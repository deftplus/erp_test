#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ТипОснования = ТипЗнч(ДанныеЗаполнения);
	Если ТипОснования = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		НематериальныйАктив = ДанныеЗаполнения;
	КонецЕсли;
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Ложь, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОчиститьДвиженияДокумента(ЭтотОбъект, "Международный, НематериальныеАктивыМеждународныйУчет");
	
	Документы.ПеремещениеНМАМеждународныйУчет.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Перемещение НМА (международный учет)';
			|en = 'IA transfer (international accounting)'"));
	
	ПроверитьВозможностьПроведения(Отказ);
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

Процедура ПроверитьВозможностьПроведения(Отказ=Ложь)
	
	ТребуемоеСостояние = Новый Структура(
		"Организация, Состояние, Подразделение",
		Организация, Перечисления.СостоянияНМА.ПринятКУчету, Подразделение);
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
			Шаблон = НСтр("ru = 'Объект принят к учету в организации ""%1"" в подразделение ""%2""';
							|en = 'The object is recognized in business unit ""%2"" of company ""%1""'");
			ТекстОшибки = ТекстОшибки
				+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Данные.Организация, Данные.Подразделение);
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"НематериальныйАктив",
			,
			Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли