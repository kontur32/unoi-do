module namespace getData = "getData";

import module namespace config = "app/config" at "../core/config.xqm";

declare function getData:getToken( $host, $username, $password )
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
      else()
};

declare
  %public
function
  getData:getData( $xquery, $params as map(*), $access_token ) 
{
  let $apiURL := 'http://localhost:9984/trac/api/v0.1/u/data'
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