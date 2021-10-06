module namespace check = "check";

declare 
  %perm:check( "/unoi/do/u" )
function check:userArea(){
  let $user := session:get( "login" )
  where empty( $user )
  return
    web:redirect( "/unoi/do" )
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
