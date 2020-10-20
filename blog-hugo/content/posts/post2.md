---
title: "Compiling Emacs from source"
date: 2020-09-10T21:06:45+01:00 
description: "I did not have a fun time hand rolling my own build of emacs. So I am writing this guide to remind my self what to do"
tags: [Emacs,Tech,Guides,]
draft: true
---
---
## Compiling emacs is not all that bad...
Emacs is one of those things that you can use for a lifetime. But you can't use
the same version for a lifetime. One day you will have to upgrade your version.
Whether that be because of nessity or curoisity is not up to me. I am just  guy
who wants to make this ordeal go a heck of a lot faster

## Prereqisites

To compile emacs you will need...

- a set of build tools. This will include
  - make
  - the gcc compiler (or any c compiler)
  - libc6 
  - git
  - the gnu coreutils
  - autoconf and automake
  
On debian based systems this is as easy as a `sudo apt install build-essential`
I don't really use any other systems you will need to install them but If you
know the packages [mail me!](mailto:jeetelongname@gmail.com) 
We also need some dependency's

- GNU tls 

## Cloning
You can get the source code by either cloning the repository or getting a tar
file. the steps are mostly the same but the way you get them and the
pre-processing you will need to do is not 

### Tar file

### Git cloning 
## Configuration
## Building
## Installing
 after you have built it and verified it is working then you can do a `sudo make
 install` this will copy over all the files into your path and essentially
 install emacs. You should be done after this!
 
## Troubleshooting
If you have run the `make clean` command then you won't be able to use that
repository to build emacs there may be a way to restore it but i dont know what
it is. I recommend not using the `make clean` command and just rebuilding on top
## Finishing up
