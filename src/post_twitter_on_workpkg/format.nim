import strutils, unicode, times, terminal, twitter, utils

proc wrapWords*(str: string, wrapLen: int = 100): string =
  let rune = str.toRunes
  var wrappedWord: seq[Rune]
  for s in countup(0, rune.len, wrapLen):
    if s + wrapLen < rune.len:
      wrappedWord = wrappedWord & rune[s..s + wrapLen - 1] & "\n".toRunes
    else:
      wrappedWord = wrappedWord & rune[s..rune.len - 1]
  return $wrappedWord

proc dateFormat*(str: string): string =
  result = str.parse("ddd MMM d HH:mm:ss zz'00' YYYY").format("yyyy/MM/dd HH:mm:ss")

proc formatTweet*(tweet: Tweet) =
  block:
    let header = tweet.user.name & "(@" & tweet.user.screenName & ") at " & dateFormat(tweet.createdAt)
    styledWriteLine(stdout, fgBlack, bgGreen, header, resetStyle)
    echo indent(wrapWords(tweet.text), 4)
    let footer = "RT: " & $tweet.retweetCount & "  Fav: " & $tweet.favoriteCount & "   (" & removeHtmlTag(tweet.source) & ")"
    styledWriteLine(stdout, fgBlack, bgCyan, footer, resetStyle)

proc formatList*(list: List) =
  block:
    echo list.slug & "(" & list.fullName & "): " & list.mode & " - " & list.uri
    echo "    " & list.description
    echo ""
