import os

proc sleepSeveralSeconds*(seconds: int) {.discardable.} =
  for i in 0..seconds:
    sleep(1000)
    stdout.write(".")
  echo("")
