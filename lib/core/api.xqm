module namespace api = "app/api";

import module namespace template = "template"  at "template.xqm";
import module namespace config = "app/config"  at "config.xqm";
import module namespace getData = "getData" at "../modules/getData.xqm";

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