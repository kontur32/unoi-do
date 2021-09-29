module namespace newUser = "newUser";

import module namespace config = "app/config" at "../../lib/core/config.xqm";
import module namespace getData = "getData" at '../../lib/modules/getData.xqm';
import module namespace login = "login" at "login.xqm";
import module namespace data = "data.save" at "data.save.xqm";

declare 
  %rest:POST
  %rest:query-param( "https://schema.org/email", "{ $email }" )
  %rest:query-param( "password", "{ $password }" )
  %rest:query-param( "redirect", "{ $redirect }" )
  %rest:path( "/unoi/do/api/v01/user" )
function newUser:main( $email as xs:string, $password as xs:string, $redirect ){
  
  let $response := 
    newUser:createAuth( $email, $email, $password )
  let $поляАккаунтаМудл :=
    map{
      'users[0][username]' : $email,
      'users[0][lastname]' : request:parameter( 'https://schema.org/familyName' ),
      'users[0][firstname]' : request:parameter( 'https://schema.org/givenName' ),
      'users[0][email]' : $email,
      'users[0][password]' : $password
    }
  return
    if ( $response[ 1 ]/@status/data() = "201" )
    then(
      (
        login:main( $email, $password, (), () ),
        newUser:записьЛичномКабинете( $email ),
        newUser:создатьПользователяМудл( $поляАккаунтаМудл )
      )
    )
    else( )
};

(: создает аккаунт пользователя на сервисе утентификации :)
declare function newUser:createAuth( $username, $email, $password ){
  let $accessToken := 
      getData:getToken( config:param( 'authHost' ), config:param( 'login' ), config:param( 'password' ) )
    let $auth := "Bearer " ||   $accessToken
    let $request := 
    <http:request method='POST'>
        <http:header name="Authorization" value= '{ $auth }'/>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="username";'/>
            <http:body media-type = "text/plain" >{ $username }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="email";'/>
            <http:body media-type = "text/plain" >{ $email }</http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="password";' />
            <http:body media-type = "text/plain">{ $password }</http:body>
        </http:multipart> 
      </http:request>
  
  let $response := 
      http:send-request(
        $request,
        config:param( 'authHost' ) || "/wp-json/wp/v2/users"
    )
  return
    $response
};

declare function newUser:записьЛичномКабинете( $userLogin ){
  let $userHash :=
    lower-case(
        string(
          xs:hexBinary(
            hash:md5(
              lower-case( $userLogin )
            ) 
          )
        )
      )
  let $newUserID := 
    'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
  
  let $dataRecord :=
    <table
        id = "{ random:uuid() }"
        label = "{ $userLogin }"
        aboutType = "https://schema.org/Person" 
        templateID = "3a483137-d7c9-469f-98b0-6583d5ba8244" 
        userID = "220" 
        modelURL = "http://localhost:9984/zapolnititul/api/v2/forms/7fe8990b-0289-4498-b329-e43c19ac6232/model"
        status = "active"
        updated="{ current-dateTime() }">
        <row id = "{ $newUserID }" aboutType = "https://schema.org/Person">
          <cell id="https://schema.org/email">{ request:parameter( 'https://schema.org/email' ) }</cell>
          <cell id="https://schema.org/givenName">{ request:parameter( 'https://schema.org/givenName' ) }</cell>
          <cell id="id">{ $newUserID }</cell>
          <cell id="https://schema.org/familyName">{ request:parameter( 'https://schema.org/familyName' ) }</cell>
          <cell id="https://schema.org/telephone">{ request:parameter( 'https://schema.org/telephone' ) }</cell>
          <cell id="Пространство имен">http://dbx.iro37.ru/unoi/сущности/учащиеся#</cell>
        </row>
    </table>
  let $response :=
    data:postRecord(
      $dataRecord,
      config:param( 'api.method.getData' ),
      session:get( "accessToken")
    )
  return
    $response
};

declare function newUser:создатьПользователяМудл( $поляПользователя ){
  let $token :=
  json:parse(
    fetch:text(
      web:create-url(
        config:param('moodle.method.token.get'),
        map{
          'username' :  config:param('moodle.login'),
          'password' : config:param('moodle.password'),
          'service' : 'trac'
        }
      )
    )
  )/json/token/text()
return
  fetch:xml(
      web:create-url(
        config:param('moodle.method.user.create'),
        map:merge(
          (
            map{
              'wstoken' : $token,
              'wsfunction' : 'core_user_create_users'
            },
            $поляПользователя
          )
        )
        
      )
    )//KEY[ @name = "id"]/VALUE/text()
};