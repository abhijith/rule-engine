require_relative 'utils'

class AdvertTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(label: "nokia")
    @a2 = Advert.new(label: "airbnb")
  end

  def teardown
    Advert.destroy_all
  end

  def test_id
    @a1.save
    @a2.save
    assert_equal 0, @a1.id
    assert_equal 1, @a2.id
  end

  def test_save_all_and_count
    assert_equal 0, Advert.count
    @a1.save
    @a2.save
    assert_equal [@a1, @a2], Advert.all
    assert_equal 2, Advert.count
  end

  def test_destroy_all
    @a1.save
    @a2.save
    assert_equal 2, Advert.count
    Advert.destroy_all
    assert_equal 0, Advert.count
  end

  def test_find
    @a2.save
    @a1.save
    assert_equal @a2, Advert.find(0)
    assert_equal @a1, Advert.find(1)
  end

  def test_exhausted?
    assert_equal false, @a1.exhausted?
  end

  def test_country_limit
    @c1 = Country.new(label: "India")
    @c1.save
    @a1.save
    @a1.set_country_limit(@c1, 10)
    assert_equal 1,   CountryLimit.count
    assert_equal @c1, CountryLimit.all[0].country
    assert_equal @a1, CountryLimit.all[0].advert
  end

  def test_channel_limit
    @c1 = Channel.new(label: "reddit")
    @c1.save
    @a1.save
    @a1.set_channel_limit(@c1, 10)
    assert_equal 1,   ChannelLimit.count
    assert_equal @c1, ChannelLimit.all[0].channel
    assert_equal @a1, ChannelLimit.all[0].advert
  end


end
