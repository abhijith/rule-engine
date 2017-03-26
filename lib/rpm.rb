require_relative 'expr'
require_relative 'channel'
require_relative 'advert'
require_relative 'tree'

def main(ch, expr)
  ads = Advert.all.select {|ad| expr.run(ch, ad) }
  p ads
end
