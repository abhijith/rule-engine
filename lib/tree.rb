class TreeNode
  attr_accessor :data, :children, :parent

  @coll = []

  def initialize(data, parent = nil)
    @data     = data
    @parent   = parent
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

  def destroy_all
    @coll = []
  end

end
