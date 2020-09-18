import parsecfg, os, secret

type
  TwitterConfig* = ref object of RootObj
    appKey*: string
    appKeySecret*: string
    accessToken*: string
    accessTokenSecret*: string

proc createSettingCfg() {.discardable.} =
  block:
    let f : File = open(joinPath(getAppDir(),"settings.cfg") ,FileMode.fmWrite)
    f.writeLine("[auth]")
    f.writeLine("appKey=\"\"")
    f.writeLine("appKeySecret=\"\"")
    f.writeLine("accessToken=\"\"")
    f.writeLine("accessTokenSecret=\"\"")
    defer:
      close(f)

proc getConfig*():TwitterConfig =
 if not os.existsFile("settings.cfg") and not os.existsFile(joinPath(getAppDir(),"settings.cfg")):
   createSettingCfg()
 var cfg: Config
 if os.existsFile("settings.cfg"):
   cfg = loadConfig("settings.cfg")
 elif os.existsFile(joinPath(getAppDir(),"settings.cfg")):
   cfg = loadConfig(joinPath(getAppDir(),"settings.cfg"))
 result = new TwitterConfig
 if cfg.getSectionValue("auth", "appKey") == "" and cfg.getSectionValue("auth", "appKeySecret") == "":
   result.appKey = getDefaultAppKey()
   result.appKeySecret = getDefaultAppKeySecret()
 else:
   result.appKey = cfg.getSectionValue("auth", "appKey")
   result.appKeySecret = cfg.getSectionValue("auth", "appKeySecret")
 result.accessToken = cfg.getSectionValue("auth", "accessToken")
 result.accessTokenSecret = cfg.getSectionValue("auth", "accessTokenSecret")

proc setConfig*(section: string, key: string, value: string):TwitterConfig =
  var cfg: Config
  if os.existsFile("settings.cfg"):
    cfg = loadConfig("settings.cfg")
  elif os.existsFile(joinPath(getAppDir(),"settings.cfg")):
    cfg = loadConfig(joinPath(getAppDir(),"settings.cfg"))
  cfg.setSectionKey(section, key, value)
  cfg.writeConfig("settings.cfg")
  return getConfig()