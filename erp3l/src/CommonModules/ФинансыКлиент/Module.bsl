
#Область ПрограммныйИнтерфейс

// Процедура получает банк по указанному БИК или корреспондентскому счету.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - Текущая форма
//	Элемент - ПолеФормы - Поле, в котором произведен выбор значения.
//	Значение - Строка - Значение, выбранное в поле.
//	СписокБанков - СписокЗначений - Список найденных банков
//	Банк - СправочникСсылка.КлассификаторБанков - Значение поля для указания банка.
//
Процедура ПолучитьБанкПоРеквизитам(Форма, Элемент, Значение, СписокБанков, Банк) Экспорт

	// Если возвращен список банков, произведем выбор банка из списка.
	Если СписокБанков.Количество() > 1 Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Форма", Форма);
		ДополнительныеПараметры.Вставить("Банк", Банк);
		ОписаниеОповещенияВыбораИзСписка = Новый ОписаниеОповещения("ВыборБанкаИзСпискаЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		Форма.ПоказатьВыборИзСписка(ОписаниеОповещенияВыбораИзСписка, СписокБанков, Элемент);
		
	ИначеЕсли СписокБанков.Количество() = 0 Тогда
		
		Если Не ПустаяСтрока(Значение) Тогда
			
			СписокВариантовОтветовНаВопрос = Новый СписокЗначений;
			СписокВариантовОтветовНаВопрос.Добавить("ВыбратьИзСписка", НСтр("ru = 'Выбрать из списка';
																			|en = 'Select from list'"));
			СписокВариантовОтветовНаВопрос.Добавить("ОтменитьВвод", НСтр("ru = 'Отменить ввод';
																		|en = 'Cancel input'"));
			
			ТекстВопроса = НСтр("ru = 'Банк с БИК %Значение% не найден в классификаторе банков.';
								|en = 'Bank with BIC %Значение% is not found in the bank classifier.'");
			ТекстВопроса = СтрЗаменить(ТекстВопроса,"%Значение%", Значение);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПолучитьБанкПоРеквизитамЗавершение",
				ЭтотОбъект,
				Новый Структура("ЭлементФормы, Форма", Элемент, Форма));
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокВариантовОтветовНаВопрос, 0, , НСтр("ru = 'Выбор банка из классификатора';
																										|en = 'Select bank from classifier'"));
			
		Иначе
			Результат = "ВыбратьИзСписка";
			ПолучитьБанкПоРеквизитамЗавершение(Результат, Новый Структура("ЭлементФормы, Форма", Элемент, Форма));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборБанкаИзСпискаЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ДополнительныеПараметры.Банк = ВыбранныйЭлемент.Значение;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьБанкПоРеквизитамЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Элемент = ДополнительныеПараметры.ЭлементФормы;
	Форма = ДополнительныеПараметры.Форма;
	
	Ответ = РезультатВопроса;
	
	Если Ответ = "ОтменитьВвод" Тогда
		Форма[Элемент.Имя] = "";
	ИначеЕсли Ответ = "ВыбратьИзСписка" Тогда
		СтруктураПараметров = Новый Структура;
		ОткрытьФорму("Справочник.КлассификаторБанков.Форма.ФормаВыбора", , Элемент);
	КонецЕсли;

КонецПроцедуры

// Процедура выводит сообщения пользователю, если заполнение на основании
// не было выполнено.
//
// Параметры:
//	Объект - ДанныеФормыКоллекция - Текущий объект
//	Основание - ДокументСсылка - Документ основание.
//
Процедура ПроверитьЗаполнениеДокументаНаОсновании(Объект, Основание) Экспорт
	
	Если ЗначениеЗаполнено(Основание) И Объект.СуммаДокумента = 0 Тогда
		
		Текст = "";
		ТипОснования = ТипЗнч(Основание);
		Если ТипОснования = Тип("ДокументСсылка.СчетНаОплатуКлиенту") Тогда
			Текст = НСтр("ru = 'Остаток задолженности по счету ""%1"" равен 0. Укажите сумму документа вручную';
						|en = 'Remaining debt of the ""%1"" account is equal to 0. Specify the document amount manually'");
			
		ИначеЕсли ТипОснования = Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") Тогда
			Текст = НСтр("ru = 'Остаток по заявке ""%1"" равен 0. Выберите неоплаченную заявку';
						|en = '""%1"" request balance is equal to 0. Select an unpaid request'");
			
		ИначеЕсли ТипОснования = Тип("ДокументСсылка.РаспоряжениеНаПеремещениеДенежныхСредств") Тогда
			Текст = НСтр("ru = 'Остаток по распоряжению ""%1"" равен 0. Выберите неоплаченное распоряжение';
						|en = '""%1"" reference balance is equal to 0. Select an unpaid reference'");
			
		ИначеЕсли ТипОснования = Тип("ДокументСсылка.РасходныйКассовыйОрдер") Тогда
			Текст = НСтр("ru = 'Остаток денежных средств к поступлению по документу ""%1"" равен 0. Укажите сумму документа вручную';
						|en = 'Cash balance for receipt against the ""%1"" document is equal to 0. Specify the document amount manually'");
			
		Иначе
			Текст = НСтр("ru = 'Остаток задолженности по документу ""%1"" равен 0. Укажите сумму документа вручную';
						|en = 'Remaining debt against the ""%1"" document is equal to 0. Specify the document amount manually'");
		КонецЕсли;
		
		Если Не ПустаяСтрока(Текст) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(Текст, Основание),, "Объект.СуммаДокумента");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость пересчета сумм документа из валюты в валюту
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ
//	ТекущаяВалюта - СправочникСсылка.Валюты - Текущая валюта
//	НоваяВалюта - СправочникСсылка.Валюты - Новая валюта.
//
// Возвращаемое значение:
//	Булево - Истина, если требуется пересчет сумм.
//
Функция НеобходимПересчетВВалюту(Объект, ТекущаяВалюта, НоваяВалюта) Экспорт
	
	НеобходимПересчет = Ложь;
	
	Если ЗначениеЗаполнено(ТекущаяВалюта)
	 И ЗначениеЗаполнено(НоваяВалюта)
	 И ТекущаяВалюта <> НоваяВалюта Тогда
	
		МассивТабличныйЧастей = Новый Массив;
		МассивТабличныйЧастей.Добавить("РасшифровкаПлатежа");
		МассивТабличныйЧастей.Добавить("ДебиторскаяЗадолженность");
		МассивТабличныйЧастей.Добавить("КредиторскаяЗадолженность");
		
		Если Объект.СуммаДокумента <> 0 Тогда
			НеобходимПересчет = Истина;
		Иначе
			Для Каждого ТабличнаяЧасть Из МассивТабличныйЧастей Цикл
				
				Если Объект.Свойство(ТабличнаяЧасть)
				 И Объект[ТабличнаяЧасть].Итог("Сумма") <> 0 Тогда
					НеобходимПересчет = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НеобходимПересчет;
	
КонецФункции

// Процедура при необходимости очищает сумму взаиморасчетов в табличной части "Расшифровка платежа".
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ.
//
Процедура ОчиститьСуммуВзаиморасчетовРасшифровкиПлатежа(Объект) Экспорт
	
	НеПустаяСумма = Ложь;
	
	Для каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
		Если СтрокаТаблицы.СуммаВзаиморасчетов > 0
			И СтрокаТаблицы.ВалютаВзаиморасчетов <> Объект.Валюта Тогда
			НеПустаяСумма = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеПустаяСумма Тогда
		ТекстВопроса = НСтр("ru = 'Очистить сумму взаиморасчетов в расшифровке платежа?';
							|en = 'Clear AR/AP amount in payment details?'");
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Объект", Объект);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОчиститьСуммуВзаиморасчетовЗавершение", ЭтотОбъект, ДопПараметры);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьСуммуВзаиморасчетовЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Объект = ДополнительныеПараметры.Объект;
		
		Для каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
			Если СтрокаТаблицы.СуммаВзаиморасчетов > 0
				И СтрокаТаблицы.ВалютаВзаиморасчетов <> Объект.Валюта Тогда
					СтрокаТаблицы.СуммаВзаиморасчетов = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура очищает сумму взаиморасчетов и валюту взаиморасчетов в табличной части "Расшифровка платежа".
//
// Параметры:
//	Объект - ДанныеФормыСтруктура - Текущий документ.
//
Процедура ОчиститьСуммуИВалютуВзаиморасчетовРасшифровкиПлатежа(Объект) Экспорт
	
	НеПустаяВалютаИлиСумма = Ложь;
	
	Для каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.ВалютаВзаиморасчетов) Или СтрокаТаблицы.СуммаВзаиморасчетов > 0 Тогда
			НеПустаяВалютаИлиСумма = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если НеПустаяВалютаИлиСумма Тогда
		ТекстВопроса = НСтр("ru = 'Очистить сумму и валюту взаиморасчетов в расшифровке платежа?';
							|en = 'Clear AR/AP amount and currency in payment details?'");
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Объект", Объект);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОчиститьСуммуИВалютуВзаиморасчетовЗавершение", ЭтотОбъект, ДопПараметры);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьСуммуИВалютуВзаиморасчетовЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Объект = ДополнительныеПараметры.Объект;
		
		Для каждого СтрокаТаблицы Из Объект.РасшифровкаПлатежа Цикл
			Если ЗначениеЗаполнено(СтрокаТаблицы.ОбъектРасчетов) Тогда
				Если СтрокаТаблицы.ВалютаВзаиморасчетов = Объект.Валюта Тогда
					СтрокаТаблицы.СуммаВзаиморасчетов = 0;
				КонецЕсли;
			Иначе
				СтрокаТаблицы.ВалютаВзаиморасчетов = Неопределено;
				СтрокаТаблицы.СуммаВзаиморасчетов = 0;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Открытие формы просмотра/редактирования видов запасов документа.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма клиентского приложения.
//	ПараметрыРедактированияВидовЗапасов - см. ЗапасыСервер.ПоместитьТоварыИВидыЗапасовВХранилище
//
Процедура ОткрытьВидыЗапасов(Форма, ПараметрыРедактированияВидовЗапасов) Экспорт
	
	ПараметрыФормыВвода = Новый Структура("ПараметрыРедактированияВидовЗапасов", ПараметрыРедактированияВидовЗапасов);
	
	ФормаВвода = ОткрытьФорму("Справочник.ВидыЗапасов.Форма.ФормаВводаВидовЗапасов", ПараметрыФормыВвода, Форма);
	
	Если ПараметрыРедактированияВидовЗапасов.РедактироватьВидыЗапасов
		И ФормаВвода.РедактироватьВидыЗапасов Тогда
		
		Форма.ЗаблокироватьДанныеФормыДляРедактирования();
		
	КонецЕсли;
	
КонецПроцедуры

// Определяет относится ли хозяйственная операция документа к расчетами с клиентами.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа.
//
// Возвращаемое значение:
//	Булево - Хозяйственная операция относится к расчетам с клиентами.
//
Функция ЭтоРасчетыСКлиентами(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента")
	 ИЛИ ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратОплатыКлиенту") Тогда
		ЭтоРасчетыСКлиентами = Истина;
	Иначе
		ЭтоРасчетыСКлиентами = Ложь;
	КонецЕсли;
	
	Возврат ЭтоРасчетыСКлиентами;
	
КонецФункции

// Получает пустую ссылку на заказ клиента или на заказ поставщику.
//
// Параметры:
//	Заказ - ДокументСсылка - Заказ
//	ЭтоРасчетыСКлиентами - Булево - Признак отражения расчетов с клиентами.
//
Процедура УстановитьПустуюСсылкуНаЗаказ(Заказ, ЭтоРасчетыСКлиентами) Экспорт
	
	Если Заказ = Неопределено Тогда
		Если ЭтоРасчетыСКлиентами Тогда
			Заказ = ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка");
		Иначе
			Заказ = ПредопределенноеЗначение("Документ.ЗаказПоставщику.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Пересчитывает сумму в шапке документа, если она отличается от сумм в табличной части.
//
// Параметры:
//    Форма - ФормаКлиентскогоПриложения - Форма, из которой подбирается многооборотная тара
//    ОписаниеОповещения - ОписаниеОповещения - Описание оповещения формы документа
//    ИмяТабличнойЧасти - Строка - Имя табличной части, содержащей расшифровку платежа.
//
Процедура ПересчитатьСуммуДокументаПоРасшифровкеПлатежа(
	Знач Форма,
	ОписаниеОповещения,
	Знач ИмяТабличнойЧасти = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда
		ТабличнаяЧасть = Форма.Объект.РасшифровкаПлатежа;
	Иначе
		ТабличнаяЧасть = Форма.Объект[ИмяТабличнойЧасти];
	КонецЕсли;
	
	Если ТабличнаяЧасть.Количество() > 0
		И Форма.Объект.СуммаДокумента <> ТабличнаяЧасть.Итог("Сумма") Тогда
		
		ТекстВопроса = НСтр("ru = 'Сумма по строкам в табличной части не равна сумме документа, пересчитать сумму документа?';
							|en = 'Total amount in the table rows is not equal to the document amount. Recalculate the document amount?'");
		
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("Форма", Форма);
		ДопПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
		ДопПараметры.Вставить("ИмяТабличнойЧасти", ИмяТабличнойЧасти);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПересчитатьСуммуДокументаПоРасшифровкеПлатежаЗавершение", ФинансыКлиент, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПересчитатьСуммуДокументаПоРасшифровкеПлатежаЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		
		Если ДополнительныеПараметры.Свойство("ИмяТабличнойЧасти")
			И ЗначениеЗаполнено(ДополнительныеПараметры.ИмяТабличнойЧасти) Тогда
			ТабличнаяЧасть = ДополнительныеПараметры.Форма.Объект[ДополнительныеПараметры.ИмяТабличнойЧасти];
		Иначе
			ТабличнаяЧасть = ДополнительныеПараметры.Форма.Объект.РасшифровкаПлатежа;
		КонецЕсли;
		
		ДополнительныеПараметры.Форма.Объект.СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Истина);
	Иначе
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Ложь);
	КонецЕсли;
	
КонецПроцедуры

// Открывает файл для просмотра
//
// Параметры:
//    ЭлементПривязки - Строка - К указанному элементу будет привязано сообщение в случае ошибки
//    ИмяФайла - Строка - Полное имя файла
//    Кодировка - Строка - "DOS" или "Windows"
//    Заголовок - Строка - Заголовок формы, в которой будет открыт файл.
//
Процедура ОткрытьФайлДляПросмотра(ЭлементПривязки, ИмяФайла, Кодировка, Заголовок) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяФайла",        ИмяФайла);
	ДополнительныеПараметры.Вставить("Кодировка",       Кодировка);
	ДополнительныеПараметры.Вставить("ЗаголовокФайла",  Заголовок);
	ДополнительныеПараметры.Вставить("ЭлементПривязки", ЭлементПривязки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраСозданиеФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещения, ДополнительныеПараметры.ИмяФайла);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраСозданиеФайла(Файл, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("Файл", Файл);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаСуществования", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуСуществования(ОписаниеОповещения);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраПроверкаСуществования(Существует, ДополнительныеПараметры) Экспорт
	
	Если НЕ Существует Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не обнаружен';
				|en = '%1 is not found'"), ДополнительныеПараметры.ЗаголовокФайла);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
	КонецЕсли;
	
	Файл = ДополнительныеПараметры.Файл;
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраПроверкаНаКаталог", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПроверкуЭтоКаталог(ОписаниеОповещения);
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраПроверкаНаКаталог(ЭтоКаталог, ДополнительныеПараметры) Экспорт
	
	Если ЭтоКаталог Тогда
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 не корректен - выбран ""каталог"".
			|Выберите %1';
			|en = '%1 is incorrect – ""directory"" is selected.
			|Select %1'"), ДополнительныеПараметры.ЗаголовокФайла);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения
			,, ДополнительныеПараметры.ЭлементПривязки);
		
		Возврат;
	КонецЕсли;
	
	ПомещаемыеФайлы = Новый Массив;
	ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.ИмяФайла));
	
	ПомещениеФайловЗавершение = Новый ОписаниеОповещения("ОткрытьФайлДляПросмотраЗавершениеПомещения", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ПомещениеФайловЗавершение, ПомещаемыеФайлы,, Ложь, );
	
КонецПроцедуры

Процедура ОткрытьФайлДляПросмотраЗавершениеПомещения(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныеФайлы <> Неопределено И ПомещенныеФайлы.Количество() > 0 Тогда
		ОписаниеФайлов = ПомещенныеФайлы.Получить(0);
		АдресФайла     = ОписаниеФайлов.Хранение;
		
		Если АдресФайла = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Текст = ДенежныеСредстваВызовСервера.ТекстовыйДокументИзВременногоХранилищаФайла(АдресФайла, ДополнительныеПараметры.Кодировка);
		Текст.Показать(ДополнительныеПараметры.ЗаголовокФайла, ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Показывает оповещение пользователю о заполнении номеров ГТД в строках табличной части документа.
//
Процедура ОповеститьОЗаполненииНомеровГТДвТабличнойЧасти(НомерГТД, ЗаполненыНомераГТД) Экспорт
	
	Если ЗаполненыНомераГТД <> Неопределено И ЗаполненыНомераГТД Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'В строках документа заполнен номер ГТД %1';
				|en = 'The %1 CCD number is filled in document lines'"),
			Строка(НомерГТД));
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Номера ГТД заполнены';
				|en = 'CCD numbers are filled in'"),
			,
			Текст,
			БиблиотекаКартинок.Информация32);
	Иначе
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Ни в одной строке номер ГТД не заполнен';
				|en = 'No lines have CCD numbers filled in'"),
			Строка(НомерГТД));
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Номера ГТД не заполнены';
				|en = 'CCD numbers are required'"),
			,
			Текст,
			БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработки события "ПриНачалеРедактирования" табличной части "РасшифровкаПлатежа".
//
Процедура РасшифровкаПлатежаПриНачалеРедактирования(Объект, Партнер, ДоговорКонтрагента, СтрокаТаблицы, НоваяСтрока, Копирование, СтатьяДвиженияДенежныхСредств = Неопределено) Экспорт
	
	// Необходимо установить пустую ссылку в ОснованиеПлатежа, чтобы был доступен поиск по строке
	Если СтрокаТаблицы <> Неопределено И СтрокаТаблицы.Свойство("ОснованиеПлатежа") Тогда
		ЭтоРасчетыСКлиентами = ЭтоРасчетыСКлиентами(Объект.ХозяйственнаяОперация);
		УстановитьПустуюСсылкуНаЗаказ(СтрокаТаблицы.ОснованиеПлатежа, ЭтоРасчетыСКлиентами);
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		
		Если Копирование Тогда
			
			СуммаОстаток = Объект.СуммаДокумента
				- Объект.РасшифровкаПлатежа.Итог("Сумма")
				+ Объект.РасшифровкаПлатежа[Объект.РасшифровкаПлатежа.Количество()-1].Сумма;
		Иначе
			
			СуммаОстаток = Объект.СуммаДокумента - Объект.РасшифровкаПлатежа.Итог("Сумма");
			
			Если ЗначениеЗаполнено(Партнер) Тогда
				СтрокаТаблицы.Партнер = Партнер;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ДоговорКонтрагента) Тогда
				Если СтрокаТаблицы.Свойство("ОснованиеПлатежа") Тогда
					СтрокаТаблицы.ОснованиеПлатежа = ДоговорКонтрагента;
				КонецЕсли;
				Если ЗначениеЗаполнено(СтатьяДвиженияДенежныхСредств) Тогда
					СтрокаТаблицы.СтатьяДвиженияДенежныхСредств = СтатьяДвиженияДенежныхСредств;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаТаблицы.Сумма = СуммаОстаток;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
