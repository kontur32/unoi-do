module namespace content = 'content';

declare function content:main( $params ){
  map{ 'содержание' : $params?_t( 'content/cabinet', map{} ) }
};