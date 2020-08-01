---
title: "How to get started with Hugo and GitHub"
date: 2020-07-31
description: "There are 5 word sentences that evry person will say 'lets start a band' 'we should open a bar' and 'I can write a blog'. I hope to help with the last one"
tags: [Hugo,Tech]
draft: false
---
---
## I am no expert 

I should start this by saying I started this website a good year ago and did nothing with it. I was adamant that I would do everything in **wrought HTML** ,lets just say that was a massive mistake.
I ended up settling on a simple home page with a hugo blog to power the back-end. After multiple hiccups with finding a theme i had settled on [Tokiwa](https://github.com/heyeshuang/hugo-theme-tokiwa) for a while and all was well... that was until i tried blogging. It just would not work for me.
This is not to say that its a bad theme, It was great and it would probably have worked if I had deployed it to a server but that's neither here nor there.
I ended up settling on [Ink](https://github.com/knadh/hugo-ink/) by knadth. It was much more simple to set up and in my opinion much easier on the eyes. I am now writing this to help people not fall into the same pitholes I did.

## Prerequisites
---
you will need ...
- git or a git client (I use ma-git but i will use the comand-line for this tutorial)
- a github account and a repository
- the hugo program [(refer to the official documentation for the install)](https://gohugo.io/getting-started/installing)
- a hugo theme [(you can find them here)](https://themes.gohugo.io/)
- a text editor that can edit a toml and a markdown file (I use emacs but whatever was bundled with your system will work)
- some patients 

## Getting started.
---
1. start by making a repository for your website. title it  *yourusername*.github.io. This will be the repo that will hold all of your posts and your theme. I won't go into detail on how to make a repository but you will find details [here](https://docs.github.com/en/github/getting-started-with-github/create-a-repo) 

You need to consider
   - To make your repository public as you will not get the github page add-on
   - you need Initalise with A README. We will then clone the Repo and work on it

2. We will now clone the repository using
```shell
git clone https://github.com/*yourusername*/*yourusername*.github.io
cd *yourusername*.github.io
```
if you have hugo installed you should now run (if you don't you should really install it now)
```shell
hugo new site *your blog name*
```
this will create a bunch of directories and a "config.toml" file. We will be using this file now.
![*An example directory structure*](/dirstructure1.png "An example directory structure")
