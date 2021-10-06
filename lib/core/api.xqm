module namespace api = "app/api";

import module namespace template = "template"  at "template.xqm";
import module namespace config = "app/config"  at "config.xqm";
import module namespace getData = "getData" at "../modules/getData.xqm";
import module namespace getForms = "modules/getForms" at "../modules/getForms.xqm";

declare  function api:config.param ( $params as map(*) ) as xs:string* {
  config:param( $params?name )
};

declare function api:template.build( $params as map(*) ){
  template:tpl( $params?app, $params?params )
};

declare function api:getData.getFileFromMainStore( $params as map(*) ){
  getData:getFile(  $params?path, $params?xq )
};

declare function api:getData.getFile( $params as map(*) ){
  getData:getFile(  $params?path, $params?xq, $params?storeID )
};

declare function api:getData.data( $params as map(*) ){
  getData:getData( 
    $params?xq,
    if( empty( $params?queryParams ) )then( map{} )else( $params?queryParams ),
    session:get( 'accessToken' )
  )
};

declare function api:getForms.forms( $params as map(*) ){
  getForms:forms( 
    $params?xq,
    if( empty( $params?queryParams ) )then( map{} )else( $params?queryParams ),
    session:get( 'accessToken' )
  )
};