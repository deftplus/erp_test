#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИсправлениеДокументов.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	// Очистим табличную часть документа.
	Если Задолженность.Количество() > 0 Тогда
		Задолженность.Очистить();
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Задолженность");
	
	СписаниеЗадолженностиЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
	Автор = Пользователи.ТекущийПользователь();

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") 
		И ДанныеЗаполнения.Свойство("АктОРасхождениях") Тогда
		
		ЗаполнитьНаОснованииАктаОРасхождениях(ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка." + Метаданные().Имя) Тогда
		
		ИсправлениеДокументов.ЗаполнитьИсправление(ЭтотОбъект, ДанныеЗаполнения);
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеЗадолженности.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	СписаниеЗадолженностиЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если РасчетыМеждуОрганизациями Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Задолженность.Партнер");
	КонецЕсли;
		
	ИсправлениеДокументов.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Контрагент) И (Организация=Контрагент) Тогда
		Текст = НСтр("ru = 'Организация и %Контрагент% должны различаться.';
					|en = 'Company and %Контрагент% should be different.'");
		
		ТипЗадолженности = ?(ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности,
												Перечисления.ТипыЗадолженности.Кредиторская,
												Перечисления.ТипыЗадолженности.Дебиторская);
		
		Текст = СтрЗаменить(Текст,"%Контрагент%",Перечисления.ТипыЗадолженности.СинонимКонтрагента(ТипЗадолженности));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст,ЭтотОбъект,"Контрагент",,Отказ);
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеЗадолженности.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	СписаниеЗадолженностиЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ИсправлениеДокументов.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		// Заполнение валюты взаиморасчетов если выключена ФО "ИспользоватьНесколькоВалют"
		Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
			ВалютаВзаиморасчетов = Неопределено;
			Для Каждого СтрокаТЧ Из Задолженность Цикл
				Если Не ЗначениеЗаполнено(СтрокаТЧ.ВалютаВзаиморасчетов) Тогда
					Если ВалютаВзаиморасчетов = Неопределено Тогда
						ВалютаВзаиморасчетов = Константы.ВалютаУправленческогоУчета.Получить();
					КонецЕсли;
					СтрокаТЧ.ВалютаВзаиморасчетов = ВалютаВзаиморасчетов;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеЗадолженности.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	//++ НЕ УТ
	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.СписаниеЗадолженности.ПараметрыНастройкиСчетовУчета(ХозяйственнаяОперация));
	//-- НЕ УТ
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Задолженность");
	
	СписаниеЗадолженностиЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	СписаниеЗадолженностиЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	СписаниеЗадолженностиЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	СписаниеЗадолженностиЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ЗаполнитьНаОснованииАктаОРасхождениях(ДанныеЗаполнения)

	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	АктОРасхожденияхПослеПриемки.Организация   КАК Организация,
	|	АктОРасхожденияхПослеПриемки.Подразделение КАК Подразделение,
	|	&ОснованиеАкта                             КАК Основание,
	|	АктОРасхожденияхПослеПриемки.Ссылка        КАК АктОРасхожденияхОснование,
	|	АктОРасхожденияхПослеПриемки.Валюта        КАК Валюта
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки КАК АктОРасхожденияхПослеПриемки
	|ГДЕ
	|	АктОРасхожденияхПослеПриемки.Ссылка = &АктОРасхождениях
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(АктОРасхожденияхПослеПриемкиТовары.СуммаПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Сумма) КАК Сумма
	|ИЗ
	|	Документ.АктОРасхожденияхПослеПриемки.Товары КАК АктОРасхожденияхПослеПриемкиТовары
	|ГДЕ
	|	АктОРасхожденияхПослеПриемкиТовары.Ссылка = &АктОРасхождениях
	|	И АктОРасхожденияхПослеПриемкиТовары.ДокументОснование = &ОснованиеАкта
	|	И АктОРасхожденияхПослеПриемкиТовары.СуммаПоДокументу - АктОРасхожденияхПослеПриемкиТовары.Сумма > 0
	|	И АктОРасхожденияхПослеПриемкиТовары.ПоВинеСтороннейКомпании
	|	И АктОРасхожденияхПослеПриемкиТовары.Действие = ЗНАЧЕНИЕ(Перечисление.ВариантыДействийПоРасхождениямВАктеПослеПриемки.ОтнестиНедостачуНаПрочиеРасходы)";
	
	Запрос.УстановитьПараметр("АктОРасхождениях", ДанныеЗаполнения.АктОРасхождениях);
	Запрос.УстановитьПараметр("ОснованиеАкта", ДанныеЗаполнения.ОснованиеАкта);
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаШапка = Результат[0].Выбрать();
	
	Если ВыборкаШапка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаШапка);
	Иначе
		Возврат;
	КонецЕсли;
	
	ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеКредиторскойЗадолженности;
	
	ВыборкаСумма = Результат[1].Выбрать();
	Если ВыборкаСумма.Следующий() Тогда
		Если ВыборкаСумма.Сумма > 0 Тогда
			НоваяСтрока = Задолженность.Добавить();
			НоваяСтрока.ВалютаВзаиморасчетов = ВыборкаШапка.Валюта;
			НоваяСтрока.Сумма = ВыборкаСумма.Сумма;
			НоваяСтрока.ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСПоставщиком;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Пользователи.ТекущийПользователь(), Подразделение);
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
