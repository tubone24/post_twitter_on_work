import strutils, pegs, unicode, twitter


proc formatTweet*(tweet: Tweet) =
  block:
    let name = tweet.name & "(" & tweet.screenName & ")"
    echo name
    echo indent(tweet.text, 4)
