#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает параметры проверки правил отражения
//
// Возвращаемое значение:
// 	Структура - Параметры проверки:
// 		* ПланСчетов - СправочникСсылка.ПланыСчетовМеждународногоУчета - Отбор плана счетов для проверки. Если Неопределено, то по всем.
// 		* Организация - СправочникСсылка.Организации - Отбор организации для проверки. Если Неопределено, то по всем.
// 		* Документ - ДокументСсылка - Отбор документа для проверки. Если Неопределено, то по всем.
//
Функция ПараметрыПроверкиПравилОтражения() Экспорт
	
	ПараметрыПроверки = Новый Структура;
	ПараметрыПроверки.Вставить("ПланСчетов");
	ПараметрыПроверки.Вставить("Организация");
	ПараметрыПроверки.Вставить("Документ");
	
	Возврат ПараметрыПроверки;
	
КонецФункции


// Выполняет проверку настройки правил отражения в международном учете
//
// Параметры:
// 	 ПараметрыПроверки - См. ПараметрыПроверкиПравилОтражения
//
// Возвращаемое значение:
//	Структура - Структура содержащая:
//		* ХозяйственныеОперацииБезПравилОтражения - См. МеждународныйУчетПоДаннымОперативногоУчета.ПроверитьПравилаОтражения
//		* СчетаБезПравилОтражения - См. МеждународныйУчетПоДаннымРеглУчета.ПроверитьПравилаОтражения
//		* ОбъектыУчетаТребующиеНастройки - См. МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПроверитьПравилаОтражения
Функция ПроверитьНастройкуПравилОтраженияУчете(ПараметрыПроверки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтражениеДокументов.Регистратор КАК Регистратор,
	|	ОтражениеДокументов.Период КАК Период,
	|	ОтражениеДокументов.ПланСчетов КАК ПланСчетов,
	|	ОтражениеДокументов.Организация КАК Организация,
	|	ОтражениеДокументов.ДатаОтражения КАК ДатаОтражения,
	|	МАКСИМУМ(ПланыСчетовМеждународногоУчетаОрганизаций.Период) КАК ПериодНастройкиФормированияПроводок
	|ПОМЕСТИТЬ ОтражениеДокументов
	|ИЗ
	|	РегистрСведений.ОтражениеДокументовВМеждународномУчете КАК ОтражениеДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПланыСчетовМеждународногоУчетаОрганизаций КАК ПланыСчетовМеждународногоУчетаОрганизаций
	|		ПО ОтражениеДокументов.ПланСчетов = ПланыСчетовМеждународногоУчетаОрганизаций.ПланСчетов
	|			И ОтражениеДокументов.Организация = ПланыСчетовМеждународногоУчетаОрганизаций.Организация
	|			И ОтражениеДокументов.Период >= ПланыСчетовМеждународногоУчетаОрганизаций.Период
	|ГДЕ
	|	(ОтражениеДокументов.Регистратор = &Документ
	|			ИЛИ &Документ = НЕОПРЕДЕЛЕНО)
	|	И (ОтражениеДокументов.ПланСчетов = &ПланСчетов
	|			ИЛИ &ПланСчетов = НЕОПРЕДЕЛЕНО)
	|	И (ОтражениеДокументов.Организация = &Организация
	|			ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И ОтражениеДокументов.Статус В (
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.КОтражениюВУчете), 
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОтраженияВМеждународномУчете.ОтсутствуютПравилаОтраженияВУчете))
	|
	|СГРУППИРОВАТЬ ПО
	|	ОтражениеДокументов.Регистратор,
	|	ОтражениеДокументов.Период,
	|	ОтражениеДокументов.ПланСчетов,
	|	ОтражениеДокументов.Организация,
	|	ОтражениеДокументов.ДатаОтражения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПланСчетов,
	|	Организация,
	|	ПериодНастройкиФормированияПроводок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыКОтражению.Регистратор КАК Регистратор,
	|	ДокументыКОтражению.Период КАК Период,
	|	ДокументыКОтражению.ПланСчетов КАК ПланСчетов,
	|	ДокументыКОтражению.Организация КАК Организация,
	|	ДокументыКОтражению.ДатаОтражения КАК ДатаОтражения,
	|	ПланыСчетовМеждународногоУчетаОрганизаций.НастройкаФормированияПроводок КАК НастройкаФормированияПроводок
	|ПОМЕСТИТЬ ДокументыКОтражению
	|ИЗ
	|	ОтражениеДокументов КАК ДокументыКОтражению
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПланыСчетовМеждународногоУчетаОрганизаций КАК ПланыСчетовМеждународногоУчетаОрганизаций
	|		ПО ДокументыКОтражению.ПланСчетов = ПланыСчетовМеждународногоУчетаОрганизаций.ПланСчетов
	|			И ДокументыКОтражению.Организация = ПланыСчетовМеждународногоУчетаОрганизаций.Организация
	|			И ДокументыКОтражению.ПериодНастройкиФормированияПроводок = ПланыСчетовМеждународногоУчетаОрганизаций.Период
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДокументыКОтражению.Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ОтражениеДокументов";
	Запрос.УстановитьПараметр("ПланСчетов", ПараметрыПроверки.ПланСчетов);
	Запрос.УстановитьПараметр("Организация", ПараметрыПроверки.Организация);
	Запрос.УстановитьПараметр("Документ", ПараметрыПроверки.Документ);
	Запрос.Выполнить();
	
	ОперацииБезПравилОтражения = МеждународныйУчетПоДаннымОперативногоУчета.ПроверитьПравилаОтражения(МенеджерВременныхТаблиц, ПараметрыПроверки);
	СчетаБезПравилОтражения    = МеждународныйУчетПоДаннымРеглУчета.ПроверитьПравилаОтражения(МенеджерВременныхТаблиц, ПараметрыПроверки);
	ОбъектыУчетаТребующиеНастройки = МеждународныйУчетПоДаннымОстаточныхФинансовыхРегистров.ПроверитьПравилаОтражения(МенеджерВременныхТаблиц, ПараметрыПроверки);
	
	Результат = Новый Структура;
	Результат.Вставить("ХозяйственныеОперацииБезПравилОтражения", ОперацииБезПравилОтражения);
	Результат.Вставить("СчетаБезПравилОтражения", СчетаБезПравилОтражения);
	Результат.Вставить("ОбъектыУчетаТребующиеНастройки", ОбъектыУчетаТребующиеНастройки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли