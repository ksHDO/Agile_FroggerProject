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

  # def get
  #   return @server.gets.chomp
  # end

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