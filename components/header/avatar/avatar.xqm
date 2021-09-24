module namespace avatar = "header/avatar";

declare function avatar:main( $params as map(*) ){
  map{
    "userLabel" : session:get( 'displayName' ),
    "userAvatarURL" : 
      if( session:get( 'userAvatarURL' ) != "")
      then( session:get( 'userAvatarURL' ) )
      else( $params?_api( 'config.param', map{ 'name' : 'defaultAvatarURL' } ) )
  }
};