require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @nokia  = Advert.new(label: "nokia")
    @airbnb = Advert.new(label: "airbnb")

    @reddit = Channel.new(label: "reddit.com")
    @medium = Channel.new(label: "medium.com")

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
    expr2 = Expr.new(field: :country,    type: :country,  value: 1, operator: :==)
    expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :member?)

    expr  = ExprGroup.new(:any?, [expr1, expr2, expr3])

    @nokia.constraint = expr
  end

  def teardown
    Advert.destroy_all
    Channel.destroy_all
    Country.destroy_all
  end

  def test_all
  end

end
