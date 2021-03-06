require_relative 'initializer'

class BaseTest < Test::Unit::TestCase
  attr_accessor :a, :b

  Klasses = [Channel, Country, Category, Advert, Limit]

  def empty_db
    Klasses.map {|klass| { klass => klass.empty } }.reduce(&:merge)
  end

  def setup
    @a = Channel.new(label: "a")
    @b = Country.new(label: "b")
  end

  def teardown
    Klasses.each(&:destroy_all)
  end

  def test_empty
    assert_equal({coll: [], count: 0}, Channel.empty)
    assert_equal({coll: [], count: 0}, Channel.table)
  end

  def test_protocol
    a.save
    b.save

    assert_equal 0, a.id
    assert_equal a, Channel.find(0)
    assert_equal a, Channel.find_by(label: "a")
    assert_equal nil, Channel.find_by(label: "x")
    assert_equal nil, Channel.find_by(name: "a")

    assert_equal [a], Channel.rows
    assert_equal [a], Channel.all
    assert_equal 1, Channel.count

    assert_equal 0, b.id
    assert_equal b, Country.find(0)
    assert_equal b, Country.find_by(label: "b")
    assert_equal nil, Country.find_by(label: "x")
    assert_equal nil, Country.find_by(name: "b")

    assert_equal [b], Country.rows
    assert_equal [b], Country.all
    assert_equal 1, Country.count

    db = {
      Channel  => {coll: [a], count: 1},
      Country  => {coll: [b], count: 1},
      Limit    => Limit.empty,
      Advert   => Advert.empty,
      Category => Category.empty
    }
    assert_equal db, Base.db

    Channel.destroy_all
    assert_equal 0, Channel.count

    db = {
      Channel  => Channel.empty,
      Country  => {coll: [b], count: 1},
      Limit    => Limit.empty,
      Advert   => Advert.empty,
      Category => Category.empty
    }
    assert_equal db, Base.db

    Country.destroy_all
    assert_equal 0, Country.count
    assert_equal empty_db, Base.db

    a.save
    b.save
    db = {
      Channel  => {coll: [a], count: 1},
      Country  => {coll: [b], count: 1},
      Limit    => Limit.empty,
      Advert   => Advert.empty,
      Category => Category.empty
    }
    assert_equal db, Base.db

    Channel.table = Channel.empty
    Country.table = Country.empty
    assert_equal empty_db, Base.db

    a.save
    b.save
    a.destroy
    b.destroy
    assert_equal empty_db, Base.db
  end

end
