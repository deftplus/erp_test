#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.АккредитованыеПоставщики.Записывать = Истина;
	Движения.НоменклатураАккредитованыхПоставщиков.Записывать = Истина;
	
	РодителиНоменклатуры = Новый Соответствие;
	
	ЗаписываемДатаНачалаСрокаАккредитации = ДатаНачалаСрокаАккредитации;
	ЗаписываемДатаОкончанияСрокаАккредитации = ДатаОкончанияСрокаАккредитации;
	
	Если РешениеПоДокументу = Перечисления.ВидыРешенийПоДокументуАккредитации.ПоложительноеРешение Тогда
		Если НЕ ЗначениеЗаполнено(АнкетаПоставщика.Контрагент) Тогда
			ПоставщикОбъект = АнкетаПоставщика.ПолучитьОбъект();
			ПоставщикОбъект.Контрагент = АккредитацияПоставщиковУХ.ПолучитьКонтрагентаПоставщика(АнкетаПоставщика);
			ПоставщикОбъект.Записать();
		КонецЕсли;
		СтатусДляЗаписи = Перечисления.СостоянияАккредитацииПоставщиков.Аккредитован;
		
		// Устанавливаем незаполненную дату отправки на проверку
		Если НЕ ЗначениеЗаполнено(ДатаОтправкиНаСогласование) Тогда
			ДатаОтправкиНаСогласование = ТекущаяДата();
		КонецЕсли;
		
		Для Каждого СтрокаНоменклатуры Из НоменклатураПоставщика Цикл
			Движение = Движения.НоменклатураАккредитованыхПоставщиков.Добавить();
			Движение.ДатаАккредитации = Дата;
			Движение.Организация = Организация;
			Движение.АнкетаПоставщика = АнкетаПоставщика;
			Движение.Номенклатура = СтрокаНоменклатуры.Номенклатура;
		КонецЦикла;

		// Записываем общее состояние по холдингу только если состояние документа "Аккредитован".
		// В остальных случаях, либо поставщик аккредитован другими документами (уже есть запись),
		// либо просто не аккредитован.
		Движения.СостоянияАккредитованныхПоставщиков.Записывать = Истина;
		АккредитацияПоставщиковУХ.ДобавитьДвижениеСостояниеАккредитацииПоставщика(
			Движения.СостоянияАккредитованныхПоставщиков,
			АнкетаПоставщика,
			Дата,
			Организация,
			Истина,
			ДатаОкончанияСрокаАккредитации);
			
	ИначеЕсли РешениеПоДокументу = Перечисления.ВидыРешенийПоДокументуАккредитации.РешениеНеПринято Тогда
		СтатусДляЗаписи = ?(ЗначениеЗаполнено(ДатаОтправкиНаСогласование),
								Перечисления.СостоянияАккредитацииПоставщиков.НаРассмотрении,
								Перечисления.СостоянияАккредитацииПоставщиков.Черновик);
		ЗаписываемДатаНачалаСрокаАккредитации = ?(ЗначениеЗаполнено(ДатаОтправкиНаСогласование), ДатаОтправкиНаСогласование, Дата);
		ЗаписываемДатаОкончанияСрокаАккредитации = ЗаписываемДатаНачалаСрокаАккредитации;
		
	ИначеЕсли РешениеПоДокументу = Перечисления.ВидыРешенийПоДокументуАккредитации.Отказ Тогда
		СтатусДляЗаписи = Перечисления.СостоянияАккредитацииПоставщиков.НеАккредитован;
		
	Иначе
		СтатусДляЗаписи = Перечисления.СостоянияАккредитацииПоставщиков.Черновик;
		ЗаписываемДатаНачалаСрокаАккредитации = Дата;
		ЗаписываемДатаОкончанияСрокаАккредитации = ЗаписываемДатаНачалаСрокаАккредитации;
	КонецЕсли;
			
	// Записываем новое состояние аккредитации
	Движение = Движения.АккредитованыеПоставщики.Добавить();
	Движение.Период = Дата;
	Движение.Организация = Организация;
	Движение.АнкетаПоставщика = АнкетаПоставщика;
	Движение.ДатаНачала = ЗаписываемДатаНачалаСрокаАккредитации;
	Движение.ДатаОкончания = ЗаписываемДатаОкончанияСрокаАккредитации;
	Движение.Состояние = СтатусДляЗаписи;
	Движение.Контрагент = АнкетаПоставщика.Контрагент;
	
	Если СтатусДляЗаписи = Перечисления.СостоянияАккредитацииПоставщиков.Аккредитован Тогда
		АккредитацияПоставщиковУХ.ЗарегистрироватьЭТППоставщика(
			АнкетаПоставщика,
			АнкетаПоставщика.ИспользуемыеЭТП.ВыгрузитьКолонку("ЭТП"));
	Иначе
		АккредитацияПоставщиковУХ.СтеретьЭТППоставщика(АнкетаПоставщика);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Ошибки = Неопределено;
	ПроверитьПередЗаписью(РежимЗаписи, Ошибки);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(
		Ошибки,
		Отказ);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		ТипЗаполнения = ТипЗнч(ДанныеЗаполнения);
		
		Если ТипЗаполнения = Тип("Структура") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
			
		Иначе
			Если НЕ ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(ДанныеЗаполнения.Ссылка) Тогда
				ВызватьИсключение НСтр("ru = 'Ввод на основании можно делать только на основании утвержденного объекта.'");
			КонецЕсли;
			Если Документы.ТипВсеСсылки().СодержитТип(ТипЗаполнения) Тогда
				Если НЕ ДанныеЗаполнения.Проведен Тогда
					ВызватьИсключение НСтр("ru = 'Ввод на основании можно делать только на основании проведенного документа.'");
				КонецЕсли;
			КонецЕсли;
			
			Если ТипЗаполнения = Тип("СправочникСсылка.АнкетыПоставщиков") Тогда
				АнкетаПоставщика = ДанныеЗаполнения;
			ИначеЕсли ТипЗаполнения = Тип("ДокументСсылка.АккредитацияПоставщика") Тогда
				АнкетаПоставщика = ДанныеЗаполнения.АнкетаПоставщика;
				Организация = ДанныеЗаполнения.Организация;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЭтоВнешнийПользователь = ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя();
	Если ЭтоВнешнийПользователь Тогда
		ТекущийПользователь = Пользователи.АвторизованныйПользователь();
		АнкетаПоставщика = ТекущийПользователь.ОбъектАвторизации;
		
	Иначе
		Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
			Ответственный = Пользователи.ТекущийПользователь();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РешениеПоДокументу) Тогда
		РешениеПоДокументу = Перечисления.ВидыРешенийПоДокументуАккредитации.РешениеНеПринято;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Дата) Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаНачалаСрокаАккредитации) Тогда
		Если НЕ ЗначениеЗаполнено(Дата) Тогда
			ДатаНачалаСрокаАккредитации = ТекущаяДатаСеанса();
		Иначе
			ДатаНачалаСрокаАккредитации = Дата;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АнкетаПоставщика) И ЗначениеЗаполнено(Организация) Тогда
		ПредыдущаяАккредитация = АккредитацияПоставщиковУХ.ПредыдущаяАккредитация(Организация, АнкетаПоставщика, Дата);
		ЭтоПовторнаяАккредитация = ЭтоПовторнаяАккредитация ИЛИ ЗначениеЗаполнено(ПредыдущаяАккредитация);

		ДанныеАккредитации = АккредитацияПоставщиковУХ.ПолучитьДанныеАккредитацииПоставщика(Организация, АнкетаПоставщика, Дата);
		Если ДанныеАккредитации <> Неопределено
				И ДанныеАккредитации.Состояние = Перечисления.СостоянияАккредитацииПоставщиков.ЛишенАккредитации
				И ДанныеАккредитации.ДатаНачала <= Дата И Дата <= ДанныеАккредитации.ДатаОкончания Тогда
			ВызватьИсключение НСтр("ru = 'Аккредитация не может быть введена так как на поставщика наложен мораторий.'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоПовторнаяАккредитация Тогда
		Если НЕ ЗначениеЗаполнено(ПричинаПереаккредитации) Тогда
			ПричинаПереаккредитации = Перечисления.ПричинаПереаккредитации.ПродлениеСрока;
		КонецЕсли;
		
		ДатаНачалаСрокаАккредитации = ПредыдущаяАккредитация.ДатаОкончанияСрокаАккредитации + 60*60*24;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаОкончанияСрокаАккредитации) Тогда
		ДатаОкончанияСрокаАккредитации = ДобавитьМесяц(ДатаНачалаСрокаАккредитации, АккредитацияПоставщиковУХ.СрокАккредитацииПоставщикаПоУмолчаниюВМесяцах());
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(РешениеПоДокументу) И РешениеПоДокументу <> Перечисления.ВидыРешенийПоДокументуАккредитации.РешениеНеПринято Тогда
		ПроверяемыеРеквизиты.Добавить("ОбоснованиеРешения");
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьПередЗаписью(РежимЗаписи, Ошибки) Экспорт
	ДругойДокумент = Документы.АккредитацияПоставщика.ПолучитьАналогичныйДокумент(
		ЭтотОбъект);
	Если ЗначениеЗаполнено(ДругойДокумент) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
			Ошибки,
			"",
			НСтр("ru='Уже есть аккредитация поставщика '") + ДругойДокумент,
			Неопределено);
	КонецЕсли;
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если ОбщиеТребования.Количество() = 0 
				ИЛИ НоменклатураПоставщика.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки,
				"",
				НСтр("ru='Нет данных для аккредитации. Необходимо заполнить требования к поставщику и список поставляемой номенклатуры.'"),
				Неопределено);
		КонецЕсли;
		ДанныеАккредитации =
			АккредитацияПоставщиковУХ.ПолучитьДанныеАккредитацииПоставщика(
				Организация,
				АнкетаПоставщика,
				ДатаНачалаСрокаАккредитации);
		Если ДанныеАккредитации <> Неопределено Тогда
			Если ДанныеАккредитации.Состояние =	Перечисления.СостоянияАккредитацииПоставщиков.ЛишенАккредитации
					И ДанныеАккредитации.ДатаОкончания <= Дата
					И ДанныеАккредитации.ДатаНачала >= Дата Тогда
				ТекстОшибки = НСтр("ru = 'Поставщику ""%АнкетаПоставщика%"" запрещена аккредитация с %ДатаНачала% по %ДатаОкончания%'");
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%АнкетаПоставщика%", Строка(АнкетаПоставщика));
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаНачала%", Строка(ДанныеАккредитации.ДатаНачала));
				ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ДатаОкончания%", Строка(ДанныеАккредитации.ДатаОкончания));
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,	"",	ТекстОшибки, Неопределено);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	АккредитацияПоставщиковУХ.СтеретьЭТППоставщика(АнкетаПоставщика);
КонецПроцедуры


#КонецЕсли