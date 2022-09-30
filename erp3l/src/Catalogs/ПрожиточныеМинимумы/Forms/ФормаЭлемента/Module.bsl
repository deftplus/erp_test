
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		
		РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(ЭтаФорма, "ВеличинаПрожиточногоМинимума", СсылкаНаОбъект);
		
		ЗначенияДляЗаполнения = Новый Структура("ПредыдущийМесяц", "ВеличинаПрожиточногоМинимума.Период");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ВеличинаПрожиточногоМинимума.Период", "ВеличинаПрожиточногоМинимумаПериодСтрокой");
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	СсылкаНаОбъект = Объект.Ссылка;
	
	ПрочитатьВеличинуПрожиточногоМинимума();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаписатьВеличинуПрожиточногоМинимума(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьВеличинуПрожиточногоМинимума();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СсылкаНаОбъект, ИмяСобытия, Параметр, Источник);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "ВеличинаПрожиточногоМинимума.Период", "ВеличинаПрожиточногоМинимумаПериодСтрокой");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "ВеличинаПрожиточногоМинимума", СсылкаНаОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаРазмерПриИзменении(Элемент)
	
	РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(ЭтаФорма, "ВеличинаПрожиточногоМинимума", СсылкаНаОбъект);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Редактирование месяца строкой.

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаПериодСтрокойПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "ВеличинаПрожиточногоМинимума.Период", "ВеличинаПрожиточногоМинимумаПериодСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
		ЭтаФорма,
		ЭтаФорма,
		"ВеличинаПрожиточногоМинимума.Период",
		"ВеличинаПрожиточногоМинимумаПериодСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "ВеличинаПрожиточногоМинимума.Период", "ВеличинаПрожиточногоМинимумаПериодСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаПериодСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаПериодСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВеличинаПрожиточногоМинимумаИстория(Команда)
	
	РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("ВеличинаПрожиточногоМинимума", СсылкаНаОбъект, ЭтаФорма, ТолькоПросмотр);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПрочитатьВеличинуПрожиточногоМинимума()
	
	РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "ВеличинаПрожиточногоМинимума", СсылкаНаОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВеличинуПрожиточногоМинимума(ТекущийОбъект)
	
	РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "ВеличинаПрожиточногоМинимума", ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьРежимИзмененияВеличины(ФормаИсточник, ДатаИзменения, Отказ, ОповещениеЗавершения)
	
	ТекстКнопкиДа = НСтр("ru = 'Изменилась величина прожиточного минимума';
						|en = 'The subsistence rate is changed'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'При редактировании Вы изменили величину прожиточного минимума. 
					|Если Вы исправили прежнюю запись величины прожиточного минимума (она была ошибочной), нажмите ""Исправлена ошибка"".
					|Если у прожиточного минимума изменился размер с %1, нажмите ""%2""';
					|en = 'When editing, you changed the subsistence rate.
					|If you just corrected the previous subsistence rate record (it was incorrect), click ""Error is corrected"".
					|If the subsistence rate is changed from %1, click ""%2""'"), 
			Формат(ДатаИзменения, "ДФ='д ММММ гггг ""г""'"),
			ТекстКнопкиДа);
	
	РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ФормаИсточник, "ВеличинаПрожиточногоМинимума", ТекстВопроса, ТекстКнопкиДа, Отказ, ОповещениеЗавершения);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ЗаписьЭлемента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено) Экспорт 

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ЗапроситьРежимИзмененияВеличины(ЭтаФорма, ВеличинаПрожиточногоМинимума.Период, Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 

	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
