require_relative 'base'

class Category < Base
  attr_accessor :id, :label, :parent_id

  def initialize(label, parent_id = nil)
    @label     = label
    @parent_id = parent_id
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

  def parent_of?(o)
    not (self.descendants & o).empty?
  end

end
