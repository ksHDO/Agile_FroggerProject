require "socket"

$commands = ['commands', 'pm', 'users']

class Server
  def initialize(ip, port)
    @server = TCPServer.open( ip, port )
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    run
  end

  def run
    loop {
      Thread.start(@server.accept) do | client |
        nick_name = client.gets.chomp.to_sym
        @connections[:clients].each do |other_name, other_client|
          if nick_name == other_name || client == other_client
            client.puts "That username already exists."
            Thread.kill self
          end
        end
        puts "#{nick_name} #{client}"
        @connections[:clients][nick_name] = client
        client.puts "Connection has been established"
        sendToAll "[#{Time.now.ctime}] #{nick_name} has joined"
        client.puts "Current users: #{get_all_clients}"
        client.puts "Enter '.commands' for a list of commands"
        listen_user_messages( nick_name, client )
      end
    }.join
  end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      puts "[#{username}]: #{msg}"
      if (msg[0] == '.')
        msg[0] = ''
        parse_command(username, client, msg)
      else
        sendToAll "[#{Time.now.ctime}] #{username.to_s}: #{msg}"
      end
    }
  end

  def parse_command(username, client, msg)
    com = msg.split(' ')[0]
    msg.slice! "#{com} "
    if $commands.include? com
      if $commands[0] == com.to_s
        client.puts "Commands (prepend with '.'): #{$commands.join(', ')}"
      elsif $commands[1] == com.to_s
        toUser = msg.split(' ')[0]
        msg.slice! "#{toUser} "
        msg = "[#{Time.now.ctime}] PM #{username.to_s}: #{msg}"
        if (!sendToUser(toUser, msg))
          msg = "Usage: .pm <user> <msg>"
        end
        client.puts msg
      elsif $commands[2] == com.to_s
        client.puts "Current users: #{get_all_clients}"
      end
    else
      client.puts "Could not parse command"
    end
  end

  def get_all_clients()
    return @connections[:clients].map{|name, client| "#{name}"}.join(', ')
  end

  def sendToAll(msg)
    @connections[:clients].each do |other_name, other_client|
      other_client.puts "#{msg}"
    end
  end

  def sendToUser(user, msg)
    @connections[:clients].each do |other_name, other_client|
      if user.to_s == other_name.to_s
        other_client.puts "#{msg}"
        return true
      end
    end
    return false
  end
end

server = Server.new("10.10.26.18", 65509)
server.run