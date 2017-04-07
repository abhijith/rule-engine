class Base
  attr_accessor :id

  @@db = Hash.new {|h,k| h[k] = [] }

  def self.db
    @@db
  end

  def self.rows
    self.instance_eval do
      self.db[self]
    end
  end

  def self.rows=(x)
    self.db[self] = x
  end

  def self.all
    self.rows
  end

  def self.count
    self.all.count
  end

  def self.destroy_all
    self.rows = []
  end

  def self.find(id)
    self.rows[id]
  end

  def self.find_by_label(l)
    self.rows.select {|x| x.label == l }.first
  end

  def save
    self.id = self.class.rows.count
    self.class.rows << self
    self
  end

  def destroy
    self.class.rows.delete(self)
  end

end

class Array
  def intersect?(x)
    not (self & x).empty?
  end
end
