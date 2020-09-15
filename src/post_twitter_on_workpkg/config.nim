import parsecfg, os, secret

type
  Config* = ref object of RootObj
    appKey*: string
    appKeySecret*: string
    accessToken*: string
    accessTokenSecret*: string

proc createSettingCfg() {.discardable.} =
  block:
    let f : File = open("settings.cfg" ,FileMode.fmWrite)
    f.writeLine("[auth]")
    f.writeLine("appKey=\"\"")
    f.writeLine("appKeySecret=\"\"")
    f.writeLine("accessToken=\"\"")
    f.writeLine("accessTokenSecret=\"\"")
    defer:
      close(f)

proc getConfig*():Config =
 if not os.existsFile("settings.cfg"):
   createSettingCfg()
 let cfg = loadConfig("settings.cfg")
 result = new Config
 if cfg.getSectionValue("auth", "appKey") == "" and cfg.getSectionValue("auth", "appKeySecret") == "":
   result.appKey = getDefaultAppKey()
   result.appKeySecret = getDefaultAppKeySecret()
 else:
   result.appKey = cfg.getSectionValue("auth", "appKey")
   result.appKeySecret = cfg.getSectionValue("auth", "appKeySecret")
 result.accessToken = cfg.getSectionValue("auth", "accessToken")
 result.accessTokenSecret = cfg.getSectionValue("auth", "accessTokenSecret")

proc setConfig*(section: string, key: string, value: string):Config =
  var cfg = loadConfig("settings.cfg")
  cfg.setSectionKey(section, key, value)
  cfg.writeConfig("settings.cfg")
  return getConfig()