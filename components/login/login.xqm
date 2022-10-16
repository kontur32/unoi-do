module namespace login = "login";

declare function login:main( $params as map(*) ){
  let $сообщение :=
    if(session:get('loginMessage'))
    then(
      <div class="card shadow rounded text-center m-4 alert alert-info">{session:get('loginMessage')}</div>
    )
    else()
  let $OAuthCodeURL :=
    web:create-url(
    $params?_conf('OAuthCodeEndpoint'),
    map{
      'client_id':$params?_conf('OAuthClienID'),
      'response_type':'code',
      'state':'state'
    }
  )
  return
    map{
      'oauthEndpoint' : $OAuthCodeURL,
      'сообщение' : $сообщение
    }
};