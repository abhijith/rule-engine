require_relative 'utils'

class AdvertTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(cat: ["cars"])
    @a2 = Advert.new(cat: ["gadgets"])
  end

  def teardown
    Advert.destroy_all
  end

  def test_to_s
  end

  def test_save_and_all
    assert_equal 0, Advert.all.count
    @a1.save
    @a2.save
    assert_equal 2, Advert.all.count
  end

  def test_find
  end

  def test_destroy_all
  end

end
