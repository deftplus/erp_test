&НаКлиенте
Перем Хранилище Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДоступнаОблачнаяКриптография = УниверсальныйОбменСБанками.ДоступнаОблачнаяКриптография();
	
	Если Параметры.Свойство("БезВозможностиВыбора") И Параметры.БезВозможностиВыбора Тогда
		БезВозможностиВыбора = Истина;
		Элементы.Выбрать.Видимость = Ложь;
	КонецЕсли;
	
	// Параметры для фильтрации сертификатов.
	ПараметрыОтбора = Параметры.ПараметрыОтбора;
	Если ПараметрыОтбора <> Неопределено Тогда
		ПредставлениеОтбора = ПараметрыОтбора.ПредставлениеОтбора;
	КонецЕсли;
	Элементы.ПредставлениеОтбора.Видимость = НЕ ПустаяСтрока(ПредставлениеОтбора);
	
	// переопределяем параметры в реквизиты
	МножественныйВыбор = Параметры.МножественныйВыбор;
	Отпечатки = Параметры.Отпечатки;
	
	// если форма открыта не для множественного выбора, то скроем ЭУ, связанные с ним
	Если НЕ МножественныйВыбор Тогда
		Элементы.ГруппаМножественныйВыбор.Видимость = Ложь;
	КонецЕсли;
	
	// определяем с каким хранилищем будем работать
	ОбрабатываемоеХранилище = ?(ЗначениеЗаполнено(Параметры.Хранилище), Врег(Параметры.Хранилище), "MY");
	
	// регулируем пометку у кнопки показа просроченных сертификатов
	ЗапретитьВыборПросроченных = Параметры.ЗапретитьВыборПросроченных;
	Если ЗапретитьВыборПросроченных Тогда
		Элементы.ПоказыватьПросроченные.Пометка   = Ложь;
		Элементы.ПоказыватьПросроченные.Видимость = Ложь;
	Иначе
		Элементы.ПоказыватьПросроченные.Пометка = (Параметры.ПоказыватьПросроченные = Истина);
	КонецЕсли;
	
	// регулируем видимость колонки ИНН (если показывается хранилище Личные, то ИНН показываем)
	Элементы.СертификатыИНН.Видимость = (ОбрабатываемоеХранилище = "MY");
	Элементы.СертификатыСНИЛС.Видимость = (ОбрабатываемоеХранилище = "MY");
	
	// инициализируем массив с начальными значениями
	Если НЕ ЗначениеЗаполнено(Параметры.НачальноеЗначениеВыбора) Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
	ИначеЕсли ТипЗнч(Параметры.НачальноеЗначениеВыбора) = Тип("Массив") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.ЗагрузитьЗначения(Параметры.НачальноеЗначениеВыбора);
	ИначеЕсли ТипЗнч(Параметры.НачальноеЗначениеВыбора) = Тип("Строка") Тогда
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.Добавить(Параметры.НачальноеЗначениеВыбора);
	Иначе
		НачальноеЗначениеВыбора = Новый СписокЗначений;
		НачальноеЗначениеВыбора.ЗагрузитьЗначения(Параметры.НачальноеЗначениеВыбора.Выгрузить( ,"Сертификат").ВыгрузитьКолонку("Сертификат"));
	КонецЕсли;
	
	Если НачальноеЗначениеВыбора.Количество() > 1 Тогда
		Элементы.МножественныйВыбор.Пометка = Истина;
	КонецЕсли;
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Для Каждого ЭлементУсловногоОформления Из УсловноеОформление.Элементы Цикл
		Для Каждого Эл Из ЭлементУсловногоОформления.Отбор.Элементы Цикл
			Эл.ПравоеЗначение = ТекущаяДата;
		КонецЦикла;
	КонецЦикла;
	
	Элементы.ТолькоОблачные.Видимость = ДоступнаОблачнаяКриптография;
	Элементы.ТолькоОблачные.Пометка = Ложь;
	
	Элементы.ГруппаИнструкция.Видимость =
		ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ВРег("ВыборСертификатаДляОбменаСБанками"),
			ВРег("Инструкция"), Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПолучитьСертификаты();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИнструкцияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПерейтиПоНавигационнойСсылке(УниверсальныйОбменСБанкамиФормыКлиентСервер.СсылкаНаИнструкцииПоРаботеСПрограммамиЭлектроннойПодписи());
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияЗакрытьНажатие(Элемент)
	
	Элементы.ГруппаИнструкция.Видимость = Ложь;
	СохранитьОтключениеВидимостиИнструкции();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СертификатыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если БезВозможностиВыбора Тогда
		ПоказатьСертификат();
	Иначе
		ВыбратьСертификат(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КоманднаяПанельСертификатыПоказать(Команда = Неопределено)
	
	ПоказатьСертификат();

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыВыбрать(Кнопка)
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, "Выберите сертификат!");
		Возврат;
	КонецЕсли;
	
	ВыбратьСертификат();
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыПоказыватьПросроченные(Команда)
	
	Элементы.ПоказыватьПросроченные.Пометка = НЕ Элементы.ПоказыватьПросроченные.Пометка;
	ОтобразитьТаблицуСертификатов();

КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыМножественныйВыбор(Команда)
	
	Элементы.МножественныйВыбор.Пометка = НЕ Элементы.МножественныйВыбор.Пометка;
	УправлениеЭУ();
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыУстановитьВсеФлажки(Команда)
	
	Для Каждого Стр Из Сертификаты Цикл
		Стр.Пометка = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельСертификатыСнятьВсеФлажки(Команда)
	
	Для Каждого Стр Из Сертификаты Цикл
		Стр.Пометка = Ложь;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПоказатьСертификат()
	
	ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите в таблице сертификат для показа.';
										|en = 'Select certificate for showing in the table.'"));
	Иначе
		Если ДоступнаОблачнаяКриптография И ТекДанные.Облачный Тогда
			Сертификат = УниверсальныйОбменСБанкамиКлиентСервер.СертификатКриптографииВСтуктуру(
				Новый СертификатКриптографии(ТекДанные.Сертификат));
			ПараметрыФормы = Новый Структура("Сертификат", Сертификат);
			ОткрытьФорму(
				"ОбщаяФорма.ПросмотрСертификатаОбменаСБанками", ПараметрыФормы,
				ЭтаФорма,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		Иначе
			СертификатДляПоказа = Новый Структура("Отпечаток, Поставщик", ТекДанные.Отпечаток, ТекДанные.Поставщик);
			УниверсальныйОбменСБанкамиКлиент.ПоказатьСертификат(СертификатДляПоказа);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьСертификатыИзЗащищенногоХранилищаНаСервере()
	
	// Определяем с каким хранилищем будем работать
	СоответствиеТиповХранилищ = Новый Соответствие;
	СоответствиеТиповХранилищ.Вставить("MY", Перечисления.ТипХранилищаСертификатов.ПерсональныеСертификаты);
	СоответствиеТиповХранилищ.Вставить("ADDRESSBOOK", Перечисления.ТипХранилищаСертификатов.СертификатыПолучателей);
	СоответствиеТиповХранилищ.Вставить("CA", Перечисления.ТипХранилищаСертификатов.СертификатыУдостоверяющихЦентров);
	СоответствиеТиповХранилищ.Вставить("ROOT", Перечисления.ТипХранилищаСертификатов.КорневыеСертификаты);
	
	Если ЗначениеЗаполнено(ОбрабатываемоеХранилище) Тогда
		Хранилище = СоответствиеТиповХранилищ.Получить(ВРег(ОбрабатываемоеХранилище));
	Иначе
		Хранилище = Перечисления.ТипХранилищаСертификатов.ПерсональныеСертификаты;
	КонецЕсли;
	
	// облачные сертификаты
	СертификатыИзХранилища = ХранилищеСертификатов.Получить(Хранилище);
	
	Возврат СертификатыИзХранилища;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьСертификатВТаблицу(Сертификат)
	
	Если Отпечатки.Количество() > 0 И Отпечатки.НайтиПоЗначению(Сертификат.Отпечаток) <> Неопределено 
		ИЛИ Отпечатки.Количество() = 0 Тогда
		
		НовыйСертификат = ПолнаяТаблицаСертификатов.Добавить();
		// Для локального сертификата не сохраняем данные сертификата.
		НовыйСертификат.Сертификат = Неопределено;
		ЗаполнитьЗначенияСвойств(НовыйСертификат, Сертификат);
		НовыйСертификат.Отпечаток = УниверсальныйОбменСБанкамиКлиентСервер.ДвоичныеДанныеВСтроку(Сертификат.Отпечаток);
		НовыйСертификат.СерийныйНомер = Строка(Сертификат.СерийныйНомер);
		НовыйСертификат.Наименование = УниверсальныйОбменСБанкамиКлиентСервер.НаименованиеСертификата(Сертификат);
		НовыйСертификат.Поставщик = УниверсальныйОбменСБанкамиКлиентСервер.СтуктураДанныхСертификатаВСтроку(Сертификат.Издатель);
		НовыйСертификат.Владелец = УниверсальныйОбменСБанкамиКлиентСервер.СтуктураДанныхСертификатаВСтроку(Сертификат.Субъект);
		НовыйСертификат.ПоставщикСтруктура = Сертификат.Издатель;
		НовыйСертификат.ВладелецСтруктура = Сертификат.Субъект;
		НовыйСертификат.СтруктураДанныхСертификата = УниверсальныйОбменСБанкамиКлиентСервер.СертификатКриптографииВСтуктуру(Сертификат);
		НовыйСертификат.Облачный = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСертификатВТаблицуСервер(Сертификат)
	
	// Серверный аналог функции ДобавитьСертификатВТаблицу для облачных сертификатов.
	
	Если Отпечатки.Количество() > 0 И Отпечатки.НайтиПоЗначению(Сертификат.Отпечаток) <> Неопределено 
		ИЛИ Отпечатки.Количество() = 0 Тогда
		
		НовыйСертификат = ПолнаяТаблицаСертификатов.Добавить();
		// Сохраняем двоичные данные сертификата.
		НовыйСертификат.Сертификат = Сертификат.Выгрузить();
		ЗаполнитьЗначенияСвойств(НовыйСертификат, Сертификат);
		НовыйСертификат.Отпечаток = УниверсальныйОбменСБанкамиКлиентСервер.ДвоичныеДанныеВСтроку(Сертификат.Отпечаток);
		НовыйСертификат.СерийныйНомер = Строка(Сертификат.СерийныйНомер);
		НовыйСертификат.Наименование = УниверсальныйОбменСБанкамиКлиентСервер.НаименованиеСертификата(Сертификат);
		НовыйСертификат.Поставщик = УниверсальныйОбменСБанкамиКлиентСервер.СтуктураДанныхСертификатаВСтроку(Сертификат.Издатель);
		НовыйСертификат.Владелец = УниверсальныйОбменСБанкамиКлиентСервер.СтуктураДанныхСертификатаВСтроку(Сертификат.Субъект);
		НовыйСертификат.ПоставщикСтруктура = Сертификат.Издатель;
		НовыйСертификат.ВладелецСтруктура = Сертификат.Субъект;
		НовыйСертификат.СтруктураДанныхСертификата = УниверсальныйОбменСБанкамиКлиентСервер.СертификатКриптографииВСтуктуру(Сертификат);
		НовыйСертификат.Облачный = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСертификатыИзЗащищенногоХранилища()
	
	Если ДоступнаОблачнаяКриптография Тогда
		
		СертификатыИзХранилища = ПолучитьСертификатыИзЗащищенногоХранилищаНаСервере();
		Для каждого Сертификат Из СертификатыИзХранилища Цикл
			СертификатКриптографии = Новый СертификатКриптографии(Сертификат.Сертификат);
			// Фильтр по параметрам отбора.
			Если НЕ УниверсальныйОбменСБанкамиКлиентСервер.СертификатСоответствуетОтбору(
						СертификатКриптографии, ПараметрыОтбора).ПризнакСоответствия Тогда
				Продолжить;
			КонецЕсли;
			ДобавитьСертификатВТаблицуСервер(СертификатКриптографии);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификаты(ТолькоОблачные = Ложь, УстанавливатьРасширение = Ложь)
	
	ПолнаяТаблицаСертификатов.Очистить();
	// Добавляем облачные сертификаты.
	ДобавитьСертификатыИзЗащищенногоХранилища();
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("УстанавливатьРасширение", УстанавливатьРасширение);
	
	Если НЕ ТолькоОблачные Тогда
		Оповещение = Новый ОписаниеОповещения("ПолучитьСертификатыПослеПодключенияРасширения",
			ЭтотОбъект,
			ДополнительныеПараметры);
			
		НачатьПодключениеРасширенияРаботыСКриптографией(Оповещение);
		Возврат;
	Иначе
		ПолучитьСертификатыПослеПолученияЛокальныхЗавершение(
			Новый Структура("Выполнено", Ложь),
			ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификатыПослеПодключенияРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Элементы.ТолькоОблачные.Пометка = НЕ Подключено;
	Если НЕ Подключено И НЕ ДополнительныеПараметры.УстанавливатьРасширение Тогда
		ПолучитьСертификатыПослеПолученияЛокальныхЗавершение(
			Новый Структура("Выполнено", Ложь), ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучитьСертификатыПослеПолученияЛокальныхЗавершение", ЭтотОбъект);
	
	УниверсальныйОбменСБанкамиКлиент.ПолучитьСертификаты(
		ОписаниеОповещения, Новый Структура("Хранилище,ЭтоЛокальноеХранилище", ОбрабатываемоеХранилище, Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСертификатыПослеПолученияЛокальныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.ТолькоОблачные.Пометка = НЕ Результат.Выполнено;
	
	Если Результат.Выполнено Тогда
		ЛокальныеСертификаты = Результат.Сертификаты;
	Иначе
		ЛокальныеСертификаты = Новый Массив;
	КонецЕсли;
	
	Сертификаты.Очистить();
	
	// Заполняем полную таблицу сертификатов из хранилища.
	Для Каждого ЭлементСертификат Из ЛокальныеСертификаты Цикл
		ДобавитьСертификатВТаблицу(ЭлементСертификат);
	КонецЦикла;
	
	ПостОбработкаПолнойТаблицыСертификатовНаСервере();
	
	// Если один из сертификатов начального значения выбора просрочен, то включим показ просроченных.
	МодульУниверсальныйОбменСБанкамиВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("УниверсальныйОбменСБанкамиВызовСервера");
	ТекущаяДата = МодульУниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере();
	
	Если НЕ ЗапретитьВыборПросроченных Тогда
		Для Каждого ЭлНачальноеЗначениеВыбора Из НачальноеЗначениеВыбора Цикл
			Если ЗначениеЗаполнено(ЭлНачальноеЗначениеВыбора.Значение) Тогда
				ТекСертСтроки = ПолнаяТаблицаСертификатов.НайтиСтроки(Новый Структура("Отпечаток", ЭлНачальноеЗначениеВыбора.Значение));
				Если ТекСертСтроки.Количество() > 0 Тогда
					Для Каждого ТекСертСтрока Из ТекСертСтроки Цикл
						Если НЕ Элементы.ПоказыватьПросроченные.Пометка И (ТекущаяДата < ТекСертСтрока.ДатаНачала ИЛИ ТекущаяДата > ТекСертСтрока.ДатаОкончания) Тогда
							Элементы.ПоказыватьПросроченные.Пометка = Истина;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// отображаем на форме таблицу сертификатов на основе полной таблицы сертификатов
	ОтобразитьТаблицуСертификатов();
	
	// активизируем начальные значения выбора
	Для Каждого ЭлНачальноеЗначениеВыбора Из НачальноеЗначениеВыбора Цикл
		Если ЗначениеЗаполнено(ЭлНачальноеЗначениеВыбора.Значение) Тогда
			ТекСертСтроки = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ЭлНачальноеЗначениеВыбора.Значение));
			Если ТекСертСтроки.Количество() > 0 Тогда
				Для Каждого Стр Из ТекСертСтроки Цикл
					Стр.Пометка = Истина;
					Элементы.Сертификаты.ТекущаяСтрока = Стр.ПолучитьИдентификатор();
				КонецЦикла;
			Иначе
				ТекстСообщения = НСтр("ru = 'Сертификат с отпечатком ""%1"" не найден в хранилище сертификатов для текущих параметров отбора.';
										|en = 'A certificate with thumbprint ""%1"" was not found in the certificate storage for the current filter parameters.'");
				ТекстСообщения = СтрШаблон(
					ТекстСообщения,
					ЭлНачальноеЗначениеВыбора);
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	УправлениеЭУ();
	
КонецПроцедуры

&НаСервере
Процедура ПостОбработкаПолнойТаблицыСертификатовНаСервере()
	
	Для Каждого Сертификат Из ПолнаяТаблицаСертификатов Цикл
		
		Сертификат.Поставщик = ЗначениеПоля(Сертификат.Поставщик);
		Сертификат.СерийныйНомер = ЗначениеПоля(Сертификат.СерийныйНомер);
		Сертификат.Владелец = ЗначениеПоля(Сертификат.Владелец);
		Сертификат.Наименование = ЗначениеПоля(Сертификат.Наименование);
		Сертификат.Отпечаток = нрег(Сертификат.Отпечаток);
		
		ПараметрыВладельца = УниверсальныйОбменСБанкамиКлиентСервер.ДанныеВладельцаСертификата(Сертификат.ВладелецСтруктура);
		Сертификат.ИмяВладельца = ЗначениеПоля(ПараметрыВладельца.Имя);
		Сертификат.Организация = ЗначениеПоля(ПараметрыВладельца.Организация);
		Сертификат.Должность = ЗначениеПоля(?(ЗначениеЗаполнено(ПараметрыВладельца.Должность) И ПараметрыВладельца.Должность <> "0",
												ПараметрыВладельца.Должность,
												ПараметрыВладельца.Подразделение));
		Сертификат.EMail = ЗначениеПоля(ПараметрыВладельца.ЭлектроннаяПочта);
		Сертификат.ИНН = ЗначениеПоля(ПараметрыВладельца.ИНН);
		Сертификат.СНИЛС = ЗначениеПоля(ПараметрыВладельца.СНИЛС);
		
		ПоставщикСтруктура = Сертификат.ПоставщикСтруктура;
		Если ПоставщикСтруктура.Свойство("CN") Тогда
			Сертификат.Издатель = ПоставщикСтруктура["CN"];
		КонецЕсли;
	
	КонецЦикла;
	
	ПолнаяТаблицаСертификатов.Сортировать("ИмяВладельца");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеПоля(СтрЗначениеПоля)
	
	Возврат ?(НЕ ЗначениеЗаполнено(СтрЗначениеПоля) ИЛИ СокрЛП(СтрЗначениеПоля) = "0", "", СтрЗначениеПоля);
	
КонецФункции

&НаКлиенте
Процедура ОтобразитьТаблицуСертификатов()
	
	// запоминаем выбранные сертификаты
	ВыбранныеСертификаты = Новый Массив;
	ПомеченныеСертификатыСтр = Сертификаты.НайтиСтроки(Новый Структура("Пометка", Истина));
	Для Каждого ЭлСертификат Из ПомеченныеСертификатыСтр Цикл
		ВыбранныеСертификаты.Добавить(ЭлСертификат.Отпечаток);
	КонецЦикла;
	
	// запоминаем текущий сертификат
	Если Элементы.Сертификаты.ТекущиеДанные <> Неопределено Тогда
		ТекущийСертификат = Элементы.Сертификаты.ТекущиеДанные.Отпечаток;
	КонецЕсли;
	
	// очищаем таблицу перед новым заполнением
	Сертификаты.Очистить();
	
	// заполняем таблицу заново
	Если ПараметрыОтбора = Неопределено Тогда
		ТекущаяДата = УниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере();
	Иначе
		ТекущаяДата = ПараметрыОтбора.Дата;
	КонецЕсли;
	
	Для Каждого Сертификат Из ПолнаяТаблицаСертификатов Цикл
		// Фильтр по дате.
		Если НЕ Элементы.ПоказыватьПросроченные.Пометка И (ТекущаяДата < Сертификат.ДатаНачала ИЛИ ТекущаяДата > Сертификат.ДатаОкончания) Тогда
			Продолжить;
		КонецЕсли;
		// Фильтр облачных.
		Если Элементы.ТолькоОблачные.Пометка И НЕ Сертификат.Облачный Тогда
			Продолжить;
		КонецЕсли;
		// Фильтр по параметрам отбора.
		Если НЕ УниверсальныйОбменСБанкамиКлиентСервер.СертификатСоответствуетОтбору(
					Сертификат.СтруктураДанныхСертификата, ПараметрыОтбора).ПризнакСоответствия Тогда
			Продолжить;
		КонецЕсли; 
		
		НовСтр = Сертификаты.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Сертификат);
	КонецЦикла;
	
	// устанавливаем выбранные сертификаты
	Для Каждого ВыбранныйСертификат Из ВыбранныеСертификаты Цикл
		СтрНайденныеСертификаты = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ВыбранныйСертификат));
		Для Каждого СтрНайденныйСертификат Из СтрНайденныеСертификаты Цикл
			СтрНайденныйСертификат.Пометка = Истина;
		КонецЦикла;
	КонецЦикла;
	
	// устанавливаем текущий сертификат
	Если ТекущийСертификат <> Неопределено Тогда
		СтрокаСертификат = Сертификаты.НайтиСтроки(Новый Структура("Отпечаток", ТекущийСертификат));
		Если СтрокаСертификат.Количество() > 0 Тогда
			Элементы.Сертификаты.ТекущаяСтрока = СтрокаСертификат[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеЭУ()
	
	Если Элементы.ГруппаМножественныйВыбор.Видимость И Элементы.МножественныйВыбор.Пометка Тогда
		Элементы.СертификатыПометка.Видимость = Истина;
		Элементы.УстановитьВсеФлажки.Доступность = Истина;
		Элементы.СнятьВсеФлажки.Доступность = Истина;
	Иначе
		Элементы.СертификатыПометка.Видимость = Ложь;
		Элементы.УстановитьВсеФлажки.Доступность = Ложь;
		Элементы.СнятьВсеФлажки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСертификат(парамМножественныйВыбор = Неопределено)
	
	ТекущаяДата = УниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере();
	
	// если принудительно установлен режим выбора при вызове метода (множ. или нет) - используеи его
	Если парамМножественныйВыбор <> Неопределено Тогда
		ПризнакВыбораНесколькихСтрок = парамМножественныйВыбор;
	Иначе
		ПризнакВыбораНесколькихСтрок = Элементы.МножественныйВыбор.Пометка;
	КонецЕсли;
	
	Если ПризнакВыбораНесколькихСтрок Тогда
		// помещаем сертификаты в массив и анализируем их периоды действия
		ТекСертификаты = Новый Массив;
		ОдинИзСертификатовПросрочен = Ложь;
		Для Каждого СтрСертификат Из Сертификаты Цикл
			
			// если строка не помечена, то продолжим
			Если НЕ СтрСертификат.Пометка Тогда
				Продолжить;
			КонецЕсли;
			
			// если сертификат просрочен, то взведем флаг
			СрокИстек = ТекущаяДата > СтрСертификат.ДатаОкончания;
			СрокНеНачался = ТекущаяДата < СтрСертификат.ДатаНачала;
			Если СрокИстек ИЛИ СрокНеНачался Тогда
				ОдинИзСертификатовПросрочен = Истина;
			КонецЕсли;
			
			СвойстваСертификата = СвойстваСертификата(СтрСертификат);
			ТекСертификаты.Добавить(СвойстваСертификата);
			
		КонецЦикла;
		
		// если один из сертификатов просрочен, то задаем уточняющий вопрос
		Если ОдинИзСертификатовПросрочен Тогда
			ДополнительныеПараметры = Новый Структура("ТекСертификаты", ТекСертификаты);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросСредиВыбранныеЕстьПросроченныеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ТекстВопроса = "Среди выбранных сертификатов есть такие, срок действия которых истек.
				|Вы уверены, что хотите продолжить выбор?";
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			Закрыть(ТекСертификаты);
		КонецЕсли;
		
	Иначе
		
		ТекДанные = Элементы.Сертификаты.ТекущиеДанные;
		
		СрокИстек = ТекущаяДата > ТекДанные.ДатаОкончания;
		СрокНеНачался = ТекущаяДата < ТекДанные.ДатаНачала;
		Если СрокИстек ИЛИ СрокНеНачался Тогда
			ДополнительныеПараметры = Новый Структура("ТекДанные", ТекДанные);
			ОписаниеОповещения = Новый ОписаниеОповещения("ВопросСертификатПросроченЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			ТекстВопроса = "Вы уверены, что хотите выбрать сертификат, срок действия которого " + ?(СрокИстек, "истек", "еще не начался") + "?";
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		РезультатПроверки = УниверсальныйОбменСБанкамиКлиентСервер.СертификатСоответствуетОтбору(
			ТекДанные.СтруктураДанныхСертификата, ПараметрыОтбора);
		Если НЕ РезультатПроверки.ПризнакСоответствия Тогда
			ПоказатьПредупреждение(, РезультатПроверки.СообщениеДляПользователя);
			Возврат;
		КонецЕсли;
		
		СвойстваСертификата = СвойстваСертификата(ТекДанные);
		
		Закрыть(СвойстваСертификата);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СвойстваСертификата(ТекДанные)
	
	СвойстваСертификата = Новый Структура;
	СвойстваСертификата.Вставить("ДатаНачала",			ТекДанные.ДатаНачала);
	СвойстваСертификата.Вставить("ДатаОкончания",			ТекДанные.ДатаОкончания);
	СвойстваСертификата.Вставить("Отпечаток",				ТекДанные.Отпечаток);
	СвойстваСертификата.Вставить("Поставщик",				ТекДанные.Поставщик);
	СвойстваСертификата.Вставить("СерийныйНомер",			ТекДанные.СерийныйНомер);
	СвойстваСертификата.Вставить("Владелец",				ТекДанные.Владелец);
	СвойстваСертификата.Вставить("Наименование",			ТекДанные.Наименование);
	СвойстваСертификата.Вставить("ВозможностьПодписи",		ТекДанные.ПригоденДляПодписания);
	СвойстваСертификата.Вставить("ВозможностьШифрования",	ТекДанные.ПригоденДляШифрования);
	СвойстваСертификата.Вставить("ПоставщикСтруктура",		ТекДанные.ПоставщикСтруктура);
	СвойстваСертификата.Вставить("ВладелецСтруктура",		ТекДанные.ВладелецСтруктура);
	
	Возврат СвойстваСертификата;
	
КонецФункции

&НаКлиенте
Процедура ВопросСертификатПросроченЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекДанные = ДополнительныеПараметры.ТекДанные;
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Закрыть(СвойстваСертификата(ТекДанные));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВопросСредиВыбранныеЕстьПросроченныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ТекСертификаты = ДополнительныеПараметры.ТекСертификаты;
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	Закрыть(ТекСертификаты);
	
КонецПроцедуры

&НаКлиенте
Процедура КоманднаяПанельФормыТолькоОблачные(Команда)
	
	Элементы.ТолькоОблачные.Пометка = НЕ Элементы.ТолькоОблачные.Пометка;
	ПолучитьСертификаты(Элементы.ТолькоОблачные.Пометка, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьОтключениеВидимостиИнструкции()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ВРег("ВыборСертификатаДляОбменаСБанками"),
		ВРег("Инструкция"), Ложь);
	
КонецПроцедуры

#КонецОбласти

