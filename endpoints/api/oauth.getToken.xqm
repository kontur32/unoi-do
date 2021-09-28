module namespace oauth = "oaut/getToken";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param( "code", "{ $code }" )
  %rest:query-param( "state", "{ $state }" )
  %rest:path( "/unoi/do/api/v01/oauthGetToken" )
function oauth:main( $code as xs:string, $state as xs:string ){
   let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="code";'/>
            <http:body media-type = "text/plain" >{ $code }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_id";' />
            <http:body media-type = "text/plain">{ config:param( 'OAuthClienID' ) }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="client_secret";' />
            <http:body media-type = "text/plain">{ config:param( 'OAuthClienSecret' ) }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="grant_type";' />
            <http:body media-type = "text/plain">authorization_code</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        'http://portal.titul24.ru/oauth/token'
    )[ 2 ]
  let $accessToken := $response/json/access__token/text()
  let $userInfo :=
    json:parse(
      fetch:text( 
        'http://portal.titul24.ru/oauth/me?access_token=' || $accessToken
      )
    )

  let $userEmail := $userInfo//user__email/text()
  return
    if( $userEmail )
    then(
      let $userInfo:= oauth:getUserMeta( $userEmail )
      return
        (
          session:set( 'accessToken', $userInfo?accessToken ),
          session:set( "login", $userEmail ),
          session:set( "displayName", $userInfo?displayName ),
          session:set( 'userAvatarURL', $userInfo?avatar ),
          web:redirect( config:param( 'host' ) || config:param( 'rootPath' ) || '/u'  ) 
        )
    )
    else(
      <err:LOGINFAIL>ошибка авторизации</err:LOGINFAIL>
    )
};

declare function oauth:getUserMeta( $login ){
    map{
      'displayName' : $login,
      'accessToken' : oauth:getToken( config:param( 'authHost' ), config:param( 'login' ), config:param( 'password' ) ),
      'avatar' : config:param( 'defaultAvatarURL' )
    }
};

declare
  %private
function oauth:getToken( $host, $username, $password ) as xs:string*
{
  let $request := 
    <http:request method='post'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="username";'/>
            <http:body media-type = "text/plain" >{ $username }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="password";' />
            <http:body media-type = "text/plain">{ $password }</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        $host || "/wp-json/jwt-auth/v1/token"
    )
    return
      if ( $response[ 1 ]/@status/data() = "200" )
      then( $response[ 2 ]//token/text() )
      else( )
};