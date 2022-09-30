
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УточнитьСписокХозяйственныхОпераций();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Используется для автоматического обновления формы платежного календаря
	Оповестить("Запись_РаспоряжениеНаПеремещениеДенежныхСредств", ПараметрыЗаписи, Объект.Ссылка);
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	#Область УХ_Встраивание
	Оповестить("ИзмененДокументТранзакции", ПараметрыЗаписи.ПараметрыОповещения);
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ХозяйственнаяОперацияПриИзменении(Элемент)
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ХозяйственнаяОперацияПриИзмененииСервер()
	
	ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыКассы(Объект.Касса);
	
	Если НЕ ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		КассаПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пересчитать суммы в документе в валюту %1?';
				|en = 'Convert amounts in the document into currency %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Пересчитать';
																|en = 'Recalculate'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отменить';
																	|en = 'Cancel'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуКасса", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуКасса(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		КассаПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.Касса = ТекущаяКасса;
		#Область УХ_Встраивание
		Позиция1 = ЭтаФорма.ПлатежнаяПозиция[0];
		Позиция1.БанковскийСчетКасса = Объект.Касса;
		#КонецОбласти 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура КассаПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущаяКасса = Объект.Касса;
	
	Если ЗначениеЗаполнено(Объект.Касса) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	
	#Область УХ_Встраивание
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ПлатежнаяПозицияОчиститьПолучателя(ЭтаФорма.ПлатежнаяПозиция);
	#КонецОбласти
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	
	СтруктураРеквизитов = ПолучитьРеквизитыБанковскогоСчета(Объект.БанковскийСчет);
	
	Если Не ФинансыКлиент.НеобходимПересчетВВалюту(Объект, Объект.Валюта, СтруктураРеквизитов.Валюта) Тогда
		
		БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, Ложь);
	Иначе
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пересчитать суммы в документе в валюту %1?';
				|en = 'Convert amounts in the document into currency %1?'"),
			СтруктураРеквизитов.Валюта);
		
		КнопкиДиалогаВопрос = Новый СписокЗначений;
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Пересчитать';
																|en = 'Recalculate'"));
		КнопкиДиалогаВопрос.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отменить';
																	|en = 'Cancel'"));
		
		ОписаниеОповещения = Новый ОписаниеОповещения("РазрешенПересчетВВалютуСчет", ЭтотОбъект, Новый Структура("СтруктураРеквизитов", СтруктураРеквизитов));
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, КнопкиДиалогаВопрос);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенПересчетВВалютуСчет(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ТекущаяВалюта = Объект.Валюта;
		БанковскийСчетПриИзмененииСервер(ДополнительныеПараметры.СтруктураРеквизитов, Истина);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ТекущаяВалюта, Объект.Валюта);
	Иначе
		
		Объект.БанковскийСчет = ТекущийБанковскийСчет;
		#Область УХ_Встраивание
		Позиция1 = ЭтаФорма.ПлатежнаяПозиция[0];
		Позиция1.БанковскийСчетКасса = Объект.БанковскийСчет;
		#КонецОбласти 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура БанковскийСчетПриИзмененииСервер(СтруктураРеквизитов, ПересчитыватьСуммы)
	
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	
	//++ Локализация
	//++ НЕ УТ
	ЗаполнитьРеквизитыГОЗ();
	//-- НЕ УТ
	//-- Локализация
	
	Если ЗначениеЗаполнено(Объект.БанковскийСчет) Тогда
		Объект.Организация = СтруктураРеквизитов.Организация;
	КонецЕсли;
	
	ТекущаяВалюта = Объект.Валюта;
	Объект.Валюта = СтруктураРеквизитов.Валюта;
	
	Если ПересчитыватьСуммы Тогда
		ПересчетСуммДокументаВВалюту(ТекущаяВалюта);
	КонецЕсли;
	
	#Область УХ_Встраивание
	//Объект.БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПустаяСсылка();
	//Объект.КассаПолучатель          = Справочники.Кассы.ПустаяСсылка();
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ПлатежнаяПозицияОчиститьПолучателя(ЭтаФорма.ПлатежнаяПозиция);
	#КонецОбласти
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы("Статус");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
	//++ Локализация
	//++ НЕ УТ
	Если Элементы.СтраницаПодтверждающиеДокументы.Видимость Тогда
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	Иначе
		Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	//-- НЕ УТ
	//-- Локализация
	
	#Область УХ_Встраивание
	// Группа страницы отображается всегда
	Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
	#КонецОбласти 
	
КонецПроцедуры

