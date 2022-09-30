
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Отказ = Параметры.Свойство("ОтказАналитика");
	
	Если Отказ тогда
		Возврат;
	КонецЕсли;
		
	// Получение параметров.	
	Периодичность            = Параметры.ПериодПланированияОтборНачало.Периодичность;
	ДатаНачалаПериода		 = Параметры.ПериодПланированияОтборНачало.ДатаНачала;
	ДатаОкончанияПериода	 = Параметры.ПериодПланированияОтборОкончание.ДатаОкончания;
	
	Элементы.ВидОтчета.СписокВыбора.ЗагрузитьЗначения(Параметры.ВидыОтчетов.ВыгрузитьЗначения());
	ВидОтчета   = Параметры.ВидыОтчетов[0].Значение; 
	
	
	Если Параметры.Сценарии <> Неопределено Тогда
		Сценарии.ЗагрузитьЗначения(Параметры.Сценарии);	
	Иначе
		Сценарии = Новый СписокЗначений;
	КонецЕсли;
	Если Параметры.Организации <> Неопределено Тогда
		Организации.ЗагрузитьЗначения(Параметры.Организации);
	Иначе
		Организации = Новый  СписокЗначений;
	КонецЕсли;
	Если Параметры.Проекты <> Неопределено Тогда
		Проекты.ЗагрузитьЗначения(Параметры.Проекты);
	Иначе
		Проекты = Новый СписокЗначений;
	КонецЕсли;
	
	ВидОтчетаПриИзмененииСервер();
	
	Если Лев(Метаданные.Версия, 4) = "3.1." Тогда
		Элементы.ВложенияСогласования.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидыОтчетовПриИзменении(Элемент)
	
	ВидОтчетаПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ВидОтчетаПриИзмененииСервер()
	
	МаксАналитикОтчета = ОбщегоНазначенияУХ.ВернутьКоличествоАналитикНаУровнеОтчета(ВидОтчета);
	МассивТипов = Новый Массив;
	ТаблицаСогласованияИзменена = Ложь;
	нРеквизиты = Новый Массив;
	ДанныеСогласования.Очистить();
	
	Для ИндексАналитики = 1 По МаксАналитикОтчета Цикл
		ИндАналитики = Строка(ИндексАналитики);
		МассивТипов.Очистить();
		
		Если Параметры.Свойство("Аналитика" + ИндАналитики, ЭтаФорма["Аналитика" + ИндАналитики]) тогда
			ТипЗначенияАналитики = ТипЗнч(Параметры["Аналитика" + ИндАналитики]);
		ИначеЕсли Параметры.Свойство("АналитикаСтроки" + ИндАналитики, ЭтаФорма["АналитикаСтроки" + ИндАналитики]) тогда
			ТипЗначенияАналитики = ТипЗнч(Параметры["АналитикаСтроки" + ИндАналитики]);
			ТаблицаЗначенийАналитики = РеквизитФормыВЗначение("ЗначенияАналитики" + ИндАналитики);
			МассивЗначенийАналитики = Параметры["ЗначенияАналитики" + ИндАналитики];
			
			Для Каждого ЗначениеАналитики Из МассивЗначенийАналитики Цикл			
			    НоваяСтрокаЗначений = ТаблицаЗначенийАналитики.Добавить();
				НоваяСтрокаЗначений.Аналитика = ЗначениеАналитики;
			КонецЦикла;
			
			ЗначениеВРеквизитФормы(ТаблицаЗначенийАналитики, "ЗначенияАналитики" + ИндАналитики);
		Иначе
			Продолжить;
		КонецЕсли;
		
		МассивТипов.Добавить(ТипЗначенияАналитики);
		нРеквизиты.Добавить(Новый РеквизитФормы("Аналитика" + ИндАналитики, Новый ОписаниеТипов(МассивТипов), "ДанныеСогласования", Строка(Объект.ВидОтчета["ВидАналитики" + ИндАналитики])));
		ТаблицаСогласованияИзменена = Истина;
	КонецЦикла;
	
	Если ТаблицаСогласованияИзменена тогда
		ИзменитьРеквизиты(нРеквизиты);
				
		Для ИндексАналитики = 1 По МаксАналитикОтчета Цикл
			ИндАналитики = Строка(ИндексАналитики);
						
			Если НЕ Параметры.Свойство("Аналитика" + ИндАналитики) И 
				НЕ Параметры.Свойство("АналитикаСтроки" + ИндАналитики) тогда
				
				Продолжить;
			КонецЕсли;
			
			нЭлемент = Элементы.Добавить("ДанныеСогласованияАналитика" + ИндАналитики, Тип("ПолеФормы"), Элементы.ДанныеСогласования);
			нЭлемент.Вид = ВидПоляФормы.ПолеВвода;
			нЭлемент.ПутьКДанным = "ДанныеСогласования.Аналитика" + ИндАналитики;
		КонецЦикла;
	КонецЕсли;
		
	// Считывание данных.
	ПолучитьТекущиеОбласти();

КонецПроцедуры



#КонецОбласти


#Область КомандыУправленияСогласованием

