
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Элементы.ГруппаОтражениеВМеждународномУчете.Видимость = Ложь;
//++ НЕ УТКА
	ПолучитьСостояниеУточненияСчетовУчета();
//-- НЕ УТКА

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
//++ НЕ УТКА
	Если ИмяСобытия = "ИзмененыНастройкиУточненияСчетовУчета" Тогда
		ПолучитьСостояниеУточненияСчетовУчета();
	КонецЕсли;
//-- НЕ УТКА
	Возврат; // в УТ11 обработчик пустой

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ НЕ УТКА

&НаСервере
Процедура ПолучитьСостояниеУточненияСчетовУчета()
	
	МеждународныйУчетОбщегоНазначения.УстановитьВидимостьНастроекМФУ(
		Объект.Ссылка,
		Элементы.ГруппаОтражениеВМеждународномУчете,
		Элементы.Найти("НастроитьУточнениеСчетов"));// у ограниченных пользователей элемент вырезается с формы
	
КонецПроцедуры
//-- НЕ УТКА

#КонецОбласти
