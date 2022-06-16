---
title: "Moving to Wayland! Login shell lambasting"
date: 2022-06-16
tags: ["gnome", "wayland", "fix", "hack"]
draft: false
---

## The problem {#the-problem}

I have been trying to move to Wayland for the past year. The call of gestures,
less artifacting and just the _hype_ had me spell bound. The problem was,
GNOME, my DE of choice, decided to make what I think is the asinine choice to not
start the DE in a login shell. All this meant was my `.profile` never runs and my nix
environment never get set up. This is a deal breaker for me because I have
programs I use every day (principally emacs) which I can now not access.

This is not a problem though! GNOME has thought of everything! you can now
_declarativly_ declare all the environment variables you want with an
`environment.d/*.conf` file!.. Oh wait. I can't run shell scripts with that...
That's
the reason I could not use my nix programs, nix sets its environment using a set of external shell
scripts that can and do change as nix installs and removes packages. This is not
a problem for a login shell as it just runs them like any normal sourced file.
But you can't run scripts in this conf file meaning nix stays unusable.


## What was my solution then? {#what-was-my-solution-then}

Well my first port of call was of course to force GNOME to start a Wayland
session in a login shell. After all thats how other people get other Wayland
environments to respect there `.profiles`. Ez slap a `-l` in the exec call of
whatever program starts GNOME and we are golden right... Well no. While you can
wiggle GNOME into running a login shell, it seems its allergic to running in a
Wayland session. I am not sure of the black magic GNOME does to start its
Wayland session but its above my pay grade.
That being said I have tried most things from fiddling with the xsession file to
pass in a `-l` argument too making my own slightly modified `gnome-session`
start up script. They either did not spawn a Wayland session, or did not load my
`.profile` (or in one entertaining case did not launch GNOME at all, I just had
a bare x display server). In any sense it did not work and it made me sad.


### The actual solution {#the-actual-solution}

But thanks to Flat on the doom emacs discord server, for breaking me out of the
rut I was in, and inspiration from the [doom env command](https://github.com/doomemacs/doomemacs)
Instead of trying to force GNOME into the login shell, bring my login shell
(more specifically my environment) to GNOME!

This is where I ask you to flash back too 20 seconds ago
where I mentioned the `environment.d/*.conf` files. Well all we are doing is setting
environment variables with our `.profile`, if we could capture all of the
environment variables my `.profile` sets and pipe that into a conf file We would
be done! In a nice list it would take three things:

-   an empty environment to actually see _exactly_ what is being set
-   A command to run my .profile
-   a command to print all the set environment variables

The first and last are actually handled by the `env` command!  Just call it with
the `-i` flag and it starts with and empty environment! Then call it at the end
to get my list! Now to read my .profile.
Turns out we can just call `sh` with the `-l` flag to start a login shell, lik I
have been wanting to do with GNOME! This leads to this very nice one liner which
I can then redirect into a `.conf` file like so.

```shell
env -i HOME=/home/jeet sh -l -c env > ~/.config/environment.d/profile.conf
```

I don't even have to do any parsing as its already in the syntax the
`environment.d` expects!
And that was it! Just that one liner and a log out and I can finally use Wayland!
Its such a simple hack in retrospect. All I would need to do now is hook this
into running at the tail end of a nix update to recapture my environment and
this hack would be seemless!


## Conclusion {#conclusion}

The fact I have had to do this in the first place feels silly. I love GNOME and
I can understand why the devs would want to move to a more intergrated system in
a sense. Does not stop me from being mad I had to wait a year to be able to use
Wayland full time. Or that I have had to spend so much time trying to figure out
how to wiggle _my not unpopular use case_ into something usable. In any case the fix is
there, even if its not preferred, and I can move onto bigger things! This may be
the beginning of a set of posts about Wayland and my adaptations to it so stay tuned!

And if you did manage to actually get a GNOME Wayland session to start in a login
shell though please do reach out!
