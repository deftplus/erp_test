
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Адрес = Неопределено;
	Параметры.Свойство("Адрес", Адрес);
	ОтборНоменклатурыНастройка = ПолучитьИзВременногоХранилища(Адрес);
	УдалитьИзВременногоХранилища(Адрес);
	
	СхемаКомпоновкиДанных = Обработки.ПомощникОформленияСкладскихАктов.ПолучитьМакет("ОтборНоменклатурыОсновнойУТКА");
	//++ НЕ УТКА
	СхемаКомпоновкиДанных = Обработки.ПомощникОформленияСкладскихАктов.ПолучитьМакет("ОтборНоменклатурыОсновной");
	//-- НЕ УТКА
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
	ОтборНоменклатуры.Инициализировать(ИсточникНастроек);
	ОтборНоменклатуры.ЗагрузитьНастройки(ОтборНоменклатурыНастройка);
	ОтборНоменклатуры.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаОК(Команда)
	
	Закрыть(ПоместитьНастройкиОтборНоменклатурыВоВременноеХранилище(ОтборНоменклатуры));
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПоместитьНастройкиОтборНоменклатурыВоВременноеХранилище(ОтборНоменклатуры)
	ОтборНоменклатурыНастройка = ОтборНоменклатуры.ПолучитьНастройки();
	Возврат ПоместитьВоВременноеХранилище(ОтборНоменклатурыНастройка);
КонецФункции

#КонецОбласти





