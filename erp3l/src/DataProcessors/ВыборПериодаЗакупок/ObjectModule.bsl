#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

Процедура Инициализировать() Экспорт
	Периодичность = ПолучитьПериодичностьПоТипуЗакупок(Инновационный);
КонецПроцедуры
	
Процедура УстановитьИнновационный(ЗначениеИнновационный) Экспорт
	Инновационный = ЗначениеИнновационный;
	ИнновационныйПриИзменении();
КонецПроцедуры

Процедура УстановитьПериодНачала(ЗначениеПериодНачала) Экспорт
	ПериодНачала = ЗначениеПериодНачала;
	ПериодНачалаПриИзменении();
КонецПроцедуры

Процедура УстановитьПериодОкончания(ЗначениеПериодОкончания) Экспорт
	ПериодОкончания = ЗначениеПериодОкончания;
	ПериодОкончанияПриИзменении();
КонецПроцедуры

Процедура УстановитьПериодЗакупок(ЗначениеПериодЗакупок) Экспорт
	ПериодЗакупок = ЗначениеПериодЗакупок;
	ПериодЗакупокПриИзменении();
КонецПроцедуры

// При изменении периодичности начало периода является базой.
// Окончание периода и охватывающий период пересчитываются
// относительно нее.
//
Процедура ИнновационныйПриИзменении() Экспорт
	НоваяПериодичность = 
		ПолучитьПериодичностьПоТипуЗакупок(
			Инновационный);
	Если Периодичность <> НоваяПериодичность Тогда
		СтарыйПериодНачала = ПериодНачала;
		// Здесь за счет связи параметров выбора
		// периоды начала и окончания сбросятся.
		Периодичность = НоваяПериодичность;
		ВосстановитьПериодНачалаСДругойПериодичностью(СтарыйПериодНачала);
		ПериодНачалаПриИзменении();
	КонецЕсли;
КонецПроцедуры

Процедура ПериодНачалаПриИзменении() Экспорт
	ОбновитьПериодЗакупокПоПериодуНачала();
	ОбновитьПериодОкончанияПоТипуПлана();
КонецПроцедуры

// Период окончания "плавает", поэтому пересчет начала
// и охватывающего периода закупок не делаем.
Процедура ПериодОкончанияПриИзменении() Экспорт
	
КонецПроцедуры

Процедура ПериодЗакупокПриИзменении() Экспорт
	ОбновитьПериодНачалаПоПериодуЗакупок();
	ОбновитьПериодОкончанияПоТипуПлана();
КонецПроцедуры

Процедура ОбновитьПериодНачалаПоПериодуЗакупок()
	ПериодНачала = 
		ОбновитьЗначениеПериодаСУчетомПериодичности(
			ПериодЗакупок,
			Периодичность);
КонецПроцедуры

Процедура ОбновитьПериодЗакупокПоПериодуНачала()
	ПериодЗакупок = 
		ОбновитьЗначениеПериодаСУчетомПериодичности(
			ПериодНачала,
			Перечисления.Периодичность.Год);
КонецПроцедуры

Процедура ОбновитьПериодОкончанияПоТипуПлана()
	Если Инновационный Тогда
		Если ЗначениеЗаполнено(ПериодНачала) Тогда
			ПериодОкончания =
				ПолучитьЗначениеПериодаСУчетомПериодичности(
					ПериодНачала.ДатаНачала,
					Периодичность,
					6);
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(ПериодЗакупок) Тогда
			ПериодОкончания =
				ПолучитьЗначениеПериодаСУчетомПериодичности(
					ПериодЗакупок.ДатаОкончания,
					Периодичность);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ВосстановитьПериодНачалаСДругойПериодичностью(СтароеЗначениеПериода)
	ПериодНачала = 
		ОбновитьЗначениеПериодаСУчетомПериодичности(
			СтароеЗначениеПериода,
			Периодичность);
КонецПроцедуры

// Если Инновационный, то год. Иначе из константы.
//
Функция ПолучитьПериодичностьПоТипуЗакупок(Инновационный)
	Перем Периодичность;
	Если Инновационный Тогда
		Периодичность = Перечисления.Периодичность.Год;
	Иначе
		Периодичность = ЦентрализованныеЗакупкиУХ.ПолучитьПериодичностьЗакупок();
	КонецЕсли;
	Возврат Периодичность;
КонецФункции

// Получить период по началу указанного с учетом периодичности.
//
// Параметры:
//  ЗначениеПериода	 - СправочникСсылка.Периоды - период для поиска
//		по его началу нового.
//  Периодичность	 - ПеречислениеСсылка.Периодичность - 
//	Смещение - Число - По умолчанию ноль. Кол-во периодов
//		указанной периодичности, для смещения результирующего периода.
// 
// Возвращаемое значение:
//  для даты начала указанного периода ищет подходящий
//	период с указанной периодичностью.
//
Функция ОбновитьЗначениеПериодаСУчетомПериодичности(ЗначениеПериода, 
													Периодичность)
	Перем ТихийРежим;
	Если НЕ ЗначениеЗаполнено(ЗначениеПериода)
			ИЛИ ЗначениеПериода.Периодичность = Периодичность Тогда
		Возврат ЗначениеПериода;
	КонецЕсли;
	Возврат ПолучитьЗначениеПериодаСУчетомПериодичности(
				ЗначениеПериода.ДатаНачала, 
				Периодичность);
КонецФункции

// Получить период по началу указанного с учетом периодичности.
//
// Параметры:
//  ДатаВПериоде	 - Дата - дата в периоде, на которую ориентируемся
//		для поиска периода.
//  Периодичность	 - ПеречислениеСсылка.Периодичность - 
//	Смещение - Число - По умолчанию ноль. Кол-во периодов
//		указанной периодичности, для смещения результирующего периода.
// 
// Возвращаемое значение:
//  для даты начала указанного периода ищет подходящий
//	период с указанной периодичностью.
//
Функция ПолучитьЗначениеПериодаСУчетомПериодичности(ДатаВПериоде, 
													Периодичность,
													Смещение=0)
	Перем ТихийРежим;
	ТихийРежим = Ложь;
	Возврат ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(
		ДатаВПериоде,
		Периодичность,
		Смещение,
		ТихийРежим);
КонецФункции
	

#КонецЕсли