require 'json'
require 'pp'

require_relative 'request'
require_relative 'advert'
require_relative 'channel'
require_relative 'country'
require_relative 'category'
require_relative 'expr'
require_relative 'rpm'
require_relative 'limit'
require_relative 'exceptions'

class Array

  def intersect?(x)
    not (self & x).empty?
  end

  def subtype_of?(o)
    self.map {|x| x.subtype_of?(o) }.all?
  end

end
