require 'webrick'
require 'optparse'

opt = ARGV.getopts('p:', 'port:')


port = opt['p'] || opt['port'] || 5000
$stderr.puts "served in #{port}"
s = WEBrick::HTTPServer.new(:Port => port, :DocumentRoot => File.join(Dir::pwd, "build"))
trap("INT"){ s.shutdown }
s.start

