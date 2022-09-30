#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьОбъект(Объект, СтруктураПараметров) Экспорт
	
	ЗаполнениеДокументов.Заполнить(Объект, СтруктураПараметров);
	
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ПериодПоСКНП", Объект.ПериодПоСКНП);
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
	ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если СтруктураПараметров.ФорматПоПостановлению735 Тогда
		Объект.ДополнительныеСвойства.Вставить("АдресДанныхДляПередачи", АдресХранилища);
	Иначе
		
		Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ТабличнаяЧасть") Тогда
			Объект.ТабличнаяЧасть.Загрузить(СтруктураДанных.ТабличнаяЧасть);
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("РеквизитыДокумента") Тогда
			ЗаполнитьЗначенияСвойств(Объект, СтруктураДанных.РеквизитыДокумента);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаполнения(ПараметрыДляЗаполнения, АдресХранилища) Экспорт
	
	НачалоНалоговогоПериода = УчетНДСПереопределяемый.НачалоНалоговогоПериода(
		ПараметрыДляЗаполнения.Организация, ПараметрыДляЗаполнения.НалоговыйПериод);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НачалоПериода",
		?(ПараметрыДляЗаполнения.ФорматПоПостановлению735, 
			НачалоКвартала(ПараметрыДляЗаполнения.НалоговыйПериод), НачалоДня(ПараметрыДляЗаполнения.Дата)));
	СтруктураПараметров.Вставить("КонецПериода",
		?(ПараметрыДляЗаполнения.ФорматПоПостановлению735, 
			КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод),  КонецДня(ПараметрыДляЗаполнения.Дата)));
		
	СтруктураПараметров.Вставить("Организация",                 ПараметрыДляЗаполнения.Организация);
	СтруктураПараметров.Вставить("НачалоНалоговогоПериода",     НачалоНалоговогоПериода);
	СтруктураПараметров.Вставить("КонецНалоговогоПериода",      КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
	СтруктураПараметров.Вставить("ФорматПоПостановлению735",    ПараметрыДляЗаполнения.ФорматПоПостановлению735);
	СтруктураПараметров.Вставить("ПериодПоСКНП",                ПараметрыДляЗаполнения.ПериодПоСКНП);
	
	СтруктураПараметров.Вставить("ФормироватьДополнительныеЛисты",      Истина);
	СтруктураПараметров.Вставить("ДополнительныеЛистыЗаТекущийПериод",  Истина);
	СтруктураПараметров.Вставить("ГруппироватьПоКонтрагентам",          Ложь);
	СтруктураПараметров.Вставить("КонтрагентДляОтбора",                 Справочники.Контрагенты.ПустаяСсылка());
	СтруктураПараметров.Вставить("ВыводитьТолькоДопЛисты",              Истина);
	СтруктураПараметров.Вставить("ВыводитьПокупателейПоАвансам",        Ложь);
	СтруктураПараметров.Вставить("ВключатьОбособленныеПодразделения",   Истина);
	СтруктураПараметров.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
	СтруктураПараметров.Вставить("ОтбиратьПоКонтрагенту",               Ложь);
	СтруктураПараметров.Вставить("ВыводитьПродавцовПоАвансам",          Ложь);
	
	СтруктураПараметров.Вставить("СписокОрганизаций",
		ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(СтруктураПараметров.Организация));
	СтруктураПараметров.Вставить("ДатаФормированияДопЛиста");
	СтруктураПараметров.Вставить("ЗаполнениеДокумента",  Истина);
	СтруктураПараметров.Вставить("ЗаполнениеДекларации", Ложь);
	СтруктураПараметров.Вставить("ЭтоКнигаПродаж",       Ложь);
	
	ПроверкаКонтрагентов.ДобавитьОбщиеПараметрыДляПроверкиКонтрагентовВОтчете(СтруктураПараметров);
	
	Если НЕ ПараметрыДляЗаполнения.ФорматПоПостановлению735 Тогда
		СтруктураПараметров.Вставить("ТабличнаяЧасть",
			Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ПустаяСсылка().ТабличнаяЧасть.ВыгрузитьКолонки());
		РеквизитыДокумента = Новый Структура("ВсегоПокупокДо,СуммаБезНДС10До,НДС10До,СуммаБезНДС18До,НДС18До,НДС0До,СуммаСовсемБезНДСДо,
		|ВсегоПокупок,СуммаБезНДС10,НДС10,СуммаБезНДС18,НДС18,НДС0,СуммаСовсемБезНДС,НДС");
		
		ПараметрыДляИтогов = Новый Структура;
		
		ПараметрыДляИтогов.Вставить("Организация",              ПараметрыДляЗаполнения.Организация);
		ПараметрыДляИтогов.Вставить("СписокОрганизаций");
		ПараметрыДляИтогов.Вставить("КонецНалоговогоПериода",   КонецКвартала(ПараметрыДляЗаполнения.НалоговыйПериод));
		ПараметрыДляИтогов.Вставить("НалоговыйПериод",          ПараметрыДляЗаполнения.НалоговыйПериод);
		ПараметрыДляИтогов.Вставить("ДатаФормированияДопЛиста", ПараметрыДляЗаполнения.Дата);
		ПараметрыДляИтогов.Вставить("Ссылка",                   ПараметрыДляЗаполнения.Ссылка);
		
		ИтогЗаПериод = Документы.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ПолучитьИтогиЗаПериодКнигаПокупок(ПараметрыДляИтогов);
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ИтогЗаПериод);
		
		// Заполнение итогов по книге
		
		РеквизитыДокумента.Вставить("ВсегоПокупокДо", ИтогЗаПериод.ВсегоПокупок);
		РеквизитыДокумента.Вставить("СуммаБезНДС10До", ИтогЗаПериод.СуммаБезНДС10);
		РеквизитыДокумента.Вставить("НДС10До", ИтогЗаПериод.НДС10);
		РеквизитыДокумента.Вставить("СуммаБезНДС18До", ИтогЗаПериод.СуммаБезНДС18);
		РеквизитыДокумента.Вставить("НДС18До", ИтогЗаПериод.НДС18);
		РеквизитыДокумента.Вставить("НДС0До", ИтогЗаПериод.НДС0);
		РеквизитыДокумента.Вставить("СуммаСовсемБезНДСДо", ИтогЗаПериод.СуммаСовсемБезНДС);
		
		СтруктураПараметров.Вставить("РеквизитыДокумента", РеквизитыДокумента);
	КонецЕсли;
	
	Отчеты.КнигаПокупок.СформироватьОтчет(СтруктураПараметров, АдресХранилища);

КонецПроцедуры

Процедура ВосстановитьДанныеДляОтправки(ПараметрыВосстановления,АдресХранилища) Экспорт
	
	ПредставлениеОтчета = Новый ТабличныйДокумент;
	
	ДокументСсылка = ПараметрыВосстановления.ДокументСсылка;
	ПоместитьВоВременноеХранилище(ДокументСсылка.ПредставлениеОтчета.Получить(), АдресХранилища);
	
КонецПроцедуры

Функция ПолучитьИтогиЗаПериодКнигаПокупок(СтруктураПараметров) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДополнительныйЛистКнигиПокупок.ВсегоПокупок,
	|	ДополнительныйЛистКнигиПокупок.СуммаБезНДС18,
	|	ДополнительныйЛистКнигиПокупок.НДС18,
	|	ДополнительныйЛистКнигиПокупок.СуммаБезНДС10,
	|	ДополнительныйЛистКнигиПокупок.НДС10,
	|	ДополнительныйЛистКнигиПокупок.НДС0,
	|	ДополнительныйЛистКнигиПокупок.СуммаБезНДС20,
	|	ДополнительныйЛистКнигиПокупок.НДС20,
	|	ДополнительныйЛистКнигиПокупок.СуммаСовсемБезНДС,
	|	ДополнительныйЛистКнигиПокупок.Дата КАК Дата,
	|	ДополнительныйЛистКнигиПокупок.Ссылка
	|ПОМЕСТИТЬ ПоследнийДополнительныйЛист
	|ИЗ
	|	Документ.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде КАК ДополнительныйЛистКнигиПокупок
	|ГДЕ
	|	ДополнительныйЛистКнигиПокупок.Организация = &Организация
	|	И ДополнительныйЛистКнигиПокупок.НалоговыйПериод = &НалоговыйПериод
	|	И ДополнительныйЛистКнигиПокупок.Дата < &Дата
	|	И ДополнительныйЛистКнигиПокупок.Ссылка <> &ТекущийДокумент
	|	И ДополнительныйЛистКнигиПокупок.Проведен
	|	И НЕ ДополнительныйЛистКнигиПокупок.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПокупок.ВсегоПокупок,
	|	КнигаПокупок.СуммаБезНДС18,
	|	КнигаПокупок.НДС18,
	|	КнигаПокупок.СуммаБезНДС10,
	|	КнигаПокупок.НДС10,
	|	КнигаПокупок.НДС0,
	|	КнигаПокупок.СуммаБезНДС20,
	|	КнигаПокупок.НДС20,
	|	КнигаПокупок.СуммаСовсемБезНДС,
	|	КнигаПокупок.Дата
	|ПОМЕСТИТЬ КнигаПокупокЗаКорректируемыйПериод
	|ИЗ
	|	Документ.КнигаПокупокДляПередачиВЭлектронномВиде КАК КнигаПокупок
	|ГДЕ
	|	КнигаПокупок.Организация = &Организация
	|	И КнигаПокупок.НалоговыйПериод = &НалоговыйПериод
	|	И КнигаПокупок.Проведен
	|	И НЕ КнигаПокупок.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПоследнийДополнительныйЛист.ВсегоПокупок КАК ВсегоПокупок,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС18,
	|	ПоследнийДополнительныйЛист.НДС18,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС10,
	|	ПоследнийДополнительныйЛист.НДС10,
	|	ПоследнийДополнительныйЛист.НДС0,
	|	ПоследнийДополнительныйЛист.СуммаБезНДС20,
	|	ПоследнийДополнительныйЛист.НДС20,
	|	ПоследнийДополнительныйЛист.СуммаСовсемБезНДС,
	|	ПоследнийДополнительныйЛист.Дата КАК ДатаОформления,
	|	0 КАК НДС
	|ИЗ
	|	ПоследнийДополнительныйЛист КАК ПоследнийДополнительныйЛист
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	КнигаПокупокЗаКорректируемыйПериод.ВсегоПокупок,
	|	КнигаПокупокЗаКорректируемыйПериод.СуммаБезНДС18,
	|	КнигаПокупокЗаКорректируемыйПериод.НДС18,
	|	КнигаПокупокЗаКорректируемыйПериод.СуммаБезНДС10,
	|	КнигаПокупокЗаКорректируемыйПериод.НДС10,
	|	КнигаПокупокЗаКорректируемыйПериод.НДС0,
	|	КнигаПокупокЗаКорректируемыйПериод.СуммаБезНДС20,
	|	КнигаПокупокЗаКорректируемыйПериод.НДС20,
	|	КнигаПокупокЗаКорректируемыйПериод.СуммаСовсемБезНДС,
	|	КнигаПокупокЗаКорректируемыйПериод.Дата,
	|	0
	|ИЗ
	|	КнигаПокупокЗаКорректируемыйПериод КАК КнигаПокупокЗаКорректируемыйПериод";
			 
	Запрос.УстановитьПараметр("Организация", СтруктураПараметров.Организация);
	Запрос.УстановитьПараметр("НалоговыйПериод", СтруктураПараметров.НалоговыйПериод);
	Запрос.УстановитьПараметр("Дата", СтруктураПараметров.ДатаФормированияДопЛиста);
	Запрос.УстановитьПараметр("ТекущийДокумент", СтруктураПараметров.Ссылка);
	
	ИтогЗаПериод = Запрос.Выполнить();
	
	Если НЕ ИтогЗаПериод.Пустой() Тогда
		
		Возврат ИтогЗаПериод.Выгрузить()[0];
		
	Иначе
		
		// Получим итоги по данным информационной базы
		Возврат Отчеты.КнигаПокупок.ПолучитьИтогиЗаПериодКнигаПокупок(СтруктураПараметров);
			
		
	КонецЕсли;
	
КонецФункции	

// Функция поиска документов, относящихся к выбранному налоговому периоду.
//
// Параметры:
//  Организация      - СправочникСсылка.Организации.
//  НалоговыйПериод  - Дата - налоговый период.
//  Дата             - Дата - дата документа.
//  Позиция          - Число (1,0) - позиция искомого документа:
//                    -1 - до даты текущего;
//                     0 - на дату текущего;
//                     1 - после даты текущего;
//                     2 - искать только по налоговому периоду.
//
// Возвращаемое значение:
//  Массив, Неопределено - упорядоченный по дате массив найденных документов.
//
Функция НайтиДокументыЗаНалоговыйПериод(Организация, НалоговыйПериод, Дата, Позиция = 0) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НалоговыйПериод) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",				Организация);
	Запрос.УстановитьПараметр("ДатаНачала",					НачалоДня(Дата));
	Запрос.УстановитьПараметр("ДатаКонца",					КонецДня(Дата));
	Запрос.УстановитьПараметр("НачалоНалоговогоПериода",	НачалоКвартала(НалоговыйПериод));
	Запрос.УстановитьПараметр("КонецНалоговогоПериода",		КонецКвартала(НалоговыйПериод));
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Дата КАК Дата,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде КАК ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде
	|ГДЕ
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Организация = &Организация
	|	И ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НалоговыйПериод >= &НачалоНалоговогоПериода
	|	И ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НалоговыйПериод <= &КонецНалоговогоПериода
	|	И НЕ ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ПометкаУдаления
	|	И &УсловиеПоДате
	|
	|УПОРЯДОЧИТЬ ПО
	|	Дата";
	
	Если Позиция = -1 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Дата < &ДатаНачала");
	ИначеЕсли Позиция = 1 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Дата > &ДатаКонца");
	ИначеЕсли Позиция = 2 Тогда
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"ИСТИНА");
	Иначе
		Запрос.Текст	= СтрЗаменить(Запрос.Текст, "&УсловиеПоДате", 
			"(ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Дата МЕЖДУ &ДатаНачала И &ДатаКонца)");
	КонецЕсли;
		
	Результат	= Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивДокументов	= Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;

КонецФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Печать дополнительного листа книги покупок
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ДополнительныйЛистКнигиПокупок";
	КомандаПечати.Представление = НСтр("ru = 'Печать дополнительного листа книги покупок';
										|en = 'Print additional purchase ledger sheet'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Обработчик    = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ДополнительныйЛистКнигиПокупок",
		НСтр("ru = 'Доп. лист книги покупок';
			|en = 'Additional purchase ledger sheet'"),
		ПечатьДополнительногоЛистаКнигиПокупок(МассивОбъектов, ОбъектыПечати));
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
КонецПроцедуры

Функция ПечатьДополнительногоЛистаКнигиПокупок(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТабличнаяЧастьДопЛиста.НомерСтроки,
	|	ТабличнаяЧастьДопЛиста.ДатаНомер,
	|	ТабличнаяЧастьДопЛиста.НомерДатаИсправления,
	|	ТабличнаяЧастьДопЛиста.НомерДатаКорректировки,
	|	ТабличнаяЧастьДопЛиста.НомерДатаИсправленияКорректировки,
	|	ТабличнаяЧастьДопЛиста.ДатаОплаты,
	|	ТабличнаяЧастьДопЛиста.ДатаОприходования,
	|	ТабличнаяЧастьДопЛиста.Продавец,
	|	ТабличнаяЧастьДопЛиста.ПродавецИНН,
	|	ТабличнаяЧастьДопЛиста.ПродавецКПП,
	|	ТабличнаяЧастьДопЛиста.НомерГТД,
	|	ТабличнаяЧастьДопЛиста.ВсегоПокупок,
	|	ТабличнаяЧастьДопЛиста.СуммаБезНДС18,
	|	ТабличнаяЧастьДопЛиста.НДС18,
	|	ТабличнаяЧастьДопЛиста.СуммаБезНДС10,
	|	ТабличнаяЧастьДопЛиста.НДС10,
	|	ТабличнаяЧастьДопЛиста.НДС0,
	|	ТабличнаяЧастьДопЛиста.СуммаСовсемБезНДС,
	|	ТабличнаяЧастьДопЛиста.Ном,
	|	ТабличнаяЧастьДопЛиста.СчетФактура,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Организация КАК Организация,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Организация.ИНН КАК ОрганизацияИНН,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Организация.КПП КАК ОрганизацияКПП,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НалоговыйПериод КАК НалоговыйПериод,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ВсегоПокупок КАК ВсегоПокупокИтог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаБезНДС18 КАК СуммаБезНДС18Итог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС18 КАК НДС18Итог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаБезНДС10 КАК СуммаБезНДС10Итог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС10 КАК НДС10Итог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС0 КАК НДС0Итог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаСовсемБезНДС КАК СуммаСовсемБезНДСИтог,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ВсегоПокупокДо КАК ВсегоПокупокИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаБезНДС18До КАК СуммаБезНДС18ИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС18До КАК НДС18ИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаБезНДС10До КАК СуммаБезНДС10ИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС10До КАК НДС10ИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НДС0До КАК НДС0ИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.СуммаСовсемБезНДСДо КАК СуммаСовсемБезНДСИтогДо,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Ссылка КАК Ссылка,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Дата КАК Дата,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.НомерДополнительногоЛиста КАК НомерДополнительногоЛиста,
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ПредставлениеОтчета КАК ПредставлениеОтчета
	|ИЗ
	|	Документ.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде КАК ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.ТабличнаяЧасть КАК ТабличнаяЧастьДопЛиста
	|		ПО (ТабличнаяЧастьДопЛиста.Ссылка = ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Ссылка)
	|ГДЕ
	|	ДопЛистКнигиПокупокДляПередачиВЭлектронномВиде.Ссылка В(&МассивОбъектов)
	|ИТОГИ
	|	МАКСИМУМ(Организация),
	|	МАКСИМУМ(ОрганизацияИНН),
	|	МАКСИМУМ(ОрганизацияКПП),
	|	МАКСИМУМ(НалоговыйПериод),
	|	МАКСИМУМ(ВсегоПокупокИтог),
	|	МАКСИМУМ(СуммаБезНДС18Итог),
	|	МАКСИМУМ(НДС18Итог),
	|	МАКСИМУМ(СуммаБезНДС10Итог),
	|	МАКСИМУМ(НДС10Итог),
	|	МАКСИМУМ(НДС0Итог),
	|	МАКСИМУМ(СуммаСовсемБезНДСИтог),
	|	МАКСИМУМ(ВсегоПокупокИтогДо),
	|	МАКСИМУМ(СуммаБезНДС18ИтогДо),
	|	МАКСИМУМ(НДС18ИтогДо),
	|	МАКСИМУМ(СуммаБезНДС10ИтогДо),
	|	МАКСИМУМ(НДС10ИтогДо),
	|	МАКСИМУМ(НДС0ИтогДо),
	|	МАКСИМУМ(СуммаСовсемБезНДСИтогДо),
	|	МАКСИМУМ(Ссылка),
	|	МАКСИМУМ(Дата),
	|	МАКСИМУМ(НомерДополнительногоЛиста)
	|ПО
	|	Ссылка";
	
	Результат = Запрос.Выполнить();
		
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ДополнительныйЛистКнигиПокупок";
		
	ПервыйДокумент = Истина;
		
	ВыборкаПоОбъектам = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоОбъектам.Следующий() Цикл
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;

		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ВыборкаТабличнойЧасти = ВыборкаПоОбъектам.Выбрать();
		
		Если ВыборкаТабличнойЧасти.Количество() = 0 Тогда

			Продолжить;
			
		КонецЕсли;
		
		ВерсияПостановленияНДС1137 = УчетНДСПереопределяемый.ВерсияПостановленияНДС1137(ВыборкаПоОбъектам.НалоговыйПериод);
		Если ВерсияПостановленияНДС1137 = 1 Тогда
			Макет = ПолучитьОбщийМакет("ДополнительныйЛистКнигиПокупок1137");
		ИначеЕсли ВерсияПостановленияНДС1137 = 2 Тогда
			Макет = ПолучитьОбщийМакет("ДополнительныйЛистКнигиПокупок952");
		Иначе
			ПредставлениеОтчета = ВыборкаПоОбъектам.ПредставлениеОтчета.Получить();
			Если ПредставлениеОтчета <> Неопределено Тогда 
				ТабличныйДокумент.Вывести(ПредставлениеОтчета);
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Секция = Макет.ПолучитьОбласть("Строка");
		СтрокаИтого = Макет.ПолучитьОбласть("Итого");
		СтрокаВсего = Макет.ПолучитьОбласть("Всего");
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("НалоговыйПериод", ВыборкаПоОбъектам.НалоговыйПериод);
		СтруктураПараметров.Вставить("КонецНалоговогоПериода", КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("СформироватьОтчетПоСтандартнойФорме", Истина);
		СтруктураПараметров.Вставить("ОтбиратьПоКонтрагенту", Ложь);
		СтруктураПараметров.Вставить("КонтрагентДляОтбора");
		СтруктураПараметров.Вставить("ГруппироватьПоКонтрагентам", Ложь); 
		СтруктураПараметров.Вставить("Организация", ВыборкаПоОбъектам.Организация);
		СтруктураПараметров.Вставить("ДатаОформления", ВыборкаПоОбъектам.Дата);
		СтруктураПараметров.Вставить("ЗаполнениеДокумента", Истина);
		СтруктураПараметров.Вставить("ДополнительныеЛистыЗаТекущийПериод", Истина);
		
		СтруктураПараметров.Вставить("НачалоПериода", НачалоКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("КонецПериода", КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		СтруктураПараметров.Вставить("ДатаФормированияДопЛиста", ВыборкаПоОбъектам.Дата);
		СтруктураПараметров.Вставить("СписокОрганизаций", ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьСписокОбособленныхПодразделений(ВыборкаПоОбъектам.Организация));
		
		УчетНДС.ВывестиШапкуДопЛиста(ТабличныйДокумент, Макет, СтруктураПараметров, ВыборкаПоОбъектам.НомерДополнительногоЛиста);
		
		ИтогЗаПериод = Новый Структура;
		ИтогЗаПериод.Вставить("ВсегоПокупок", ВыборкаПоОбъектам.ВсегоПокупокИтогДо);
		ИтогЗаПериод.Вставить("СуммаБезНДС10", ВыборкаПоОбъектам.СуммаБезНДС10ИтогДо);
		ИтогЗаПериод.Вставить("НДС10", ВыборкаПоОбъектам.СуммаБезНДС10ИтогДо);
		ИтогЗаПериод.Вставить("СуммаБезНДС18", ВыборкаПоОбъектам.СуммаБезНДС18ИтогДо);
		ИтогЗаПериод.Вставить("НДС18", ВыборкаПоОбъектам.НДС18ИтогДо);
		ИтогЗаПериод.Вставить("НДС0", ВыборкаПоОбъектам.НДС0ИтогДо);
		ИтогЗаПериод.Вставить("СуммаСовсемБезНДС", ВыборкаПоОбъектам.СуммаСовсемБезНДСИтогДо);
		
		СтрокаИтого.Параметры.Заполнить(ИтогЗаПериод);
		ТабличныйДокумент.Вывести(СтрокаИтого);
		
		СтруктураСекций = Новый Структура("СекцияСтрока", Макет.ПолучитьОбласть("Строка"));
		ПараметрыСтроки = СтруктураСекций.СекцияСтрока.Параметры;

		Пока ВыборкаТабличнойЧасти.Следующий() Цикл
			
			Секция.Параметры.Заполнить(ВыборкаТабличнойЧасти);
			ТабличныйДокумент.Вывести(Секция);		
			
		КонецЦикла;	
		
		ВсегоЗаПериод = Новый Структура;
		ВсегоЗаПериод.Вставить("ВсегоПокупок", ВыборкаПоОбъектам.ВсегоПокупокИтог);
		ВсегоЗаПериод.Вставить("СуммаБезНДС10", ВыборкаПоОбъектам.СуммаБезНДС10Итог);
		ВсегоЗаПериод.Вставить("НДС10", ВыборкаПоОбъектам.СуммаБезНДС10Итог);
		ВсегоЗаПериод.Вставить("СуммаБезНДС18", ВыборкаПоОбъектам.СуммаБезНДС18Итог);
		ВсегоЗаПериод.Вставить("НДС18", ВыборкаПоОбъектам.НДС18Итог);
		ВсегоЗаПериод.Вставить("НДС0", ВыборкаПоОбъектам.НДС0Итог);
		ВсегоЗаПериод.Вставить("СуммаСовсемБезНДС", ВыборкаПоОбъектам.СуммаСовсемБезНДСИтог);
				
		СтрокаВсего.Параметры.Заполнить(ВсегоЗаПериод);
		ТабличныйДокумент.Вывести(СтрокаВсего);

		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаПоОбъектам.Организация, КонецКвартала(ВыборкаПоОбъектам.НалоговыйПериод));
		Если ОбщегоНазначенияБПВызовСервераПовтИсп.ЭтоЮрЛицо(ВыборкаПоОбъектам.Организация) Тогда
			ИмяОрг = "";
			Свидетельство = "";
		Иначе
			ИмяОрг = ОтветственныеЛица.РуководительПредставление;
			СведенияОЮрФизЛице = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаПоОбъектам.Организация);
			Свидетельство = СведенияОЮрФизЛице.Свидетельство;
		КонецЕсли;
		
		Секция = Макет.ПолучитьОбласть("Подвал");
		Секция.Параметры.ИмяРук        = ОтветственныеЛица.РуководительПредставление;
		Секция.Параметры.ИмяОрг        = ИмяОрг;
		Секция.Параметры.Свидетельство = Свидетельство;
		
		ТабличныйДокумент.Вывести(Секция);
		
		УправлениеКолонтитулами.УстановитьКолонтитулы(ТабличныйДокумент);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент,
			НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоОбъектам.Ссылка);

	КонецЦикла;	

	Возврат ТабличныйДокумент;
	
КонецФункции	

#КонецОбласти

#КонецОбласти

#КонецЕсли