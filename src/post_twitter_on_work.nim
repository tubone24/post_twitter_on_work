import dotenv, os
import post_twitter_on_workpkg/twitter, post_twitter_on_workpkg/config, post_twitter_on_workpkg/format

# let env = initDotEnv()
# env.load()

when isMainModule:
  # let tw = newTwitter(getEnv("appKey"), getEnv("appKeySecret"), getEnv("accessToken"), getEnv("accessTokenSecret"))
  let conf = getConfig()
  let tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
  let tweets = tw.getTimeline()
  for tweet in tw.getTweetIter():
    formatTweet(tweet)
