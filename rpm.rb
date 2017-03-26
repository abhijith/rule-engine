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
        expr1 = Expr.new(ch: :category, ad: :category, op: :==)
        expr2 = Expr.new(ch: :pref, ad: :category, op: :intersect?)
        expr3 = Expr.new(ch: :language, ad: :language, op: :==)
        expr4 = ExprGroup.new(:any?, [expr1, expr2])
        expr5 = ExprGroup.new(:all?, [expr1, expr4])
        expr6 = ExprGroup.new(:any?, [expr1, expr4])

        a1 = Advert.new(cat: ["cars"])
        a1.language = "english"
        a1.save

        a2 = Advert.new(cat: ["gadgets"])
        a2.language = "german"
        a2.save

        a3 = Advert.new(cat: ["cooking"])
        a3.language = "german"
        a3.save

        c1 = Channel.new(cat: ["cars"], preference: ["cars", "gadgets"])
        c1.language = "english"

        c2 = Channel.new(cat: ["cooking"], preference: ["food"])
        c2.language = "german"

        # initialize rule
        # rule = JSON.parse(File.read("rule.json"))
        # initialize ads
        # ads  = JSON.parse(File.read("ads.json"))

        p main(request, expr6)
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
