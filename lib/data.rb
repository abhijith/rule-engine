require_relative 'utils'

def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end

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

def init_data
  countries = ["india", "germany", "sweden", "france", "italy"]
  countries.each {|x| Country.new(label: x).save }

  # --
  # cars
  # |    `["bmw", "audi", "fiat", "volvo"]
  # `bikes
  # |    `["ktm", "bmw", "yamaha", "suzuki"]
  # `foods
  # |    `["dosa", "idly", "meatballs", "croissant", "pizza"]
  # `travel
  #       `airlines
  #               `["lufthansa", "air-france", "emirates", "air-india"]
  # --
  cars       = ["bmw", "audi", "fiat", "volvo"]
  bikes      = ["ktm", "bmw", "yamaha", "suzuki"]
  airlines   = ["lufthansa", "air-france", "emirates", "air-india"]
  foods      = ["dosa", "idly", "meatballs", "croissant", "pizza"]

  categories = {
    "cars"     => cars,
    "bikes"    => bikes,
    "foods"    => foods,
    "travel"   => { "airlines" => airlines }
  }
  build_category_tree(categories)


  # channels
  channels  = {
    "reddit.com"       => ["cars", "bikes", "airlines", "travel"],
    "team-bhp.com"     => ["cars", "bikes"],
    "motocross.com"    => ["bikes", "ktm", "yamaha", "suzuki", "bmw"],
    "trip-advisor.com" => ["foods", "travel", "air-india", "emirates"],
    "booking.com"      => ["lufthansa", "air-france"],
    "clear-trip.com"   => ["airlines"],
    "lufthansa.com"    => ["lufthansa", "foods"]
  }

  channels.each_pair do |channel, categories|
    c = Channel.new(label: channel)
    c.categories = categories.map {|x| Category.find_by_label(x) }.compact
    c.save
  end

  country_limits = Country.all.map {|c| Limit.new(c, 6).save }
  channel_limits = Channel.all.map {|c| Limit.new(c, 3).save }

  # ads
  ads = ["bmw-m4", "audi-a4", "fiat-punto", "volvo-s40",
         "master-chef-australia", "master-chef-us", "ktm-390",
         "yamaha-r6", "motocross", "formula-1", "khaana-kazana",
         "airbnb", "euro-cars", "sixt", "hertz"]

  ads.each do |x|
    ad = Advert.new(label: x).save
    ad.limits = country_limits + channel_limits
  end

end

def init_min_data
  countries = ["india", "germany", "sweden", "france", "italy"]
  countries.each {|x| Country.new(label: x).save }

  # --
  # cars
  # |    `["bmw", "audi", "fiat", "volvo"]
  # `bikes
  # |    `["ktm", "bmw", "yamaha", "suzuki"]
  # `foods
  # |    `["dosa", "idly", "meatballs", "croissant", "pizza"]
  # `travel
  #       `airlines
  #               `["lufthansa", "air-france", "emirates", "air-india"]
  # --
  cars       = ["bmw", "audi", "fiat", "volvo"]
  bikes      = ["ktm", "bmw", "yamaha", "suzuki"]
  airlines   = ["lufthansa", "air-france", "emirates", "air-india"]
  foods      = ["dosa", "idly", "meatballs", "croissant", "pizza"]

  categories = {
    "cars"     => cars,
    "bikes"    => bikes,
    "foods"    => foods,
    "travel"   => { "airlines" => airlines }
  }
  build_category_tree(categories)

  # channels
  channels  = {
    "team-bhp.com"    => ["bikes", "ktm", "yamaha", "suzuki", "bmw"],
    "trip-advisor.com" => ["foods", "travel", "air-india", "emirates"],
    "booking.com"      => ["lufthansa", "air-france"],
  }

  channels.each_pair do |channel, categories|
    c = Channel.new(label: channel)
    c.categories = categories.map {|x| Category.find_by_label(x) }.compact
    c.save
  end

  country_limits = Country.all.map {|c| Limit.new(c, 6).save }
  channel_limits = Channel.all.map {|c| Limit.new(c, 3).save }

  # ads
  ads = ["bmw-i8", "volvo-xc60",
         "duke-390", "yamaha-r6",
         "master-chef-india", "master-chef-italia",
         "airbnb", "hertz"]

  ads.each do |x|
    ad = Advert.new(label: x).save
    ad.limits = country_limits + channel_limits
  end

end

[:channel, :country, :category]
