require_relative 'lib/utils'
require_relative 'lib/rpm'

USAGE = "usage: ruby main.rb <request.json>"
if ARGV.empty?
  puts USAGE
else
  if ARGV.length == 1
    file = ARGV.first
    if File.exists?(file)
      request = Channel.load(file)
      expr    = ExprGroup.load("data/rule.json")
      ads     = Advert.load("data/ads.json")

      p Advert.all
      main(request, expr)
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end
