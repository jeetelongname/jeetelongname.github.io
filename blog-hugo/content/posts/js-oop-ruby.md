---
title: "Recreating the JS object system in ruby"
date: 2023-03-04
tags: ["ruby", "javascript", "oop", "hack", "programming"]
draft: true
---

I had a funky idea, why not try and re create the js object system in ruby?
Why? well because we can.
This idea dawned on me when I realised I can add the functionality of property
like accesses to hash values using method missing.

```ruby
class Hash
  def method_missing(prop, *args, &block)
    self[prop]
  end
end

hash = {
  hello: "hello is not a method 😱",
}

puts hash.hello #=>  "hello is not a method 😱"
```

Ignoring the method definition this looks a lot like javascript. and now I want to
see how far we can take it.


## Some expectations {#some-expectations}

Now this will not lead to a full look alike of Javascripts object system. we can
get close but we are still limited by rubys syntax. In any case I think we can
create something that works a lot like the function and learn something along
the way!


## Why javascripts object system is special {#why-javascripts-object-system-is-special}

Lets take a minute to discuss javascripts object system.
JS is interesting because you do not need to go through classes to make objects.


## Properties {#properties}

Properties are our object attributes, they are our values, they can be read and
written too

```javascript
obj = {
    first: "Joe",
    last: "mama"
}

console.log(obj.first) // => Joe
obj.last = "Son"
console.log(obj.last) // => Son
```

We can already get our properties, but we need to be able to set them.
Now in a pitiful language we would be stumped but not in ruby. Here setting
attributes is also a method that can be caught with `method_missing`!

```ruby
class Hash
  def method_missing(prop, *args)
    puts prop
  end
end

hash = {hello: "hi"}
hash.hello = "greetings" # => :hello=
```

as you can see, its just our method name with an equals sign appended too it.
check for that and we can set the property in question

```ruby
class Hash
  def method_missing(prop, *args, &block)
   if prop.end_with? '='
     self[prop.to_s.delete_suffix('=').to_sym] = args.first
   else
     self[prop]
   end
  end
end

hash = {hello: "Hi"}
puts hash.hello # => "Hi"
hash.hello = "greetings"
puts hash.hello # => "greetings"
```

and just like that we can now get and set properties.


## Methods {#methods}

Methods are a little more interesting, Methods are properties that are
functions, they The way they access the object is through the use of the `this` keyword.

```js
obj = {
  first: "Joe",
  last: "Mama",
  full () {
    return `${this.first} ${this.last}`
  }
}

console.log(obj.full()) // => Joe Mama
```

Now this is a trivial case but methods can do all sorts of things, not only
access our properties but set them with arguments taken in from the caller.
All of this hinges on accessing the special variable...


### `This` {#this}

`this` in js is an implicit and usually hidden arguments to all functions (except
arrow functions). It contains a reference to the object we are working on, You
can think of it like `self` in languages such as python and ruby.

`this` can be passed in explicitly by using the `.call` method on the function like
so. In fact the `obj.method()` is just syntax sugar for the `.call` method.

```js
obj.full() == obj.full.call(obj) // => true
```

This is visually similar to python. The only difference being that the
method definitions need to take in an implicit self argument as there first
positional argument.

```python
class Person():
    def method(self, *args): # explit self argument
        return args

Person().method(1,2,3) # implict self passed in when called.
```

We can actually implement the python style of "this passing" relatively simply,
using lambdas and currying.

```ruby
class Hash
  def method_missing(prop, *args)
    if prop.end_with?("=") # check if its a set
      self[prop.to_s.delete_suffix('=').to_sym] = args.first
    elsif (accessed_prop = self[prop]).instance_of? Proc
      # curry the method and then call it with self.
      # This returns another method which can take the rest of the arguments
      accessed_prop.curry.call(self)
    else
      accessed_prop
    end
  end
end

hash = { hello: 'Hi',
         greet: ->(this, name, l_name) { "#{this.hello}, #{name}, #{l_name}" } }

hash.hello = 'greetings'
puts hash.greet.('Joe', 'Mama') # => "greetings, Joe Mama"
```

This is nice and all but I want to have that magic variable.


### Getters and Setters {#getters-and-setters}


## Prototypes {#prototypes}
