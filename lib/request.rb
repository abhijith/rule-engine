require_relative 'utils'

class Request

  attr_accessor :channel, :categories, :country

  def initialize(channel: nil, categories: [], country: nil)
    @channel    = Channel.find_by_label(channel)
    @categories = categories.map {|c| Category.find_by_label(c) }.compact
    @country    = Country.find_by_label(country)
  end

  def category
    self.categories
  end

end
