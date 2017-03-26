require 'set'
require 'pp'
require 'json'
require_relative 'lib/expr'
require_relative 'lib/channel'
require_relative 'lib/advert'
require_relative 'lib/tree'

USAGE = "usage: ruby main.rb <request.json>"
if ARGV.empty?
  puts USAGE
else
  if ARGV.length == 1
    file = ARGV.first
    if File.exists?(file)
      buff = JSON.parse(File.read(file))
      begin
        puts main(buff)
      rescue Note::PreRequisiteMissing => e
        puts e.message
      end
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
