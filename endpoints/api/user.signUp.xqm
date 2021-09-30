module namespace signUp = "signUp";

import module namespace config = "app/config" at "../../lib/core/config.xqm";
import module namespace getData = "getData" at '../../lib/modules/getData.xqm';

import module namespace template="template" at "../../lib/core/template.xqm";
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';
import module namespace data = "data.save" at "data.save.xqm";

declare 
  %rest:GET
  %rest:POST
  %rest:query-param( "course", "{ $coursID }" )
  %rest:query-param( "redirect", "{ $redirect }" )
  %rest:path( "/unoi/do/api/v01/user/signup" )
function signUp:main( $coursID as xs:string, $redirect ){
  let $templateID := '7da6b3ba-961a-4147-9607-31e89b8deed8'
  let $userID := template:tpl( 'serviceFunctions/userID', map{} )/result/text()
  let $названиеКурса := 1
   
  return 
    <table
    label="" id="{ random:uuid() }"
    aboutType="https://schema.org/Person"
    templateID="{ $templateID }"
    userID="220"
    modelURL="{'http://localhost:9984/zapolnititul/api/v2/forms/' ||$templateID || '/model' }" 
    status="active"
    updated="{ current-dateTime() }">
      <row id="{ $userID }" type="https://schema.org/Person">
        <cell id="http://dbx.iro37.ru/unoi/свойства/статусКуса">подана заявка</cell>
        <cell id="Пространство имен">http://dbx.iro37.ru/unoi/сущности/учащиеся#</cell>
        <cell id="http://dbx.iro37.ru/unoi/свойства/идентификаторКурса">{ $coursID }</cell>
        <cell id="http://dbx.iro37.ru/unoi/свойства/названиеКурса">{ 1 }</cell>
        <cell id="id">{ $userID }</cell>
        <cell id="http://dbx.iro37.ru/unoi/свойства/датаНачалаКурса">
          { substring-after( $coursID, '/' ) }
        </cell>
      </row>
    </table>
};