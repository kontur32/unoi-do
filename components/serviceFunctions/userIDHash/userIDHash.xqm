module namespace userIDHash = 'serviceFunctions/userIDHash';

declare function userIDHash:main( $params ){
  let $userLogin :=
    if( $params?userLogin )
    then( $params?userLogin )
    else(  session:get( 'login' ) )
  return
    map{
      'значение' :  
      lower-case(
        string(
          xs:hexBinary(
            hash:md5(
              lower-case( $userLogin )
            ) 
          )
        )
      )
    }
};