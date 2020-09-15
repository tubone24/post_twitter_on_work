import os, strutils

proc sleepSeveralSeconds*(seconds: int) {.discardable.} =
  for i in 0..seconds:
    sleep(1000)
    stdout.write(".")
  echo("")

proc removeUserAtmark*(str: string): string =
  return str.strip(trailing = false, chars = {'@'})
