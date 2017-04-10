require_relative 'base'

class Channel < Base
  attr_accessor :label, :categories

  def initialize(label: nil)
    @label      = label
    @categories = []
  end

  def to_h
    {
      id:    id,
      label: label,
      categories: categories.map(&:to_h)
    }
  end

end
