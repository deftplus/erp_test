//++ Устарело_Производство21
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент(ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ПараметрыПроверкиКоличества = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверкиКоличества.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыПроверкиКоличества.УсловиеОтбораСтрокДляОкругления = "МатериалыИУслуги.ЗаказатьНаСклад = ИСТИНА";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества);
	
	ПараметрыПроверкиХарактеристик = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверкиХарактеристик.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ, ПараметрыПроверкиХарактеристик);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЗаказНаПроизводство),
		Отказ,
		МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыОкругления = НоменклатураСервер.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "МатериалыИУслуги";
	ПараметрыОкругления.УсловиеОтбораСтрокДляОкругления = "МатериалыИУслуги.ЗаказатьНаСклад = ИСТИНА";
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
	ЗаполнитьНовыйКодСтроки();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

Процедура ЗаполнитьНовыйКодСтроки()

	СтруктураПоиска = Новый Структура("КодСтроки", 0);
	СтрокиСПустымКодом = МатериалыИУслуги.НайтиСтроки(СтруктураПоиска);
	Если СтрокиСПустымКодом.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("Документ.КорректировкаЗаказаМатериаловВПроизводство");
	ЭлементБлокировки.УстановитьЗначение("Распоряжение", Распоряжение);
	
	ЭлементБлокировки = Блокировка.Добавить("Документ.ЗаказНаПроизводство");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", Распоряжение);
	
	Блокировка.Заблокировать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.КодСтроки), 0) КАК КодСтроки
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказНаПроизводствоМатериалыИУслуги.КодСтроки КАК КодСтроки
	|	ИЗ
	|		Документ.ЗаказНаПроизводство.МатериалыИУслуги КАК ЗаказНаПроизводствоМатериалыИУслуги
	|	ГДЕ
	|		ЗаказНаПроизводствоМатериалыИУслуги.Ссылка = &Распоряжение
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		КорректировкаЗаказаМатериаловВПроизводство.МаксимальныйКодСтроки
	|	ИЗ
	|		Документ.КорректировкаЗаказаМатериаловВПроизводство КАК КорректировкаЗаказаМатериаловВПроизводство
	|	ГДЕ
	|		КорректировкаЗаказаМатериаловВПроизводство.Распоряжение = &Распоряжение) КАК ВложенныйЗапрос";
	
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	МаксимальныйКодСтроки = Выборка.КодСтроки;
	
	Для каждого ДанныеСтроки Из СтрокиСПустымКодом Цикл
		МаксимальныйКодСтроки = МаксимальныйКодСтроки + 1;
		ДанныеСтроки.КодСтроки = МаксимальныйКодСтроки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
//-- Устарело_Производство21