#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		
		ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
		Если ТипДанныхЗаполнения = Тип("Структура") Тогда
			
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыЗаполнения = Документы.ПодготовкаКПередачеОС.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	ИнициализироватьДокумент();	

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ПараметрыЗаполнения = Документы.ПодготовкаКПередачеОС.ПараметрыЗаполненияНалогообложенияНДСПродажи(ЭтотОбъект);
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, ОС);
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	Если ПоддержкаОтложенногоПереходаПрав Или Не ПередачаВыполнена Тогда
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов");
	Иначе
		ПараметрыВыбораСтатейИАналитик = Документы.ПодготовкаКПередачеОС.ПараметрыВыбораСтатейИАналитик();
		ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	КонецЕсли;
	
	Если Не ПередачаВыполнена Тогда
		НепроверяемыеРеквизиты.Добавить("ДатаПередачи");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		РассчитатьАмортизацию(Отказ);
		УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПодготовкаКПередачеОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ТаблицаРеквизитов = ТаблицаРеквизитовДокумента();
	
	Документы.ПодготовкаКПередачеОС.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Подготовка к передаче ОС';
			|en = 'Preparation for FA handover'"));
	
	УчетОСВызовСервера.ПроверитьСоответствиеОСОрганизации(ЭтотОбъект.ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСостояниеОСПринятоКУчету(ЭтотОбъект.ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьСоответствиеМестонахожденияОС(ЭтотОбъект.ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	УчетОСВызовСервера.ПроверитьЗаполнениеСчетаУчетаОС(ЭтотОбъект.ОС.Выгрузить(), ТаблицаРеквизитов, Отказ);
	
	ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	ДопПараметры.ДополнительныеСвойства = ДополнительныеСвойства;
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ, ДопПараметры);
	
	Если Не Отказ Тогда
		РеглУчетПроведениеСервер.ОтразитьДокумент(Новый Структура("Ссылка, Дата, Организация", Ссылка, Дата));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
	Если Не ЗначениеЗаполнено(СобытиеПодготовкиОС) Тогда
		СобытиеПодготовкиОС = УчетОСВызовСервера.ПолучитьСобытиеПоОСИзСправочника(Перечисления.ВидыСобытийОС.ПодготовкаКПередаче);
	КонецЕсли;
	
	ПоддержкаОтложенногоПереходаПрав = Истина;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПодготовкаКПередачеОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Функция ТаблицаРеквизитовДокумента()
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&Ссылка КАК Регистратор,
		|	&Дата КАК Период,
		|	НАЧАЛОПЕРИОДА(&Дата, МЕСЯЦ) КАК ДатаРасчета,
		|	&Номер,
		|	&Организация,
		|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета) КАК СостояниеОС,
		|	""ОС"" КАК ИмяСписка,
		|	ИСТИНА КАК ВыдаватьСообщения,
		|	&Подразделение КАК Подразделение,
		|	НЕОПРЕДЕЛЕНО КАК МОЛ");
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Номер", Номер);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура РассчитатьАмортизацию(Отказ)
	
	НачисленнаяАмортизация.Очистить();
	
	ТаблицаНачисленнаяАмортизация = УчетОСВызовСервера.НачисленнаяАмортизация(
		ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство"), ТаблицаРеквизитовДокумента(),, Отказ);
	
	ДополнительныеСвойства.Вставить("НачисленнаяАмортизация", ТаблицаНачисленнаяАмортизация);
	НачисленнаяАмортизация.Загрузить(ТаблицаНачисленнаяАмортизация);
	
КонецПроцедуры

Процедура УстановитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете()
	
	Если НЕ Проведен Тогда
		Возврат;
	КонецЕсли;
	
	НепроверяемыеРеквизиты = Новый Структура;
	НепроверяемыеРеквизиты.Вставить("Комментарий");
	
	ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(ЭтотОбъект, НепроверяемыеРеквизиты);
	
	Если ИзмененияДокумента.Свойство("ТабличныеЧасти") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыПередачиОС = Новый Структура;
	РеквизитыПередачиОС.Вставить("ПередачаВыполнена");
	РеквизитыПередачиОС.Вставить("СобытиеПередачиОС");
	РеквизитыПередачиОС.Вставить("ДатаПередачи");
	
	РегистрацияТолькоПоДатеПередачи = Истина;
	
	Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
		
		Для каждого Реквизит Из ИзмененияДокумента.Реквизиты Цикл
			Если Реквизит.Имя = "ДатаПередачи" И НачалоДня(Реквизит.СтароеЗначение) = НачалоДня(Дата) Тогда
				РегистрацияТолькоПоДатеПередачи = Ложь;
				Прервать;
			КонецЕсли;
			Если НЕ РеквизитыПередачиОС.Свойство(Реквизит.Имя) Тогда
				РегистрацияТолькоПоДатеПередачи = Ложь;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если НЕ РегистрацияТолькоПоДатеПередачи Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаВыборочнойРегистрации = РеглУчетПроведениеСервер.ТаблицаВыборочнойРегистрацииКОтражению();
	РеглУчетПроведениеСервер.ДобавитьПараметрыВыборочнойРегистрацииКОтражениюВРеглУчете(
		ТаблицаВыборочнойРегистрации, Организация, ДатаПередачи);
	ПроведениеДокументов.ДобавитьТаблицуДанныхДокумента(ЭтотОбъект,
		"ТаблицаВыборочнойРегистрацииКОтражению", ТаблицаВыборочнойРегистрации);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли