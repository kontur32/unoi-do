module namespace login = "login";

declare function login:main( $params as map(*) ){
  map{
    'loginEndPoint' : $params?_conf( 'loginEndPoint' ),
    'oauthEndpoint' : $params?_conf( 'oauthEndpoint' ),
    'redirect' : $params?redirect
  }
};