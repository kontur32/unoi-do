module namespace login = "login";

import module namespace config = "app/config" at "../../lib/core/config.xqm";
import module namespace auth = "lib/modules/auth" at "../../lib/modules/auth.xqm";

declare 
  %rest:GET
  %rest:query-param("login", "{$login}", "guest")
  %rest:query-param("password", "{$password}")
  %rest:query-param("redirect", "{$redirect}")
  %rest:path("/unoi/do/api/v01/login")
function login:main($login as xs:string, $password as xs:string, $redirect){
  let $redir := 
    if(session:get('loginURL'))
    then(session:get('loginURL'), session:delete('loginURL'))
    else(
      if($redirect)then($redirect)else(config:param('rootPath' ) || '/u' )
    )

  let $user :=  login:getUserMeta($login)
  return
    if(not($user?error))
    then(
      session:set('accessToken', $user?accessToken),
      session:set("login", $login),
      session:set("displayName", $login),
      session:set("userID", $user?userID),
      web:redirect($redir) 
    )
    else(web:redirect(config:param('rootPath')))
};

declare function login:getUserMeta($login){
  let $userHash :=
    lower-case(
      string(xs:hexBinary(hash:md5(lower-case($login))))
    )
  let $userID := 
    'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
  let $accessToken :=
    auth:getJWT(config:param('authHost'), config:param('login'), config:param('password'))
  return
    map{
      'displayName' : $login,
      'accessToken' : $accessToken,
      'userID' : $userID
  }
};