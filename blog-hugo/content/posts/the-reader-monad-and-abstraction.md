---
title: "The Reader Applicative and abstraction"
date: 2023-04-10T02:43:00+01:00
tags: ["haskell", "programming"]
draft: false
---

Now this is not a haskell blog site but this is the second interesting thing
haskell has offered me.

Today we are discussing the curious nature of the Reader monad
(well the Reader applicative functor as I don't plan on delving into the
monad aspects a terrible amount)

To do this we will be discussing this pairs function.

```haskell
pairs :: [a] -> [(a, a)]
pairs = zip <*> tail
```

On the surface its all weird and magical, but we will walk through the types and
the implementations so that we can maybe pick up an intuition on how this works
in general.

Now this function takes in a list and constructs a list of pairs, where the
second slot is the item over in the list from the first slot.
We can define it like this.

```haskell
pairs lst = zip lst (tail lst)

print $ [1..5]
print $ pairs [1..5]
```

```text
[1,2,3,4,5]
[(1,2),(2,3),(3,4),(4,5)]
```

Now the question becomes, how does the first become the second using the Reader
applicative? How does the type work out in such a neat fashion? How does this really
abstract thing turn into something so concrete and useful? Well fear not dear
_reader_ we will answer these questions in due course.


## How do these types work out? {#how-do-these-types-work-out}

Lets start off with the types

```haskell
(<*>) :: Applicative m => m (a -> b) -> m a -> m b
```

This is the general type of the `ap` operator but in this case we are working with
the Reader applicative. In that case we need to see what it looks like when we
collapse the constraint.

```haskell
(<*>) :: (r -> (a -> b)) -- (1)
      -> (r -> a)        -- (2)
      -> (r -> b)        -- (3)
```

To anyone who has worked with haskell a little bit, this should be _readable_.

1.  is a function that takes in a value `r` and returns a function from `a` to `b`
2.  is a function from `r` to `a`
3.  is a function from `r` to `b`. This is our return value.

where `r` `a` and `b` are type variables that will collapse as we apply arguments.
Note how our context is this `(r -> ...)` function. This means ours functions have
to take in the same first argument. You can intuit this as an "environment"
these functions take in, though we will discuss the uses of the Reader monad in
a bit.

We can actually clean this up a little bit, the `->` operator is right associative
meaning `a -> b -> c -> d` is the same as `a -> (b -> (c -> d))`.
With this knowledge in hand our type before turns into.

```haskell
(<*>) :: (r -> a -> b)
      -> (r -> a)
      -> r
      -> b
```

Here we can see something, our first argument is a function from `r` to `a` to `b`,
our, second argument is a function from `r` to `a`, This suggests we will combine
these functions so that the second argument to the first function is the result
of the second function (wordy I known). We also see how the return type `b` in the
first function is also the return type of the `ap` operator itself. This type is
pretty good at hinting both what this function takes in, and also how its
combining our arguments under the hood.

Now lets have a look at the types of `zip` and `tail`

```haskell
zip :: [a'] -> [b'] -> [(a', b')]
tail :: [a'] -> [a']
```

We can see both of these functions take in an `[a']` and then do something with
that. In other words our `[a']` becomes our `r`. We can continue this process of
subbing types into our `ap` operator.

```haskell
zip :: [a'] -> [b'] -> [(a', b')]
  thus
    r :: [a']
    a :: [b']
    b :: [(a', b')]
```

When we fill in our type with this information we can see our type popping out.

```haskell
(zip <*>) :: ([a'] -> [b']) -> [a'] -> [(a', b')]
```

adding `tail` into the mix constrains the type of `b'` even further

```haskell
tail :: [a'] -> [a']
  thus
     b' :: a'
```

applying this gives us our final type.

```haskell
(zip <*> tail) :: [a'] -> [(a', a')]
```

Congrats, we have now manually done the job of the haskell type checker.
Hopefully now we now see how just by following the types and using abstractions
we have come back to the _type_ of thing we want to do. This is nice and all but
what about the actual implementation? the type is useless if it does not follow
our logic.


## Why does the implementation work out? {#why-does-the-implementation-work-out}

the implementation of our `ap` operator for our Reader Applicative is as follows

```haskell
(<*>) :: (r -> a -> b) -> (r -> a) -> r -> b
(<*>) f g r = f r (g r)
```

If we sub in our functions, we see our implementation pop out.

```haskell
(<*>) zip tail lst :: [(a, a)]
(<*>) zip tail lst = zip lst (tail lst)
```

This leads us back to `pairs = zip <*> tail`, which becomes our final implementation.


## So now why does the reader monad exist? {#so-now-why-does-the-reader-monad-exist}

Before we delve into that, we need discuss why we use applicatives and monads.
This was discussed in more detail in my [understanding monads post](/blog/posts/understanding-monads)
but here is a smaller run down.

An applicative functor allows us to compose contexts together into larger ones,
like we have seen. It allows for a lot of very interesting abstractions such as
parser combinators&nbsp;[^fn:1] as well as many other use cases (note that all monads
you have played with also are applicatives). We see here how we have taken two
functions that take in the same first argument and use the reader applicative to
combine them into something larger. This scales.

```haskell
zip3 :: [a] -> [b] -> [c] -> [(a, b, c)]
(zip3 <*>) :: ([a] -> [b]) -> [a] -> [c] -> [(a, b, c)]
(zip3 <*> map show) :: Show a => [a] -> [c] -> [(a, String, c)]
(zip3 <*> map show <*> map even) :: (Show a, Integral a) => [a] -> [(a, String, Bool)]
```

Here we essentially collect transformations of a list of type `[a]` Each function
on the left hand side receives this `[a]` but its the responsibility of the left
most function to collect it all together. This is a small contrived example, yet
the rules here would apply to any set of functions that take in the
same first argument.

Here we have a type with three parameters, we have functions that
extract out the information from a single string.

```haskell
data Person = Person {name :: String, age :: Int, job :: String}

constructType :: String -> Person
constructType str = Person
                        (extractName str)
                        (extractAge str)
                        (extractJob str)
```

but now instead of passing in str manually we can use this Reader applicative to pass
this "environment" implicitly.

```haskell
constructType :: String -> Person
constructType = Person <$> extractName <*> extractAge <*> extractJob
```

Again here follow the types. `<$>` is fmap, it lifts `Person` from a simple function
to a function that works with our Reader applicative.

```haskell
(Person <$>) :: r -> String -> r -> (Int -> String -> Person)
```

We can then keep on adding functions with the use of our `<*>` operator like so

```haskell
(Person <$>) :: r -> String -> r -> (Int -> String -> Person)
(Person <$> extractName <*>) :: r -> Int -> (String -> Person)
(Person <$> extractName <*> extractAge) :: r -> String -> Person
(Person <$> extractName <*> extractAge <*> extractJob) :: r -> Person
```

We take this further with monads, where we can use the latter computation to
inform the next. It allows us to combine these computations together using
context.

Its why the IO monad works so nicely. With the Reader monad it allows us to
compose together computations which all need some kind of shared read only state. Useful
when passing around things like app configurations (Values such as database
configuration or network settings that only become known at deploy time), or
something like react props

