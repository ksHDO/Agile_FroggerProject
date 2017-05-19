require "socket"

$commands = [
    "pm"
]

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
        listen_user_messages( nick_name, client )
      end
    }.join
  end

  def listen_user_messages( username, client )
    loop {
      msg = client.gets.chomp
      if (msg[0] == '.')
        msg[0] = ''
        puts "hello"
        parse_command(username, client, msg)
      else
        sendToAll "[#{Time.now.ctime}] #{username.to_s}: #{msg}"
      end
    }
  end

  def parse_command(username, client, msg)
    com = msg.split(' ')[0]
    msg.slice! "#{com} "
    could_parse = false
    $commands.each do |command|
      puts "command: #{command}"
      if (command == com)
        toUser = msg.split(' ')[0]
        msg.slice! "#{toUser} "
        msg = "[#{Time.now.ctime}] PM #{username.to_s}: #{msg}"
        sendToUser(toUser, msg)
        client.puts msg
        could_parse = true
      end
    end
    if (!could_parse)
      client.puts "Could not parse command"
    end
  end

  def get_all_clients()

  end

  def sendToAll(msg)
    @connections[:clients].each do |other_name, other_client|
      other_client.puts "#{msg}"
    end
  end

  def sendToUser(user, msg)
    @connections[:clients].each do |other_name, other_client|
      puts "from '#{user}' to '#{other_name}' with '#{msg}' ?"
      if user.to_s == other_name.to_s
        other_client.puts "#{msg}"
      end
    end
  end
end

server = Server.new("192.168.1.8", 65509)
server.run