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
      request = JSON.parse(File.read(file), symbolize_names: true)
      rule    = JSON.parse(File.read("data/rule.json"), symbolize_names: true)
      e  = ExprGroup.load(rule)
      c1 = Channel.new(request)
    # p main(c1, expr5)
      #rescue StandardError => e
        #puts e.message
        #puts e.backtrace
      #end
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
