#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыНовогоДокумента();
	
	ОпределитьИННОрганизации();
	
	ПредставлениеЗапроса = ПолучитьПодсказкуЗначениеПоискаЗапросаЕГР(
		Объект.ПараметрЗапроса, 
		Объект.Контрагент,
		Объект.ПараметрЗапроса,
		ЭтотОбъект.НаименованиеОрганизации,
		ЭтотОбъект.ИНН);

	ЭтоНовыйДокумент = Параметры.Ключ.Пустая();
	ЭтоСкопированныйДокумент = Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования);
	
	Если Не ЭтоНовыйДокумент ИЛИ ЭтоСкопированныйДокумент Тогда
		ОбновитьЗаголовокФормы(ЭтаФорма);
		Если ИНН = Объект.ПараметрЗапроса Тогда
			ВидВыписки = "себе";
		Иначе
			ВидВыписки = "контрагенту";
		КонецЕсли;
		ПриИзмененииВидаВыписки(ЭтотОбъект);
	КонецЕсли;
	
	// управляем панелью статуса
	УправлениеСтатусомИДоступностью();
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "ЗаголовокОрганизации");
	
	ОбновитьПредставлениеПараметрЗапроса(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ДанныеПоследнегоЦиклаОбмена <> Неопределено Тогда
		Оповестить(
			"Чтение сообщения", 
			Новый Структура("Сообщение, ЦиклОбмена", 
				ДанныеПоследнегоЦиклаОбмена.ТранспортноеСообщение, 
				ДанныеПоследнегоЦиклаОбмена.ЦиклОбмена));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьЗаголовокФормы(ЭтаФорма);
	
	Оповестить("Запись_ЗапросНаВыпискуИзЕГРЮЛ_ЕГРИП",, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПараметрЗапросаПриИзменении(Элемент)
	
	Объект.ПараметрЗапроса = ПредставлениеЗапроса;
	Объект.Контрагент = Неопределено;
	ОбновитьПредставлениеПараметрЗапроса(ЭтаФорма);
	
	ОпределитьИННОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрЗапросаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ПрисвоитьЗначениеПараметруЗапроса", ЭтотОбъект);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("РежимВыбора", Истина);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",ДополнительныеПараметры, ЭтаФорма,,,,
		Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеСтатусомИДоступностью();
	
	ОпределитьИННОрганизации();
	
	ПриИзмененииВидаВыписки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидВыпискиПриИзменении(Элемент)
	
	ОпределитьИННОрганизации();
	ПриИзмененииВидаВыписки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСтатус(Команда)
	
	// управляем панелью статуса
	УправлениеСтатусомИДоступностью();

КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	ДополнительныеПараметры = Новый Структура("КонтекстЭДО", КонтекстЭДО);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтправкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	КонтекстЭДО.ОтправкаЗапросаНаВыпискуИзЕГР(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = ДополнительныеПараметры.КонтекстЭДО;
	ЗаявлениеОтправлено = ЗаявлениеОтправлено(Объект.Ссылка);
	
	УправлениеСтатусомИДоступностью();
	
	// Перерисовка статуса отправки в форме Отчетность
	ПараметрыОповещения = Новый Структура(); 
	ПараметрыОповещения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	Оповестить("Завершение отправки в контролирующий орган", ПараметрыОповещения, Объект.Ссылка);
	
	Если Открыта() И ЗаявлениеОтправлено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВидаВыписки(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Если Форма.ВидВыписки = "себе" Тогда
		
		Если НЕ Форма.ЗаявлениеОтправлено Тогда
			Объект.ПараметрЗапроса = Форма.ИНН;
			Элементы.ГруппаПараметрЗапроса.Видимость = Ложь;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			Подсказка = НСтр("ru = '%1 (ИНН %2)';
							|en = '%1 (ИНН %2)'");
			Подсказка = СтрШаблон(Подсказка, Форма.НаименованиеОрганизации, Форма.ИНН);
			Элементы.ВидВыписки.Подсказка = Подсказка;
		Иначе
			Элементы.ВидВыписки.Подсказка = "";
		КонецЕсли;
		
	Иначе
		
		Элементы.ВидВыписки.Подсказка = "";
		
		Элементы.ГруппаПараметрЗапроса.Видимость = Истина;
		
	КонецЕсли;
	
	Форма.ПредставлениеЗапроса = ПолучитьПодсказкуЗначениеПоискаЗапросаЕГР(
		Объект.ПараметрЗапроса, 
		Объект.Контрагент,
		Объект.ПараметрЗапроса,
		Форма.НаименованиеОрганизации,
		Форма.ИНН);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьИННОрганизации()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ЭтоИП = НЕ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Объект.Организация);
		Если ЭтоИП Тогда
			Сведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, , "НаимЮЛСокр, ИННФЛ");
			ИНН = СокрЛП(Сведения.ИННФЛ);
			НаименованиеОрганизации = Сведения.НаимЮЛСокр;
		Иначе
			Сведения = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, , "НаимЮЛСокр, ИННЮЛ");
			ИНН = СокрЛП(Сведения.ИННЮЛ);
			НаименованиеОрганизации = Сведения.НаимЮЛСокр;
		КонецЕсли;
	Иначе
		ИНН = "";
		НаименованиеОрганизации = "";
	КонецЕсли;

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФормы(Форма)
	
	Объект = Форма.Объект;
	
	ДлинаСтроки = СтрДлина(Объект.ПараметрЗапроса);
	
	СтрокаПодсказки = "";
	Если ДлинаСтроки = 13 ИЛИ ДлинаСтроки = 15 Тогда
		СтрокаПодсказки = "ОГРН " + Объект.ПараметрЗапроса;
	ИначеЕсли ДлинаСтроки = 10 ИЛИ ДлинаСтроки = 12 Тогда
		СтрокаПодсказки = "ИНН " + Объект.ПараметрЗапроса;
	КонецЕсли;

	
	Если ЗначениеЗаполнено(СтрокаПодсказки) Тогда
		Заголовок = НСтр("ru = 'Запрос на выписку из ЕГРЮЛ/ЕГРИП по %1';
						|en = 'Запрос на выписку из ЕГРЮЛ/ЕГРИП по %1'");
	Иначе
		Заголовок = НСтр("ru = 'Запрос на выписку из ЕГРЮЛ/ЕГРИП';
						|en = 'Запрос на выписку из ЕГРЮЛ/ЕГРИП'");
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, СтрокаПодсказки);
		
	Форма.Заголовок = Заголовок;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеПараметрЗапроса(Форма)
	
	Форма.ПредставлениеЗапроса = ПолучитьПодсказкуЗначениеПоискаЗапросаЕГР(
		Форма.Объект.ПараметрЗапроса, 
		Форма.Объект.Контрагент,
		Форма.Объект.ПараметрЗапроса,
		Форма.НаименованиеОрганизации,
		Форма.ИНН);
	
КонецПроцедуры

&НаСервере
Функция ПрорисоватьСтатус()
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Объект.Ссылка, Объект.Организация);
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(ЭтаФорма, ПараметрыПрорисовкиПанелиОтправки);
		
КонецФункции

&НаСервере
Процедура УправлениеСтатусомИДоступностью()
	
	ПрорисоватьСтатус();
	УправлениеЭУОтправка();
		
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУОтправка()
	
	ТекстСообщения = "";
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДОСервер = Неопределено Тогда 
		Элементы.Отправить.Видимость = Ложь; // пока отсутствует обработчик
		Возврат;
	КонецЕсли;
	
	ЗаявлениеОтправлено = ЗаявлениеОтправлено(Объект.Ссылка);
	
	Элементы.Отправить.Видимость 			= Не ЗаявлениеОтправлено;
	Элементы.Записать.ТолькоВоВсехДействиях = ЗаявлениеОтправлено;
	
	Если ЗаявлениеОтправлено Тогда
		
		Элементы.ГруппаВидВыписки.Видимость 	  = Ложь;

		Элементы.ГруппаПараметрЗапроса.Видимость  = Истина;
		
		Элементы.ЗаголовокПараметрЗапроса.Заголовок  		= НСтр("ru = 'Выписка по:';
																	|en = 'Выписка по:'");
		Элементы.ПараметрЗапроса.Вид						= ВидПоляФормы.ПолеНадписи;
		Элементы.ПараметрЗапроса.ОтображениеПодсказки 		= ОтображениеПодсказки.Нет;
		Элементы.ПараметрЗапроса.РастягиватьПоГоризонтали 	= Истина;
		Элементы.ПараметрЗапроса.АвтоМаксимальнаяШирина 	= Ложь;
		
	КонецЕсли;
	
	ПриИзмененииВидаВыписки(ЭтотОбъект);
	
	Элементы.Организация.ТолькоПросмотр = ЗаявлениеОтправлено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисвоитьЗначениеПараметруЗапроса(РезультатВыбора, Параметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;   

	ИННКонтрагента = ПолучитьИННКонтрагента(РезультатВыбора);
	
	Если ПустаяСтрока(ИННКонтрагента) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'У контрагента не заполнен ИНН.';
														|en = 'У контрагента не заполнен ИНН.'"));
		Объект.Контрагент = Неопределено;
		ПредставлениеЗапроса = Неопределено;
		Объект.ПараметрЗапроса = Неопределено;
		Возврат;
	КонецЕсли;
	
	Объект.ПараметрЗапроса 	= ИННКонтрагента;
	Объект.Контрагент 		= РезультатВыбора;
	
	Модифицированность = Истина;
	
	ОбновитьПредставлениеПараметрЗапроса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПодсказкуЗначениеПоискаЗапросаЕГР(
		КодПоиска, 
		Контрагент, 
		ПараметрЗапроса,
		НаименованиеОрганизации,
		ИНН)
	
	КодПоиска = СокрЛП(КодПоиска);
	
	КодПоискаТолькоЦифры = "";
	Для Индекс = 1 По СтрДлина(КодПоиска) Цикл
		Символ = Сред(КодПоиска, Индекс, 1);
		Если Не ЗначениеЗаполнено(Символ) Тогда
			Продолжить;
		КонецЕсли;
		Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ,, Ложь) Тогда
			КодПоискаТолькоЦифры = КодПоискаТолькоЦифры + Символ;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ДлинаСтроки = СтрДлина(КодПоискаТолькоЦифры);
	СтрокаПодсказки = "";
	
	Если ДлинаСтроки = 13 ИЛИ ДлинаСтроки = 15 Тогда
		СтрокаПодсказки = КодПоискаТолькоЦифры + " (ОГРН)";
	ИначеЕсли ДлинаСтроки = 10 ИЛИ ДлинаСтроки = 12 Тогда
		СтрокаПодсказки = КодПоискаТолькоЦифры + " (ИНН)";
	Иначе
		Контрагент = Неопределено;
		СтрокаПодсказки = КодПоискаТолькоЦифры;
	КонецЕсли;
	
	КодПоиска = КодПоискаТолькоЦифры;
	
	Если ИНН = ПараметрЗапроса Тогда
		// За себя
		Если ЗначениеЗаполнено(НаименованиеОрганизации) Тогда
			СтрокаПодсказки = СтрокаПодсказки + ", " + НаименованиеОрганизации;
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(Контрагент) Тогда
			// За контрагента
			КраткоеНаименование = ПолучитьКраткоеНаименованиеКонтрагента(Контрагент);
			СтрокаПодсказки = СтрокаПодсказки + ", " + КраткоеНаименование;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтрокаПодсказки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьКраткоеНаименованиеКонтрагента(Контрагент)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "Наименование");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьИННКонтрагента(КонтрагентСсылка);
	
	ИННКонтрагента = "";
	
	Если НЕ ЗначениеЗаполнено(КонтрагентСсылка) Тогда
		Возврат ИННКонтрагента;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Контрагенты.ИНН
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", КонтрагентСсылка);
	
	Попытка
		Результат = Запрос.Выполнить();
	Исключение
		Возврат ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервераПереопределяемый.ИННКонтрагента(КонтрагентСсылка);
	КонецПопытки;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ИННКонтрагента = СокрЛП(Выборка.ИНН);
	КонецЦикла;
	
	Возврат ИННКонтрагента;
	
КонецФункции

&НаСервереБезКонтекста
Функция КонтекстЭДОСервер()
	
	Возврат ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаявлениеОтправлено(Ссылка)
	
	СтатусОтправки = КонтекстЭДОСервер().ПолучитьСтатусОтправкиОбъекта(Ссылка);
	
	ЗаявлениеОтправлено = 
		ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;
		
	Возврат ЗаявлениеОтправлено;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьОрганизациюПоУмолчанию()

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
			Объект.Организация = Модуль.ОрганизацияПоУмолчанию();
		КонецЕсли;
	КонецЕсли;
	
	// Если организаций больше одной, то используем основную организацию
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Объект.Организация = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	ВидВыписки = "контрагенту";
	ОпределитьИННОрганизации();
	ПриИзмененииВидаВыписки(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОрганизациюИзЗначенияЗаполнения(Параметры)

	Если Параметры.Свойство("ЗначенияЗаполнения") 
		И ТипЗнч(Параметры.ЗначенияЗаполнения) = Тип("Структура")
		И Параметры.ЗначенияЗаполнения.Свойство("Организация") Тогда
		
		Объект.Организация = Параметры.ЗначенияЗаполнения.Организация;
		
		ВидВыписки = "контрагенту";
		ОпределитьИННОрганизации();
		ПриИзмененииВидаВыписки(ЭтотОбъект);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыНовогоДокумента()

	Если Параметры.Ключ.Пустая() Тогда
		
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			ЗаполнитьОрганизациюПоУмолчанию();
		КонецЕсли;
		
		ЗаполнитьОрганизациюИзЗначенияЗаполнения(Параметры);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

#КонецОбласти