
#Область ПрограммныйИнтерфейс

// Получает схему данных объекта в виде строки.
// 
// Параметры:
//  ИмяОбъекта - Строка - полное имя объекта метаданных.
//  ИсключаемыеПоля - Структура - структура исключаемых из схемы полей.
// 
// Возвращаемое значение:
//  Строка - схема данных объекта в виде строки.
//
Функция ПолучитьСхемуДанныхОбъектаВВидеСтроки(ИмяОбъекта, ИсключаемыеПоля = Неопределено) Экспорт
	
	СхемаОбъект = ПолучитьБазовуюСхемуДанных(ИмяОбъекта);
	
	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ИмяОбъекта);
	РеквизитыИСвойстваОбъекта = РеквизитыИСвойстваОбъектаМетаданных(МетаданныеОбъекта, ИсключаемыеПоля);
	ПространствоИменОбъекта = ПространствоИменПоИмениОбъекта(ИмяОбъекта);
	
	ДобавитьОбъектМетаданныхВСхему(СхемаОбъект, 
		ПространствоИменОбъекта, МетаданныеОбъекта, РеквизитыИСвойстваОбъекта);
	
	СписокСвязанныхЭлементов = Новый СписокЗначений; // для сортировки
	Для Каждого СвязанныйОбъект Из РеквизитыИСвойстваОбъекта.СвязанныеОбъекты Цикл
		СписокСвязанныхЭлементов.Добавить(СвязанныйОбъект.Ключ);
	КонецЦикла;
	
	СписокСвязанныхЭлементов.СортироватьПоЗначению();
	Для Каждого ЭлементСписка Из СписокСвязанныхЭлементов Цикл
		
		ИмяОбъектаМетаданных = ЭлементСписка.Значение;
		СвязанныйОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
		Если СвязанныйОбъектМетаданных = РеквизитыИСвойстваОбъекта.МетаданныеОбъекта Тогда
			Продолжить;
		КонецЕсли;
		
		СвязанныеОбъекты = РеквизитыИСвойстваОбъекта.СвязанныеОбъекты.Получить(ИмяОбъектаМетаданных); 
		
		ДобавитьОбъектМетаданныхВСхему(СхемаОбъект, 
			ПространствоИменОбъекта, СвязанныйОбъектМетаданных, СвязанныеОбъекты);
			
	КонецЦикла;
	
	Тип = СоздатьСоставнойТип("Сообщение");
	СхемаОбъект.Содержимое.Добавить(Тип); 
	Фрагменты = Тип.Содержимое.Часть.Фрагменты;
	ПолноеИмяОбъекта = РеквизитыИСвойстваОбъекта.МетаданныеОбъекта.ПолноеИмя(); 
	
	Элемент = СоздатьЭлементСхемы("СтрокаСообщения", ПространствоИменОбъекта, ПолноеИмяОбъекта);
	ДобавитьЭлементВСхему(Фрагменты, Элемент, Ложь);
	
	Элемент = СоздатьЭлементСхемы("СвойстваСообщения", ПространствоИменОбъекта, "СвойстваСообщения");
	ДобавитьЭлементВСхему(Фрагменты, Элемент, Ложь);
	
	Если РеквизитыИСвойстваОбъекта.Свойство("Отбор") Тогда
		
		ПолноеИмяОтбора = СтрШаблон("%1.Отбор", РеквизитыИСвойстваОбъекта.МетаданныеОбъекта.ПолноеИмя());
		ДлинаСтроки = 4;
		ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаСтроки));
		
		Элемент = СоздатьЭлементСхемы("Отбор", ПространствоИменОбъекта, ПолноеИмяОтбора, ОписаниеТипаСтрока);
		Фрагменты.Добавить(Элемент);
		
		Тип = СоздатьСоставнойТип(ПолноеИмяОтбора);
		СхемаОбъект.Содержимое.Добавить(Тип); 
		Фрагменты = Тип.Содержимое.Часть.Фрагменты;
		
		РеквизитыИСвойстваОбъекта.Отбор.Сортировать("ИмяСвойстваXDTO");

		Для Каждого ЭлементОтбора Из РеквизитыИСвойстваОбъекта.Отбор Цикл
			
			Если ЭлементОтбора.ПримитивныйТип Тогда
				ПространствоИменЭлемента = ПространствоИменXS();
			Иначе
				ПространствоИменЭлемента = ПространствоИменОбъекта;
			КонецЕсли;
			 
			Элемент = СоздатьЭлементСхемы(ЭлементОтбора.ИмяРеквизита, 
						ПространствоИменЭлемента, ЭлементОтбора.ТипСтрокой, ЭлементОтбора.ОписаниеТипов1С);
			
			ДобавитьЭлементВСхему(Фрагменты, Элемент);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Тип = СоздатьЭлементСхемы("Сообщение", ПространствоИменПоИмениОбъекта(ИмяОбъекта), "Сообщение");
	СхемаОбъект.Содержимое.Добавить(Тип);
	
	СхемаОбъект.ОбновитьЭлементDOM();
	
	// Преобразование схемы в строку.
	ЗаписьDOM = Новый ЗаписьDOM;
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписьDOM.Записать(СхемаОбъект.ДокументDOM, ЗаписьXML);
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции

// Возвращает пространство имен по имени объекта.
// 
// Параметры:
//  ИмяОбъекта - Строка - полное имя объекта метаданных.
// 
// Возвращаемое значение:
// 	Строка - пространство имен объекта.
// 
Функция ПространствоИменПоИмениОбъекта(ИмяОбъекта) Экспорт
	
	Префикс = ПрефиксПространстваИмен();
	ИмяВерсии = ИмяВерсииКонфигурации(ИмяОбъекта);
	
	Возврат СтрШаблон("%1%2%3", Префикс, ИмяВерсии, ИмяОбъекта);
	
КонецФункции

