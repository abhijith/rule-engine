require_relative 'utils'

class Request

  attr_accessor :channel, :categories, :country

  def initialize(channel: nil, categories: nil, country: nil)
    p [channel, country, categories]
    @channel    = Channel.find_by_label(channel).id
    @categories = categories.map {|c| Category.find_by_label(c) }.compact.map(&:id)
    @country    = Country.find_by_label(country).id
  end

  def self.load(file)
    Request.new(JSON.parse(File.read(file), symbolize_names: true))
  end

end
