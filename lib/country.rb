require_relative 'base'

class Country < Base
  attr_accessor :id, :label

  def initialize(label: nil)
    @label = label
  end

end
