require_relative 'initializer'

class BaseTest < Test::Unit::TestCase

  def setup
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_id
    a = Channel.new(label: "a").save
    assert_equal 0, a.id
    assert_equal [a], Channel.all
    b = Country.new(label: "b").save
    assert_equal [b], Country.all
    assert_equal 0, b.id
    c = Advert.new(label: "c").save
    assert_equal [c], Advert.all
    assert_equal 0, c.id

    db = {
      Channel => [a],
      Country => [b],
      Advert  => [c]
    }
    assert_equal db, Base.db
  end

end
