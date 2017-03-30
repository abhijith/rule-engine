class ChannelLimit
  attr_accessor :advert_id, :channel_id, :limit, :views

  @@coll    = []
  @@counter = 0

  def initialize(advert_id: nil, channel_id: nil, limit: nil)
    @views      = 0
    @limit      = limit
    @advert_id  = advert_id
    @channel_id = channel_id
  end

  def self.count
    @@counter
  end

  def save
    @@coll << self
    @@counter = @@counter + 1
    self
  end

  def self.all
    @@coll
  end

  def self.find(advert_id, channel_id)
    @@coll.select {|x| x.advert_id == advert_id and x.channel_id == channel_id }
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def inc_view
    views = views.succ
  end

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

  def advert
    Advert.find(self.advert_id)
  end

  def channel
    Channel.find(self.channel_id)
  end

end
