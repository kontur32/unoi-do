module namespace auth = "lib/modules/auth";

(: получает токен доступа accessToken :)

declare function auth:getJWT($host, $username, $password)
{
  let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="username";'/>
            <http:body media-type = "text/plain" >{$username}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="password";' />
            <http:body media-type = "text/plain">{$password}</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        $host || "/wp-json/jwt-auth/v1/token"
    )
    return
      if($response[1]/@status/data()="200")
      then($response[2]//token/text())
      else($response)
};

(: получает access token для пользователя на сервисе аутентификации :)
declare
  %public
function auth:getAuthToken(
  $tokenEndPoint as xs:string,
  $OAuthClienID as xs:string,
  $OAuthClienSecret as xs:string,
  $code as xs:string
)
{
  let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="code";'/>
            <http:body media-type = "text/plain" >{$code}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_id";' />
            <http:body media-type = "text/plain">{$OAuthClienID}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_secret";' />
            <http:body media-type = "text/plain">{$OAuthClienSecret}</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="grant_type";' />
            <http:body media-type = "text/plain">authorization_code</http:body>
        </http:multipart> 
      </http:request>
  
  return 
      http:send-request($request, $tokenEndPoint)
};
