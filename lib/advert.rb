require 'date'

class Advert < Base
  attr_accessor :label, :start_date, :end_date, :limit, :views, :constraints, :limits

  def initialize(label: nil, limit: 10, start_date: nil, end_date: nil)
    @label       = label
    @views       = 0
    @limit       = limit
    @constraints = nil
    @limits      = []
    @start_date  = start_date
    @end_date    = end_date
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

  def limits=(limits)
    limits.each do |limit|
      RpmLogger.debug("associated limit #{limit.inspect} with #{self.to_h}")
      limit.ad_id = self.id
      @limits << limit
    end
  end

  def fetch_limit(obj)
    type = obj.class
    self.limits.select {|l| self.id == l.ad_id and l.type == type and l.type_id == obj.id }.first
  end

  def fetch_limits(objs)
    objs.map {|obj| self.fetch_limit(obj) }.compact
  end

  def views_exceeded?(objs)
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
