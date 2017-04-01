def init_data
  # setup countries
  # setup categories
  # setup channels
  # setup ads

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

  categories.each do |x|
    Category.new(label: x).save
  end

  # channels
  channels  = {
    "reddit.com"       => ["cars", "bikes", "airlines", "travel"],
    "team-bhp.com"     => ["cars", "bikes"],
    "motocross.com"    => ["bikes", "ktm", "yamaha", "suzuki", "bmw"]
    "trip-advisor.com" => ["foods", "travel", "air-india", "emirates"],
    "booking.com"      => ["lufthansa", "air-france"],
    "clear-trip.com"   => ["airlines"],
    "lufthansa.com"    => ["lufthansa", "foods"]
  }

  channels.each_pair do |channel, categories|
    Channel.new(label: x).save
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
