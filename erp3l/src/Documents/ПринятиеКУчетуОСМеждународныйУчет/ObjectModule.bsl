#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипОснования = Тип("ДокументСсылка.ПринятиеКУчетуОС") Тогда
		ЗаполнитьПоДокументуРеглУчета(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	ОсновныеСредства.Очистить();
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	НачислятьАмортизацию = (ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
	АмортизацияПоНаработке = (МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииОС.ПропорциональноОбъемуПродукции);
	
	Если НачислятьАмортизацию И Не АмортизацияПоНаработке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ПоказательНаработки");
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("ПоказательНаработки");
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Или АмортизацияПоНаработке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокИспользования");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Или МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииОС.УменьшаемогоОстатка Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентУскорения");
	КонецЕсли;
	
	Если ПорядокУчета<>Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.СписыватьПриПринятииКУчету Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетРасходов");
	КонецЕсли;
	
	Если НачислятьАмортизацию Тогда
		ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
		ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	КонецЕсли;
	
	КлючевыеРеквизиты = Новый Массив;
	КлючевыеРеквизиты.Добавить("ОсновноеСредство");
	ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(
		ЭтотОбъект, "ОсновныеСредства", КлючевыеРеквизиты, Отказ, НСтр("ru = 'Основные средства';
																		|en = 'Fixed assets'"));
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПринятиеКУчетуОСМеждународныйУчет.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект, "Международный, ОсновныеСредстваМеждународныйУчет");
	
	МеждународныйУчетВнеоборотныеАктивы.ПроверитьВозможностьСменыСостоянияОС(
		ЭтотОбъект,
		ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство"),
		Перечисления.СостоянияОС.ПринятоКУчету,
		Отказ);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДокументуРеглУчета(ДанныеЗаполнения)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПринятиеКУчету.Ссылка КАК ДокументОснование,
		|	ПринятиеКУчету.Организация КАК Организация,
		|	ПринятиеКУчету.Подразделение КАК Подразделение,
		|	ПринятиеКУчету.МетодНачисленияАмортизацииБУ КАК МетодНачисленияАмортизации,
		|	ПринятиеКУчету.СрокИспользованияБУ КАК СрокИспользования,
		|	ПринятиеКУчету.ОС.(
		|		ОсновноеСредство,
		|		ИнвентарныйНомер
		|	) КАК ТабличнаяЧасть
		|ИЗ
		|	Документ.ПринятиеКУчетуОС КАК ПринятиеКУчету
		|ГДЕ
		|	ПринятиеКУчету.Ссылка = &Ссылка"
	);
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Реквизиты);
	ЭтотОбъект.ОсновныеСредства.Загрузить(Реквизиты.ТабличнаяЧасть.Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)

	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Принятие к учету ОС на основании группы ОС невозможен!
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз';
			|en = 'Unable to recognize FA based on FA group.
			|Select FA. To open a group, press Ctrl and the down arrow'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ОрганизацияОС = МеждународныйУчетВнеоборотныеАктивы.ОрганизацияВКоторойОСПринятоКУчету(Основание);
	
	Если ЗначениеЗаполнено(ОрганизацияОС) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Основное средство ""%1"" уже принято к учету.';
										|en = 'The ""%1"" fixed asset is already recognized.'"), Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Основание, "ГруппаОСМеждународныйУчет,ЭксплуатирующееПодразделение,ИнвентарныйНомер");
	
	ГруппаОС = Реквизиты.ГруппаОСМеждународныйУчет;
	Подразделение = Реквизиты.ЭксплуатирующееПодразделение;
	
	НоваяСтрока = ОсновныеСредства.Добавить();
	НоваяСтрока.ОсновноеСредство = Основание;
	НоваяСтрока.ИнвентарныйНомер = Реквизиты.ИнвентарныйНомер;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если ОсновныеСредства.Количество() <> 0 Тогда
		МеждународныйУчетВнеоборотныеАктивы.ПроверитьВозможностьСменыСостоянияОС(
			ЭтотОбъект,
			ОсновныеСредства.ВыгрузитьКолонку("ОсновноеСредство"),
			Перечисления.СостоянияОС.ПринятоКУчету);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли