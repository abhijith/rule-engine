require_relative 'utils'

def flush
  [Advert, Channel, Country, Category, Limit].each(&:destroy_all)
end
