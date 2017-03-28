class Category
  attr_accessor :data, :children, :parent

  @@coll = []
  @@root = nil

  def initialize(data, parent = nil)
    @data     = data
    @parent   = parent
    @children = []
  end

  def self.init
    @@root = Category.new(:root)
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

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end


end
