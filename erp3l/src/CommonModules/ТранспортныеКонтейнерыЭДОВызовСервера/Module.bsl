
#Область СлужебныйПрограммныйИнтерфейс

// Начинает отмену распаковки контейнеров.
// 
// Параметры:
// 	Контейнеры - Массив из ДокументСсылка.ТранспортныйКонтейнерЭДО
// Возвращаемое значение:
// 	См. ДлительныеОперации.ВыполнитьФункцию
Функция НачатьОтменуРаспаковкиКонтейнеров(Контейнеры) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Добавление транспортных контейнеров ЭДО в исключения';
															|en = 'Add EDI transport containers to exceptions'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"ТранспортныеКонтейнерыЭДОСлужебный.ОтменитьРаспаковкуКонтейнеров",
		Контейнеры);
	
КонецФункции

Функция НачатьРаспаковкуКонтейнеров(Контейнеры, Отпечатки, КонтекстДиагностики) Экспорт
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Распаковка транспортных контейнеров ЭДО';
															|en = 'Unpack EDI transport containers'");
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения,
		"ТранспортныеКонтейнерыЭДО.РаспаковатьКонтейнеры",
		Контейнеры, Отпечатки, КонтекстДиагностики);
	
КонецФункции

Функция РезультатРаспаковкиКонтейнеров(АдресРезультата) Экспорт
	
	РезультатРаспаковки = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Результат = Новый Структура;
	Результат.Вставить("РезультатЗагрузкиДокументов",
		ЭлектронныеДокументыЭДО.ОбработатьРезультатЗагрузкиВФоне(РезультатРаспаковки.РезультатЗагрузкиДокументов));
	Результат.Вставить("РаспакованоКонтейнеров", РезультатРаспаковки.РаспакованоКонтейнеров);
	Результат.Вставить("КонтекстДиагностики", РезультатРаспаковки.КонтекстДиагностики);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти