module namespace defaultFormField = "content/defaultFormField";

declare function defaultFormField:main( $params as map(*) ){
  map{
    'containerID' : $params?containerID,
    'templateID' : $params?templateID,
    'aboutType' : $params?aboutType,
    'formName' : $params?formName,
    'saveRedirect' : '/unoi/do/u',
    'formAction' : '/unoi/do/api/v01/data',
    'enctype' : 'multipart/form-data'
  }
};