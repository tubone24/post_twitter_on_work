import unittest
import post_twitter_on_workpkg/utils

suite "removeUserAtmark":
  setup:
    var input: string
  test "testOK":
    input = "@meitante1conan"
    check removeUserAtmark(input) == "meitante1conan"
  test "testOK_noatmark":
    input = "meitante1conan"
    check removeUserAtmark(input) == "meitante1conan"
  test "testOK_training":
    input = "meitante1conan@"
    check removeUserAtmark(input) == "meitante1conan@"
  test "testOK_middle":
    input = "meitante1@conan"
    check removeUserAtmark(input) == "meitante1@conan"

suite "exponentialBackoff":
  setup:
    var input: int
  test "testOK":
    input = 1
    check exponentialBackoff(input) == 1
    input = 2
    check exponentialBackoff(input) == 3
  test "testminus":
    input = -1
    check exponentialBackoff(input) == 0
    input = -2
    check exponentialBackoff(input) == 0
  test "test0":
    input = 0
    check exponentialBackoff(input) == 0

suite "removeHtmlTag":
  setup:
    var input: string
  test "testOK":
    input = "<a href=\"https://mobile.twitter.com\" rel=\"nofollow\">Twitter Web App</a>"
    check removeHtmlTag(input) == "Twitter Web App"
  test "long text":
    input = """<html><head><title>aaa<title></head><body>test</body></html>"""
    check removeHtmlTag(input) == "aaatest"
