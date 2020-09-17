import base64

block:
  let f : File = open("src/post_twitter_on_workpkg/secret.nim" ,FileMode.fmRead)
  defer:
    close(f)
  echo encode(f.readAll)


