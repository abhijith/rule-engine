class Channel

  attr_accessor :name, :category, :preferences, :country, :language, :username

  def initialize(category: nil, preferences: nil, country: nil, language: nil, username: nil)
    @category    = category
    @preferences = preferences
  end

end
