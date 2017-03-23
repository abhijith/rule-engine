expr = {
  type:    :category,
  request: [1],
  advert:  [2],
  op:      :foo
}

def foo(request, ads)
  { r: request, a: ads }
end

p Object.send(expr[:op], expr[:request], expr[:advert])
