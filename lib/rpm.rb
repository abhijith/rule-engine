require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  Advert.live.select do |ad|
    (not ad.limits_exceeded?([request.country, request.channel])) and ad.constraints.satisfies?(Request.new(request), true)
  end
end
