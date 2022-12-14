
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДекорацияОписание.Заголовок = Параметры.ТекстИнформации;
	
	Если Параметры.ЭтоОшибка Тогда
		НашлиКартинку = ПолучитьКартинкуПодсистемы("ДиалогСтоп");
	Иначе
		НашлиКартинку = ПолучитьКартинкуПодсистемы("ДиалогИнформация");
	КонецЕсли;
	
	Если НашлиКартинку.Вид <> ВидКартинки.Пустая Тогда
		Элементы.ДекорацияКартинка.Картинка = НашлиКартинку;
	Иначе
		Элементы.ДекорацияКартинка.Картинка = Новый Картинка;
		Элементы.ДекорацияКартинка.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СформироватьРезультат(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьРезультат(ТекущееЗначение)
	
	Закрыть(ТекущееЗначение);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКартинкуПодсистемы(ИмяКартинки) 
	
	ИщемКартинку = Новый Структура(ИмяКартинки);
	Результат = Неопределено;
	
	Попытка 
		ЗаполнитьЗначенияСвойств(ИщемКартинку, БиблиотекаКартинок);
		ИщемКартинку.Свойство(ИмяКартинки, Результат);
	Исключение
		Результат = Новый Картинка;
	КонецПопытки;
	
	Если Результат = Неопределено Тогда
		Результат = Новый Картинка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

