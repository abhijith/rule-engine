class Category
  attr_accessor :id, :label, :parent_id

  @@coll    = []
  @@counter = 0

  def initialize(label, parent_id = nil)
    @label     = label
    @parent_id = parent_id
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
    self
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.find_by_label(l)
    @@coll.select {|x| x.label == l }.first
  end

  def parent
    Category.find(self.parent_id) if self.parent_id
  end

  def parent=(node)
    self.parent_id = node.id
  end

  def children
    Category.all.select {|x| x.parent_id == self.id }
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def add_child(node)
    node.parent_id = self.id
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

  def ==(o)
    self.label == o.label and self.parent_id == o.parent_id
  end

  def self.intersect?(a, b)
    (a.map(&:id) & b.map(&:id)).any?
  end

  def isa?(o)
    self.ancestors.member?(o)
  end

end
