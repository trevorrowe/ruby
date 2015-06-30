require 'net/http'
require 'logger'

req = Net::HTTP::Put.new('/', { 'expect' => '100-continue' })
req.body = 'data'

http = Net::HTTP.new('localhost', 3000)
http.continue_timeout = 1
http.set_debug_output(Logger.new($stdout))
http.request(req)
