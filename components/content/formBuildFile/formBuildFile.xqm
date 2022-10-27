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
  return  
    map{
      'названиеДокумента':$params?form/csv/record/label/text(),
      'идентификаторФормы':$formName,
      'служебныеПоляФормы':$params?_t('content/defaultFormField', $служебныеПоляФормы)
    }
};