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
  let $имяПоляФайла :=
    $params?form/csv/record[inputType/text() = 'file']/ID/text()
  return  
    map{
      'названиеДокумента':$params?form/csv/record[inputType/text() = 'file']/label/text(),
      'идентификаторФайла':$data/row/cell[@id/data()=$params?form/csv/record/ID/text()]/table/row/@id/data(),
      'имяПоляФайла':$имяПоляФайла,
      'идентификаторФормы':$formName,
      'containerID' : $служебныеПоляФормы?containerID,
      'templateID' : $служебныеПоляФормы?templateID,
      'aboutType' : $служебныеПоляФормы?aboutType,
      'saveRedirect' : '/unoi/do/u/cabinet',
      'служебныеПоляФормы':$params?_t('content/defaultFormField', $служебныеПоляФормы)
    }
};