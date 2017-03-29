require_relative 'utils'

def main(request)
  p Advert.all.select {|ad| ad.constriant.satisfies?(request) }
end