&НаКлиенте
Процедура МаршрутСогласования(Команда)
		
	ДействияСогласованиеУХКлиент.МаршрутСогласования(ЭтаФорма,Элементы.ДанныеСогласования.ТекущиеДанные.ДокументОбласти);
    Обновить(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования(Команда)
	
	ПолучитьДокументСогласованияПоРакурсу(Элементы.ДанныеСогласования.ВыделенныеСтроки[0]);	
	ДействияСогласованиеУХКлиент.ИсторияСогласования(ЭтаФорма,Элементы.ДанныеСогласования.ТекущиеДанные.ДокументОбласти);

КонецПроцедуры

&НаКлиенте
Процедура СогласованиеДокумента(Команда)
	ТекВыделенныеСтроки = Элементы.ДанныеСогласования.ВыделенныеСтроки;
	Если ТекВыделенныеСтроки.Количество() = 1 Тогда
		ПолучитьДокументСогласованияПоРакурсу(ТекВыделенныеСтроки[0]);	
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("СогласовываемыйДокумент", Элементы.ДанныеСогласования.ТекущиеДанные.ДокументОбласти);
		ОткрытьФорму("ОбщаяФорма.КомментарийИСогласование", СтруктураПараметров, ЭтаФорма);
	ИначеЕсли ТекВыделенныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не выбран ракурс для согласования. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	Иначе	
		СтруктураПараметров = СформироватьСтруктуруПараметровСогласованияМассиваРакурсов();
		ОткрытьФорму("ОбщаяФорма.КомментарийИСогласование", СтруктураПараметров, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНаСогласование(Команда)
	
	МассивВыбранныхОбластей = ПолучитьМассивВыбранныхОбластей();
	Для Каждого Стр Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл	
		ПринятьКОбработке(Стр);	
	КонецЦикла;
	
	Обновить(Неопределено);	
	АктивироватьСтрокиСОбластями(МассивВыбранныхОбластей);
	
	ФлагИзменений = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)

	ОбновитьТаблицуРакурсов();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаблокироватьОбласть(Команда)
	
	МассивВыбранныхОбластей = ПолучитьМассивВыбранныхОбластей();
	ИзменитьБлокировкуОбласти_Сервер(1);
	Обновить(Неопределено);
	АктивироватьСтрокиСОбластями(МассивВыбранныхОбластей);	
	ФлагИзменений = Истина;

КонецПроцедуры

&НаКлиенте
Процедура РазблокироватьОбласть(Команда)
	
	МассивВыбранныхОбластей = ПолучитьМассивВыбранныхОбластей();
	ИзменитьБлокировкуОбласти_Сервер(0);
	Обновить(Неопределено);
	АктивироватьСтрокиСОбластями(МассивВыбранныхОбластей);		
	ФлагИзменений = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование(Команда)
	
	МассивВыбранныхОбластей = ПолучитьМассивВыбранныхОбластей();
	ОтменитьСогласование_Сервер();
	Обновить(Неопределено);
	АктивироватьСтрокиСОбластями(МассивВыбранныхОбластей);		
	ФлагИзменений = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ВложенияСогласования()
	
	ДействияСогласованиеУХКлиент.ТелеграмВложенныеФайлы(ЭтаФорма, Элементы.ДанныеСогласования.ТекущиеДанные.ДокументОбласти);
	
КонецПроцедуры

#КонецОбласти


Процедура ПолучитьТекущиеОбласти() 
		
	// Получаем вошедшие в текущий срез периоды и данные
	МассивВыделенныхСтрок = Новый Массив;
		
	ЗапросРакурсы = Новый Запрос;
	
	ОтборПоАналитикам = "";
	ПоляАналитик1 = "";
	ПоляАналитик2 = "";
	ТекстЗапросаПоАналитике	= "";
	СоединенияПоАналитикам = "";
		
	Для ИндексАналитики = 1 По МаксАналитикОтчета Цикл
		ИндАналитики = Строка(ИндексАналитики);
		
		Если ЭтаФорма["Аналитика" + ИндАналитики] = Неопределено
			И ЭтаФорма["АналитикаСтроки" + ИндАналитики] = Неопределено тогда
			
			ОтборПоАналитикам = ОтборПоАналитикам + "
	|			И РакурсДанных.Аналитика" + ИндАналитики + " = НЕОПРЕДЕЛЕНО";
						
			Продолжить;
		ИначеЕсли ЭтаФорма["Аналитика" + ИндАналитики] = Неопределено тогда
			Продолжить;	
		КонецЕсли;
			
		ОтборПоАналитикам = ОтборПоАналитикам + "
	|			И РакурсДанных.Аналитика" + ИндАналитики + " = &Аналитика" + ИндАналитики;
				
		ЗапросРакурсы.УстановитьПараметр("Аналитика" + ИндАналитики, ЭтаФорма["Аналитика" + ИндАналитики]);
		
		ПоляАналитик1 = ПоляАналитик1 + ",
	|	&Аналитика" + ИндАналитики + " КАК Аналитика" + ИндАналитики;
		
		ПоляАналитик2 = ПоляАналитик2 + ",
	|	втПроцессыСогласования.Аналитика" + ИндАналитики + " КАК Аналитика" + ИндАналитики;
	КонецЦикла;
	
	Для ИндексАналитики = 1 По МаксАналитикОтчета Цикл
		ИндАналитики = Строка(ИндексАналитики);
		
		Если ЭтаФорма["АналитикаСтроки" + ИндАналитики] = Неопределено тогда
			Продолжить;
		КонецЕсли;		
			
		ТекстЗапросаПоАналитике	= ТекстЗапросаПоАналитике + "
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗначенияАналитики.Аналитика КАК Аналитика
	|ПОМЕСТИТЬ втАналитика" + ИндАналитики + "
	|ИЗ
	|	&ЗначенияАналитики" + ИндАналитики + " КАК ЗначенияАналитики
	|;";
		
		ЗапросРакурсы.УстановитьПараметр("ЗначенияАналитики" + ИндАналитики, РеквизитФормыВЗначение("ЗначенияАналитики" + ИндАналитики));
		
		СоединенияПоАналитикам = СоединенияПоАналитикам + "
	|		ЛЕВОЕ СОЕДИНЕНИЕ втАналитика" + ИндАналитики + " КАК втАналитика" + ИндАналитики + "
	|		ПО (ИСТИНА)";
				
		ПоляАналитик1 = ПоляАналитик1 + ",
	|	ЕСТЬNULL(втАналитика" + ИндАналитики + ".Аналитика, НЕОПРЕДЕЛЕНО) КАК Аналитика" + ИндАналитики;
		
		ПоляАналитик2 = ПоляАналитик2 + ",
	|	втПроцессыСогласования.Аналитика" + ИндАналитики + " КАК Аналитика" + ИндАналитики;
				
		ОтборПоАналитикам = ОтборПоАналитикам + "
	|			И ВЫБОР 
	|				КОГДА втАналитика" + ИндАналитики + ".Аналитика ЕСТЬ NULL
	|					ТОГДА РакурсДанных.Аналитика" + ИндАналитики + " = НЕОПРЕДЕЛЕНО
	|				ИНАЧЕ
	|					втАналитика" + ИндАналитики + ".Аналитика = РакурсДанных.Аналитика" + ИндАналитики + "
	|			КОНЕЦ";
	КонецЦикла;
	
	Для ИндексАналитики = МаксАналитикОтчета + 1 По 6 Цикл
		ИндАналитики = Строка(ИндексАналитики);
		
		ОтборПоАналитикам = ОтборПоАналитикам + "
	|			И РакурсДанных.Аналитика" + ИндАналитики + " = НЕОПРЕДЕЛЕНО";
	КонецЦикла;
	//-----------
	
	ЗапросРакурсы.Текст =   	
	"ВЫБРАТЬ
	|	УправлениеПериодомСценария.Ссылка КАК Ссылка,
	|	УправлениеПериодомСценария.ВерсияОрганизационнойСтруктуры КАК ВерсияОрганизационнойСтруктуры,
	|	УправлениеПериодомСценария.Сценарий КАК Сценарий,
	|	УправлениеПериодомСценария.ПериодСценария КАК ПериодСценария,
	|	УправлениеПериодомСценария.ПериодСценария.ДатаНачала КАК ПериодСценарияДатаНачала,
	|	УправлениеПериодомСценария.ПериодСценарияОкончание.ДатаОкончания КАК ПериодСценарияОкончаниеДатаОкончания
	|ПОМЕСТИТЬ втПериодыСценарии
	|ИЗ
	|	Документ.УправлениеПериодомСценария КАК УправлениеПериодомСценария
	|ГДЕ
	|	УправлениеПериодомСценария.Сценарий В(&Сценарии)
	|	И (УправлениеПериодомСценария.ПериодСценария.ДатаНачала МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			ИЛИ УправлениеПериодомСценария.ПериодСценарияОкончание.ДатаОкончания МЕЖДУ &ДатаНачала И &ДатаОкончания
	|			ИЛИ УправлениеПериодомСценария.ПериодСценария.ДатаНачала <= &ДатаНачала
	|				И УправлениеПериодомСценария.ПериодСценарияОкончание.ДатаОкончания >= &ДатаОкончания)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиСоставаОбластейВидовОтчетов.КлючОбласти КАК Ракурс,
	|	НастройкиСоставаОбластейВидовОтчетов.КлючОбласти.РазделятьПоОрганизациям КАК РазделятьПоОрганизациям,
	|	НастройкиСоставаОбластейВидовОтчетов.КлючОбласти.РазделятьПоПроектам КАК РазделятьПоПроектам
	|ПОМЕСТИТЬ втДоступныеРакурсы
	|ИЗ
	|	РегистрСведений.НастройкиСоставаСтрокСводнойТаблицы КАК НастройкиСоставаСтрокСводнойТаблицы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиСоставаОбластейВидовОтчетов КАК НастройкиСоставаОбластейВидовОтчетов
	|		ПО НастройкиСоставаСтрокСводнойТаблицы.СтрокаОтчета = НастройкиСоставаОбластейВидовОтчетов.СтрокаОтчета
	|ГДЕ
	|	НастройкиСоставаСтрокСводнойТаблицы.ВариантСводнойТаблицы = &ВариантСводнойТаблицы
	|	И НастройкиСоставаОбластейВидовОтчетов.КлючОбласти.ВключатьВсеПоказателиВидаОтчета = ЛОЖЬ
	|	И НастройкиСоставаОбластейВидовОтчетов.КлючОбласти.ПометкаУдаления = ЛОЖЬ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОбластиДанныхВидовОтчетов.Ссылка,
	|	ОбластиДанныхВидовОтчетов.РазделятьПоОрганизациям,
	|	ОбластиДанныхВидовОтчетов.РазделятьПоПроектам
	|ИЗ
	|	Справочник.ОбластиДанныхВидовОтчетов КАК ОбластиДанныхВидовОтчетов
	|ГДЕ
	|	ОбластиДанныхВидовОтчетов.Владелец = &Владелец
	|	И ОбластиДанныхВидовОтчетов.ВключатьВсеПоказателиВидаОтчета = ИСТИНА
	|	И ОбластиДанныхВидовОтчетов.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организации
	|ПОМЕСТИТЬ втОрганизации
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	Организации.Ссылка В(&Организации)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Проекты.Ссылка КАК Проекты
	|ПОМЕСТИТЬ втПроекты
	|ИЗ
	|	Справочник.Проекты КАК Проекты
	|ГДЕ
	|	Проекты.Ссылка В(&Проекты)	
	|;" + ТекстЗапросаПоАналитике + "
	|	
	|////////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втДоступныеРакурсы.Ракурс КАК Ракурс,
	|	втДоступныеРакурсы.РазделятьПоОрганизациям КАК РазделятьПоОрганизациям,
	|	втДоступныеРакурсы.РазделятьПоПроектам КАК РазделятьПоПроектам,
	|	втОрганизации.Организации КАК ОрганизационнаяЕдиница,
	|	втПериодыСценарии.Ссылка КАК ПериодСценарияДокумент,
	|	втПериодыСценарии.ВерсияОрганизационнойСтруктуры КАК ВерсияОрганизационнойСтруктуры,
	|	втПроекты.Проекты КАК Проект,
	|	втПериодыСценарии.ПериодСценария КАК ПериодСценария,
	|	втПериодыСценарии.ПериодСценарияДатаНачала КАК ПериодСценарияДатаНачала,
	|	втПериодыСценарии.ПериодСценарияОкончаниеДатаОкончания КАК ПериодСценарияОкончаниеДатаОкончания,
	|	втПериодыСценарии.Сценарий КАК Сценарий,
	|	РакурсДанных.Ссылка КАК ДокументОбласти,
	|	РакурсДанных.ИндексСостояния КАК ИндексСостояния,
	|	ВЫБОР
	|		КОГДА РакурсДанных.ЗначениеЗаблокировано = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЗначениеЗаблокировано" + ПоляАналитик1 + "
	|ПОМЕСТИТЬ втПроцессыСогласования
	|ИЗ
	|	втДоступныеРакурсы КАК втДоступныеРакурсы
	|		ЛЕВОЕ СОЕДИНЕНИЕ втОрганизации КАК втОрганизации
	|		ПО (ВЫБОР
	|				КОГДА втДоступныеРакурсы.РазделятьПоОрганизациям = ИСТИНА
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПроекты КАК втПроекты
	|		ПО (ВЫБОР
	|				КОГДА втДоступныеРакурсы.РазделятьПоПроектам = ИСТИНА
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ)
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПериодыСценарии КАК втПериодыСценарии	
	|		ПО (ИСТИНА)" + СоединенияПоАналитикам + "
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РакурсДанных КАК РакурсДанных
	|		ПО втДоступныеРакурсы.Ракурс = РакурсДанных.Область
	|			И (РакурсДанных.ПометкаУдаления = ЛОЖЬ)
	|			И (РакурсДанных.Сценарий = втПериодыСценарии.Сценарий)	
	|			И (РакурсДанных.ПериодОтчета = втПериодыСценарии.ПериодСценария)" + ОтборПоАналитикам + "
	|			И (ВЫБОР
	|				КОГДА РакурсДанных.Область.РазделятьПоОрганизациям = ИСТИНА
	|					ТОГДА РакурсДанных.Организация = втОрганизации.Организации
	|				ИНАЧЕ РакурсДанных.Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
	|			КОНЕЦ)
	|			И (ВЫБОР
	|				КОГДА РакурсДанных.Область.РазделятьПоПроектам = ИСТИНА
	|					ТОГДА РакурсДанных.Проект = втПроекты.Проекты
	|				ИНАЧЕ РакурсДанных.Проект = ЗНАЧЕНИЕ(Справочник.Проекты.ПустаяСсылка)
	|			КОНЕЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////	
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втПроцессыСогласования.Ракурс КАК Ракурс,
	|	втПроцессыСогласования.РазделятьПоОрганизациям КАК РазделятьПоОрганизациям,
	|	втПроцессыСогласования.РазделятьПоПроектам КАК РазделятьПоПроектам,
	|	втПроцессыСогласования.ОрганизационнаяЕдиница КАК ОрганизационнаяЕдиница,
	|	втПроцессыСогласования.ПериодСценарияДокумент КАК ПериодСценарияДокумент,
	|	втПроцессыСогласования.ВерсияОрганизационнойСтруктуры КАК ВерсияОрганизационнойСтруктуры,
	|	втПроцессыСогласования.Проект КАК Проект,
	|	втПроцессыСогласования.ПериодСценария КАК ПериодСценария,
	|	втПроцессыСогласования.ПериодСценарияДатаНачала КАК ПериодСценарияДатаНачала,
	|	втПроцессыСогласования.ПериодСценарияОкончаниеДатаОкончания КАК ПериодСценарияОкончаниеДатаОкончания,
	|	втПроцессыСогласования.Сценарий КАК Сценарий,
	|	втПроцессыСогласования.ДокументОбласти КАК ДокументОбласти,
	|	втПроцессыСогласования.ИндексСостояния КАК ИндексСостояния,
	|	втПроцессыСогласования.ЗначениеЗаблокировано КАК ЗначениеЗаблокировано,
	|	втПроцессыСогласования.ПериодСценария КАК ПредставлениеПериода,
	|	РегистрМатрицыПолномочий.Исполняющий КАК Исполнитель,
	|	РегистрМатрицыПолномочий.Согласование КАК Согласование,
	|	ВЫБОР
	|		КОГДА втПроцессыСогласования.ДокументОбласти.ПометкаУдаления
	|			ТОГДА 1
	|		ИНАЧЕ 0	
	|	КОНЕЦ КАК ПометкаУдаленияРакурса" + ПоляАналитик2 + "
	|ИЗ
	|	втПроцессыСогласования КАК втПроцессыСогласования
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РегистрМатрицыПолномочий КАК РегистрМатрицыПолномочий
	|		ПО (РегистрМатрицыПолномочий.ДокументБД = &ТипКлючевогоОбъекта)
	|			И втПроцессыСогласования.Ракурс = РегистрМатрицыПолномочий.ШаблонДокументаБД
	|			И втПроцессыСогласования.ВерсияОрганизационнойСтруктуры = РегистрМатрицыПолномочий.ВерсияРегламентаПодготовкиОтчетности
	|			И (ВЫБОР
	|				КОГДА втПроцессыСогласования.РазделятьПоПроектам = ИСТИНА
	|					ТОГДА втПроцессыСогласования.Проект = РегистрМатрицыПолномочий.Проект
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ)
	|			И (ВЫБОР
	|				КОГДА втПроцессыСогласования.РазделятьПоОрганизациям = ИСТИНА
	|					ТОГДА втПроцессыСогласования.ОрганизационнаяЕдиница = РегистрМатрицыПолномочий.Организация
	|				ИНАЧЕ ИСТИНА
	|			КОНЕЦ)
	|ГДЕ
	|	втПроцессыСогласования.ПериодСценарияДокумент ЕСТЬ НЕ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	втПроцессыСогласования.ПериодСценарияДатаНачала,
	|	втПроцессыСогласования.Ракурс";
	
	ЗапросРакурсы.УстановитьПараметр("Сценарии",Сценарии);
    ЗапросРакурсы.УстановитьПараметр("ДатаНачала",ДатаНачалаПериода);
	ЗапросРакурсы.УстановитьПараметр("ДатаОкончания",ДатаОкончанияПериода);
	ЗапросРакурсы.УстановитьПараметр("ВариантСводнойТаблицы",ВариантСводнойТаблицы);
    ЗапросРакурсы.УстановитьПараметр("Владелец",ВидОтчета);	
    ЗапросРакурсы.УстановитьПараметр("Организации",Организации);
	ЗапросРакурсы.УстановитьПараметр("Проекты",Проекты);
	ЗапросРакурсы.УстановитьПараметр("ТипКлючевогоОбъекта",Справочники.ДокументыБД.НайтиПоНаименованию("РакурсДанных",,,Справочники.ТипыБазДанных.ТекущаяИБ));

	Результат = ЗапросРакурсы.Выполнить();
	Выборка = Результат.Выбрать();
	
	ДанныеСогласования.Очистить();
	Элементы.ДанныеСогласования.Обновить();
	
	Пока Выборка.Следующий() Цикл
		
		 Нстр = ДанныеСогласования.Добавить();
		 ЗаполнитьЗначенияСвойств(Нстр,Выборка);
		 Нстр.ПредставлениеПериода = Строка(Выборка.ПериодСценарияДокумент.ПериодСценария) + " - " + Строка(Выборка.ПериодСценарияДокумент.ПериодСценарияОкончание);
		 		
	КонецЦикла;
	
	Элементы.ДанныеСогласования.Доступность = НЕ Выборка.Количество() = 0;
	
КонецПроцедуры	

Процедура УстановитьБлокировкуОбласти(ДокументОбласти,Блокировка)
	
	СводнаяТаблицаУХ.УстановитьСтатусОбласти(ДокументОбласти,Неопределено,Блокировка);	
		
КонецПроцедуры

Процедура ПринятьКОбработке(СтрокаДанные)
	ПолучитьДокументСогласованияПоРакурсу(СтрокаДанные);
	ТекущаяСтрока = ДанныеСогласования.НайтиПоИдентификатору(СтрокаДанные);	
	ТекДокументОбласти = ТекущаяСтрока.ДокументОбласти;
	Если НЕ ТекДокументОбласти.Проведен Тогда
		// Документ не проведён. Проведём перед отправкой на согласование.
		Попытка
			ДокументОбъект = ТекДокументОбласти.ПолучитьОбъект();
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
			МодульУправленияПроцессамиУХ.ПринятьКОбработке(, ТекДокументОбласти);	
		Исключение
			ТекстСообщения = НСтр("ru = 'При отправке документа %Документ% на согласование возникли ошибки: %ОписаниеОшибки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Строка(ТекДокументОбласти));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецПопытки;
	Иначе
		// Проверка на проведение пройдена. Отправляем ракурс на согласование.
		МодульУправленияПроцессамиУХ.ПринятьКОбработке(, ТекДокументОбласти);	
	КонецЕсли;
КонецПроцедуры

// Заполняет поле ДокументОбласти во всех строках из массива МассивСтрокВход.
&НаСервере
Процедура ЗаполнитьДокументыОбластиВСтроках(МассивСтрокВход)
	Для Каждого ТекМассивСтрокВход Из МассивСтрокВход Цикл
		ПолучитьДокументСогласованияПоРакурсу(ТекМассивСтрокВход);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПолучитьДокументСогласованияПоРакурсу(СтрокаДанные)
	
	ТекущаяСтрока = ДанныеСогласования.НайтиПоИдентификатору(СтрокаДанные);
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ДокументОбласти) Тогда
		
		ТекущаяСтрока.ДокументОбласти = ТекущаяСтрока.ДокументОбласти;
		
	Иначе
		
		СогласованиеОбластиДанных 						= Документы.РакурсДанных.СоздатьДокумент();
		СогласованиеОбластиДанных.Дата 					= ТекущаяДата();
		СогласованиеОбластиДанных.Область 				=  ТекущаяСтрока.Ракурс;
		СогласованиеОбластиДанных.Сценарий 				= ТекущаяСтрока.Сценарий;
		СогласованиеОбластиДанных.Организация 			= ТекущаяСтрока.ОрганизационнаяЕдиница;
		СогласованиеОбластиДанных.Проект 				= ТекущаяСтрока.Проект;
		СогласованиеОбластиДанных.ПредставлениеПериода 	= ТекущаяСтрока.ПредставлениеПериода;	
		СогласованиеОбластиДанных.ПериодНачалоДата 		=  ТекущаяСтрока.ПериодСценарияДатаНачала;
		СогласованиеОбластиДанных.ПериодОкончаниеДата 	=  ТекущаяСтрока.ПериодСценарияОкончаниеДатаОкончания;	
		СогласованиеОбластиДанных.Периодичность 		= Периодичность;		
		СогласованиеОбластиДанных.ПериодОтчета 			=  ТекущаяСтрока.ПериодСценария;
		
		МаксАналитикОтчета = ОбщегоНазначенияУХ.ВернутьКоличествоАналитикНаУровнеОтчета(Объект.ВидОтчета);
		
		Для ИндексАналитики = 1 По МаксАналитикОтчета Цикл
			ИндАналитики = Строка(ИндексАналитики);
			ТекущаяСтрока.Свойство("Аналитика" + ИндАналитики, СогласованиеОбластиДанных["Аналитика" + ИндАналитики]);	
		КонецЦикла;
				
		СогласованиеОбластиДанных.Записать();
			
		ТекущаяСтрока.ДокументОбласти = СогласованиеОбластиДанных.Ссылка;
		
	КонецЕсли;
			
КонецПроцедуры	

// Заполняет поле ДокументОбласти в выбранных пользователем строках.
&НаСервере
Процедура ЗаполнитьДокументыОбластиВВыбранныхСтроках()
	МассивСтрок = Новый Массив;
	Для Каждого Стр Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл	
		МассивСтрок.Добавить(Стр);
	КонецЦикла;
	ЗаполнитьДокументыОбластиВСтроках(МассивСтрок);	
КонецПроцедуры

// Возвращает структуру параметров формы для согласования выделенных ракурсов.
&НаСервере
Функция СформироватьСтруктуруПараметровСогласованияМассиваРакурсов()
	// Инициализация.
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("СогласовываемыйДокумент",	 Неопределено);
	РезультатФункции.Вставить("ПакетДокументов",			 Новый СписокЗначений);
	РезультатФункции.Вставить("СписокЗадач",				 Новый СписокЗначений);
	// Заполним поле ДокументОбласти у выбранных строк.
	ЗаполнитьДокументыОбластиВВыбранныхСтроках();
	// Получим список ссылок.
	СписокСсылок = Новый СписокЗначений;
	Для Каждого Стр Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл
		СтрокаДерева = ДанныеСогласования.НайтиПоИдентификатору(Стр);
		СписокСсылок.Добавить(СтрокаДерева.ДокументОбласти);
	КонецЦикла;
	// Сформируем и вернём структуру.
	РезультатФункции = УправлениеПроцессамиСогласованияУХ.СформироватьСтруктуруОткрытияФормыВизированияПакетаДокументов(СписокСсылок);
	Возврат РезультатФункции;
КонецФункции

// Серверная обёртка команды ОтменитьСогласование.
&НаСервере
Процедура ОтменитьСогласование_Сервер()
	// Инициализация.
	НачатьТранзакцию();
	ЕстьОшибки = Ложь;
	ПредставлениеРакурса = "";
	Попытка
		// Непосредственная отмена согласования.
		ЗаполнитьДокументыОбластиВВыбранныхСтроках();
		Для Каждого Стр Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл
			СтрокаДерева = ДанныеСогласования.НайтиПоИдентификатору(Стр);
			ТекДокументОбласти = СтрокаДерева.ДокументОбласти;
			ПредставлениеРакурса = Строка(ТекДокументОбласти);
			МодульУправленияПроцессамиУХ.ОтменитьСогласование(, ТекДокументОбласти);
		КонецЦикла;
	Исключение
		// Обработка исключительных ситуаций.
		ТекстСообщения = НСтр("ru = 'При отмене согласования ракурса %Ракурс% возникли ошибки: %ОписаниеОшибки%. Операция отменена.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ракурс%", Строка(ПредставлениеРакурса));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		ЕстьОшибки = Истина;
	КонецПопытки;
	// Фиксирование транзакции.
	Если ЕстьОшибки Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Изменяет блокировку у выделенных на форме областей. Параметр ИндексБлокировкиВход
// определяет направление блокировки.
&НаСервере
Процедура ИзменитьБлокировкуОбласти_Сервер(ИндексБлокировкиВход)
	// Инициализация.
	НачатьТранзакцию();
	ЕстьОшибки = Ложь;
	ПредставлениеРакурса = "";
	Попытка
		// Непосредственное изменение блокировки.
		ЗаполнитьДокументыОбластиВВыбранныхСтроках();
		Для Каждого Стр Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл
			СтрокаДерева = ДанныеСогласования.НайтиПоИдентификатору(Стр);
			ТекДокументОбласти = СтрокаДерева.ДокументОбласти;
			ПредставлениеРакурса = Строка(ТекДокументОбласти);
			УстановитьБлокировкуОбласти(ТекДокументОбласти, ИндексБлокировкиВход);
		КонецЦикла;
	Исключение
		// Обработка исключительных ситуаций.
		ТекстСообщения = НСтр("ru = 'При изменении блокировки ракурса %Ракурс% возникли ошибки: %ОписаниеОшибки%. Операция отменена.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ракурс%", Строка(ПредставлениеРакурса));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		ЕстьОшибки = Истина;
	КонецПопытки;
	// Фиксирование транзакции.
	Если ЕстьОшибки Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецПроцедуры

// Возвращает массив выбранных пользователем областей.
&НаКлиенте
Функция ПолучитьМассивВыбранныхОбластей()	
	РезультатФункции = Новый Массив;
	Для Каждого ТекВыделенныеСтроки Из Элементы.ДанныеСогласования.ВыделенныеСтроки Цикл	
		НайденнаяСтрока = ДанныеСогласования.НайтиПоИдентификатору(ТекВыделенныеСтроки);
		Если НайденнаяСтрока <> Неопределено Тогда
			ТекДокументОбласти = НайденнаяСтрока.ДокументОбласти;
			РезультатФункции.Добавить(ТекДокументОбласти);
		Иначе
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

// Устанавливает выделение в строках таблицы ДанныеСогласования с областями 
// данных из массива МассивВыбранныхОбластейВход.
&НаКлиенте
Процедура АктивироватьСтрокиСОбластями(МассивВыбранныхОбластейВход)
	// Очистим выделение.
	Элементы.ДанныеСогласования.ВыделенныеСтроки.Очистить();
	Для Каждого ТекДанныеСогласования Из ДанныеСогласования Цикл
		Попытка
			// Проверка принадлежности области данных в текущей строке к массиву выбранных областей данных.
			ТекДокументОбласти = ТекДанныеСогласования.ДокументОбласти;
			НайденныеОбласти = МассивВыбранныхОбластейВход.Найти(ТекДокументОбласти);
			Если НайденныеОбласти <> Неопределено Тогда
				// Установка выделения на текущую строку.
				ИдентификаторСтроки = ТекДанныеСогласования.ПолучитьИдентификатор();
				Элементы.ДанныеСогласования.ВыделенныеСтроки.Добавить(ИдентификаторСтроки);
			Иначе
				Продолжить;			// Строка не содержит областей из массива.
			КонецЕсли;
		Исключение
			ТекстСообщения = НСтр("ru = 'При установке выделения на строки произшли ошибки: %ОписаниеОшибки%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеСогласованияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
		
	Если НЕ Поле.Имя = "ДанныеСогласованияСтатусСогласования" Тогда
		СтандартнаяОбработка = Ложь;	
		Если НЕ Элементы.ДанныеСогласования.ТекущиеДанные = Неопределено Тогда	
			ПараметрыФормы = ПодготовитьПарамтерыВызоваСТ(Элементы.ДанныеСогласования.ТекущаяСтрока);
			ОткрытьФорму("Обработка.СводнаяТаблица.Форма",ПараметрыФормы);	
		КонецЕсли;			
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "СостояниеЗаявкиПриИзменении" Тогда
		МассивВыбранныхОбластей = ПолучитьМассивВыбранныхОбластей();
		Обновить(Неопределено);
		АктивироватьСтрокиСОбластями(МассивВыбранныхОбластей);
		ФлагИзменений = Истина;
	Иначе
		// Неизвестное событие, не обрабатываем.
	КонецЕсли;
	 
КонецПроцедуры

&НаКлиенте
Процедура ДанныеСогласованияПередНачаломИзменения(Элемент, Отказ)
	
	Если НЕ Элемент.ТекущийЭлемент.Имя = "ДанныеСогласованияСтатусСогласования"  Тогда	
		Отказ = Истина;
	Иначе	
		Если  ЗначениеЗаполнено(Элемент.ТекущиеДанные.Согласование) Тогда
			 Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСвойстваРакурса(Команда)
	
	Если НЕ Элементы.ДанныеСогласования.ТекущиеДанные = Неопределено Тогда		
		ПоказатьЗначение(,Элементы.ДанныеСогласования.ТекущиеДанные.Ракурс);		
	КонецЕсли;	
			
КонецПроцедуры

Функция ПодготовитьПарамтерыВызоваСТ(ИндексСтроки)
	
	    ТекущиеДанные =  ДанныеСогласования.НайтиПоИдентификатору(ИндексСтроки);
	
	    ТекущийРакурс =  ТекущиеДанные.Ракурс;
	
	    ПараметрыФормы = Новый Структура("Бланк",ТекущийРакурс.БланкОтображения);
		ПараметрыФормы.Вставить("ПериодПланированияОтборНачало",ТекущиеДанные.ПериодСценарияДатаНачала);
		ПараметрыФормы.Вставить("ПериодПланированияОтборОкончание",ТекущиеДанные.ПериодСценарияОкончаниеДатаОкончания);
		
		СтруктураАналитик = Новый Структура;
		СтруктураАналитик.Вставить("Сценарии", ТекущиеДанные.Сценарий);
		Если ЗначениеЗаполнено(ТекущиеДанные.ОрганизационнаяЕдиница) Тогда
			СтруктураАналитик.Вставить("Организации", ТекущиеДанные.ОрганизационнаяЕдиница);
		КонецЕсли;
		Если ЗначениеЗаполнено(ТекущиеДанные.Проект) Тогда
			СтруктураАналитик.Вставить("Проект", ТекущиеДанные.Проект);
		КонецЕсли;

		ПараметрыФормы.Вставить("АналитикиОтбораИсточник",ПоместитьВоВременноеХранилище(СтруктураАналитик,Новый УникальныйИдентификатор));
		ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.ДокументОбласти);
				
		Возврат ПараметрыФормы;
		
		
КонецФункции

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Закрыть(ФлагИзменений);
		
КонецПроцедуры

&НаКлиенте
Процедура ДанныеСогласованияСтатусСогласованияПриИзменении(Элемент)
	
	УстановитьСтатус(Элементы.ДанныеСогласования.ТекущаяСтрока,Элементы.ДанныеСогласования.ТекущиеДанные.ИндексСостояния);
	ФлагИзменений = Истина;
	ПолучитьТекущиеОбласти();
	
КонецПроцедуры
	
&НаКлиенте
Процедура УстановитьСтатус(ИндексСтроки,Статус)
	
	СтрокаДанные = ДанныеСогласования.НайтиПоИдентификатору(ИндексСтроки);
	
	Если НЕ ЗначениеЗаполнено(СтрокаДанные.ДокументОбласти) Тогда	
		ПолучитьДокументСогласованияПоРакурсу(ИндексСтроки);
	КонецЕсли;
	
	ТекущийДокументСогласования = СтрокаДанные.ДокументОбласти;
	
	Если Статус = 3 Тогда
		УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВСостояниеУтверждена(ТекущийДокументСогласования);
	ИначеЕсли Статус = 0 Тогда
		УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВСостояниеЧерновик(ТекущийДокументСогласования);	
	ИначеЕсли Статус = 2 Тогда
		УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВСостояниеОтклонена(ТекущийДокументСогласования);		
	ИначеЕсли Статус = 1 Тогда
		УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВСостояниеНаУтверждении(ТекущийДокументСогласования);		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьТаблицуРакурсов()
	ТекСтрока = ДанныеСогласования.Индекс(Элементы.Данныесогласования.ТекущиеДанные);
	ПолучитьТекущиеОбласти();
	Элементы.ДанныеСогласования.Обновить();
	Элементы.Данныесогласования.ТекущаяСтрока = ДанныеСогласования.Получить(ТекСтрока).ПолучитьИдентификатор();
КонецПроцедуры



