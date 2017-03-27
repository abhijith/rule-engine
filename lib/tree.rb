class TreeNode
  attr_accessor :data, :children, :parent

  @@coll = []
  @@root = TreeNode.new(:root)

  def initialize(data, parent = nil)
    @data     = data
    @parent   = parent
    @children = []
  end

  def self.root
    @@root
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

  def find(id)
    @@coll[id]
  end

  def destroy_all
    @coll = []
  end

end
