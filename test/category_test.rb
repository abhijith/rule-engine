require_relative 'initializer'

class CategoryTest < Test::Unit::TestCase

  def setup
    @root    = Category.new(label: :root)
    @cars    = Category.new(label: :cars)
    @bmw     = Category.new(label: :bmw)
    @audi    = Category.new(label: :audi)
    @cuisine = Category.new(label: :cuisine)
    @chinese = Category.new(label: :chinese)
    @indian  = Category.new(label: :indian)
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_id
    @cars.save
    @bmw.save
    assert_equal 0, @cars.id
    assert_equal 1, @bmw.id
  end

  def test_save_all_and_count
    assert_equal 0, Category.count
    @cars.save
    @cuisine.save
    assert_equal [@cars, @cuisine], Category.all
    assert_equal 2, Category.count
  end

  def test_destroy_all
    @cars.save
    @cuisine.save
    assert_equal 2, Category.count
    Category.destroy_all
    assert_equal 0, Category.count
  end

  def test_find
    @cars.save
    @bmw.save
    assert_equal @cars, Category.find(0)
    assert_equal @bmw, Category.find(1)
    assert_equal nil, Category.find(2)
  end

  def test_parent
    @cars.save
    @bmw.save
    @audi.save

    @cars.add_child(@bmw)
    @audi.parent = @cars
    assert_equal @cars, @bmw.parent
    assert_equal @cars, @audi.parent
    assert_equal @cars.children, [@bmw, @audi]
  end

  def setup_descendants
    [@root, @cars, @bmw, @chinese, @audi, @cuisine, @indian].map(&:save)
    assert_equal [], @cars.descendants

    @root.add_child(@cars)
    @root.add_child(@cuisine)

    @cars.add_child(@bmw)
    @cars.add_child(@audi)

    @cuisine.add_child(@chinese)
    @cuisine.add_child(@indian)
  end

  def test_descendants
    setup_descendants
    assert_equal [:bmw, :audi], @cars.descendants.map(&:label)
    assert_equal [:cars, :bmw, :audi, :cuisine, :chinese, :indian], @root.descendants.map(&:label)
  end

  def test_ancestor_to?
    setup_descendants
    assert_equal true, @root.ancestor_to?([@indian])
  end

  def test_ancestors
    [@root, @cars, @bmw, @chinese, @audi, @cuisine, @indian].map(&:save)
    assert_equal [], @cars.descendants

    @root.add_child(@cars)
    @root.add_child(@cuisine)

    @cars.add_child(@bmw)
    @cars.add_child(@audi)

    @cuisine.add_child(@chinese)
    @cuisine.add_child(@indian)

    assert_equal [:cars, :root], @bmw.ancestors.map(&:label)
    assert_equal [:cuisine, :root], @indian.ancestors.map(&:label)
    assert_equal [], @root.ancestors
  end

end
