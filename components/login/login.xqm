module namespace login = "login";

declare function login:main( $params as map(*) ){
  let $сообщение :=
    if( session:get( 'loginMessage' ) )
    then(
      <div class="col-sm-3"/>,
        <div class="col-sm-6">,
          <div class="card shadow rounded text-center m-4">{ session:get( 'loginMessage' ) }</div>
        </div>,
        <div class="col-sm-3"/>
    )
    else()
  return
  map{
    'oauthEndpoint' : $params?_conf( 'oauthEndpoint' ),
    'сообщение' : $сообщение
  }
};