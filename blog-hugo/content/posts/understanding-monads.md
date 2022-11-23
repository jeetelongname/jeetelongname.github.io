---
title: "I finally understand monads and now I will write about it"
date: 2022-11-23T05:53:00+00:00
tags: ["haskell", "programming"]
draft: false
---

After A lot of struggle I finally understand monads and why they are useful.
This is less an explainer and more of a write up of my understanding. In any
case Let us get started.


## So what is a monad? {#so-what-is-a-monad}

A monad is a datatype that can use `>>=`, You can call it `bind` or `then` with
the latter name leading into what it does.
Here is its type.

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

This function takes in a context of `m a`, then a function which transforms that
inner value, returning that transformed value in the same context.

```haskell
print $ Just 1 >>= return . (+1)
print $ Just 2 >>= return . (+1)
```

```text
Just 2
Just 3
```

This allows for many operations to be chained together, as the return value of
the first becomes the input of the next.

```haskell
print $ Just 1 >>= return . (+1) >>= return . (+1)
```

```text
Just 3
```


### Do notation {#do-notation}

This chaining of operations looks a lot like imperative programming. This is in
part why `do` notation exists. If we were to use IO (which is a value
contained in the context that it came from an input output system.)
This

```haskell
print "Hello, what is your name?" >>= \_ -> getLine >>= \name -> print $ "Hello " ++ name
```

Turns into

```haskell
main = do
  print "Hello, what is your name?"
  name <- getLine
  print ("Hello " ++ name)
```

Which should look pretty familiar to you.
Here is what the python looks like

```python
def main():
    print("Hello, what is your name?")
    name = input()
    print("Hello " + name)
```


## Okay this is cool and all, but why do we need to implement functor and applicative?? {#okay-this-is-cool-and-all-but-why-do-we-need-to-implement-functor-and-applicative}

Well when you look at what we are doing, `>>=` hides a lot from us.
When we have a look at what functor and applicative add to the
equation we can hopefully see why we need them as well.


## Functors {#functors}

A functor is a datatype where we can (f)map the inner value without losing the
outer context.
It gives us the `<$>` operator, otherwise know as fmap.
Its type is

```haskell
(<$>) :: (a -> b) -> f a -> f b
```

This operation takes a function that transforms type a into type b, and then
a functor of type a, it transforms it into a functor of type b.
Simple enough.

One little side note, _haskell is curried_ meaning that we can write
something like this `(f <$>)` Which returns a function that takes a functor of
type a.
If we say for demonstration that `f` is a function that takes an `Int` and
returns a `String`, our types would look like this.

```haskell
f :: Int -> String
(f <$>) :: f Int -> f String
```

Essentially we have transformed our lowly f that can only work on simple types
into a function that works on functors. This is known as a _lift_ operation.
This is important for later.


## Applicatives {#applicatives}

Applictives add a few more operations to the mix, notably `pure` and `<*>`
Here are the types

```haskell
pure :: a -> f a
(<*>) :: f (a -> b) -> f a -> f b
```

Pure is simple enough. It takes a value and "wraps" it into an applicative. This
raises a value and allows us to use it in the applicative space.
`<*>` takes a function wrapped in an applicative and compose it with another
applicative. If you compare its type to that of `<$>` we can see that they are
similar but `<*>` allows us to use a function in a context! this makes it a more
general version of functor.

Also note that

```haskell
(f <$>) ::  f Int -> f String
(pure f <*>) :: f Int -> String
```


### Why is this useful {#why-is-this-useful}

Well these operations allow us to compose contexts together, something that was
not possible with just `<$>`
For example lets take `(min <$>)` as an example

```haskell
min :: a -> a -> a
(min <$>) :: f a -> f (a -> a)
```

Here we are using a function that takes two arguments rather than one and here
we can see our problem. We have a function wrapped in a context. _If only there_
_was an operation that allowed us to compose contexts together_.
As we can see the left hand side of this equation has the type of `f (a -> a)`,
the right has the type of `f a` these, which then combine and come to the correct
result.

```haskell
min <$> Just 1 <*> Just 2
```

