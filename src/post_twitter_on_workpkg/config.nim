import os, parsecfg, strutils, streams

type
  Config* = ref object of RootObj
    appKey: string
    appKeySecret: string
    accessToken: string
    accessTokenSecret: string

proc getConfig():
   let cfg = loadConfig("settings.cfg")

