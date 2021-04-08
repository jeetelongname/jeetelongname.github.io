---
title: "List manipulation into madness"
date: 2021-04-07
description: "mind.map { |n| n.append 'Ruby this Ruby that' }"
tags: [programming, lists, python, ruby]
draft: false
---

# It all started from a joke..

A friend sent me a code snippet in an effort to prank meme. To bad for him I
know that url by heart and was not fooled by his petty gambit. But this got
me thinking about ways of shrinking his solution and ended up with me finding
different ways to manipulate the same list into doing the same thing.
I hope you find this journey as interesting as I did!

This is the data set I used and will be compatible with all of these examples
(including the ruby ones (or python ones depending on where you came from))

```ruby
    print(a([47961, 58081, 58081, 54756, 57121, 18496, 13689, 13689, 60516, 60516, 60516, 13225, 62500, 53824, 59049, 58081, 59049, 43264, 45796, 13225, 44100, 53824, 51984, 13689, 60516, 42849, 58081, 44100, 47961, 21025, 59536, 20164, 44944, 31684, 60516, 15876, 60516, 18225, 35721, 47089, 36100, 44100, 31684,])
```

## Python

All this snippet is doing is decoding all the numbers in a list according to how my friend
encoded them and concatenating the decoded value to the variable `c` then
returning said value `c`

Its a fine solution but lacks panache and it uses 3 lines which is not the most terse way
too put it

```python
    def a(b, c=""):
        for d in b:
            c += chr(round(((d ** (1 / 2)) * (5 / 9)) - 18))
        return c
```

We can of course move the body onto the same line but its not really that inventive
(Its also the form my friend sent too me for maximum illegibility) but it is
starting to look a lot like list comprehension...

```python
    def a(b, c=""):
        for d in b: c += chr(round(((d ** (1 / 2)) * (5 / 9)) - 18))
        return c
```

This is where I come to my first new example in which I do everything in one line.
All I am doing here is using [list
comprehension](https://www.w3schools.com/python/python_lists_comprehension.asp)
to manipulate the entire array. I then join the entire array to an empty string
using the `join` method.
I was pretty happy with this. but this started feeling a lot like a map function
(I guess it is) and I thought why not use the one in python?

```python
    def a(b):
        return "".join([chr(round(((d ** (1 / 2)) * (5 / 9)) - 18)) for d in b])
```

With the map function all we need too do is provide it with a _reference_ to a function (which
will perform our transformation) and an iterable (in this case a list). I then
`join` the list like I did last time

This was my first use of the map function in python. Now _its readable_ and its
_useful_ but its not cool, fun or small which are the more important tenants when
programming. So to ruby we go!

```python
    def decrypt(d):
        return chr(round(((d ** (1 / 2)) * (5 / 9)) - 18))

    def a(b):
        return "".join(map(decrypt, b))
```

## Ruby

In ruby the map method takes a function inline using a `block`. A block is just
an anonymous function that a method can take as an argument. You see them all
over the place in ruby code.
In our case we are passing a block to the map
method and it will then "transform" or change all the elements in our array
according to our block. We then call the join method on our new array which will
turn our array into a string which we then return (in ruby the return is implied which makes it similar to lisp in that
regard (and another reason I love ruby!))

Not only is this smaller its a lot nicer too look at then the _python map
function_

```ruby
    def a(b)
      b.map { |i| (i ** 0.5 * 5 / 9 - 18).round.chr }.join
    end
```

Now that we have come this far I thought it would be fun too go back the other
way and see what the ruby versions of the other methods we discussed look like

Ruby does not have formal list comprehension as we can use the `select` and
`collect` methods to "emulate it". Select in this case would not help us as it
is more similar to the [filter higher order
function](https://en.wikipedia.org/wiki/Filter_%28higher-order_function%29) but
we can try and rewrite it using collect

```ruby
    def a(b)
        b.collect { |x| (x ** 0.5 * 5 / 9 - 18).round.chr }.join
    end
```

as we can see that we can just substitute in `map` and have the exact same
solution. So why use it over map? Well you don't need to at all, turns out there
the same function but since ruby wants its small talk users to feel at home they
added in this `collect` alias.

Now that I have wasted your time a little we can
move over to using an iterator to solve this problem. as we can see the iterator
is so much more clunky than the other solutions. We are having to instantiate c,
then manipulate it _linearly_ and then return it explicitly. This is not only
more lines of code but lines of _boring code_

```ruby
def a(b)
    c = ""
    b.each do |x|
        c +=  (x ** 0.5 * 5 / 9 - 18).round.chr
    end
    c
end

```

We can of course move it onto one line

```ruby
def a(b)
    c = ""; b.each { |x| c +=  (x ** 0.5 * 5 / 9 - 18).round.chr };c
end

```

but it does not have the same charm as using one of the previous higher order
functions
(on a side note this example also uses a higher order function called `each` its
actually the main iterator of the language which is pretty cool (but its still
clunky!))

If you are more of a `for` fanatic then we can also use that but it loses a lot
of the charm that any of the other solutions gave us

```ruby
def a(b)
    c = ""
    for x in b
        c +=  (x ** 0.5 * 5 / 9 - 18).round.chr
    end
    c
end
```

# Takeways from this article

1. Higher order functions can make your code much more elegant
2. List Comprehension is pretty cool and combines the `map` and `filter` Higher
   Order functions into one nice syntactic package (we never actually used its
   filtering capability's but they are [pretty
   cool](https://www.w3schools.com/python/python_lists_comprehension.asp))
3. Ruby is a mishmash of a lot of cool languages
4. Rubys solutions can be more clunky (but we have pattern matching so it
   balances out :)
5. Iterators are boring and clunky no matter the language :)
6. I spent way to much time on a really simple problem and should probably go to
   bed

If there are other methods I may have missed out or I made a silly mistake then [do get in
touch!](mailto:jeetelongname@gmail.com)

oh and the link my friend was encoding can [be found here](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
