class Channel

  attr_accessor :name, :category, :pref, :country, :language

  def initialize(cat: nil, preference: nil)
    @category = cat
    @pref     = preference
  end

end