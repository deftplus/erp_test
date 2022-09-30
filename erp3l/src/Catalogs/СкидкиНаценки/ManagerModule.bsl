
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Данные.ВариантСовместногоПрименения) И Не ЗначениеЗаполнено(Данные.Наименование) Тогда
		СтандартнаяОбработка = Ложь;
		Представление = Данные.ВариантСовместногоПрименения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("ЭтоГруппа");
	Поля.Добавить("ВариантСовместногоПрименения");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Получает реквизиты объекта, которые необходимо блокировать от изменения.
//
// Возвращаемое значение:
//  Массив - блокируемые реквизиты объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт

	Результат = Новый Массив;
	Результат.Добавить("ВалютаПредоставления");
	Результат.Добавить("ВариантСовместногоПрименения");
	Результат.Добавить("ВариантРасчетаРезультатаСовместногоПрименения");
	Результат.Добавить("ВидЦены");
	Результат.Добавить("ЗначениеСкидкиНаценки");
	Результат.Добавить("СегментПодарков");
	Результат.Добавить("СпособПредоставления;СпособПредоставленияСкидкиНаценки,СпособПредоставленияБонусныеБаллы,ПоказатьФормуНастроекВнешнейОбработкиБонусы,ПоказатьФормуНастроекВнешнейОбработки");
	Результат.Добавить("Управляемая;СпособНазначения");
	Результат.Добавить("УсловияПредоставления;УсловияПредоставленияПодобратьУсловияПредоставления,УсловияПредоставленияПодобратьУсловияПредоставленияБонусы,УсловияПредоставленияГруппаСоздать");
	Результат.Добавить("ЦеновыеГруппы");
	Результат.Добавить("Родитель");
	Результат.Добавить("ТекстСообщения");
	Результат.Добавить("ВидКартыЛояльности");
	Результат.Добавить("ИспользоватьКратность");
	Результат.Добавить("УсловиеДляСкидкиКоличеством");
	Результат.Добавить("ТочностьОкругления");
	Результат.Добавить("ПсихологическоеОкругление");
	Результат.Добавить("ВариантОкругления");
	Результат.Добавить("СпособПримененияСкидки");
	Результат.Добавить("СпособНазначения;СпособНазначенияВручную,СпособНазначенияАвтоматически");
	Результат.Добавить("БонуснаяПрограммаЛояльности");
	Результат.Добавить("ПериодДействия;ИспользоватьПериодДействия");
	Результат.Добавить("КоличествоПериодовДействия");
	Результат.Добавить("ПериодОтсрочкиНачалаДействия;ИспользоватьОтсрочкуНачалаДействия");
	Результат.Добавить("КоличествоПериодовОтсрочкиНачалаДействия");
	Результат.Добавить("ВариантОтбораНоменклатуры;ДополнительныйОтборПредставление,ОтборПредставление,СегментНоменклатуры,СписокНоменклатуры");
	Результат.Добавить("ПрименятьУмножениеВРамкахВышестоящейГруппы");
	Результат.Добавить("УчитыватьХарактеристики");
	Возврат Результат;
	
КонецФункции

// Определяет настройки начального заполнения элементов
//
// Параметры:
//  Настройки - Структура - настройки заполнения:
//   * ПриНачальномЗаполненииЭлемента - Булево - Если Истина, то для каждого элемента будет
//      вызвана процедура индивидуального заполнения ПриНачальномЗаполненииЭлемента.
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	
	Настройки.ПриНачальномЗаполненииЭлемента = Истина;
	
КонецПроцедуры

// Вызывается при начальном заполнении справочника.
//
// Параметры:
//  КодыЯзыков - Массив - список языков конфигурации. Актуально для мультиязычных конфигураций.
//  Элементы   - ТаблицаЗначений - данные заполнения. Состав колонок соответствует набору реквизитов
//                                 справочника.
//  ТабличныеЧасти - Структура - Ключ - Имя табличной части объекта.
//                               Значение - Выгрузка в таблицу значений пустой табличной части.
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	#Область КорневаяГруппа
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "КорневаяГруппа";
	Элемент.Наименование = НСтр("ru = 'Корневая группа';
								|en = 'Root group'", ОбщегоНазначения.КодОсновногоЯзыка());
	#КонецОбласти

КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.СкидкиНаценки - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

#Область ЗаполнитьЭлементыНачальнымиДанными

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.СкидкиНаценки.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "11.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("89e9294c-4188-4c5c-b7d0-133f2d367281");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СкидкиНаценки.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.';
	|en = 'Updates the names of predefined items.
	|While the update is in progress, names of predefined items might be displayed incorrectly.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "До";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.СкидкиНаценки.ОбработатьДанныеПоСкидкамДляОбновленияКешированныхЗапросов";
	НоваяСтрока.Порядок = "До";

#КонецОбласти

#Область ОбработатьДанныеПоСкидкамДляОбновленияКешированныхЗапросов

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.СкидкиНаценки.ОбработатьДанныеПоСкидкамДляОбновленияКешированныхЗапросов";
	Обработчик.Версия = "11.5.7.149";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("58a777c3-0572-4c90-9ffd-dbc1715d380f");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.СкидкиНаценки.ЗарегистрироватьДанныеПоСкидкамКОбработкеДляОбновленияКешированныхЗапросов";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление кешированных запросов для скидок';
									|en = 'Update cached requests for discounts'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.СкидкиНаценки.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.СкидкиНаценки.ЗаполнитьЭлементыНачальнымиДанными";
	НоваяСтрока.Порядок = "После";

#КонецОбласти

КонецПроцедуры

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.СкидкиНаценки);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.СкидкиНаценки, Ложь, "Наименование");
	
КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеПоСкидкамКОбработкеДляОбновленияКешированныхЗапросов(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.СкидкиНаценки";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СкидкиНаценки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СкидкиНаценки КАК СкидкиНаценки
	|ГДЕ
	|	НЕ СкидкиНаценки.ЭтоГруппа
	|	И НЕ СкидкиНаценки.СпособПредоставления В
	|		(ВЫБРАТЬ
	|			ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка
	|		ИЗ
	|			Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ЭлементыДляРегистрации = Новый Массив();
	
	Пока Выборка.Следующий() Цикл
		
		Если СкидкиНаценкиСервер.НеобходимаРегистрация(Выборка.Ссылка) Тогда
			ЭлементыДляРегистрации.Добавить(Выборка.Ссылка);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ЭлементыДляРегистрации);
	
КонецПроцедуры

Процедура ОбработатьДанныеПоСкидкамДляОбновленияКешированныхЗапросов(Параметры) Экспорт
	
	ПолноеИмяОбъекта        = "Справочник.СкидкиНаценки";
	
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Для Каждого ЭлементСправочника Из ОбновляемыеДанные Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСправочника.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			СправочникОбъект = ЭлементСправочника.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(ЭлементСправочника.Ссылка);
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;

			СкидкиНаценкиСервер.ОбновитьКэшированныйЗапрос(СправочникОбъект);
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ЭлементСправочника.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

// Заполняет предопределенный элемент справочника "Скидки (наценки)".
//
Процедура ЗаполнитьПредопределенныеЭлементы() Экспорт
	
	СправочникОбъект = Справочники.СкидкиНаценки.КорневаяГруппа.ПолучитьОбъект();
	СправочникОбъект.ВариантСовместногоПрименения = Перечисления.ВариантыСовместногоПримененияСкидокНаценок.Максимум;
	СправочникОбъект.ВариантРасчетаРезультатаСовместногоПрименения = Перечисления.ВариантыРасчетаРезультатаСовместногоПрименения.ПоСтроке;
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
