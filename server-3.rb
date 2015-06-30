# This example server accepts a simple PUT request with the 'Excpect: 100-continue'
# header. It alternates between the following two responses:
#
# * 100 Continue, accepting the body, then 200 OK
# * 403 Forbidden, not accepting the body
#

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
    socket.print("HTTP/1.1 100 Continue\r\n")
    socket.print("\r\n")
    socket.read(content_length)
    socket.print("HTTP/1.1 200 OK\r\n")
    socket.print("\r\n")
  else
    socket.print("HTTP/1.1 403 Forbidden\r\n")
    socket.print("\r\n")
  end

  n += 1
  socket.close

end
