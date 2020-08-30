# Package

packageName   = "post_twitter_on_work"
version       = "0.1.0"
author        = "tubone24"
description   = "Twitter on work"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
installExt    = @["nim"]
bin           = @["post_twitter_on_work"]



# Dependencies

requires "nim >= 0.20.2"
requires "dotenv >= 1.1.0"

task run, "running":
  exec "nimble build"
  exec "bin/" & packageName & " nim"