// Возвращает имя объекта метаданных по пространству имен.
// 
// Параметры:
//  ПространствоИмен - Строка - пространство имен объекта метаданных.
// 
// Возвращаемое значение:
//  Строка - имя объекта метаданных
// 
Функция ИмяОбъектаПоПространствуИмен(ПространствоИмен) Экспорт
	
	// Удаляем префикс, общий для всех конфигураций.
	ПространствоИменБезПрефикса = СтрЗаменить(ПространствоИмен, ПрефиксПространстваИмен(), "");
	
	// Имя объекта - последняя строка.
	МассивСтрок = СтрРазделить(ПространствоИменБезПрефикса, "/");
	
	Возврат МассивСтрок[МассивСтрок.ВГраница()];
	
КонецФункции

// Новая структура реквизитов и свойств переданного объекта метаданных.
// 
// Параметры:
//  МетаданныеОбъекта - ОбъектМетаданных - метаданные объекта.
// 
// Возвращаемое значение:
//  Структура - Новая структура реквизитов и свойств:
// 		* МетаданныеОбъекта - ОбъектМетаданных - метаданные объекта.
// 		* ПолноеИмяОбъекта - Строка - полное имя объекта метаданных.
// 		* Реквизиты - ТаблицаЗначений - таблица реквизитов объекта.
// 		* Свойства - Структура - свойства объекта метаданных.
// 
Функция НоваяСтруктураРеквизитовИСвойств(МетаданныеОбъекта) Экспорт
	
	РеквизитыИСвойства = Новый Структура;
	Свойства = Новый Структура;
	ПолноеИмяОбъекта = МетаданныеОбъекта.ПолноеИмя();
	
	РеквизитыИСвойства.Вставить("МетаданныеОбъекта", МетаданныеОбъекта);
	РеквизитыИСвойства.Вставить("ПолноеИмяОбъекта", ПолноеИмяОбъекта);
	РеквизитыИСвойства.Вставить("Реквизиты", НоваяТаблицаРеквизитов());
	
	Если СП_ОбменДанными.ЭтоРегистр(ПолноеИмяОбъекта) Тогда
		Свойства.Вставить("СтандартныеРеквизиты");
		Свойства.Вставить("Измерения");
		Свойства.Вставить("Ресурсы");
		Свойства.Вставить("Отбор");
		
	ИначеЕсли Метаданные.Перечисления.Содержит(МетаданныеОбъекта) Тогда
		РеквизитыИСвойства.Вставить("ЗначенияПеречисления", Новый Массив);
		
		Свойства.Вставить("ЭтоСсылка", Истина);
		
	Иначе
		РеквизитыИСвойства.Вставить("ТабличныеЧасти", Новый Структура);
		
		Свойства.Вставить("СтандартныеРеквизиты");
		Свойства.Вставить("Реквизиты");
		Свойства.Вставить("ТаблицаКлючей");
		Свойства.Вставить("Идентификатор");
		Свойства.Вставить("ЭтоСсылка", Истина);
		
		Если Метаданные.Задачи.Содержит(МетаданныеОбъекта) Тогда
			Свойства.Вставить("РеквизитыАдресации");
		КонецЕсли;
		
	КонецЕсли;
	
	РеквизитыИСвойства.Вставить("Свойства", Свойства);
	
	Возврат РеквизитыИСвойства;
	
КонецФункции

// Выполняет проверку включения подсистемы Kafka-Connector.
// 
// Возвращаемое значение:
//  Булево - подсистема включена.
//  
Функция ПодсистемаВключена() Экспорт
	
	Возврат Константы.СП_ИспользоватьКафкаКоннектор.Получить();
	
КонецФункции

// Получает схему данных по пространству имен.
// 
// Параметры:
//  ПространствоИмен - Строка - пространство имен объекта обмена.
// 
// Возвращаемое значение:
//  Неопределено, СправочникСсылка - схема данных объекта обмена.
//  
Функция ПолучитьСхемуДанныхПоПространствуИмен(ПространствоИмен) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПространствоИмен", ПространствоИмен);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СП_СхемыДанных.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СП_СхемыДанных КАК СП_СхемыДанных
	|ГДЕ
	|	СП_СхемыДанных.Наименование = &ПространствоИмен";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
		
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.Ссылка;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПространствоИменXS()
	
	Возврат "http://www.w3.org/2001/XMLSchema";
	     
КонецФункции

Функция ПрефиксПространстваИмен()
	
	Возврат "https://silverbulleters.org/kafcon/";
	
КонецФункции

Функция ИмяВерсииКонфигурации(ИмяОбъекта)
	
	Если ИмяОбъекта = "Справочник.СП_СхемыДанных" Тогда
		ИмяВерсии = "";
		
	Иначе
		ИмяВерсии = СтрШаблон("%1/", СокрЛП(Метаданные.Имя));
		
	КонецЕсли;
	
	Возврат ИмяВерсии;
	
КонецФункции

