module namespace getFile = "api/getFile";

declare function getFile:main($params as map(*)){
  map{
    'файл':getFile:getData($params, $params?fileID)
  }
};

declare function getFile:getData($params, $fileID){
  let $xq :=
    'declare variable $params external; 
    ./row/cell/table/row[@id=$params?fileID]'

  let $data := 
    $params?_api(
      'getData.data',
      map{
        'xq':$xq,
        'queryParams':map{'fileID':$fileID}
      }
    )/data/row/cell/text()
  
  return
    if($data)
    then($data)
    else(
      <err:D01>{$fileID}{$data}Не удалось получить электронный документ</err:D01>
    )
};