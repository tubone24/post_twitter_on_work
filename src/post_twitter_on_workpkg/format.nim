import strutils, unicode, times, twitter

proc wrapWords*(str: string, wrapLen: int = 100): string =
  let rune = str.toRunes
  var wrappedWord: seq[Rune]
  for s in countup(0, rune.len, wrapLen):
    if s + wrapLen < rune.len:
      wrappedWord = wrappedWord & rune[s..s + wrapLen]
    else:
      wrappedWord = wrappedWord & rune[s..rune.len - 1]
  return $wrappedWord

proc dateFormat*(str: string): string =
  result = str.parse("ddd MMM d HH:mm:ss zz'00' YYYY").format("yyyy/MM/dd HH:mm:ss")

proc formatTweet*(tweet: Tweet) =
  block:
    let header = tweet.name & "(" & tweet.screenName & ") at " & dateFormat(tweet.createdAt)
    echo header
    echo indent(wrapWords(tweet.text), 4)
