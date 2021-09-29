module namespace inkwi = "inkwi/user";

import module namespace template="template" at "../../lib/core/template.xqm";

declare 
  %rest:GET
  %rest:path( "/unoi/do/{ $area }/{ $part }" )
  %output:method( "xhtml" )
  %output:doctype-public( "www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" )
function inkwi:main( $area, $part ){
    switch( $part )
    case 'cabinet' return template:tpl( 'views/user', map{ 'part' : '/cabinet'} )
    default return template:tpl( 'views', map{} )
};