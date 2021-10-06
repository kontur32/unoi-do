module namespace signUp = "signUp";

import module namespace config = "app/config" at "../../lib/core/config.xqm";
import module namespace getData = "getData" at '../../lib/modules/getData.xqm';
import module namespace getForms = "modules/getForms" at '../../lib/modules/getForms.xqm';

import module namespace template="template" at "../../lib/core/template.xqm";
import module namespace dateTime = 'dateTime' at 'http://iro37.ru/res/repo/dateTime.xqm';
import module namespace data = "data.save" at "data.save.xqm";

declare 
  %rest:GET
  %rest:query-param( "redirect", "{ $redirect }", "/unoi/do/u/courses" )
  %rest:path( "/unoi/do/api/v01/u/courses/signup/{$id}/{$date}" )
function signUp:main( $id as xs:string, $date, $redirect ){
  let $templateID :=
      getForms:forms( '.[ starts-with( @label, "Учащийся: заявки на КПК" ) ]', map{} )
      /forms/form/@id/data()
  let $идентификаторСлушателяКПК := session:get( 'userID' )
  let $идентификаторЗаявки :=
    'http://dbx.iro37.ru/unoi/сущности/заявкиНаКПК#' || random:uuid()
  let $идентификаторКПК :=
    'http://dbx.iro37.ru/unoi/сущности/курсыКПК#' || $id || '/' || $date
     
  let $dataRecord := 
    <table
    label="" id="{ random:uuid() }"
    aboutType="http://dbx.iro37.ru/unoi/онтология/заявкаНаКПК"
    templateID="{ $templateID }"
    userID="220"
    modelURL="{'http://localhost:9984/zapolnititul/api/v2/forms/' ||$templateID || '/model' }" 
    status="active"
    updated="{ current-dateTime() }">
      <row id="{ $идентификаторЗаявки }" type="http://dbx.iro37.ru/unoi/онтология/заявкаНаКПК">
        <cell id="http://dbx.iro37.ru/unoi/свойства/статусЗаявкиНаКПК">подана заявка</cell>
        <cell id="Пространство имен">http://dbx.iro37.ru/unoi/сущности/заявкиНаКПК#</cell>
        <cell id="http://dbx.iro37.ru/unoi/свойства/идентификаторКПК">{ $идентификаторКПК }</cell>
        <cell id="http://dbx.iro37.ru/unoi/свойства/участникКПК">{ $идентификаторСлушателяКПК }</cell>
        <cell id="id">{ $идентификаторЗаявки }</cell>
      </row>
    </table>
  let $response :=
    signUp:postRecord(
      $dataRecord,
      config:param( 'api.method.getData' ),
      session:get( "accessToken" )
    )
  return
     if ( $response[ 1 ]/@status/data() = "200" )
     then( web:redirect( config:param( 'host' ) || $redirect ) )
     else( <err:DATA_SAVE>данные не записаны</err:DATA_SAVE>)
  
};

declare function signUp:postRecord( $dataRecord, $path, $accessToken ){
   http:send-request(
     <http:request method='POST'>
        <http:header name="Authorization" value= '{ "Bearer " || $accessToken }'/>
        <http:multipart media-type = "multipart/form-data">
            <http:header name="Content-Disposition" value= 'form-data; name="data";'/>
            <http:body media-type = "application/xml" >
              { $dataRecord }
            </http:body>
        </http:multipart> 
      </http:request>,
     $path
    )
};