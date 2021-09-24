module namespace inkwi = "inkwi";

import module namespace template="template" at "../../lib/core/template.xqm";

declare 
  %rest:GET
  %rest:path( "/unoi/do" )
  %output:method( "html" )
  %output:doctype-public( "www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" )
function inkwi:main(){
  template:tpl( 'views', map{} )
};