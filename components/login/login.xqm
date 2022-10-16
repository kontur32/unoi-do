module namespace login = "login";

declare function login:main( $params as map(*) ){
  let $сообщение :=
    if(session:get('loginMessage'))
    then(
      <div class="card shadow rounded text-center m-4 alert alert-info">{session:get('loginMessage')}</div>
    )
    else()
  let $OAuthCodeURLtitul24 :=
    web:create-url(
      $params?_conf('OAuthCodeEndpoint'),
      map{
        'client_id':$params?_conf('OAuthClienID'),
        'response_type':'code',
        'state':'state'
      }
    )
  let $OAuthCodeURLyandexID :=
    web:create-url(
      'https://oauth.yandex.ru/authorize',
      map{
        'client_id':'6e24a6e883ea4413b947d31c73d340d4',
        'response_type':'code',
        'state':'state'
      }
    )
  let $OAuthCodeURLvkID :=
    web:create-url(
      'https://oauth.vk.com/authorize',
      map{
        'client_id':'51450585',
        'redirect_uri':'https://dbx93-ssl.iro37.ru/unoi/do/api/v01/oauthGetToken/vkID',
        'scope':'email',
        'response_type':'code',
        'state':'state'
      }
    )
  return
    map{
      'OAuthCodeURLtitul24' : $OAuthCodeURLtitul24,
      'OAuthCodeURLyandexID' : $OAuthCodeURLyandexID,
      'OAuthCodeURLvkID' : $OAuthCodeURLvkID,
      'сообщение' : $сообщение
    }
};