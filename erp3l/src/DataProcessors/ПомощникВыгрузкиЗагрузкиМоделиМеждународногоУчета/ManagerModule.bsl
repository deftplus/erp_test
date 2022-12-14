#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет загрузку модели международного учета из файла
//
// Параметры:
// 	Параметры - Структура - Содержит адрес данных для загрузки:
// 	 * ДвоичныеДанные - ДвоичныеДанные - 
// 	АдресХранилища - Строка - Адрес во временном хранилище для помещения результата.
//
Процедура ЗагрузитьМодельУчета(Параметры, АдресХранилища) Экспорт
	
	Обработка = Обработки.УниверсальныйОбменДаннымиXML.Создать();	
	
	ИмяВременногоФайлаДанных = ПолучитьИмяВременногоФайла("xml");
	Параметры.ДвоичныеДанные.Записать(ИмяВременногоФайлаДанных);
	
	Обработка.ИмяФайлаОбмена                        = ИмяВременногоФайлаДанных;
	Обработка.РежимОбмена                           = "Загрузка";
	Обработка.ЗапоминатьЗагруженныеОбъекты          = Ложь;
	Обработка.ВыводВПротоколСообщенийОбОшибках      = Истина;
	
	ИмяВременногоФайлаПротоколаОбмена = ПолучитьИмяВременногоФайла("txt");
	Обработка.ВыводВПротоколИнформационныхСообщений = Ложь;
	Обработка.ИмяФайлаПротоколаОбмена               = ИмяВременногоФайлаПротоколаОбмена;
	
	Обработка.ЗагружатьДанныеВРежимеОбмена               			= Истина;
	Обработка.ОбъектыПоСсылкеЗагружатьБезПометкиУдаления 			= Истина;
	Обработка.ОптимизированнаяЗаписьОбъектов             			= Истина;
	Обработка.ЗапоминатьЗагруженныеОбъекты               			= Истина;
	Обработка.НеВыводитьНикакихИнформационныхСообщенийПользователю	= Истина;
	Обработка.ВыводВОкноСообщенийИнформационныхСообщений 			= Ложь;

	УстановитьПривилегированныйРежим(Истина);
	Обработка.ВыполнитьЗагрузку();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПротоколОбмена = Новый ТекстовыйДокумент;
	ПротоколОбмена.Прочитать(ИмяВременногоФайлаПротоколаОбмена);
	
	УдалитьФайлы(ИмяВременногоФайлаПротоколаОбмена);
	УдалитьФайлы(ИмяВременногоФайлаДанных);
	
	Результат = Новый Структура("ЗагрузкаВыполнена", НЕ Обработка.ФлагОшибки);
	Результат.Вставить("ПротоколОбмена", ПротоколОбмена.ПолучитьТекст());
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
КонецПроцедуры

// Выполняет выгрузку модели международного учета в файла
//
// Параметры:
// 	Параметры - Структура - Пустая структура. Для совместимости с механизмом выполнения длительных операций
// 	АдресХранилища - Строка - Адрес во временном хранилище для помещения результата.
//
Процедура ВыгрузитьМодельУчета(Параметры, АдресХранилища) Экспорт
	
	Обработка = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	
	ИмяВременногоФайлаПравилОбмена = ПолучитьИмяВременногоФайла("xml");
	ИмяМакета = НастройкиСистемы.ИмяПравилОбменаПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета();
	
	ЕстьПравила = Метаданные.Обработки.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.Макеты.Найти(ИмяМакета) <> Неопределено;
	Если Не ЕстьПравила Тогда
		Результат = Новый Структура("ЗагрузкаВыполнена", Ложь);
		Результат.Вставить("ФайлВыгрузки", Неопределено);
		ШаблонОшибки = НСтр("ru = 'Отсутствует макет правил обмена: %1';
							|en = 'Missing exchange rules template: %1'");
		ТекстОшибки = СтрШаблон(
					ШаблонОшибки, "Обработки.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.Макеты." + ИмяМакета);
		Результат.Вставить("ПротоколОбмена", ТекстОшибки);
		ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
		Возврат;
	КонецЕсли;
	
	МакетПравилОбмена = Обработки.ПомощникВыгрузкиЗагрузкиМоделиМеждународногоУчета.ПолучитьМакет(ИмяМакета);
	МакетПравилОбмена.Записать(ИмяВременногоФайлаПравилОбмена);
	
	Обработка.ИмяФайлаПравилОбмена = ИмяВременногоФайлаПравилОбмена;
	Обработка.ЗагрузитьПравилаОбмена();
	
	ИмяВременногоФайлаПротоколаОбмена = ПолучитьИмяВременногоФайла("txt");
	Обработка.ВыводВПротоколИнформационныхСообщений = Ложь;
	Обработка.ИмяФайлаПротоколаОбмена               = ИмяВременногоФайлаПротоколаОбмена;
	
	ИмяФайлаВыгрузки = ПолучитьИмяВременногоФайла("xml");
	Обработка.ИмяФайлаОбмена = ИмяФайлаВыгрузки;
	Обработка.РежимОбмена    = "Выгрузка";
	Обработка.НеВыводитьНикакихИнформационныхСообщенийПользователю = Истина;
	
	УстановитьПривилегированныйРежим(Истина);
	Обработка.ВыполнитьВыгрузку();
	УстановитьПривилегированныйРежим(Ложь);
	
	ПротоколОбмена = Новый ТекстовыйДокумент;
	ПротоколОбмена.Прочитать(ИмяВременногоФайлаПротоколаОбмена);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаВыгрузки);
	
	Результат = Новый Структура("ЗагрузкаВыполнена", НЕ Обработка.ФлагОшибки);
	Результат.Вставить("ФайлВыгрузки", ДвоичныеДанные);
	Результат.Вставить("ПротоколОбмена", ПротоколОбмена.ПолучитьТекст());
	ПоместитьВоВременноеХранилище(Результат, АдресХранилища);
	
	УдалитьФайлы(ИмяВременногоФайлаПротоколаОбмена);
	УдалитьФайлы(ИмяВременногоФайлаПравилОбмена);
	УдалитьФайлы(ИмяФайлаВыгрузки);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли