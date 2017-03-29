require_relative 'utils'

def main(request)
  Advert.all.map do |ad|
    p ad.constraint.satisfies?(request)
  end
end
