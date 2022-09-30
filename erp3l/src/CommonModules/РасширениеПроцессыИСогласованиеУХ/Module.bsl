////////////////////////////////////////////////////////////////////////////////////////
// Модуль содержит методы, специфичные для 1с:Управление холдингом, вызов которых может
// потребоваться из 1С:БП МСФО.
////////////////////////////////////////////////////////////////////////////////////////

Процедура НарисоватьПанельСогласования(ЭлементыВход, РодительскаяГруппаВход) Экспорт
	МодульСогласованияДокументовУХ.НарисоватьПанельСогласования(ЭлементыВход, РодительскаяГруппаВход);
КонецПроцедуры

Процедура ОпределитьСостояниеЗаявки(ФормаВход) Экспорт
	ДействияСогласованиеУХСервер.ОпределитьСостояниеЗаявки(ФормаВход);
КонецПроцедуры

Функция ИзменитьСостояниеЗаявки(СсылкаВход, СостояниеВход, ФормаВход, ОбъектВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(СостояниеВход);
		Параметры.Добавить(ФормаВход);
		Параметры.Добавить(ОбъектВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ИзменитьСостояниеЗаявки", Параметры);
		РезультатФункции = Параметры[4];
	КонецЕсли;	
	Возврат РезультатФункции;
КонецФункции

Функция ЭтоСостояниеВРаботе(СостояниеВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(СостояниеВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЭтоСостояниеВРаботе", Параметры);
		РезультатФункции = Параметры[1];
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьМассивЭтаповСогласованияТекущегоПользователя(ОбъектВход) Экспорт
	РезультатФункции = Новый Массив;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ОбъектВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПолучитьМассивЭтаповСогласованияТекущегоПользователя", Параметры);
		РезультатФункции = Параметры[1];
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Процедура СостояниеПриИзмененииСервер(ФормаВход, СсылкаВход) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ФормаВход);
		Параметры.Добавить(СсылкаВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.СостояниеПриИзмененииСервер", Параметры);
	Иначе
		// Не используется блок соглсования, определение состояния не требуется.
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьСтруктуруСостояний(СтруктураРезультат) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(СтруктураРезультат);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьСтруктуруСостояний", Параметры);
		СтруктураРезультат = Параметры[0];
	Иначе
		СтруктураРезультат.Вставить("Запланирован"   , Неопределено);
		СтруктураРезультат.Вставить("ЗаписанСОшибкой", Неопределено);
		СтруктураРезультат.Вставить("Выполняется"    , Неопределено);
		СтруктураРезультат.Вставить("Подготовлен"    , Неопределено);
		СтруктураРезультат.Вставить("Утвержден"      , Неопределено);
		СтруктураРезультат.Вставить("Возвращен"      , Неопределено);
	КонецЕсли;	
КонецПроцедуры

Функция ВернутьДанныеСостоянийЭкземпляраОтчета(СсылкаВход) Экспорт
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("СостояниеЗаявки",					 Неопределено);
	РезультатФункции.Вставить("СостояниеСогласованияДоИзменения",	 Неопределено);
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВернутьДанныеСостоянийЭкземпляраОтчета", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции.Вставить("СостояниеЗаявки",					 Неопределено);
		РезультатФункции.Вставить("СостояниеСогласованияДоИзменения",	 Неопределено);
	КонецЕсли;	
	Возврат РезультатФункции;
КонецФункции

Функция ОпределитьИспользованиеМаршрутаСогласования(СогласующийВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(СогласующийВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ОпределитьИспользованиеМаршрутаСогласования", Параметры);
		РезультатФункции = Параметры[1];
	КонецЕсли;	
	Возврат РезультатФункции;	
КонецФункции

Процедура ИзменитьСостояниеСогласованияОбъекта(ОбъектВход, СостояниеСогласованияВход) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ОбъектВход);
		Параметры.Добавить(СостояниеСогласованияВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("МодульСогласованияДокументовУХ.ИзменитьСостояниеСогласованияОбъекта", Параметры);
	Иначе
		// Не нужно выполнять изменение состояния.
	КонецЕсли;	
КонецПроцедуры

Процедура УстановитьСостояниеСогласованияПослеЗаполнения(РабочийОбъектВход) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(РабочийОбъектВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("МодульСогласованияДокументовУХ.УстановитьСостояниеСогласованияПослеЗаполнения", Параметры);
		РабочийОбъектВход = Параметры[0];
	Иначе
		// Не нужно выполнять изменение состояния.
	КонецЕсли;	
КонецПроцедуры

Функция СогласованиеЧерезРакурс(ВидОтчетаВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ВидОтчетаВход);
		Параметры.Добавить(РезультатФункции);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.СогласованиеЧерезРакурс", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Ложь;
	КонецЕсли;	
	Возврат РезультатФункции;	
КонецФункции

Функция ПолучитьСтруктуруОткрытияРакурсаПоОтчету(ВидОтчетаВход, ПериодОтчетаВход) Экспорт
	РезультатФункции = Новый Структура;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходнаяСтруктура = Новый Структура;
		Параметры = Новый Массив;
		Параметры.Добавить(ВидОтчетаВход);
		Параметры.Добавить(ПериодОтчетаВход);
		Параметры.Добавить(ВыходнаяСтруктура);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьСтруктуруОткрытияРакурса", Параметры);
		РезультатФункции.Вставить("ПараметрыОткрытия", Параметры[2]);
		РезультатФункции.Вставить("СтрокаОткрытияФормы", "Обработка.СводнаяТаблица.Форма.ФормаУправленияСогласованием");
	Иначе
		РезультатФункции.Вставить("ПараметрыОткрытия", Новый Структура);
		РезультатФункции.Вставить("СтрокаОткрытияФормы", "");
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ВернутьСтатусОбъекта(СсылкаВход) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьЗначениеСтатусОбъекта", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ВернутьТекущееСостояние(СсылкаВход) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьЗначениеТекущееСостояние", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПеревестиЗаявкуВПроизвольноеСостояние(Знач Заявка, Знач СостояниеЗаявки, Знач Период = Неопределено, Знач Автор = Неопределено,Форма = Неопределено,ДокументПроцесса = Неопределено) Экспорт 
	РезультатФункции = Истина;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(Заявка);
		Параметры.Добавить(СостояниеЗаявки);
		Параметры.Добавить(Период);
		Параметры.Добавить(Автор);
		Параметры.Добавить(Форма);
		Параметры.Добавить(ДокументПроцесса);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьЗначениеПеревестиЗаявкуВПроизвольноеСостояние", Параметры);
		РезультатФункции = Параметры[6];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПроверитьВозможностьУтвержденияОтчета(ПользовательВход, ВидОтчетаВход, ОрганизацияВход) Экспорт 
	РезультатФункции = Истина;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Истина;
		Параметры = Новый Массив;
		Параметры.Добавить(ПользовательВход);
		Параметры.Добавить(ВидОтчетаВход);
		Параметры.Добавить(ОрганизацияВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПроверитьВозможностьУтвержденияОтчета", Параметры);
		РезультатФункции = Параметры[3];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьСостояниеЭтапаНастраиваемогоОтчета(ОбъектВход, ЭтапПроцессаВход) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ОбъектВход);
		Параметры.Добавить(ЭтапПроцессаВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПолучитьСостояниеЭтапаНастраиваемогоОтчета", Параметры);
		ЭтапПроцессаВход = Параметры[1];
		РезультатФункции = Параметры[2];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции

Функция ПолучитьСостояниеСогласования_Утвержден(ТипОбъектаСогласованияВход) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ТипОбъектаСогласованияВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПолучитьСостояниеСогласования_Утвержден", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции

Процедура ИнициализироватьПроцесс(Знач ПериодСценария, Знач Сценарий, Знач Дата, СостоянияВыполненияПроцесса = Неопределено, мПоследователиСтрок = Неопределено, мПредшественникиСтрок = Неопределено) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ПериодСценария);
		Параметры.Добавить(Сценарий);
		Параметры.Добавить(Дата);
		Параметры.Добавить(СостоянияВыполненияПроцесса);
		Параметры.Добавить(мПоследователиСтрок);
		Параметры.Добавить(мПредшественникиСтрок);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ИнициализироватьПроцесс", Параметры);
		Если ТипЗнч(СостоянияВыполненияПроцесса) = Тип("ТаблицаЗначений") Тогда
			СостоянияВыполненияПроцесса	 = Параметры[3].Скопировать();
		Иначе
			// Таблица формы. Оставляем.
		КонецЕсли;
		мПоследователиСтрок				 = Параметры[4];
		мПредшественникиСтрок			 = Параметры[5];
	Иначе
		// Не нужно выполнять изменение состояния.
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьИзменениеСостоянияОбъекта(НаборЗаписейВход, Отказ) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(НаборЗаписейВход);
		Параметры.Добавить(Отказ);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ОбработатьИзменениеСостоянияОбъекта", Параметры);
		ВыгрузкаНаборЗаписей = Параметры[0].Выгрузить();
		НаборЗаписейВход.Загрузить(ВыгрузкаНаборЗаписей);
		Отказ = Параметры[1];
	Иначе
		// Не нужно обрабатывать изменение состояния.
	КонецЕсли;
КонецПроцедуры		// ОбработатьИзменениеСостоянияОбъекта()	

Функция ПолучитьОтветственногоЗаТипОбъекта(ЭлементСсылка, Знач Организация = Неопределено, Знач ШаблонДокументаБД = Неопределено, ТипОтветственного = Неопределено, ВернутьМассив = Ложь) Экспорт
	РезультатФункции = Справочники.Пользователи.ПустаяСсылка();	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Справочники.Пользователи.ПустаяСсылка();
		Параметры = Новый Массив;
		Параметры.Добавить(ЭлементСсылка);
		Параметры.Добавить(Организация);
		Параметры.Добавить(ШаблонДокументаБД);
		Параметры.Добавить(ТипОтветственного);
		Параметры.Добавить(ВыходноеЗначение);
		Параметры.Добавить(ВернутьМассив);		
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПолучитьОтветственногоЗаТипОбъекта", Параметры);
		РезультатФункции = Параметры[4];
	Иначе
		РезультатФункции = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции 

Процедура ЗаполнитьСостоянияСогласования(НастраиваемыйОтчетВход) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(НастраиваемыйОтчетВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("МодульСогласованияДокументовУХ.ЗаполнитьСостоянияСогласования", Параметры);
	Иначе
		// Не нужно обрабатывать изменение состояния согласования.
	КонецЕсли;
КонецПроцедуры

Процедура ЭскалацияУтвержденияЭтапа(ДокументОбъектВход, Отказ) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Параметры = Новый Массив;
		Параметры.Добавить(ДокументОбъектВход);
		Параметры.Добавить(Отказ);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("МодульУправленияПроцессамиУХ.ЭскалацияУтвержденияЭтапа", Параметры);
		Отказ = Параметры[1];
	Иначе
		// Не нужно проводить эскалацию утверждения.
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСхемуСКДДляПодстановкиВШаблоне(ТипОбъектаОповещенияВход, ВидОбъектаОповещенияВход, НазначениеОповещенияВход) Экспорт
	РезультатФункции = Новый СхемаКомпоновкиДанных;	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Новый СхемаКомпоновкиДанных;
		Параметры = Новый Массив;
		Параметры.Добавить(ТипОбъектаОповещенияВход);
		Параметры.Добавить(ВидОбъектаОповещенияВход);
		Параметры.Добавить(НазначениеОповещенияВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("МодульУправленияОповещениямиУХ.ЗаполнитьСхемуСКДДляПодстановкиВШаблоне", Параметры);
		РезультатФункции = Параметры[3];
	Иначе
		РезультатФункции = Новый СхемаКомпоновкиДанных;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ОбработатьЭкземплярОтчета(РабочийОбъект, Реквизиты, ОбновлениеДокумента = Ложь, ПробныйПроцесс = Ложь, Утвердить = Ложь, СогласовыватьВход = Ложь, СтруктураНастроек = Неопределено) Экспорт
	РезультатФункции = Истина;	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Истина;
		Параметры = Новый Массив;
		Параметры.Добавить(РабочийОбъект);
		Параметры.Добавить(Реквизиты);
		Параметры.Добавить(ОбновлениеДокумента);
		Параметры.Добавить(ПробныйПроцесс);
		Параметры.Добавить(Утвердить);
		Параметры.Добавить(СогласовыватьВход);
		Параметры.Добавить(СтруктураНастроек);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВыполнитьОбработкуЭкземпляраОтчета", Параметры);
		РезультатФункции = Параметры[7];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьПустойШаблон() Экспорт
	РезультатФункции = Неопределено;	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить("Справочник.ШаблоныУниверсальныхПроцессов");
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ЗаполнитьПустуюСсылкуНаАналитику", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Процедура СоздатьНаборЗаписейСостоянияВыполненияПроцессовУправлениеПериодами(ПериодСценария, Сценарий, ДвиженияСостоянияВыполненияПроцессов) Экспорт
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ПериодСценария);
		Параметры.Добавить(Сценарий);
		Параметры.Добавить(ДвиженияСостоянияВыполненияПроцессов);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.СоздатьНаборЗаписейСостоянияВыполненияПроцессовУправлениеПериодами", Параметры);
	Иначе
		// Не создаём набор записей
	КонецЕсли;
КонецПроцедуры

Функция ВернутьЗапросЗаполненияОбменаМоделями(ПараметрВход) Экспорт
	РезультатФункции = "";	
	ВыходноеЗначение = Неопределено;
	Параметры = Новый Массив;
	Параметры.Добавить(ПараметрВход);
	Параметры.Добавить(ВыходноеЗначение);
	ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВернутьЗапросЗаполненияОбменаМоделями", Параметры);
	РезультатФункции = Параметры[1];
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьПустойЭкземплярПроцесса() Экспорт
	РезультатФункции = "";
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПолучитьПустойЭкземплярПроцесса", Параметры);
		РезультатФункции = Параметры[0];
	Иначе
		РезультатФункции = "";
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПроверитьЭтоШаблонАвтоутверждение(ШаблонВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ШаблонВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПроверитьЭтоШаблонАвтоутверждение", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Ложь;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьОбластьДанныхПоказателя(ПоказательВход, ЭкземплярОтчетаВход) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ПоказательВход);
		Параметры.Добавить(ЭкземплярОтчетаВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВернутьОбластьДанныхПоказателя", Параметры);
		РезультатФункции = Параметры[2];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ПолучитьРакурсСогласованияОбласти(ЭкземплярОтчетаВход, РакурсВход, ОрганизацияВход, ИспользоватьПроектыВход = Ложь) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ЭкземплярОтчетаВход);
		Параметры.Добавить(РакурсВход);
		Параметры.Добавить(ОрганизацияВход);
		Параметры.Добавить(ИспользоватьПроектыВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВернутьРакурсСогласованияОбласти", Параметры);
		РезультатФункции = Параметры[4];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

Функция ТребуетсяСогласованиеЭкземпляра(ЭкземплярОтчетаВход) Экспорт
	РезультатФункции = Ложь;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Ложь;
		Параметры = Новый Массив;
		Параметры.Добавить(ЭкземплярОтчетаВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВернутьТребуетсяСогласованиеЭкземпляраОтчета", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Ложь;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ТребуетсяСогласованиеЭкземпляра()

Функция ПолучитьДеревоЗначенийЭтапов(ВерсияОрганизационнойСтруктурыВход) Экспорт
	РезультатФункции = Новый ДеревоЗначений;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Новый ДеревоЗначений;
		Параметры = Новый Массив;
		Параметры.Добавить(ВерсияОрганизационнойСтруктурыВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВыполнитьПолучениеДереваЗначенийЭтапов", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = Новый ДеревоЗначений;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПолучитьДеревоЗначенийЭтапов()

Функция ОбработатьОбъектЭлиминация(ЭлиминацияОбъект, Утвердить = Ложь) Экспорт
	РезультатФункции = Истина;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Новый Структура;
		Параметры = Новый Массив;
		Параметры.Добавить(ЭлиминацияОбъект);
		Параметры.Добавить(Утвердить);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВыполитьОбработкуЭлиминации", Параметры);
		ЭлиминацияОбъект =  Параметры[0];
		РезультатФункции = Параметры[2];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции		// ОбработатьОбъектЭлиминация()

Функция ПолучитьСценарийПериодПоИсточнику(ИсточникВход) Экспорт
	РезультатФункции = Новый Структура;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Новый Структура;
		Параметры = Новый Массив;
		Параметры.Добавить(ИсточникВход);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВыполнитьПолучениеСценарияПериодаПоИсточнику", Параметры);
		РезультатФункции = Параметры[1];
	Иначе
		РезультатФункции = УправлениеРабочимиПроцессамиУХ.ПолучитьСценарийПериодПоИсточникуМСФО(ИсточникВход);
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции		// ПолучитьСценарийПериодПоИсточнику()

Функция СоздатьДокументЭлиминация(ВалютаЭлиминационныхПроводок, Организация, КонсолидирующаяОрганизация, ПериодОтчета, Сценарий) Экспорт
	РезультатФункции = Неопределено;
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Новый Структура;
		Параметры = Новый Массив;
		Параметры.Добавить(ВалютаЭлиминационныхПроводок);
		Параметры.Добавить(Организация);
		Параметры.Добавить(КонсолидирующаяОрганизация);
		Параметры.Добавить(ПериодОтчета);
		Параметры.Добавить(Сценарий);
		Параметры.Добавить(ВыходноеЗначение);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ВыполнитьСозданиеДокументаЭлиминация", Параметры);
		ЭлиминацияОбъект =  Параметры[0];
		РезультатФункции = Параметры[5];
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции		// СоздатьДокументЭлиминация()

Функция ПроверитьУтверждениеПравилРакурсов(СсылкаВход, СостояниеВход) Экспорт
	РезультатФункции = "";
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ВыходноеЗначение);
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(СостояниеВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПроверитьУтверждениеПравилРакурсов", Параметры);
		РезультатФункции = Параметры[0];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		// ПроверитьУтверждениеПравилРакурсов()

Функция ПроверитьПравильностьЗаполненияСтрокиПланаЗакупок(СсылкаВход, СостояниеВход) Экспорт
	РезультатФункции = "";
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ВыходноеЗначение);
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(СостояниеВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПроверитьПравильностьЗаполненияСтрокиПланаЗакупок", Параметры);
		РезультатФункции = Параметры[0];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		 // ПроверитьПравильностьЗаполненияСтрокиПланаЗакупок()	

Функция ПроверитьПравильностьЗаполненияПрограммыЗакупок(СсылкаВход, СостояниеВход) Экспорт
	РезультатФункции = "";
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ВыходноеЗначение = Неопределено;
		Параметры = Новый Массив;
		Параметры.Добавить(ВыходноеЗначение);
		Параметры.Добавить(СсылкаВход);
		Параметры.Добавить(СостояниеВход);
		ОбщегоНазначения.ВыполнитьМетодКонфигурации("УправлениеПроцессамиСогласованияУХ.ПроверитьПравильностьЗаполненияПрограммыЗакупок", Параметры);
		РезультатФункции = Параметры[0];
	Иначе
		РезультатФункции = Истина;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции		 // ПроверитьПравильностьЗаполненияПрограммыЗакупок()

Процедура ПриСозданииНаСервереСписок(Форма) Экспорт
	//Для совместимости;	
КонецПроцедуры		//ПриСозданииНаСервереСписок()

Процедура ПриСозданииНаСервереОбъект(Форма) Экспорт
	//Для совместимости;	
КонецПроцедуры		//ПриСозданииНаСервереОбъект()

