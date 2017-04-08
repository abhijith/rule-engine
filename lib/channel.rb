require_relative 'base'

class Channel < Base
  attr_accessor :label, :categories

  def initialize(label: nil)
    @label      = label
    @categories = []
  end

end
