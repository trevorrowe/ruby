require 'net/http'
require 'logger'

#Net::HTTP::IDEMPOTENT_METHODS_.clear

yielded_count = 0
bytes_yielded = 0
cl = nil

http = Net::HTTP.new('localhost', 3000)

http.read_timeout = 0.5

http.request(Net::HTTP::Get.new('/')) do |resp|

  yielded_count +=1
  if yielded_count > 1
    raise "retried, oops, didn't expect"
  end

  puts resp.code
  puts resp.to_hash.inspect
  cl = resp.to_hash['content-length'].first.to_i
  resp.read_body do |chunk|
    bytes_yielded += chunk.bytesize
    puts "CHUNK: #{chunk.inspect}"
  end

  puts 'code here'
end

if cl != bytes_yielded
  puts(bytes_yielded - cl)
end
