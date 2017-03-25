class Children < Array
  attr_accessor :parent
  def initialize
    p self
    @parent = nil
  end

  def <<(node)
    node.parent = self
    super(node)
  end

end

class TreeNode
  attr_accessor :data, :children, :parent

  def initialize(d, parent_node = nil)
    @data     = d
    @parent   = parent_node
    @children = []
  end

  def <<(node)
    puts "--"
    node.parent = self
    self.children << node
  end

  def descendants
    [self] + self.children.flat_map {|node| node.descendants }
  end

  def ancestors
    if self.parent
      [self.parent] + self.parent.ancestors
    else
      []
    end
  end

end
