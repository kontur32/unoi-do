module namespace getData = "getData";

import module namespace config = "app/config" at "../core/config.xqm";
import module namespace auth = "lib/modules/auth" at "auth.xqm";

declare
  %public
function
  getData:getData( $xquery, $params as map(*) ) 
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
     getData:getData( $xquery, $params, $accessToken )
};

declare
  %public
function
  getData:getData( $xquery, $params as map(*), $access_token ) 
{
  let $apiURL := config:param( 'dataHost' ) || '/trac/api/v0.1/u/data'
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

declare
  %public
function getData:getFile(  $fileName, $xq, $storeID, $access_token ){
 let $href := 
   web:create-url(
     config:param( 'api.method.getData' ) || '/stores/' ||  $storeID,
     map{
       'access_token' : $access_token,
       'path' : $fileName,
       'xq' : $xq
     }
   )
 return
   try{ fetch:xml( $href ) }catch*{}
};

declare
  %public
function getData:getFile(  $fileName, $xq, $storeID ){
   getData:getFile(  $fileName, $xq, $storeID, session:get( 'accessToken' ) )
};

declare
  %public
function getData:getFile(  $fileName, $xq ){
   getData:getFile(  $fileName, $xq, config:param( 'fileStore.Saas.main' ), session:get( 'accessToken' ) )
};