#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Заголовок = НСтр("ru = 'Информация о синхронизации данных с конфигурацией ""1С:Документооборот""';
					|en = 'Information about data synchronization with 1C:Document Management'");
	
	Макет = ПланыОбмена.ОбменУправлениеПредприятиемДокументооборот20.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();

КонецПроцедуры

#КонецОбласти