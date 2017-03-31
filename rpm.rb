require 'sinatra'

require_relative 'lib/utils'
require_relative 'lib/rpm'

def init_data
  ad1     = Advert.new(label: "bmw-m3").save

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

  car_ex  = Channel.new(label: "car-example.com").save
  food_ex = Channel.new(label: "food-example.com").save

  car_ex.categories = [cars, food]

  expr1 = Expr.new(field: :channel,    type: :channel,  value: 0, operator: :==)
  expr2 = Expr.new(field: :country,    type: :country,  value: [0, 1], operator: :member?)
  expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :intersect?)

  expr  = ExprGroup.new(:any?, [expr1, expr2, expr3])

  ad1.constraints = expr

  l1 = Limit.new(germany, 2)
  l2 = Limit.new(car_ex, 2)
  ad1.limits = [l1, l2]
end

def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end

get '/' do
  flush
  init_data
  ":initialized"
end

get '/ads/:id' do
  content_type :json
  a = Advert.find(params[:id].to_i)
  a.to_h.to_json
end

post '/match' do
  content_type :json
  r = JSON.parse(request.body.read, symbolize_names: true)
  main(r).to_json
end
