import httpclient, json, base64, tables, oauth1, strutils

const
    requestTokenUrl = "https://api.twitter.com/oauth/request_token"
    authorizeUrl = "https://api.twitter.com/oauth/authorize"
    accessTokenUrl = "https://api.twitter.com/oauth/access_token"
    requestUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"

type
  Twitter* = ref object of RootObj
    apiKey:string
    apiSecret:string
    accessToken:string
    accessTokenSecret:string
    bearerToken*: string

proc auth(apiKey:string, apiSecret:string):string =
  const authEndpoint = "https://api.twitter.com/oauth2/token"
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

proc parseResponseBody(body: string): Table[string, string] =
  let responses = body.split("&")
  result = initTable[string, string]()
  for response in responses:
    let r = response.split("=")
    result[r[0]] = r[1]

proc newTwitter*(apiKey:string, apiSecret:string, accessToken:string, accessTokenSecret:string):Twitter =
  let tw = new Twitter
  tw.apiKey = apiKey
  tw.apiSecret = apiSecret
  tw.accessToken = accessToken
  tw.accessTokenSecret = accessTokenSecret
  tw.bearerToken = auth(tw.apiKey, tw.apiSecret)
  return tw

proc getTimeline*(tw:Twitter):string =
  const homeTimelineEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
  let client = newHttpClient()
  let timeline = client.oAuth1Request(homeTimelineEndpoint, tw.apiKey, tw.apiSecret, tw.accessToken, tw.accessTokenSecret, isIncludeVersionToHeader = true)
  echo timeline.body

