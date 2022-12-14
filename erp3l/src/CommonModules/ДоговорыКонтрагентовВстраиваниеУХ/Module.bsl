#Область ПрограммныйИнтерфейс

Функция УстановитьДоговорКонтрагента(ДоговорКонтрагента, ВладелецДоговора, ОрганизацияДоговора, СписокВидовДоговора = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт 
	
КонецФункции

Функция ПолучитьСтавкуНДСПоДоговору(Знач ДоговорКонтрагента, Знач Период = Неопределено) Экспорт
	
	ТипДоговора = ТипЗнч(ДоговорКонтрагента);		
	
	Если ТипДоговора = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		ИЛИ ТипДоговора = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "СтавкаНДС");
		
	КонецЕсли;
	
	Возврат Справочники.СтавкиНДС.ПустаяСсылка();
	
КонецФункции

Функция ДатаНачалаДействияДоговора(ДоговорКонтрагента) Экспорт
	
	ТипДоговора = ТипЗнч(ДоговорКонтрагента);		
	
	Если ТипДоговора = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
		ИЛИ ТипДоговора = Тип("СправочникСсылка.ДоговорыАренды")
		ИЛИ ТипДоговора = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
		
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ДатаНачалаДействия");
		
	ИначеЕсли ТипДоговора = Тип("СправочникСсылка.ДоговорыКредитовИДепозитов") Тогда	
		
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДоговорКонтрагента, "ДатаПервогоТранша"); 
		
	КонецЕсли;
	
	Возврат Дата(1, 1, 1);
		
КонецФункции

Функция ЕстьУчетнаяПолитикаСРаздельнымУчетомНДСНаСчете19() Экспорт
	
КонецФункции

Функция СформироватьАвтоЗначенияРеквизитовПлательщикаПолучателя(Организация, СчетОрганизации, Контрагент, СчетКонтрагента, ПеречислениеВБюджет, Дата) Экспорт
	
КонецФункции		

Функция ПлатежГосОргану(ВидОперации, Контрагент) Экспорт
	
КонецФункции		// ПлатежГосОргану()

Процедура ЗаполнитьСтрокиСчетаУчета(Строки, ИмяТабличнойЧасти, Контекст, МенеджерОбъекта, ВключаяЗаполненные = Ложь) Экспорт
	
КонецПроцедуры		// ЗаполнитьСтроки()

Функция КонтекстПлатежногоДокумента(ИсточникДанных) Экспорт
	
КонецФункции		// КонтекстПлатежногоДокумента()

Функция АдминистраторНалогаОрганизации(Налог, Организация, Период = Неопределено) Экспорт
	
КонецФункции		// АдминистраторНалогаОрганизации()

Процедура УстановитьНедоступныеВидыДоговоров(Исключения) Экспорт
	
	Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СКомиссионеромНаЗакупку);
	Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.Прочее);
	
	ИспользоватьДоговорыСКлиентами = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	
	Если Не ИспользоватьДоговорыСКлиентами Тогда
		
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СПокупателем);
		
	КонецЕсли;
	
	Если НЕ ИспользоватьДоговорыСКлиентами Или Не ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах") Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СКомиссионером);
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоИзДавальческогоСырья") Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СДавальцем);
	КонецЕсли;
	
	ИспользоватьДоговорыСПоставщиками = ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками");
	
	Если Не ИспользоватьДоговорыСПоставщиками Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СПоставщиком);
	КонецЕсли;
	
	Если Не ИспользоватьДоговорыСПоставщиками Или Не ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках") Тогда
		
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СКомитентом);
		
	КонецЕсли;
	
	Если Не ИспользоватьДоговорыСКлиентами Или Не ПолучитьФункциональнуюОпцию("ИспользоватьОказаниеАгентскихУслугПриЗакупке") Тогда
		
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СКомитентомНаЗакупку);
		
	КонецЕсли;
	
	
	Если Не ИспользоватьДоговорыСПоставщиками Или Не ПолучитьФункциональнуюОпцию("ИспользоватьИмпортныеЗакупки") Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.Импорт);
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.ВвозИзЕАЭС);
	КонецЕсли;
		
	Если Не ИспользоватьДоговорыСПоставщиками Или Не  ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранениеВПроцессеЗакупки") Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СПоклажедателем);
	КонецЕсли;
		
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьПроизводствоНаСтороне") Тогда
		Исключения.Добавить(Справочники.ВидыДоговоровКонтрагентовУХ.СПереработчиком);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОграничитьВыборРеквизитов(Форма, ЗначенияЗаполнения) Экспорт
	
	Элементы = Форма.Элементы;
	Параметры = Форма.Параметры;
	
КонецПроцедуры

Процедура НачальноеЗаполнениеВерсииСоглашения(ВерсияСоглашенияОбъект, КешОбработкиЗаполнения) Экспорт
	
КонецПроцедуры

Функция ЕстьПревышениеЛимитовПоДоговору(ДоговорСсылка) Экспорт
	
	Если Не ЗначениеЗаполнено(ДоговорСсылка) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ЗаявкаНаРасходованиеДенежныхСредств.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК ЗаявкаНаРасходованиеДенежныхСредств
	               |ГДЕ
	               |	ЗаявкаНаРасходованиеДенежныхСредств.Проведен
	               |	И ЗаявкаНаРасходованиеДенежныхСредств.Договор = &ДоговорКонтрагента
	               |	И ЗаявкаНаРасходованиеДенежныхСредств.ЕстьПревышениеЛимитов
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ЗаявкаНаРасход.Ссылка
	               |ИЗ
	               |	Документ.ЗаявкаНаРасход КАК ЗаявкаНаРасход
	               |ГДЕ
	               |	ЗаявкаНаРасход.Проведен
	               |	И ЗаявкаНаРасход.ДоговорКонтрагента = &ДоговорКонтрагента
	               |	И ЗаявкаНаРасход.ЕстьПревышениеЛимитов
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ОперативныйПланПоБюджетамОбороты.ДокументПланирования
	               |ИЗ
	               |	РегистрНакопления.ОперативныйПланПоБюджетам.Обороты(, , Период, ДоговорКонтрагента = &ДоговорКонтрагента) КАК ОперативныйПланПоБюджетамОбороты
	               |ГДЕ
	               |	ВЫРАЗИТЬ(ОперативныйПланПоБюджетамОбороты.ДокументПланирования КАК Документ.ОперативныйПлан).ЕстьПревышениеЛимитов = ИСТИНА";

	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорСсылка);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции

