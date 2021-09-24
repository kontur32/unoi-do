module namespace log = "log";

import module namespace config = "app/config" at "../core/config.xqm";

declare function log:log( $fileName, $data, $params ) {
  switch ( $params?mode )
  case 'rewrite'
    return
      file:write-text(
           config:param( 'logDir' ) || $fileName,
            string-join( ( current-dateTime() || '--' || $data, '&#xD;&#xA;' ) )
         )
    case 'add'
    return
      file:append-text(
           config:param( 'logDir' ) || $fileName,
            string-join( ( current-dateTime() || '--' || $data, '&#xD;&#xA;' ) )
         )
   default 
     return
     file:append-text(
         config:param( 'logDir' ) || $fileName,
          string-join( ( current-dateTime() || '--' || $data, '&#xD;&#xA;' ) )
       )
       
};

declare function log:log ( $fileName, $data ) {
  log:log( $fileName, $data, map{ 'mode' : 'add' } )
};