#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Подразделение)
	|	И ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(Партнер)
	|	И ЗначениеРазрешено(Сценарий)
	|	И ЗначениеРазрешено(ВидПлана)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "РегистрыНакопления.ПланыЗакупок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.3.10";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b77c69c9-1fd8-436f-a25b-9932c5b83e7c");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "РегистрыНакопления.ПланыЗакупок.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет движения документа ""План закупок"" по регистру накопления ""Планы закупок"":
	| - заполняет ресурс ""К заказу"" и ""Количество"" в соответствии с признаками ""Замещен"" и ""Замещен к заказу""
	| - заполняет измерение ""Вид плана"".';
	|en = 'Updates records in the ""Purchase plan"" document for the ""Purchase plans"" accumulation register:
	| - fills in the ""To order"" and ""Quantity"" resources according to ""Substituted"" and ""Substituted to order""
	| - fills in the ""Plan profile"" dimension.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.ПланЗакупок.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.РегистрыНакопления.ПланыЗакупок.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Документы.ПланЗакупок.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

// Процедура регистрации данных для обработчика обновления ОбработатьДанныеДляПереходаНаВерсию.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяДокумента = "Документ.ПланЗакупок";
	ПолноеИмяРегистра = "РегистрНакопления.ПланыЗакупок";
	ИмяРегистра       = "ПланыЗакупок";
	
	ТекстЗапроса = Документы.ПланЗакупок.АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра);
	
	Регистраторы = ОбновлениеИнформационнойБазыУТ.РегистраторыДляПерепроведения(
		ТекстЗапроса, ПолноеИмяРегистра, ПолноеИмяДокумента);
	
	Запрос = Новый Запрос;
	Запрос.Текст = Документы.ПланЗакупок.ТекстЗапросаДанныеКОбработке();
	
	ЗапросПакет = Запрос.ВыполнитьПакет();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Регистраторы, ЗапросПакет[3].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	ОбновлениеИнформационнойБазы.ОтметитьРегистраторыКОбработке(
		Параметры, Регистраторы, ПолноеИмяРегистра);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Регистраторы = Новый Массив;
	Регистраторы.Добавить("Документ.ПланЗакупок");
	
	ОбработкаЗавершена = ОбновлениеИнформационнойБазыУТ.ПерезаписатьДвиженияИзОчереди(Регистраторы,
		"РегистрНакопления.ПланыЗакупок", Параметры.Очередь);
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
