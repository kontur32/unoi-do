module namespace login = "login";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param( "login", "{ $login }", "guest" )
  %rest:query-param( "password", "{ $password }" )
  %rest:query-param( "redirect", "{ $redirect }" )
  %rest:query-param( "guest", "{ $guest }" )
  %rest:path( "/unoi/do/api/v01/login" )
function login:main($login as xs:string, $password as xs:string, $redirect){
  let $redir := 
    if( session:get( 'loginURL' ) )
    then( session:get( 'loginURL' ), session:delete( 'loginURL' ) )
    else(
      if( $redirect )then( $redirect )else( config:param( 'rootPath' ) || '/u'  )
    )

  let $user :=  login:getUserMeta( $login, $password )
  return
    if( not( $user?error )  )
    then(
      session:set( 'accessToken', $user?accessToken ),
      session:set( "login", $login ),
      session:set( "displayName", $user?displayName ),
      session:set( "userID", $user?userID ),
      web:redirect( $redir ) 
    )
    else( web:redirect( config:param( 'rootPath' ) ) )
};

declare function login:getUserMeta( $login, $password ){
  let $userHash :=
    lower-case(
      string( xs:hexBinary( hash:md5( lower-case( $login ) ) ) )
    )
  let $userID := 
    'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
  return
    map{
      'displayName' : $login,
      'accessToken' : login:getToken( config:param( 'authHost' ), config:param( 'login' ), config:param( 'password' ) ),
      'userID' : $userID
  }
};

declare
  %private
function login:getToken( $host, $username, $password ) as xs:string*
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
      then(
        $response[ 2 ]//token/text()
      )
      else( )
};