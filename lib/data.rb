require_relative 'utils'

def foo(h, parent_id = nil)
  case h.class.to_s
  when Hash.to_s
    puts :hash
    h.each_pair do |k, v|
      c = Category.new(label: k, parent_id: parent_id).save
      foo(v, c.id)
    end
  when Array.to_s
    puts :arr
    h.each {|x| Category.new(label: x, parent_id: parent_id).save }
  when String.to_s
    puts :str
    Category.new(label: h, parent_id: parent_id).save
  end
end

def setup_cats
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
  foo(categories)
end

setup_cats
pp Category.all[1]

def init_data
  # setup countries
  # setup categories
  # setup channels
  # setup ads

  countries = ["india", "germany", "sweden", "france", "italy"]
  countries.each {|x| Country.new(label: x).save }

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
    c = Channel.new(label: x)
    c.categories = categories.map {|x| Category.find_by_label(x) }.compact
    c.save
  end

  # ads
  ads = ["bmw-m4", "audi-a4", "fiat-punto", "volvo-s40",
         "master-chef-australia", "master-chef-us", "ktm-390",
         "yamaha-r6", "motocross", "formula-1", "khaana-kazana",
         "airbnb", "euro-cars", "sixt", "hertz"]

  ads.each {|x| Advert.new(label: x).save }
end

def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end
