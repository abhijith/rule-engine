require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    init_data
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_main
    assert_equal 4,  Advert.count
    assert_equal 3,  Country.count
    assert_equal 2,  Channel.count
    assert_equal 10, Category.count

    ad = Advert.find_by_label("volvo-s40")
    r = Request.new(channel: "team-bhp.com", preferences: ["cars"], country: "sweden")
    assert_equal ad, main({channel: "team-bhp.com", preferences: ["cars"], country: "sweden"})
    assert_equal true, ad.constraints.satisfies?(r)

    ad = Advert.find_by_label("bmw-i8")
    r = Request.new(channel: "team-bhp.com", preferences: ["bmw"], country: "germany")
    assert_equal ad, main({channel: "team-bhp.com", preferences: ["bmw"], country: "germany"})
    assert_equal true, ad.constraints.satisfies?(r)

    ad = Advert.find_by_label("master-chef")
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "india")
    assert_equal ad, main({channel: "trip-advisor.com", preferences: ["food"], country: "india"})
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "germany")
    assert_equal ad, main({channel: "trip-advisor.com", preferences: ["food"], country: "germany"})
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "sweden")
    assert_equal ad, main({channel: "trip-advisor.com", preferences: ["food"], country: "sweden"})
    assert_equal true, ad.constraints.satisfies?(r)


    ad = Advert.find_by_label("air-berlin")
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "sweden")
    assert_equal ad, main({channel: "trip-advisor.com", preferences: ["cars"], country: "sweden"})
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "germany")
    assert_equal ad, main({channel: "trip-advisor.com", preferences: ["cars"], country: "germany"})
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "india")
    assert_equal nil, main({channel: "trip-advisor.com", preferences: ["cars"], country: "india"})
    assert_equal false, ad.constraints.satisfies?(r)
  end

end
