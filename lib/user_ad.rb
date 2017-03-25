class UserAd

  attr_accessor :user_id, :advert_id, :views

  @@coll = []

  def initialize(uid, aid)
    @user_id   = uid
    @advert_id = aid
    @views     = 0
  end

  def save
    @@coll << self
  end

  def self.all
    @@coll
  end

  def self.find
    @@coll.find {|x| }
  end

  def self.destroy_all
    @@coll = []
  end

end
