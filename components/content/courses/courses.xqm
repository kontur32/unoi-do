module namespace courses = 'content/courses';

declare function courses:main( $params ){
  let $заявки := courses:getData( $params, session:get( 'userID' ) )
  return
    map{
      'заявки' : <lo>{ $заявки[ @status = "подана заявка" ] }</lo>,
      'текущие' : <lo>{ $заявки[ @status = "идет обучение" ] }</lo>,
      'завершенные' : <lo>{ $заявки[ @status = "обучение завершено" ] }</lo>
    }
};

declare function courses:getData( $params, $userID ){
  let $xq :=
    "http://localhost:9984/static/unoi/xq/requestsList.xq"

  let $заявкиКПК := 
    $params?_api(
      'getData.data',
      map{ 'xq' : $xq, 'queryParams' : map{ 'userID' : $userID } }
    )/data/table
  
  for $i in $заявкиКПК/row
  let $индентификаторКурса :=
    $i
    /cell[ @id="http://dbx.iro37.ru/unoi/свойства/идентификаторКПК" ]
    /substring-after( text(), '#' )
  
  let $курс :=
      fetch:xml(
      'http://localhost:9984//unoi/api/v01/lists/courses/' || $индентификаторКурса
    )
  let $статус := 
     $i/cell[@id="http://dbx.iro37.ru/unoi/свойства/статусЗаявкиНаКПК"]/text()
  return
    <li status = "{ $статус }"><a href = "{'http://sdo.unoi.ru/course/view.php?id=' || substring-before( $индентификаторКурса, '/' )}">{ substring-after( $индентификаторКурса, '/' ) }:{ $курс/data/table/row/cell[@label="Название ДПП"]/text() }</a></li>
    
};