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
      ads     = JSON.parse(File.read("data/ads.json"), symbolize_names: true)

      e   = ExprGroup.load(rule)
      c1  = Channel.new(request)
      Advert.load(ads)
      p Advert.all
      main(c1, e)
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
