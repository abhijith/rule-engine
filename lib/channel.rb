class Channel

  attr_accessor :label, :categories, :country

  @@coll = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
  end

  def self.load(file)
    coll = JSON.parse(File.read(file), symbolize_names: true)
  end

  def self.parse(coll)
    coll.map {|h| self.new(h).save }
  end

  def to_s
  end

  def self.count
    @@counter
  end

  def save
    @@counter = @@counter + 1
    @@coll << self
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

end
