require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  ad = Advert.live.select do |ad|
    (not ad.limits_exceeded?([request.country, request.channel])) and ad.constraints.satisfies?(request, debug = false)
  end.first
  ad.update_limits
end
