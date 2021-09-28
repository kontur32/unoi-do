module namespace login = "login";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param( "login", "{ $login }", "guest" )
  %rest:query-param( "password", "{ $password }" )
  %rest:query-param( "redirect", "{ $redirect }" )
   %rest:query-param( "guest", "{ $guest }" )
  %rest:path( "/unoi/do/api/v01/login" )
function login:main( $login as xs:string, $password as xs:string, $redirect, $guest ){
  let $redir := 
    if( $redirect )then( $redirect )else( config:param( 'rootPath' ) || '/u'  )
  return
  if(  $guest = "yes" )
  then(
    session:set( "login", 'guest' ),
    session:set( "displayName", "Гость"),
    session:set( "grants", "гость"),
    web:redirect( $redir )
  )
  else(
    let $user :=  login:getUserMeta( $login, $password )
    return
      if( not( $user?error )  )
      then(
        session:set( 'accessToken', $user?accessToken ),
        session:set( "login", $login ),
        session:set( "displayName", $user?displayName ),
        session:set( 'userAvatarURL', $user?avatar ),
        web:redirect( $redir ) 
      )
      else( web:redirect( config:param( 'rootPath' ) ) )
    )
};

declare function login:getUserMeta( $login, $password ){
  map{
    'displayName' : $login,
    'accessToken' : login:getToken( config:param( 'authHost' ), config:param( 'login' ), config:param( 'password' ) ),
    'avatar' : ''
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