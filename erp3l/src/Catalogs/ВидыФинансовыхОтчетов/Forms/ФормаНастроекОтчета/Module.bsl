
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыводитьКодСтроки   = Параметры.ВыводитьКодСтроки;
	ВыводитьПримечание  = Параметры.ВыводитьПримечание;
	ЗаголовокКодаСтроки = Параметры.ЗаголовокКодаСтроки;
	ЗаголовокПримечания = Параметры.ЗаголовокПримечания;
	ЯзыкОтчета          = Параметры.ЯзыкОтчета;
	ТолькоПросмотр      = Параметры.ТолькоПросмотр;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЯзыкОтчетаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ПолучитьКодыЯзыков(); 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	НастройкиОтчета = Новый Структура;
	НастройкиОтчета.Вставить("ВыводитьКодСтроки",   ВыводитьКодСтроки);
	НастройкиОтчета.Вставить("ВыводитьПримечание",  ВыводитьПримечание);
	НастройкиОтчета.Вставить("ЗаголовокКодаСтроки", ЗаголовокКодаСтроки);
	НастройкиОтчета.Вставить("ЗаголовокПримечания", ЗаголовокПримечания);
	НастройкиОтчета.Вставить("ЯзыкОтчета",          ЯзыкОтчета);
	
	Закрыть(НастройкиОтчета);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьКодыЯзыков()
	
	КодыЯзыков = Новый СписокЗначений; 
	МеждународнаяОтчетностьКлиентЛокализация.СписокЯзыковОтчетности(КодыЯзыков);
	
	КодыЯзыков.Добавить("en", НСтр("ru = 'Английский';
									|en = 'English'"));
	КодыЯзыков.Добавить("ru", НСтр("ru = 'Русский';
									|en = 'Russian'"));
	
	Возврат КодыЯзыков; 
	
КонецФункции

#КонецОбласти