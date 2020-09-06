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

proc setConfig*(section: string, key: string, value: string):Config =
  var cfg = loadConfig("settings.cfg")
  cfg.setSectionKey(section, key, value)
  cfg.writeConfig("settings.cfg")
  return getConfig()

