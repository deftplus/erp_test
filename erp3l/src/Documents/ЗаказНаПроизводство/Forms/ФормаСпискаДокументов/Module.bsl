//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДелаПереопределяемый.ПриСозданииНаСервере(ЭтаФорма, Список);
	
	ОтборыСписковКлиентСервер.СкопироватьСписокВыбораОтбораПоМенеджеру(
		Элементы.ОтветственныйОтбор.СписокВыбора,
		ОбщегоНазначенияУТ.ПолучитьСписокПользователейСПравомДобавления(Метаданные.Документы.ЗаказНаПроизводство));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеНеАктивен",  СостояниеНеАктивен());
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеЗакрыт",     СостояниеЗакрыт());
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеВРаботе",    СостояниеВРаботе());
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеВыполнен",   СостояниеВыполнен());
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеПостроение", СостояниеПостроение());
			
	Если Параметры.Свойство("СтруктураОтборов") Тогда
		УстановитьОтборыПоСтруктуреОтборов(Параметры.СтруктураОтборов);
	КонецЕсли;
		
	УстановитьВидимостьДоступностьЭлементов();
	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма, Элементы.КоманднаяПанельГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ЗаказНаПроизводство" Тогда
		УправлениеИндикаторами();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ТекущиеДелаПереопределяемый.ПередЗагрузкойДанныхИзНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтборПоПриоритету();
	УстановитьОтборПоПодразделению();
	УстановитьОтборПоОтветственному();
	
	УправлениеИндикаторами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусу();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СтатусОтборНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВыбранныеЗначения", Статус);
	
	ОткрытьФорму("Документ.ЗаказНаПроизводство.Форма.ОтборПоСтатусу",
					ПараметрыФормы,
					ЭтотОбъект,,,,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборНачалоВыбораЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		
		Статус = ВыбранноеЗначение;
		УстановитьОтборПоСтатусу();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборОчистка(Элемент, СтандартнаяОбработка)
	
	Если Статус.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Статус.Очистить();
	
	УстановитьОтборПоСтатусу();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриоритетОтборПриИзменении(Элемент)
	
	УстановитьОтборПоПриоритету();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеОтборПриИзменении(Элемент)
	УстановитьОтборПоПодразделению();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	УстановитьОтборПоОтветственному();
КонецПроцедуры

&НаКлиенте
Процедура ИндикаторПрименяютсяНедействующиеСпецификацииНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Подразделение", Подразделение);
	ПараметрыФормы.Вставить("Ответственный", Ответственный);
	ОткрытьФорму("Документ.ЗаказНаПроизводство.Форма.ЗаменаНедействующихСпецификаций", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура КомандаПерейтиКВыпускуПродукцииОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВыпускПродукции.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКВыработкеСотрудниковОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВыработкаСотрудников.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКЗаказамПереработчикамОтЗаказов(Команда)

	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ЗаказПереработчику.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКМаршрутнымЛистамОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ПараметрыФормы.Вставить("НеЗагружатьОтборы", Истина);
	ОткрытьФорму("Документ.МаршрутныйЛистПроизводства.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПерейтиКПередачеМатериаловОтЗаказов(Команда)
	
	СписокЗаказов = ВыбранныеЗаказы();
	Если СписокЗаказов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ОтборПоСпискуЗаказов", СписокЗаказов);
	ОткрытьФорму("Документ.ВнутреннееПотреблениеТоваров.Форма.ФормаСписка", ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПланированиеЗаказа(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыЗаказовНаПроизводство.КПроизводству") Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Планирование заказа недоступно.
										|Заказ должен быть проведен со статусом ""К производству"".';
										|en = 'Cannot plan the order.
										|The order should be posted with status ""For production"".'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заказ", ТекущиеДанные.Ссылка);
	
	ОткрытьФорму("Обработка.ДиспетчированиеГрафикаПроизводства.Форма.Планирование", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбслуживаниеФормы

&НаСервере
Процедура УправлениеИндикаторами()
	
	Если ПравоДоступа("Редактирование", Метаданные.Документы.ЗаказНаПроизводство) Тогда
		ВидимостьИндикатора = Документы.ЗаказНаПроизводство.ЕстьЗаказыСНедействующимиСпецификациями(Подразделение, Ответственный);
	Иначе
		ВидимостьИндикатора = Ложь;
	КонецЕсли;
	
	Элементы.ИндикаторПрименяютсяНедействующиеСпецификации.Видимость = ВидимостьИндикатора;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если ПравоДоступа("Использование", Метаданные.Обработки.ДиспетчированиеГрафикаПроизводства) Тогда
		Элементы.СписокПланированиеЗаказа.Видимость = Истина;
	Иначе
		Элементы.СписокПланированиеЗаказа.Видимость = Ложь;
	КонецЕсли; 
	
	ПравоДоступаДобавление = Документы.ЗаказНаПроизводство.ПравоДоступаДобавление();
	
	ИспользоватьПодменюСоздания = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенноеОбеспечениеПотребностей")
		ИЛИ ПолучитьФункциональнуюОпцию("ИспользоватьПланированиеПроизводства");
	
	Элементы.ФормаСписокГруппаСоздать.Видимость = ПравоДоступаДобавление И ИспользоватьПодменюСоздания;
	Элементы.СписокСоздатьНовый.Видимость       = ПравоДоступаДобавление И НЕ ИспользоватьПодменюСоздания;
	
	УправлениеИндикаторами();
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Номер.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Дата.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Статус.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеГрафика.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Подразделение.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Ответственный.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Комментарий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаказовНаПроизводство.Закрыт;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Приоритеты.Ссылка                      КАК Приоритет,
	|	-Приоритеты.РеквизитДопУпорядочивания  КАК ПриоритетНомер,
	|	Приоритеты.Цвет                        КАК Цвет,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(Приоритеты.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.Приоритеты КАК Приоритеты");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Элемент = УсловноеОформление.Элементы.Добавить();

			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Приоритет.Имя);
			
			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Приоритет");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Выборка.ПриоритетНомер;
			
			Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Выборка.Цвет.Получить());
			Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Выборка.Представление);
			
			Элемент = УсловноеОформление.Элементы.Добавить();

			ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
			ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПриоритетОтбор.Имя);

			ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
			ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ОтборЭлемента.ПравоеЗначение = Выборка.Приоритет;

			Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Выборка.Цвет.Получить());
			
		КонецЦикла;
		
	КонецЕсли;
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтатусу(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Статус", 
		Статус, 
		ВидСравненияКомпоновкиДанных.ВСписке,
		, // Представление - автоматически
		ЗначениеЗаполнено(Статус));
	
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПриоритету()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"ПриоритетОтбор", 
		Приоритет, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Приоритет));
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПодразделению(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Подразделение", 
		Подразделение, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Подразделение));
	
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОтветственному(ОбновитьИндикаторы = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		Список.Отбор, 
		"Ответственный", 
		Ответственный, 
		ВидСравненияКомпоновкиДанных.Равно,
		, // Представление - автоматически
		ЗначениеЗаполнено(Ответственный));
	
	Если ОбновитьИндикаторы Тогда
		УправлениеИндикаторами();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыПоСтруктуреОтборов(СтруктураОтборов)
	
	Если СтруктураОтборов.Свойство("Статусы") Тогда
		
		Статус.ЗагрузитьЗначения(СтруктураОтборов.Статусы);
		УстановитьОтборПоСтатусу(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Константы

&НаКлиентеНаСервереБезКонтекста
Функция СостояниеНеАктивен() 
	
	Возврат НСтр("ru = 'Не активен';
				|en = 'Not active'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СостояниеЗакрыт() 
	
	Возврат НСтр("ru = 'Закрыт';
				|en = 'Closed'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СостояниеВРаботе() 
	
	Возврат НСтр("ru = 'В работе';
				|en = 'In progress'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СостояниеВыполнен() 
	
	Возврат НСтр("ru = 'Выполнен';
				|en = 'Completed'");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СостояниеПостроение() 
	
	Возврат НСтр("ru = 'Построение';
				|en = 'Build'");
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаКлиенте
Функция ВыбранныеЗаказы()

	Возврат ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область Производительность

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина,
		"Документ.ЗаказНаПроизводство.ФормаСпискаДокументов.Элемент.Список.Выбор");
	
КонецПроцедуры

#КонецОбласти
//-- Устарело_Производство21
