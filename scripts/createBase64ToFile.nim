import base64, os

block:
  let str = $os.commandLineParams()[0]
  let decodedStr = decode(str)
  let f : File = open("src/post_twitter_on_workpkg/secret.nim" ,FileMode.fmWrite)
  f.writeLine(decodedStr)
  defer:
    close(f)


