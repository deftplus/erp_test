#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает настройки оформления по умолчанию для вариантов анализа.
// 
// Параметры:
// 	ПокомпонентноеСравнение - Булево - Описание
// Возвращаемое значение:
// 	Структура - Описание:
// * ВключатьНоль - Булево -
// * РежимШкалыЗначений - ПеречислениеСсылка.РежимШкалыЗначенийДиаграмм -
// * РежимСглаживанияДиаграмм - Булево -
// * ОкантовкаДиаграмм - Булево -
// * ВыводитьПодписиКДиаграммам - Булево -
// * ОтображатьЛегенду - Булево -
// * ВыводитьМаркерТочекПрогноза - Булево -
// * ВыделятьМаксимальноеЗначениеДляПокомпонентногоСравнения - Булево -
// * ГрадиентДляПокомпонентногоСравнения - Булево -
// * ТолькоЦветОсновнойСерии - Булево -
// * ХранилищеНастроекОформления - ХранилищеЗначения -
Функция НастройкиОформленияПоУмолчанию(ПокомпонентноеСравнение = Ложь) Экспорт
	
	// Сформируем настройки цветов
	ЦветовыеНастройки = Новый Структура;
	
	НаборЦветов = Новый Соответствие;
	НаборЦветов.Вставить("Значение", WebЦвета.СинийСоСтальнымОттенком);
	НаборЦветов.Вставить("Прогноз", WebЦвета.НейтральноФиолетовоКрасный);
	НаборЦветов.Вставить("ЦелевоеЗначение", WebЦвета.ЗеленыйЛес);
	НаборЦветов.Вставить("ПозитивноеОтклонение", WebЦвета.КоролевскиГолубой);
	НаборЦветов.Вставить("НегативноеОтклонение", WebЦвета.Малиновый);
	НаборЦветов.Вставить("ЗонаДопустимыхОтклонений", Новый Цвет(255, 195, 0));
	
	ЦветовыеНастройки.Вставить("Цвета", НаборЦветов);
	
	ХранилищеНастроекОформления = Новый ХранилищеЗначения(ЦветовыеНастройки);
	
	// Сформируем настройки параметров вывода
	СтруктураНастроекОформления = Новый Структура;
	СтруктураНастроекОформления.Вставить("ХранилищеНастроекОформления", ХранилищеНастроекОформления);
	СтруктураНастроекОформления.Вставить("ТолькоЦветОсновнойСерии", Истина);
	СтруктураНастроекОформления.Вставить("ГрадиентДляПокомпонентногоСравнения", Истина);
	СтруктураНастроекОформления.Вставить("ВыделятьМаксимальноеЗначениеДляПокомпонентногоСравнения", Ложь);
	СтруктураНастроекОформления.Вставить("ВыводитьМаркерТочекПрогноза", Ложь);
	СтруктураНастроекОформления.Вставить("ОтображатьЛегенду", Истина);
	СтруктураНастроекОформления.Вставить("ВыводитьПодписиКДиаграммам", Истина);
	СтруктураНастроекОформления.Вставить("ОкантовкаДиаграмм", Ложь);
	СтруктураНастроекОформления.Вставить("РежимСглаживанияДиаграмм", Истина);
	СтруктураНастроекОформления.Вставить("РежимШкалыЗначений", Перечисления.РежимШкалыЗначенийДиаграмм.Авто);
	СтруктураНастроекОформления.Вставить("ВключатьНоль", Истина);
	
	Возврат СтруктураНастроекОформления;
	
КонецФункции

// Помещает во временное хранилище схему компоновки данных,
// настройки компоновки данных и пользовательские настройки и возвращает их адреса.
//
// Параметры:
//	ВариантАнализа - СправочникСсылка.ВариантыАнализаЦелевыхПоказателей - вариант анализа, для которого возвращаются адреса.
//
// Возвращаемое значение:
//	Структура - структура, содержащая адреса:
//	 *СхемаКомпоновкиДанных - Строка - адрес временного хранилища, содержащий схему компоновки.
//	 *НастройкиКомпоновкиДанных - Строка - адрес временного хранилища, содержащий настройки схемы компоновки.
//	 *ПользовательскиеНастройки - Строка - адрес временного хранилища, содержащий пользовательские настройки.
//
Функция АдресаСхемыКомпоновкиДанныхИПользовательскихНастроек(ВариантАнализа) Экспорт
	
	Адреса = Новый Структура("СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, ПользовательскиеНастройки");
	
	// Получим схему компоновки данных
	Если ЗначениеЗаполнено(ВариантАнализа.Владелец.СхемаКомпоновкиДанных) ИЛИ ВариантАнализа.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить() = Неопределено Тогда
		СхемаИНастройки = Справочники.СтруктураЦелей.ОписаниеИСхемаКомпоновкиДанныхЦелиПоИмениМакета(ВариантАнализа.Владелец, ВариантАнализа.Владелец.СхемаКомпоновкиДанных);
		СхемаКомпоновкиДанных = СхемаИНастройки.СхемаКомпоновкиДанных;
	Иначе
		СхемаКомпоновкиДанных = ВариантАнализа.Владелец.ХранилищеСхемыКомпоновкиДанных.Получить();
	КонецЕсли;
	
	Адреса.СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	
	Настройки = ВариантАнализа.Владелец.ХранилищеНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(Настройки) Тогда
		Адреса.НастройкиКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	ПользовательскиеНастройки = ВариантАнализа.ХранилищеПользовательскихНастроекКомпоновкиДанных.Получить();
	
	Если ЗначениеЗаполнено(ПользовательскиеНастройки) Тогда
		Адреса.ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(ПользовательскиеНастройки, Новый УникальныйИдентификатор());
	КонецЕсли;
	
	Возврат Адреса;
	
КонецФункции

// Возвращает демонстрационные данные, указанные при варианте анализа
//
// Параметры:
//	ВариантАнализа - СправочникСсылка.ВариантыАнализаЦелевыхПоказателей - вариант анализа, для которого возвращаются адреса.
//
// Возвращаемое значение:
//	ТаблицаЗначений - таблица демонстрационных данных варианта анализа.
//
Функция ДемонстрационныеДанныеВариантаАнализа(ВариантАнализа) Экспорт 
	ДемонстрационныеДанные = Новый ТаблицаЗначений;
	
	ЗначениеАнализаИмя = Строка(ВариантАнализа.ЗначениеАнализа.Получить());
	ЗначениеАнализаДополнительноеИмя = Строка(ВариантАнализа.ЗначениеАнализаДополнительное.Получить());
	ОбъектАнализаИмя = Строка(ВариантАнализа.ОбъектАнализа.Получить());
	
	ХранилищеДемонстрационныхДанныхЗначение = ВариантАнализа.ХранилищеДемонстрационныхДанных.Получить();
	Если ХранилищеДемонстрационныхДанныхЗначение <> Неопределено Тогда
		ДемонстрационныеДанные = ХранилищеДемонстрационныхДанныхЗначение.Данные.Получить(); // ТаблицаЗначений -
		
		КолонкаТаблицы = ДемонстрационныеДанные.Колонки.ЗначениеПоказателя; // КолонкаТаблицыЗначений - 
		КолонкаТаблицы.Имя = ЗначениеАнализаИмя;
		
		Если ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнение
			ИЛИ ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнениеДинамика Тогда
			Если ВариантАнализа.РежимПокомпонентногоСравнения = 0 Тогда
				КолонкаТаблицы = ДемонстрационныеДанные.Колонки.ОбъектАнализа; // КолонкаТаблицыЗначений -
				КолонкаТаблицы.Имя = ОбъектАнализаИмя;
			Иначе
				КолонкаТаблицы = ДемонстрационныеДанные.Колонки.ЗначениеПоказателяДополнительное; // КолонкаТаблицыЗначений -
				КолонкаТаблицы.Имя = ЗначениеАнализаДополнительноеИмя;
			КонецЕсли;
		КонецЕсли;
		Если ВариантАнализа.ТипАнализа = Перечисления.ТипыАнализаПоказателей.ПокомпонентноеСравнение Тогда
			Если ВариантАнализа.РежимПокомпонентногоСравнения = 0 Тогда
				ПоследняяДата = ДемонстрационныеДанные[0].Период;
				ДемонстрационныеДанные.ЗаполнитьЗначения(Неопределено, "Период");
				
				ИтогПоТаблице = ДемонстрационныеДанные.Итог(ЗначениеАнализаИмя);
				НоваяСтрока = ДемонстрационныеДанные.Добавить();
				НоваяСтрока.Период = ПоследняяДата;
				НоваяСтрока[ЗначениеАнализаИмя] = ИтогПоТаблице;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Возврат ДемонстрационныеДанные;
КонецФункции
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.ВариантыАнализаЦелевыхПоказателей.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.3.16";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("b54f847e-a72c-4e9a-af54-92b2a4f31ac2");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.ВариантыАнализаЦелевыхПоказателей.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "МониторингЦелевыхПоказателей.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Замена строковых литералов в отборах настроек предопределенных макетов компоновки данных в справочнике ""Варианты анализа целевых показателей""';
									|en = 'Replacement of string literals in setting filters for predefined templates of data composition in the “Target value analysis options” catalog'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.СтруктураЦелей.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Отчеты.МониторЦелевыхПоказателей.ПолноеИмя());
	Блокируемые.Добавить(Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

	НоваяСтрока = Обработчик.ПриоритетыВыполнения.Добавить();
	НоваяСтрока.Процедура = "Справочники.СтруктураЦелей.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	НоваяСтрока.Порядок = "После";

КонецПроцедуры

#Область Обработчики_2_5_3

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ИменаПредопределенныхСхем = Справочники.СтруктураЦелей.ИменаПредопределенныхМакетовДляПроверкиОтборов();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИменаПредопределенныхСхем", ИменаПредопределенныхСхем);
	Запрос.Текст = "ВЫБРАТЬ
	|	ВариантыАнализаЦелевыхПоказателей.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВариантыАнализаЦелевыхПоказателей КАК ВариантыАнализаЦелевыхПоказателей
	|ГДЕ
	|	ВариантыАнализаЦелевыхПоказателей.Владелец.СхемаКомпоновкиДанных В (&ИменаПредопределенныхСхем)
	|	И НЕ ВариантыАнализаЦелевыхПоказателей.УдалитьНеТребуютсяЗаменыСтроковыхЛитераловВОтборах";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Справочник.ВариантыАнализаЦелевыхПоказателей";
	
	ЗаменыПоМакетам = Справочники.СтруктураЦелей.СтруктураЗаменВОтборахПредопределенныхМакетовМЦП();
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь,
			ПолноеИмяОбъекта,
			МенеджерВТ);
	
	Если Не Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Если Не Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСсылок.Ссылка,
	|	СтруктураЦелей.СхемаКомпоновкиДанных КАК СтруктураЦелейСхемаКомпоновкиДанных,
	|	СтруктураЦелей.ХранилищеНастроекКомпоновкиДанных КАК СтруктураЦелейХранилищеНастроекКомпоновкиДанных
	|ИЗ
	|	&ТаблицаОбновляемыхДанных КАК ТаблицаСсылок
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.ВариантыАнализаЦелевыхПоказателей КАК ВариантыАнализа
	|ПО
	|	ТаблицаСсылок.Ссылка = ВариантыАнализа.Ссылка
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.СтруктураЦелей КАК СтруктураЦелей
	|ПО
	|	ВариантыАнализа.Владелец = СтруктураЦелей.Ссылка";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаОбновляемыхДанных", Результат.ИмяВременнойТаблицы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			Блокировка.Заблокировать();
			
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
			Если СправочникОбъект = Неопределено Тогда
				
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
				
			Иначе
				
				СхемаКомпоновкиДанных = Выборка.СтруктураЦелейСхемаКомпоновкиДанных;
				
				ЗаменыПолей = ЗаменыПоМакетам.Получить(СхемаКомпоновкиДанных);
				Если НЕ ЗаменыПолей = Неопределено Тогда
					// Значение не было изменено
					
					Настройки = СправочникОбъект.ХранилищеПользовательскихНастроекКомпоновкиДанных.Получить(); // ПользовательскиеНастройкиКомпоновкиДанных -
					НастройкиСхемыЦели = Выборка.СтруктураЦелейХранилищеНастроекКомпоновкиДанных.Получить();
					
					Если НЕ Настройки = Неопределено И НЕ НастройкиСхемыЦели = Неопределено Тогда
						ЭлементыОтбораЦели = КомпоновкаДанныхКлиентСервер.ПолучитьЭлементыОтбора(НастройкиСхемыЦели.Отбор);
						
						Для каждого ЗаменаПоля Из ЗаменыПолей Цикл
							
							ИмяПоля = ЗаменаПоля.Ключ;
							ЗаменыПоПолю = ЗаменаПоля.Значение;
							
							Для каждого ЭлементОтбораЦели Из ЭлементыОтбораЦели Цикл
								Если ТипЗнч(ЭлементОтбораЦели) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
									Продолжить;
								КонецЕсли;
								Если Строка(ЭлементОтбораЦели.ЛевоеЗначение) = ИмяПоля Тогда
									ИдентификаторПользовательскойНастройки = ЭлементОтбораЦели.ИдентификаторПользовательскойНастройки;
									
									Для каждого ЭлементОтбораВариантаАнализа Из Настройки.Элементы Цикл
										
										Если ЭлементОтбораВариантаАнализа.ИдентификаторПользовательскойНастройки = ИдентификаторПользовательскойНастройки Тогда
											
											Если НЕ ЭлементОтбораВариантаАнализа = Неопределено Тогда
												Если ТипЗнч(ЭлементОтбораВариантаАнализа.ПравоеЗначение) = Тип("Строка") Тогда
													ЗначениеЗамены = ЗаменыПоПолю.Получить(ЭлементОтбораВариантаАнализа.ПравоеЗначение);
													Если НЕ ЗначениеЗамены = Неопределено Тогда
														ЭлементОтбораВариантаАнализа.ПравоеЗначение = ЗначениеЗамены;
													КонецЕсли;
												ИначеЕсли ТипЗнч(ЭлементОтбораВариантаАнализа.ПравоеЗначение) = Тип("СписокЗначений") Тогда
													Для каждого ЭлементСписка Из ЭлементОтбораВариантаАнализа.ПравоеЗначение Цикл
														ЗначениеЗамены = ЗаменыПоПолю.Получить(ЭлементСписка.Значение);
														Если НЕ ЗначениеЗамены = Неопределено Тогда
															ЭлементСписка.Значение = ЗначениеЗамены;
														КонецЕсли;
													КонецЦикла;
												КонецЕсли;
												
											КонецЕсли;
											
										КонецЕсли;
										
									КонецЦикла;
									
								КонецЕсли;
								
							КонецЦикла;
							
						КонецЦикла;
						
						СправочникОбъект.ХранилищеПользовательскихНастроекКомпоновкиДанных = Новый ХранилищеЗначения(Настройки);
					КонецЕсли;
				КонецЕсли;
				
				СправочникОбъект.УдалитьНеТребуютсяЗаменыСтроковыхЛитераловВОтборах = Истина;
				
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(СправочникОбъект);
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ОткрытиеСуществующегоОбъекта = Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ);
	СозданиеОбъектаНеИзСписка = Не ОткрытиеСуществующегоОбъекта
			И Не (Параметры.Свойство("ЗначенияЗаполнения") 
				И Параметры.ЗначенияЗаполнения.Свойство("Владелец")
				Или Параметры.Свойство("ЗначениеКопирования"));
	
	Если ВидФормы = "ФормаОбъекта" И СозданиеОбъектаНеИзСписка Тогда
		
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Справочники.ВариантыАнализаЦелевыхПоказателей.Формы.ФормаПредупреждения;
	КонецЕсли;
КонецПроцедуры
	
#КонецОбласти 
