module namespace getForms = "modules/getForms";

import module namespace config = "app/config" at "../core/config.xqm";
import module namespace auth = "modules/auth" at "auth.xqm";

declare
  %public
function
  getForms:forms( $xquery, $params as map(*) ) 
{
  let $accessToken := 
    if( try{ session:get( 'accessToken' ) }catch*{ false() } )
    then( session:get( 'accessToken' ) )
    else(
      auth:getJWT(
          config:param( 'authHost' ),
          config:param( 'login' ),
          config:param( 'password' )
        )
    )
  return
     getForms:forms( $xquery, $params, $accessToken )
};

declare
  %public
function
  getForms:forms( $xquery, $params as map(*), $access_token ) 
{
  let $apiURL := config:param( 'dataHost' ) || '/trac/api/v0.1/u/forms'
  let $parameters :=
    map:merge(
      (
        map{ 'access_token' : $access_token, 'xq' : $xquery },
        $params
      )
    )
  return
    fetch:xml(
      web:create-url( $apiURL, $parameters )
    )
};