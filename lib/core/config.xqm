module namespace config = "app/config";

declare  function config:param( $param as xs:string ) as xs:string* {
  doc ( "../../config.xml" )/config/param[ @id = $param ]/text()
};