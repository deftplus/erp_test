#Область СлужебныйПрограммныйИнтерфейс

Процедура НастроитьФормуОбъектаУчета(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФормы = Форма.ИмяФормы;
	
	Если ИмяФормы= "Справочник.ДоговорыКонтрагентов.Форма.ФормаЭлемента" Тогда
		ОбщийМодуль = ДоговорыКонтрагентовФормыБМ;
	ИначеЕсли ИмяФормы = "Справочник.ЦенныеБумаги.Форма.ФормаЭлемента" Тогда
		ОбщийМодуль = ЦенныеБумагиФормыБМ;
	ИначеЕсли ИмяФормы = "Справочник.Организации.Форма.ФормаОрганизации" Тогда
		ОбщийМодуль = ОрганизацииФормыБМ;
	
	Иначе
		ОбщийМодуль = Неопределено;			// Неизвестный вариант объекта учета, не доопределяем форму.
	КонецЕсли;
	
	Если ОбщийМодуль <> Неопределено Тогда
		ОбщийМодуль.НастроитьФормуОбъектаУчета(Форма, Отказ, СтандартнаяОбработка)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
