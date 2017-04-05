require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  objs = [request.country, request.channel].compact

  ad = Advert.live.select do |ad|
    (not ad.limits_exceeded?([request.country, request.channel])) and ad.constraints.satisfies?(request, debug = false)
  end.first

  ad.update_limits(objs) if ad

  ad
end
