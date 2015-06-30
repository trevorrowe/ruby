require 'socket'

server = TCPServer.new('localhost', 3000)

n = 0
loop do

  socket = server.accept
  puts socket.gets

  body = "1234567890"

  resp_headers = []
  resp_headers << "HTTP/1.1 200 OK\r\n"
  resp_headers << "Content-Type: text/plain\r\n"
  resp_headers << "Content-Length: #{body.bytesize}\r\n"
  resp_headers << "Connection: close\r\n"
  resp_headers << "\r\n"

  socket.print(resp_headers.join)

  socket.print(body[0...5])
  sleep(n % 2)
  socket.print(body[5..-1])
  socket.close
  n += 1

end
