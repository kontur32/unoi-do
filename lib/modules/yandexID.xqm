module namespace yandexID = "lib/modules/yandexID";

import module namespace config = "app/config" at "../core/config.xqm";
import module namespace auth = "lib/modules/auth" at "auth.xqm";

declare
  %public
function yandexID:userEmail($code as xs:string)
  as xs:string*
{
  let $accessToken := 
    auth:getAuthToken(
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
    $userEmail
};