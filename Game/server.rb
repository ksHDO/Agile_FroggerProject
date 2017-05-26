require "socket"

# Server needs to minimize sending data between clients
# Send frog positions to everyone every x defined seconds
#
# LATER: Send Truck Send Lane, Type, Direction
#
#
#
#

$serverIp = "localhost"
$serverPort = 65509

class Server
  def initialize(ip, port)
    @server = TCPServer.open(ip, port)
    @connections = Hash.new
    @rooms = Hash.new
    @clients = Hash.new
    @connections[:server] = @server
    @connections[:rooms] = @rooms
    @connections[:clients] = @clients
    @clientId = 0
    server_update
  end

  def server_update
    loop {
      Thread.start(@server.accept) do |client|
        # @connections[:clients].each do |other_name, other_client|
        #   if nick_name == other_name || client == other_client
        #     client.puts "That username already exists."
        #     Thread.kill self
        #   end
        # end
        # puts "#{nick_name} #{client}"
        id = @clientId
        @clientid = @clientId + 1
        @connections[:clients][id] = client
        puts "got someone"
        # client.puts "Connection has been established"
        get_and_send_data(id, client)
      end
    }.join

  end

  def get_and_send_position(id, client)
    loop {
      # puts 'waiting for pos'
      x = client.gets.chomp
      y = client.gets.chomp
      puts 'receive <' + x.to_s + ',' + y.to_s + '>'
      sendToAll(id, x, y)
    }
    end


  def get_and_send_data(id, client)
    loop {
      size = client.gets.chomp
      data = client.read(size.to_i)
      puts data
      puts "---------"
      send_to_all(id, size,data)
    }
  end

  def sendToAll(fromId, x, y)
    @connections[:clients].each do |id, other_client|
      other_client.puts x
      other_client.puts y
    end
  end

  def send_to_all(fromId, size, params)
    @connections[:clients].each do |id, other_client|
      other_client.puts size
      other_client.puts params
    end
  end

end

server = Server.new($serverIp, $serverPort)
server.run