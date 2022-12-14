
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Ключ.Пустая() Тогда
		
		СправочникОбъект = РеквизитФормыВЗначение("Объект");
		Шаблон           = СправочникОбъект.Шаблон.Получить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Модифицированность = Истина;
	Шаблон = ВыбранноеЗначение;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Шаблон = Новый ХранилищеЗначения(Шаблон);
		
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.
//
&НаКлиенте
Процедура РедактироватьШаблон(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ШаблонПроцесса) Тогда
						
		ОткрытьФорму("Справочник.ШаблоныОповещений.Форма.ФормаРедактированияШаблона_Управляемая"
		, Новый Структура("СсылкаНаОбъект, ТипШаблона, Шаблон, ЭтапПроцесса, ТипОбъектаОповещения, ВидОбъектаОповещения, НазначениеОповещения, ВидСобытияОповещения"
		, Объект.Ссылка
		, Объект.ТипШаблона
		, Шаблон
		, Объект.ЭтапПроцесса
		, Объект.ТипОбъектаОповещения
		, Объект.ШаблонПроцесса
		, Объект.КатегорияОповещения
		, Объект.НазначениеОповещения)
		, ЭтаФорма);
		
	Иначе
				
		ОткрытьФорму("Справочник.ШаблоныОповещений.Форма.ФормаРедактированияШаблонаУниверсальногоПроцесса"
		, Новый Структура("СсылкаНаОбъект, ТипШаблона, Шаблон, ШаблонПроцесса"
		, Объект.Ссылка
		, Объект.ТипШаблона
		, Шаблон
		, Объект.ШаблонПроцесса)
		, ЭтаФорма);
				
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ.
//






