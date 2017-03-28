class Advert
  attr_accessor :id, :label, :start_date, :end_date, :country, :language, :limit

  @@coll    = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
    @limit = nil
  end

  def self.load(file)
    JSON.parse(File.read(file), symbolize_names: true)
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

  def live?
  end

  def expired?
    not live?
  end

  def self.live
  end

  def exhausted?
  end

end
