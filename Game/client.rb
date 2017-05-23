require "socket"

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

  def get_server
    return @server.gets.chomp
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
end
