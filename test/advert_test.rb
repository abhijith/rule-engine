require_relative 'utils'

class AdvertTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(label: "nokia")
    @a2 = Advert.new(label: "airbnb")

    @india   = Country.new(label: "india").save
    @germany = Country.new(label: "germany").save
    @food = Channel.new(label: "food-example.com").save

    @l1 = Limit.new(@germany, 2).save
    @l2 = Limit.new(@food, 1).save
    @l3 = Limit.new(@germany, 2).save
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_save_all_and_count
    @a1.save
    @a2.save
    assert_equal [@a1, @a2], Advert.all
  end

  def test_id
    @a1.save
    @a2.save
    assert_equal 0, @a1.id
    assert_equal 1, @a2.id
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

  def test_find_by_label
    @a2.save
    @a1.save
    assert_equal @a2, Advert.find_by_label("airbnb")
    assert_equal @a1, Advert.find_by_label("nokia")
  end

  def test_live_and_expired?
    @a1.start_date = DateTime.now - 1
    @a1.end_date   = DateTime.now + 1
    assert_equal true, @a1.live?
    assert_equal false, @a1.expired?
    assert_equal true, @a2.expired?
  end

  def test_live
    @a1.start_date = DateTime.now - 1
    @a1.end_date   = DateTime.now + 1
    @a1.save
    @a2.save
    assert_equal 1, Advert.live.count
  end

  def test_expired
    @a1.start_date = DateTime.now - 2
    @a1.end_date   = DateTime.now - 1
    @a1.save
    @a2.save
    assert_equal 2, Advert.expired.count
  end

  def test_exhausted?
    assert_equal false, @a1.exhausted?
  end

  def test_inc_view
    assert_equal 0, @a1.views
    @a1.inc_view
    assert_equal 1, @a1.views
  end

  def test_limits=
    @a1.save
    @a1.limits = [@l1, @l2]
    assert_equal [@l1, @l2].map(&:ad_id), @a1.limits.map(&:ad_id)
  end

  def test_fetch_limit
    @a1.save
    @a1.limits = [@l1, @l2]
    assert_equal @l1, @a1.fetch_limit(@germany)
  end

  def test_fetch_limits
    @a1.save
    @a1.limits = [@l1, @l2]
    assert_equal [@l1, @l2], @a1.fetch_limits([@germany, @food])
  end

  def test_limits
    @a1.save
    @a1.save
    @a1.limits = [@l1, @l2]

    assert_equal false, @a1.limits_exceeded?([@germany, @food])
    assert_equal @germany.id,    @l1.type_id
    assert_equal @food.id,       @l2.type_id
    assert_equal @germany.class, @l1.type
    assert_equal @food.class,    @l2.type
  end

  def test_update_limits
    @a1.save
    @a2.save

    @a1.limits = [@l1, @l2]
    @a2.limits = [@l3]

    assert_equal false, @a1.limits_exceeded?([@germany])
    assert_equal false, @a2.limits_exceeded?([@germany])
    assert_equal false, @a1.limits_exceeded?([@food])

    @a1.update_limits([@germany])
    @a2.update_limits([@germany])
    @a1.update_limits([@food])

    assert_equal false, @a1.limits_exceeded?([@germany])
    assert_equal false, @a2.limits_exceeded?([@germany])
    assert_equal true,  @a1.limits_exceeded?([@food])

    @a1.update_limits([@germany])
    @a2.update_limits([@germany])

    assert_equal true, @a1.limits_exceeded?([@germany])
    assert_equal true, @a2.limits_exceeded?([@germany])
    assert_equal true, @a1.limits_exceeded?([@germany, @food])

    assert_equal 3, @a1.views
    assert_equal 2, @l1.views
    assert_equal 1, @l2.views
    assert_equal 2, @l3.views
  end

end
