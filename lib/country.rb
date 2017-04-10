require_relative 'base'

class Country < Base
  attr_accessor :label

  def initialize(label: nil)
    @label = label
  end

  def to_h
    { id: id, label: label }
  end

end
