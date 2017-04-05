require 'json'
require 'pp'
require 'logger'

require_relative 'request'
require_relative 'advert'
require_relative 'channel'
require_relative 'country'
require_relative 'category'
require_relative 'expr'
require_relative 'rpm'
require_relative 'limit'
require_relative 'exceptions'
require_relative 'data'

class Array

  def intersect?(x)
    not (self & x).empty?
  end

end

log = File.absolute_path(File.dirname(__FILE__)) + "/../pineapple.log"
RpmLogger = Logger.new(log)
RpmLogger.level = ENV["LOG_LEVEL"] || Logger::INFO
