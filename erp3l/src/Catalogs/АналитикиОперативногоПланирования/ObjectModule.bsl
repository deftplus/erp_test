
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	МассивЛимитируемыхАналитик = Справочники.АналитикиОперативногоПланирования.ПолучитьЛимитируемыеАналитики();
	ВозможноЛимитирование = Предопределенный И МассивЛимитируемыхАналитик.Найти(Ссылка) <> неопределено;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 