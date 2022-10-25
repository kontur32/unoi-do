module namespace formBuild = 'content/formBuild';

declare function formBuild:main($params){
  let $data := $params?data
  let $formFields := $params?form/csv
  let $formName := $params?form/@label/data()
  let $formName := random:uuid()
  let $служебныеПоляФормы :=
    map{
      'aboutType' : 'https://schema.org/Person',
      'templateID' : $data/@templateID/data(),
      'containerID' : if( $data/@id/data() )then( $data/@id/data() )else( random:uuid() ),
      'formName' : $formName
    }
  return  
    map{
      'форма' : formBuild:buildForm( $data, $formName, $formFields ),
      'служебныеПоляФормы' : $params?_t( 'content/defaultFormField', $служебныеПоляФормы )
    }
};

declare function formBuild:buildForm(
  $data as element(table),
  $formName,
  $formFields
)
{
  let $dataFields :=
    for $i in $formFields/record
    where not($i/inputType/text()) or  $i/inputType/text() != 'hidden'
    let $inputField :=
      switch($i/inputType/text())
      case 'file' return map{'type':'file', 'value':''}
      default 
        return
          map{
            'type':'text',
            'value': $data/row/cell[@id/data() = $i/ID/text()]/text()
          }
    return
      <div class="form-group">
          <label>{$i/label/text()}</label>
          <input form = "{$formName}" type="{$inputField?type}" name="{$i/ID/text()}" value = "{$inputField?value}" class="form-control" placeholder=""/>
      </div>
     return
       <form class="card shadow rounded p-2" id="{$formName}" enctype="multipart/form-data">
         {$dataFields}
         <input form="{$formName}" name="Пространство имен" value="{$data/row/cell[@id = 'Пространство имен']/text()}" hidden="yes"/>
         <input form="{$formName}" name="id" value="{$data/row/@id/data()}" hidden="yes"/>
       </form>
};