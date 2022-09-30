
&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ОткрытьВерсиюДокумента();
	
КонецПроцедуры

&НаКлиенте
Процедура СравнитьВерсии(Команда)
	
	СравнитьДвеВерсииДокумента();
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюДокумента()
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("АдресВременногоХранилищаОбъекта",ДокументОбъектАдрес);
	СтруктураПараметров.Вставить("СозданаВФормеГрупповогоРедактирования",Истина);
	СтруктураПараметров.Вставить("ВозможноРедактирование",Ложь);
	СтруктураПараметров.Вставить("СрезПоВерсиям",Истина);
	СтруктураПараметров.Вставить("ВалютаОтображения",ВалютаОтображения);
	СтруктураПараметров.Вставить("мТекущаяВалюта",ВалютаОтображения);
	
	СписокВерсийДоТекущей = Новый СписокЗначений;
	
	Если Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки.Количество() = 1 Тогда
		
		СписокВерсий=Новый СписокЗначений;
		Для Каждого Строка ИЗ Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки Цикл
			СписокВерсий.Добавить(ОбнаруженныеВерсии.НайтиПоИдентификатору(Строка).Ссылка);
			тВерсияКод = ОбнаруженныеВерсии.НайтиПоИдентификатору(Строка).Код;
		КонецЦикла;
		
		СтруктураПараметров.Вставить("СписокВерсий",СписокВерсий);
		
		АдресИзмененногоОбъекта = Неопределено;
				
		Для Каждого СтрВерсия Из ОбнаруженныеВерсии Цикл	
			Если  СтрВерсия.Код <= тВерсияКод Тогда
				СписокВерсийДоТекущей.Добавить(СтрВерсия.Ссылка);
			КонецЕсли;				
		Конеццикла;	
		
		Если МногопериодныйРежим Тогда
			СтруктураПараметров.Вставить("Бланк",ТекущийБланк);	   		
			СтруктураПараметров.Вставить("ЭкземплярОтчета",Объект.ЭкземплярОтчета);	
			СтруктураПараметров.Вставить("СписокВерсий",СписокВерсийДоТекущей);
			Оповещение = Новый ОписаниеОповещения("ОткрытьВерсиюДокументаЗавершение", ЭтотОбъект);
			ИмяФормыБланка = "Обработка.АналитическийБланк.Форма.ФормаОтчета";
			ОткрытьФорму(ИмяФормыБланка, СтруктураПараметров,,,,,Оповещение,РежимОткрытияОкнаФормы.Независимый);	
		Иначе	
			Оповещение = Новый ОписаниеОповещения("ОткрытьВерсиюДокументаЗавершение", ЭтотОбъект);
			ОткрытьФорму("Документ.НастраиваемыйОтчет.Форма.ФормаДокументаУправляемая", СтруктураПараметров,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура СравнитьДвеВерсииДокумента()
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("АдресВременногоХранилищаОбъекта",ДокументОбъектАдрес);
	СтруктураПараметров.Вставить("СозданаВФормеГрупповогоРедактирования",Истина);
	СтруктураПараметров.Вставить("ВозможноРедактирование",Ложь);
	СтруктураПараметров.Вставить("СрезПоВерсиям",Истина);
	СтруктураПараметров.Вставить("ВалютаОтображения",ВалютаОтображения);
	СтруктураПараметров.Вставить("мТекущаяВалюта",ВалютаОтображения);
	
	СписокВерсийДоТекущей_1 = Новый СписокЗначений;
	СписокВерсийДоТекущей_2 = Новый СписокЗначений;

	
	Если Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки.Количество() = 2 Тогда
		
		СписокВерсий	=	Новый СписокЗначений;
		СписокВерсийКод	= 	Новый СписокЗначений;

		Для Каждого Строка ИЗ Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки Цикл
			СписокВерсий.Добавить(ОбнаруженныеВерсии.НайтиПоИдентификатору(Строка).Ссылка);
			СписокВерсийКод.Добавить(ОбнаруженныеВерсии.НайтиПоИдентификатору(Строка).Код);
		КонецЦикла;
		
		СтруктураПараметров.Вставить("СписокВерсий",СписокВерсий);
		
		АдресИзмененногоОбъекта = Неопределено;
				
		тВерсияКод_1 = СписокВерсийКод[0].Значение;
		тВерсияКод_2 = СписокВерсийКод[1].Значение;
	
		Для Каждого СтрВерсия Из ОбнаруженныеВерсии Цикл	
			Если  СтрВерсия.Код <= тВерсияКод_1 Тогда
				СписокВерсийДоТекущей_1.Добавить(СтрВерсия.Ссылка);
			КонецЕсли;				
			Если  СтрВерсия.Код <= тВерсияКод_2 Тогда
				СписокВерсийДоТекущей_2.Добавить(СтрВерсия.Ссылка);
			КонецЕсли;	
		Конеццикла;	
		
		Если МногопериодныйРежим Тогда			
			ПараметрыБазовойВерсии = Новый Структура;
			ПараметрыБазовойВерсии.Вставить("ПериодОтчета",ПериодОтчета);
			ПараметрыБазовойВерсии.Вставить("ПериодОкончания",ПериодОкончания);
			ПараметрыБазовойВерсии.Вставить("Сценарий",Сценарий);
			ПараметрыБазовойВерсии.Вставить("Организация",Организация);
			ПараметрыБазовойВерсии.Вставить("Проект",Проект);
			ПараметрыБазовойВерсии.Вставить("СписокВерсий",СписокВерсийДоТекущей_1);
			ПараметрыБазовойВерсии.Вставить("Валюта",ВалютаОтображения);
			
			СтруктураПараметров.Вставить("Бланк",ТекущийБланк);	   		
			СтруктураПараметров.Вставить("ЭкземплярОтчета",Объект.ЭкземплярОтчета);	
			СтруктураПараметров.Вставить("СписокВерсий",СписокВерсийДоТекущей_2);
			СтруктураПараметров.Вставить("ПараметрыБазовойВерсии",ПараметрыБазовойВерсии);
			
			Оповещение = Новый ОписаниеОповещения("ОткрытьВерсиюДокументаЗавершение", ЭтотОбъект);
			ИмяФормыБланка = "Обработка.АналитическийБланк.Форма.ФормаОтчета";
			ОткрытьФорму(ИмяФормыБланка, СтруктураПараметров,,,,,Оповещение,РежимОткрытияОкнаФормы.Независимый);	
		Иначе	
			Оповещение = Новый ОписаниеОповещения("ОткрытьВерсиюДокументаЗавершение", ЭтотОбъект);
			ОткрытьФорму("Документ.НастраиваемыйОтчет.Форма.ФормаДокументаУправляемая", СтруктураПараметров,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		КонецЕсли;
		
	Иначе	
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Необходимо выделить две версии'"),,,СтатусСообщения.Внимание);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюДокументаЗавершение(Результат, ДополнительныеПараметры) Экспорт	
	АдресИзмененногоОбъекта = Результат;	
КонецПроцедуры // ОткрытьФормуОтчета()

&НаКлиенте
Процедура СвернутьДоВерсии(Команда)
	
	Если НЕ Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки.Количество()=1 Тогда
		
		ПоказатьПредупреждение(,Нстр("ru = 'В качестве границы свертки данных необходимо выбрать одну версию.'"));
		Возврат;
		
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ОбнаруженныеВерсии.ТекущиеДанные;
	
	Если ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.УдалениеЗапрещено Тогда
		
		ПоказатьПредупреждение(,Нстр("ru = 'Свертка возможна только до версий, созданных через экземпляр отчета.'"));
		Возврат;
		
	КонецЕсли;
	
	ДопПараметры = Новый Структура("ТекущиеДанные", ТекущиеДанные);
	Оповещение = Новый ОписаниеОповещения("СвернутьДоВерсииЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВопрос(Оповещение, СтрШаблон(Нстр("ru = 'Версии экземпляра отчета будут свернуты до версии %1. Вы уверены?'"), 
		ТекущиеДанные.Ссылка), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьДоВерсииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ТекущиеДанные = ДополнительныеПараметры.ТекущиеДанные;
     
    Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
	ЭтаФорма.Модифицированность = Истина;
	
	СтруктураДанных=Новый Структура;
    СтруктураДанных.Вставить("ВерсияДляСвертки",ТекущиеДанные.Ссылка);
    СтруктураДанных.Вставить("ЭкземплярОтчета",Объект.ЭкземплярОтчета);
    
    Оповестить("СвернутьВерсии", СтруктураДанных);
    
    ОбновитьСписокВерсий();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МногопериодныйРежим = Параметры.МногопериодныйРежим;
	РежимСводнойТаблицы = Параметры.РежимСводнойТаблицы;
	
	Если МногопериодныйРежим Тогда
		 ТекущийБланк = Параметры.ТекущийБланк;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.ЭкземплярОтчета) Тогда
		Если Не ЗначениеЗаполнено(Параметры.ЭкземплярОтчета) Тогда
			ВызватьИсключение НСтр("ru = 'Обработка не предназначена для непосредственного использования.'");
		КонецЕсли;
		Объект.ЭкземплярОтчета = Параметры.ЭкземплярОтчета;
		ВидОтчета           = Параметры.ВидОтчета;
		Сценарий 			= Параметры.Сценарий;
		Организация 		= Параметры.Организация;
        ПериодОтчета 		= Параметры.ПериодОтчета;
        ПериодОкончания 	= Параметры.ПериодОкончания;
		Проект 				= Параметры.Проект;
		Для Инд =1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
			ЭтаФорма["Аналитика"+Инд] = Параметры["Аналитика"+Инд];
		КонецЦикла;		
	КонецЕсли;
	
	ОбновитьСписокВерсий();
	ВалютаОтображения = Объект.ЭкземплярОтчета.ОсновнаяВалюта;
	
	СостояниеСогласования = РасширениеПроцессыИСогласованиеУХ.ВернутьТекущееСостояние(Объект.ЭкземплярОтчета);
	ЗапрещеноУдаление = (СостояниеСогласования = Перечисления.СостоянияОтчетов.Подготовлен ИЛИ СостояниеСогласования = Перечисления.СостоянияОтчетов.Утвержден);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.СтраницаПустая;
	
	Элементы.ОбнаруженныеВерсииКонтекстноеМенюУстановитьНачалоДиапазона.Доступность=Ложь;
	Элементы.ОбнаруженныеВерсииКонтекстноеМенюУстановитьКонецДиапазона.Доступность=Ложь;
	
	Если  МногопериодныйРежим Тогда	
		ПериодОтчета 		= Объект.ЭкземплярОтчета.ПериодОтчета;
		ПериодОкончания 	= Объект.ЭкземплярОтчета.ПериодОкончания;
		Сценарий		 	= Объект.ЭкземплярОтчета.Сценарий;
		Организация		 	= Объект.ЭкземплярОтчета.Организация;
		Проект			 	= Объект.ЭкземплярОтчета.Проект;	
	ИначеЕсли НЕ РежимСводнойТаблицы Тогда	
		ДокументОбъект = Объект.ЭкземплярОтчета.ПолучитьОбъект();
		ДокументОбъект.ИнициализироватьКонтекст();
		НоваяСтруктураПеременных = ДокументОбъект.ПодготовитьСтруктуруПеременныхДляРасчета();
		ДокументОбъектАдрес = ПоместитьВоВременноеХранилище(НоваяСтруктураПеременных, ЭтаФорма.УникальныйИдентификатор);
		
	Иначе	
		Элементы.ОбнаруженныеВерсииОткрытьВерсию.Видимость = Ложь;
		Элементы.ОбнаруженныеВерсииСравнитьВерсии.Видимость = Ложь;
		Элементы.ОбнаруженныеВерсииКонтекстноеМенюОткрытьВерсию.Видимость = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокВерсий()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ВерсииЗначенийПоказателей.Владелец КАК Ссылка,
		|	ВЫБОР
		|		КОГДА НЕ ВерсииЗначенийПоказателей.ЭкземплярОтчета = ВерсииЗначенийПоказателей.Регистратор
		|				ИЛИ ВерсииЗначенийПоказателей.Владелец.РучнаяОперация = 2
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК УдалениеЗапрещено,
		|	ВерсииЗначенийПоказателей.Владелец.Код КАК Код,
		|	ВерсииЗначенийПоказателей.Владелец.Дата КАК Дата,
		|	ВерсииЗначенийПоказателей.Владелец.Автор КАК Автор,
		|	ВерсииЗначенийПоказателей.Владелец.Комментарий КАК Комментарий,
		|	ВерсииЗначенийПоказателей.Владелец.РежимКорректировки КАК РежимКорректировки,
		|	ВерсииЗначенийПоказателей.Владелец.ВерсияХранимогоФайла КАК ВерсияХранимогоФайла,
		|	ВерсииЗначенийПоказателей.Организация КАК Организация,
		|	ВерсииЗначенийПоказателей.Аналитика1 КАК Аналитика1,
		|	ВерсииЗначенийПоказателей.Аналитика2 КАК Аналитика2,
		|	ВерсииЗначенийПоказателей.Аналитика3 КАК Аналитика3,
		|	ВерсииЗначенийПоказателей.Аналитика4 КАК Аналитика4,
		|	ВерсииЗначенийПоказателей.Аналитика5 КАК Аналитика5,
		|	ВерсииЗначенийПоказателей.Аналитика6 КАК Аналитика6,
		|	ВерсииЗначенийПоказателей.Регистратор КАК Регистратор,
		|	ВерсииЗначенийПоказателей.ЭкземплярОтчета КАК ЭкземплярОтчета,
		|	ВерсииЗначенийПоказателей.Сценарий КАК УправлениеПериодомСценарий,
		|	ВерсииЗначенийПоказателей.Проект КАК Проект
		|ИЗ
		|	Справочник.ВерсииЗначенийПоказателей КАК ВерсииЗначенийПоказателей
		|ГДЕ
		|	ВерсииЗначенийПоказателей.ЧерноваяВерсия = ЛОЖЬ
		|	И ВерсииЗначенийПоказателей.ВидОтчета = &ВидОтчета
		|	И ВерсииЗначенийПоказателей.ПометкаУдаления = ЛОЖЬ
		|	И ВерсииЗначенийПоказателей.Сценарий = &Сценарий
		|	И ВерсииЗначенийПоказателей.ПериодОтчета.ДатаНачала >= &ДатаНачала
		|	И ВерсииЗначенийПоказателей.ПериодОтчета.ДатаОкончания <= &ДатаОкончания
		|	//И ВерсииЗначенийПоказателей.Организация 	= &Организация
		|	//И ВерсииЗначенийПоказателей.Проект 		= &Проект
		|	//И ВерсииЗначенийПоказателей.Аналитика1 	= &Аналитика1
		|	//И ВерсииЗначенийПоказателей.Аналитика2 	= &Аналитика2
		|	//И ВерсииЗначенийПоказателей.Аналитика3 	= &Аналитика3
		|	//И ВерсииЗначенийПоказателей.Аналитика4 	= &Аналитика4
		|	//И ВерсииЗначенийПоказателей.Аналитика5 	= &Аналитика5
		|	//И ВерсииЗначенийПоказателей.Аналитика6 	= &Аналитика6
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВерсииЗначенийПоказателей.Владелец.Код УБЫВ";		
	
	Запрос.УстановитьПараметр("ВидОтчета",ВидОтчета);
    Запрос.УстановитьПараметр("Организация",Организация);
	Запрос.УстановитьПараметр("Сценарий",Сценарий);
	
	Запрос.УстановитьПараметр("ДатаНачала",ПериодОтчета.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания",ПериодОкончания.ДатаОкончания);
	
	Если ЗначениеЗаполнено(Проект) Тогда
		 Запрос.Текст = СтрЗаменить(Запрос.Текст,"//И ВерсииЗначенийПоказателей.Проект","И ВерсииЗначенийПоказателей.Проект");
		 Запрос.УстановитьПараметр("Проект",Проект);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		 Запрос.Текст = СтрЗаменить(Запрос.Текст,"//И ВерсииЗначенийПоказателей.Организация","И ВерсииЗначенийПоказателей.Организация");
	КонецЕсли;

	Для Инд = 1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
		Если ЗначениеЗаполнено(ЭтаФорма["Аналитика"+Инд]) Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст,"//И ВерсииЗначенийПоказателей.Аналитика"+Инд,"И ВерсииЗначенийПоказателей.Аналитика"+Инд);
			Запрос.УстановитьПараметр("Аналитика"+Инд,ЭтаФорма["Аналитика"+Инд]);	
		КонецЕсли;			
	КонецЦикла;	
	
	Результат=Запрос.Выполнить().Выбрать();
	ОбнаруженныеВерсии.Очистить();
	
	Пока Результат.Следующий() Цикл
		
		НоваяСтрока=ОбнаруженныеВерсии.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,Результат);
		НоваяСтрока.СостояниеОбъекта=0;
		
	КонецЦикла;
	
