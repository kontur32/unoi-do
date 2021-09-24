module namespace user = "views/user";

declare function user:main( $params as map(*) ){
  let $p :=    
       map{
        'header' : $params?_t( 'header', map{} ),
        'content' : $params?_t( 'content', map{} ),
        'footer' : $params?_t( 'footer', map{} )
      }
  return
    map{ 'содержание' : $params?_t( 'main', $p ) }
};