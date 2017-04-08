require_relative 'base'

class Country < Base
  attr_accessor :label

  def initialize(label: nil)
    @label = label
  end

end
