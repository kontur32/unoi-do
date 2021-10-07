module namespace logout = "logout";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:GET
  %rest:query-param( "redirect", "{ $redirect }" )
  %rest:path( "/unoi/do/api/v01/logout" )
function logout:main( $redirect ){
  let $sessionAuthDestroy :=
    fetch:text(
      config:param( 'authHost' ) || 
      '/sessionDestroy/?user='  || 
      session:get( 'userAuthID' )
    )   
  return
    if( $sessionAuthDestroy )then( session:close() )else(),
  let $redir := 
    if( $redirect )then( $redirect )else( config:param( 'rootPath' )  )
  return  
      web:redirect( $redir )
};
