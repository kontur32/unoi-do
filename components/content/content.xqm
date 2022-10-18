module namespace content = 'content';

declare function content:main( $params ){
  map{
    'access_token':session:get("accessToken")
  }
};