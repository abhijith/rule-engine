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

class Expr
  attr_accessor :channel, :advert, :operator
end

expr1 = {
  :channel  => [:preferences],
  :advert   => [:category]
  :operator => :intersection,
}

expr2 = {
  :channel  => [:category],
  :advert   => [:category]
  :operator => :==,
}

expr3 = {
  :channel  => [:category],
  :advert   => [:category]
  :operator => :is_a?,
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
  channel: "cars",
  pref: ["cars", "gadgets"]
}

r2 = {
  channel: "cars",
  pref: ["gadgets"]
}
