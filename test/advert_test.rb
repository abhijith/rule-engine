require_relative 'utils'

class AdvertTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(label: "nokia")
    @a2 = Advert.new(label: "airbnb")
  end

  def teardown
    Advert.destroy_all
  end

  def test_save_and_all
    assert_equal 0, Advert.all.count
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

end
