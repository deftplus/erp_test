//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьКомпоновщикНастроек();
	
	ПараметрОтбора = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек.ФиксированныеНастройки, "Подразделение");
	
	ПараметрОтбора.Значение = Параметры.Подразделение;
	ПараметрОтбора.Использование = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнить(Команда)
	
	Закрыть(ПоместитьНастройкиВХранилище(ВладелецФормы.УникальныйИдентификатор));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ИнициализироватьКомпоновщикНастроек()
	
	СхемаКомпоновкиДанных = Обработки.НастройкаПередачиМатериаловВПроизводство.ПолучитьМакет("ОтборНоменклатуры");
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных); 
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьНастройкиВХранилище(УникальныйИдентификаторВладельца)
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	ВключитьОтборПоСпецификациям(КомпоновщикНастроек);

	Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификаторВладельца);

КонецФункции
 
&НаСервере
Процедура ВключитьОтборПоСпецификациям(КомпоновщикНастроек)

	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	СписокВозможныхПолей = Новый Массив;
	СписокВозможныхПолей.Добавить("Спецификация");
	СписокВозможныхПолей.Добавить("Этап");
	СписокВозможныхПолей.Добавить("Этап.Подразделение");
	
	Использование = Ложь;
	Для каждого ИмяПоля Из СписокВозможныхПолей Цикл
		ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(НастройкиОсновнойСхемы.Отбор, ИмяПоля);
		Для каждого ЭлементОтбора Из ЭлементыОтбора Цикл
			Если ЭлементОтбора.Использование Тогда
				Использование = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если Использование Тогда
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	ПараметрОтбора = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		КомпоновщикНастроек.ФиксированныеНастройки, "ИспользуетсяОтборПоСпецификации");
	
	ПараметрОтбора.Значение = Истина;
	ПараметрОтбора.Использование = Использование;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Устарело_Производство21