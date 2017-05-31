require "socket"
require "yaml"

class Client
  def initialize( ip, port )
    @server = TCPSocket.open(ip, port)
    @response = nil
  end

  def disconnect
    @server.close
  end

  def get_pos_from_server
    return @server.gets.chomp
  end

  def get_server
    size = @server.gets.chomp
    data = @server.read(size.to_i)
    return YAML.load data
  end

  def sendData(data)
    j = data.to_yaml(line_width: -1)
    @server.puts j.bytesize
    @server.print j
  end
end

module ServerClient
  def initialize_client
    begin
      @client = Client.new($serverIp, $serverPort)
    rescue => ex
      puts "Could not connect to server, running locally"
    end
  end
end

module ServerListener
  include ServerClient

  def initialize_listener
    initialize_client
    listen_to_server
  end
end

module ServerSender
  include ServerClient

  def initialize_sender
    initialize_client
    @frame_to_send_on = 2
    @current_frame_to_send = 0
  end

  def ready_to_send
    @current_frame_to_send += 1
    if @current_frame_to_send >= @frame_to_send_on
      @current_frame_to_send = 0
      true
    end
    false
  end
end