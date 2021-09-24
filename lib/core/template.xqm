module namespace template = "template";

import module namespace getData = "getData" at "../modules/getData.xqm";
import module namespace config = "app/config" at "../core/config.xqm";

declare function template:replace( $string, $map as map(*) ){
  fold-left(
        map:for-each( $map, function( $key, $value ){ map{ $key : $value } } ),
        $string, 
        function( $string, $d ){
           replace(
            $string,
            "\{\{" || map:keys( $d )[ 1 ] || "\}\}",
            replace( serialize( map:get( $d, map:keys( $d )[ 1 ] ) ), '\\', '\\\\' ) (: проблема \ в заменяемой строке :)
          ) 
        }
      )
};

declare function template:xhtml( $app as xs:string, $map as item(), $componentPath ){
  
  let $appAlias :=
    if( contains( $app, "/") )
    then( tokenize( $app, "/" )[ last()] )
    else( $app )
  
  let $string := 
    file:read-text(
      file:base-dir() || $componentPath ||  '/' || $app || "/"  || $appAlias || ".html"
    )
  
  return
    parse-xml(
      template:replace( $string, $map )
    )
};

declare function template:tpl( $app as xs:string, $params as map(*) ){
  let $componentPath := '../../components'
  
  let $queryTpl :=
  'import module namespace {{appAlias}} = "{{app}}" 
     at "{{rootPath}}/{{app}}/{{appAlias}}.xqm";  
     declare variable $params external;
     {{appAlias}}:main( $params )'
  
  let $appAlias := 
    if( contains( $app, "/") )then( tokenize( $app, "/")[ last() ] )else( $app )
  
  let $query := 
    template:replace(
      $queryTpl,
      map{
        'rootPath' : $componentPath,
        'app' : $app,
        'appAlias' : $appAlias
      }
    )
  
  let $tpl := function( $app, $params ){ template:tpl( $app, $params ) }
  let $config := function( $param ){ config:param( $param ) }
  
  let $api := 
    function( $methodName, $paramsAPI ){
      let $ns := 
        for $i in inspect:functions()
        return
          namespace-uri-from-QName( function-name( $i ) )
      let $funct :=
        if( $ns = 'app/api' )
        then( inspect:functions() )
        else( inspect:functions( 'api.xqm' ) )
        return
          for $f in $funct
          where 
            local-name-from-QName( function-name( $f ) ) = $methodName and
            namespace-uri-from-QName( function-name( $f ) ) = 'app/api'
          return $f( $paramsAPI )
  }

  let $paramsCall := 
    map{ 'params':
      map:merge( ( $params, map{ '_api' : $api, '_t' : $tpl, '_conf' : $config } ) )
    }
  
  let $result :=
      xquery:eval( $query, $paramsCall )
    
  return
     template:xhtml( $app, $result, $componentPath )
};