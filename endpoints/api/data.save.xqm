module namespace data = "data.save";

import module namespace config = "app/config" at "../../lib/core/config.xqm";

declare 
  %rest:POST
  %rest:form-param ( "_t24_templateID", "{ $templateID }", "" )
  %rest:form-param ( "_t24_id", "{ $id }", "" )
  %rest:form-param ( "_t24_type", "{ $aboutType }" )
  %rest:form-param ( "_t24_saveRedirect", "{ $redirect }", "/" )
  %rest:path( "/unoi/do/api/v01/data" )
function data:main( $templateID, $id, $aboutType, $redirect ){
   let $userID := 
     json:parse( convert:binary-to-string( xs:base64Binary( tokenize( session:get( "accessToken" ), '\.' )[ 2 ] || '=' ) ) )
    /json/data/user/id/text()
   
   return
     if( $userID )
     then(
     let $paramNames := 
        for $name in  distinct-values( request:parameter-names() )
        where not ( starts-with( $name, "_t24_" ) )
        return $name  
       
       let $params := 
         map{
           "userID" : $userID,
           "currentID" : if( $id = "" )then( random:uuid() )else( $id ),
           "aboutType" : $aboutType,
           "templateID" : $templateID,
           "modelURL" : 'http://localhost:9984/zapolnititul/api/v2/forms/' || $templateID || '/model',
           "paramNames" : $paramNames
         }
         
    let $dataRecord :=  data:buildDataRecord( $params )
    let $auth := "Bearer " || session:get( "accessToken")
    let $response :=
     http:send-request(
       <http:request method='POST'>
          <http:header name="Authorization" value= '{ $auth }'/>
          <http:multipart media-type = "multipart/form-data">
              <http:header name="Content-Disposition" value= 'form-data; name="data";'/>
              <http:body media-type = "application/xml" >
                { $dataRecord }
              </http:body>
          </http:multipart> 
        </http:request>,
       config:param( 'api.method.getData' )
      )
    let $reponseCode := $response[ 1 ]/@status/data()
    let $message := 
      if( $reponseCode = '200' )
      then( 'Изменения сохранены' )
      else( $response )
    return
      web:redirect(
        web:create-url(
          $redirect,
          map{ 'message' : $message }
        )
      )
    )
    else( <err:AUTH01>ID пользователя не определен</err:AUTH01> )
};

declare 
  %private
function data:buildDataRecord( $params ){
   let $record := data:dataRecord( $params )
     
   let $model := <table/>
      
   let $request :=
      <http:request method='POST'>
        <http:multipart media-type = "multipart/form-data" >
            <http:header name="Content-Disposition" value= 'form-data; name="data";'/>
            <http:body media-type = "application/xml" >
              { $record }
            </http:body>
            <http:header name="Content-Disposition" value= 'form-data; name="model";'/>
            <http:body media-type = "application/xml" >
              { $model }
            </http:body>
        </http:multipart> 
      </http:request>
  
  return 
    http:send-request(
      $request,
      'http://localhost:9984/xlsx/api/v1/trci/bind/meta'
    )[2]
};


declare 
  %public
function data:dataRecord( $params ){
  <table
      id = "{ $params?currentID }"
      label = "{ $params?label }"
      aboutType = "{ $params?aboutType }" 
      templateID = "{ $params?templateID }" 
      userID = "{ $params?userID }" 
      modelURL = "{  $params?modelURL }"
      status = "active">
      <row>
        (: добавляет поля текстовые :)
        {
          for $param in $params?paramNames
          (: если есть одинаковые параметры, то записыаются все :)
          let $paramValue := request:parameter( $param ) 
          where not ( $paramValue instance of map(*)  ) and $paramValue
          return
              <cell label="{ web:decode-url( $param ) }">{ $paramValue }</cell>
        }
        
        (: добавляет поля-файлы :)
        {
          for $param in $params?paramNames
          let $paramValue := request:parameter( $param )
          where
            ( $paramValue instance of map(*)  ) and 
            not (
              string( map:get( $paramValue, map:keys( $paramValue )[ 1 ] ) ) = ""
            ) 
          return
              <cell label="{ $param }">
                <table>
                  <row id="{ random:uuid() }" label="{ map:keys( $paramValue )[1] }" type="https://schema.org/DigitalDocument">
                    <cell id="content">
                      { xs:string( map:get( $paramValue, map:keys( $paramValue )[1] ) )  }
                    </cell>
                  </row>
                </table> 
              </cell>  
        }
      </row>
    </table>
};