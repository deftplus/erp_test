
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	НастройкаПравДоступаУХ.ОбновитьДляГруппы("Бланк", Ссылка);
	
КонецПроцедуры
	
#КонецЕсли
