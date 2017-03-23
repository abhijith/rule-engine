class Request

  attr_accessor :name, :category, :preferences

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
