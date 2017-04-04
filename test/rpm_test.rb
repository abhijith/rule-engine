require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def build_category_tree(h, parent_id = nil)
    case h.class.to_s
    when Hash.to_s
      h.each_pair do |k, v|
        c = Category.new(k, parent_id).save
        build_category_tree(v, c.id)
      end
    when Array.to_s
      h.each {|x| build_category_tree(x, parent_id) }
    when String.to_s
      Category.new(h, parent_id).save
    end
  end

  def setup
    countries = ["india", "germany", "sweden"]
    countries.each {|x| Country.new(label: x).save }

    cars     = ["bmw", "volvo"]
    airlines = ["air-berlin", "air-india"]
    food     = ["dosa", "meatballs"]

    categories = {
      "cars"     => cars,
      "travel"   => { "airlines" => airlines, "food" => food }
    }
    build_category_tree(categories)

    channels  = {
      "team-bhp.com"     => ["automobiles", "cars", "bikes"],
      "trip-advisor.com" => ["travel", "airlines", "food"],
    }

    channels.each_pair do |channel, categories|
      c = Channel.new(label: channel)
      c.categories = categories.map {|x| Category.find_by_label(x) }.compact
      c.save
    end

    country_limits = Country.all.map {|c| Limit.new(c, 6).save }
    channel_limits = Channel.all.map {|c| Limit.new(c, 3).save }

    @volvo = Advert.new(label: "volvo-s40").save
    @volvo.limits = country_limits + channel_limits
    @volvo.constraints = ExprGroup.new(:all?, [Expr.new(field: :country,     type: Country,  value: Country.find_by_label("sweden").id,       operator: :==),
                                               Expr.new(field: :channel,     type: Channel,  value: Channel.find_by_label("team-bhp.com").id, operator: :==),
                                               Expr.new(field: :preferences, type: Category, value: [Category.find_by_label("cars").id],      operator: :==)
                                              ])

    @bmw = Advert.new(label: "bmw-i8").save
    @bmw.limits = country_limits + channel_limits
    @bmw.constraints = ExprGroup.new(:all?, [Expr.new(field: :country,     type: Country,  value: Country.find_by_label("germany").id,      operator: :==),
                                             Expr.new(field: :channel,     type: Channel,  value: Channel.find_by_label("team-bhp.com").id, operator: :==),
                                             Expr.new(field: :preferences, type: Category, value: Category.find_by_label("cars").id,        operator: :parent_of?)
                                            ])

    @masterchef = Advert.new(label: "master-chef").save
    @masterchef.limits = country_limits + channel_limits
    cats = ["food", "dosa", "travel"].map {|x| Category.find_by_label(x).id }
    @masterchef.constraints = ExprGroup.new(:all?, [Expr.new(field: :country,     type: Country,  value: Country.all.map(&:id),   operator: :member?),
                                                    Expr.new(field: :channel,     type: Channel,  value: Channel.find_by_label("trip-advisor.com").id, operator: :==),
                                                    Expr.new(field: :preferences, type: Category, value: cats, operator: :intersect?)
                                                   ])

    @airberlin = Advert.new(label: "air-berlin").save
    @airberlin.limits = country_limits + channel_limits
    expr = ExprGroup.new(:any?, [Expr.new(field: :preferences, type: Category, value: Category.find_by_label("travel").id, operator: :parent_of?),
                                 Expr.new(field: :categories,  type: Category, value: Category.find_by_label("travel").id, operator: :parent_of?)])

    @airberlin.constraints = ExprGroup.new(:all?, [Expr.new(field: :country,    type: Country,  value: [1, 2], operator: :member?),
                                                   Expr.new(field: :channel,    type: Channel,  value: Channel.find_by_label("trip-advisor.com").id, operator: :==),
                                                   expr])
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_main
    assert_equal 4,  Advert.count
    assert_equal 3,  Country.count
    assert_equal 2,  Channel.count
    assert_equal 10, Category.count

    ad = Advert.find_by_label("volvo-s40")
    r = Request.new(channel: "team-bhp.com", preferences: ["cars"], country: "sweden")
    assert_equal true, ad.constraints.satisfies?(r)

    ad = Advert.find_by_label("bmw-i8")
    r = Request.new(channel: "team-bhp.com", preferences: ["bmw"], country: "germany")
    assert_equal true, ad.constraints.satisfies?(r)

    ad = Advert.find_by_label("master-chef")
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "india")
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "germany")
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["food"], country: "sweden")
    assert_equal true, ad.constraints.satisfies?(r)


    ad = Advert.find_by_label("air-berlin")
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "sweden")
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "germany")
    assert_equal true, ad.constraints.satisfies?(r)
    r = Request.new(channel: "trip-advisor.com", preferences: ["cars"], country: "india")
    assert_equal false, ad.constraints.satisfies?(r)
  end

end
