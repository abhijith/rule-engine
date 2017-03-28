require 'json'

class Request

  attr_accessor :channel, :categories, :country

  def initialize(channel: nil, categories: nil, country: nil)
    @channel   = channel
    @categoies = categories
  end

  def self.load(file)
    Request.new(JSON.parse(File.read(file), symbolize_names: true))
  end

end
