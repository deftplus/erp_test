
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры,"Валюта,Организация");
	Если ЗначениеЗаполнено(Организация) Тогда
		Элементы.УстанавливатьПоВсемОрганизациям.ФорматРедактирования = 
			СтрШаблон("БЛ='%1'; БИ='%2'", 
				СтрШаблон(Нстр("ru = 'По организации %1'", Организация)),
				Нстр("ru = 'По всем организациям'"));
	Иначе
		Элементы.УстанавливатьПоВсемОрганизациям.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УстанавливатьСуммуПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УстанавливатьАвтоматическийПереводПриИзменении(Элемент)
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	Результат = Новый Структура;
	Если Не УстанавливатьПоВсемОрганизациям Тогда
		Результат.Вставить("Организация", Организация);
	КонецЕсли;
	
	Если УстанавливатьСумму Тогда
		Результат.Вставить("МаксимальныйОстаток", МаксимальныйОстаток);
	КонецЕсли;
	
	Если УстанавливатьАвтоматическийПеревод Тогда
		Результат.Вставить("ПереводитьАвтоматически", ПереводитьАвтоматически);
	КонецЕсли;
	
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.МаксимальныйОстаток.ТолькоПросмотр = Не Форма.УстанавливатьСумму;
	Элементы.ПереводитьАвтоматически.ТолькоПросмотр = Не Форма.УстанавливатьАвтоматическийПеревод;
	
КонецПроцедуры

#КонецОбласти