Функция ПолучитьБазовуюСхемуДанных(ИмяОбъекта)
	
	// Определение необходимых параметров.
	ПространствоИменОбъекта = ПространствоИменПоИмениОбъекта(ИмяОбъекта);
	ПространствоИменXS = ПространствоИменXS();
	
	ТипСтрока36 = ОписаниеТипаИзСтроки("Строка(36)");
	ТипСтрока100 = ОписаниеТипаИзСтроки("Строка(100)");
	ТипСтрока200 = ОписаниеТипаИзСтроки("Строка(200)");
	ТипСтрока256 = ОписаниеТипаИзСтроки("Строка(256)");
	
	// Построение схемы данных в виде строки.
	Параметр1 = СтрШаблон("xmlns:tns=""%1""", ПространствоИменОбъекта);
	Параметр2 = СтрШаблон("xmlns:xs=""%1""", ПространствоИменXS);
	Параметр3 = СтрШаблон("targetNamespace=""%1""", ПространствоИменОбъекта);
	Параметр4 = "attributeFormDefault=""unqualified"" elementFormDefault=""qualified""";
	
	ШаблонСхемы = 
	"<?xml version=""1.0"" encoding=""UTF-8""?>
	|<xs:schema %1 %2 %3 %4>
	|</xs:schema>";
	
	СхемаСтрока = СтрШаблон(ШаблонСхемы, Параметр1, Параметр2, Параметр3, Параметр4);
	
	// Построение схемы данных в виде объекта.
	ЧтениеXML = Новый ЧтениеXML; 
	ЧтениеXML.УстановитьСтроку(СхемаСтрока);
	
	ПостроительDOM  = Новый ПостроительDOM;
	ДокументDOM		= ПостроительDOM.Прочитать(ЧтениеXML);
	
	ПостроительСхем = Новый ПостроительСхемXML;
	СхемаОбъект = ПостроительСхем.СоздатьСхемуXML(ДокументDOM);
	СхемаОбъект.ОбновитьЭлементDOM();
	
	// Добавление типа СвойстваСообщения.	
	Тип = СоздатьСоставнойТип("СвойстваСообщения"); 
	СхемаОбъект.Содержимое.Добавить(Тип); 
	Фрагменты = Тип.Содержимое.Часть.Фрагменты;
	
	Элемент = СоздатьЭлементСхемы("ИдентификаторСообщения", ПространствоИменXS(), "string", ТипСтрока36);
	ДобавитьЭлементВСхему(Фрагменты, Элемент);
	
	Элемент = СоздатьЭлементСхемы("ИмяБазыИсточника", ПространствоИменXS(), "string", ТипСтрока100);
	ДобавитьЭлементВСхему(Фрагменты, Элемент);
	
	Элемент = СоздатьЭлементСхемы("ПолноеИмяБазыИсточника", ПространствоИменXS(), "string", ТипСтрока200);
	ДобавитьЭлементВСхему(Фрагменты, Элемент);
	
	Элемент = СоздатьЭлементСхемы("КлючМаршрутизации", ПространствоИменXS(), "string", ТипСтрока256);
	ДобавитьЭлементВСхему(Фрагменты, Элемент);
	
	СхемаОбъект.ОбновитьЭлементDOM();
	
	Возврат СхемаОбъект;
	
КонецФункции

