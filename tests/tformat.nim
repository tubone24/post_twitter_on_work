import unittest
import post_twitter_on_workpkg/format

suite "dateFormat":
  setup:
    var input: string
  test "testOK":
    input = "Wed Oct 10 20:19:24 +0000 2018"
    check dateFormat(input) == "2018/10/11 05:19:24" #JST

suite "wrapWords":
  setup:
    var input: string
  test "testUnder100words":
    input = "腰の痛みが取れなくて早10年が経ちました。もうこの腰の痛みと向き合って一生終わるのかと思うと憂鬱ですが、そもそも運動しない私が悪いのです。"
    check wrapWords(input) == "腰の痛みが取れなくて早10年が経ちました。もうこの腰の痛みと向き合って一生終わるのかと思うと憂鬱ですが、そもそも運動しない私が悪いのです。"
  test "testOver100words":
    input = "腰の痛みが取れなくて早10年が経ちました。もうこの腰の痛みと向き合って一生終わるのかと思うと憂鬱ですが、そもそも運動しない私が悪いのです。さらに悪いことにデブになりました。太るということは腰にも悪いので腰の痛みはさらに悪化することになりました。"
    check wrapWords(input) == "腰の痛みが取れなくて早10年が経ちました。もうこの腰の痛みと向き合って一生終わるのかと思うと憂鬱ですが、そもそも運動しない私が悪いのです。さらに悪いことにデブになりました。太るということは腰にも悪いの\nで腰の痛みはさらに悪化することになりました。"
  test "0word":
    input = ""
    check wrapWords(input) == ""
  test "set wrap length 20":
    input = "腹筋は自然のコルセットとお医者さんに言われたものの運動する気になりません。"
    check wrapWords(input, 20) == "腹筋は自然のコルセットとお医者さんに言わ\nれたものの運動する気になりません。"
