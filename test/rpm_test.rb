require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @nokia  = Advert.new(label: "nokia").save
    @airbnb = Advert.new(label: "airbnb").save

    @reddit = Channel.new(label: "reddit.com").save
    @medium = Channel.new(label: "medium.com").save

    @cars    = Category.new(:cars)
    @bmw     = Category.new(:bmw)
    @audi    = Category.new(:audi)
    @cuisine = Category.new(:cuisine)
    @chinese = Category.new(:chinese)
    @indian  = Category.new(:indian)

    [@cars, @bmw, @chinese, @audi, @cuisine, @indian].map(&:save)

    @cars.add_child(@bmw)
    @cars.add_child(@audi)

    @cuisine.add_child(@chinese)
    @cuisine.add_child(@indian)

    expr1 = Expr.new(field: :channel,    type: :channel,  value: 1, operator: :==)
    expr2 = Expr.new(field: :country,    type: :country,  value: [0, 1], operator: :member?)
    expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :intersect?)
    expr4 = Expr.new(field: :categories, type: :category, value: [0], operator: :descendant?)

    expr  = ExprGroup.new(:any?, [expr1, expr2, expr3])

    @nokia.constraints  = expr
    @airbnb.constraints = expr4
  end

  def teardown
    Advert.destroy_all
    Channel.destroy_all
    Country.destroy_all
  end

  def test_all
    Advert.find(0).constraints
    Advert.find(1).constraints
  end

end
