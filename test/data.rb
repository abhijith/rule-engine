def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end

def build_category_tree(h, parent_id = nil)
  case h.class.to_s
  when Hash.to_s
    h.each_pair do |k, v|
      c = Category.new(label: k, parent_id: parent_id).save
      build_category_tree(v, c.id)
    end
  when Array.to_s
    h.each {|x| build_category_tree(x, parent_id) }
  when String.to_s
    Category.new(label: h, parent_id: parent_id).save
  end
end

def make_limits(channel: nil, country: nil)
  a = []
  b = []
  a = Country.all.map {|c| Limit.new(c, country).save } if country
  b = Channel.all.map {|c| Limit.new(c, channel).save } if channel
  a + b
end

def make_ad(label)
  Advert.new(label: label, start_date: DateTime.now - 1, end_date: DateTime.now + 1).save
end

def init_data
  ##
  #
  # cars
  #    |
  #    `[bmw, volvo]
  # travel
  #      |
  #      `airlines
  #              |
  #               `[air-berlin, air-india]
  #      |
  #      `food
  #           |
  #           `[dosa, meatballs]
  #
  ##

  countries = ["india", "germany", "sweden"]
  countries.each {|x| Country.new(label: x).save }

  categories = {
    "cars"     => ["bmw", "volvo"],
    "travel"   => { "airlines" => ["air-berlin", "air-india"], "food" => ["dosa", "meatballs"] }
  }
  build_category_tree(categories)

  channels  = {
    "team-bhp.com"     => ["automobiles", "cars", "bikes"],
    "trip-advisor.com" => ["travel", "airlines", "food"],
    "reddit.com"       => ["social", "news"],
  }

  channels.each_pair do |channel, categories|
    c = Channel.new(label: channel)
    c.categories = categories.map {|x| Category.find_by(label: x) }.compact
    c.save
  end

  volvo = make_ad("volvo-s40")
  volvo.limits = make_limits(channel: 2, country: 2)
  volvo.constraints = ExprGroup.all?([Expr.==(:country, "sweden"),
                                      Expr.==(:channel,"team-bhp.com"),
                                      Expr.==(:preferences, ["cars"])])

  bmw = make_ad("bmw-i8")
  bmw.limits = make_limits(channel: 2, country: 2)
  bmw.constraints = ExprGroup.all?([Expr.==(:country, "germany"),
                                    Expr.==(:channel, "team-bhp.com"),
                                    Expr.ancestor_to?(:preferences, "cars")])

  masterchef = make_ad("master-chef")
  masterchef.limits = make_limits(channel: 3, country: 3)
  masterchef.constraints = ExprGroup.all?([Expr.member?(:country, ["germany", "sweden", "india"]),
                                           Expr.==(:channel, "trip-advisor.com"),
                                           Expr.intersect?(:preferences, ["food", "dosa", "travel"])])

  airberlin = make_ad("air-berlin")
  airberlin.limits = make_limits(channel: 3, country: 3)
  expr = ExprGroup.any?([Expr.ancestor_to?(:preferences, "travel"),
                         Expr.ancestor_to?(:categories,  "travel")])
  airberlin.constraints = ExprGroup.all?([Expr.member?(:country, ["germany", "sweden"]),
                                          Expr.==(:channel, "trip-advisor.com"),
                                          expr])

  coke = make_ad("coke")
  coke.limit = 5
  coke.constraints = Expr.==(:channel, "reddit.com")

  # no conditions except ad-level limits
  catch_all = make_ad("catch-all-ad")
  catch_all.limit = 20
  catch_all.constraints = ExprGroup.true

  # expired
  jogurt = make_ad("Jogurt")
  jogurt.start_date  = DateTime.now - 10
  jogurt.end_date    = DateTime.now - 1
  jogurt.constraints = Expr.true
end
