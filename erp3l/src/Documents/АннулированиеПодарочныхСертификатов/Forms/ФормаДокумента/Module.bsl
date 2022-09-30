
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "СчитанПодарочныйСертификат"
		И Параметр.ФормаВладелец = УникальныйИдентификатор Тогда
		
		ОбработатьПодарочныйСертификат(Параметр.ПодарочныйСертификат);
		
	КонецЕсли;
		
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПодарочныеСертификатыПодарочныйСертификатПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	ДанныеСертификата = ДанныеСертификата(ТекущиеДанные.ПодарочныйСертификат);
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодарочныеСертификатыСуммаПриИзменении(Элемент)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.ПодарочныеСертификаты.ТекущиеДанные;
	ДанныеСертификата = ДанныеСертификата(ТекущиеДанные.ПодарочныйСертификат);
	
	Если ДанныеСертификата.СуммаВВалютеСертификата < ТекущиеДанные.СуммаВВалютеСертификата Тогда
		ТекущиеДанные.СуммаВВалютеСертификата = ДанныеСертификата.СуммаВВалютеСертификата;
		
		ТекстСообщения = НСтр("ru = 'Сумма аннулирования превышает остаточную сумму сертификата. Значение изменено на максимально возможное.';
								|en = 'The cancellation amount exceeds the residual amount of the certificate. The value is changed to the maximum possible.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьТабличнуюЧастьПодарочныеСертификаты();
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СчитатьПодарочныйСертификат(Команда)
	
	ОткрытьФорму(
		"Справочник.ПодарочныеСертификаты.Форма.СчитываниеПодарочногоСертификата",
		Новый Структура("НеИспользоватьРучнойВвод", Ложь),
		ЭтаФорма,
		ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкодов)
	
	Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(ДанныеШтрихкодов) Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеШтрихкодов) = Тип("Массив") Тогда
		МассивШтрихкодов = ДанныеШтрихкодов;
	Иначе
		МассивШтрихкодов = Новый Массив;
		МассивШтрихкодов.Добавить(ДанныеШтрихкодов);
	КонецЕсли;
	
	ПодарочныеСертификатыКлиент.ОбработатьПолученныйКодНаКлиенте(
		ЭтаФорма,
		МассивШтрихкодов[0].Штрихкод,
		ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.Штрихкод"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	ПодарочныеСертификатыКлиент.ОбработатьПолученныйКодНаКлиенте(
		ЭтаФорма,
		Данные,
		ПредопределенноеЗначение("Перечисление.ТипыКодовКарт.МагнитныйКод"));
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ДанныеСертификата(ПодарочныйСертификат)
	
	ДатаПолученияОстатка = ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Дата, ТекущаяДатаСеанса());
	
	СуммаВВалютеСертификата = ПодарочныеСертификатыВызовСервера.ОстатокПодарочногоСертификата(ПодарочныйСертификат, ДатаПолученияОстатка);
	ДанныеСертификата = АналитикаДоходовСертификата(ПодарочныйСертификат);
	ДанныеСертификата.Вставить("СуммаВВалютеСертификата", СуммаВВалютеСертификата);
	
	Возврат ДанныеСертификата;
	
КонецФункции

&НаСервере
Функция АналитикаДоходовСертификата(ПодарочныйСертификат)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыПодарочныхСертификатов.СтатьяДоходов КАК СтатьяДоходов,
	|	ВидыПодарочныхСертификатов.АналитикаДоходов КАК АналитикаДоходов
	|ИЗ
	|	Справочник.ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыПодарочныхСертификатов КАК ВидыПодарочныхСертификатов
	|		ПО ПодарочныеСертификаты.Владелец = ВидыПодарочныхСертификатов.Ссылка
	|ГДЕ
	|	ПодарочныеСертификаты.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ПодарочныйСертификат);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Аналитика = Новый Структура("СтатьяДоходов, АналитикаДоходов");
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Аналитика, Выборка);
	КонецЕсли;
	Возврат Аналитика;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТабличнуюЧастьПодарочныеСертификаты()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.ПодарочныеСертификаты.Очистить();
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ИсторияПодарочныхСертификатовСрезПоследних.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	АктивацияПодарочныхСертификатов.Период КАК ДатаАктивации
	|ПОМЕСТИТЬ ПодарочныеСертификаты
	|ИЗ
	|	РегистрСведений.ИсторияПодарочныхСертификатов.СрезПоследних(&Дата, ) КАК ИсторияПодарочныхСертификатовСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияПодарочныхСертификатов КАК АктивацияПодарочныхСертификатов
	|		ПО ИсторияПодарочныхСертификатовСрезПоследних.ПодарочныйСертификат = АктивацияПодарочныхСертификатов.ПодарочныйСертификат
	|			И (АктивацияПодарочныхСертификатов.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Активирован))
	|ГДЕ
	|	ИсторияПодарочныхСертификатовСрезПоследних.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыПодарочныхСертификатов.Аннулирован)
	|	И АктивацияПодарочныхСертификатов.Регистратор.Организация = &Организация
	|	И (ИсторияПодарочныхСертификатовСрезПоследних.Статус В (&ПогашенныеВидыСертификатов)
	|			ИЛИ ВЫБОР
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.День)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, ДЕНЬ, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Неделя)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, НЕДЕЛЯ, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Месяц)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, МЕСЯЦ, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Квартал)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, КВАРТАЛ, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Год)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, ГОД, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Декада)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, ДЕКАДА, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				КОГДА АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.ПериодДействия = ЗНАЧЕНИЕ(Перечисление.Периодичность.Полугодие)
	|					ТОГДА ДОБАВИТЬКДАТЕ(АктивацияПодарочныхСертификатов.Период, ПОЛУГОДИЕ, АктивацияПодарочныхСертификатов.ПодарочныйСертификат.Владелец.КоличествоПериодовДействия)
	|				ИНАЧЕ АктивацияПодарочныхСертификатов.Период
	|			КОНЕЦ < &Дата)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0) КАК СуммаВВалютеСертификата
	|ИЗ
	|	ПодарочныеСертификаты КАК ПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(
	|				&Дата,
	|				ПодарочныйСертификат В
	|					(ВЫБРАТЬ
	|						Т.ПодарочныйСертификат
	|					ИЗ
	|						ПодарочныеСертификаты КАК Т)) КАК ПодарочныеСертификатыОстатки
	|		ПО ПодарочныеСертификаты.ПодарочныйСертификат = ПодарочныеСертификатыОстатки.ПодарочныйСертификат");
	
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Ссылка), Объект.Дата - 1, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	
	МассивПогашенныеВидыСертификатов = Новый Массив;
	МассивПогашенныеВидыСертификатов.Добавить(Перечисления.СтатусыПодарочныхСертификатов.Возвращен);
	МассивПогашенныеВидыСертификатов.Добавить(Перечисления.СтатусыПодарочныхСертификатов.ПолностьюПогашен);
	
	Запрос.УстановитьПараметр("ПогашенныеВидыСертификатов", МассивПогашенныеВидыСертификатов);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Объект.ПодарочныеСертификаты.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодарочныйСертификат(ПодарочныйСертификат)
	
	НайденныеСтроки = Объект.ПодарочныеСертификаты.НайтиСтроки(Новый Структура("ПодарочныйСертификат", ПодарочныйСертификат));
	Если НайденныеСтроки.Количество() = 0 Тогда
		НайденнаяСтрока = Объект.ПодарочныеСертификаты.Добавить();
	Иначе
		НайденнаяСтрока = НайденныеСтроки[0];
	КонецЕсли;
	
	НайденнаяСтрока.ПодарочныйСертификат = ПодарочныйСертификат;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ДатаПолученияОстатка = Объект.Дата;
	Иначе
		ДатаПолученияОстатка = ТекущаяДатаСеанса();
	КонецЕсли;
	
	НайденнаяСтрока.СуммаВВалютеСертификата = ПодарочныеСертификатыВызовСервера.ОстатокПодарочногоСертификата(ПодарочныйСертификат, ДатаПолученияОстатка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
