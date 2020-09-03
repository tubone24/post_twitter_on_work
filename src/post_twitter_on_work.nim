import dotenv, os
import post_twitter_on_workpkg/twitter, post_twitter_on_workpkg/config

# let env = initDotEnv()
# env.load()

when isMainModule:
  # let tw = newTwitter(getEnv("appKey"), getEnv("appKeySecret"), getEnv("accessToken"), getEnv("accessTokenSecret"))
  let conf = getConfig()
  let tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
  echo tw.bearerToken
  let tweets = tw.getTimeline()
  for tweet in tw.getTweetIter():
    echo tweet.text
    echo tweet.screenName