Процедура ДобавитьЭлементВСхему(Фрагменты, Элемент, Обязательный = Ложь)
	
	Если Обязательный Тогда
		Фрагменты.Добавить(Элемент);
		
	Иначе
		Содержимое = Новый ФрагментXS;
		Содержимое.МинимальноВходит = 0;
	    Содержимое.Часть = Элемент;
		Фрагменты.Добавить(Содержимое);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура КвалифицироватьПримитивныйТип(Элемент, ПространствоИмен, ИмяТипа, ОписаниеТипа)
	
	ИмяТипаПоУмолчанию = Новый РасширенноеИмяXML(ПространствоИмен, ИмяТипа);
	
	Если НРег(ИмяТипа) = "string" И ОписаниеТипа.КвалификаторыСтроки.Длина <> 0 Тогда
		АнонимноеОпределениеТипа = Новый ОпределениеПростогоТипаXS;
		АнонимноеОпределениеТипа.ИмяБазовогоТипа = ИмяТипаПоУмолчанию;
		
		Фасет = Новый ФасетМаксимальнойДлиныXS();
		Фасет.Значение = ОписаниеТипа.КвалификаторыСтроки.Длина;
		Фасет.ЛексическоеЗначение = Формат(ОписаниеТипа.КвалификаторыСтроки.Длина, "ЧГ=");
		
		АнонимноеОпределениеТипа.Фасеты.Добавить(Фасет);

		Элемент.АнонимноеОпределениеТипа = АнонимноеОпределениеТипа;
		
	ИначеЕсли ИмяТипа = "decimal" И ОписаниеТипа.КвалификаторыЧисла.Разрядность <> 0 Тогда
		АнонимноеОпределениеТипа = Новый ОпределениеПростогоТипаXS;
		АнонимноеОпределениеТипа.ИмяБазовогоТипа = ИмяТипаПоУмолчанию;
		
		Фасет = Новый ФасетОбщегоКоличестваРазрядовXS();
		Фасет.Значение = ОписаниеТипа.КвалификаторыЧисла.Разрядность;
		Фасет.ЛексическоеЗначение  = Строка(ОписаниеТипа.КвалификаторыЧисла.Разрядность);
		
		АнонимноеОпределениеТипа.Фасеты.Добавить(Фасет);
		
		Фасет = Новый ФасетКоличестваРазрядовДробнойЧастиXS();
		Фасет.Значение = ОписаниеТипа.КвалификаторыЧисла.РазрядностьДробнойЧасти;
		Фасет.ЛексическоеЗначение  = Строка(ОписаниеТипа.КвалификаторыЧисла.РазрядностьДробнойЧасти);
		
		АнонимноеОпределениеТипа.Фасеты.Добавить(Фасет);
		
		Элемент.АнонимноеОпределениеТипа = АнонимноеОпределениеТипа;

	Иначе
		Элемент.ИмяТипа = ИмяТипаПоУмолчанию;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОбъектМетаданныхВСхему(СхемаОбъект, ПространствоИмен, Объект, РеквизитыИСвойства)
	
	ИмяОбъектаМетаданных = Объект.ПолноеИмя();
	
	Если РеквизитыИСвойства.Свойство("ЗначенияПеречисления") Тогда
		Тип = СоздатьПростойТипПеречисление(ИмяОбъектаМетаданных, РеквизитыИСвойства.ЗначенияПеречисления);
		СхемаОбъект.Содержимое.Добавить(Тип);
		
	Иначе
		Тип = СоздатьСоставнойТип(ИмяОбъектаМетаданных); 
		СхемаОбъект.Содержимое.Добавить(Тип); 
		Фрагменты = Тип.Содержимое.Часть.Фрагменты;
		
	КонецЕсли;
	
	Если РеквизитыИСвойства.Свойство("Реквизиты") Тогда
		ДобавитьРеквизитыОбъектаМетаданныхВСхему(РеквизитыИСвойства, ПространствоИмен, Фрагменты);
	КонецЕсли;
	
	Если РеквизитыИСвойства.Свойство("ТабличныеЧасти") Тогда
		
		Для Каждого ТабличнаяЧасть Из РеквизитыИСвойства.ТабличныеЧасти Цикл
			
			ДобавитьТабличнуюЧастьОбъектаМетаданныхВСхему(
				СхемаОбъект, ИмяОбъектаМетаданных, ТабличнаяЧасть, ПространствоИмен, Фрагменты);
			
			ПолноеИмяТабличнойЧасти = СтрШаблон("%1.%2", ИмяОбъектаМетаданных, ТабличнаяЧасть.Ключ);
			ПолноеИмяСтрокиТабличнойЧасти = СтрШаблон("%1.%2", ПолноеИмяТабличнойЧасти, "Строка"); 
			ТипСтрокаТабличнойЧасти = СоздатьСоставнойТип(ПолноеИмяСтрокиТабличнойЧасти); 
			СхемаОбъект.Содержимое.Добавить(ТипСтрокаТабличнойЧасти);

			ФрагментыСтрокаТабличнойЧасти = ТипСтрокаТабличнойЧасти.Содержимое.Часть.Фрагменты;
			Для Каждого РеквизитТабличнойЧасти Из ТабличнаяЧасть.Значение Цикл
				
				ДобавитьСтрокуТабличнойЧастиОбъектаМетаданныхВСхему(
					РеквизитТабличнойЧасти, ПространствоИмен, ФрагментыСтрокаТабличнойЧасти);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РеквизитыИСвойства.Свойства.Свойство("ТаблицаКлючей") Тогда
		Элемент = СоздатьЭлементСхемы("ТаблицаКлючей", ПространствоИмен, "ТаблицаКлючей");
		ДобавитьЭлементВСхему(Фрагменты, Элемент);
	КонецЕсли;
	
	Если РеквизитыИСвойства.Свойства.Свойство("Идентификатор") Тогда
		ДлинаИдентификатора = 36;		
		ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(ДлинаИдентификатора));
		 
		Элемент = СоздатьЭлементСхемы("Идентификатор", ПространствоИменXS(), "string", ОписаниеТипаСтрока);
		ДобавитьЭлементВСхему(Фрагменты, Элемент);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьРеквизитыОбъектаМетаданныхВСхему(РеквизитыИСвойства, ПространствоИмен, Фрагменты)
	
	РеквизитыИСвойства.Реквизиты.Сортировать("ИмяСвойстваXDTO");

	Для Каждого Реквизит Из РеквизитыИСвойства.Реквизиты Цикл
		
		Если Реквизит.ИмяСвойстваXDTO = "" Тогда
			Продолжить;
		КонецЕсли;

		Если Реквизит.ПримитивныйТип Тогда
			ПространствоИменЭлемента = ПространствоИменXS();
		Иначе
			ПространствоИменЭлемента = ПространствоИмен;
		КонецЕсли;

		Элемент = СоздатьЭлементСхемы(Реквизит.ИмяСвойстваXDTO, 
						ПространствоИменЭлемента, Реквизит.ТипСтрокой, Реквизит.ОписаниеТипов1С);
		
		ДобавитьЭлементВСхему(Фрагменты, Элемент, Реквизит.Обязательный);

	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьТабличнуюЧастьОбъектаМетаданныхВСхему(
	СхемаОбъект, ИмяОбъектаМетаданных, ТабличнаяЧасть, ПространствоИмен, Фрагменты)
	
	ПолноеИмяТабличнойЧасти = СтрШаблон("%1.%2", ИмяОбъектаМетаданных, ТабличнаяЧасть.Ключ);
	ПолноеИмяСтрокиТабличнойЧасти = СтрШаблон("%1.%2", ПолноеИмяТабличнойЧасти, "Строка");
	
	Элемент = 
		СоздатьЭлементСхемы(
			ТабличнаяЧасть.Ключ,
			ПространствоИмен,
			ПолноеИмяТабличнойЧасти);
	
	ДобавитьЭлементВСхему(Фрагменты, Элемент);
	
	ТипТабличнаяЧасть = СоздатьСоставнойТип(ПолноеИмяТабличнойЧасти, ВидГруппыМоделиXS.Последовательность); 
	СхемаОбъект.Содержимое.Добавить(ТипТабличнаяЧасть);
	ФрагментыТабличнаяЧасть = ТипТабличнаяЧасть.Содержимое.Часть.Фрагменты;
	
	Элемент = 
		СоздатьЭлементСхемы(
			"Строка", 
			ПространствоИмен,
			ПолноеИмяСтрокиТабличнойЧасти);
		
	ДобавитьЭлементВСхему(ФрагментыТабличнаяЧасть, Элемент);
	
	УстановитьПризнакЭлементСписок(ФрагментыТабличнаяЧасть, Элемент);
	
КонецПроцедуры

Процедура ДобавитьСтрокуТабличнойЧастиОбъектаМетаданныхВСхему(
	РеквизитТабличнойЧасти, ПространствоИмен, ФрагментыСтрокаТабличнойЧасти)
	
	Если РеквизитТабличнойЧасти.ПримитивныйТип Тогда
		ПространствоИменЭлемента = ПространствоИменXS();
		
	Иначе
		ПространствоИменЭлемента = ПространствоИмен;
		
	КонецЕсли;
	
	Элемент = 
		СоздатьЭлементСхемы(
			РеквизитТабличнойЧасти.ИмяСвойстваXDTO,
			ПространствоИменЭлемента,
			РеквизитТабличнойЧасти.ТипСтрокой,
			РеквизитТабличнойЧасти.ОписаниеТипов1С);
	
	ДобавитьЭлементВСхему(
		ФрагментыСтрокаТабличнойЧасти, 
		Элемент, 
		РеквизитТабличнойЧасти.Обязательный);
	
