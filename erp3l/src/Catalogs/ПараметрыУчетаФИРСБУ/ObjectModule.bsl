#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ЗначениеЗаполнено(ФИ) Тогда		
		МассивНепроверяемыхРеквизитов.Добавить("ВидФИ");
	Иначе 
		МассивНепроверяемыхРеквизитов.Добавить("ФИ");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПараметрыУчетаФИРСБУ.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПараметрыУчетаФИРСБУ КАК ПараметрыУчетаФИРСБУ
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПараметрыУчетаФИРСБУ КАК ТекущиеПараметры
	|		ПО (ТекущиеПараметры.Ссылка = &Ссылка)
	|			И ПараметрыУчетаФИРСБУ.ВидФИ = ТекущиеПараметры.ВидФИ
	|			И ПараметрыУчетаФИРСБУ.ФИ = ТекущиеПараметры.ФИ
	|			И ПараметрыУчетаФИРСБУ.Актив = ТекущиеПараметры.Актив
	|			И ПараметрыУчетаФИРСБУ.Ссылка <> ТекущиеПараметры.Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат;	
	КонецЕсли;
	
	Отказ = Истина;
	Сообщить(Нстр("ru = 'Настройка с такими параметрами уже существует'"));
	
КонецПроцедуры

#КонецЕсли