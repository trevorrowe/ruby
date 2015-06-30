require 'socket'

server = TCPServer.new('localhost', 3000)

n = 0
loop do

  socket = server.accept

  req_method, req_uri, http_version = socket.gets.split(/\s+/)

  req_headers = {}
  line = socket.gets
  until line == "\r\n"
    key, value = line.split(/:\s*/, 2)
    req_headers[key.downcase] = value
    line = socket.gets
  end

  content_length = req_headers['content-length'].to_i

  if n % 2 == 0
    puts "READING FULL BODY: #{socket.read(content_length)}"
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("\r\n")
  else
    puts "READING 1/2 BODY: #{socket.read(content_length / 2)}"
  end
  n += 1
  socket.close

end
