class Base
  attr_accessor :id

  @@db = Hash.new {|h,k| h[k] = { coll: [], count: 0 } }

  def self.db
    @@db
  end

  def self.empty
    { coll: [], count: 0 }
  end

  def self.table
    self.instance_eval do
      self.db[self]
    end
  end

  def self.table=(x)
    self.instance_eval do
      self.db[self] = x
    end
  end

  def self.rows
    self.instance_eval do
      self.db[self][:coll]
    end
  end

  def self.rows=(x)
    self.db[self] = { coll: x, count: x.count }
  end

  def self.all
    self.rows
  end

  def self.count
    self.instance_eval do
      self.db[self][:count]
    end
  end

  def self.count=(x)
    self.instance_eval do
      self.db[self][:count] = x
    end
  end

  def self.destroy_all
    self.table = self.empty
  end

  def self.find(id)
    self.rows[id]
  end

  def self.find_by(**kwargs)
    rs = self.rows.select do |x|
      kwargs.map {|attr, val| x.send(attr) == val if x.respond_to?(attr) }.all?
    end
    rs.first
  end

  def save
    self.id = self.class.count
    self.class.rows << self
    self.class.count = self.class.count + 1
    self
  end

  def destroy
    self.class.rows.delete(self)
    self.class.count = self.class.count - 1
  end

end

module Limited
  attr_accessor :limit, :views

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

  def inc_view
    @views = @views + 1
  end

end
