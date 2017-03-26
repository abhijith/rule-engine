require_relative 'utils'

def main(ch, expr)
  p Advert.all.select {|ad| expr.run(ch, ad) }
end
