
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	#Область УХ_Встраивание
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	#КонецОбласти 
	
	ДенежныеСредстваСервер.УстановитьВидимостьОплатыПлатежнойКартой(Элементы.ФормаОплаты);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УправлениеЭлементамиФормы();
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	#Область УХ_Встраивание
	ПриЧтенииСозданииНаСервере();
	#КонецОбласти 
	
	УправлениеЭлементамиФормы();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ОжидаемоеПоступлениеДенежныхСредств", ПараметрыЗаписи, Объект.Ссылка); // Используется для автоматического обновления формы платежного календаря

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	#Область УХ_Встраивание
	ЗаявкиНаОперацииКлиент.ПослеЗаписи(ПараметрыЗаписи);
	#КонецОбласти 

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

	#Область УХ_Встраивание
	НастроитьЗависимыеЭлементыФормыНаСервере();
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФормаОплатыПриИзменении(Элемент)
	
	УправлениеЭлементамиФормы();
	#Область УХ_Встраивание
	Подключаемый_ПриИзмененииЭлементаУХ(Элемент);
	#КонецОбласти 
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	Если Не ЗначениеЗаполнено(Объект.Валюта) Тогда
		Объект.Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	#Область УХ_Встраивание
	//Элементы.Касса.Видимость = (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная);
	//Элементы.БанковскийСчет.Видимость = (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная);
	#КонецОбласти 
	
	УстановитьВидимостьКнопокФормы();
	
	#Область УХ_Встраивание
	ДенежныеСредстваСервер.УстановитьПараметрыВыбораКонтрагента(Объект, Элементы.Контрагент);
	
	УстановитьПараметрыВыбораДоговоровКредитовДепозитов();
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
	УстановитьСвойстваПоляВводаДоговор();
	#КонецОбласти 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокФормы()
	
	ВидимостьСоздатьНаОсновании = Объект.Проведен;
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("ДокументПриходныйКассовыйОрдерСоздатьНаОсновании");
	МассивВсехРеквизитов.Добавить("ДокументПоступлениеБезналичныхДенежныхСредствСоздатьНаОсновании");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ВидимостьСоздатьНаОсновании Тогда
		Если Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная Тогда
			МассивРеквизитовОперации.Добавить("ДокументПриходныйКассовыйОрдерСоздатьНаОсновании");
			
		ИначеЕсли Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная Тогда
			МассивРеквизитовОперации.Добавить("ДокументПоступлениеБезналичныхДенежныхСредствСоздатьНаОсновании");
			
		Иначе
			МассивРеквизитовОперации.Добавить("ДокументПриходныйКассовыйОрдерСоздатьНаОсновании");
			МассивРеквизитовОперации.Добавить("ДокументПоступлениеБезналичныхДенежныхСредствСоздатьНаОсновании");
			
		КонецЕсли;
	КонецЕсли;
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область УХ_Встраивание

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	ЭтотОбъект.ИспользоватьДоговорыМеждуОрганизациями = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыМеждуОрганизациями");
	ЭтотОбъект.ИспользоватьДоговорыСКлиентами         = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	ЭтотОбъект.ИспользоватьДоговорыСПоставщиками      = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками");
	
	НастройкиПолейФормы = Документы.ОжидаемоеПоступлениеДенежныхСредств.НастройкиПолейФормы();
	ЗначениеВРеквизитФормы(НастройкиПолейФормы, "НастройкиПолей");
	ЗависимостиПолейФормы = ДенежныеСредстваСервер.ЗависимостиПолейФормы(НастройкиПолейФормы);
	ЗначениеВРеквизитФормы(ЗависимостиПолейФормы, "ЗависимостиПолей");
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииЭлементаУХ(Элемент)
	
	ПриИзмененииЭлементаУХНаСервере(Элемент.Имя);
	
	Если Элемент.Имя = "ВидОперацииУХ" Тогда
		АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтатьяБюджета_ПриИзменении(Элемент)
	ПриИзмененииСтатьиБюджетаНаКлиенте(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииСтатьиБюджетаНаКлиенте(Элемент, РучноеИзменение = Истина)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
	ПриИзмененииСтатьиБюджетаНаСервере(Элемент.Имя, РучноеИзменение);
КонецПроцедуры	

&НаСервере
Процедура ПриИзмененииСтатьиБюджетаНаСервере(ИмяЭлемента, РучноеИзменение = Истина)
	ЗаявкиНаОперации.ПриИзмененииСтатьиБюджета(ЭтотОбъект, ИмяЭлемента, РучноеИзменение);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АналитикаСтатьиБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииАналитикиСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
	ПриИзмененииАналитикиСтатьиНаСервере(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииАналитикиСтатьиНаСервере(ИмяЭлемента)
	ЗаявкиНаОперации.ПриИзмененииАналитикиСтатьиБюджета(ЭтотОбъект, ИмяЭлемента);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЭлементСтруктурыЗадолженностиПриИзменении(Элемент)
		
	ЭлементСтруктурыЗадолженности = Объект.ЭлементСтруктурыЗадолженности;
	Если НЕ ЗначениеЗаполнено(ЭлементСтруктурыЗадолженности) Тогда
		Возврат;
	КонецЕсли;
		
	СтатьяДДС = СтатьяДДСПоЭлементуСтруктурыЗадолженности(ЭлементСтруктурыЗадолженности);
	Если ЗначениеЗаполнено(СтатьяДДС) Тогда
		Объект.СтатьяДвиженияДенежныхСредств = СтатьяДДС;
		ПриИзмененииСтатьиБюджетаНаКлиенте(Элементы.СтатьяДвиженияДенежныхСредств, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтатьяДДСПоЭлементуСтруктурыЗадолженности(ЭлементСтруктурыЗадолженности)
	
	Договор = ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ДоговорДокумента(Объект);
	
	СтатьяДДС = ЗаявкиНаОперацииВызовСервера.СтатьяДДСПоЭлементуСтруктурыЗадолженности(Договор, 
		ЭлементСтруктурыЗадолженности, ПредопределенноеЗначение("Перечисление.ВидыДвиженийПриходРасход.Приход"));
		
	Возврат СтатьяДДС;	
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	#Область УХ_Встраивание
	СобытияОбновленияПП = "Запись_ПриходныйКассовыйОрдер,Запись_ПоступлениеБезналичныхДенежныхСредств";
	Если ЗаявкиНаОперацииКлиент.ТребуетсяОбработкаСобытия(ИмяСобытия, СобытияОбновленияПП) Тогда
		ВыполнитьОбработкуСобытийЗаявки(ИмяСобытия, Параметр, СобытияОбновленияПП);
	КонецЕсли;
	#КонецОбласти 
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

#Область УХ_ПлатежнаяПозиция

&НаКлиенте
Процедура Подключаемый_СтрокаПлатежнаяПозицияНажатие(Элемент, СтандартнаяОбработка)
	
	ПлатежныеПозицииКлиент.НажатиеНаПредставлениеПлатежнойПозиции(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлатежнаяПозицияНажатиеПродолжение(Результат, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Результат) Тогда
		ПлатежнаяПозицияНажатиеЗавершениеНаСервере(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПлатежнаяПозицияНажатиеЗавершениеНаСервере(Адрес)
	
	ПлатежныеПозиции.ЗагрузитьПлатежнуюПозициюПослеРедактирования(ЭтаФорма, Адрес);
	
КонецПроцедуры

#КонецОбласти 

#Область УХ_ВызовыОбщихПроцедурИФункцийСогласованияОбъектов

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

// Проверяет сохранение текущего объекта и изменяет его статус
// НовоеЗначениеСтатусаВход.
&НаКлиенте
Процедура ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатусаВход)
	Если (Объект.Ссылка.Пустая()) ИЛИ (Модифицированность) Тогда
		СтруктураПараметров = Новый Структура("ВыбранноеЗначение", НовоеЗначениеСтатусаВход);
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, СтруктураПараметров);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Изменение состояния возможно только после записи данных.
		|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	ИзменитьСостояниеЗаявкиКлиент(НовоеЗначениеСтатусаВход);	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ДействияСогласованиеУХКлиент.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ПринятьКСогласованию(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ИсторияСогласования(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.СогласоватьДокумент(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ОтменитьСогласование(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.МаршрутСогласования(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход) экспорт
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход) экспорт
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход) экспорт
	Возврат ФормаВход["Согласующий"];
КонецФункции

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСтатусОбъекта(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПриИзмененииЭлементаУХНаСервере(ИмяЭлемента)
	
	УстановитьСвойстваПоляВводаДоговор();
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ПриИзмененииЭлементаУХ(ЭтаФорма, ИмяЭлемента);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Организация", Объект.Организация);
	СтруктураОтбора.Вставить("ПометкаУдаления", Ложь);
	
	СтруктураПараметровВыбора = Новый Структура;
	СтруктураПараметровВыбора.Вставить("РежимВыбора", Истина);
	
	Если Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации") 
		ИЛИ Объект.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации") Тогда
		СтруктураОтбора.Организация= Объект.ОрганизацияОтправитель;
		СтруктураОтбора.Вставить("ОрганизацияПолучатель", Объект.Организация);
		СтруктураПараметровВыбора.Вставить("Отбор", СтруктураОтбора);
		ОткрытьФорму("Справочник.ДоговорыМеждуОрганизациями.Форма.ФормаВыбора",
			СтруктураПараметровВыбора,
			Элемент,
			Элемент,)
	Иначе
		#Область УХ_Встраивание
		Для Каждого Параметр Из Элемент.ПараметрыВыбора Цикл
			Если Параметр.Имя = "Отбор.ВидДоговораУХ" Тогда
				СтруктураОтбора.Вставить("ВидДоговораУХ", Параметр.Значение);
			КонецЕсли;
		КонецЦикла;
		#КонецОбласти 
		СтруктураОтбора.Вставить("Контрагент", Объект.Контрагент);
		СтруктураПараметровВыбора.Вставить("Отбор", СтруктураОтбора);
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора",
			СтруктураПараметровВыбора,
			Элемент,
			Элемент,)
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("ФормаОплаты");
	РеквизитыФормы.Вставить("ИспользоватьНесколькоВалют");
	РеквизитыФормы.Вставить("ИспользоватьНачислениеЗарплатыУТ");
	РеквизитыФормы.Вставить("ВалютныйПлатеж");
	РеквизитыФормы.Вставить("ИспользоватьСинхронизациюДанных");
	РеквизитыФормы.Вставить("Модифицированность");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	#Область УХ_Встраивание
	РеквизитыФормы.Вставить("Истина", Истина);
	РеквизитыФормы.Вставить("СтатусОбъекта", Форма.СтатусОбъекта);
	РеквизитыФормы.Вставить("ЕстьСуперПользователь", Форма.ЕстьСуперПользователь);
	РеквизитыФормы.Вставить("ЕстьРасчетыСКонтрагентами", ВидыОперацийУХКлиентСерверПовтИсп.ЭтоРасчетыСКонтрагентом(Форма.Объект.ВидОперацииУХ));
	РеквизитыФормы.Вставить("ЭтоТехническаяОперация", Ложь);
	#КонецОбласти 
	
	Возврат РеквизитыФормы;
	
КонецФункции

&НаСервере
Процедура УстановитьПараметрыВыбораДоговоровКредитовДепозитов()

	МассивПараметров = Новый Массив;
	
	Если НЕ Объект.Организация.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Объект.Организация));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.ФормаОплаты)
		И (Объект.ФормаОплаты = Перечисления.ФормыОплаты.Безналичная
		ИЛИ Объект.ФормаОплаты = Перечисления.ФормыОплаты.Наличная) Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ФормаОплаты", Объект.ФормаОплаты));
	КонецЕсли;
	
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ХарактерДоговора",
		Справочники.ДоговорыКредитовИДепозитов.ХарактерДоговораПоОперации(Объект.ХозяйственнаяОперация)));
		
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления",Ложь));
	
	Если НЕ Объект.Контрагент.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Объект.Контрагент));
	КонецЕсли;
	
	НовыеПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Элементы.ДоговорКредитаДепозита.ПараметрыВыбора = НовыеПараметрыВыбора;
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура УстановитьПараметрыВыбораДоговораЛизинга()

	МассивПараметров = Новый Массив;
	Если НЕ Объект.Организация.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", Объект.Организация));
	КонецЕсли;
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует));
	МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ПометкаУдаления",Ложь));
	Если НЕ Объект.Контрагент.Пустая() Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", Объект.Контрагент));
	КонецЕсли;
	
	Элементы.ДоговорАренды.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Процедура УстановитьСвойстваПоляВводаДоговор()
	
	ЭтоИнтеркампани = ВзаиморасчетыСервер.ХозяйственнаяОперацияИнтеркампани(Объект.ХозяйственнаяОперация);
	
	Если ЭтоИнтеркампани И ЭтотОбъект.ИспользоватьДоговорыМеждуОрганизациями 
		ИЛИ ВзаиморасчетыСервер.ХозяйственнаяОперацияСКлиентом(Объект.ХозяйственнаяОперация) И ЭтотОбъект.ИспользоватьДоговорыСКлиентами
		ИЛИ ВзаиморасчетыСервер.ХозяйственнаяОперацияСПоставщиком(Объект.ХозяйственнаяОперация) И ЭтотОбъект.ИспользоватьДоговорыСПоставщиками Тогда
		Элементы.Договор.Видимость = Истина;
	Иначе
		Элементы.Договор.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	МассивТипов = Новый Массив;
	
	Если НЕ ЗначениеЗаполнено(Объект.Договор) Тогда
		Если ЭтоИнтеркампани Тогда
			Объект.Договор = ПредопределенноеЗначение("Справочник.ДоговорыМеждуОрганизациями.ПустаяСсылка");
			МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыМеждуОрганизациями"));
		Иначе
			Объект.Договор = ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
			МассивТипов.Добавить(Тип("СправочникСсылка.ДоговорыКонтрагентов"));
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Договор.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбработкуСобытийЗаявки(ИмяСобытия, Параметр, СобытияОбновленияПП = "")
	ЗаявкиНаОперации.ОбработкаОповещенияФормыЗаявки(ЭтотОбъект, ИмяСобытия, Параметр, СобытияОбновленияПП);
КонецПроцедуры

#КонецОбласти
