import parsecfg

type
  Config* = ref object of RootObj
    appKey*: string
    appKeySecret*: string
    accessToken*: string
    accessTokenSecret*: string

proc getConfig*():Config =
 let cfg = loadConfig("settings.cfg")
 result = new Config
 result.appKey = cfg.getSectionValue("auth", "appKey")
 result.appKeySecret = cfg.getSectionValue("auth", "appKeySecret")
 result.accessToken = cfg.getSectionValue("auth", "accessToken")
 result.accessTokenSecret = cfg.getSectionValue("auth", "accessTokenSecret")

