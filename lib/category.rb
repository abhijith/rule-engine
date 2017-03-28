class Category
  attr_accessor :id, :label, :children, :parent

  @@coll    = []
  @@counter = 0

  def initialize(label, parent = nil)
    @label    = label
    @parent   = parent
    @children = []
  end

  def self.load(file)
    JSON.parse(File.read(file), symbolize_names: true)
  end

  def self.parse(coll)
    coll.map {|h| self.new(h).save }
  end

  def self.count
    @@counter
  end

  def save
    self.id = @@counter
    @@coll << self
    @@counter = @@counter + 1
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def add_child(node)
    node.parent = self
    self.children << self.find(node)
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
