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
  %perm:check( "/unoi/do/api/v01/user" )
function check:apiArea(){
  let $user := session:get( "login" )
  where empty( $user )
  return
    web:redirect( "/unoi/do" )
};