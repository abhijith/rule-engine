def init_data
  # cars
  # |    `["bmw", "audi", "fiat", "volvo"]
  # `bikes
  # |    `["ktm", "bmw", "yamaha", "suzuki"]
  # `foods
  # |    `["dosa", "idly", "meatballs", "croissant", "pizza"]
  # `flights
  #       `["lufthansa", "air-france", "emirates", "air-india"]

  categories = ["cars", "bikes", "food"]
  cars       = ["bmw", "audi", "fiat", "volvo"]
  bikes      = ["ktm", "bmw", "yamaha", "suzuki"]
  flights    = ["lufthansa", "air-france", "emirates", "air-india"]
  foods      = ["dosa", "idly", "meatballs", "croissant", "pizza"]

  categories = {
    "cars"   => cars,
    "bikes"  => bikes,
    "foods"  => foods,
    "travel" => []
  }

  # channels
  channels  = ["reddit.com", "team-bhp.com", "medium.com",
               "trip-advisor.com", "booking.com"]
  countries = ["india", "germany", "sweden", "france", "italy"]

  # ads
  ads = ["bmw-m4", "audi-a4", "fiat-punto", "volvo-s40",
         "master-chef-australia", "master-chef-us", "ktm-390",
         "yamaha-r6", "motocross", "formula-1", "khaana-kazana",
         "airbnb", "euro-cars", "sixt", "hertz"]

end

def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end
