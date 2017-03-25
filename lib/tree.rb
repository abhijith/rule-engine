class TreeNode
  attr_accessor :data, :children, :parent

  def initialize(d, parent_node = nil)
    @data     = d
    @parent   = parent_node
    @children = []
  end

  def <<(node)
    node.parent = self
    self.children << node
  end

  def descendants
    self.children.flat_map {|node| [node] + node.descendants }
  end

  def ancestors
    if self.parent
      [self.parent] + self.parent.ancestors
    else
      []
    end
  end

end
