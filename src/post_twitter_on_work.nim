import dotenv, os
import post_twitter_on_workpkg/twitter, post_twitter_on_workpkg/config, post_twitter_on_workpkg/format, post_twitter_on_workpkg/utils

# let env = initDotEnv()
# env.load()

when isMainModule:
  # let tw = newTwitter(getEnv("appKey"), getEnv("appKeySecret"), getEnv("accessToken"), getEnv("accessTokenSecret"))
  let conf = getConfig()
  let tw = newTwitter(conf.appKey, conf.appKeySecret, conf.accessToken, conf.accessTokenSecret)
  let tweets = tw.getHomeTimeline()
  for tweet in tw.getTweetIter():
    formatTweet(tweet)
  while true:
    sleepSeveralSeconds(60)
    let tweets = tw.getHomeTimeline(tw.sinceId)
    for tweet in tw.getTweetIter():
      formatTweet(tweet)
