require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  # reject expired and exhausted
  coll = Advert.all.reject do |ad|
    ad.exhausted? or ad.views_exhausted?(request)
  end

  coll = coll.select {|ad| ad.constraints.satisfies?(request) }

  coll.map do |ad|
    ad.inc_view
    ad.inc_country_view(request)
    ad.inc_channel_view(request)
  end

  "true"
end