// Процедура содержит логику формирования структуры
// вычисляемых реквизитов договора при заполнении из версии договора,
// зависящую от учетного ядра.
//
// Параметры:
//  ВычисляемыеРеквизиты	 - 	Структура - Структура вычисляемых реквизитов.
//  ВерсияСоглашенияОбъект	 - 	ДокументОбъект.ВерсияСоглашения* - Исходный документ версии договора.
//
Процедура ЗаполнитьВычисляемыеРеквизитыДоговора(ВычисляемыеРеквизиты, ВерсияСоглашения) Экспорт
	
	ТипВерсииСоглашения = ТипЗнч(ВерсияСоглашения);
	
	ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
		Если ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияАккредитив") Тогда
			
		ОплатаВВалюте = (ВерсияСоглашения.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
			
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияБанковскаяГарантия") Тогда
		
		ОплатаВВалюте = (ВерсияСоглашения.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);

		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияВалютноПроцентныйСвоп") Тогда
		
		ОплатаВВалюте = (ВерсияСоглашения.ВалютаОрганизации <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);

		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияВалютныйСвоп") Тогда
		
		ОплатаВВалюте = (ВычисляемыеРеквизиты.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);

		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияВалютныйФорвард") Тогда
		
		ОплатаВВалюте = (ВычисляемыеРеквизиты.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияДепозит") Тогда
		
		ОплатаВВалюте = (ВерсияСоглашения.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("БанковскийСчетКомиссии", ВерсияСоглашения.БанковскийСчет);
		ВычисляемыеРеквизиты.Вставить("БанковскийСчетПроцентов", ВерсияСоглашения.БанковскийСчет);
		
		ВычисляемыеРеквизиты.Вставить("ДатаПервогоТранша", ВерсияСоглашения.ДатаНачалаДействия);
		ВычисляемыеРеквизиты.Вставить("ДатаПоследнегоПлатежа", ВерсияСоглашения.ДатаОкончанияДействия);
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
		ВычисляемыеРеквизиты.Вставить("СуммаТраншей", ВерсияСоглашения.Сумма);
		
		Если ВерсияСоглашения.КапитализацияПроцентов Тогда
			ТипДоговора = Перечисления.ТипыДоговораКредитовИДепозитов.ДепозитВБанкеСКапитализацией;
		Иначе
			ТипДоговора = Перечисления.ТипыДоговораКредитовИДепозитов.ДепозитВБанке;
		КонецЕсли;
		
		ВычисляемыеРеквизиты.Вставить("ТипДоговора", ТипДоговора);
		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияКоммерческийДоговор") Тогда
		
		ОплатаВВалюте = (ВерсияСоглашения.ОсновнаяВалютаПлатежей <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("ЗаданГрафикИсполнения", ВерсияСоглашения.СпособФормированияПлатежей = Перечисления.СпособыФормированияПлатежейПоДоговору.ПоГрафикуПлатежей);
		Если ЗначениеЗаполнено(ВерсияСоглашения.ГосударственныйКонтракт) Тогда
			ИдентификаторГосКонтракта = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияСоглашения.ГосударственныйКонтракт, "Код");
			ВычисляемыеРеквизиты.Вставить("ИдентификаторГосКонтракта", ИдентификаторГосКонтракта);
		КонецЕсли;
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
		
		ЗаполнитьГрафикИсполненияДоговора(ВычисляемыеРеквизиты, ВерсияСоглашения);
		
	ИначеЕсли ТипВерсииСоглашения = Тип("ДокументОбъект.ВерсияСоглашенияКредит") Тогда
		ОплатаВВалюте = (ВерсияСоглашения.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);		
		ВычисляемыеРеквизиты.Вставить("ОплатаВВалюте", ОплатаВВалюте);	
		
		ВычисляемыеРеквизиты.Вставить("БанковскийСчетКомиссии", ВерсияСоглашения.БанковскийСчет);
		ВычисляемыеРеквизиты.Вставить("БанковскийСчетПроцентов", ВерсияСоглашения.БанковскийСчет);
		
		ВычисляемыеРеквизиты.Вставить("ДатаПервогоТранша", ВерсияСоглашения.ДатаНачалаДействия);
		ВычисляемыеРеквизиты.Вставить("ДатаПоследнегоПлатежа", ВерсияСоглашения.ДатаОкончанияДействия);
		
		ВычисляемыеРеквизиты.Вставить("Статус", Перечисления.СтатусыДоговоровКонтрагентов.Действует);
		ВычисляемыеРеквизиты.Вставить("СуммаТраншей", ВерсияСоглашения.Сумма);
		
		Если ВерсияСоглашения.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.ЗаемПолученный
			ИЛИ ВерсияСоглашения.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.ЗаемВыданный Тогда
			
			ЭтоВнутригрупповойКонтрагент = РаботаСКонтрагентамиУХ.ЭтоВнутригрупповойКонтрагент(ВерсияСоглашения.Контрагент);
			Если ЭтоВнутригрупповойКонтрагент Тогда
				ТипДоговора = Перечисления.ТипыДоговораКредитовИДепозитов.ВнутреннийЗайм;
			Иначе
				ТипДоговора = Перечисления.ТипыДоговораКредитовИДепозитов.ВнешнийЗайм;
			КонецЕсли;
			
			ВычисляемыеРеквизиты.Вставить("ТипДоговора", ТипДоговора);
			
		Иначе
			ТипДоговора = Перечисления.ТипыДоговораКредитовИДепозитов.КредитВБанке;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру параметров для заполнения налогообложения НДС продажи.
//
// Параметры:
//  Объект - СправочникОбъект.ДоговорыКонтрагентов - договор, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
//
Функция ПараметрыЗаполненияНалогообложенияНДСПродажи(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	
	ПараметрыЗаполнения.Организация = Объект.Организация;
	ПараметрыЗаполнения.НаправлениеДеятельности = Объект.НаправлениеДеятельности;
	ПараметрыЗаполнения.Подразделение = Объект.Подразделение;

	Если Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СПокупателем Тогда
		
		ПараметрыЗаполнения.РеализацияТоваров = Истина;
		ПараметрыЗаполнения.РеализацияРаботУслуг = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СКомиссионером Тогда
		
		ПараметрыЗаполнения.ПередачаНаКомиссию = Истина;
		ПараметрыЗаполнения.ОтчетКомиссионера = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СДавальцем Тогда
		
		ПараметрыЗаполнения.ОтчетДавальцу = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СХранителем Тогда
		
		ПараметрыЗаполнения.ВыкупТоваровХранителем = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает структуру параметров для заполнения налогообложения НДС закупки.
//
// Параметры:
//  Объект - СправочникОбъект.ДоговорыКонтрагентов - договор, по которому необходимо сформировать параметры.
//
// Возвращаемое значение:
//  Структура - Параметры заполнения, описание параметров см. УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки();
//
Функция ПараметрыЗаполненияНалогообложенияНДСЗакупки(Объект) Экспорт
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСЗакупки();
	
	ПараметрыЗаполнения.Контрагент = Объект.Контрагент;

	Если Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СПоставщиком Тогда
		
		ПараметрыЗаполнения.ПриобретениеТоваров = Истина;
		ПараметрыЗаполнения.ПриобретениеРабот = Истина;
		ПараметрыЗаполнения.ПриобретениеНаСтатьи = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СПоклажедателем Тогда
		
		ПараметрыЗаполнения.ПриобретениеТоваров = Истина;
		 
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СПереработчиком Тогда
		
		ПараметрыЗаполнения.ПриобретениеРабот = Истина;
	
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.СКомитентом Тогда
		
		ПараметрыЗаполнения.ПриемНаКомиссию = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.ВвозИзЕАЭС Тогда
		
		ПараметрыЗаполнения.ВвозТоваровИзТаможенногоСоюза = Истина;
		
	ИначеЕсли Объект.ВидДоговораУХ = Справочники.ВидыДоговоровКонтрагентовУХ.Импорт Тогда
		
		ПараметрыЗаполнения.ИмпортТоваров = Истина;
		
	КонецЕсли;
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции


#Область ОбработчикиСобытийФормДоговоров

Процедура ПриСозданииНаСервереВерсииСоглашения(Форма, Отказ, СтандартнаяОбработка) Экспорт
		
КонецПроцедуры

Процедура ПриСозданииНаСервереВерсияСоглашенияКоммерческийДоговор(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ДоговорыКонтрагентовВстраиваниеУХКлиентСервер.ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(Форма);
	
	Форма.СрокОплатыПокупателей = Константы.СрокОплатыПокупателей.Получить();
	Форма.СрокОплатыПоставщикам = Константы.СрокОплатыПоставщикам.Получить();
	
	Элементы.ТипЦен.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.ВидыЦен);
	
КонецПроцедуры

Процедура ПриИзмененииКонтрагентаВерсияСоглашения(Форма) Экспорт
	
	
	
КонецПроцедуры

Процедура ПриИзмененииОрганизацииВерсияСоглашения(Форма) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийОбъектов

Процедура ОбработкаЗаполненияВерсияСоглашения(ВерсияСоглашенияОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Не ЗначениеЗаполнено(ВерсияСоглашенияОбъект.Партнер) И ЗначениеЗаполнено(ВерсияСоглашенияОбъект.Контрагент) Тогда
		ВерсияСоглашенияОбъект.Партнер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияСоглашенияОбъект.Контрагент, "Партнер")
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполненияВерсияСоглашенияКоммерческийДоговор(ВерсияСоглашенияОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Перем Ошибки;
	
	ТипДоговора = УправлениеДоговорамиУХВызовСервераПовтИсп.ВидДоговораБП(ВерсияСоглашенияОбъект.ВидДоговораУХ);
	
	Если Не ВерсияСоглашенияОбъект.УчетАгентскогоНДС Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ВидАгентскогоДоговора");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если НЕ ВерсияСоглашенияОбъект.ПлатежныйАгент Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПризнакАгента");
	КонецЕсли;
		
	ИспользоватьОформлениеЗакупок = (ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
		Или ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
		Или ТипДоговора = Перечисления.ТипыДоговоров.Импорт);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУправлениеДоставкой")
		Или ВерсияСоглашенияОбъект.СпособДоставки = Перечисления.СпособыДоставки.ОпределяетсяВРаспоряжении
		Или Не ИспользоватьОформлениеЗакупок Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СпособДоставки");
		МассивНепроверяемыхРеквизитов.Добавить("ПеревозчикПартнер");
		МассивНепроверяемыхРеквизитов.Добавить("АдресДоставкиПеревозчика");
	КонецЕсли;
	
	ДоставкаТоваров.ПроверитьЗаполнениеРеквизитовДоставки(ВерсияСоглашенияОбъект, МассивНепроверяемыхРеквизитов, Отказ);
	
	Если ВерсияСоглашенияОбъект.НалогообложениеНДСОпределяетсяВДокументе 
		ИЛИ ТипДоговора = Перечисления.ТипыДоговоров.Импорт Или
		ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НалогообложениеНДС");
	КонецЕсли;
	
	Если ВерсияСоглашенияОбъект.ЗакупкаПодДеятельностьОпределяетсяВДокументе
		ИЛИ (ТипДоговора <> Перечисления.ТипыДоговоров.СПоставщиком
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПереработчиком
			И ТипДоговора <> Перечисления.ТипыДоговоров.СПоклажедателем) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЗакупкаПодДеятельность");
	КонецЕсли;
	
	Если ТипДоговора <> Перечисления.ТипыДоговоров.СПоклажедателем Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокОформленияСписанияНедостачПринятыхНаХранениеТоваров");
	КонецЕсли;	
	
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
КонецПроцедуры

#КонецОбласти

Функция ТекстЗапросаВсеОбъектыРасчетов() Экспорт
	
	Возврат 
		"ВЫБРАТЬ
		|	ВерсииРасчетовСрезПоследних.ПредметГрафика КАК ПредметГрафика,
		|	ВерсииРасчетовСрезПоследних.ВерсияГрафика КАК Регистратор
		|ПОМЕСТИТЬ ВТ_Сделки
		|ИЗ
		|	РегистрСведений.ВерсииРасчетов.СрезПоследних КАК ВерсииРасчетовСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДоговорыКонтрагентов.Ссылка КАК Ссылка
		|		ИЗ
		|			Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ГДЕ
		|			ДоговорыКонтрагентов.СпособФормированияПлатежей = ЗНАЧЕНИЕ(Перечисление.СпособыФормированияПлатежейПоДоговору.ПоГрафикуПлатежей)
		|			И ДоговорыКонтрагентов.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ДоговорыКредитовИДепозитов.Ссылка
		|		ИЗ
		|			Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
		|		ГДЕ
		|			ДоговорыКредитовИДепозитов.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ДоговорыАренды.Ссылка
		|		ИЗ
		|			Справочник.ДоговорыАренды КАК ДоговорыАренды
		|		ГДЕ
		|			ДоговорыАренды.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ЗаказПоставщику.Ссылка
		|		ИЗ
		|			Документ.ЗаказПоставщику КАК ЗаказПоставщику
		|		ГДЕ
		|			ЗаказПоставщику.Проведен
		|			И ЗаказПоставщику.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ЦенныеБумаги.Ссылка
		|		ИЗ
		|			Справочник.ЦенныеБумаги КАК ЦенныеБумаги
		|		ГДЕ
		|			НЕ ЦенныеБумаги.ЭтоГруппа
		|			И ЦенныеБумаги.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			РеестрУступленныхДенежныхТребований.Ссылка
		|		ИЗ
		|			Документ.РеестрУступленныхДенежныхТребований КАК РеестрУступленныхДенежныхТребований
		|		ГДЕ
		|			РеестрУступленныхДенежныхТребований.Проведен
		|			И РеестрУступленныхДенежныхТребований.РежимАктуализацииЗаявок = ЗНАЧЕНИЕ(Перечисление.РежимыАктуализацииЗаявокПоГрафикам.ПоНастройкамСистемы)) КАК ОбъектыРасчетов
		|		ПО ВерсииРасчетовСрезПоследних.ПредметГрафика = ОбъектыРасчетов.Ссылка";
	
КонецФункции

Функция ИмяТаблицыСправочникаДоговорыКредитовИДепозитов() Экспорт
	 Возврат "Справочник.ДоговорыКредитовИДепозитов";
КонецФункции
#КонецОбласти

#Область УнификацияРешений

Функция ПодготовитьСписокРазрешенныхВалют(ВалютаРегламентированногоУчета, ВсеКромеВалютыРеглУчета) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", ВалютаРегламентированногоУчета);
	Запрос.УстановитьПараметр("ВсеКромеВалютыРеглУчета", ВсеКромеВалютыРеглУчета);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Валюты.Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	(Валюты.Ссылка <> &ВалютаРегламентированногоУчета и &ВсеКромеВалютыРеглУчета)
	|	ИЛИ (Валюты.Ссылка = &ВалютаРегламентированногоУчета и НЕ &ВсеКромеВалютыРеглУчета)";
	
	ВыборкаИзЗапроса = Запрос.Выполнить().Выбрать();
	
	ВозвращаемыйМассив = Новый Массив;
	
	Пока ВыборкаИзЗапроса.Следующий() Цикл
		ВозвращаемыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", ВыборкаИзЗапроса.Ссылка));
	КонецЦикла;
	
	Если ВозвращаемыйМассив.Количество() = 0 Тогда
		ВозвращаемыйМассив.Добавить(Новый ПараметрВыбора("Отбор.Ссылка", Справочники.Валюты.ПустаяСсылка()));
	КонецЕсли;
	
	Возврат ВозвращаемыйМассив;
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьГрафикИсполненияДоговора(ВычисляемыеРеквизиты, ВерсияСоглашения)
	
	ВычисляемыеРеквизиты.Вставить(
		"ЗаданГрафикИсполнения",
		РаботаСДоговорамиКонтрагентовЕХ.НуженГрафикИсполнения(
			ВерсияСоглашения.ВидДоговораУХ,
			ВерсияСоглашения.ПорядокРасчетов,
			ВерсияСоглашения.СпособФормированияПлатежей)
	);
	
	Договор = ВерсияСоглашения.ДополнительныеСвойства.ДоговорОбъект;
	
	ВерсияПроведена = ВерсияСоглашения.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Проведение
		ИЛИ (ВерсияСоглашения.ДополнительныеСвойства.РежимЗаписи = РежимЗаписиДокумента.Запись И ВерсияСоглашения.Проведен);
	
	Если ВычисляемыеРеквизиты.ЗаданГрафикИсполнения И ВерсияПроведена Тогда
		
		Если ЗначениеЗаполнено(ВерсияСоглашения.ДоговорКонтрагента) Тогда
			// существующий график обновить
			ГрафикСсылка = ВерсияСоглашения.ДополнительныеСвойства.ДоговорОбъект.ГрафикИсполненияДоговора;
		Иначе
			// новый график
			ГрафикСсылка = неопределено;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ГрафикСсылка) Тогда
			ГрафикОбъект = ГрафикСсылка.ПолучитьОбъект();
		Иначе
			ГрафикОбъект = Документы.ГрафикИсполненияДоговора.СоздатьДокумент();
		КонецЕсли;
		
		ГрафикОбъект.Дата = ТекущаяДатаСеанса();
		ГрафикОбъект.Договор = ВерсияСоглашения.ДоговорКонтрагента;
		ГрафикОбъект.ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов;
		
		ГрафикОбъект.ЭтапыГрафикаИсполненияДоговора.Очистить();
		
		СуммаДоговора = Договор.Сумма;
		Для Каждого СтрокаГрафикаСоглашения Из ВерсияСоглашения.ГрафикРасчетов Цикл
			
			Если СтрокаГрафикаСоглашения.Сумма = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ГрафикОбъект.ЭтапыГрафикаИсполненияДоговора.Добавить();
			НоваяСтрока.ДатаПоГрафику = СтрокаГрафикаСоглашения.Дата;
			Если СтрокаГрафикаСоглашения.ВидБюджета = ПланыВидовХарактеристик.ВидыБюджетов.БюджетДвиженияДенежныхСредств Тогда
				НоваяСтрока.СуммаОплаты = СтрокаГрафикаСоглашения.Сумма;
				Если СуммаДоговора <> 0 Тогда
					НоваяСтрока.ПроцентОплаты = НоваяСтрока.СуммаОплаты * 100 / СуммаДоговора;
				КонецЕсли;
			Иначе
				НоваяСтрока.СуммаИсполнения = СтрокаГрафикаСоглашения.Сумма;
				Если СуммаДоговора <> 0 Тогда
					НоваяСтрока.ПроцентИсполнения = НоваяСтрока.СуммаИсполнения * 100 / СуммаДоговора;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ГрафикОбъект.ЭтоНовый() Тогда
			ВычисляемыеРеквизиты.Вставить("ГрафикИсполненияДоговора", Документы.ГрафикИсполненияДоговора.ПолучитьСсылку());
			ГрафикОбъект.УстановитьСсылкуНового(ВычисляемыеРеквизиты.ГрафикИсполненияДоговора);
		Иначе
			ВычисляемыеРеквизиты.Вставить("ГрафикИсполненияДоговора", ГрафикОбъект.Ссылка);
		КонецЕсли;
		
		ВыполнитьОбработкуДопОбъекта(ВерсияСоглашения, ГрафикОбъект, "ПровестиНеОперативно");
		
	Иначе
		ВычисляемыеРеквизиты.Вставить("ГрафикИсполненияДоговора", неопределено);
		
		Если ЗначениеЗаполнено(Договор.ГрафикИсполненияДоговора) Тогда
			ГрафикОбъект = Договор.ГрафикИсполненияДоговора.ПолучитьОбъект();
			ВыполнитьОбработкуДопОбъекта(ВерсияСоглашения, ГрафикОбъект, "УстановитьПометкуУдаления");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьОбработкуДопОбъекта(ВерсияСоглашенияОбъект, ДопОбъект, Действие)
	
	Данные = Новый Структура("Объект, Действие", ДопОбъект, Действие);
	ВерсияСоглашенияОбъект.ДополнительныеСвойства.ДополнительныеОбъекты.Добавить(Данные);
	
КонецПроцедуры

#КонецОбласти
