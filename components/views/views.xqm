module namespace views = "views";

declare function views:main( $params as map(*) ){
  let $p :=    
       map{
        'header' : '',
        'content' : (
          $params?_t( 'login', map{ 'redirect' :  $params?_conf( 'rootPath' ) || '/u' } ),
          $params?_t( 'registration', map{ 'redirect' :  $params?_conf( 'rootPath' ) || '/u' } )
        ),
        'footer' : $params?_t( 'footer', map{} )
      }
    
  return
    map{ 'содержание' : $params?_t( 'main', $p ) }
};