КонецПроцедуры

Процедура ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, КоллекцияРеквизитов, СвязанныеОбъекты,
	ЭтоСвязанныйОбъект, ИсключаемыеПоля = Неопределено)
	
	Если ИсключаемыеПоля = Неопределено Тогда
		ИсключаемыеПоля = Новый Структура();
	КонецЕсли;
	
	Для Каждого Реквизит Из КоллекцияРеквизитов Цикл
		
		Если ИсключаемыеПоля.Свойство(Реквизит.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		ДобавитьРеквизитОбъектаМетаданныхВТаблицу(
			ТаблицаРеквизитов,
			Реквизит.Имя, 
			Реквизит.Тип, 
			СвязанныеОбъекты, 
			ЭтоСвязанныйОбъект);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьРеквизитОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, Имя, ОписаниеТипа, 
	СвязанныеОбъекты, ЭтоСвязанныйОбъект = Ложь)
	
	РасширенноеОписаниеТипа = РасширенноеОписаниеТипа(ОписаниеТипа);
	
	Если СтрНайти(РасширенноеОписаниеТипа.ТипСтрокой, "%НеподдерживаемыйТип%") > 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоСвязанныйОбъект И Не РасширенноеОписаниеТипа.ПримитивныйТип Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоСвязанныйОбъект Тогда
		ИмяСвойстваXDTO = "";
	Иначе
		ИмяСвойстваXDTO = Имя;
	КонецЕсли;
	
	НоваяСтрока = ТаблицаРеквизитов.Добавить();
	НоваяСтрока.ИмяРеквизита = Имя;
	НоваяСтрока.ОписаниеТипов1С = РасширенноеОписаниеТипа.ОписаниеТипов;
	НоваяСтрока.ТипСтрокой = РасширенноеОписаниеТипа.ТипСтрокой;
	НоваяСтрока.ПримитивныйТип = РасширенноеОписаниеТипа.ПримитивныйТип;
	НоваяСтрока.ИмяСвойстваXDTO = ИмяСвойстваXDTO;
	
	Если Не РасширенноеОписаниеТипа.ПримитивныйТип Тогда
		Для Каждого Тип Из ОписаниеТипа.Типы() Цикл		
			МетаданныеТипа = Метаданные.НайтиПоТипу(Тип);
			Если МетаданныеТипа <> Неопределено Тогда
				ДобавитьСвязанныйОбъект(СвязанныеОбъекты, МетаданныеТипа);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция СоздатьПростойТипПеречисление(ИмяТипа, МассивЗначений)

	Тип  = Новый ОпределениеПростогоТипаXS;  
	Тип.Имя = ИмяТипа;
	Тип.ИмяБазовогоТипа = Новый РасширенноеИмяXML(ПространствоИменXS(), "string");
	
	Для Каждого ТекущаяСтрокаПеречисления Из МассивЗначений Цикл 	
		Фасет = Новый ФасетПеречисленияXS();
		Фасет.Значение = ТекущаяСтрокаПеречисления;
		Фасет.ЛексическоеЗначение  = ТекущаяСтрокаПеречисления;		
		Тип.Фасеты.Добавить(Фасет);
	КонецЦикла;	
		
	Возврат Тип;
	
КонецФункции

Процедура УстановитьПризнакЭлементСписок(Фрагменты, Элемент)
	
	Содержимое = Новый ФрагментXS;
	Содержимое.МинимальноВходит = 0;
	Содержимое.МаксимальноВходит = "unbounded";
	Содержимое.Часть = Элемент;
	Фрагменты.Добавить(Содержимое);
	
КонецПроцедуры

Процедура ДобавитьОсновныеРеквизиты(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты, ИсключаемыеПоля)
	
	ТаблицаРеквизитов = НоваяТаблицаРеквизитов();
	
	Свойства = РеквизитыИСвойства.Свойства;
	ЭтоСвязанныйОбъект = РеквизитыИСвойства.Свойство("ЭтоСвязанныйОбъект");
	МожноДобавлять = НЕ СП_ОбменДанными.ЭтоРегистр(РеквизитыИСвойства.ПолноеИмяОбъекта);
	
	Если Свойства.Свойство("СтандартныеРеквизиты") И МожноДобавлять Тогда
		ИсключаемыеПоляСтандартныеРеквизиты = Неопределено;
		ИсключаемыеПоля.Свойство("СтандартныеРеквизиты", ИсключаемыеПоляСтандартныеРеквизиты);
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(
			ТаблицаРеквизитов, 
			МетаданныеОбъекта.СтандартныеРеквизиты, 
			СвязанныеОбъекты, 
			ЭтоСвязанныйОбъект,
			ИсключаемыеПоляСтандартныеРеквизиты);
	КонецЕсли;
	
	Если Свойства.Свойство("РеквизитыАдресации") И МожноДобавлять Тогда
		ИсключаемыеПоляРеквизитыАдресации = Неопределено;
		ИсключаемыеПоля.Свойство("РеквизитыАдресации", ИсключаемыеПоляРеквизитыАдресации);
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(
			ТаблицаРеквизитов, 
			МетаданныеОбъекта.РеквизитыАдресации, 
			СвязанныеОбъекты, 
			ЭтоСвязанныйОбъект,
			ИсключаемыеПоляРеквизитыАдресации);
	КонецЕсли;
	
	Если Свойства.Свойство("Реквизиты") И МожноДобавлять Тогда
		ИсключаемыеПоляРеквизиты = Неопределено;
		ИсключаемыеПоля.Свойство("Реквизиты", ИсключаемыеПоляРеквизиты);
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(
			ТаблицаРеквизитов, 
			МетаданныеОбъекта.Реквизиты, 
			СвязанныеОбъекты, 
			ЭтоСвязанныйОбъект,
			ИсключаемыеПоляРеквизиты);
	КонецЕсли;
	
	РеквизитыИСвойства.Вставить("Реквизиты", ТаблицаРеквизитов);
	
