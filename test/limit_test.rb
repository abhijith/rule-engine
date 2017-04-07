require_relative 'initializer'

class LimitTest < Test::Unit::TestCase

  def setup
    @india = Country.new(label: "india").save
    @food  = Channel.new(label: "food-example.com").save

    @l1 = Limit.new(@india, 2)
    @l2 = Limit.new(@food, 2)
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_id
    @l1.save
    @l2.save
    assert_equal 0, @l1.id
    assert_equal 1, @l2.id
  end

  def test_save_all_and_count
    assert_equal 0, Limit.count
    @l1.save
    @l2.save
    assert_equal [@l1, @l2], Limit.all
    assert_equal 2, Limit.count

    assert_equal @india.class, @l1.type
    assert_equal @food.class,  @l2.type
    assert_equal @india.id,    @l1.type_id
    assert_equal @food.id,     @l2.type_id
  end

  def test_destroy_all
    @l1.save
    @l2.save
    assert_equal 2, Limit.count
    Limit.destroy_all
    assert_equal 0, Limit.count
  end

  def test_find
    @l2.save
    @l1.save
    assert_equal @l2, Limit.find(0)
    assert_equal @l1, Limit.find(1)
  end

  def test_inc_view_and_exhausted?
    assert_equal false, @l1.exhausted?
    @l1.inc_view
    @l1.inc_view
    assert_equal true, @l1.exhausted?
  end

  def test_type_instance
    assert_equal @india, @l1.type_instance
  end

end
