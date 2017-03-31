require 'date'

class Advert
  attr_accessor :id, :label, :start_date, :end_date, :limit, :views, :constraints, :limits

  @@coll    = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
    @views = 0
    @limit = 10

    # @start_date = DateTime.now
    # @end_date   = DateTime.now + (60 * 60 * 24)

    @constraints = nil
    @limits = []
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

  def live?
    (self.start_date..self.end_date).cover?(DateTime.now)
  end

  def expired?
    not live?
  end

  def self.live
    self.all.select {|x| x.live? and (not exhausted?) }
  end

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

  def inc_view
    @views = @views + 1
  end

  def fetch_limit(request, type)
    self.limits.select {|x| x.type.to_s == type.to_s.capitalize and request.send(type) }.first
  end

  def fetch_limits(request)
    [:channel, :country].map do |type|
      fetch_limit(request, type)
    end.compact
  end

  def views_exhausted?(request)
    fetch_limits(request).map(&:exhausted?).any?
  end

end
