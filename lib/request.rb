require_relative 'utils'

class Request

  attr_accessor :channel, :categories, :country

  def initialize(channel: nil, categories: [], country: nil)
    @channel    = Channel.find_by_label(channel) if channel
    @country    = Country.find_by_label(country) if country
    @categories = categories.map {|c| Category.find_by_label(c) }.compact
  end

end
