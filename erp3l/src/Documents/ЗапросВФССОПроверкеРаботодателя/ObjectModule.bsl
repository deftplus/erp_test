#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция возвращает признак завершенности работы с объектом.
Функция ОбъектЗафиксирован() Экспорт
	Возврат Проведен;
КонецФункции

// Процедура обновляет вторичные данные в документе с учетом фиксации.
Функция ОбновитьВторичныеДанныеДокумента(ДанныеОрганизации = Истина, ДанныеСотрудника = Истина, ДанныеОЗаработке = Истина, ОбновлятьБезусловно = Истина) Экспорт
	Модифицирован = Ложь;
	
	Если ОбъектЗафиксирован() И Не ОбновлятьБезусловно Тогда
		Возврат Модифицирован;
	КонецЕсли;
	
	ПараметрыФиксации = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(Метаданные().ПолноеИмя()).ПараметрыФиксацииВторичныхДанных();
	
	Если ДанныеОрганизации И ОбновитьДанныеСтрахователя(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Если ДанныеСотрудника И ОбновитьДанныеСотрудника(ПараметрыФиксации) Тогда
		Модифицирован = Истина;
	КонецЕсли;
	
	Возврат Модифицирован;
КонецФункции

Функция ОбновитьДанныеСтрахователя(ПараметрыФиксации)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РеквизитыДокумента = Новый Структура("РегистрационныйНомерФСС,ДополнительныйКодФСС,КодПодчиненностиФСС,НаименованиеТерриториальногоОрганаФСС,Руководитель,ДолжностьРуководителя,ОснованиеПодписиРуководителя,АдресОрганизации");
	
	ИменаРеквизитовОрганизации = "РегистрационныйНомерФСС, КодПодчиненностиФСС, ДополнительныйКодФСС, НаименованиеТерриториальногоОрганаФСС";
	ЗначенияРеквизитовОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, ИменаРеквизитовОрганизации);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ЗначенияРеквизитовОрганизации, ИменаРеквизитовОрганизации);
	
	СведенияОПодписях = ПодписиДокументов.СведенияОПодписяхПоУмолчаниюДляОбъектаМетаданных(Метаданные(), Организация);
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, СведенияОПодписях);
	
	АдресаОрганизации = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
		Организация,
		Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации,
		Дата,
		Ложь);
	Если АдресаОрганизации.Количество() > 0 Тогда
		РеквизитыДокумента.АдресОрганизации = АдресаОрганизации[0].Значение;
	Иначе
		РеквизитыДокумента.АдресОрганизации = "";
	КонецЕсли;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

Функция ОбновитьДанныеСотрудника(ПараметрыФиксации)
	КадровыеДанные = Новый Массив;
	КадровыеДанные.Добавить("ФизическоеЛицо");
	КадровыеДанные.Добавить("Фамилия");
	КадровыеДанные.Добавить("Имя");
	КадровыеДанные.Добавить("Отчество");
	КадровыеДанные.Добавить("СтраховойНомерПФР");
	КадровыеДанные.Добавить("АдресПоПрописке");
	КадровыеДанные.Добавить("АдресПоПропискеПредставление");
	
	КадровыеДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник), КадровыеДанные, Дата);
	Если КадровыеДанныеСотрудников.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	КадровыеДанныеСотрудника = КадровыеДанныеСотрудников[0];
	
	ФизическоеЛицо = КадровыеДанныеСотрудника["ФизическоеЛицо"];
	
	РеквизитыДокумента = Новый Структура("ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР,Адрес");
	ЗаполнитьЗначенияСвойств(РеквизитыДокумента, КадровыеДанныеСотрудника, "ФизическоеЛицо,Фамилия,Имя,Отчество,СтраховойНомерПФР");
	РеквизитыДокумента.Адрес = КадровыеДанныеСотрудника.АдресПоПрописке;
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьДанныеШапки(РеквизитыДокумента, ЭтотОбъект, ПараметрыФиксации);
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли