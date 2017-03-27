class Channel

  attr_accessor :name, :category, :language

  @@coll = []
  @@counter = 0

  def initialize(category: nil, language: nil)
    @category = category
  end

  def self.load(file)
    coll = JSON.parse(File.read(file), symbolize_names: true)
    coll.map {|h| Channel.new(h).save }
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
    @@coll = []
  end

end
