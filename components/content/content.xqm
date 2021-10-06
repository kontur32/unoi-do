module namespace content = 'content';

declare function content:main( $params ){
  map{ 'содержание' : $params?_api( 'getForms.forms', map{'xq' : '.[ starts-with( @label, "ЛК:")]'} ) }
};