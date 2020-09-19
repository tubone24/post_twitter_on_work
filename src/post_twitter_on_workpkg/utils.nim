import os, strutils, math

proc sleepSeveralSeconds*(seconds: int) {.discardable.} =
  for i in 0..seconds:
    sleep(1000)
    stdout.write(".")
  echo("")

proc removeUserAtmark*(str: string): string =
  return str.strip(trailing = false, chars = {'@'})

proc exponentialBackoff*(n: int): int =
   if n < 0:
     return 0
   else:
     return 2 ^ n - 1