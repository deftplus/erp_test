//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Склад");
	МассивНепроверяемыхРеквизитов.Добавить("Товары.ОснованиеДляПолучения");
	
	ИспользоватьНесколькоСкладов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
	
	ШаблонСообщенияСклад     = НСтр("ru = 'Не заполнена колонка ""Склад"" в строке %1.';
									|en = 'The ""Warehouse"" column is not populated in line %1.'");
	ШаблонСообщенияОснование = НСтр("ru = 'Не заполнена колонка ""Основание для получения"" в строке %1.';
									|en = 'The ""Receipt basis"" column is not populated in line %1.'");
	Для каждого ДанныеСтроки Из Товары Цикл
		
		Если ДанныеСтроки.СпособНастройки <> Перечисления.СпособыНастройкиПередачиМатериаловВПроизводство.НастраиваетсяИндивидуально Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.Склад) И ИспользоватьНесколькоСкладов Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщенияСклад, ДанныеСтроки.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ДанныеСтроки.НомерСтроки, "Склад");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле, "Объект", Отказ);
		КонецЕсли; 
		
		Если НЕ ЗначениеЗаполнено(ДанныеСтроки.ОснованиеДляПолучения) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщенияОснование, ДанныеСтроки.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ДанныеСтроки.НомерСтроки, "ОснованиеДляПолучения");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, Поле, "Объект", Отказ);
		КонецЕсли; 
		
	КонецЦикла; 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21