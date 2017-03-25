require 'set'

class Array

  def subset(b)
    Set.new(self).subset?(Set.new(b))
  end

  def intersect?(b)
    Set.new(self).intersect?(Set.new(b))
  end

  def subtype?(b)
    b.is_a? self.class
  end

end
