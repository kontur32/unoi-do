module namespace registration = "registration";

declare function registration:main( $params as map(*) ){
  map{
    'redirect' : $params?redirect
  }
};