&НаСервере
Процедура УточнитьСписокХозяйственныхОпераций()
	
	ИспользоватьНесколькоРасчетныхСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьНесколькоКасс            = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	
	Если Не ИспользоватьНесколькоРасчетныхСчетов Тогда
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(
			Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ИспользоватьНесколькоКасс Тогда
		СписокВыбораХозяйственныхОпераций = Элементы.ХозяйственнаяОперация.СписокВыбора;
		НайденныйЭлемент = СписокВыбораХозяйственныхОпераций.НайтиПоЗначению(
			Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу);
		Если НайденныйЭлемент <> Неопределено Тогда
			СписокВыбораХозяйственныхОпераций.Удалить(НайденныйЭлемент);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	#Область УХ_Встраивание
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ПриЧтенииСозданииНаСервере(ЭтаФорма);
	#КонецОбласти
	
	ДенежныеСредстваСервер.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	ТекущаяКасса = Объект.Касса;
	ТекущийБанковскийСчет = Объект.БанковскийСчет;
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыДокументаПоХозяйственнойОперации()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияКассыОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация  = Объект.Организация;
		СтруктураПараметров.Касса        = Объект.Касса;
		
		Объект.Касса = ЗначениеНастроекПовтИсп.ПолучитьКассуОрганизацииПоУмолчанию(СтруктураПараметров);
		Объект.Валюта = Справочники.Кассы.ПолучитьРеквизитыКассы(Объект.Касса).Валюта;
		#Область УХ_Встраивание
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКОтправитель(ЭтаФорма.ПлатежнаяПозиция, Объект.Касса, Объект.Валюта);
		#КонецОбласти 
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		СтруктураПараметров = ДенежныеСредстваСервер.ПараметрыЗаполненияБанковскогоСчетаОрганизацииПоУмолчанию();
		СтруктураПараметров.Организация      = Объект.Организация;
		СтруктураПараметров.БанковскийСчет   = Объект.БанковскийСчет;
		
		Объект.БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(СтруктураПараметров);
		Объект.Валюта = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(Объект.БанковскийСчет).Валюта;
		#Область УХ_Встраивание
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКОтправитель(ЭтаФорма.ПлатежнаяПозиция, Объект.БанковскийСчет, Объект.Валюта);
		#КонецОбласти 
	КонецЕсли;
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств Тогда
		
		ОрганизацияПолучатель = Объект.Организация;
		
		КассаПолучатель = Справочники.Кассы.ПолучитьКассуПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(КассаПолучатель) Тогда
			Объект.КассаПолучатель = КассаПолучатель;
		КонецЕсли;
		#Область УХ_Встраивание
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКПолучатель(ЭтаФорма.ПлатежнаяПозиция, Объект.КассаПолучатель);
		#КонецОбласти 
		
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		Или Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк Тогда
		
		ОрганизацияПолучатель = Объект.Организация;
		
		БанковскийСчетПолучатель = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(
			ОрганизацияПолучатель,
			Объект.Валюта);
		Если ЗначениеЗаполнено(БанковскийСчетПолучатель) Тогда
			Объект.БанковскийСчетПолучатель = БанковскийСчетПолучатель;
		КонецЕсли;
		
		#Область УХ_Встраивание
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКПолучатель(ЭтаФорма.ПлатежнаяПозиция, Объект.БанковскийСчетПолучатель);
		#КонецОбласти 
		
	КонецЕсли;
	
	#Область УХ_Встраивание
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКОтправитель(ЭтаФорма.ПлатежнаяПозиция, Объект.БанковскийСчет, Объект.Валюта);
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКПолучатель(ЭтаФорма.ПлатежнаяПозиция, Объект.БанковскийСчетПолучатель);
	ИначеЕсли Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу Тогда
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКОтправитель(ЭтаФорма.ПлатежнаяПозиция, Объект.Касса, Объект.Валюта);
		ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.УстановитьБКПолучатель(ЭтаФорма.ПлатежнаяПозиция, Объект.КассаПолучатель);
	КонецЕсли;
	#КонецОбласти 
	
	//++ НЕ УТ
	ЗаполнитьРеквизитыГОЗ();
	Если Объект.ПлатежиПо275ФЗ И Объект.ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
		Объект.ПлатежиПо275ФЗ = Ложь;
		Объект.БанковскийСчет = Неопределено;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыКассы(Касса)
	
	Возврат Справочники.Кассы.ПолучитьРеквизитыКассы(Касса);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыБанковскогоСчета(БанковскийСчет)
	
	Возврат Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет);
	
КонецФункции

