module namespace admin = "views/admin";

declare function admin:main( $params as map(*) ){
  let $p :=    
       map{
        'header' : $params?_t('header', map{} ),
        'content' : admin:content(),
        'footer' : $params?_t('footer', map{})
      }
  return
     map{'содержание' : $params?_t('main', $p)}
};

declare function admin:content(){
  <div>
    <div class="row">
      <div class="col-md-12">
        <div class="h2">Личный кабинет руководителя программ</div>
      </div>
    </div>
    <div class="row">
      <div class="col-md-3 border-right border-3">
        <div class="h2 text-center">Разделы</div>
        <div>
          <ul>
            <li class="marked">
              <span class="fw-bold">Заявки на курсы</span>
            </li>
            <li class="marked">
              <a href="#">Текущие курсы</a>
            </li>
            <li class="marked pb-3">
              <a href="#">Завершенные</a>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-md-4 border-right border-3">
        <div class="h2 pb-3 text-center">Список курсов</div>
        <div>
          <ul>
            <li class="marked">
              <a href="?group=ist2019-1.1">Учитель истории</a>
            </li>
            <li class="">
              <span class="fw-bold">Программы ФГОС 3+</span>
            </li>
          </ul>
        </div>
      </div>
      <div class="col-md-5 border-right">
        <div class="h2 pb-3 text-center">"Программы ФГОС 3+"</div>
        <div class="h4 text-center">Документы курса</div>
        <div class="row border-bottom pb-2">
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Приказ</a></div>
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Ведомость</a></div>
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Сведения</a></div>
        </div>
        <div class="h4 text-center mt-2">Слушатели</div>
        <div class="row border-bottom pb-2">
          <div class="col-md-8">Колтовская А.А.</div>
          <div class="col-md-4">(<a href="#">анкета</a>)</div>
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Заявление</a></div>
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Договор</a></div>
          <div class="col-md-4"><a class="btn btn-warning" role="button" href="#">Оплата</a></div>
        </div>
        <div class="row border-bottom py-2">
          <div class="col-md-8">Темрюковна М.</div>
          <div class="col-md-4">(<a href="#">анкета</a>)</div>
          <div class="col-md-4"><a class="btn btn-success" role="button" href="#">Заявление</a></div>
          <div class="col-md-4"><a class="btn btn-warning" role="button" href="#">Договор</a></div>
          <div class="col-md-4"><a class="btn btn-warning" role="button" href="#">Оплата</a></div>
        </div>
        <div class="row border-bottom py-2">
          <div class="col-md-8">Глинская Е.В.</div>
          <div class="col-md-4">(<a href="#">анкета</a>)</div>
          <div class="col-md-4"><a class="btn btn-warning" role="button" href="#">Заявление</a></div>
          <div class="col-md-4"><a class="btn btn-secondary" role="button" href="#">Договор</a></div>
          <div class="col-md-4"><a class="btn btn-secondary" role="button" href="#">Оплата</a></div>
        </div>
        <div class="row border-bottom py-2">
          <div class="col-md-8">Палеолог С.Ф.</div>
          <div class="col-md-4">(<a href="#">анкета</a>)</div>
          <div class="col-md-4">
            <a class="btn btn-warning" role="button" href="#" data-bs-toggle="modal" data-bs-target="#exampleModal">Заявление</a>
          </div>
          <div class="col-md-4"><a class="btn btn-success" data-bs-toggle="modal" data-bs-target="#exampleModal2" role="button" href="#">Договор</a></div>
          <div class="col-md-4"><a class="btn btn-secondary" role="button" href="#">Оплата</a></div>
        </div>
      </div>
    </div>
    
    {admin:modal1()}
    {admin:modal2()}
    
  </div>
};


declare function admin:modal1(){
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Заявление слушателя</h5>
            <button type="button" class="close" data-dismiss="modal" data-bs-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">х</span>
            </button>
          </div>
          <div class="modal-body">
            <div class="row">
              <div class="col-md-12">Заявление слушателя: <strong>Палеолог С.В.</strong></div>
              <div class="col-md-12">Курс: <strong>"Программы ФГОС 3+"</strong></div>
              <div class="col-md-12">Статус: <strong class="text-warning">Не верифицирован</strong></div>
              <div class="col-md-6 my-1"><button type="button" class="btn btn-primary">Скачать</button></div>
              <div class="col-md-6 my-1"><button type="button" class="btn btn-success">Верифицировать</button></div>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
            <button type="button" class="btn btn-primary">Сохранить изменения</button>
          </div>
        </div>
      </div>
    </div>
};

declare function admin:modal2(){
  <div class="modal fade" id="exampleModal2" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Заявление слушателя</h5>
          <button type="button" class="close" data-dismiss="modal" data-bs-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">х</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-12">Заявление слушателя: <strong>Палеолог С.В.</strong></div>
            <div class="col-md-12">Курс: <strong>"Программы ФГОС 3+"</strong></div>
            <div class="col-md-12">Статус: <strong class="text-success">Верифицирован</strong></div>
         </div>
         <div class="row">
          <div class="col-md-3 my-1"><button type="button" class="btn btn-primary">Скачать</button></div>
          <div class="col-md-6 my-1"><button type="button" class="btn btn-danger">Отменить верификацию</button></div>
        </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
          <button type="button" class="btn btn-primary">Сохранить изменения</button>
        </div>
      </div>
    </div>
  </div>
};