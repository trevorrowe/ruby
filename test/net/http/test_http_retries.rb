# coding: US-ASCII
require 'test/unit'
require 'net/http'
require 'stringio'

require 'socket'
require 'struct'

class TestNetHTTPIdempotentRetries < Test::Unit::TestCase

  class SimpleHttpServer

    def start(&block)
      @socket = TCPServer.new('127.0.0.1', 3000).accept
    end

    def respond(&block)
      http_method, request_uri, _ = @socket.gets.split(/\s+/)
      yield(http_method, request_uri, request_headers, @socket)
      @socket.close
    end

    def stop
      @socket.close
    end

    private

    def request_headers
      headers = {}
      line = @socket.gets
      until line == "\r\n"
        key, value = line.split(/:\s*/, 2)
        headers[key.downcase] = value
        line = @socket.gets
      end
      headers
    end

  end

  def test_put_rewinds_body_stream
    server = SimpleHttpServer.new
    start do |http|
      body = StringIO.new('body')
      req = Net::HTTP::Put.new('/', 'content-length' => body.size.to_s )
      req.body_stream = body
      res = http.request(req)
    end
  end

  def test_get_yields_once
  end
end
