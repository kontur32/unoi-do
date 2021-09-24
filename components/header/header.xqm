module namespace header = "header";

declare function header:main( $params as map(*) ){
  map{
    'mainMenu' : $params?_t( 'header/mainMenu', map{} ),
    'avatar' : $params?_t( 'header/avatar', map{} )
  }  
};