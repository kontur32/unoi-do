module namespace logout = "logout";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param( "redirect", "{ $redirect }" )
  %rest:path( "/unoi/do/api/v01/logout" )
function logout:main( $redirect ){
  session:close(),
  let $redir := 
    if( $redirect )then( $redirect )else( config:param( 'rootPath' )  )
  return 
    web:redirect( $redir )
};
