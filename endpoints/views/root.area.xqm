module namespace inkwi = "inkwi/user";

import module namespace template="template" at "../../lib/core/template.xqm";

declare 
  %rest:GET
  %rest:path( "/unoi/do/{$area}")
  %output:method("xhtml")
  %output:doctype-public("www.w3.org/TR/xhtml11/DTD/xhtml11.dtd")
function inkwi:main($area){
    switch( $area )
    case 'u' return template:tpl('views/user', map{})
    case 'a' return template:tpl('views/admin', map{})
    default return template:tpl('views', map{})
};