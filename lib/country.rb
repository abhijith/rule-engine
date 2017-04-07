require_relative 'base'

class Country < Base
  attr_accessor :label

  def initialize(label: nil)
    @label = label
  end

  def self.find_by_label(l)
    Country.all.select {|x| x.label == l }.first
  end

end
