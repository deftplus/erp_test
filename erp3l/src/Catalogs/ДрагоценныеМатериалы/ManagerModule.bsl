#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняется заполнение реквизитов предопределенных элементов справочника
//
Процедура ЗаполнитьПредопределенныеДрагоценныеМатериалы() Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьУчетДрагоценныхМатериалов") Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		ЗаполнитьПредопределенныеЭлементыПоДанымИзКода();
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Заполнение предопределенных драгоценных материалов';
				|en = 'Populate predefined precious materials'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

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
//  ТабличныеЧасти - Структура - Ключ - имя табличной части объекта
//                               Значение - Выгрузка в таблицу значений пустой табличной части
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	КодОсновногоЯзыка = ОбщегоНазначения.КодОсновногоЯзыка();
	СоответствиеКодов = Справочники.УпаковкиЕдиницыИзмерения.ЗаполнитьЕдиницыИзмеренияИзКлассификатора("162,163");
	Караты = СоответствиеКодов["162"];
	Граммы = СоответствиеКодов["163"];
	
	#Область Алмазы
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Алмазы";
	Элемент.Наименование = НСтр("ru = 'Алмазы';
								|en = 'Diamonds'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Караты;
	#КонецОбласти

	#Область Золото
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Золото";
	Элемент.Наименование = НСтр("ru = 'Золото';
								|en = 'Gold'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Иридий
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Иридий";
	Элемент.Наименование = НСтр("ru = 'Иридий';
								|en = 'Iridium'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Осмий
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Осмий";
	Элемент.Наименование = НСтр("ru = 'Осмий';
								|en = 'Osmium'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Палладий
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Палладий";
	Элемент.Наименование = НСтр("ru = 'Палладий';
								|en = 'Palladium'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Платина
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Платина";
	Элемент.Наименование = НСтр("ru = 'Платина';
								|en = 'Platinum'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область ПлатинаВЛабораторнойПосудеДляХиманализов
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПлатинаВЛабораторнойПосудеДляХиманализов";
	Элемент.Наименование = НСтр("ru = 'Платина в лабораторной посуде для химанализов';
								|en = 'Platinum in laboratory glassware for chemical analysis'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область ПлатинородиевыеТермопары
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ПлатинородиевыеТермопары";
	Элемент.Наименование = НСтр("ru = 'Платинородиевые термопары';
								|en = 'Platinum-rhodium thermocouples'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Родий
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Родий";
	Элемент.Наименование = НСтр("ru = 'Родий';
								|en = 'Rhodium'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Рутений
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Рутений";
	Элемент.Наименование = НСтр("ru = 'Рутений';
								|en = 'Rhutenium'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область Серебро
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "Серебро";
	Элемент.Наименование = НСтр("ru = 'Серебро';
								|en = 'Silver'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область СолиСеребраДляХиманализов
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СолиСеребраДляХиманализов";
	Элемент.Наименование = НСтр("ru = 'Соли серебра для химанализов в пересчете на металл';
								|en = 'Silver salts for chemical analyzes in terms of metal'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

	#Область СусальноеЗолото
	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "СусальноеЗолото";
	Элемент.Наименование = НСтр("ru = 'Сусальное золото';
								|en = 'Gold leaf'", КодОсновногоЯзыка);
	Элемент.ЕдиницаИзмерения = Граммы;
	#КонецОбласти

КонецПроцедуры

// Вызывается при начальном заполнении создаваемого элемента.
//
// Параметры:
//  Объект                  - СправочникОбъект.ДрагоценныеМатериалы - заполняемый объект.
//  Данные                  - СтрокаТаблицыЗначений - данные заполнения.
//  ДополнительныеПараметры - Структура - Дополнительные параметры.
//
Процедура ПриНачальномЗаполненииЭлемента(Объект, Данные, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

// Проверяет заполнение табличной части с содержанием драгоценных материалов
//
// Параметры:
// 		Объект - СправочникОбъект.ДрагоценныеМатериалы - Объект проверки
// 		ТабличнаяЧасть - ТабличнаяЧасть из СтрокаТабличнойЧасти - Проверяемая табличная часть объекта:
// 							* ДрагоценныйМатериал - СправочникСсылка.ДрагоценныеМатериалы - 
// 							* Расположение - ПеречислениеСсылка.РасположениеДрагоценныхКамней -
// 		Отказ - Булево - Признак найденной ошибки при проверке заполнения.
//
Процедура ПроверитьЗаполнениеДрагоценныхМатериалов(Объект, ТабличнаяЧасть, Отказ) Экспорт
	
	ШаблонТекстаОшибки = НСтр("ru = 'Не заполнена колонка ""Классификация для 1-ДМ"" в строке %1 списка ""Драгоценные металлы и камни""';
								|en = 'Column ""Classification for 1-DM"" is required in line %1 of the ""Precious metals and stones"" list'");
	Для н=0 По ТабличнаяЧасть.Количество()-1 Цикл
		Если ТабличнаяЧасть[н].ДрагоценныйМатериал = Справочники.ДрагоценныеМатериалы.Алмазы
			И Не ЗначениеЗаполнено(ТабличнаяЧасть[н].Расположение) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонТекстаОшибки, Формат(н+1, "ЧГ=0")),
				Объект,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДрагоценныеМатериалы", н+1, "Расположение"),
				"Объект",
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ДрагоценныеМатериалы.ЗаполнитьЭлементыНачальнымиДанными";
	Обработчик.Версия = "2.5.5.51";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("6a21830d-3786-4da7-b808-499fe097c557");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ДрагоценныеМатериалы.ЗарегистрироватьПредопределенныеЭлементыДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Обновление наименований предопределенных элементов.
	|До завершения обработки наименования этих элементов в ряде случаев будет отображаться некорректно.';
	|en = 'Updates the names of predefined items.
	|While the update is in progress, names of predefined items might be displayed incorrectly.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ДрагоценныеМатериалы.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ДрагоценныеМатериалы.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.ДрагоценныеМатериалы.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "МультиязычностьСервер.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "Любой";

КонецПроцедуры

Процедура ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗарегистрироватьПредопределенныеЭлементыДляОбновления(Параметры, Метаданные.Справочники.ДрагоценныеМатериалы);
	
КонецПроцедуры

Процедура ЗаполнитьЭлементыНачальнымиДанными(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаполнитьЭлементыНачальнымиДанными(Параметры, Метаданные.Справочники.ДрагоценныеМатериалы, Ложь, "Наименование");
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьПредопределенныеЭлементыПоДанымИзКода()
	
	МетаданныеОбъекта = Метаданные.Справочники.ДрагоценныеМатериалы;
	ПредопределенныеДанные = Справочники.НастройкиХозяйственныхОпераций.ПредопределенныеДанныеОбъекта(МетаданныеОбъекта);
	Для Каждого ДанныеЭлемента Из ПредопределенныеДанные Цикл
		ЭлементСсылка = Справочники.ДрагоценныеМатериалы[ДанныеЭлемента.ИмяПредопределенныхДанных];
		ЭлементОбъект = ЭлементСсылка.ПолучитьОбъект();
		СписокРеквизитов = "ИмяПредопределенныхДанных,Наименование,ЕдиницаИзмерения";
		ЗаполнитьЗначенияСвойств(ЭлементОбъект, ДанныеЭлемента, СписокРеквизитов);
		ЭлементОбъект.ОбменДанными.Загрузка = Истина;
		ЭлементОбъект.Записать();
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
