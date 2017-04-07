class Array
  def intersect?(x)
    not (self & x).empty?
  end
end
