require_relative 'utils'

class AdvertTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(label: "nokia")
    @a2 = Advert.new(label: "airbnb")

    india   = Country.new(label: "india").save
    germany = Country.new(label: "germany").save

    l1 = Limit.new(germany, 2)
    l2 = Limit.new(india, 2)
    @a1.limits = [l1, l2]
  end

  def teardown
    Advert.destroy_all
    Channel.destroy_all
    Country.destroy_all
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

  def test_find_by_label
    @a2.save
    @a1.save
    assert_equal @a2, Advert.find_by_label("airbnb")
    assert_equal @a1, Advert.find_by_label("nokia")
  end

  def test_live?
    @a1.start_date = DateTime.now - 1000
    @a1.end_date   = DateTime.now + 1000
    assert_equal true, @a1.live?
    assert_equal false, @a1.expired?
    assert_equal true, @a2.expired?
  end

  def test_live
    @a1.start_date = DateTime.now - 1000
    @a1.end_date   = DateTime.now + 1000
    @a1.save
    @a2.save
    assert_equal 1, Advert.live.count
  end

  def test_exhausted?
    assert_equal false, @a1.exhausted?
  end

  def test_limits
    r1 = {
      channel: "car-example.com",
      categories: ["cars"],
      country: "germany"
    }

    assert_equal false, @a1.views_exhausted?(Request.new(r1))
    @a1.fetch_limits(Request.new(r1)).each(&:inc_view)
    @a1.fetch_limits(Request.new(r1)).each(&:inc_view)
    assert_equal true, @a1.views_exhausted?(Request.new(r1))
  end


end
