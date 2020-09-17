import base64, os

block:
  let f1 : File = open("base64.txt" ,FileMode.fmRead)
  let decodedStr = decode(f1.readAll)
  let f2 : File = open("src/post_twitter_on_workpkg/secret.nim" ,FileMode.fmWrite)
  f2.writeLine(decodedStr)
  defer:
    close(f1)
    close(f2)


