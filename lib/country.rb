class Country
  attr_accessor :id, :label

  @@coll = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
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

  # comparators
  def ==(o)
    self.label == o.label
  end

end
