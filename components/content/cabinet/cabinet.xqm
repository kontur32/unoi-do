module namespace cabinet = 'content/cabinet';

declare function cabinet:main( $params ){
  let $userID :=
    $params?_t( 'serviceFunctions/userID', map{} )/result/text() 
  
  let $templateID := 
    tokenize( $params?_conf( 'моделиЛичногоКабинета' ), ',' )
  
  let $data1 := cabinet:getData( $params, $userID, $templateID[ 1 ] )
  let $data2 := cabinet:getData( $params, $userID, $templateID[ 2 ] )
  let $data3 := cabinet:getData( $params, $userID, $templateID[ 3 ] )
  let $data4 := cabinet:getData( $params, $userID, $templateID[ 4 ] )
  
  let $основныеСведения :=
      $params?_t( 'content/formBuild',  map{ 'data' : $data1, 'formName' : 'основныеСведения' } 
    )
  
  let $формаЛичныхДанных := 
    $params?_t( 'content/formBuild',  map{ 'data' : $data2, 'formName' : 'личныеДанные' } )
  
  let $формаОбразование :=
    $params?_t( 'content/formBuild',  map{ 'data' : $data3, 'formName' : 'образование' } )
  
  let $формаМестоРаботы :=
    $params?_t( 'content/formBuild',  map{ 'data' : $data4, 'formName' : 'местоРаботы' } )
  
  return
      map{
        'основныеСведения' : $основныеСведения,
        'личныеДанные' : $формаЛичныхДанных,
        'образование' : $формаОбразование,
        'местоРаботы' : $формаМестоРаботы
      }
};

declare function cabinet:getData( $params, $userID, $templateID ){
  let $xqTemplate :=
    'declare variable $params external; .[ @templateID = "%1" ][ row[ @id = $params?userID ] ]'
  let $xq := replace( $xqTemplate, '%1', $templateID )
  let $data := 
    $params?_api(
      'getData.data',
      map{ 'xq' : $xq, 'queryParams' : map{ 'userID' : $userID } }
    )/data/table[ last() ]
  return
    if( $data instance of element( table ) )
    then( $data )
    else(
      <table id = "{ random:uuid() }" templateID = "{ $templateID }">
        <row id = "{ $userID }">
          <cell id="Пространство имен" >http://dbx.iro37.ru/unoi/сущности/учащиеся#</cell>
        </row>
      </table>
    )
};