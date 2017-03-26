require_relative 'expr'
require_relative 'channel'
require_relative 'advert'
require_relative 'tree'

def main(request, expr)
  ch  = Channel.new(request)
  ads = Advert.all.select {|ad| expr.run(ch, ad) }
  p ads
end