&НаСервере
Процедура ПересчетСуммДокументаВВалюту(ТекущаяВалюта)
	
	ДенежныеСредстваСервер.ПересчетСуммДокументаВВалюту(
		Объект,
		ТекущаяВалюта,
		Объект.Валюта);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныйРеквизит = "")
	
	ДенежныеСредстваКлиентСервер.НастроитьЭлементыФормы(ЭтаФорма, ИзмененныйРеквизит, РеквизитыФормы(ЭтаФорма));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РеквизитыФормы(Форма)
	
	РеквизитыФормы = Новый Структура;
	РеквизитыФормы.Вставить("Модифицированность");
	
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	#Область УХ_Встраивание
	РеквизитыФормы.Вставить("Истина", Истина);
	#КонецОбласти
	Возврат РеквизитыФормы;
	
КонецФункции

#КонецОбласти

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//++ Локализация
	//++ НЕ УТ
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтверждающиеДокументыФайлНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПунктыМеню = Новый СписокЗначений;
	ПунктыМеню.Добавить("ВыборИзПрисоединенныхФайлов", НСтр("ru = 'Выбрать из присоединенных файлов ...';
															|en = 'Select from attached files ...'"),, БиблиотекаКартинок.ВыбратьЗначение);
	ПунктыМеню.Добавить("ДобавлениеФайлаСДиска", НСтр("ru = 'Добавить файл с диска ...';
														|en = 'Add file from disk ...'"),, БиблиотекаКартинок.ОткрытьФайл);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, ПунктыМеню, Элементы.ПодтверждающиеДокументыФайл);
	//-- НЕ УТ
	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти

//++ Локализация
#Область Локализация

#Область Локализация_ПодключаемыеОбработчикиСобытийФормы

&НаСервере
Процедура Подключаемый_ПриСозданииНаСервереЛокализация(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервереЛокализация();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ПриЧтенииНаСервереЛокализация(ТекущийОбъект)
	
	ПриЧтенииНаСервере(ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервереЛокализация();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработкаОповещенияЛокализация(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
			И Параметр.Свойство("ВладелецФайла")
			И Параметр.ВладелецФайла = ВыбранныйВладелецФайла
			И Параметр.ЭтоНовый
			И ДобавляетсяФайлПодтверждающегоДокумента Тогда
			
		Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл = Источник[0];
		ДобавляетсяФайлПодтверждающегоДокумента = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждающиеДокументы

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметрыВыбораВладельца = Новый Структура("Действие", Результат.Значение);
		Если ЗначениеЗаполнено(Объект.ДоговорСЗаказчиком) Тогда
			ВыборВладельцаФайлаЗавершение(Новый Структура("Значение", Объект.ДоговорСЗаказчиком), ДополнительныеПараметрыВыбораВладельца);
		Иначе
			Если Результат.Значение = "ДобавлениеФайлаСДиска" Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'В документе не указан договор с заказчиком. Добавление файла невозможно.';
												|en = 'Contract with the customer is not specified in the document. Cannot add the file.'"));
			ИначеЕсли Результат.Значение = "ВыборИзПрисоединенныхФайлов" Тогда
				ПоказатьПредупреждение(, НСтр("ru = 'В документе не указан договор с заказчиком. Выбор файла невозможен.';
												|en = 'Contract with the customer is not specified in the document. Cannot select the file.'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВладельцаФайлаЗавершение(Результат, ДополнительныеПараметры)
	
	Если Результат <> Неопределено Тогда
		ВыбранныйВладелецФайла = Результат.Значение;
		Если ДополнительныеПараметры.Действие = "ДобавлениеФайлаСДиска" Тогда
			ИдентификаторФайла = Новый УникальныйИдентификатор;
			ДобавляетсяФайлПодтверждающегоДокумента = Истина;
			РаботаСФайламиКлиент.ДобавитьФайлы(ВыбранныйВладелецФайла, ИдентификаторФайла);
		ИначеЕсли ДополнительныеПараметры.Действие = "ВыборИзПрисоединенныхФайлов" Тогда
			РаботаСФайламиКлиент.ОткрытьФормуВыбораФайлов(ВыбранныйВладелецФайла, Элементы.ПодтверждающиеДокументыФайл);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЛокализацияСлужебные

&НаСервере
Процедура ПриЧтенииСозданииНаСервереЛокализация()
	
	ДенежныеСредстваСерверЛокализация.УправлениеЭлементамиФормыПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

//++ НЕ УТ

&НаСервере
Процедура ЗаполнитьРеквизитыГОЗ()
	
	Если Объект.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет Тогда
		
		РеквизитыСчета = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ТекущийБанковскийСчет, "ОтдельныйСчетГОЗ, ГосударственныйКонтракт");
		Объект.ПлатежиПо275ФЗ = РеквизитыСчета.ОтдельныйСчетГОЗ;
		
		Если Объект.ПлатежиПо275ФЗ Тогда
			
			ДоговорыСЗаказчиком = Справочники.ГосударственныеКонтракты.ДоговорыПоГосударственномуКонтракту(
				РеквизитыСчета.ГосударственныйКонтракт);
			Если ДоговорыСЗаказчиком.Количество() Тогда
				Объект.ДоговорСЗаказчиком = ДоговорыСЗаказчиком[0];
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Объект.ТипПлатежаФЗ275) Тогда
				
				ПараметрыПлатежа = Новый Структура;
				ПараметрыПлатежа.Вставить("ПлатежиПо275ФЗ", Истина);
				ПараметрыПлатежа.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
				ПараметрыПлатежа.Вставить("БанковскийСчет", Объект.БанковскийСчет);
			
				ДоступныеТипыПлатежа275ФЗ = Справочники.ТипыПлатежейФЗ275.ДоступныеТипыПлатежа275ФЗ(ПараметрыПлатежа);
				Если ДоступныеТипыПлатежа275ФЗ.Количество() Тогда
					Объект.ТипПлатежаФЗ275 = ДоступныеТипыПлатежа275ФЗ[0];
				Иначе
					Объект.ТипПлатежаФЗ275 = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#Область УХ_Встраивание

#Область УХ_ВызовыОбщихПроцедурИФункцийСогласованияОбъектов

&НаСервере
Процедура ОпределитьСостояниеОбъектаНаСервере()
	
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ОпределитьСостояниеОбъекта(ЭтаФорма);

	#Область УХ_Встраивание
	УправлениеЭлементамиФормы();
	НастроитьЗависимыеЭлементыФормыНаСервере();
	#КонецОбласти 
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСостояниеЗаявки(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;

	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
КонецПроцедуры

// Проверяет сохранение текущего объекта и изменяет его статус
// НовоеЗначениеСтатусаВход.
&НаКлиенте
Процедура ПроверитьСохранениеИзменитьСтатус(НовоеЗначениеСтатусаВход)
	Если (Объект.Ссылка.Пустая()) ИЛИ (Модифицированность) Тогда
		СтруктураПараметров = Новый Структура("ВыбранноеЗначение", НовоеЗначениеСтатусаВход);
		ОписаниеОповещения = Новый ОписаниеОповещения("СостояниеЗаявкиОбработкаВыбораПродолжение", ЭтотОбъект, СтруктураПараметров);
		ТекстВопроса = НСтр("ru = 'Данные еще не записаны.
		|Изменение состояния возможно только после записи данных.
		|Данные будут записаны.'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
		Возврат;
	КонецЕсли;
	ИзменитьСостояниеЗаявкиКлиент(НовоеЗначениеСтатусаВход);	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение)
	ДействияСогласованиеУХКлиент.ИзменитьСостояниеЗаявкиКлиент(ВыбранноеЗначение, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаявкиОбработкаВыбораПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		Записать();
		ИзменитьСостояниеЗаявкиКлиент(Параметры.ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИзменитьСостояниеЗаявки(Ссылка, Состояние)
	
	Возврат УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, Состояние, , , ЭтотОбъект);
	
КонецФункции

&НаКлиенте
Процедура ПринятьКСогласованию_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ПринятьКСогласованию(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ИсторияСогласования(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура СогласоватьДокумент_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.СогласоватьДокумент(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьСогласование_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.ОтменитьСогласование(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура МаршрутСогласования_Подключаемый() Экспорт
	ДействияСогласованиеУХКлиент.МаршрутСогласования(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры

// Возвращает значение реквизита СостояниеЗаявки на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСостояниеЗаявки(ФормаВход) экспорт
	Возврат ФормаВход["СостояниеЗаявки"];
КонецФункции

// Возвращает значение реквизита СтатусОбъекта на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСтатусОбъекта(ФормаВход)
	Возврат ФормаВход["СтатусОбъекта"];
КонецФункции

// Возвращает значение реквизита Согласующий на форме ФормаВход.
// Т.к. данный реквизит генерируется кодом, обращение к нему напрямую из
// кода недоступно.
&НаКлиентеНаСервереБезКонтекста
Функция РеквизитСогласующий(ФормаВход) экспорт
	Возврат ФормаВход["Согласующий"];
КонецФункции

&НаКлиенте
Процедура СтатусОбъектаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ВыбранноеЗначение = РеквизитСтатусОбъекта(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьСохранениеИзменитьСтатус(ВыбранноеЗначение);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_ПриИзмененииВидаОперацииБюджетирования(Элемент)
	
	ПриИзмененииВидаОперацииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтатьяБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АналитикаСтатьиБюджета_ПриИзменении(Элемент)
	АналитикиСтатейБюджетовУХКлиент.ПриИзмененииАналитикиСтатьиБюджета(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаПлатежнойПозиции(Элемент)
	
	ПП = ЭтаФорма.ПлатежнаяПозиция;
	
	Если Элемент.Имя = "ППОтправитель" Тогда
		Отправитель = ПП[0].БанковскийСчетКасса;
		Если ТипЗнч(Отправитель) = Тип("СправочникСсылка.Кассы") Тогда
			Объект.Касса = Отправитель;
			КассаПриИзменении(Элементы.Касса);
		Иначе
			Объект.БанковскийСчет = Отправитель;
			БанковскийСчетПриИзменении(Элементы.БанковскийСчет);
		КонецЕсли;
		ПП[0].Организация = Объект.Организация;
		ПП[1].Организация = Объект.Организация;
		ПП[0].ВалютаОплаты = Объект.Валюта;
		ПП[1].ВалютаОплаты = Объект.Валюта;
		ПП[0].ВалютаВзаиморасчетов = Объект.Валюта;
		ПП[1].ВалютаВзаиморасчетов = Объект.Валюта;
	ИначеЕсли Элемент.Имя = "ПППолучатель" Тогда
		Получатель = ПП[1].БанковскийСчетКасса;
		Если ТипЗнч(Получатель) = Тип("СправочникСсылка.Кассы") Тогда
			Объект.КассаПолучатель = Получатель;
		Иначе
			Объект.БанковскийСчетПолучатель = Получатель;
		КонецЕсли;
	ИначеЕсли Элемент.Имя = "ППДатаИсполнения1" Тогда
		ДатаИсполнения1 = ПП[0].ДатаИсполнения;
		Объект.ДатаПлатежа = ДатаИсполнения1;
		ПП[1].ДатаИсполнения = ДатаИсполнения1;
	ИначеЕсли Элемент.Имя = "ППДатаИсполнения2" Тогда
		ДатаИсполнения2 = ПП[1].ДатаИсполнения;
	ИначеЕсли Элемент.Имя = "СуммаДокумента" Тогда
		ПП[0].Сумма = Объект.СуммаДокумента;
		ПП[0].СуммаВзаиморасчетов = Объект.СуммаДокумента;
		ПП[1].Сумма = Объект.СуммаДокумента;
		ПП[1].СуммаВзаиморасчетов = Объект.СуммаДокумента;
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВидаОперацииНаСервере()
	
	Данные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ВидОперацииУХ, "ВидОперацииДДСБезналичныйРасчет, ВидОперацииДДСНаличныйРасчет");
	
	Если ЗначениеЗаполнено(Данные.ВидОперацииДДСБезналичныйРасчет) Тогда
		Объект.ХозяйственнаяОперация = Данные.ВидОперацииДДСБезналичныйРасчет;
	Иначе
		Объект.ХозяйственнаяОперация = Данные.ВидОперацииДДСНаличныйРасчет;
	КонецЕсли;
	
	//
	ЭтаФорма.ПлатежнаяПозиция.Загрузить(ПлатежныеПозиции.НоваяПлатежнаяПозицияПоДаннымДокумента(Объект));
	
	ХозяйственнаяОперацияПриИзмененииСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтаФорма, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти
//-- Локализация

#Область Инициализация

#Если НаСервере Тогда

Если Не ПодключеныОбработчикиЛокализация И ПолучитьФункциональнуюОпцию("ПоддержкаПлатежейРФ") Тогда
	
	ПодключеныОбработчикиЛокализация = Истина;
	
	ПодключаемыеОбработчикиСобытийФормы = Новый Массив;
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ПриСозданииНаСервере");
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ПриЧтенииНаСервере");
	ПодключаемыеОбработчикиСобытийФормы.Добавить("ОбработкаОповещения");
	
	Для каждого Обработчик Из ПодключаемыеОбработчикиСобытийФормы Цикл
		УстановитьДействие(Обработчик, "Подключаемый_" + Обработчик + "Локализация");
	КонецЦикла;
	
КонецЕсли;

#КонецЕсли

#КонецОбласти
