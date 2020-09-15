import httpclient, oauth1

proc retryoAuth1Request*(client: HttpClient, url: string, apiKey: string, apiSecret: string, accessToken: string, accessTokenSecret: string, isIncludeVersionToHeader: bool = true, httpMethod: HttpMethod = HttpGet, maxRetries: int = 3, retryCount: int = 0): Response  =
  try:
    result = client.oAuth1Request(url, apiKey, apiSecret, accessToken, accessTokenSecret, isIncludeVersionToHeader, httpMethod = httpMethod)
  except:
    if retryCount > maxRetries:
      raise
    result = retryoAuth1Request(client, url, apiKey, apiSecret, accessToken, accessTokenSecret, isIncludeVersionToHeader, httpMethod = httpMethod, maxRetries = maxRetries, retryCount = retryCount + 1)