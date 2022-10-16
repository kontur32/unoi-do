module namespace oauth = "oaut/getToken/titul24";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param("code", "{$code}")
  %rest:query-param("state", "{$state}")
  %rest:path("/unoi/do/api/v01/oauthGetToken/vkID")
function oauth:vkID($code as xs:string, $state as xs:string){
  $code
};

declare 
  %rest:GET
  %rest:query-param("code", "{$code}")
  %rest:query-param("state", "{$state}")
  %rest:path("/unoi/do/api/v01/oauthGetToken/yandexID")
function oauth:yandexID($code as xs:string, $state as xs:string){
  let $accessToken := 
    oauth:getAuthToken(
      'https://oauth.yandex.ru/token',
      '6e24a6e883ea4413b947d31c73d340d4',
      '96c2c9faf9574a89a3bea5e99d4c7c69',
      $code
    )//access__token/text()
  let $userEmail := 
    fetch:xml(
      web:create-url(
        'https://login.yandex.ru/info',
        map{
          'format':'xml',
          'oauth_token':$accessToken
        }
      )
    )/user/default_email/text()
  return
    if($userEmail)
    then(
      let $userMeta:= oauth:getUserMeta($userEmail)
      let $redir := oauth:loginRedirectURL()   
      return
        (oauth:setSession($userMeta), web:redirect($redir))
    )
    else(<err:LOGINFAIL>ошибка авторизации</err:LOGINFAIL>)
};


declare 
  %rest:GET
  %rest:query-param("code", "{$code}")
  %rest:query-param("state", "{$state}")
  %rest:path("/unoi/do/api/v01/oauthGetToken/titul24")
function oauth:titul24($code as xs:string, $state as xs:string){
  oauth:main($code, $state)
};

declare
  %private
function oauth:main($code as xs:string, $state as xs:string){
  let $accessToken :=
    oauth:getAuthToken(
      config:param('OAuthTokenEndpoint'),
      config:param('OAuthClienID'),
      config:param('OAuthClienSecret'),
      $code
    )/json/access__token/text()
  let $userEmail := oauth:userInfo($accessToken)//user__email/text() 
  return
    if($userEmail)
    then(
      let $userMeta:= oauth:getUserMeta($userEmail)
      let $redir := oauth:loginRedirectURL()   
      return
        (oauth:setSession($userMeta), web:redirect($redir))
    )
    else(<err:LOGINFAIL>ошибка авторизации</err:LOGINFAIL>)
};




(: генерирует редирект URL после успешной авторизации :)
declare
  %private
function oauth:loginRedirectURL()
{
  if(session:get('loginURL'))
  then(session:get('loginURL'), session:delete('loginURL'))
  else(config:param('host') || config:param('rootPath') || '/u')
};

(: получает информацию о пользователе с сервиса аутентификации :)
declare
  %private
function oauth:userInfo(
  $accessToken as xs:string
)
{
  json:parse(
    fetch:text( 
      web:create-url(
        config:param('OAuthUserInfoEndpoint'),
        map{'access_token' : $accessToken}
      )
    )
  )
};

(: получает access token для пользователя на сервисе аутентификации :)
declare
  %private
function oauth:getAuthToken(
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


(: устанавливает сессию из мета-данных :)
declare function oauth:setSession($userMeta as map(*)){
  session:set('accessToken', $userMeta?accessToken),
  session:set("login", $userMeta?email),
  session:set("userID", $userMeta?userID),
  session:set("displayName", $userMeta?displayName),
  session:set('userAvatarURL', $userMeta?avatar)
};


(: возвращает map метаданными пользователя для установки сессии :)
declare function oauth:getUserMeta($login) as map(*){
  let $userHash :=
    lower-case(
      string(xs:hexBinary(hash:md5(lower-case($login))))
    )
  let $userID := 
    'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
  let $accessToken := oauth:getToken(config:param('authHost'), config:param('login'), config:param('password'))
  return 
   map{
      'email' : $login,
      'displayName' : $login,
      'accessToken' : $accessToken,
      'avatar' : config:param('defaultAvatarURL'),
      'userID': $userID
    }
};

declare
  %private
function oauth:getToken($host, $username, $password) as xs:string*
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
      if ($response[1]/@status/data()= "200")
      then($response[2]//token/text())
      else()
};