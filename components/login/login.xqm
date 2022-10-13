module namespace login = "login";

declare function login:main( $params as map(*) ){
  let $сообщение :=
    if(session:get('loginMessage'))
    then(
      <div class="card shadow rounded text-center m-4 alert alert-info">{session:get('loginMessage')}</div>
    )
    else()
  return
  map{
    'oauthEndpoint' : $params?_conf('oauthEndpoint'),
    'сообщение' : $сообщение
  }
};