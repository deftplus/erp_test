
&НаСервере
Функция ПолучитьРеквизитПоТипуСубконто(ВидАналитики)
	
	ТипЗначения = ВидАналитики.ТипЗначения;
	ТаблицаОпределенныхРеквизитов = ВидАналитики.РеквизитыДляСинхронизации.Выгрузить();
	
	ТабличноеПолеРеквизиты = Новый ТаблицаЗначений;
	
	ТабличноеПолеРеквизиты.Колонки.Добавить("ИмяРеквизита");
	ТабличноеПолеРеквизиты.Колонки.Добавить("ПредставлениеРеквизита");
	ТабличноеПолеРеквизиты.Колонки.Добавить("Ключ");
	ТабличноеПолеРеквизиты.Колонки.Добавить("Макет");
	
	Если Документы.ТипВсеСсылки().СодержитТип(ТипЗначения.Типы()[0]) Тогда
		ТипМетаДанных="Документ";
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(ТипЗначения.Типы()[0]) Тогда
		ТипМетаДанных="Перечисление";
	Иначе
		ТипМетаДанных="Справочник";
	КонецЕсли;
	
	Если ТипМетаДанных="Справочник" Тогда
		
		МетаДанныеСправочник = Метаданные.НайтиПоТипу(ТипЗначения.Типы()[0]);
		
		Если МетаДанныеСправочник = Неопределено Тогда
			
			Возврат ТабличноеПолеРеквизиты;
			
		КонецЕсли;
		
		Если МетаданныеСправочник.ДлинаНаименования>0 Тогда	
			
			СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
			СтрокаТаблицы.ИмяРеквизита           = "Наименование";
			СтрокаТаблицы.ПредставлениеРеквизита = "Наименование";
			
			НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти("Наименование", "ИмяРеквизита");
			Если НайденнаяСтрока <> Неопределено Тогда
				СтрокаТаблицы.Макет = Истина;
				СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
			КонецЕсли;
			
		КонецЕсли;
		
		Если МетаданныеСправочник.ДлинаКода>0 Тогда	
			
			СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
			СтрокаТаблицы.ИмяРеквизита           = "Код";
			СтрокаТаблицы.ПредставлениеРеквизита = "Код";
			
			НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти("Код", "ИмяРеквизита");
			Если НайденнаяСтрока <> Неопределено Тогда
				СтрокаТаблицы.Макет = Истина;
				СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
			КонецЕсли;
			
		КонецЕсли;

		
		Для Каждого Реквизит Из МетаДанныеСправочник.Реквизиты Цикл
			
			Если ОбщегоНазначенияУХ.ПроверитьНаПримитивныйТипКонсолидация(Реквизит) Тогда
				
				СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
				СтрокаТаблицы.ИмяРеквизита           = Реквизит.Имя;
				СтрокаТаблицы.ПредставлениеРеквизита = Реквизит.Представление();
				НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти(Реквизит.Имя, "ИмяРеквизита");
				
				Если НайденнаяСтрока <> Неопределено Тогда
					СтрокаТаблицы.Макет = Истина;
					СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
				КонецЕсли;

			КонецЕсли;
			
		КонецЦикла;
				
	ИначеЕсли ТипМетаДанных="Документ" Тогда
		
		МетаДанныеДокумент = Метаданные.НайтиПоТипу(ТипЗначения.Типы()[0]);
		
		Если МетаДанныеДокумент=Неопределено Тогда
			
			Возврат ТабличноеПолеРеквизиты;
			
		КонецЕсли;
		
		СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
		СтрокаТаблицы.ИмяРеквизита           = "Номер";
		СтрокаТаблицы.ПредставлениеРеквизита = "Номер";
		
		НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти("Номер", "ИмяРеквизита");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаТаблицы.Макет = Истина;
			СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
		КонецЕсли;

		СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
		СтрокаТаблицы.ИмяРеквизита           = "Дата";
		СтрокаТаблицы.ПредставлениеРеквизита = "Дата";
		
		НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти("Дата", "ИмяРеквизита");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаТаблицы.Макет = Истина;
			СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
		КонецЕсли;

		Для Каждого Реквизит Из МетаДанныеДокумент.Реквизиты Цикл
			
			Если ОбщегоНазначенияУХ.ПроверитьНаПримитивныйТипКонсолидация(Реквизит) Тогда
				
				СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
				СтрокаТаблицы.ИмяРеквизита           = Реквизит.Имя;
				СтрокаТаблицы.ПредставлениеРеквизита = Реквизит.Представление();
				НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти(Реквизит.Имя, "ИмяРеквизита");
				Если НайденнаяСтрока <> Неопределено Тогда
					СтрокаТаблицы.Макет = Истина;
					СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
				КонецЕсли;

				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ТипМетаДанных="Перечисление" Тогда
		
		СтрокаТаблицы = ТабличноеПолеРеквизиты.Добавить();
		СтрокаТаблицы.ИмяРеквизита           = "Наименование";
		СтрокаТаблицы.ПредставлениеРеквизита = "Наименование";
		
		НайденнаяСтрока = ТаблицаОпределенныхРеквизитов.Найти("Наименование", "ИмяРеквизита");
		Если НайденнаяСтрока <> Неопределено Тогда
			СтрокаТаблицы.Макет = Истина;
			СтрокаТаблицы.Ключ  = НайденнаяСтрока.Ключ;
		КонецЕсли;

	КонецЕсли;
	
	Возврат ТабличноеПолеРеквизиты;
	
