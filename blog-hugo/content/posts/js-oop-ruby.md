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

```rjsx
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
   if prop.to_s[-1] == '='
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

Methods are functions that act on our object. they access the object using the
special varaible of this


### Getters and Setters {#getters-and-setters}


## Prototypes {#prototypes}
