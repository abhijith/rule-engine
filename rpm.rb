require 'set'
require 'pp'
require 'json'
require_relative 'lib/rpm'

USAGE = "usage: ruby main.rb <request.json>"
if ARGV.empty?
  puts USAGE
else
  if ARGV.length == 1
    file = ARGV.first
    if File.exists?(file)
      request = JSON.parse(File.read(file))
      begin
        puts main(request)
      rescue StandardError => e
        puts e.message
      end
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
