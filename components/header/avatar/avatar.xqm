module namespace avatar = "header/avatar";

declare function avatar:main( $params as map(*) ){
  let $hash := 
    $params?_t( 'serviceFunctions/userIDHash', map{ 'login' : session:get( 'login' ) } )/result/text()
  return
  map{
    "userLabel" : session:get( 'displayName' ),
    "userAvatarURL" : 'https://www.gravatar.com/avatar/' || $hash
  }
};