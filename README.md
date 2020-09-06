# post_twitter_on_work

[![Actions Status](https://github.com/tubone24/post_twitter_on_work/workflows/Build%20Nim/badge.svg)](https://github.com/tubone24/post_twitter_on_work/actions)

> If you use it, you can watch Twitter on work.

# Setup

Use Nim and Nimble, so you should install nim (>=1.00)

```
$ nimble install -d
$ nimble build
```

## Release Build

If you would like to optimize build.

```
$ nimble build -d:release
```

# Run

## Build and Run

```
$ nimble run post_twitter_on_work
```

## Or Run builder binary 

### for LINUX

```
$ ./bin/post_twitter_on_work
```

### for Windows

```
$ bin\post_twitter_on_work.exe
```

## Usage

```
Overview:
  Get Tweets on CLI for Nim Client

Usage:
  post_twitter_on_work status
  post_twitter_on_work home [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work mention [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work user <username> [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work search <query> [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work post <text> [-r|--resetToken]

Options:
  status                      Get status
  home                        Get home timeline
  mention                     Get mention timeline
  user                        Get user timeline
  search                      Get twitter search
  post                        Post Tweet
  <username>                  Twitter username
  <query>                     Search query keyword
  <text>                      Tweet text
  -i, --interval=<seconds>    Get tweet interval (defaults 60 second)
  -r, --resetToken            Reset accessToken when change user account
```
