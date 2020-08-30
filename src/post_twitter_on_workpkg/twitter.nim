import httpclient, json, base64, tables, oauth1, strutils

const
    requestTokenUrl = "https://api.twitter.com/oauth/request_token"
    authorizeUrl = "https://api.twitter.com/oauth/authorize"
    accessTokenUrl = "https://api.twitter.com/oauth/access_token"
    homeTimelineEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    authEndpoint = "https://api.twitter.com/oauth2/token"

type
  Twitter* = ref object of RootObj
    apiKey:string
    apiSecret:string
    accessToken:string
    accessTokenSecret:string
    bearerToken*: string

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
  let client = newHttpClient()
  let requestTokenResponse = client.getOAuth1RequestToken(requestTokenUrl, apiKey, apiSecret, isIncludeVersionToHeader = true)
  let requestTokenBody = parseResponseBody(requestTokenResponse.body)
  let requestToken = requestTokenBody["oauth_token"]
  let requestTokenSecret = requestTokenBody["oauth_token_secret"]
  echo "Access the url, please obtain the verifier key."
  echo getAuthorizeUrl(authorizeUrl, requestToken)
  echo "Please enter a verifier key (PIN code)."
  let verifier = readLine stdin
  let accessTokenResponse = client.getOAuth1AccessToken(accessTokenUrl, apiKey, apiSecret, requestToken, requestTokenSecret, verifier, isIncludeVersionToHeader = true)
  let accessTokenResponseBody = parseResponseBody(accessTokenResponse.body)
  let accessToken = accessTokenResponseBody["oauth_token"]
  let accessTokenSecret = accessTokenResponseBody["oauth_token_secret"]
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
  tw.bearerToken = getBearerToken(tw.apiKey, tw.apiSecret)
  return tw

proc getTimeline*(tw:Twitter):string =
  let client = newHttpClient()
  let timeline = client.oAuth1Request(homeTimelineEndpoint, tw.apiKey, tw.apiSecret, tw.accessToken, tw.accessTokenSecret, isIncludeVersionToHeader = true)
  echo timeline.body

