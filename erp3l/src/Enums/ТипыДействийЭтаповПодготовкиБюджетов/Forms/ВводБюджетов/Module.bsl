
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Адрес = Параметры.Адрес;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	
	НастройкиДействия = ПолучитьИзВременногоХранилища(Адрес);

	Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.ВосстановитьНастройкиДействия(НастройкиДействия, ЭтаФорма);
	
	ПараметрыОпций = Новый Структура("МодельБюджетирования", МодельБюджетирования);
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыОпций);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидыБюджетовПриИзменении(Элемент)
	
	Для Каждого СтрокаБюджета Из ВидыБюджетов Цикл
		СтрокаБюджета.НомерСтроки = ВидыБюджетов.Индекс(СтрокаБюджета) + 1;
	КонецЦикла;
	
	УстановитьПредставлениеАналогичныхНастроек(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.ВидыБюджетов.ТекущиеДанные.КлючСтроки = Новый УникальныйИдентификатор();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПередУдалением(Элемент, Отказ)
	
	КлючСтрокиНастройкиАналитики = Элементы.ВидыБюджетов.ТекущиеДанные.КлючСтрокиНастройкиАналитики;
	УдалитьНастройкиАналитик(КлючСтрокиНастройкиАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПредставлениеИзмеренийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
	
	СписокВыбора = НастройкиВидовБюджетов(ТекущиеДанные);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВидыБюджетовПредставлениеИзмеренийВыборЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения,СписокВыбора,Элемент,
		СписокВыбора.НайтиПоЗначению(ТекущиеДанные.КлючСтрокиНастройкиАналитики));

КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПредставлениеИзмеренийВыборЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
		
		ВыбранноеЗначение = РезультатВыбора.Значение;
		
		Если Не ЗначениеЗаполнено(ВыбранноеЗначение) ИЛИ ВыбранноеЗначение = ТекущиеДанные.КлючСтроки Тогда
			ТекущийБюджет = ТекущиеДанные.ВидБюджета;
			КлючСтрокиНастройкиАналитики = ВыбранноеЗначение;
			Если Не ЗначениеЗаполнено(КлючСтрокиНастройкиАналитики) Тогда
				КлючСтрокиНастройкиАналитики = Элементы.ВидыБюджетов.ТекущиеДанные.КлючСтроки; 
			КонецЕсли;
				
			АдресАналитикаЗаполненияБюджета = ПоместитьАналитикаЗаполненияБюджетаВХранилище();

			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("АдресАналитикаЗаполненияБюджета", АдресАналитикаЗаполненияБюджета);
			ПараметрыФормы.Вставить("КлючСтроки", КлючСтрокиНастройкиАналитики);
			ПараметрыФормы.Вставить("ВидБюджета", ТекущийБюджет);
			ПараметрыФормы.Вставить("МодельБюджетирования", МодельБюджетирования);
			
			Оповещение = Новый ОписаниеОповещения("ПриЗакрытииФормыНастройкиАналитикЗаполненияБюджета", ЭтаФорма);
			
			ОткрытьФорму("Перечисление.ТипыДействийЭтаповПодготовкиБюджетов.Форма.НастройкиЗаполненияБюджетаПоУмолчанию",
							ПараметрыФормы,,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе
			Если ТекущиеДанные.КлючСтрокиНастройкиАналитики <> ВыбранноеЗначение Тогда
				УдалитьНастройкиАналитик(ТекущиеДанные.КлючСтрокиНастройкиАналитики);
			КонецЕсли;
			ТекущиеДанные.КлючСтрокиНастройкиАналитики = ВыбранноеЗначение;
			ТекущиеДанные.ПредставлениеИзмерений = РезультатВыбора.Представление;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПредставлениеИзмеренийОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
	Если ТекущиеДанные.КлючСтроки = ТекущиеДанные.КлючСтрокиНастройкиАналитики Тогда
		РезультатВыбора = Новый Структура();
		РезультатВыбора.Вставить("Значение", ТекущиеДанные.КлючСтрокиНастройкиАналитики);
		РезультатВыбора.Вставить("Представление", Нстр("ru = 'Индивидуальные настройки';
														|en = 'Individual settings'"));
		ВидыБюджетовПредставлениеИзмеренийВыборЗавершение(РезультатВыбора, Неопределено)
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыБюджетовПредставлениеИзмеренийОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ВидыБюджетов.ТекущиеДанные;
	УдалитьНастройкиАналитик(ТекущиеДанные.КлючСтрокиНастройкиАналитики);
	ТекущиеДанные.КлючСтрокиНастройкиАналитики = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Отказ = Ложь;
	ОбработкаПроверкиЗаполненияНаКлиенте(Отказ);
	
	Если Не Отказ Тогда
		Закрыть(СохранитьНастройкиНаСервере());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция СохранитьНастройкиНаСервере()
	
	Настройки = Перечисления.ТипыДействийЭтаповПодготовкиБюджетов.НастройкиДействия(ЭтаФорма);
	Возврат ПоместитьВоВременноеХранилище(Настройки, Адрес);
	
КонецФункции

&НаКлиенте
Процедура ПриЗакрытииФормыНастройкиАналитикЗаполненияБюджета(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресАналитик = Результат.Адрес;
	КлючСтрокиНастройкиАналитики = Результат.КлючСтрокиНастройкиАналитики;
	
	ПараметрыОтбора = Новый Структура("КлючСтроки",КлючСтрокиНастройкиАналитики);
	НайденныеСтроки = ВидыБюджетов.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеСтроки.Количество() > 0 Тогда
		НайденныеСтроки[0].КлючСтрокиНастройкиАналитики = КлючСтрокиНастройкиАналитики;
		НайденныеСтроки[0].ПредставлениеИзмерений = Нстр("ru = 'Индивидуальные настройки';
														|en = 'Individual settings'");
	КонецЕсли;
	
	ЗаполнитьНастройкиАналитикЗаполненияБюджетаСервер(АдресАналитик);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройкиАналитикЗаполненияБюджетаСервер(Адрес)
	
	АналитикаЗаполненияБюджета.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеАналогичныхНастроек(ЭтаФорма)
	
	
	
КонецПроцедуры

&НаСервере
Функция ПоместитьАналитикаЗаполненияБюджетаВХранилище()
	
	Если ЗначениеЗаполнено(АдресАналитикаЗаполненияБюджета) Тогда
		АдресАналитикаЗаполненияБюджета = ПоместитьВоВременноеХранилище(АналитикаЗаполненияБюджета.Выгрузить(), АдресАналитикаЗаполненияБюджета);
	Иначе
		АдресАналитикаЗаполненияБюджета = ПоместитьВоВременноеХранилище(АналитикаЗаполненияБюджета.Выгрузить(), УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат АдресАналитикаЗаполненияБюджета;

КонецФункции

&НаКлиенте
Функция НастройкиВидовБюджетов(ТекущиеДанные)
	
	СписокНастроек = Новый СписокЗначений;
	
	Для Каждого Стр Из ВидыБюджетов Цикл
		Если Стр.КлючСтроки <> ТекущиеДанные.КлючСтроки И Стр.КлючСтроки = Стр.КлючСтрокиНастройкиАналитики Тогда
			ПредставлениеНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Аналогично с.%1.%2';
					|en = 'Similar to .%1.%2'"),
				Стр.НомерСтроки,
				Стр.ВидБюджета);	
			СписокНастроек.Добавить(Стр.КлючСтрокиНастройкиАналитики, ПредставлениеНастройки);
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.КлючСтрокиНастройкиАналитики)
		ИЛИ ТекущиеДанные.КлючСтроки = ТекущиеДанные.КлючСтрокиНастройкиАналитики Тогда
		ПредставлениеНастройки = НСтр("ru = 'Индивидуальные настройки';
										|en = 'Individual settings'");	
		СписокНастроек.Добавить(ТекущиеДанные.КлючСтрокиНастройкиАналитики, ПредставлениеНастройки);
	ИначеЕсли ЗначениеЗаполнено(ТекущиеДанные.КлючСтрокиНастройкиАналитики)
		И ТекущиеДанные.КлючСтроки <> ТекущиеДанные.КлючСтрокиНастройкиАналитики Тогда
		ПредставлениеНастройки = НСтр("ru = 'Индивидуальные настройки';
										|en = 'Individual settings'");
		СписокНастроек.Добавить(ТекущиеДанные.КлючСтроки, ПредставлениеНастройки);
	КонецЕсли;
	
	Возврат СписокНастроек;

КонецФункции

&НаКлиенте
Процедура ОбработкаПроверкиЗаполненияНаКлиенте(Отказ)
	
	Для Каждого Стр Из ВидыБюджетов Цикл
		
		Сч = ВидыБюджетов.Индекс(Стр);
		
		Если Не ЗначениеЗаполнено(Стр.ВидБюджета) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не заполнен вид бюджета';
					|en = 'Budget profile in line %1 is not filled in'"),
				Сч+1);
			ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ВидыБюджетов[%1].ВидБюджета",
				Сч);
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, ПутьКДанным, Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Стр.ПредставлениеИзмерений) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В строке %1 не заполнены настройки измерений';
					|en = 'Settings in line %1 is not filled in'"),
				Сч+1);
			ПутьКДанным = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"ВидыБюджетов[%1].ПредставлениеИзмерений",
				Сч); 	
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,, ПутьКДанным,Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройкиАналитик(КлючСтрокиНастройкиАналитики)
	
	ПараметрыОтбора = Новый Структура("КлючСтрокиНастройкиАналитики", КлючСтрокиНастройкиАналитики);
	
	НайденныеСтроки = ВидыБюджетов.НайтиСтроки(ПараметрыОтбора);
	
	Если НайденныеСтроки.Количество() <= 1 Тогда
		ПараметрыОтбора = Новый Структура("КлючСтроки", КлючСтрокиНастройкиАналитики);
		НайденныеСтроки = АналитикаЗаполненияБюджета.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Для Каждого УдаляемыйЭлемент Из НайденныеСтроки Цикл
				АналитикаЗаполненияБюджета.Удалить(УдаляемыйЭлемент);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
