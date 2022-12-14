
#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Документ = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Предусмотрено открытие обработки только из документов.';
								|en = 'Data processor can be opened only from documents.'");
	КонецЕсли;
	
	Объект.ГодЛимитирования = Параметры.ГодЛимитирования;
	Объект.Валюта = Параметры.Валюта;
	Объект.ВидБюджета = Параметры.ВидБюджета;
	
	ПериодЛимитированияНачало = НачалоГода(Объект.ГодЛимитирования);
	ПериодЛимитированияОкончание = НачалоДня(КонецГода(ПериодЛимитированияНачало));
	//Корзина
	ЗаполнитьКорзину(Параметры.Корзина);
	
	//
	ПараметрыЛимитирования = ПолучитьПараметрыЛимитирования(Объект.ВидБюджета, ПериодЛимитированияНачало);
	Периодичность = ПараметрыЛимитирования.Периодичность;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ВидБюджета", Объект.ВидБюджета);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Валюта", Объект.Валюта);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаНачала", ПериодЛимитированияНачало);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", ПериодЛимитированияОкончание);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Периодичность", Периодичность);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Документ", Параметры.Документ);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДокументУказан", ЗначениеЗаполнено(Параметры.Документ));
	
	// Дата, лимиты установленные на периоды с датой начала меньшей чем НачалоПериода считаются просроченными;
	Если Периодичность = Перечисления.Периодичность.Год Тогда
		НачалоПериода = НачалоГода(ТекущаяДатаСеанса());
	ИначеЕсли Периодичность = Перечисления.Периодичность.Полугодие Тогда
		НачалоПериода = ДобавитьМесяц(НачалоГода(ТекущаяДатаСеанса()), 6);
	ИначеЕсли Периодичность = Перечисления.Периодичность.Квартал Тогда
		НачалоПериода = НачалоКвартала(ТекущаяДатаСеанса());
	ИначеЕсли Периодичность = Перечисления.Периодичность.Месяц Тогда
		НачалоПериода = НачалоМесяца(ТекущаяДатаСеанса());
	ИначеЕсли Периодичность = Перечисления.Периодичность.Неделя Тогда
		НачалоПериода = НачалоНедели(ТекущаяДатаСеанса());
	Иначе
		НачалоПериода = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекущаяДата", НачалоПериода);
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("Корзина", Объект.Корзина);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьТекстИнформационнойНадписи(ЭтаФорма);
	
	НастроитьПоляБыстрогоОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И Объект.Корзина.Количество() > 0 Тогда
		
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.';
									|en = 'All changes made to the data will be lost.'");
		
		Возврат;
		
	КонецЕсли;
	
	ПередЗакрытиемФормыПодбораЛимитов(ЭтаФорма, Объект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	//СохранитьНастройкиФормыНаСервере();
	Если ПеренестиВДокумент Тогда
		АдресЛимитовВХранилище = АдресТоваровВХранилище(ЭтаФорма.ВладелецФормы.УникальныйИдентификатор);
	Иначе
		АдресЛимитовВХранилище = Неопределено;
	КонецЕсли;
	
	Если АдресЛимитовВХранилище <> Неопределено Тогда
		Структура = Новый Структура("АдресЛимитовВХранилище", АдресЛимитовВХранилище);
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Прочее

&НаКлиенте
Процедура ИнформационнаяНадписьНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриНажатииНаИнформационнуюНадпись(ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВидБюджетаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВалютаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГодЛимитированияНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура ПодборТаблицаЛимитовПриАктивизацииСтроки(Элемент)
	
	ПриАктивизацииСтрокиТаблицыЛимитов(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТаблицаЛимитовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = ДополнительныеПараметрыОбработкиЗавершения();
	ДополнительныеПараметры.Элемент = Элемент;
	
	// Проверить выбранную строку номенклатуры.
	Оповещение = Новый ОписаниеОповещения("ПодборТаблицаЛимитовВыборЗавершение", ЭтотОбъект, 
		ДополнительныеПараметры);
	ПриВыбореСтрокиТаблицыЛимита(ЭтаФорма, Оповещение);
	
КонецПроцедуры

// Параметры:
// 	ДополнительныеПараметры - см. ДополнительныеПараметрыОбработкиЗавершения
//
&НаКлиенте
Процедура ПодборТаблицаЛимитовВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СтрокаТаблицыЛимитов = ДополнительныеПараметры.Элемент.ТекущиеДанные;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыЛимита = ПолучитьПараметрыЛимитаПередДобавлениеВКорзину(ПараметрыФормы);
	
	ДобавитьВКорзину(ПараметрыЛимита, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборТаблицаЛимитовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ПараметрыПеретаскивания.ДопустимыеДействия = ДопустимыеДействияПеретаскивания.Копирование;
	
	ПолучитьДанныеПеретаскивания(ЭтаФорма, Элемент, ПараметрыПеретаскивания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКорзина

&НаКлиенте
Процедура КорзинаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	ПеретащитьВКорзинуНаСервере(ПараметрыПеретаскивания.Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаПроцентРучнойСкидкиПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаСуммаРучнойСкидкиПриИзменении(Элемент)
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаПриИзменении(Элемент)
	УстановитьТекстИнформационнойНадписи(ЭтаФорма);
	Элементы.Список.Обновить();
	
	//Обновление корзины
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("Корзина", Объект.Корзина);
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура КорзинаПередУдалением(Элемент, Отказ)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть(КодВозвратаДиалога.OK);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Подборы

&НаКлиенте
Процедура ДобавитьВКорзину(ПараметрыЛимита, ПараметрыФормы = Неопределено)
	
	Если Не ЗначениеЗаполнено(ПараметрыЛимита) Тогда
		Возврат;
	КонецЕсли;
	
	НовыеСтроки = Новый Массив;
	
	НоваяСтрока = СтруктураСтрокиЛимитов();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ПараметрыЛимита);
	
	НовыеСтроки.Добавить(НоваяСтрока);
	
	ДобавитьВКорзинуЗавершение(ПараметрыЛимита, НовыеСтроки);
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьВКорзинуНаКлиенте(ПараметрыТовара, НовыеСтроки)
	
	Отбор = Новый Структура("ВидБюджета, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ЦФО, Проект, ПериодЛимитирования, Валюта");
	
	Для Каждого НоваяСтрока Из НовыеСтроки Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, НоваяСтрока);
		
		РезультатПоиска = Объект.Корзина.НайтиСтроки(Отбор);
		
		Если РезультатПоиска.Количество() = 0 Тогда
			
			ТекущаяСтрока = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Отбор);
			
		Иначе
			ТекущаяСтрока = РезультатПоиска[0];
		КонецЕсли;
		
		Если ТекущаяСтрока.Сумма = НоваяСтрока.Свободно Тогда
			Объект.Корзина.Удалить(ТекущаяСтрока.НомерСтроки - 1); 
			Возврат "";
		Иначе	
			ТекущаяСтрока.Сумма = НоваяСтрока.Свободно;
		КонецЕсли;
		
		Если Не ПоказыватьПодобранныеЛимиты Тогда
			
			ТекстОповещения = Символы.ПС + НСтр("ru = 'Лимит по статье ""[СтатьяБюджета]"" на сумму [Сумма] [Валюта] добавлен в корзину'");
			
			ВставляемыеЗначения = Новый Структура("СтатьяБюджета, Сумма, Валюта");
			
			Аналитики = Новый Массив;
			Для Поз = 1 По АналитикиСтатейБюджетовУХКлиентСервер.КоличествоАналитикСтатьи() Цикл
				Аналитики.Добавить(Строка(НоваяСтрока["Аналитика"+Поз]));
			КонецЦикла;
			
			ВставляемыеЗначения.СтатьяБюджета      = Строка(ТекущаяСтрока.СтатьяБюджета) + " (" + СтрСоединить(Аналитики, ",") + ")";
			ВставляемыеЗначения.Сумма              = Формат(ТекущаяСтрока.Сумма, "ЧДЦ=2; ЧН=");
			ВставляемыеЗначения.Валюта             = Строка(ТекущаяСтрока.Валюта);
			
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстОповещения, ВставляемыеЗначения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если НовыеСтроки.Количество() > 0 Тогда
		Элементы.Корзина.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
	ТекстОповещения = "";
	
	Возврат ТекстОповещения;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьВКорзинуЗавершение(ПараметрыТовара, НовыеСтроки)
	
	ТекстОповещения = ДобавитьВКорзинуНаКлиенте(ПараметрыТовара, НовыеСтроки);
	
	Если Не ПоказыватьПодобранныеЛимиты Тогда
		ПоказатьОповещениеПользователя(НСтр("ru = 'Лимит добавлен в корзину'"), , ТекстОповещения);
	КонецЕсли;
	
	УстановитьТекстИнформационнойНадписи(ЭтаФорма);
	
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("Корзина", Объект.Корзина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыЛимитаПередДобавлениеВКорзину(ПараметрыФормы)
	
	ПараметрыЛимита = СтруктураСтрокиЛимитов();
	
	ЗаполнитьЗначенияСвойств(ПараметрыЛимита, ТекущаяСтрокаЛимита);
	
	Возврат ПараметрыЛимита;
	
КонецФункции

&НаСервере
Функция АдресТоваровВХранилище(УникальныйИдентификаторВладельца)
	
	АдресВХранилище = Неопределено;
	
	Если ПеренестиВДокумент Тогда
		
		Лимиты = Объект.Корзина.Выгрузить();
		АдресВХранилище = ПоместитьВоВременноеХранилище(Лимиты, УникальныйИдентификаторВладельца);
		
	КонецЕсли;
	
	Возврат АдресВХранилище;
	
КонецФункции

#КонецОбласти

#Область ПодборЛимитов

&НаКлиентенаСервереБезКонтекста
Процедура УстановитьТекстИнформационнойНадписи(Форма)
	
	Корзина = Форма.Объект.Корзина;
	Валюта = Форма.Объект.Валюта;
	
	ФорматнаяСтрока = НСтр("ru = 'Л = ru_RU; НП = Истина; НД = Ложь; ДП = Ложь';
							|en = 'Л = en_EN; НП = Истина; НД = Ложь; ДП = Ложь'");
	
	Сумма = Формат(Корзина.Итог("Сумма"), "ЧДЦ=2; ЧН=");
	Количество = НРег(ЧислоПрописью(Корзина.Количество(), ФорматнаяСтрока, НСтр("ru = 'позиция,позиции,позиций,ж,,,,,0';
																				|en = 'position,positions,,,0'")));
	
	ИнформационнаяНадпись = НСтр("ru = 'Всего подобрано [Количество], на сумму [Сумма] [Валюта] [СкрытьПоказать]';
								|en = '[Количество] positions are picked, to the amount of [Сумма] [Валюта] [СкрытьПоказать]'");
	
	СкрытьПоказать = "";
	
	СкрытьПоказать = ?(Форма.ПоказыватьКорзину, НСтр("ru = '(скрыть)';
													|en = '(hide)'"), НСтр("ru = '(показать)';
																			|en = '(show)'"));
	
	ВставляемыеЗначения = Новый Структура;
	ВставляемыеЗначения.Вставить("Количество",Количество);
	ВставляемыеЗначения.Вставить("Сумма",Сумма);
	ВставляемыеЗначения.Вставить("Валюта",Валюта);
	ВставляемыеЗначения.Вставить("СкрытьПоказать",СкрытьПоказать);
	
	ИнформационнаяНадпись = СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ИнформационнаяНадпись, ВставляемыеЗначения);
	
	Форма.ИнформационнаяНадпись = ИнформационнаяНадпись;
	
	Форма.Элементы.ОбластьПодобранныеЛимиты.Видимость = Форма.ПоказыватьКорзину;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриНажатииНаИнформационнуюНадпись(Форма, Объект)
	
	Форма.ПоказыватьКорзину = Не Форма.ПоказыватьКорзину;
	УстановитьТекстИнформационнойНадписи(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеПеретаскивания(Форма, Элемент, ПараметрыПеретаскивания)
	
	МассивПараметров = Новый Массив; 
	
	Для каждого КлючСтроки Из ПараметрыПеретаскивания.Значение Цикл
		
		ДанныеСтроки = Элемент.ДанныеСтроки(КлючСтроки);
		
		Если ДанныеСтроки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыЛимита = СтруктураСтрокиЛимитов();
		
		ЗаполнитьЗначенияСвойств(ПараметрыЛимита, ДанныеСтроки);
		
		МассивПараметров.Добавить(ПараметрыЛимита);
		
	КонецЦикла;
	
	ПараметрыПеретаскивания.Значение = МассивПараметров;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореСтрокиТаблицыЛимита(Форма, ОповещениеУспешногоВыбора)
	
	СтрокаТаблицыЛимитов = Форма.Элементы.Список.ТекущиеДанные;
	Если СтрокаТаблицыЛимитов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОповещениеУспешногоВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриАктивизацииСтрокиТаблицыЛимитов(Форма, Элемент)
	
	ТД = Элемент.ТекущиеДанные;
	
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ТекущаяСтрокаЛимита <> Неопределено Тогда
		Если ТД.Свойство("ГруппировкаСтроки") Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Форма.ТекущаяСтрокаЛимита = СтруктураСтрокиЛимитов();
	ЗаполнитьЗначенияСвойств(Форма.ТекущаяСтрокаЛимита, ТД);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СтруктураСтрокиЛимитов()
	
	СтруктураЛимита = Новый Структура;
	
	СтруктураЛимита.Вставить("ВидБюджета", ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыБюджетов.ПустаяСсылка"));
	СтруктураЛимита.Вставить("Предназначение", ПредопределенноеЗначение("Перечисление.ПредназначенияЭлементовСтруктурыОтчета.ПустаяСсылка"));
	СтруктураЛимита.Вставить("ПериодЛимитирования", ПредопределенноеЗначение("Справочник.Периоды.ПустаяСсылка"));
	СтруктураЛимита.Вставить("Валюта", КэшируемыеПроцедурыОПК.ПустаяВалюта());
	СтруктураЛимита.Вставить("ЦФО", КэшируемыеПроцедурыОПК.ПустойЦФО());
	СтруктураЛимита.Вставить("Проект", КэшируемыеПроцедурыОПК.ПустойПроект());
	СтруктураЛимита.Вставить("СтатьяБюджета", неопределено);
	СтруктураЛимита.Вставить("Аналитика1", неопределено);
	СтруктураЛимита.Вставить("Аналитика2", неопределено);
	СтруктураЛимита.Вставить("Аналитика3", неопределено);
	СтруктураЛимита.Вставить("Аналитика4", неопределено);
	СтруктураЛимита.Вставить("Аналитика5", неопределено);
	СтруктураЛимита.Вставить("Аналитика6", неопределено);
	
	СтруктураЛимита.Вставить("Свободно", 0);
	
	Возврат СтруктураЛимита;
	
КонецФункции

&НаСервере
Процедура ПеретащитьВКорзинуНаСервере(Данные)
	
	Для Каждого НоваяСтрока Из Данные Цикл
		
		Отбор = Новый Структура("ВидБюджета, СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ЦФО, Проект, ПериодЛимитирования, Валюта");
		ЗаполнитьЗначенияСвойств(Отбор, НоваяСтрока);
		
		РезультатПоиска = Объект.Корзина.НайтиСтроки(Отбор);
		Если РезультатПоиска.Количество() = 0 Тогда
			ТекущаяСтрока = Объект.Корзина.Добавить();
			ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Отбор);
		Иначе
			ТекущаяСтрока = РезультатПоиска[0];
		КонецЕсли;
		
		Если ТекущаяСтрока.Сумма < НоваяСтрока.Свободно Тогда
			ТекущаяСтрока.Сумма = НоваяСтрока.Свободно;
		Иначе
			ТекущаяСтрока.Сумма = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемФормыПодбораЛимитов(Форма, Объект, Отказ)
	
	Если Форма.ПеренестиВДокумент ИЛИ Форма.ВыполняетсяЗакрытие Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Корзина.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПередЗакрытиемФормыПодбораЛимитовЗавершение", ЭтотОбъект, 
			Новый Структура("Форма", Форма)), 
		НСтр("ru = 'Подобранные лимиты не перенесены в документ. Перенести?'"), 
		РежимДиалогаВопрос.ДаНетОтмена);
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемФормыПодбораЛимитовЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Форма.ПеренестиВДокумент = Истина;
		Форма.ВыполняетсяЗакрытие = Истина;
		Форма.Закрыть(КодВозвратаДиалога.OK);
		Форма.ВыполняетсяЗакрытие = Ложь;
		Возврат;
	КонецЕсли;
	
	Форма.ВыполняетсяЗакрытие = Истина;
	Форма.Закрыть();
	Форма.ВыполняетсяЗакрытие = Ложь;

КонецПроцедуры

#КонецОбласти 

&НаСервереБезКонтекста
Функция ПолучитьПараметрыЛимитирования(ВидБюджета, ПериодЛимитированияНачало)
	
	Результат = Новый Структура("ВидБюджета, Периодичность", 
		ВидБюджета, Перечисления.Периодичность.ПустаяСсылка());
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидБюджета", ВидБюджета);
	Запрос.УстановитьПараметр("НаДату", ПериодЛимитированияНачало);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыЛимитированияСрезПоследних.ВидБюджета КАК ВидБюджета,
	|	ПараметрыЛимитированияСрезПоследних.ВидБюджета.Предназначение КАК Предназначение,
	|	ПараметрыЛимитированияСрезПоследних.ПериодичностьЛимитирования КАК Периодичность
	|ИЗ
	|	РегистрСведений.ПараметрыЛимитирования.СрезПоследних(&НаДату, ВидБюджета = &ВидБюджета) КАК ПараметрыЛимитированияСрезПоследних";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Результат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Результат, Выборка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция ДополнительныеПараметрыОбработкиЗавершения()
	
	Результат = Новый Структура;
	Результат.Вставить("Элемент");
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Корзина = Настройки.ДополнительныеСвойства.Корзина.Выгрузить();
	
	СтруктураПоиска = Новый Структура("СтатьяБюджета, Аналитика1, Аналитика2, Аналитика3, Аналитика4, Аналитика5, Аналитика6, ЦФО, Проект, ПериодЛимитирования");
	Для Каждого Строка Из Строки Цикл
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Строка.Значение.Данные);
		Данные = Корзина.НайтиСтроки(СтруктураПоиска);
		Если Данные.Количество() = 0 Тогда
			Строка.Значение.Данные.ВКорзине = 0;
		Иначе
			Строка.Значение.Данные.ВКорзине = Данные[0].Сумма;
		КонецЕсли;
		
		Строка.Значение.Данные.Остаток = Строка.Значение.Данные.Свободно - Строка.Значение.Данные.ВКорзине;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоляБыстрогоОтбора()
	
	//  ПараметрыВыбора для периода лимитирования
	Элемент = Элементы.КомпоновщикНастроекПользовательскиеНастройкиЭлемент2Значение;
	
	ПараметрыВыбора = Новый Массив();
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Произвольный", Ложь));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.Периодичность", Периодичность));
	ПараметрыВыбора.Добавить(Новый ПараметрВыбора("Отбор.ТолькоПериодыГода", ПериодЛимитированияНачало));
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	
	//  ПараметрыВыбора для статьи бюджета
	Элемент = Элементы.КомпоновщикНастроекПользовательскиеНастройкиЭлемент3Значение;
	Массив = Новый Массив(); 
	Если Объект.ВидБюджета = ПланыВидовХарактеристик.ВидыБюджетов.БюджетДвиженияДенежныхСредств Тогда
		Массив.Добавить(Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств")); 
	ИначеЕсли Объект.ВидБюджета = ПланыВидовХарактеристик.ВидыБюджетов.БюджетДоходовИРасходов Тогда
		Массив.Добавить(Тип("СправочникСсылка.СтатьиДоходовИРасходов")); 
	Иначе
		Массив.Добавить(Тип("СправочникСсылка.СтатьиДвиженияРесурсов")); 
	КонецЕсли;	
	Описание = Новый ОписаниеТипов(Массив);
	
	Элемент.ОграничениеТипа = Описание;
	Элемент.КнопкаВыбора = Истина;
	Элемент.КнопкаСпискаВыбора = Истина;
	Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВВыпадающемСпискеИВПолеВвода;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Подстановка наименования периода для колонки Период
	Элемент = УсловноеОформление.Элементы.Добавить();
	//КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ТаблицаКонтроляРезультат.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПериод.Имя);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"Список.ПериодЛимитирования", ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("Список.ПериодЛимитирования"));
	
	// Выделить включенные в корзину лимиты
	Элемент = УсловноеОформление.Элементы.Добавить();
	//КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.ТаблицаКонтроляРезультат.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПериод.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокЦФО.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПроект.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатьяБюджета.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика1.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика2.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика3.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика4.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика5.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокАналитика6.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВалюта.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСвободно.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокВКорзине.Имя);
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокОстаток.Имя);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Элемент.Отбор,
		"Список.ВКорзине", ВидСравненияКомпоновкиДанных.Заполнено);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,Истина));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКорзину(Данные)
	
	ТМП = Параметры.Корзина.Выгрузить();
	
	ИмяКолонки = "ВидБюджета";
	Если ТМП.Колонки.Найти(ИмяКолонки) = неопределено Тогда
		ТМП.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыБюджетов"));
		ТМП.ЗаполнитьЗначения(Объект.ВидБюджета, ИмяКолонки);
	КонецЕсли;
	
	ИмяКолонки = "Валюта";
	Если ТМП.Колонки.Найти(ИмяКолонки) = неопределено Тогда
		ТМП.Колонки.Добавить(ИмяКолонки, Новый ОписаниеТипов("СправочникСсылка.Валюты"));
		ТМП.ЗаполнитьЗначения(Объект.Валюта, ИмяКолонки);
	КонецЕсли;
	
	Объект.Корзина.Загрузить(ТМП);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
