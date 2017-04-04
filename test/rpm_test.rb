require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    init_data
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def assert_ad(attrs, ad, status)
    r = Request.new(attrs)
    assert_equal ad, main(attrs)
    assert_equal status, ad.constraints.satisfies?(r) if ad
  end

  def test_main
    assert_equal 4,  Advert.count
    assert_equal 3,  Country.count
    assert_equal 2,  Channel.count
    assert_equal 10, Category.count

    ad = Advert.find_by_label("volvo-s40")
    assert_ad({channel: "team-bhp.com", preferences: ["cars"], country: "sweden"}, ad, true)

    ad = Advert.find_by_label("bmw-i8")
    assert_ad({channel: "team-bhp.com", preferences: ["bmw"], country: "germany"}, ad, true)

    ad = Advert.find_by_label("master-chef")
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "india"}, ad, true)
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "germany"}, ad, true)
    assert_ad({channel: "trip-advisor.com", preferences: ["food"], country: "sweden"}, ad, true)

    ad = Advert.find_by_label("air-berlin")
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "sweden"}, ad, true)
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "germany"}, ad, true)
    assert_ad({channel: "trip-advisor.com", preferences: ["cars"], country: "india"}, nil, false)
  end

end
