#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ДляПроведения

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных мханизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт	
	Возврат ВстраиваниеУХФинансовыеИнструменты.ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры);	
КонецФункции

Функция ПараметрыВзаиморасчеты(ДанныеЗаполнения) Экспорт 

	Возврат ВстраиваниеУХФинансовыеИнструменты.ПараметрыВзаиморасчетыУХ(ДанныеЗаполнения);	

КонецФункции

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт	
	ВстраиваниеУХФинансовыеИнструменты.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента, Истина, Ложь);
КонецПроцедуры

Функция ТекстЗапроса_СчетаДокумента(НомераТаблиц) Экспорт

	НомераТаблиц.Вставить("втСчетаДокумента", НомераТаблиц.Количество());
	
	Возврат
	"ВЫБРАТЬ
	|	СчетаУчета.Ссылка.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	СчетаУчета.Ссылка КАК Ссылка,
	|	СчетаУчета.ВидСчетаФИ КАК ВидСчетаФИ,
	|	СчетаУчета.Счет КАК Счет,
	|	СчетаУчета.Субконто1 КАК Субконто1,
	|	СчетаУчета.Субконто2 КАК Субконто2,
	|	СчетаУчета.Субконто3 КАК Субконто3
	|ПОМЕСТИТЬ втСчетаДокумента
	|ИЗ
	|	Документ.ПриобретениеЦеннойБумаги.СчетаУчета КАК СчетаУчета
	|ГДЕ
	|	СчетаУчета.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Документ.ФинансовыйИнструмент,
	|	Документ.Ссылка,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетВзаиморасчетов),
	|	Документ.СчетВзаиморасчетов,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	Документ.ПриобретениеЦеннойБумаги КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка"
	
КонецФункции

Функция ТекстЗапроса_Проводки(НомераТаблиц) Экспорт
		
	ТекстПроводки = Новый Массив;	
	НомераТаблиц.Вставить("втТаблицаПроводок", НомераТаблиц.Количество());
	
	ТекстПроводки.Добавить(ТекстЗапроса_ПриобретениеФИ());
	ТекстПроводки.Добавить(ТекстЗапроса_ПриобретениеДисконт());	
		
	Разделитель = "
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|";
	
	Возврат СтрСоединить(ТекстПроводки, Разделитель);

КонецФункции

Функция ТекстЗапроса_ПриобретениеФИ()

	Возврат
	"ВЫБРАТЬ
	|	т.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	т.Дата КАК Период,
	|	т.Валюта КАК Валюта,
	|	т.Количество КАК Количество,
	|	т.Сумма - т.НКД КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетВзаиморасчетов) КАК СчетКт,
	|	""Приобретение ценной бумаги"" КАК Комментарий
	|ПОМЕСТИТЬ втТаблицаПроводок
	|ИЗ
	|	втСобытия КАК т";

КонецФункции

Функция ТекстЗапроса_ПриобретениеДисконт()

	Возврат
	"ВЫБРАТЬ
	|	т.ФинансовыйИнструмент КАК ФинансовыйИнструмент,
	|	т.Дата КАК Период,
	|	т.Валюта КАК Валюта,
	|	0 КАК Количество,
	|	т.НКД КАК Сумма,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетНКД) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетВзаиморасчетов) КАК СчетКт,
	|	""НКД при приобретении ценной бумаги"" КАК Комментарий
	|ИЗ
	|	втСобытия КАК т";

КонецФункции

#КонецОбласти
	
#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";

КонецПроцедуры

#Область Отчеты

// Заполняет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	ФинансовыеИнструментыУХ.ДобавитьКомандыОтчетовФИ(КомандыОтчетов, Параметры);
КонецПроцедуры

#КонецОбласти

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Документы.ПродажаЦеннойБумаги.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	ВстраиваниеУХФинансовыеИнструменты.ДобавитьКомандыСозданияНаОсновании_ВариантыОплат(КомандыСозданияНаОсновании, Параметры);

КонецПроцедуры

// Добавляет команду создания документа "Реализация услуг и прочих активов".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	ТекущиеМД = ПустаяСсылка().Метаданные();
	
	Если ПравоДоступа("Добавление", ТекущиеМД) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = ТекущиеМД.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(ТекущиеМД);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли