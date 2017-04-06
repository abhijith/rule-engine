require_relative 'utils'

def main(attrs)
  request = Request.new(attrs)

  objs = [request.country, request.channel].compact
  RpmLogger.debug(objs)

  ads = Advert.live.select do |ad|
    RpmLogger.debug("Examining ad: #{ad.to_h}")

    (not ad.views_exceeded?([request.country, request.channel])) and ad.constraints.satisfied?(request, debug = false)
  end

  RpmLogger.debug("Matched ads: #{ads.map(&:to_h)}")

  ad = ads.first
  if ad
    RpmLogger.debug("Updating limits for: #{ad.to_h}")
    ad.update_limits(objs)
    RpmLogger.debug("Limits updated: #{ad.to_h}")
  end

  ad
end
