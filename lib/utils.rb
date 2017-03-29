require 'json'
require 'pp'

require_relative 'request'
require_relative 'advert'
require_relative 'channel'
require_relative 'country'
require_relative 'category'
require_relative 'expr'

class Array
  def intersect?(x)
    not (self & x).empty?
  end
end
