require 'set'
require 'pp'
require_relative 'lib/expr'
require_relative 'lib/channel'
require_relative 'lib/advert'
require_relative 'lib/tree'

[c1, c2].each do |c|
  Advert.all.each do |a|
    puts "-" * 10
    puts expr.run(c, a)
    puts "-" * 10
  end
end
