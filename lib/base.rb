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

  def self.find_by(**kwargs)
    rs = self.rows.select do |x|
      kwargs.map {|attr, val| x.send(attr) == val if x.respond_to?(attr) }.all?
    end
    rs.first
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
