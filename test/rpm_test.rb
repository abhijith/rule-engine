require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @a1 = Advert.new(label: "nokia")
    @a2 = Advert.new(label: "airbnb")
  end

  def teardown
    Advert.destroy_all
  end

  def test_all
  end

end
