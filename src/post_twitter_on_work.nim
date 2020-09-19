const doc = """
Overview:
  Get Tweets on CLI for Nim Client

Usage:
  post_twitter_on_work status
  post_twitter_on_work home [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work mention [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work user <username> [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work search <query> [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work list [-u|--user=<userName>] [-s|--slug=<slugName>] [-l|--listId=<id>] [-r|--resetToken] [-i|--interval=<seconds>]
  post_twitter_on_work post <text> [-r|--resetToken]

Options:
  status                      Get status
  home                        Get home timeline
  mention                     Get mention timeline
  user                        Get user timeline
  search                      Get twitter search
  list                        Get twitter list
  post                        Post Tweet
  <username>                  Twitter username
  <query>                     Search query keyword
  <text>                      Tweet text
  -i, --interval=<seconds>    Get tweet interval (defaults 60 second)
  -r, --resetToken            Reset accessToken when change user account
"""

import os, strutils
import docopt
import post_twitter_on_workpkg/twitter, post_twitter_on_workpkg/config, post_twitter_on_workpkg/format, post_twitter_on_workpkg/utils


proc main() =
  let args = docopt(doc, version = "0.1.0")
  if args["status"]:
    echo("HelloWorld")
  if args["home"]:
    var sleepInterval: int
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    if args["--interval"]:
      sleepInterval = parseInt($args["--interval"])
    else:
      sleepInterval = 60
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
      tweets = tw.getHomeTimeline()
    for tweet in tw.getTweetIter():
      formatTweet(tweet)
    while true:
      sleepSeveralSeconds(sleepInterval)
      let tweets = tw.getHomeTimeline(tw.sinceId)
      for tweet in tw.getTweetIter():
        formatTweet(tweet)
  if args["mention"]:
    var sleepInterval: int
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    if args["--interval"]:
      sleepInterval = parseInt($args["--interval"])
    else:
      sleepInterval = 60
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
      tweets = tw.getMentionTimeline()
    for tweet in tw.getTweetIter():
      formatTweet(tweet)
    while true:
      sleepSeveralSeconds(sleepInterval)
      let tweets = tw.getMentionTimeline(tw.sinceId)
      for tweet in tw.getTweetIter():
        formatTweet(tweet)
  if args["user"]:
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
      tweets = tw.getUserTimeline(removeUserAtmark($args["<username>"]))
    if args["--interval"]:
      let sleepInterval = parseInt($args["--interval"])
      for tweet in tw.getTweetIter():
        formatTweet(tweet)
      while true:
        sleepSeveralSeconds(sleepInterval)
        let tweets = tw.getUserTimeline(removeUserAtmark($args["<username>"]), tw.sinceId)
        for tweet in tw.getTweetIter():
          formatTweet(tweet)
    else:
      for tweet in tw.getTweetIter():
        formatTweet(tweet)
  if args["search"]:
    var sleepInterval: int
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    if args["--interval"]:
      sleepInterval = parseInt($args["--interval"])
    else:
      sleepInterval = 60
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
      tweets = tw.getSearch($args["<query>"])
    for tweet in tw.getSearchIter():
      formatTweet(tweet)
    while true:
      sleepSeveralSeconds(sleepInterval)
      let tweets = tw.getSearch($args["<query>"], tw.sinceId)
      for tweet in tw.getSearchIter():
        formatTweet(tweet)
  if args["post"]:
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
    echo(tw.postTweet($args["<text>"]))
  if args["list"]:
    if args["--resetToken"]:
      discard setConfig("auth", "accessToken", "")
      discard setConfig("auth", "accessTokenSecret", "")
    let
      conf = getConfig()
      tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
    discard tw.getListList(removeUserAtmark($args["<username>"]))
    for list in tw.gettListListIter():
      formatList(list)

when isMainModule:
  main()
