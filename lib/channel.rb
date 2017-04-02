class Channel
  attr_accessor :id, :label, :categories

  @@coll    = []
  @@counter = 0

  def initialize(label: nil)
    @label      = label
    @categories = []
  end

  def self.load(file)
    coll = JSON.parse(File.read(file), symbolize_names: true)
  end

  def self.parse(coll)
    coll.map {|h| self.new(h).save }
  end

  def self.count
    @@counter
  end

  def save
    self.id = @@counter
    @@coll << self
    @@counter = @@counter + 1
    self
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.find_by_label(l)
    @@coll.select {|x| x.label == l }.first
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def ==(o)
    self.label == o.label
  end

end
