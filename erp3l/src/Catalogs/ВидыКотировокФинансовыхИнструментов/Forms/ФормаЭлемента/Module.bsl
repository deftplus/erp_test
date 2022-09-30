
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ПодготовитьФормуНаСервере();
	ТекущееЗначениеКотировки = ПолучитьЗначениеКотировки(Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипКотировкиПриИзменении(Элемент)
	ОбновитьВидимостьРеквизитов();
КонецПроцедуры
&НаКлиенте
Процедура ФункциональнаяВалютаПриИзменении(Элемент)
	ОбновитьВидимостьРеквизитов();
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	ОбновитьВидимостьРеквизитов();
КонецПроцедуры

&НаКлиенте
Процедура ЦеннаяБумагаПриИзменении(Элемент)
	ОбновитьВидимостьРеквизитов();
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	КэшируемыеЗначения = Новый Структура;
	
	ТипыКотировок = МСФОВызовСервераУХ.ПолучитьСтруктуруСоЗначениямиПеречисления("ТипыКотировокФинансовыхИнструментов");
	КэшируемыеЗначения.Вставить("ТипыКотировок", ТипыКотировок);
	
	ОбновитьВидимостьРеквизитов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьРеквизитов()

	ТипыКотировок = КэшируемыеЗначения.ТипыКотировок;	
	ПоляОтображения = "Валюта,ФункциональнаяВалюта,Контрагент,ЦеннаяБумага,ФиксированноеЗначение,
						|БазовыйВидКотировки,ВидКотировкиПоправка,ЗначениеНадБазовой,ПроцентНадБазовой";
	
	Элементы.ФункциональнаяВалюта.ТолькоПросмотр = Ложь;
	Если Объект.ТипКотировки = ТипыКотировок.КурсВалюты Тогда
		
		ВидимыеПоля = "Валюта,ФункциональнаяВалюта,ДекорацияОписание";
		
	ИначеЕсли Объект.ТипКотировки = ТипыКотировок.РыночнаяСтавкаПроцента Тогда
		
		ВидимыеПоля = "";
		
	ИначеЕсли Объект.ТипКотировки = ТипыКотировок.БанковскаяКотировка Тогда
		
		ВидимыеПоля = "Валюта,Контрагент,ФункциональнаяВалюта";
		Элементы.Контрагент.Заголовок = "Банк";
		
	ИначеЕсли Объект.ТипКотировки = ТипыКотировок.БанковскаяСтавкаПроцента Тогда
		
		ВидимыеПоля = "Контрагент";
		Элементы.Контрагент.Заголовок = "Банк";
		
	ИначеЕсли Объект.ТипКотировки = ТипыКотировок.КотировкаЦеннойБумаги Тогда
		
		ВидимыеПоля = "ЦеннаяБумага,ФункциональнаяВалюта,ДекорацияОписание";
		Элементы.ФункциональнаяВалюта.ТолькоПросмотр = Истина;
		
		Объект.ФункциональнаяВалюта = Объект.ЦеннаяБумага.ВалютаНоминала;
		
	Иначе
		
		ВидимыеПоля = "";
	
	КонецЕсли;
	
	Элементы.ДекорацияОписание.Заголовок = Справочники.ВидыКотировокФинансовыхИнструментов.ПолучитьОписаниеЗначенияКотировки(Объект);
	
	Видимые = Новый Структура(ВидимыеПоля);	
	
	Для каждого ПолеОтображения Из Новый Структура(ПоляОтображения) Цикл
		Элементы[ПолеОтображения.Ключ].Видимость = Видимые.Свойство(ПолеОтображения.Ключ);
	КонецЦикла;

КонецПроцедуры

// Возвращает последнее значение котировки КотировкаВход. Когда значение не задано - 
// будет возвращено нулевое.
Функция ПолучитьЗначениеКотировки(КотировкаВход)
	РезультатФункции = 0;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗначенияКотировокФИСрезПоследних.Значение
		|ИЗ
		|	РегистрСведений.ЗначенияКотировокФИ.СрезПоследних(, ВидКотировки = &ВидКотировки) КАК ЗначенияКотировокФИСрезПоследних";
	Запрос.УстановитьПараметр("ВидКотировки", КотировкаВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции = ВыборкаДетальныеЗаписи.Значение;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

#КонецОбласти