КонецФункции

&НаСервере
Процедура ОбработатьИзменениеАналитики(ВидАналитики)
	
	Если ВидАналитики <> ПрошлыйВидАналитики Тогда
		
		Если НЕ ПрошлыйВидАналитики.Пустая() Тогда
			
			Если НЕ ПустаяСтрока(АдресСоответствия) Тогда
				
				Соответствие = ПолучитьИзВременногоХранилища(АдресСоответствия);
				Если ТипЗнч(Соответствие) <> Тип("Соответствие") Тогда
					Соответствие = Новый Соответствие;
				КонецЕсли;
				
			Иначе
				Соответствие = Новый Соответствие;
			КонецЕсли;
			
			Соответствие.Вставить(ПрошлыйВидАналитики, РеквизитФормыВЗначение("ТаблицаНастроек"));
			
			Если НЕ ПустаяСтрока(АдресСоответствия) Тогда
				УдалитьИзВременногоХранилища(АдресСоответствия);
			КонецЕсли;
			
			АдресСоответствия = ПоместитьВоВременноеХранилище(Соответствие, УникальныйИдентификатор);
			
		КонецЕсли;
		
		ПрошлыйВидАналитики = ВидАналитики;
		ЗаполнитьТаблицуНастроек(ВидАналитики);
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНастроек(ВидАналитики)
	
	Если НЕ ПустаяСтрока(АдресСоответствия) Тогда
		Соответствие = ПолучитьИзВременногоХранилища(АдресСоответствия);
		
		Если ТипЗнч(Соответствие) <> Тип("Соответствие") Тогда
			Соответствие = Новый Соответствие;
		КонецЕсли;
	Иначе
		
		Соответствие = Новый Соответствие;
		
	КонецЕсли;
	
	Если Соответствие[ВидАналитики] <> Неопределено Тогда
		ЗначениеВРеквизитФормы(Соответствие[ВидАналитики], "ТаблицаНастроек");
	Иначе
		ЗначениеВРеквизитФормы(ПолучитьРеквизитПоТипуСубконто(ВидАналитики), "ТаблицаНастроек");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокАналитикПриАктивизацииСтроки(Элемент)
	
	ВидАналитики = Элементы.СписокАналитик.ТекущаяСтрока;
	Если ВидАналитики <> Неопределено Тогда
		ОбработатьИзменениеАналитики(ВидАналитики);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастроекКлючПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаНастроек.ДанныеСтроки(Элементы.ТаблицаНастроек.ТекущаяСтрока);
	
	Если ТекущаяСтрока.Ключ Тогда
		ТекущаяСтрока.Макет = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	СохранитьИзмененияНастроек();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияНастроек()
	
	Если НЕ ПустаяСтрока(АдресСоответствия) Тогда
		
		Соответствие = ПолучитьИзВременногоХранилища(АдресСоответствия);
		
		Для Каждого Элемент Из Соответствие Цикл
			
			Если Элемент.Ключ = ПрошлыйВидАналитики Тогда
				Продолжить;
			КонецЕсли;
			
			ТекОбъект = Элемент.Ключ.ПолучитьОбъект();
			ТекОбъект.РеквизитыДляСинхронизации.Очистить();
			НайденныеСтроки = Элемент.Значение.НайтиСтроки(Новый Структура("Макет", Истина));
			
			Для Каждого Строка Из НайденныеСтроки Цикл
				ЗаполнитьЗначенияСвойств(ТекОбъект.РеквизитыДляСинхронизации.Добавить(), Строка);
			КонецЦикла;
			
		КонецЦикла;
		
		Попытка
			ТекОбъект.Записать();
		Исключение
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			СообщениеПользователю.Сообщить();
		КонецПопытки;
		
	КонецЕсли;
	
	Если НЕ ПрошлыйВидАналитики.Пустая() Тогда
		
		ТекОбъект = ПрошлыйВидАналитики.ПолучитьОбъект();
		ТекОбъект.РеквизитыДляСинхронизации.Очистить();
		
		НайденныеСтроки = ТаблицаНастроек.НайтиСтроки(Новый Структура("Макет", Истина));
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			ЗаполнитьЗначенияСвойств(ТекОбъект.РеквизитыДляСинхронизации.Добавить(), Строка);
		КонецЦикла;
				
		Попытка
			ТекОбъект.Записать();
		Исключение
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			СообщениеПользователю.Сообщить();
		КонецПопытки;
		
		
	КонецЕсли;
	
КонецПроцедуры