КонецПроцедуры // ОбновитьСписокВерсий()

&НаСервере
Процедура ПодготовитьДанныеДляУдаления()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ОписаниеВерсий.Ссылка КАК Ссылка,
	|	ОписаниеВерсий.Код КАК Код,
	|	ОписаниеВерсий.Дата КАК Дата,
	|	ОписаниеВерсий.Автор КАК Автор
	|ИЗ
	|	Справочник.ОписаниеВерсий КАК ОписаниеВерсий
	|ГДЕ
	|	ОписаниеВерсий.ЭкземплярОтчета = &ЭкземплярОтчета
	|	И (ОписаниеВерсий.Регистратор = &ЭкземплярОтчета
	|			ИЛИ ОписаниеВерсий.РучнаяОперация < 2)
	|	И ОписаниеВерсий.ЧерноваяВерсия = ЛОЖЬ"; 
	
	Если КодНачалаДиапазона >0  Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|	И ОписаниеВерсий.Код >= &МинКод";
		Запрос.УстановитьПараметр("МинКод", КодНачалаДиапазона);
		
	КонецЕсли;
	
	Если КодКонцаДиапазона>0 Тогда
		
		Запрос.Текст = Запрос.Текст + "
		|	И ОписаниеВерсий.Код <= &МаксКод";
		Запрос.УстановитьПараметр("МаксКод", КодКонцаДиапазона);
		
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ЭкземплярОтчета", Объект.ЭкземплярОтчета);
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(),"ТаблицаУдаляемыхВерсий");
		