This scales. Here is a function which takes in three arguments and adds them.
Here we lift f then apply one context. We get back a value which takes in
another context and returns a function within that same context&nbsp;[^fn:1] which we can continue to
chain with other values using `<*>`

```haskell
f :: a -> a -> a -> a
f a b c = a + b + c

(f <$>) :: f a -> f (a -> a -> a)
(f <$> Just 1 <*>) :: f a -> f (a -> a)
(f <$> Just 1 <*> Just 1 <*>) :: f a -> f a
```


## Bringing this all together {#bringing-this-all-together}

So we have the ability to transform the inner value of a context, we have the
ability to compose two or more contexts together. The problem arises when we want to
compute the next context based on the result of the previous. Look again at the
type of `<*>`

```haskell
(<*>) :: f (a -> b) -> f a -> f b
```

we know the end goal of this computation as all `<*>` is doing is satsfying the contexed
function. This limits us to computations where we can reason about the end
result. What about a computation where we can't, where we need to think about the
last computation before we move on. This is a power monads have.

Lets revist the type of `>>=`

```haskell
(>>=) :: m a -> (a -> m b) -> m b
```

The first argument is a contexted value, You can reason about it like its some
kind of computation. This computation is then "unwrapped" and passed into a
function which crucially _can decide what to do_. We do not need to think about
whatever end goal we want right at the beginning, we can go as the wind tells us,
so to speak. This is useful in places we need to parse some kind of context, for
example a context filled language such as some markup languages, [including the
one I am currently writing this post in](https://orgmode.org/).


## A monad in plain sight {#a-monad-in-plain-sight}

So we have discussed what all of these things are but lets discuss a real world
monad, One that you probably have already used. The Async Monad!

Yes if you have done Async programming then you have used a monad. Lets
have a look at an example.

```js
fetch(`http://localhost:8080/some-data`).then(response => {
    if (response.ok) {
        response.text().then(text => JSON.parse(text))
    }
})
```

Here we receive a promised response from fetch. We then unwrap its inner value and
get our response object. After playing with it, we extract out the text (which
is a Promised string) and parse it into a json object. This entire expression
returns a Promised JSON object.

In this case we take a context, unwrap it, then return back the same context
with a transformed value.

We decide as we go, Our next computation is dependent on the value of the last.

Note how `async await` is basically do notation in this case

```js
const getData = async (idx) => {
    let response = await fetch('http://localhost:8080/some-data');
    if (response.ok) {
        let text = await response.text();
        return JSON.parse(text);
    } else {
        throw new Error("An error has occured")
    }
};
```

`async` = `do`

`await` = `<-`


## Why did I write this? {#why-did-i-write-this}

This is an explainer I have done, less because I want to try and be the one to
tackle the monad fallacy but because its fun and a good way to help me solidify
what I know. Plus it may start to
help build intuitions on these types. Though it must be said

> There is no royal road to Haskell. —Euclid

The best way to learn is to get your hands on them and play with them. No amount
of theory will do you any good unless you put these ideas into practice. Once
you do you start to see the patterns and then you can really get into the meat
of them and become an epik haskeller.
Some of the resources I really like include [The Typeclassopedia](https://wiki.haskell.org/Typeclassopedia), [This video on
the IO monad,](https://www.youtube.com/watch?v=fCoQb-zqYDI) this [video implementing a json parser in haskell](https://www.youtube.com/watch?v=N9RUqGYuGfw) and [this course
from the University of Pennsylvania](https://www.cis.upenn.edu/~cis1940/spring13/lectures.html).
Though it did not really begin to click until I started playing with Async in
Dart.

Hopefully this is helpful and or interesting. If I have made a mistake or you
want to discuss this [my email is here!](mailto:jeetelongname@gmail.com)

[^fn:1]: `g <$> Just 1` will return a function with the rest of the inputs wrapped
    in a context. We need to remember that haskell is curried by default.
    So if we have a type like this `g :: a -> a -> a -> a` we _really_ mean
    `g :: a -> (a -> (a -> a))`. So when we reflect on the type of `<$> :: (a -> b)
    -> f a -> f b` we can see that the rest of our function will be "swallowed"
    b thus we get the type `g <$> :: f a -> f (a -> a -> a)`