КонецПроцедуры

Процедура ДобавитьПеречисленияИТабличныеЧасти(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты, ИсключаемыеПоля)
	
	ЭтоСвязанныйОбъект = РеквизитыИСвойства.Свойство("ЭтоСвязанныйОбъект");
	
	Если РеквизитыИСвойства.Свойство("ЗначенияПеречисления") Тогда
		Для Каждого ЗначениеПеречисления Из МетаданныеОбъекта.ЗначенияПеречисления Цикл
			РеквизитыИСвойства.ЗначенияПеречисления.Добавить(ЗначениеПеречисления.Имя);
		КонецЦикла;
	КонецЕсли;
	
	Если РеквизитыИСвойства.Свойство("ТабличныеЧасти") И Не ЭтоСвязанныйОбъект Тогда
		
		ИсключаемыеПоляТаблицы = Неопределено;
		ИсключаемыеПоля.Свойство("ТабличныеЧасти", ИсключаемыеПоляТаблицы);
		
		Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
			
			ИсключаемыеПоляРеквизиты = Неопределено;
			Если Не ИсключаемыеПоляТаблицы = Неопределено Тогда
				ИсключаемыеПоляТаблицы.Свойство(ТабличнаяЧасть.Имя, ИсключаемыеПоляРеквизиты);
			КонецЕсли;
			
			ТаблицаРеквизитов = НоваяТаблицаРеквизитов();
			
			ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(
				ТаблицаРеквизитов, 
				ТабличнаяЧасть.Реквизиты,
				СвязанныеОбъекты,
				ЭтоСвязанныйОбъект,
				ИсключаемыеПоляРеквизиты);
			
			Если ТаблицаРеквизитов.Количество() > 0 Тогда
				РеквизитыИСвойства.ТабличныеЧасти.Вставить(ТабличнаяЧасть.Имя, ТаблицаРеквизитов);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьОтборыИНаборыЗаписей(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты)
	
	ЭтоСвязанныйОбъект = РеквизитыИСвойства.Свойство("ЭтоСвязанныйОбъект");
	ЭтоРегистр = СП_ОбменДанными.ЭтоРегистр(РеквизитыИСвойства.ПолноеИмяОбъекта);
	
	Если РеквизитыИСвойства.Свойства.Свойство("Отбор") Тогда
		
		ТаблицаРеквизитов = НоваяТаблицаРеквизитов();
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.СтандартныеРеквизиты, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
			
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.Измерения, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
			
		РеквизитыИСвойства.Вставить("Отбор", ТаблицаРеквизитов);
		
	КонецЕсли;
	
	Если ЭтоРегистр Тогда
		
		ТаблицаРеквизитов = НоваяТаблицаРеквизитов();
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.СтандартныеРеквизиты, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.Измерения, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
		
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.Ресурсы, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
			
		ДобавитьРеквизитыОбъектаМетаданныхВТаблицу(ТаблицаРеквизитов, 
			МетаданныеОбъекта.Реквизиты, СвязанныеОбъекты, ЭтоСвязанныйОбъект);
		
		СтруктураНаборЗаписей = Новый Структура("НаборЗаписей", ТаблицаРеквизитов);
		РеквизитыИСвойства.Вставить("ТабличныеЧасти", СтруктураНаборЗаписей);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОписаниеТипаИзСтроки(СтрокаТипа)
	
	ПараметрыТипа = ПолучитьПараметрыТипа(СтрокаТипа);
	
	Если ПараметрыТипа.Имя = "Строка" Тогда
		КвалификаторыСтроки = Новый КвалификаторыСтроки(ПараметрыТипа.Длина);
		ОписаниеТипа = Новый ОписаниеТипов(ПараметрыТипа.Имя, , КвалификаторыСтроки);
		
	ИначеЕсли ПараметрыТипа.Имя = "Число" Тогда
		КвалификаторыЧисла = Новый КвалификаторыЧисла(ПараметрыТипа.Длина, ПараметрыТипа.Точность);
		ОписаниеТипа = Новый ОписаниеТипов(ПараметрыТипа.Имя, КвалификаторыЧисла);
		
	Иначе
		ОписаниеТипа = Новый ОписаниеТипов(ПараметрыТипа.Имя);
		
	КонецЕсли;
	
	Возврат ОписаниеТипа;
	
КонецФункции

Функция ПолучитьПараметрыТипа(ИмяТипа)
	
	ИмяТипа = СтрЗаменить(ИмяТипа, "(", ",");
	ИмяТипа = СтрЗаменить(ИмяТипа, ")", "");
	МассивПодстрок = СтрРазделить(ИмяТипа, ",");
	
	КоличествоПараметров = 3;
	ИндексИмя = 0;
	ИндексДлина = 1;
	ИндексТочность = 2;
	
	МассивПараметров = Новый Массив(КоличествоПараметров);
	Для Индекс = 0 По МассивПодстрок.ВГраница() Цикл
		МассивПараметров.Вставить(Индекс, МассивПодстрок[Индекс]);
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Имя", МассивПараметров[ИндексИмя]);
	Результат.Вставить("Длина", МассивПараметров[ИндексДлина]);
	Результат.Вставить("Точность", МассивПараметров[ИндексТочность]);
	
	Возврат Результат;
	
КонецФункции