This post only really focused on the Reader applicative, If you want to see how
the reader _monad_ have a look at [this post from dollar shave club](https://engineering.dollarshaveclub.com/the-reader-monad-example-motivation-542c54ccfaa8).


## The neatness of abstraction. {#the-neatness-of-abstraction-dot}

We have now used abstract tools to solve our concrete problems, Why is this
neat? Well now that we have expressed our solution in terms of this abstraction,
we can use all of the tools and types of this abstraction to aid us further.

take for example the function `sequenceA`

```haskell
sequenceA :: (Traversable t, Applicative f) => t (f a) -> f (t a)
```

here we can see it essentially can turn a type inside out, Now this may not seem
useful now but imagine what it would look like if we collapse the constraints.

```haskell
sequenceA :: [r -> a] -> r -> [a]
```

Here we have a function that takes in a list of functions from `r` to `a` and then
it returns a function from `r` to `[a]`

In other words, we can perform a set of transformations on a single value.

```haskell
sequenceA [(+1), (+2), (+3)] 1
```

|   |   |   |
|---|---|---|
| 2 | 3 | 4 |

This may seem contrived but you can imagine use cases. We need to pass a user
given value through a gauntlet of checks. or we take in a value and need multipe
permutations of it and so on. I am sure that people are more creative than me.

Just by re-framing our problem using this abstraction, we have turned
something pretty manual and "low level" into something smaller, easier to extend
and nicer, and thats pretty neat.


## Conclusion {#conclusion}

Hopefully now you have a small intuition on the Reader Applicitive, The Reader
Monad is another beast but now you have the basics of the type out of the way
you can pick up that a with a little less head scratching.

Again this was not written to be useful but if you did find it useful feel free
to email me, (its somewhere on this site).


## Appendix {#appendix}

So there is actually another version of the `ap` operator that is implemented in
terms of the Reader monad

```haskell
pairs = ap zip tail
```

This is a historical artifact as Monads are older than Applicatives, but
it means we now have another way of framing the problem. As the type is
essentially the same (Just constrained to Monads) all of the type work we did
still _applies_ but the implementation and how we get back to our first solution
is interesting.

the implementation of ap is as follows

```haskell
ap m1 m2 = do { x1 <- m1; x2 <- m2; return (x1 x2) }
```

as do notation is syntax sugar for `>>=` lets get rid of it

```haskell
ap m1 m2 = m1 >>= (\x1 -> m2 >>= (\x2 -> return (x1 x2)))
```

The implementation of `>>=` and `return` are as follows

```haskell
(>>=)  :: (r -> a) -> (a -> r -> b) -> r -> b
f >>= k = \r -> k (f r) r

return :: a -> r -> a
return = const
```

With this we can start to sub

```haskell
-- return = const
ap zip tail = zip >>= (\x1 -> tail >>= (\x2 -> const (x1 x2)))
-- sub inner >>=
ap zip tail = zip >>= (\x1 -> (\r2 -> (\x2 -> const (x1 x2)) (tail r2) r2)
-- sub outer >>=
ap zip tail = (\r1 -> (\x1 -> (\r2 -> (\x2 -> const (x1 x2)) (tail r2) r2)) (zip r1) r1)
-- move r1 to the left hand side
ap zip tail r1 = (\x1 -> (\r2 -> (\x2 -> const (x1 x2)) (tail r2) r2)) (zip r1) r1
-- replace x1 with (zip r1)
ap zip tail r1 = (\r2 -> (\x2 -> const ((zip r1) x2)) (tail r2) r2) r1
-- replace x2 with (tail r2)
ap zip tail r1 = (\r2 -> const ((zip r1) (tail r2)) r2) r1
-- replace r2 with r1
ap zip tail r1 = const ((zip r1) (tail r1)) r1
-- const x = (\y -> x)
ap zip tail r1 = (\c1 -> ((zip r1) (tail r1))) r1
-- replace c1 with r1
ap zip tail r1 = ((zip r1) (tail r1))
-- clean up
ap zip tail r = (zip r) (tail r)
```

Easy to read, I know. This took me a while to work out but playing with it
helped quite a bit.

[^fn:1]: For those out of the loop, Parser combinators is a way to build up a
    parser by composing smaller parsers together. [This video by the Tsoding really
    helped me pick it up](https://www.youtube.com/watch?v=N9RUqGYuGfw). Its also the basis for libraries such as [Parsec](https://hackage.haskell.org/package/parsec) and
    other libraries that follow in its wake