require 'date'

class Advert < Base
  include Limited

  attr_accessor :label, :start_date, :end_date, :constraints, :limits

  def initialize(label: nil, limit: 10, start_date: nil, end_date: nil)
    @label       = label
    @views       = 0
    @limit       = limit
    @constraints = nil
    @start_date  = start_date
    @end_date    = end_date
  end

  def live?
    (self.start_date..self.end_date).cover?(DateTime.now)
  end

  def expired?
    not self.live?
  end

  def self.live
    self.all.select {|x| x.live? }
  end

  def self.expired
    self.all.select {|x| x.expired? }
  end

  def limits
    Limit.all.select {|l| l.ad_id == self.id }
  end

  def limits=(limits)
    limits.each do |limit|
      RpmLogger.debug("associated limit #{limit.inspect} with #{self.to_h}")
      limit.ad_id = self.id
    end
  end

  def fetch_limit(obj)
    self.limits.select {|l| l.type == obj.class and l.type_id == obj.id }.first
  end

  def fetch_limits(objs)
    objs.map {|obj| self.fetch_limit(obj) }.compact
  end

  def views_exceeded?(objs)
    self.fetch_limits(objs).map(&:exhausted?).any?
  end

  def to_h
    {
      id:    id,
      label: label,
      views: views,
      limit: limit,
      start_date: start_date,
      end_date: end_date,
      constraints: constraints.to_h,
      limits: limits.map(&:to_h)
    }
  end

  def update_views(objs)
    self.inc_view
    self.fetch_limits(objs).each(&:inc_view)
    true
  end

end
