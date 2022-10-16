module namespace vkID = "lib/modules/vkID";

import module namespace config = "app/config" at "../core/config.xqm";
import module namespace auth = "lib/modules/auth" at "auth.xqm";

declare
  %public
function vkID:userEmail($code as xs:string)
  as xs:string*
{
  let $userEmail := 
    json:parse(
      fetch:text(
        web:create-url(
          'https://oauth.vk.com/access_token',
          map{
            'client_id':'51450585',
            'client_secret': 'eIvx3cjjlqpstOrWZ9fX',
            'redirect_uri': config:param('host') || '/unoi/do/api/v01/oauthGetToken/vkID',
            'scope':'email',
            'code':$code
          }
        )
    )
  )//email/text()
  return
    $userEmail
};