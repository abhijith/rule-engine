require_relative 'expr'
require_relative 'channel'
require_relative 'advert'
require_relative 'tree'

def main(request)
  ch = Channel.new(request)
  Advert.all.select do |ad|

  end
end
