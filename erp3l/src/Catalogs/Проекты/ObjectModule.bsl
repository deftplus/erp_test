#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (Проект ИЛИ ЗначениеЗаполнено(Родитель)) Тогда
		
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Для этапа проекта необходимо указать проект-родитель.'"),Отказ,,СтатусСообщения.Важное);
		Возврат;
		
	КонецЕсли;
	
	Если Проект Тогда
		
		Если ЭтоНовый() Тогда
			УстановитьСсылкуНового(Справочники.Проекты.ПолучитьСсылку());
			ПроектЭтапа = ПолучитьСсылкуНового();
		Иначе
			ПроектЭтапа = Ссылка;
		КонецЕсли;
		
	Иначе
		
		ТекущийРодитель=Родитель;
		
		Пока Истина Цикл
			
			Если НЕ ЗначениеЗаполнено(ТекущийРодитель) Тогда
				
				ПроектЭтапа=Справочники.Проекты.ПустаяСсылка();
				Прервать;
			
			ИначеЕсли ТекущийРодитель.Проект Тогда
				
				ПроектЭтапа= ТекущийРодитель;
				Прервать;
				
			Иначе
				
				ТекущийРодитель=ТекущийРодитель.Родитель;
				
			КонецЕсли;
			
		КонецЦикла;	
		
	КонецЕсли;
				
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

#КонецЕсли