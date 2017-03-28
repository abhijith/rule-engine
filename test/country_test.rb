require_relative 'utils'

class CountryTest < Test::Unit::TestCase

  def setup
    @a1 = Country.new(label: "India")
    @a2 = Country.new(label: "Germany")
  end

  def teardown
    Country.destroy_all
  end

  def test_save_and_all
    assert_equal 0, Country.all.count
    @a1.save
    @a2.save
    assert_equal [@a1, @a2], Country.all
    assert_equal 2, Country.count
  end

  def test_destroy_all
    @a1.save
    @a2.save
    assert_equal 2, Country.count
    Country.destroy_all
    assert_equal 0, Country.count
  end

  def test_find
    @a2.save
    @a1.save
    assert_equal @a2, Country.find(0)
    assert_equal @a1, Country.find(1)
    assert_equal nil, Country.find(2)
  end

end
