module namespace formBuildFile = 'content/formBuildFile';

declare function formBuildFile:main($params){
  let $data := $params?data
  let $formName := random:uuid()
  let $служебныеПоляФормы :=
    map{
      'aboutType':'https://schema.org/Person',
      'templateID':$data/@templateID/data(),
      'containerID':if($data/@id/data())then($data/@id/data())else(random:uuid()),
      'formName':$formName
    }
  let $ii :=
    let $i := $params?form/csv/record
    where not($i/inputType/text()) or  $i/inputType/text() != 'hidden'
    return
      $i[1]/ID/text()
  return  
    map{
      'названиеДокумента':$params?form/csv/record/label/text(),
      'идентификаторФайла':$data/row/cell[@id/data()=$params?form/csv/record/ID/text()]/table/row/@id/data(),
      'имяПоляФайла':$ii,
      'идентификаторФормы':$formName,
      'служебныеПоляФормы':$params?_t('content/defaultFormField', $служебныеПоляФормы)
    }
};