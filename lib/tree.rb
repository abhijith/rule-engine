class TreeNode
  attr_accessor :data, :children, :parent

  def initialize(d, parent_node = nil)
    @data     = d
    @parent   = parent_node
    @children = []
  end

  def descendants
    self.children.flat_map {|node| node.children }
  end

  def ancestors
  end

end
