
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
	СтруктураИзменяемыхРеквизитов = СтруктураИзменяемыхРеквизитов();
	Для Каждого КлючИЗначение Из СтруктураИзменяемыхРеквизитов Цикл
		Если Не ЭтотОбъект[КлючИЗначение.Ключ+"Флаг"] Тогда
			НепроверяемыеРеквизиты.Добавить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
	НачислятьАмортизацию = (ПорядокУчета=Перечисления.ПорядокУчетаСтоимостиВнеоборотныхАктивов.НачислятьАмортизацию);
	АмортизацияПоНаработке = (МетодНачисленияАмортизации=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
	
	Если НачислятьАмортизацию И Не АмортизацияПоНаработке Тогда
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Тогда
		НепроверяемыеРеквизиты.Добавить("МетодНачисленияАмортизации");
		НепроверяемыеРеквизиты.Добавить("СчетАмортизации");
		НепроверяемыеРеквизиты.Добавить("СтатьяРасходов");
		НепроверяемыеРеквизиты.Добавить("АналитикаРасходов");
		НепроверяемыеРеквизиты.Добавить("ПоказательНаработки");
		НепроверяемыеРеквизиты.Добавить("ОбъемНаработки");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Или АмортизацияПоНаработке Тогда
		НепроверяемыеРеквизиты.Добавить("СрокИспользования");
	КонецЕсли;
	
	Если Не НачислятьАмортизацию Или МетодНачисленияАмортизации<>Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
		НепроверяемыеРеквизиты.Добавить("КоэффициентУскорения");
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик(ЭтотОбъект);
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		ЗаполнитьПоНематериальномуАктиву(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ТекущиеЗначения.ПорядокУчета КАК ПорядокУчета,
		|	ТекущиеЗначения.ЛиквидационнаяСтоимость КАК ЛиквидационнаяСтоимость,
		|	ТекущиеЗначения.ЛиквидационнаяСтоимостьПредставления КАК ЛиквидационнаяСтоимостьПредставления,
		|	ТекущиеЗначения.СчетУчета КАК СчетУчета,
		|	ТекущиеЗначения.СчетАмортизации КАК СчетАмортизации,
		|	ТекущиеЗначения.МетодНачисленияАмортизации КАК МетодНачисленияАмортизации,
		|	ТекущиеЗначения.СрокИспользования КАК СрокИспользования,
		|	ТекущиеЗначения.ОбъемНаработки КАК ОбъемНаработки,
		|	ТекущиеЗначения.КоэффициентУскорения КАК КоэффициентУскорения,
		|	ТекущиеЗначения.СтатьяРасходов КАК СтатьяРасходов,
		|	ТекущиеЗначения.АналитикаРасходов КАК АналитикаРасходов
		|ИЗ
		|	РегистрСведений.НематериальныеАктивыМеждународныйУчет.СрезПоследних(
		|			&Дата,
		|			НематериальныйАктив = &НематериальныйАктив
		|				И Регистратор <> &ТекущийРегистратор) КАК ТекущиеЗначения"
	);
	Запрос.УстановитьПараметр("Дата", Новый Граница(?(ЗначениеЗаполнено(Дата), Дата, ТекущаяДатаСеанса()), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("НематериальныйАктив", НематериальныйАктив);
	Запрос.УстановитьПараметр("ТекущийРегистратор", Ссылка);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		СтруктураИзменяемыхРеквизитов = СтруктураИзменяемыхРеквизитов();
		Для Каждого КлючИЗначение Из СтруктураИзменяемыхРеквизитов Цикл
			Если Не ЭтотОбъект[КлючИЗначение.Ключ+"Флаг"] Тогда
				ЭтотОбъект[КлючИЗначение.Ключ] = Выборка[КлючИЗначение.Ключ];
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик(ЭтотОбъект);
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект, "Международный, НематериальныеАктивыМеждународныйУчет");
	
	Документы.ИзменениеПараметровНМАМеждународныйУчет.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Изменение параметров НМА (международный учет)';
			|en = 'Change of IA parameters (international accounting)'"));
	
	ПроверитьВозможностьИзмененияПараметров(Отказ);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтруктураИзменяемыхРеквизитов()
	
	Возврат Новый Структура(
		"ПорядокУчета, ЛиквидационнаяСтоимость, ЛиквидационнаяСтоимостьПредставления,
		|СчетУчета, СчетАмортизации,
		|МетодНачисленияАмортизации, СрокИспользования, ОбъемНаработки, КоэффициентУскорения,
		|СтатьяРасходов, АналитикаРасходов"
	);
	
КонецФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ИзменениеПараметровНМАМеждународныйУчет.ПараметрыВыбораСтатейИАналитик(ЭтотОбъект);
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПроверитьВозможностьИзмененияПараметров(Отказ=Ложь)
	
	ТребуемоеСостояние = Новый Структура("Организация, Состояние", Организация, Перечисления.СостоянияНМА.ПринятКУчету);
	ПараметрыПроверки = Новый Структура("ДатаСведений, ИсключаемыйРегистратор", Дата, Ссылка);
	Ошибки = МеждународныйУчетВнеоборотныеАктивы.ПроверитьСостояниеВнеоборотныхАктивов(
		НематериальныйАктив, ТребуемоеСостояние, ПараметрыПроверки);
	Если Ошибки=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого КлючИЗначение Из Ошибки Цикл
		Объект = КлючИЗначение.Ключ;
		Данные = КлючИЗначение.Значение;
		
		ТекстОшибки = НСтр("ru = 'Учетные данные нематериального актива ""%1"" не могут быть изменены.';
							|en = 'Accounting data of the ""%1"" intangible asset cannot be changed.'") + Символы.ПС;
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%1", Объект);
		Если Данные.Состояние <> Перечисления.СостоянияНМА.ПринятКУчету Тогда
			ТекстОшибки = ТекстОшибки
				+ НСтр("ru = 'Объект не принят к учету';
						|en = 'The object is not recognized'");
		Иначе
			ТекстОшибки = ТекстОшибки
				+ СтрЗаменить(НСтр("ru = 'Объект принят к учету в организации ""%1""';
									|en = 'The object is recognized in company ""%1""'"), "%1", Данные.Организация);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НематериальныйАктив",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПоНематериальномуАктиву(Основание)
	
	Организация = МеждународныйУчетВнеоборотныеАктивы.ОрганизацияВКоторойНМАПринятКУчету(Основание);
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Нематериальный актив ""%1"" не принят к учету.';
										|en = 'The ""%1"" intangible asset is not recognized.'"), Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	НематериальныйАктив = Основание;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли