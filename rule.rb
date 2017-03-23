rule = {
  "group" => {
    "condition"=> "AND",
    "rules"=> [{
                 "field"=> "global-views",
                 "operator"=> ">=",
                 "value"=> "1000"
               },
               {
                 "group" => {
                   "condition"=> "OR",
                   "rules"=> [{
                                "field"=> "preferences",
                                "operator"=> "in",
                                "value"=> []
                              },
                              {
                                "field"=> "category",
                                "operator"=> "in",
                                "value"=> []
                              },
                              {
                                "field"=> "user-views",
                                "operator"=> ">=",
                                "value"=> "1000"
                              }]
                 }
               }]
  }
}

class Expr
  attr_accessor :type, :request, :advert, :op
end

e1 = {
  type:    :category,
  request: [1],
  advert:  [2],
  op:      :debug
}

e2 = {
  type:    :category,
  request: [1],
  advert:  [2],
  op:      :m1
}

e3 = {
  type:    :category,
  request: [1],
  advert:  [1],
  op:      :m1
}

def debug(r, a)
  p({r: r, a: a})
end

def m1(request, ads)
  p request == ads
end

def foo(expr)
  Object.send(expr[:op], expr[:request], expr[:advert])
end

foo(e1)
foo(e2)
foo(e3)
