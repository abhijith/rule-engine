require_relative 'utils'

class RpmError < StandardError
  def initialize(x = nil)
    RpmLogger.error(x) if x
    RpmLogger.debug(self.backtrace.join("\n")) if self.backtrace
  end
end

class ChannelNotFound  < RpmError ; end
class CountryNotFound  < RpmError ; end
class CategoryNotFound < RpmError ; end
class AdvertNotFound   < RpmError ; end
class LimitNotFound    < RpmError ; end

class InvalidOperator  < RpmError ; end
class InvalidField     < RpmError ; end
class ProtocolError    < RpmError ; end
