//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
//	НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
//	ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
//	Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыПеремещенияМатериаловВПроизводстве[НовыйСтатус];
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПеремещениеМатериаловВПроизводстве);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект, ПараметрыУказанияСерий);
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Перем РеквизитыШапки;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПеремещениеМатериаловВПроизводстве);
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, ПараметрыУказанияСерий);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	МассивНепроверяемыхРеквизитов = Новый Массив;

	ПараметрыПроверкиКоличества = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверкиКоличества.ИмяТЧ = "МатериалыИРаботы";
	ПараметрыПроверкиКоличества.ПроверитьВозможностьОкругления = Ложь;
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества);

	Если ЗначениеЗаполнено(ПодразделениеОтправитель) И ПодразделениеОтправитель = ПодразделениеПолучатель Тогда

		ТекстСообщения = НСтр("ru = 'Одно подразделение не может быть как отправителем, так и получателем. Измените одно из подразделений.';
								|en = 'The same business unit cannot be both shipping and receiving. Change one of business units.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,ЭтотОбъект, "ПодразделениеОтправитель",,Отказ);

	КонецЕсли;

	ПараметрыПроверкиХарактеристик = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверкиХарактеристик.ИмяТЧ = "МатериалыИРаботы";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверкиХарактеристик);
	
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ПеремещениеМатериаловВПроизводстве);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	Серии.Очистить();
	
	Для Каждого СтрокаТЧ Из МатериалыИРаботы Цикл
		СтрокаТЧ.Назначение            = Неопределено;
		СтрокаТЧ.НазначениеОтправителя = Неопределено;
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//    Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 1;
	СтрокаТаб.ЗначениеДоступа = Организация;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 1;
	СтрокаТаб.ЗначениеДоступа = ПодразделениеОтправитель;

	СтрокаТаб = Таблица.Добавить();
	СтрокаТаб.НомерНабора     = 2;
	СтрокаТаб.ЗначениеДоступа = ПодразделениеПолучатель;

КонецПроцедуры

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21