require_relative 'initializer'

class BaseTest < Test::Unit::TestCase

  def setup
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_id
    p Base.db

    Channel.new(label: "a").save
    Country.new(label: "b").save
    Advert.new(label: "c").save

    pp Base.db
  end

end
