require 'json'

class Request

  attr_accessor :name, :category, :preferences, :country, :language, :username

  def initialize(category: nil, preferences: nil, country: nil, language: nil, username: nil)
    @category    = category
    @preferences = preferences
  end

  def self.load(file)
    Request.new(JSON.parse(File.read(file), symbolize_names: true))
  end

end