module namespace content = 'content';

declare function content:main( $params ){
    let $содержание :=
      <div>
        Главная страница сервиса <span>"Электронный вассал методиста"</span>
      </div>
   
  
   return
      map{ 'содержание' : <div class = "h2">{ session:get( 'login') }, добро пожаловать в личный кабинет системы дистанционного образования УНОИ!</div> }
};