# frozen_string_literal: true

# Hash
class Hash
  def respond_to_missing?
    true
  end

  def method_missing(accessor, *_args)
    self[accessor]
  end
end

hash = {
  hello: 'hello is not a method 😱',
  my_method: lambda { |_that|
    puts this.hello
  }
}

puts hash.hello #=>  "hello is not a method 😱"
puts this
hash.my_method.call(:hello)
