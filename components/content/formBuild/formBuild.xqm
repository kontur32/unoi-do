module namespace formBuild = 'content/formBuild';

declare function formBuild:main( $params ){
  let $data := $params?data
  let $formFields :=
    fetch:xml(
      'http://localhost:9984/zapolnititul/api/v2/forms/' || $data/@templateID/data() || '/fields'
    )/csv
  let $служебныеПоляФормы :=
    map{
      'aboutType' : 'https://schema.org/Person',
      'templateID' : $data/@templateID/data(),
      'containerID' : if( $data/@id/data() )then( $data/@id/data() )else( random:uuid() ),
      'formName' : $params?formName
    }
  return  
    map{
      'форма' : formBuild:buildForm( $data, $params?formName, $formFields ),
      'служебныеПоляФормы' : $params?_t( 'content/defaultFormField', $служебныеПоляФормы )
    }
};

declare function formBuild:buildForm( $data as element( table ), $formName, $formFields ){
  let $dataFields :=
    for $i in $formFields/record
    where not( $i/inputType/text() ) or  $i/inputType/text() != 'hidden'
    return
      <div class="form-group">
          <label>{ $i/label/text() }</label>
          <input form = "{ $formName }" type="text" name="{ $i/ID/text() }" value = "{ $data/row/cell[ @id/data() = $i/ID/text() ]/text()}" class="form-control" placeholder=""/>
      </div>
     return
       <form class="card shadow rounded p-4 m-4" id="{ $formName }">
         { $dataFields }
         <input form="{ $formName }" name="Пространство имен" value="{ $data/row/cell[ @id = 'Пространство имен' ]/text() }" hidden="yes"/>
         <input form="{ $formName }" name="id" value="{ $data/row/@id/data() }" hidden="yes"/>
       </form>
};