require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  # reject expired and exhausted
  coll = Advert.all.reject do |ad|
    ad.exhausted? or ad.views_exhausted?(request)
  end

  coll = coll.select {|ad| ad.constraints.satisfies?(request) }

  coll.count.to_json
end
