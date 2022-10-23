module namespace oauth = "oaut/getToken/titul24";

import module namespace config = "app/config"
  at "../../lib/core/config.xqm";
import module namespace auth = "lib/modules/auth"
  at "../../lib/modules/auth.xqm";

import module namespace titul24 = "lib/modules/titul24" 
  at "../../lib/modules/titul24.xqm";
import module namespace yandexID = "lib/modules/yandexID" 
  at "../../lib/modules/yandexID.xqm";
import module namespace vkID = "lib/modules/vkID" 
  at "../../lib/modules/vkID.xqm";

import module namespace getData = "getData" 
  at '../../lib/modules/getData.xqm';
import module namespace getForms = "modules/getForms"
  at '../../lib/modules/getForms.xqm';


declare 
  %rest:GET
  %rest:query-param("code", "{$code}")
  %rest:query-param("state", "{$state}")
  %rest:path("/unoi/do/api/v01/oauthGetToken/{$oauthService}")
function oauth:vkID(
  $oauthService as xs:string,
  $code as xs:string,
  $state as xs:string
){
  let $userEmail := 
    switch ($oauthService)
    case 'vkID' return vkID:userEmail($code)
    case 'yandexID' return yandexID:userEmail($code)
    case 'titul24' return titul24:userEmail($code)
    default return ()
  return
     if($userEmail)
    then(
     
     let $userHash :=
        lower-case(string(xs:hexBinary(hash:md5(lower-case($userEmail)))))
     let $userID := 
        'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
     let $templateID :=
       getForms:forms(
         '.[starts-with(@label, "ЛК: Карточка учащегося")]', map{}
       )/forms/form/@id/data()
      let $xq :=
        'declare variable $params external; 
        .[@templateID=$params?templateID][row[@id=$params?userID]]'
      let $userData := 
        getData:getData(
          $xq,map{'templateID':$templateID, 'userID':$userID}
        )/data/table[last()] 
      let $isRegistred := $userData/row/@id/data() = $userID
      return
        if($isRegistred)
        then(
          let $userMeta:= oauth:getUserMeta($userEmail)
          let $redir := oauth:loginRedirectURL()   
          return
            (oauth:setSession($userMeta), web:redirect($redir))
        )
        else(
          session:set(
            'loginMessage', 
            'Пользователель ' || $userEmail || ' не зарегистрирован. ' || 
            'Заполните форму регистрации на этой странице или войдите с другой учетной записью (email)'
          ),
          web:redirect(config:param('rootPath'))
        )
    )
    else(
      session:set(
        'loginMessage', 
        'Произошла ошибка: сервиса аутентификации ' || $oauthService || ' не удалось подтвердить Ваш логин.'
      ),
      web:redirect(config:param('rootPath'))
    )
};


(: эксперименты с многвенной авторизацией от яндекса :)
declare 
  %rest:GET
  %rest:path("/unoi/do/api/v01/oauthGetToken/yandexID/quick")
function oauth:yandexID(){
  <a>{request:uri()}</a>
};



(: генерирует редирект URL после успешной авторизации :)
declare
  %private
function oauth:loginRedirectURL()
{
  if(session:get('loginURL'))
  then(session:get('loginURL'), session:delete('loginURL'))
  else(config:param('host') || config:param('rootPath') || '/u')
};

(: устанавливает сессию из мета-данных :)
declare function oauth:setSession($userMeta as map(*)){
  session:set('accessToken', $userMeta?accessToken),
  session:set("login", $userMeta?email),
  session:set("userID", $userMeta?userID),
  session:set("displayName", $userMeta?displayName),
  session:set('userAvatarURL', $userMeta?avatar)
};

(: возвращает map метаданными пользователя для установки сессии :)
declare function oauth:getUserMeta($login) as map(*){
  let $userHash :=
    lower-case(
      string(xs:hexBinary(hash:md5(lower-case($login))))
    )
  let $userID := 
    'http://dbx.iro37.ru/unoi/сущности/учащиеся#' || $userHash
  let $accessToken := auth:getJWT(config:param('authHost'), config:param('login'), config:param('password'))
  return 
   map{
      'email' : $login,
      'displayName' : $login,
      'accessToken' : $accessToken,
      'avatar' : config:param('defaultAvatarURL'),
      'userID': $userID
    }
};