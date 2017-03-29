require_relative 'utils'

def init_data
  ad1     = Advert.new(label: "bmw-m3").save
  ad2     = Advert.new(label: "master-chef").save

  cars    = Category.new("cars")
  bmw     = Category.new("bmw")
  audi    = Category.new("audi")
  food    = Category.new("food")
  south   = Category.new("south-indian")
  north   = Category.new("north-indian")

  india   = Country.new(label: "india").save
  germany = Country.new(label: "germany").save

  [cars, bmw, food, audi, south, north].map(&:save)

  cars.add_child(bmw)
  cars.add_child(audi)

  food.add_child(south)
  food.add_child(north)

  reddit = Channel.new(label: "car-example.com").save
  medium = Channel.new(label: "food-example.com").save

  reddit.categories = [cars, food]

  expr1 = Expr.new(field: :channel,    type: :channel,  value: 1, operator: :==)
  expr2 = Expr.new(field: :country,    type: :country,  value: [0, 1], operator: :member?)
  expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :intersect?)

  expr  = ExprGroup.new(:any?, [expr1, expr2, expr3])

  ad1.constraints = expr
  ad2.constraints = expr2
end

def main(attrs)
  init_data

  request = Request.new(attrs)
  coll = Advert.all.select do |ad|
    ad.constraints.satisfies?(request)
  end
  coll.map do |ad|
    ad.inc_view
    p ad.views
  end
end
