module namespace cabinet = 'content/cabinet';

declare function cabinet:main($params){map{}};
declare function cabinet:main2($params){
  let $userID := session:get('userID')  
  let $templates :=
    $params?_api(
      'getForms.forms', map{'xq' : '.[starts-with( @label, "ЛК:" )]'}
    )/forms
  
  let $forms :=
    for $i in $templates/form
    let $data := cabinet:getData($params, $userID, $i/@id/data())  
    return
      $params?_t('content/formBuild',  map{'data': $data, 'form':$i})
  return
      map{
        'основныеСведения' : $forms[1],
        'личныеДанные' : $forms[2],
        'образование' : $forms[3],
        'местоРаботы' : $forms[4]
      }
};

declare function cabinet:getData($params, $userID, $templateID){
  let $xq :=
    'declare variable $params external; 
    .[@templateID=$params?templateID][row[@id=$params?userID]]'

  let $data := 
    $params?_api(
      'getData.data',
      map{
        'xq':$xq,
        'queryParams':map{'userID':$userID, 'templateID':$templateID}
      }
    )/data/table[last()]
  
  return
    if($data instance of element(table))
    then($data)
    else(
      <table id = "{random:uuid()}" templateID = "{$templateID}">
        <row id = "{$userID}">
          <cell id="Пространство имен" >http://dbx.iro37.ru/unoi/сущности/учащиеся#</cell>
        </row>
      </table>
    )
};