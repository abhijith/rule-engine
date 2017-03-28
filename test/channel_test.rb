require_relative 'utils'

class ChannelTest < Test::Unit::TestCase

  def setup
    @a1 = Channel.new(label: "reddit.com")
    @a2 = Channel.new(label: "medium.com")
  end

  def teardown
    Channel.destroy_all
  end

  def test_save_and_all
    assert_equal 0, Channel.all.count
    @a1.save
    @a2.save
    assert_equal [@a1, @a2], Channel.all
    assert_equal 2, Channel.count
  end

  def test_destroy_all
    @a1.save
    @a2.save
    assert_equal 2, Channel.count
    Channel.destroy_all
    assert_equal 0, Channel.count
  end

  def test_find
    @a2.save
    @a1.save
    assert_equal @a2, Channel.find(0)
    assert_equal @a1, Channel.find(1)
  end

end