// Создать составной тип.
// 
// Параметры:
//  ИмяТипа - Строка - имя типа.
//  ВидГруппы - ВидГруппыМоделиXS - вид группы.
// 
// Возвращаемое значение:
//  ОпределениеСоставногоТипаXS - составной тип XS.
// 
Функция СоздатьСоставнойТип(ИмяТипа = "", ВидГруппы = "")
	
	Тип = Новый ОпределениеСоставногоТипаXS;
	
	Если ЗначениеЗаполнено(ИмяТипа) Тогда
		Тип.Имя = ИмяТипа;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидГруппы) Тогда
		ВидГруппы = ВидГруппыМоделиXS.Все;
	КонецЕсли;
	
	Часть = Новый ГруппаМоделиXS;
	Часть.ВидГруппы = ВидГруппы;
	
	Содержимое = Новый ФрагментXS;
	Содержимое.Часть = Часть;
	
	Тип.Содержимое = Содержимое;
	
	Возврат Тип;

КонецФункции

// Создает элемент схемы данных.
// 
// Параметры:
//  ИмяЭлемента - Строка - имя элемента.
//  ПространствоИмен - Строка - пространство имен.
//  ИмяТипа - Строка - имя типа.
//  ОписаниеТипа - Неопределено, ОписаниеТипов - описание типа.
// 
// Возвращаемое значение:
// 	ОбъявлениеЭлементаXS - элемент схемы данных.
// 
Функция СоздатьЭлементСхемы(ИмяЭлемента, ПространствоИмен, ИмяТипа, ОписаниеТипа = Неопределено)
	
	Элемент = Новый ОбъявлениеЭлементаXS;  
	Элемент.Имя = ИмяЭлемента;
	
	ПространствоИменПримитивногоТипа = ПространствоИменXS();
	
	Если Не ЗначениеЗаполнено(ОписаниеТипа)
		ИЛИ ОписаниеТипа.Типы().Количество() = 1 Тогда
		
		Элемент.ИмяТипа = Новый РасширенноеИмяXML(ПространствоИмен, ИмяТипа);
		
	ИначеЕсли ПространствоИмен = ПространствоИменПримитивногоТипа Тогда
		КвалифицироватьПримитивныйТип(Элемент, ПространствоИмен, ИмяТипа, ОписаниеТипа);
		
	Иначе
		АнонимноеОпределениеТипа = СоздатьСоставнойТип();
		АнонимноеОпределениеТипа.Содержимое.Часть.ВидГруппы = ВидГруппыМоделиXS.Выбор;
		Элемент.АнонимноеОпределениеТипа = АнонимноеОпределениеТипа;
		
		Для Каждого Тип Из ОписаниеТипа.Типы() Цикл
			
			МассивТипов = Новый Массив;
			МассивТипов.Добавить(Тип);
			
			ОписаниеПодчиненногоТипа = 
				Новый ОписаниеТипов(МассивТипов, 
					ОписаниеТипа.КвалификаторыЧисла, 
					ОписаниеТипа.КвалификаторыСтроки, 
					ОписаниеТипа.КвалификаторыДаты);
			
			РасширенноеОписаниеТипа = РасширенноеОписаниеТипа(ОписаниеПодчиненногоТипа);
			Если РасширенноеОписаниеТипа.ПримитивныйТип Тогда
				ПространствоИменЭлемента = ПространствоИменПримитивногоТипа;
			Иначе
				ПространствоИменЭлемента = ПространствоИмен;
			КонецЕсли;
			
			ПодчиненныйЭлемент = 
				СоздатьЭлементСхемы(РасширенноеОписаниеТипа.ТипСтрокой, 
					ПространствоИменЭлемента, 
					РасширенноеОписаниеТипа.ТипСтрокой, 
					ОписаниеПодчиненногоТипа);
				
			Элемент.АнонимноеОпределениеТипа.Содержимое.Часть.Фрагменты.Добавить(ПодчиненныйЭлемент);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Элемент;
	
КонецФункции

// Возвращает структуру с расширенным описанием типа.
// 
// Параметры:
//  ОписаниеТипа - ОписаниеТипов - описание типа данных.
// 
// Возвращаемое значение:
//  Структура - расширенное описание типа:
// 		* ОписаниеТипов - ОписаниеТипов - описание типов.
// 		* ТипСтрокой - Строка - тип в виде строки.
// 		* ПримитивныйТип - Булево - признак примитивного типа.
// 		* СоставнойТип - Булево - признак составного типа. 
//
Функция РасширенноеОписаниеТипа(ОписаниеТипа)
	
	ТипСтрокой = "";
	ПримитивныйТип = Ложь;
	ОписаниеТипаРезультат = ОписаниеТипа;
	
	Для Каждого Тип Из ОписаниеТипа.Типы() Цикл
		
		ИмяТипа = СП_ОбменДанными.ПолучитьИмяТипаВВидеСтроки(Тип, ПримитивныйТип);
		ТипСтрокой = ДобавитьСтрокуСРазделителем(ТипСтрокой, ИмяТипа);
		
		Если СтрНайти(Тип, "Описание типов") Тогда
			ДлинаОписания = 1000;
			КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаОписания);
			ОписаниеТипаРезультат = 
				Новый ОписаниеТипов(
					ОписаниеТипаРезультат, 
					"Строка", 
					"ОписаниеТипов", , 
					КвалификаторСтроки);
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоТипов = ОписаниеТипа.Типы().Количество();
	ЭтоПримитивныйТип = ПримитивныйТип И КоличествоТипов = 1;
	ЭтоСоставнойТип = КоличествоТипов > 1;
	
	СтруктураОписания = Новый Структура;
	СтруктураОписания.Вставить("ОписаниеТипов", ОписаниеТипаРезультат);
	СтруктураОписания.Вставить("ТипСтрокой", ТипСтрокой);
	СтруктураОписания.Вставить("ПримитивныйТип", ЭтоПримитивныйТип);
	СтруктураОписания.Вставить("СоставнойТип", ЭтоСоставнойТип); 
	
	Возврат СтруктураОписания;
	
