require 'net/http'
require 'logger'

#Net::HTTP::IDEMPOTENT_METHODS_.clear

body = "1234567890abcmnoxyzz"
req = Net::HTTP::Put.new('/', { 'content-length' => body.bytesize.to_s })
req.body_stream = StringIO.new(body)

http = Net::HTTP.new('localhost', 3000)
http.read_timeout = 1
http.set_debug_output(Logger.new($stdout))
http.request(req)
