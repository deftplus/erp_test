
&НаКлиенте
Процедура Сохранить(Команда)
		
	ПерезаписатьНастройку = Ложь;
	
	Для Каждого Стр Из СохраненныеНастройки Цикл
		Если Стр.ИмяНастройки =  НаименованиеНастройки Тогда	
			 ПерезаписатьНастройку = Истина;	
		КонецЕсли;		
	КонецЦикла;	

	Если ПерезаписатьНастройку Тогда
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение",ЭтаФорма);
		
		СтрокаШаблона = Нстр("ru = 'Заменить ранее сохраненный вариант настройки таблицы: %1 ?'");
		
		Если Не ПустаяСтрока(СтрокаШаблона) тогда
			ПоказатьВопрос(Оповещение, СтрШаблон(СтрокаШаблона, НаименованиеНастройки), РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
			
	Иначе	
		ПризнакМодификации = Ложь;
		Закрыть(Новый Структура("Вариант",НаименованиеНастройки));
	КонецЕсли;	
		
КонецПроцедуры


&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПризнакМодификации = Ложь;
		Закрыть(Новый Структура("Вариант",НаименованиеНастройки));	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередУдалениемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНастройки(Элементы.СохраненныеНастройки.ТекущиеДанные.ИмяНастройки);	
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НаименованиеНастройки   = Параметры.ИмяТекущейНастройки;
	Бланк                   = Параметры.Бланк;
	СписокДоступныхНастроек = ПолучитьИзВременногоХранилища(Параметры.СписокДоступныхНастроекАдрес);
	
	Для Каждого Стр Из СписокДоступныхНастроек Цикл
		НЭлНастройки = СохраненныеНастройки.Добавить();
		НЭлНастройки.ИмяНастройки 		= Стр.ИмяВарианта;
		НЭлНастройки.ОсновнаяНастройка  = Стр.ОсновнаяНастройка;
		Если НЭлНастройки.ОсновнаяНастройка Тогда
			 ИмяБланка = Стр.ИмяВарианта;
		КонецЕсли;	
		
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура СохраненныеНастройкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные.ОсновнаяНастройка Тогда
		НаименованиеНастройки = ПолучитьИмяНовойНастройки();
		Элементы.НаименованиеНастройки.Подсказка = Нстр("ru ='Будет сохранен новый вариант сводной таблицы'"); 
	Иначе		
		НаименованиеНастройки = Элемент.ТекущиеДанные.ИмяНастройки;
		Элементы.НаименованиеНастройки.Подсказка = Нстр("ru ='Будет перезаписан существующий вариант сводной таблицы'");	
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СохраненныеНастройкиПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ОсновнаяНастройка Тогда
		 ПоказатьПредупреждение(,Нстр("ru = 'Невозможно удалить основной вариант сводной таблицы'"));
		 Отказ = Истина;
	Иначе	
		Оповещение = Новый ОписаниеОповещения("ВопросПередУдалениемЗавершение",ЭтаФорма);
		
		СтрокаШаблона = Нстр("ru = 'Удалить ранее сохраненный вариант настройки таблицы: %1 ?'");
		
		Если Не ПустаяСтрока(СтрокаШаблона) тогда
			ПоказатьВопрос(Оповещение, СтрШаблон(СтрокаШаблона, НаименованиеНастройки), РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
			
        Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяНовойНастройки()
	
	Для ИндНастройки = 1 по 1000 Цикл
		
		СтрокаШаблона = Нстр("ru = '%1 вариант (%2)'");
		
		ИмяНовойНастройки = "";
		Если Не ПустаяСтрока(СтрокаШаблона) тогда
			ИмяНовойНастройки = СтрШаблон(СтрокаШаблона, ИмяБланка, Строка(ИндНастройки));
		КонецЕсли;
				
		Если СохраненныеНастройки.НайтиСтроки(Новый Структура("ИмяНастройки",ИмяНовойНастройки)).Количество()=0 Тогда	
			Возврат  ИмяНовойНастройки;	
		КонецЕсли;			
	КонецЦикла;
	
	Возврат ИмяНовойНастройки;
		
КонецФункции

Процедура УдалитьВариантНастройки(ИмяНастройки)
	
	нВарианты = РегистрыСведений.ВариантыНастроекБланковСТ.СоздатьМенеджерЗаписи();
	нВарианты.Бланк 	   = Бланк;
	нВарианты.ИмяНастройки = ИмяНастройки;
	нВарианты.Пользователь = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	
	нВарианты.Прочитать();
	нВарианты.Удалить();
    нВарианты.Записать();
	
	СохраненныеНастройки.Удалить(СохраненныеНастройки.НайтиПоИдентификатору(Элементы.СохраненныеНастройки.ТекущаяСтрока));
	ПризнакМодификации = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПризнакМодификации Тогда
		  СтандартнаяОбработка = Ложь;
		  Закрыть(Новый Структура("ОбновитьВарианты",Истина));	
	КонецЕсли;	
		
КонецПроцедуры



