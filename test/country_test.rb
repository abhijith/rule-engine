require_relative 'utils'

class CountryTest < Test::Unit::TestCase

  def setup
  end

  def teardown
    Country.destroy_all
  end

end
