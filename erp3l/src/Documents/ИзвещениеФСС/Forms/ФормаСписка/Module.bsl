#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ТолькоТребующиеОтправки
		Или Параметры.ТолькоТребующиеОтправкиСегодня
		Или Параметры.ТолькоТребующиеПодтверждения Тогда
		
		КлючСохраненияПоложенияОкна = "ТолькоТребующиеОтправки";
		НачалоТекущегоДня = НачалоДня(ТекущаяДатаСеанса());
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Обработано",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"ОбработаноЛожь");
		Если Параметры.ТолькоТребующиеОтправки
			Или Параметры.ТолькоТребующиеОтправкиСегодня Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"МаксимальнаяДатаОтправкиРеестра",
				НачалоТекущегоДня,
				ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
				,
				,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
				"МаксимальнаяДатаОтправкиРеестраНачалоТекущегоДня");
		КонецЕсли;
		Если Параметры.ТолькоТребующиеПодтверждения Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"МаксимальнаяДатаПодтверждения",
				НачалоТекущегоДня,
				ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
				,
				,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
				"МаксимальнаяДатаПодтвержденияНачалоТекущегоДня");
		КонецЕсли;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"ПометкаУдаления",
			Ложь,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"ПометкаУдаленияЛожь");
		
	КонецЕсли;
	
	Если Параметры.ТолькоТребующиеОтправкиСегодня Тогда
		
		КлючСохраненияПоложенияОкна = "ТолькоТребующиеОтправкиСегодня";
		НачалоРабочегоДня = НачалоДня(Документы.ИзвещениеФСС.БлижайшийРабочийДень(НачалоТекущегоДня));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"МаксимальнаяДатаОтправкиРеестра",
			НачалоРабочегоДня,
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			,
			,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"МаксимальнаяДатаОтправкиРеестраНачалоРабочегоДня");
		
	КонецЕсли;
	
	// Добавление отборов и сохранение их идентификаторов для быстрого поиска.
	ОтборКД = Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ЭлементОтбораКД = ЗапросыБЗК.ДобавитьОтбор(ОтборКД, "Организация", "=", Организация);
	ЭлементОтбораКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ИдентификаторОтбораПоОрганизации = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	
	ЭлементОтбораКД = ЗапросыБЗК.ДобавитьОтбор(ОтборКД, "Обработано", "=", Ложь);
	ЭлементОтбораКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ИдентификаторОтбораИзвещенияВРаботе = ОтборКД.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	
	ОформлениеКД = ОбщегоНазначенияБЗК.ДобавитьУсловноеОформление(Список, "ОсталосьДней");
	ЗапросыБЗК.ДобавитьОтбор(ОформлениеКД.Отбор, "ОсталосьДней", "<=", 2);
	ОбщегоНазначенияБЗК.УстановитьПараметрУсловногоОформления(ОформлениеКД, "ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	
	КлючНазначенияИспользования = КлючСохраненияПоложенияОкна;
	
	ОбновитьПараметрыСписка();
	
	ОбновитьВидимостьДоступность();
	
	ПравоИзменения = ПравоДоступа("Изменение", Метаданные.Документы.ИзвещениеФСС);
	
	Элементы.ПолучитьИзФСС.Видимость                      = ПравоИзменения;
	Элементы.ПолучитьСообщенияЗаПериод.Видимость          = ПравоИзменения;
	Элементы.ПовторноЗаполнитьИзФайловИзвещений.Видимость = ПравоИзменения;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОбновитьПараметрыСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ИзвещениеФСС"
		Или ИмяСобытия = "Запись_БольничныйЛист"
		Или ИмяСобытия = "Запись_ОтпускПоУходуЗаРебенком"
		Или ИмяСобытия = "Запись_Отпуск"
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеПолученияСообщенийОтФСС()
		Или ИмяСобытия = СЭДОФССКлиент.ИмяСобытияПослеОтправкиПодтвержденияПолучения() Тогда
		ОтключитьОбработчикОжидания("ОбновитьСписок");
		ПодключитьОбработчикОжидания("ОбновитьСписок", 0.2, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФильтрПоОрганизацииПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТолькоИзвещенияВРаботеПриИзменении(Элемент)
	ОбновитьСписок();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	Оповестить("Запись_ИзвещениеФСС", Новый Структура, Неопределено);
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьИзФСС(Команда)
	СЭДОФССКлиент.ПолучитьСообщенияИзФСС(Организация);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНаОснованииФайловИзвещений(Команда)
	ОбновитьНаОснованииФайловИзвещенийНаСервере();
	Оповестить("Запись_ИзвещениеФСС");
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСообщенияЗаПериод(Команда)
	СЭДОФССКлиент.ОткрытьФормуПолученияСообщенийЗаПериод(Организация);
КонецПроцедуры

&НаКлиенте
Процедура ЗадаватьВопросОПодвержденииПолучения(Команда)
	ЗадаватьВопросОПодвержденииПолученияНаСервере();
	ПоказатьПредупреждение(, НСтр("ru = 'Включено напоминание о необходимости отправки подтверждения получения перед открытием файлов извещений ФСС';
									|en = 'Reminder to send confirmation of receipt before opening SSF notification files is enabled'"));
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьСписок()
	ОбновитьСписокНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокНаСервере()
	
	ОбновитьВидимостьДоступность();
	
	ОбновитьПараметрыСписка();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметрыСписка()
	
	НастройкиКД = Список.КомпоновщикНастроек.Настройки;
	
	ЭлементОтбораКД = НастройкиКД.Отбор.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораПоОрганизации);
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Организация") <> 0 Тогда
		ЭлементОтбораКД = ОбщегоНазначенияБЗК.ДобавитьОтборУсловногоОформления(НастройкиКД, "Организация", "=", Организация);
		ИдентификаторОтбораПоОрганизации = НастройкиКД.Отбор.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбораКД.Использование  = ЗначениеЗаполнено(Организация);
	ЭлементОтбораКД.ПравоеЗначение = Организация;
	
	ЭлементОтбораКД = НастройкиКД.Отбор.ПолучитьОбъектПоИдентификатору(ИдентификаторОтбораИзвещенияВРаботе);
	Если ТипЗнч(ЭлементОтбораКД) <> Тип("ЭлементОтбораКомпоновкиДанных")
		Или СтрСравнить(ЭлементОтбораКД.ЛевоеЗначение, "Обработано") <> 0 Тогда
		ЭлементОтбораКД = ОбщегоНазначенияБЗК.ДобавитьОтборУсловногоОформления(НастройкиКД, "Обработано", "=", Ложь);
		ИдентификаторОтбораИзвещенияВРаботе = НастройкиКД.Отбор.ПолучитьИдентификаторПоОбъекту(ЭлементОтбораКД);
	КонецЕсли;
	ЭлементОтбораКД.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбораКД.Использование = ИзвещенияВРаботе;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	
	Элементы.Организация.Видимость = Не ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьНаОснованииФайловИзвещенийНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИзвещениеФССПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ИзвещениеФССПрисоединенныеФайлы КАК ИзвещениеФССПрисоединенныеФайлы
	|ГДЕ
	|	ИзвещениеФССПрисоединенныеФайлы.Служебный";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Выборка.Ссылка.ПолучитьОбъект().Записать();
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	Если ПравоДоступа("Изменение", Метаданные.Документы.ИзвещениеФСС) Тогда
		ОтветНаВопрос = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
			"ПособияФСС.СЭДО",
			"ОтветНаВопросОПодтвержденииПолучения");
	Иначе
		ОтветНаВопрос = 2;
	КонецЕсли;
	Элементы.ЗадаватьВопросОПодвержденииПолучения.Видимость = ОтветНаВопрос <> Неопределено;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗадаватьВопросОПодвержденииПолученияНаСервере()
	ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(
		"ПособияФСС.СЭДО",
		"ОтветНаВопросОПодтвержденииПолучения",
		ИмяПользователя());
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
