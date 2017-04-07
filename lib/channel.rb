require_relative 'base'

class Channel < Base
  attr_accessor :label, :categories

  def initialize(label: nil)
    @label      = label
    @categories = []
  end

  def self.find_by_label(l)
    Channel.all.select {|x| x.label == l }.first
  end

end
