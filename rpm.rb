require_relative 'lib/utils'
require_relative 'lib/rpm'

USAGE = "usage: ruby rpm.rb <request.json>"
if ARGV.empty?
  puts USAGE
else
  if ARGV.length == 1
    file = ARGV.first
    if File.exists?(file)
      request = Request.load(file)

      main(request)
    else
      puts "No such file: #{file}"
    end
  else
    puts USAGE
  end
end

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

  cuisine.add_child(chinese)
  cuisine.add_child(indian)

  reddit = Channel.new(label: "car-example.com").save
  medium = Channel.new(label: "food-example.com").save

  reddit.categories = [cars, food]

  expr1 = Expr.new(field: :channel,    type: :channel,  value: 1, operator: :==)
  expr2 = Expr.new(field: :country,    type: :country,  value: [0, 1], operator: :member?)
  expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :intersect?)

  expr  = ExprGroup.new(:any?, [expr1, expr2, expr3])

  ad1.constraints = expr
  ad2.constraints = expr4
end
