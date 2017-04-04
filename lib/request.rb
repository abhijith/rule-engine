require_relative 'utils'

class Request
  attr_accessor :channel, :categories, :country, :preferences

  def initialize(channel: nil, preferences: [], country: nil)
    if channel
      @channel = Channel.find_by_label(channel)
      raise ChannelNotFound.new, "no such channel" if @channel.nil?
      @categories = @channel.categories
    end

    if country
      @country = Country.find_by_label(country)
      raise CountryNotFound.new, "no such channel" if @country.nil?
    end

    @preferences  = preferences.map {|c| Category.find_by_label(c) }.compact
  end

end
