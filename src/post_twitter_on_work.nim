import dotenv, os
import post_twitter_on_workpkg/twitter

let env = initDotEnv()
env.load()

when isMainModule:
  let tw = newTwitter(getEnv("appKey"), getEnv("appKeySecret"), getEnv("accessToken"), getEnv("accessTokenSecret"))
  echo tw.bearerToken
  let tweets = tw.getTimeline()
  for tweet in tw.getTweetIter():
    echo tweet.text
    echo tweet.screenName
