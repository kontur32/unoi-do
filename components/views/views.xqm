module namespace views = "views";

declare function views:main( $params as map(*) ){
  let $redirect := $params?_conf('rootPath') || '/u'
  let $page :=    
       map{
        'header' : '',
        'content' : (
          $params?_t('login', map{'redirect':$redirect}),
          $params?_t('registration', map{'redirect':$redirect})
        ),
        'footer' : $params?_t('footer', map{})
      }
    
  return
    map{'содержание' : $params?_t('main',$page)}
};