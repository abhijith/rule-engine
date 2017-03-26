class Channel

  attr_accessor :name, :category, :pref, :country, :language, :username

  def initialize(cat: nil, preference: nil, country: nil, language: nil, username: nil)
    @category = cat
    @pref     = preference
  end

end
