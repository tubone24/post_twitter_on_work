import httpclient, json, base64

type
  Twitter* = ref object of RootObj
    apiKey:string
    apiSecret:string
    accessToken:string
    accessTokenSecret:string
    bearerToken*: string

proc newTwitter*(apiKey:string, apiSecret:string, accessToken:string, accessTokenSecret:string):Twitter =
  let tw = new Twitter
  tw.apiKey = apiKey
  tw.apiSecret = apiSecret
  tw.accessToken = accessToken
  tw.accessTokenSecret = accessTokenSecret
  return tw

proc auth*(tw:Twitter):string =
  const authEndpoint = "https://api.twitter.com/oauth2/token"
  let client = newHttpClient()
  let credentials = encode(tw.apiKey & ":" & tw.apiSecret)
  client.headers = newHttpHeaders({
    "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8",
    "Authorization": "Basic " & credentials
  })
  let body = "grant_type=client_credentials"
  let response = client.request(authEndpoint, httpMethod = HttpPost, body = body)
  tw.bearerToken = parseJson(response.body)["access_token"].getStr()