КонецФункции

// Добавляет данные в строку с разделителями.
// 
// Параметры:
//  ИсходнаяСтрока - Строка - исходная строка.
//  ДобавляемыйТекст - Строка - добавляемый текст.
// 
// Возвращаемое значение:
//  Строка - строка с разделителями.
// 
Функция ДобавитьСтрокуСРазделителем(ИсходнаяСтрока, ДобавляемыйТекст)
	
	Если ЗначениеЗаполнено(ИсходнаяСтрока) Тогда
		Результат = СтрШаблон("%1, %2", ИсходнаяСтрока, ДобавляемыйТекст);
	Иначе
		Результат = ДобавляемыйТекст;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Реквизиты и свойства объекта метаданных.
// 
// Параметры:
//  МетаданныеОбъекта - ОбъектМетаданных - метаданные объекта.
// 
// Возвращаемое значение:
//  Структура - Реквизиты и свойства объекта метаданных.
//
Функция РеквизитыИСвойстваОбъектаМетаданных(МетаданныеОбъекта, ИсключаемыеПоля = Неопределено)
	
	РеквизитыИСвойства = НоваяСтруктураРеквизитовИСвойств(МетаданныеОбъекта);
	ЗаполнитьСтруктуруРеквизитовИСвойств(МетаданныеОбъекта, РеквизитыИСвойства, ИсключаемыеПоля);
	
	РеквизитыИСвойстваСвязанныхОбъектов = Новый Соответствие;
	
	Для Каждого СвязанныйОбъект Из РеквизитыИСвойства.СвязанныеОбъекты Цикл
		
		РеквизитыИСвойстваСвязанногоОбъекта = НоваяСтруктураРеквизитовИСвойств(СвязанныйОбъект.Ключ);
		РеквизитыИСвойстваСвязанногоОбъекта.Вставить("ЭтоСвязанныйОбъект", Истина);
		
		ЗаполнитьСтруктуруРеквизитовИСвойств(СвязанныйОбъект.Ключ, РеквизитыИСвойстваСвязанногоОбъекта);
		
		ПолноеИмяКлюча = СвязанныйОбъект.Ключ.ПолноеИмя();
		РеквизитыИСвойстваСвязанныхОбъектов.Вставить(ПолноеИмяКлюча, РеквизитыИСвойстваСвязанногоОбъекта);
		
	КонецЦикла;
	
	РеквизитыИСвойства.СвязанныеОбъекты = РеквизитыИСвойстваСвязанныхОбъектов;
	
	Возврат РеквизитыИСвойства;
	
КонецФункции

// Заполняет структуру реквизитов и свойств по метаданным объекта.
// 
// Параметры:
//  МетаданныеОбъекта - Метаданные - метаданные объекта.
//  РеквизитыИСвойства - Структура - реквизиты и свойства объекта.
// 
Процедура ЗаполнитьСтруктуруРеквизитовИСвойств(МетаданныеОбъекта, РеквизитыИСвойства, ИсключаемыеПоля = Неопределено)
	
	Если ИсключаемыеПоля = Неопределено Тогда
		ИсключаемыеПоля = Новый Структура();
	КонецЕсли;
	
	СвязанныеОбъекты = Новый Соответствие;
	
	ДобавитьОсновныеРеквизиты(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты, ИсключаемыеПоля);
	
	ДобавитьПеречисленияИТабличныеЧасти(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты, ИсключаемыеПоля);
	
	ДобавитьОтборыИНаборыЗаписей(МетаданныеОбъекта, РеквизитыИСвойства, СвязанныеОбъекты);
	
	РеквизитыИСвойства.Вставить("СвязанныеОбъекты", СвязанныеОбъекты); 
	
КонецПроцедуры

// Добавить связанный объект.
// 
// Параметры:
//  СвязанныеОбъекты - Соответствие - связанные объекты.
//  НовыйЭлемент - ОбъектМетаданных, Неопределено - новый связанный объект.
//
Процедура ДобавитьСвязанныйОбъект(СвязанныеОбъекты, НовыйЭлемент)
	
	Если СвязанныеОбъекты.Получить(НовыйЭлемент) = Неопределено Тогда
		
		СвязанныеОбъекты.Вставить(НовыйЭлемент);
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует таблицу реквизитов.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица реквизитов:
// 		* ИмяРеквизита - Строка - имя реквизита метаданных. 
// 		* ОписаниеТипов1С - ОписаниеТипов - описание типов реквизита.
// 		* ИмяСвойстваXDTO - Строка - имя свойства XDTO. 
// 		* ТипXDTO - Строка - описание типа XDTO.
// 		* ТипСтрокой - Строка - описание типа в виде строки.
// 		* ПримитивныйТип - Булево - признак примитивного типа.
// 		* Флажок - Булево - реквизит имеет тип Булево.
// 		* Обязательный - Булево - признак обязательного реквизита.
//
Функция НоваяТаблицаРеквизитов()
	
	ТаблицаРеквизитов = Новый ТаблицаЗначений;
	ТаблицаРеквизитов.Колонки.Добавить("ИмяРеквизита");
	ТаблицаРеквизитов.Колонки.Добавить("ОписаниеТипов1С");
	ТаблицаРеквизитов.Колонки.Добавить("ИмяСвойстваXDTO");
	ТаблицаРеквизитов.Колонки.Добавить("ТипXDTO");
	ТаблицаРеквизитов.Колонки.Добавить("ТипСтрокой");
	ТаблицаРеквизитов.Колонки.Добавить("ПримитивныйТип");
	ТаблицаРеквизитов.Колонки.Добавить("Флажок");
	ТаблицаРеквизитов.Колонки.Добавить("Обязательный", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаРеквизитов;
	
КонецФункции

#КонецОбласти
