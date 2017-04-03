require_relative 'utils'

class Request
  attr_accessor :channel, :categories, :country

  def initialize(channel: nil, categories: [], country: nil)
    if channel
      @channel = Channel.find_by_label(channel)
      raise ChannelNotFound.new, "no such channel" if @channel.nil?
    end

    if country
      @country = Country.find_by_label(country)
      raise CountryNotFound.new, "no such channel" if @country.nil?
    end

    @categories = categories.map {|c| Category.find_by_label(c) }.compact
  end

end
