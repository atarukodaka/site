require 'webrick'

port = 5000
s = WEBrick::HTTPServer.new(:Port => 5000, :DocumentRoot => File.join(Dir::pwd, "build"))
trap("INT"){ s.shutdown }
s.start

