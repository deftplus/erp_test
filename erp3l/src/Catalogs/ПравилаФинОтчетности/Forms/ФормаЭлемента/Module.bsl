#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокПолучателей();
	ЗаполнитьСписокКомплектов();
	
	Если НЕ ЗначениеЗаполнено(Объект.НачалоВыполнения) Тогда
		Объект.НачалоВыполнения = НачалоМесяца(УниверсальныйОбменСБанкамиВызовСервера.ТекущаяДатаНаСервере());
	КонецЕсли;
	
	ОбновитьПредставлениеНачалаВыполнения(ЭтотОбъект);
	ОбновитьПредставлениеОкончанияВыполнения(ЭтотОбъект);
	
	ПредыдущаяОрганизация = Объект.Организация;
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОтборПоСубъекту = Новый Структура();
		ОтборПоСубъекту.Вставить("Субъект", Объект.Организация);
		НайденныеСтроки = Объект.ЭкономическиеСубъекты.НайтиСтроки(ОтборПоСубъекту);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			ИдентификаторСтроки = ДобавитьНовыйЭкономическийСубъект(ЭтотОбъект, Объект.Организация, Ложь);
			Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
	Для каждого Субъект Из Объект.ЭкономическиеСубъекты Цикл
		Субъект.Наименование = ЗаполнениеФинОтчетностиВБанкиКлиентСервер.СформироватьНаименованиеСубъекта(
			Субъект.Субъект, Субъект.ВключатьОбособленныеПодразделения);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Новый Структура("Идентификатор", Объект.ИдентификаторКомплекта));
	КраткоеПредставлениеКомплекта = ?(НайденныеСтроки.Количество() > 0, НайденныеСтроки[0].КраткоеПредставление, "");
	
	Объект.Наименование = УниверсальныйОбменСБанкамиФормыКлиентСервер.НаименованиеПравилаФинОтчетности(
		Объект.Получатель, КраткоеПредставлениеКомплекта, Объект.Организация);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Новый Структура("Получатель", Объект.Получатель));
	Если НайденныеСтроки.Количество() = 0 Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
			НСтр("ru = 'Получатель';
				|en = 'Recipient'"),,, НСтр("ru = 'Выбранному получателю регулярная отчетность не требуется.';
												|en = 'Selected recipient does not require regular reporting.'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.Получатель",, Отказ);
		
		// Проверять дальше не имеет смысла.
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("Объект"));
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Новый Структура("Идентификатор", Объект.ИдентификаторКомплекта));
	Если НайденныеСтроки.Количество() > 0 Тогда
		ОписаниеКомплекта = НайденныеСтроки[0];
		
		Если ЗначениеЗаполнено(ОписаниеКомплекта.ДатаНачала)
			И Объект.НачалоВыполнения < ОписаниеКомплекта.ДатаНачала Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Сдается с';
					|en = 'Submitted from'"),,, СтрШаблон(НСтр("ru = 'Начало применения комплекта: %1';
															|en = 'Start of set application: %1'"),
					Формат(ОписаниеКомплекта.ДатаНачала, "ДФ='MMMM гггг'")));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеНачалаПериода",, Отказ);
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОписаниеКомплекта.ДатаОкончания)
			И ЗначениеЗаполнено(Объект.ОкончаниеВыполнения)
			И Объект.ОкончаниеВыполнения > ОписаниеКомплекта.ДатаОкончания Тогда
			
			ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
				НСтр("ru = 'Сдается по';
					|en = 'Submitted by'"),,, СтрШаблон(НСтр("ru = 'Окончание применения комплекта: %1';
															|en = 'End of set application: %1'"),
					Формат(ОписаниеКомплекта.ДатаОкончания, "ДФ='MMMM гггг'")));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеОкончанияПериода",, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.НачалоВыполнения)
		И ЗначениеЗаполнено(Объект.ОкончаниеВыполнения)
		И Объект.НачалоВыполнения > Объект.ОкончаниеВыполнения Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Корректность",
			НСтр("ru = 'Сдается с';
				|en = 'Submitted from'"),,, НСтр("ru = 'Начало отчетного периода не может быть позже его окончания';
											|en = 'The reporting period start cannot be later than its end'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПредставлениеНачалаПериода",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьОрганизацию(Команда)
	
	НачатьДобавлениеОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьКонтрагента(Команда)
	
	НачатьДобавлениеКонтрагента();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОтборПоСубъекту = Новый Структура();
		ОтборПоСубъекту.Вставить("Субъект", Объект.Организация);
		НайденныеСтроки = Объект.ЭкономическиеСубъекты.НайтиСтроки(ОтборПоСубъекту);
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			ИдентификаторСтроки = ДобавитьНовыйЭкономическийСубъект(ЭтотОбъект, Объект.Организация, Ложь);
			Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.Организация <> ПредыдущаяОрганизация Тогда
		ОтборПоСубъекту = Новый Структура();
		ОтборПоСубъекту.Вставить("Субъект", ПредыдущаяОрганизация);
		НайденныеСтроки = Объект.ЭкономическиеСубъекты.НайтиСтроки(ОтборПоСубъекту);
		
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Объект.ЭкономическиеСубъекты.Удалить(Объект.ЭкономическиеСубъекты.Индекс(НайденнаяСтрока));
		КонецЦикла;
		
		ПредыдущаяОрганизация = Объект.Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ЗаполнитьСписокКомплектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторКомплектаПриИзменении(Элемент)
	
	ОбработкаИзмененияИдентификатора(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыполненияПриИзменении(Элемент)
	
	ОбновитьПредставлениеНачалаВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(Объект.НачалоВыполнения), КонецМесяца(Объект.НачалоВыполнения));
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьНачалоВыполненияЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбораПериода, Элементы.НачалоВыполнения,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПериодПоУмолчанию = ?(ЗначениеЗаполнено(Объект.ОкончаниеВыполнения), Объект.ОкончаниеВыполнения, ТекущаяДата());
	
	ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(ПериодПоУмолчанию), КонецМесяца(ПериодПоУмолчанию));
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьОкончаниеВыполненияЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбораПериода, Элементы.ОкончаниеВыполнения,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Объект.ОкончаниеВыполнения = Дата(1, 1, 1);
	
	ОбновитьПредставлениеОкончанияВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВыполненияПриИзменении(Элемент)
	
	ОбновитьПредставлениеОкончанияВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкономическиеСубъектыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЭкономическиеСубъекты.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Субъект) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, ТекущиеДанные.Субъект);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЭкономическиеСубъектыПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ЭкономическиеСубъекты.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ЭкономическиеСубъектыКонтекстноеМенюУдалить.Доступность =
		Не Элементы.ЭкономическиеСубъекты.ТекущиеДанные.Субъект = Объект.Организация;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкономическиеСубъектыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	// Вместо стандартного окна покажем сначала выбор типа экономического субъекта.
	Отказ = Истина;
	
	СписокВариантов = Новый СписокЗначений;
	СписокВариантов.Добавить("Организация", НСтр("ru = 'Организация';
												|en = 'Company'"));
	СписокВариантов.Добавить("Контрагент",  НСтр("ru = 'Контрагент';
												|en = 'Counterparty'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЭкономическиеСубъектыПередНачаломДобавленияЗавершение", ЭтотОбъект);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, СписокВариантов);

КонецПроцедуры

&НаКлиенте
Процедура ЭкономическиеСубъектыПередУдалением(Элемент, Отказ)
	
	Если Элементы.ЭкономическиеСубъекты.ТекущиеДанные.Субъект = Объект.Организация Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокПолучателей()
	
	СписокВыбора = Элементы.Получатель.СписокВыбора;
	СписокВыбора.Очистить();
	
	ДоступныеПолучатели = ФинОтчетностьВБанки.ДоступныеБанки(Ложь);
	
	Для каждого ЭлементСписка Из ДоступныеПолучатели Цикл
		Если ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(ЭлементСписка.Значение) Тогда
			СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокКомплектов()
	
	Если ЗначениеЗаполнено(Объект.Получатель) Тогда
		НайденныеСтроки = КомплектыОтчетности.НайтиСтроки(Новый Структура("Получатель", Объект.Получатель));
		Если НайденныеСтроки.Количество() = 0 Тогда
			Если ФинОтчетностьВБанкиКлиентСервер.ЭтоБанкУниверсальногоОбмена(Объект.Получатель) Тогда
				КомплектыОтчетностиПолучателя = ЗаполнениеФинОтчетностиВБанки.КомплектыОтчетности(Объект.Получатель);
				Для каждого СтрокаКомплекта Из КомплектыОтчетностиПолучателя Цикл
					Если Не ЗначениеЗаполнено(СтрокаКомплекта.Периодичность) Тогда
						Продолжить;
					КонецЕсли;
					НоваяСтрока = КомплектыОтчетности.Добавить();
					НоваяСтрока.Получатель = Объект.Получатель;
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКомплекта);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьСписокКомплектов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписокКомплектов(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СписокВыбора = Элементы.ИдентификаторКомплекта.СписокВыбора;
	СписокВыбора.Очистить();
	
	Отбор = Новый Структура;
	Отбор.Вставить("Получатель", Объект.Получатель);
	
	НайденныеСтроки = Форма.КомплектыОтчетности.НайтиСтроки(Отбор);
	Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		СписокВыбора.Добавить(НайденнаяСтрока.Идентификатор, НайденнаяСтрока.КраткоеПредставление);
	КонецЦикла;
	
	Если СписокВыбора.НайтиПоЗначению(Объект.ИдентификаторКомплекта) = Неопределено Тогда
		Объект.ИдентификаторКомплекта = "";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ИдентификаторКомплекта)
		И СписокВыбора.Количество() > 0 Тогда
		Объект.ИдентификаторКомплекта = СписокВыбора[0].Значение;
	КонецЕсли;
	
	ОбработкаИзмененияИдентификатора(Форма);
	
	ДоступноНесколькоКомплектов = СписокВыбора.Количество() > 1;
	Элементы.ИдентификаторКомплекта.ТолькоПросмотр = НЕ ДоступноНесколькоКомплектов;
	
	Форма.Элементы.ГруппаНастройкаПериодичности.Видимость =
		ЗначениеЗаполнено(Объект.Получатель) И СписокВыбора.Количество() > 0;
	Форма.Элементы.ДекорацияНетПериодичности.Видимость =
		ЗначениеЗаполнено(Объект.Получатель) И СписокВыбора.Количество() = 0;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработкаИзмененияИдентификатора(Форма)
	
	Объект = Форма.Объект;
	
	НайденныеСтроки = Форма.КомплектыОтчетности.НайтиСтроки(Новый Структура("Идентификатор",
		Объект.ИдентификаторКомплекта));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		Объект.КраткоеПредставлениеКомплекта = "";
		Объект.ПредставлениеПериодичности = "";
		Объект.Периодичность = Неопределено;
		Форма.ПредставлениеПериодичности = "";
	Иначе
		ОписаниеКомплекта = НайденныеСтроки[0];
		
		Объект.КраткоеПредставлениеКомплекта = ОписаниеКомплекта.КраткоеПредставление;
		
		Объект.ПредставлениеПериодичности = "";
		ПериодВРодительномПадеже = "";
		
		Если НРег(ОписаниеКомплекта.Периодичность) = НРег("Месяц") Тогда
			Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц");
			Объект.ПредставлениеПериодичности = НСтр("ru = 'Ежемесячно';
													|en = 'Monthly'");
			ПериодВРодительномПадеже = НСтр("ru = 'месяца';
											|en = 'month'");
			
		ИначеЕсли НРег(ОписаниеКомплекта.Периодичность) = НРег("Квартал") Тогда
			Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал");
			Объект.ПредставлениеПериодичности = НСтр("ru = 'Ежеквартально';
													|en = 'Quarterly'");
			ПериодВРодительномПадеже = НСтр("ru = 'квартала';
											|en = 'quarter'");
		ИначеЕсли НРег(ОписаниеКомплекта.Периодичность) = НРег("Год") Тогда
			Объект.Периодичность = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
			Объект.ПредставлениеПериодичности = НСтр("ru = 'Ежегодно';
													|en = 'Annually'");
			ПериодВРодительномПадеже = НСтр("ru = 'года';
											|en = 'year'");
		КонецЕсли;
		
		ПредставлениеСрокаСдачи = НСтр("ru = 'последнего дня ';
										|en = 'last day '") + ПериодВРодительномПадеже;
		
		Если ОписаниеКомплекта.СрокПредставленияМесяцев <> 0
			Или ОписаниеКомплекта.СрокПредставленияДней <> 0 Тогда
			
			ПредставлениеСрокаСдачи = ?(ОписаниеКомплекта.СрокПредставленияМесяцев <> 0,
				СтрШаблон(НСтр("ru = '%1 мес. ';
								|en = '%1 month. '"), ОписаниеКомплекта.СрокПредставленияМесяцев), "");
			
			ШаблонДней = ?(ОписаниеКомплекта.СрокПредставленияВРабочихДнях,
				НСтр("ru = '%1 раб. дн.';
					|en = '%1 workdays'"),
				НСтр("ru = '%1 дн.';
					|en = '%1 days'"));
			
			ПредставлениеСрокаСдачи = ПредставлениеСрокаСдачи +
				?(ОписаниеКомплекта.СрокПредставленияДней <> 0,
					СтрШаблон(ШаблонДней, ОписаниеКомплекта.СрокПредставленияДней), "");
			
			ПредставлениеСрокаСдачи = СокрЛП(ПредставлениеСрокаСдачи)
				+ НСтр("ru = ' после окончания ';
						|en = ' after the end '") + ПериодВРодительномПадеже;
			
		КонецЕсли;
		
		Форма.ПредставлениеПериодичности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1, не позднее %2';
				|en = '%1, not later than %2'"),
			Объект.ПредставлениеПериодичности,
			ПредставлениеСрокаСдачи);
		
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНачалоВыполненияЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.НачалоВыполнения = РезультатВыбора.НачалоПериода;
	
	ОбновитьПредставлениеНачалаВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОкончаниеВыполненияЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ОкончаниеВыполнения = РезультатВыбора.НачалоПериода;
	
	ОбновитьПредставлениеОкончанияВыполнения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеНачалаВыполнения(Форма)
	
	Объект = Форма.Объект;
	
	Форма.ПредставлениеНачалаПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"),
		НачалоМесяца(Объект.НачалоВыполнения),
		КонецМесяца(Объект.НачалоВыполнения));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредставлениеОкончанияВыполнения(Форма)
	
	Объект = Форма.Объект;
	
	Если НЕ ЗначениеЗаполнено(Объект.ОкончаниеВыполнения) Тогда
		Форма.ПредставлениеОкончанияПериода = НСтр("ru = 'Бессрочно';
													|en = 'Permanent'");
	Иначе
		Форма.ПредставлениеОкончанияПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
			ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"),
			НачалоМесяца(Объект.ОкончаниеВыполнения),
			КонецМесяца(Объект.ОкончаниеВыполнения));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеОрганизации()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьДобавлениеОрганизации", ЭтотОбъект);
	ОткрытьФорму("Документ.ФинОтчетВБанк.Форма.ФормаВыборОрганизации",, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьДобавлениеОрганизации(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоСубъекту = Новый Структура();
	ОтборПоСубъекту.Вставить("Субъект",                          РезультатЗакрытия.Организация);
	ОтборПоСубъекту.Вставить("ВключатьОбособленныеПодразделения", РезультатЗакрытия.ВключатьОбособленныеПодразделения);
	
	НайденныеСтроки = Объект.ЭкономическиеСубъекты.НайтиСтроки(ОтборПоСубъекту);
	Если НайденныеСтроки.Количество() > 0 Тогда
		// Выделим найденную строку.
		Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	Иначе
		ИдентификаторСтроки = ДобавитьНовыйЭкономическийСубъект(ЭтотОбъект, РезультатЗакрытия.Организация,
			РезультатЗакрытия.ВключатьОбособленныеПодразделения);
		Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = ИдентификаторСтроки;
		Модифицированность = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеКонтрагента()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьДобавлениеКонтрагента", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора",, ЭтотОбъект,,,, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьДобавлениеКонтрагента(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоСубъекту = Новый Структура("Субъект", РезультатЗакрытия);
	НайденныеСтроки = Объект.ЭкономическиеСубъекты.НайтиСтроки(ОтборПоСубъекту);
	Если НайденныеСтроки.Количество() > 0 Тогда
		// Выделим найденную строку.
		Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	Иначе
		ИдентификаторСтроки = ДобавитьНовыйЭкономическийСубъект(ЭтотОбъект, РезультатЗакрытия, Ложь);
		Элементы.ЭкономическиеСубъекты.ТекущаяСтрока = ИдентификаторСтроки;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьНовыйЭкономическийСубъект(Форма, Субъект, ВключатьОбособленныеПодразделения)
	
	Объект = Форма.Объект;
	
	НоваяСтрока                                   = Объект.ЭкономическиеСубъекты.Добавить();
	НоваяСтрока.Субъект                           = Субъект;
	НоваяСтрока.ВключатьОбособленныеПодразделения = ВключатьОбособленныеПодразделения;
	НоваяСтрока.Наименование                      = ЗаполнениеФинОтчетностиВБанкиКлиентСервер.СформироватьНаименованиеСубъекта(Субъект,
		ВключатьОбособленныеПодразделения);
	
	Возврат НоваяСтрока.ПолучитьИдентификатор();
	
КонецФункции

&НаКлиенте
Процедура ЭкономическиеСубъектыПередНачаломДобавленияЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт

	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйЭлемент.Значение = "Организация" Тогда
		НачатьДобавлениеОрганизации();
	Иначе
		НачатьДобавлениеКонтрагента();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

