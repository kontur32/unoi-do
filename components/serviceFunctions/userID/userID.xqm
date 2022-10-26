module namespace userIDHash = 'serviceFunctions/userID';

declare function userIDHash:main($params){
  let $userLogin :=
    if($params?userLogin)
    then($params?userLogin)
    else(session:get('login'))
  return
    map{
      'значение' :
      'http://dbx.iro37.ru/unoi/сущности/учащиеся#' ||
      $params?_t( 'serviceFunctions/userIDHash', map{ 'login' : $userLogin } )/result/text()
    }
};