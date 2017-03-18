class Channel

  attr_accessor :name

  @@coll = []

  def initialize
  end

  def to_s
  end

  def save
    @@coll << self
  end

  def self.all
    @@coll
  end

  def self.find
    @@coll.find {|x| }
  end

  def self.destroy_all
    @@coll = []
  end

end