КонецПроцедуры // ПодготовитьДанныеДляУдаления() 

&НаСервере
Процедура УдалитьВыбранныеВерсии()
	
	КодНачалаДиапазона=0;
	КодКонцаДиапазона=0;
	НачалоДиапазонаУдаления="";
	КонецДиапазонаУдаления="";
	НаименованиеКонецДиапазона="";
	НаименованиеНачалоДиапазона="";
		
	Для Каждого Строка Из ТаблицаУдаляемыхВерсий Цикл
		
		Попытка
			Строка.Ссылка.ПолучитьОбъект().Удалить();
		Исключение
			ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(Нстр("ru = 'Не удалось удалить версию № %1 от %2. Автор: %3'"), 
				Формат(Строка.Код,"ЧДЦ=0; ЧН=-; ЧГ=3,0"), Формат(Строка.Дата, "ДФ=dd.MM.yyyy"), Строка.Автор));
		КонецПопытки;
		
	КонецЦикла;	
		
	ОбновитьСписокВерсий();
	
КонецПроцедуры // УдалитьВыбранныеВерсии() 

&НаКлиенте
Процедура ВыполнитьУдаление(Команда)
	
	СписокВыделенныхВерсийКод = Новый СписокЗначений;
		
	Если Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки.Количество() = 0 Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Нет выделенных версий документа.'"));
		Возврат;
	КонецЕсли;

	Для Каждого Строка ИЗ Элементы.ОбнаруженныеВерсии.ВыделенныеСтроки Цикл
		СписокВыделенныхВерсийКод.Добавить(ОбнаруженныеВерсии.НайтиПоИдентификатору(Строка).Код);
	КонецЦикла;

	Если СписокВыделенныхВерсийКод.Количество()>0 Тогда 
		
		КодКонцаДиапазона	= СписокВыделенныхВерсийКод[0].Значение;
		КодНачалаДиапазона 	= СписокВыделенныхВерсийКод[СписокВыделенныхВерсийКод.Количество()-1].Значение;
		ПодготовитьДанныеДляУдаления();
		
		Если ТаблицаУдаляемыхВерсий.Количество() = ОбнаруженныеВерсии.Количество() Тогда 
			
			Оповещение = Новый ОписаниеОповещения("ПродолжитьУдалениеВерсий", ЭтотОбъект);		
			ПоказатьВопрос(Оповещение, Нстр("ru = 'Будут удалены все версии документа. Вы уверены?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
			
		КонецЕсли;
		
		ПродолжитьУдалениеВерсий(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьУдалениеВерсий(РезультатВопроса = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если (РезультатВопроса <> Неопределено) И (РезультатВопроса <> КодВозвратаДиалога.Да) Тогда
		
		ТаблицаУдаляемыхВерсий.Очистить();
		Возврат;
		
	КонецЕсли;
		
	Оповещение = Новый ОписаниеОповещения("ВыполнитьУдалениеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, СтрШаблон(Нстр("ru = 'Вы хотите удалить %1 версий. Вы уверены?'"), 
		ТаблицаУдаляемыхВерсий.Количество()), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры	

&НаКлиенте
Процедура ВыполнитьУдалениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
        
        УдалитьВыбранныеВерсии();
		ЭтаФорма.Модифицированность = Истина;
		Оповестить(Нстр("ru = 'Обработать удаление версий'"), Объект.ЭкземплярОтчета);
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеНачалоДиапазона()
	
	Если НЕ ЗначениеЗаполнено(КонецДиапазонаУдаления) Тогда
		КонецДиапазонаУдаления=НачалоДиапазонаУдаления;
		УстановитьЗначениеКонецДиапазона();
	ИначеЕсли НачалоДиапазонаУдаления.Код > КодКонцаДиапазона Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Начало диапазона не может располагаться позже конца диапазона'"));
		Возврат;
	КонецЕсли;
	
	Описание=НачалоДиапазонаУдаления;
	
	НаименованиеНачалоДиапазона = СтрШаблон(Нстр("ru = 'Версия №%1 от %2. Автор: %3'"), Формат(Описание.Код, "ЧДЦ=0; ЧН=' '; ЧГ=3,0"), 
		Формат(Описание.Дата, "ДФ=dd.MM.yyyy"), Описание.Автор);
	КодНачалаДиапазона=НачалоДиапазонаУдаления.Код;
	
	Для Каждого Строка ИЗ ОбнаруженныеВерсии Цикл
		
		Если Строка.Код>=КодНачалаДиапазона И Строка.Код<=КодКонцаДиапазона Тогда
			
			Строка.СостояниеОбъекта=1;
			
		Иначе
			
			Строка.СостояниеОбъекта=0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеКонецДиапазона()
	
	Если КонецДиапазонаУдаления.Код < КодНачалаДиапазона Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'Начало диапазона не может располагаться позже конца диапазона'"));
		Возврат;
	КонецЕсли;
	
	Описание=КонецДиапазонаУдаления;
	
	НаименованиеКонецДиапазона = СтрШаблон(Нстр("ru = 'Версия №%1 от %2. Автор: %3'"), Формат(Описание.Код, "ЧДЦ=0; ЧН=' '; ЧГ=3,0"), 
		Формат(Описание.Дата, "ДФ=dd.MM.yyyy"), Описание.Автор);
	КодКонцаДиапазона=КонецДиапазонаУдаления.Код;
	
	Для Каждого Строка ИЗ ОбнаруженныеВерсии Цикл
		
		Если Строка.Код>=КодНачалаДиапазона И Строка.Код<=КодКонцаДиапазона Тогда
			
			Строка.СостояниеОбъекта=1;
			
		Иначе
			
			Строка.СостояниеОбъекта=0;
			
		КонецЕсли;
		
	КонецЦикла;
				
КонецПроцедуры

&НаКлиенте
Процедура НачалоДиапазонаУдаленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЭкземплярОтчета", Объект.ЭкземплярОтчета);
	
	НачалоДиапазонаУдаления = Неопределено;

	Оповещение = Новый ОписаниеОповещения("НачалоДиапазонаУдаленияНачалоВыбораЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ОписаниеВерсий.Форма.ФормаВыбора", СтруктураПараметров,,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте
Процедура НачалоДиапазнаУдаленияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    НачалоДиапазонаУдаления=Результат;
    
    Если НачалоДиапазонаУдаления <> Неопределено Тогда
        УстановитьЗначениеНачалоДиапазона();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КонецДиапазонаУдаленияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("ЭкземплярОтчета",Объект.ЭкземплярОтчета);
	
	КонецДиапазонаУдаления = Неопределено;

	
	ОткрытьФорму("Справочник.ОписаниеВерсий.Форма.ФормаВыбора",СтруктураПараметров,,,,, Новый ОписаниеОповещения("КонецДиапазонаУдаленияНачалоВыбораЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
	
КонецПроцедуры

&НаКлиенте
Процедура КонецДиапазонаУдаленияНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    КонецДиапазонаУдаления=Результат;
    
    Если КонецДиапазонаУдаления <> Неопределено Тогда
        УстановитьЗначениеКонецДиапазона();
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНачалоДиапазона(Команда)
	
	НачалоДиапазонаУдаления=Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Ссылка;
	
	Если НачалоДиапазонаУдаления <> Неопределено Тогда
		УстановитьЗначениеНачалоДиапазона();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКонецДиапазона(Команда)
	
	КонецДиапазонаУдаления=Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Ссылка;
	
	Если КонецДиапазонаУдаления <> Неопределено Тогда
		УстановитьЗначениеКонецДиапазона();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбнаруженныеВерсииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="ОбнаруженныеВерсииВерсияХранимогоФайла" Тогда
		
		Если ЗначениеЗаполнено(Элементы.ОбнаруженныеВерсии.ТекущиеДанные.ВерсияХранимогоФайла) Тогда
			
			ХранимыеФайлыКлиентУХ.ОткрытьХранимыйФайлДляЧтения(,,Элементы.ОбнаруженныеВерсии.ТекущиеДанные.ВерсияХранимогоФайла);
			
		КонецЕсли;
		
	ИначеЕсли Поле.Имя="ОбнаруженныеВерсииРегистратор" Тогда
		
		Если ЗначениеЗаполнено(Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Регистратор)
			И (НЕ Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Регистратор=Объект.ЭкземплярОтчета) Тогда
			
			ПоказатьЗначение(,Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Регистратор);
			
		КонецЕсли;
		
	Иначе
		
		ПоказатьЗначение(,Элементы.ОбнаруженныеВерсии.ТекущиеДанные.Ссылка);
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсииЗначенийПоказателей(Команда)
	
	ТекущаяСтрока = Элементы.ОбнаруженныеВерсии.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Отбор", Новый Структура("Владелец", ТекущаяСтрока.Ссылка));
	
	ОткрытьФорму("Справочник.ВерсииЗначенийПоказателей.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры

