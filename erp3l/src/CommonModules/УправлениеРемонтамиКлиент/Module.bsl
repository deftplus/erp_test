////////////////////////////////////////////////////////////////////////////////
// Процедуры подсистемы управления ремонтами.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получает данные для печати и открывает форму печати.
//
// Параметры:
//	ОписаниеКоманды - Структура - структура с описанием команды.
//
// Возвращаемое значение:
//	Неопределено
//
Функция ПечатьЭтикетокУзловОбъектовЭксплуатации(ОписаниеКоманды) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПечатьЭтикетокУзловОбъектовЭксплуатации.Форма",
		Новый Структура("Узлы", ОписаниеКоманды.ОбъектыПечати),
		ОписаниеКоманды.Форма,
		Новый УникальныйИдентификатор);
	
	Возврат Неопределено;
	
КонецФункции

// Сообщает о неудачном поиске узлов по штрихкоду.
// 
Процедура СообщитьЧтоНеУдалосьНайтиУзлыПоШтрихкоду() Экспорт

	ТекстСообщения = НСтр("ru = 'Узлы не найдены';
							|en = 'Sub-assets not found'");
	ПояснениеСообщения = НСтр("ru = 'Не удалось найти узлы по штрихкоду';
								|en = 'Cannot find sub-assets using the barcode'");
	
	ПоказатьОповещениеПользователя(ТекстСообщения,, ПояснениеСообщения,,,);
		
КонецПроцедуры

// Генерирует штрихкоды для узлов объектов эксплуатации.
// 
// Параметры:
// 	СписокУзлов - Массив из СправочникСсылка.УзлыОбъектовЭксплуатации - Узлы, для которых требуется сгенерировать штрихкод.
Процедура СгенерироватьШтрихкодыУзлов(Знач СписокУзлов) Экспорт
	
	КоличествоВсего = СписокУзлов.Количество();
	КоличествоОбработанных = УправлениеРемонтамиВызовСервера.СгенерироватьШтрихкодыУзлов(СписокУзлов);
	
	Если КоличествоОбработанных > 0 Тогда
		
		Если КоличествоОбработанных = КоличествоВсего Тогда
			КартинкаОповещения = БиблиотекаКартинок.Информация32;
			ТекстСообщения = НСтр("ru = 'Штрихкод сформирован для всех выбранных узлов';
									|en = 'Barcode generated for all selected sub-assets'");
		Иначе	
			КартинкаОповещения = БиблиотекаКартинок.Внимание32;
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Штрихкод сформирован для %1 из %2 выбранных узлов';
											|en = 'Barcode generated for %1 of %2 selected sub-assets'"),
					КоличествоОбработанных, 
					КоличествоВсего);
		КонецЕсли;

		ТекстЗаголовка = НСтр("ru = 'Штрихкоды сформированы';
								|en = 'Barcodes are generated'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, КартинкаОповещения);

	Иначе
		
		ТекстСообщения = НСтр("ru = 'У выбранных узлов уже сформирован штрихкод';
								|en = 'The barcode has already been generated for selected sub-assets'");
		ТекстЗаголовка = НСтр("ru = 'Штрихкоды не сформированы';
								|en = 'Barcodes are not generated'");
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Внимание32);
		
	КонецЕсли;

	Оповестить("Запись_УзлыОбъектовЭксплуатации");
	ОповеститьОбИзменении(Тип("СправочникСсылка.УзлыОбъектовЭксплуатации"));
	
КонецПроцедуры

// Выполняет поиск узлов по штрихкоду.
// Открывает форму, где пользователь вводит штрихкод.
// После ввода выполняется поиск узлов.
// Если найдено несколько узлов, то открывается форма для выбора узлов.
// После успешного поиска возвращает массив найденных узлов.
// 
// Параметры:
// 	ПроцедураОбработки - ОписаниеОповещения - Процедура, которую нужно вызвать при успешном поиске.
//  ПараметрыПодбора - см. ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора
Процедура ПоискУзловПоШтрихкоду(ПроцедураОбработки, ПараметрыПодбора = Неопределено) Экспорт

	ДополнительныеПараметры = Новый Структура("ПроцедураОбработки, ПараметрыПодбора", ПроцедураОбработки, ПараметрыПодбора);
	Оповещение = Новый ОписаниеОповещения("ПоискУзловПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

// Выполняет поиск объектов эксплуатации или узлов по штрихкоду.
// Открывает форму, где пользователь вводит штрихкод.
// После ввода выполняется поиск.
// Если найдено несколько ОЭ или узлов, то открывается форма для выбора.
// После успешного поиска возвращает массив ссылок.
// 
// Параметры:
// 	ПроцедураОбработки - ОписаниеОповещения - Процедура, которую нужно вызвать при успешном поиске.
//  ПараметрыПодбора - см. ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора
Процедура ПоискОбъектовЭксплуатацииИлиУзловПоШтрихкоду(ПроцедураОбработки, ПараметрыПодбора = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура("ПроцедураОбработки, ПараметрыПодбора", ПроцедураОбработки, ПараметрыПодбора);
	Оповещение = Новый ОписаниеОповещения("ПоискОбъектовЭксплуатацииИлиУзловПоШтрихкодуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ШтрихкодированиеНоменклатурыКлиент.ПоказатьВводШтрихкода(Оповещение);
	
КонецПроцедуры

// Обработка ввода штрихкода.
// 
// Параметры:
//  ДанныеШтрихкодов - Структура, Массив из Строка - Данные штрихкодов.
// 	ПроцедураОбработки - ОписаниеОповещения - Процедура, которую нужно вызвать при успешном поиске.
//  ПараметрыПодбора - см. ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора
Процедура ОбработатьВводШтрихкодовУзлов(ДанныеШтрихкодов, ПроцедураОбработки, ПараметрыПодбора = Неопределено) Экспорт
	
	РезультатПоиска = УправлениеРемонтамиВызовСервера.НайтиУзлыПоШтрихкодам(
						ДанныеШтрихкодов, ПараметрыПодбора);
	
	Если РезультатПоиска.МассивОбъектов.Количество() = 0 Тогда
		
		СообщитьОРезультатахПоискаУзловПоШтрихкоду(РезультатПоиска);
	
	ИначеЕсли РезультатПоиска.МассивОбъектов.Количество() = 1 Тогда
		
		ВыполнитьОбработкуОповещения(ПроцедураОбработки, РезультатПоиска.МассивОбъектов);
	
	Иначе
		
		ДополнительныеПараметры = Новый Структура("ПроцедураОбработки", ПроцедураОбработки);
		Оповещение = Новый ОписаниеОповещения("ВыборУзловПоШтриходуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Параметры = Новый Структура;
		Параметры.Вставить("ДанныеШтрихкодов", ДанныеШтрихкодов);
		Параметры.Вставить("ПараметрыПодбора", ПараметрыПодбора);
		Параметры.Вставить("МассивОбъектов", РезультатПоиска.МассивОбъектов);
		Параметры.Вставить("ПоискУзлов", Истина);
		ОткрытьФорму("Справочник.ОбъектыЭксплуатации.Форма.ПоискПоШтрихкоду", Параметры,,,,, Оповещение);
	
	КонецЕсли;
	
КонецПроцедуры

// Обработка ввода штрихкода.
// 
// Параметры:
//  ДанныеШтрихкодов - Структура, Массив из Строка - Данные штрихкодов.
// 	ПроцедураОбработки - ОписаниеОповещения - Процедура, которую нужно вызвать при успешном поиске.
//  ПараметрыПодбора - см. ВнеоборотныеАктивыКлиентСервер.ПараметрыПодбора
Процедура ОбработатьВводШтрихкодовОбъектовЭксплуатацииИлиУзлов(ДанныеШтрихкодов, ПроцедураОбработки, ПараметрыПодбора = Неопределено) Экспорт
	
	РезультатПоиска = УправлениеРемонтамиВызовСервера.НайтиОбъектыЭксплуатацииИлиУзлыПоШтрихкодам(
						ДанныеШтрихкодов, ПараметрыПодбора);
	
	Если РезультатПоиска.МассивОбъектов.Количество() = 0 Тогда
		
		СообщитьОРезультатахПоискаОбъектовЭксплуатацииИлиУзловПоШтрихкоду(РезультатПоиска);
	
	ИначеЕсли РезультатПоиска.МассивОбъектов.Количество() = 1 Тогда
		
		ВыполнитьОбработкуОповещения(ПроцедураОбработки, РезультатПоиска.МассивОбъектов);
	
	Иначе
		
		ДополнительныеПараметры = Новый Структура("ПроцедураОбработки", ПроцедураОбработки);
		Оповещение = Новый ОписаниеОповещения("ВыборУзловПоШтриходуЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		Параметры = Новый Структура;
		Параметры.Вставить("ДанныеШтрихкодов", ДанныеШтрихкодов);
		Параметры.Вставить("ПараметрыПодбора", ПараметрыПодбора);
		Параметры.Вставить("МассивОбъектов", РезультатПоиска.МассивОбъектов);
		Параметры.Вставить("ПоискОбъектовЭксплуатации", Истина);
		Параметры.Вставить("ПоискУзлов", Истина);
		ОткрытьФорму("Справочник.ОбъектыЭксплуатации.Форма.ПоискПоШтрихкоду", Параметры,,,,, Оповещение);
	
	КонецЕсли;
	
КонецПроцедуры

// Сообщает о результатах поиска по штрихкоду.
// 
// Параметры:
// 	РезультатПоиска - см. УправлениеРемонтамиВызовСервера.НайтиОбъектыЭксплуатацииИлиУзлыПоШтрихкодам
Процедура СообщитьОРезультатахПоискаОбъектовЭксплуатацииИлиУзловПоШтрихкоду(РезультатПоиска) Экспорт
	
	ОчиститьСообщения();
	
	ШаблонСообщения = НСтр("ru = 'Не удалось найти объекты эксплуатации и узлы по штрихкоду %1';
							|en = 'Cannot find sub-assets and objects by barcode %1'");
	Для каждого Штрихкод Из РезультатПоиска.НеНайдены Цикл
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Штрихкод);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения); 
	КонецЦикла; 
	
	ШаблонСообщенияОбъект = НСтр("ru = 'Объект эксплуатации ""%1"" не может быть добавлен в документ, т.к. он не удовлетворяет условиям выбора';
								|en = 'The asset ""%1"" cannot be added to the document, as it does not meet selection conditions'");
	ШаблонСообщенияУзел = НСтр("ru = 'Узел ""%1"" не может быть добавлен в документ, т.к. он не удовлетворяет условиям выбора';
								|en = 'The sub-asset ""%1"" cannot be added to the document, as it does not meet selection conditions'");
	Для каждого СсылкаНаОбъект Из РезультатПоиска.НеПодходят Цикл
		Если ТипЗнч(СсылкаНаОбъект) = Тип("СправочникСсылка.УзлыОбъектовЭксплуатации") Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщенияУзел, СсылкаНаОбъект);
		Иначе
			ТекстСообщения = СтрШаблон(ШаблонСообщенияОбъект, СсылкаНаОбъект);
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, СсылкаНаОбъект); 
	КонецЦикла; 
	
КонецПроцедуры

// Сообщает о результатах поиска по штрихкоду.
// 
// Параметры:
// 	РезультатПоиска - см. УправлениеРемонтамиВызовСервера.НайтиУзлыПоШтрихкодам
Процедура СообщитьОРезультатахПоискаУзловПоШтрихкоду(РезультатПоиска) Экспорт
	
	ОчиститьСообщения();
	
	ШаблонСообщения = НСтр("ru = 'Не удалось найти узлы по штрихкоду %1';
							|en = 'Cannot find sub-assets using the barcode.%1'");
	Для каждого Штрихкод Из РезультатПоиска.НеНайдены Цикл
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Штрихкод);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения); 
	КонецЦикла; 
	
	ШаблонСообщения = НСтр("ru = 'Узел ""%1"" не может быть добавлен в документ, т.к. он не удовлетворяет условиям выбора';
							|en = 'The sub-asset ""%1"" cannot be added to the document, as it does not meet selection conditions'");
	Для каждого СсылкаНаОбъект Из РезультатПоиска.НеПодходят Цикл
		ТекстСообщения = СтрШаблон(ШаблонСообщения, СсылкаНаОбъект);
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения, СсылкаНаОбъект); 
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает новый статус для объектов эксплуатации.
//
// Параметры:
//	НовыйСтатус - ПеречислениеСсылка.СтатусыОбъектовЭксплуатации - новый статус
//	ПредставлениеСтатуса - Строка - представление нового статуса
//  МассивОбъектов - Массив - список объектов эксплуатации.
//
Процедура УстановитьСтатусОбъектовЭксплуатации(НовыйСтатус, ПредставлениеСтатуса, МассивОбъектов) Экспорт
	
	Если МассивОбъектов.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗначениеСтатуса",      НовыйСтатус);
	ДополнительныеПараметры.Вставить("ПредставлениеСтатуса", ПредставлениеСтатуса);
	ДополнительныеПараметры.Вставить("ВыделенныеСсылки",     МассивОбъектов);
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьСтатусОбъектовЭксплуатацииЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Выбранным объектам эксплуатации будет установлен статус ""%1"". Продолжить?';
						|en = 'Status ""%1"" will be set for the selected assets. Continue?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ПредставлениеСтатуса);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ИзменитьКлассОбъектовЭксплуатации(МассивОбъектов) Экспорт
	
	Если МассивОбъектов.Количество() = 0 Тогда
		Возврат
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ВыделенныеСсылки", МассивОбъектов);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКлассОбъектовЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЭтоКлассУзла", Ложь);
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Отбор", ПараметрыОтбора);
	
	ОткрытьФорму("Справочник.КлассыОбъектовЭксплуатации.ФормаВыбора", ПараметрыВыбора,,,,, ОписаниеОповещения);
	
КонецПроцедуры

Процедура УстановитьСтатусОбъектовЭксплуатацииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	КоличествоВсего = ДополнительныеПараметры.ВыделенныеСсылки.Количество();
	
	Результат = УправлениеРемонтамиВызовСервера.УстановитьСтатусОбъектовЭксплуатации(
										ДополнительныеПараметры.ВыделенныеСсылки, 
										ДополнительныеПараметры.ЗначениеСтатуса);
										
	Если Результат.КоличествоОбработанных > 0 Тогда
		
		Если Результат.КоличествоОбработанных = КоличествоВсего Тогда
			КартинкаОповещения = БиблиотекаКартинок.Информация32;
			ТекстСообщения = НСтр("ru = 'Для всех выбранных в списке объектов эксплуатации установлен новый статус';
									|en = 'A new status has been set for all the assets selected in the list'");
		Иначе	
			КартинкаОповещения = БиблиотекаКартинок.Внимание32;
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для %1 из %2 выбранных в списке объектов эксплуатации установлен новый статус';
											|en = 'A new status has been set for %1 of %2 assets selected in the list'"),
					Результат.КоличествоОбработанных, 
					КоличествоВсего);
		КонецЕсли;

		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Статус ""%1"" установлен';
										|en = 'Status ""%1"" is set'"), ДополнительныеПараметры.ПредставлениеСтатуса);

		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, КартинкаОповещения);

	Иначе
		
		Если Результат.ЕстьОшибкиПроверкиЗаполнения Тогда
			ТекстСообщения = НСтр("ru = 'Статус не установлен ни для одного объекта эксплуатации. Необходимо открыть объект эксплуатации и выполнить проверку заполнения.';
									|en = 'The status is not set for any asset. Open the asset and perform a filling check.'");
		Иначе	
			ТекстСообщения = НСтр("ru = 'Статус не установлен ни для одного объекта эксплуатации.';
									|en = 'The status is not set for any asset.'");
		КонецЕсли;
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Статус ""%1"" не установлен';
										|en = 'Status ""%1"" is not set'"), ДополнительныеПараметры.ПредставлениеСтатуса);
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Внимание32);
		
	КонецЕсли;

	Оповестить("Запись_ОбъектыЭксплуатации");
	ОповеститьОбИзменении(Тип("СправочникСсылка.ОбъектыЭксплуатации"));
	
КонецПроцедуры

Процедура ВыбратьКлассОбъектовЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора)
		ИЛИ ТипЗнч(РезультатВыбора) <> Тип("СправочникСсылка.КлассыОбъектовЭксплуатации") Тогда
		Возврат;
	КонецЕсли;
	
	Если УправлениеРемонтамиВызовСервера.ИспользуютсяПодклассы(РезультатВыбора) Тогда
		
		ДополнительныеПараметрыВыбора = Новый Структура;
		ДополнительныеПараметрыВыбора.Вставить("ВыделенныеСсылки", ДополнительныеПараметры.ВыделенныеСсылки);
		ДополнительныеПараметрыВыбора.Вставить("Класс", РезультатВыбора);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПодклассОбъектовЭксплуатацииЗавершение", ЭтотОбъект, ДополнительныеПараметрыВыбора);
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Владелец", РезультатВыбора);
		
		ПараметрыВыбора = Новый Структура;
		ПараметрыВыбора.Вставить("Отбор", ПараметрыОтбора);

		ОткрытьФорму("Справочник.ПодклассыОбъектовЭксплуатации.ФормаВыбора", ПараметрыВыбора,,,,, ОписаниеОповещения);
	
	Иначе
		
		ИзменитьКлассОбъектовЭксплуатацииПослеВыбора(
			ДополнительныеПараметры.ВыделенныеСсылки, 
			РезультатВыбора, 
			Неопределено);
			
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыбратьПодклассОбъектовЭксплуатацииЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатВыбора)
		ИЛИ ТипЗнч(РезультатВыбора) <> Тип("СправочникСсылка.ПодклассыОбъектовЭксплуатации") Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьКлассОбъектовЭксплуатацииПослеВыбора(
		ДополнительныеПараметры.ВыделенныеСсылки, 
		ДополнительныеПараметры.Класс, 
		РезультатВыбора);
	
КонецПроцедуры

Процедура ИзменитьКлассОбъектовЭксплуатацииПослеВыбора(ВыделенныеСсылки, Класс, Подкласс)

	ОчиститьСообщения();
	
	КоличествоВсего = ВыделенныеСсылки.Количество();
	
	Результат = УправлениеРемонтамиВызовСервера.ИзменитьКлассОбъектовЭксплуатации(
										ВыделенныеСсылки, 
										Класс,
										Подкласс);
										
	Если Результат.КоличествоОбработанных > 0 Тогда
		
		Если Результат.КоличествоОбработанных = КоличествоВсего Тогда
			ТекстСообщения = НСтр("ru = 'Для всех выбранных в списке объектов эксплуатации установлен новый класс';
									|en = 'A new class has been set for all the assets selected in the list'");
		Иначе	
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для %1 из %2 выбранных в списке объектов эксплуатации установлен новый класс';
											|en = 'A new class has been set for %1 of %2 assets selected in the list'"),
					Результат.КоличествоОбработанных, 
					КоличествоВсего);
		КонецЕсли;

		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Установлен класс ""%1""';
										|en = 'Class ""%1"" set'"), Результат.КлассПредставление);

		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);

	Иначе
		
		Если Результат.ЕстьОшибкиПроверкиЗаполнения Тогда
			ТекстСообщения = НСтр("ru = 'Класс не установлен ни для одного объекта эксплуатации.
			|Необходимо открыть объект эксплуатации и выполнить проверку заполнения.';
			|en = 'The class is not set for any asset.
			|Open the asset and perform a filling check.'");
		Иначе	
			ТекстСообщения = НСтр("ru = 'Класс не установлен ни для одного объекта эксплуатации.';
									|en = 'The class is not set for any asset.'");
		КонецЕсли;
		
		ТекстЗаголовка = СтрШаблон(НСтр("ru = 'Класс ""%1"" не установлен';
										|en = 'Class ""%1"" is not set'"), Результат.КлассПредставление);
		
		ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
		
	КонецЕсли;

	Оповестить("Запись_ОбъектыЭксплуатации");
	ОповеститьОбИзменении(Тип("СправочникСсылка.ОбъектыЭксплуатации"));
	
КонецПроцедуры

Процедура ПоискУзловПоШтрихкодуЗавершение(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ОбработатьВводШтрихкодовУзлов(
		ДанныеШтрихкодов, 
		ДополнительныеПараметры.ПроцедураОбработки, 
		ДополнительныеПараметры.ПараметрыПодбора);
	
КонецПроцедуры

Процедура ПоискОбъектовЭксплуатацииИлиУзловПоШтрихкодуЗавершение(ДанныеШтрихкодов, ДополнительныеПараметры) Экспорт
	
	ОбработатьВводШтрихкодовОбъектовЭксплуатацииИлиУзлов(
		ДанныеШтрихкодов, 
		ДополнительныеПараметры.ПроцедураОбработки, 
		ДополнительныеПараметры.ПараметрыПодбора);
	
КонецПроцедуры

Процедура ВыборУзловПоШтриходуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() <> 0 Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ПроцедураОбработки, Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
