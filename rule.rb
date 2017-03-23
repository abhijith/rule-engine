expr = {
  type:    :category,
  request: [1],
  advert:  [2],
  op:      :foo
}

def foo(request, ads)
  p { r: request, a: ads }
  request == ads
end

def bar(request, ads)

p Object.send(expr[:op], expr[:request], expr[:advert])
