module namespace check = "check";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %perm:check("/unoi/do/u")
function check:userArea(){
  let $user := session:get("login")
  where empty($user) and not(config:param('mode')='noLogin')
  return
    web:redirect("/unoi/do")
};

declare 
  %perm:check( "/unoi/do/api/v01/u" )
function check:apiArea(){
  let $user := session:get( "login" )
  where empty( $user )
  return
    (
      session:set( 'loginURL', request:uri() ),
      session:set( 'loginMessage', 'Для записи на курс войдите с помощью своей учетной записи' ),
      web:redirect( "/unoi/do" )
    )
};
