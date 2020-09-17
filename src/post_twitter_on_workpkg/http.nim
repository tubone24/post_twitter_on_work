import httpclient, oauth1, os

proc retryoAuth1Request*(client: HttpClient, url: string, apiKey: string, apiSecret: string, accessToken: string, accessTokenSecret: string, isIncludeVersionToHeader: bool = true, httpMethod: HttpMethod = HttpGet, maxRetries: int = 3, retryCount: int = 0): Response  =
  try:
    result = client.oAuth1Request(url, apiKey, apiSecret, accessToken, accessTokenSecret, isIncludeVersionToHeader, httpMethod = httpMethod)
  except:
    if retryCount >= maxRetries:
      raise
    sleep(1000 * retryCount)
    result = retryoAuth1Request(client, url, apiKey, apiSecret, accessToken, accessTokenSecret, isIncludeVersionToHeader, httpMethod = httpMethod, maxRetries = maxRetries, retryCount = retryCount + 1)

proc retryRequest*(client: HttpClient, url: string, httpMethod: HttpMethod = HttpGet, body = "", headers: HttpHeaders = nil, multipart: MultipartData = nil, maxRetries: int = 3, retryCount: int = 0): Response =
  try:
    result = client.request(url, httpMethod, body, headers, multipart)
  except:
    if retryCount >= maxRetries:
      raise
    sleep(1000 * retryCount)
    result = retryRequest(client, url, httpMethod, body, headers, multipart, maxRetries = maxRetries, retryCount = retryCount + 1)
