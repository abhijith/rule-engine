require 'date'

class Advert
  attr_accessor :id, :label, :start_date, :end_date, :limit, :views, :constraints, :limits

  @@coll    = []
  @@counter = 0

  def initialize(label: nil, limit: 10, start_date: nil, end_date: nil)
    @label       = label
    @views       = 0
    @limit       = limit
    @constraints = nil
    @limits      = []
    @start_date  = start_date
    @end_date    = end_date
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

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def self.find(id)
    @@coll[id]
  end

  def self.find_by_label(l)
    @@coll.select {|x| x.label == l }.first
  end

  def live?
    (self.start_date..self.end_date).cover?(DateTime.now)
  end

  def expired?
    not live?
  end

  def self.live
    self.all.select {|x| x.live? }
  end

  def self.expired
    self.all.select {|x| x.expired? }
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

  def fetch_limit(obj)
    type = obj.class
    self.limits.select {|l| l.type == type and l.type_id == obj.id }.first
  end

  def fetch_limits(objs)
    objs.map {|obj| self.fetch_limit(obj) }.compact
  end

  def limits_exceeded?(objs)
    self.fetch_limits(objs).map(&:exhausted?).any?
  end

  def to_h
    { label: label }
  end

  def update_limits(objs)
    self.inc_view
    self.fetch_limits(objs).each(&:inc_view)
    true
  end

end
