# Package

version       = "0.1.0"
author        = "tubone24"
description   = "Watch Twitter on work"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
installExt    = @["nim"]
bin           = @["post_twitter_on_work"]



# Dependencies
requires "nim >= 1.0.0"
requires "dotenv >= 1.1.0"
requires "oauth >= 0.10"
