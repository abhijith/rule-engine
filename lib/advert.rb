require 'date'

class Advert
  attr_accessor :id, :label, :start_date, :end_date, :limit, :views, :constraints

  @@coll    = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
    @views = 0
    @limit = 10

    @start_date = DateTime.now
    @end_date   = DateTime.now + (60 * 60 * 24)

    @constraints = nil
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

  def views_exhausted?(request)
    find(self.id, request.country.id)
  end

  # def inc_view(request)
  #   views = view.succ
  #   [:country, :channel].each do |type|
  #     Limit.find(ltype: type, ltype_id: request.send(type).id, advert_id: self.id)
  #   end
  # end

  def incr_view
    p [@views, views]
    views = views + 1
  end

  def inc_country_view(request)
    CountryLimit.find(self.id, request.country).inc_view
  end

  def inc_channel_view(request)
    ChannelLimit.find(self.id, request.channel).inc_view
  end

  # make this polymorphic
  def country_limits(country)
    CountryLimit.all.select {|x| x.advert_id == self.id and x.country_id == country.id }
  end

  def channel_limits(channel)
    ChannelLimit.all.select {|x| x.advert_id == self.id and x.channel_id == channel.id }
  end

  def set_country_limit(country, limit)
    CountryLimit.new(advert_id: self.id, country_id: country.id, limit: limit).save
  end

  def set_channel_limit(channel, limit)
    ChannelLimit.new(advert_id: self.id, channel_id: channel.id, limit: limit).save
  end

end
