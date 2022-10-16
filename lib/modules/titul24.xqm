module namespace titul24 = "lib/modules/titul24";

import module namespace config = "app/config" at "../core/config.xqm";
import module namespace auth = "lib/modules/auth" at "auth.xqm";


declare
  %public
function titul24:userEmail($code as xs:string)
  as xs:string*
{
  let $accessToken :=
    auth:getAuthToken(
      config:param('OAuthTokenEndpoint'),
      config:param('OAuthClienID'),
      config:param('OAuthClienSecret'),
      $code
    )/json/access__token/text()
  let $userEmail := titul24:userInfo($accessToken)//user__email/text()
  return
    $userEmail
};

(: получает информацию о пользователе с сервиса аутентификации :)
declare
  %private
function titul24:userInfo(
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