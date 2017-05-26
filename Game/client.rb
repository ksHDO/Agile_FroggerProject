require "socket"
require "yaml"

class Client
  def initialize( ip, port )
    @server = TCPSocket.open(ip, port)
    # @request = nil
    @response = nil
    # listen
    # @request.join
    # @response.join
  end

  def disconnect
    @server.close
  end

  def get_pos_from_server
    return @server.gets.chomp
  end

  def get_server()
    size = @server.gets.chomp
    data = @server.read(size.to_i)
    puts data
    return YAML.load data
  end

  def listen
    # @response = Thread.new do
    #   loop {
    #     msg = @server.gets.chomp
    #     puts "#{msg}"
    #   }
    # end
  end

  def sendInput(x, y)
    @server.puts x
    @server.puts y
    # puts 'sent <' + x.to_s + ',' + y.to_s + '>'
  end

  def sendData(data)
    j = data.to_yaml(line_width: -1)
    # j.delete! "\n"
    # puts j
    # puts "--------"
    @server.puts j.bytesize
    @server.print j
  end
end
