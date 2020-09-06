import httpclient, json, base64, tables, oauth1, strutils, config

const
    requestTokenUrl = "https://api.twitter.com/oauth/request_token"
    authorizeUrl = "https://api.twitter.com/oauth/authorize"
    accessTokenUrl = "https://api.twitter.com/oauth/access_token"
    homeTimelineEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json?count=200"
    mentionTimelineEndpoint = "https://api.twitter.com/1.1/statuses/mentions_timeline.json?count=200"
    userTimelineEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=200"
    trendEndpoint = "https://api.twitter.com/1.1/trends/place.json"
    authEndpoint = "https://api.twitter.com/oauth2/token"

type
  Twitter* = ref object of RootObj
    apiKey:string
    apiSecret:string
    accessToken:string
    accessTokenSecret:string
    bearerToken*: string
    tweets*: JsonNode
    sinceId*: string
  Tweet* = ref object of RootObj
    createdAt*: string
    text*: string
    name*: string
    profileImageUrlHttps*: string
    screenName*: string


proc parseResponseBody(body: string): Table[string, string] =
  let responses = body.split("&")
  result = initTable[string, string]()
  for response in responses:
    let r = response.split("=")
    result[r[0]] = r[1]

proc getBearerToken(apiKey:string, apiSecret:string):string =
  let client = newHttpClient()
  let credentials = encode(apiKey & ":" & apiSecret)
  client.headers = newHttpHeaders({
    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
    "Authorization": "Basic " & credentials
  })
  let body = "grant_type=client_credentials"
  let response = client.request(authEndpoint, httpMethod = HttpPost, body = body)
  let bearerToken = parseJson(response.body)["access_token"].getStr()
  return bearerToken

proc getAccessToken(apiKey:string, apiSecret:string):Table[string, string] =
  let
    client = newHttpClient()
    requestTokenResponse = client.getOAuth1RequestToken(requestTokenUrl, apiKey, apiSecret, isIncludeVersionToHeader = true)
    requestTokenBody = parseResponseBody(requestTokenResponse.body)
    requestToken = requestTokenBody["oauth_token"]
    requestTokenSecret = requestTokenBody["oauth_token_secret"]
  echo "Access the url, please obtain the verifier key."
  echo getAuthorizeUrl(authorizeUrl, requestToken)
  echo "Please enter a verifier key (PIN code)."
  let
    verifier = readLine stdin
    accessTokenResponse = client.getOAuth1AccessToken(accessTokenUrl, apiKey, apiSecret, requestToken, requestTokenSecret, verifier, isIncludeVersionToHeader = true)
    accessTokenResponseBody = parseResponseBody(accessTokenResponse.body)
    accessToken = accessTokenResponseBody["oauth_token"]
    accessTokenSecret = accessTokenResponseBody["oauth_token_secret"]
  result = initTable[string, string]()
  result["accessToken"]  = accessToken
  result["accessTokenSecret"]  = accessTokenSecret

proc newTwitter*(apiKey:string, apiSecret:string, accessToken:string, accessTokenSecret:string):Twitter =
  let tw = new Twitter
  tw.apiKey = apiKey
  tw.apiSecret = apiSecret
  tw.accessToken = accessToken
  tw.accessTokenSecret = accessTokenSecret
  if tw.accessToken == "" and tw.accessTokenSecret == "":
    let tokens = getAccessToken(tw.apiKey, tw.apiSecret)
    tw.accessToken = tokens["accessToken"]
    tw.accessTokenSecret = tokens["accessTokenSecret"]
    discard setConfig("auth", "accessToken", tw.accessToken)
    discard setConfig("auth", "accessTokenSecret", tw.accessTokenSecret)
  tw.bearerToken = getBearerToken(tw.apiKey, tw.apiSecret)
  return tw

proc getHomeTimeline*(tw:Twitter, sinceId: string = ""):JsonNode =
  let client = newHttpClient()
  var url: string
  if sinceId == "":
    url = homeTimelineEndpoint
  else:
    url = homeTimelineEndpoint & "&since_id=" & sinceId
  let timeline = client.oAuth1Request(url, tw.apiKey, tw.apiSecret, tw.accessToken, tw.accessTokenSecret, isIncludeVersionToHeader = true)
  try:
    tw.tweets = parseJson(timeline.body)
  except JsonParsingError:
    echo timeline.headers
    echo timeline.body

iterator getTweetIter*(tw:Twitter):Tweet =
  for i in countdown(tw.tweets.len - 1, 0):
    let tweetObj = new Tweet
    tweetObj.createdAt = tw.tweets[i]["created_at"].getStr()
    tweetObj.text = tw.tweets[i]["text"].getStr()
    tweetObj.screenName = tw.tweets[i]["user"]["screen_name"].getStr()
    tweetObj.name = tw.tweets[i]["user"]["name"].getStr()
    tweetObj.profileImageUrlHttps = tw.tweets[i]["user"]["profile_image_url_https"].getStr()
    tw.sinceId = tw.tweets[i]["id_str"].getStr()
    yield tweetObj

proc getMentionTimeline*(tw:Twitter, sinceId: string = ""):JsonNode =
  let client = newHttpClient()
  var url: string
  if sinceId == "":
    url = mentionTimelineEndpoint
  else:
    url = mentionTimelineEndpoint & "&since_id=" & sinceId
  let timeline = client.oAuth1Request(url, tw.apiKey, tw.apiSecret, tw.accessToken, tw.accessTokenSecret, isIncludeVersionToHeader = true)
  try:
    tw.tweets = parseJson(timeline.body)
  except JsonParsingError:
    echo timeline.headers
    echo timeline.body

proc getUserTimeline*(tw:Twitter, username: string, sinceId: string = ""):JsonNode =
  let client = newHttpClient()
  var url: string
  if sinceId == "":
    url = mentionTimelineEndpoint & "&screen_name=" & username
  else:
    url = mentionTimelineEndpoint & "screen_name=" & username & "&since_id=" & sinceId
  let timeline = client.oAuth1Request(url, tw.apiKey, tw.apiSecret, tw.accessToken, tw.accessTokenSecret, isIncludeVersionToHeader = true)
  try:
    tw.tweets = parseJson(timeline.body)
  except JsonParsingError:
    echo timeline.headers
    echo timeline.body
