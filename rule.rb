require 'set'

# Example 1
# ---------
# A request comes with the following info:

# Channel has category "cars";
# User has preferences "cars","gadgets"

# We have the following ads available:
# Ad 1 -- category "cars"
# Ad 2 -- Category "gadgets"

# Returning Ad 1 is a better match since it doesn't contradict the channel's category

# Example 2
# ---------
# Channel has category "cars"
# User has preferences "gadgets"

# Perhaps we don't return any ad since:

# Ad 1 goes against the user's preferences
# Ad 2 is not related to the channel


# From here you can see that this starting point still allows you to
# move on to more complex situations:

# Categories can have hierarchies (gadgets can be phones, tablets,
# watches). If there is a preference on a subcategory, that can imply a
# preference on a parent category.

# In my example 2, one could argue that it's less bad not to respect the
# channel's category than the user's preference. So, if we can give the
# user an ad they are interested on, even if that's not in the category
# space of the channel, maybe that's a good alternative.

expr1 = {
  :channel  => :pref,
  :advert   => :category,
  :operator => :intersect?,
}

expr2 = {
  :channel  => :category,
  :advert   => :category,
  :operator => :==,
}

expr3 = {
  :channel  => :category,
  :advert   => :category,
  :operator => :subtype?,
}

nested_rule = {
  :group => {
    :cond  => "AND" ,
    :rules => [
      expr1,
      {
        :group => {
          :cond  => "OR",
          :rules => [expr2, expr3]
        }
      }]
  }
}

flat_rule = {
  :group => {
    :cond  => "OR" ,
    :rules => [expr1, expr2, expr3]
  }
}

# Rule
# channel == category and category in preferences

# We have the following ads available:
# Ad 1 -- category "cars"
# Ad 2 -- Category "gadgets"

a1 = {
  category: ["cars"]
}

a2 = {
  category: ["gadgets"]
}

r1 = {
  category: ["cars"],
  pref: ["cars", "gadgets"]
}

# Returning Ad 1 is a better match since it doesn't contradict the channel's category

r2 = {
  category: ["cars"],
  pref: ["gadgets"]
}

# Perhaps we don't return any ad since:
# Ad 1 goes against the user's preferences
# Ad 2 is not related to the channel

adverts  = [a1, a2]
requests = [r1, r2]

class Array

  def subset(b)
    Set.new(self).subset?(Set.new(b))
  end

  def intersect?(b)
    Set.new(self).intersect?(Set.new(b))
  end

  def subtype?(b)
    b.is_a? self.class
  end

end

def run(expr, channel, advert)
  lhs = channel[expr[:channel]]
  rhs = advert[expr[:advert]]
  op  = expr[:operator]
  p [lhs, rhs, op]
  lhs.send(op, rhs)
end

p run(expr1, r1, a1)
p run(expr2, r1, a1)
p run(expr3, r1, a1)
p run(expr1, r1, a2)
p run(expr2, r1, a2)
p run(expr3, r1, a2)

p run(expr1, r2, a1)
p run(expr2, r2, a1)
p run(expr3, r2, a1)
p run(expr1, r2, a2)
p run(expr2, r2, a2)
p run(expr3, r2, a2)
