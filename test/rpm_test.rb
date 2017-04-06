require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    init_data
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def assert_ad(attrs, label, status)
    ad = Advert.find_by_label(label)
    r = Request.new(attrs)
    assert_equal ad, main(attrs)
    assert_equal status, ad.constraints.satisfied?(r) if ad
  end

  def test_main
    assert_equal 4,  Advert.count
    assert_equal 3,  Country.count
    assert_equal 2,  Channel.count
    assert_equal 10, Category.count

    assert_ad({channel: "team-bhp.com",     preferences: ["cars"], country: "sweden"  }, "volvo-s40",   true)
    assert_ad({channel: "team-bhp.com",     preferences: ["bmw"],  country: "germany" }, "bmw-i8",      true)
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "india"   }, "master-chef", true)
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "germany" }, "master-chef", true)
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "sweden"  }, "master-chef", true)
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "sweden"  }, "air-berlin",  true)
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "germany" }, "air-berlin",  true)
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "india"   }, "spurious",    false)
  end

end
