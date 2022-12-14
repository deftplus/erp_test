
&НаСервере
Процедура ОбработкаИзмененияУниверсальногоОтчета()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	
	СтруктураНастроек = ТиповыеОтчетыУХ.ПолучитьСтруктуруПараметровТиповогоОтчета(ТекОбъект.УниверсальныйОтчет);
	СтруктураНастроек.Вставить("ФормироватьПриОткрытии", Ложь);
	СКД = ПолучитьИзВременногоХранилища(ТиповыеОтчетыУХ.СформироватьСхемуКомпоновкиДанных(ТекОбъект.УниверсальныйОтчет, Неопределено));

	НастройкиОтчета = Новый ХранилищеЗначения(СтруктураНастроек);
	КомпоновщикНастроек = ТиповыеОтчетыУХ.ПолучитьКомопновщикПоСхемеИНастройкам(СКД, СтруктураНастроек.НастройкиКомпоновщика);
	
	Отбор = Новый Структура;
	
	Для Каждого ДоступныйОтбор Из КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.Элементы Цикл
		Если НЕ ДоступныйОтбор.Папка Тогда
			
			Отбор.Вставить(Строка(ДоступныйОтбор.Поле), Ложь);
			
		КонецЕсли;
	КонецЦикла;
	
	ТекОбъект.Отбор = Новый ХранилищеЗначения(Отбор);
	ОтборТЗ = Новый ХранилищеЗначения(Отбор);
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = Объект.УниверсальныйОтчет.Наименование;
	КонецЕсли;
	
	ОбновитьКартинкуОтчета();
	ЗаполнитьСписокДоступныхНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура УниверсальныйОтчетПриИзменении(Элемент)
	
	ОбработкаИзмененияУниверсальногоОтчета();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКартинкуОтчета()
	
	Если Объект.УниверсальныйОтчет.ВидПроизвольногоОтчета = 1 Тогда
		Элементы.Декорация_Отчет.Картинка = БиблиотекаКартинок.Монитор_Пример;
	ИначеЕсли Объект.УниверсальныйОтчет.ПредставлениеЭлементаОтчета = Перечисления.ПредставленияЭлементовОтчетов.Диаграмма Тогда
		Элементы.Декорация_Отчет.Картинка = БиблиотекаКартинок.Диаграмма_Пример;
	Иначе
		Элементы.Декорация_Отчет.Картинка = БиблиотекаКартинок.Отчет_Пример;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьКартинкуОтчета();
	ЗаполнитьСписокДоступныхНастроек();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхНастроек()
	
	Элементы.СохраненнаяНастройка.СписокВыбора.Очистить();
	Элементы.СохраненнаяНастройка.СписокВыбора.Добавить(Справочники.СохраненныеНастройки.ПустаяСсылка(), Нстр("ru = '(По умолчанию)'"));
	ТекущиеОтчеты = ТиповыеОтчетыУХ.ПолучитьТаблицуДоступныхВариантов(Объект.УниверсальныйОтчет, Перечисления.ТипыНастроек.НастройкиОтчета, ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь"));
	
	Для Каждого Элемент Из ТекущиеОтчеты Цикл
		
		Элементы.СохраненнаяНастройка.СписокВыбора.Добавить(Элемент.Ссылка, Элемент.Наименование);
		
	КонецЦикла;
	
КонецПроцедуры
