#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Для Каждого СтрокаПоСотруднику Из Сотрудники Цикл
			// Номер лицевого счета
			Если ПроверяемыеРеквизиты.Найти("Сотрудники.ЛицевойСчет") <> Неопределено
				И НЕ ПустаяСтрока(СтрокаПоСотруднику.ЛицевойСчет)
				И СтрДлина(СтрокаПоСотруднику.ЛицевойСчет) <> 20 Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'У сотрудника %1 длина номера лицевого счета менее 20 цифр.';
							|en = 'Personal account number of employee %1 contains less than 20 digits.'"),
						СтрокаПоСотруднику.Сотрудник),, 
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Объект.Сотрудники", 
						СтрокаПоСотруднику.НомерСтроки, 
						"ЛицевойСчет"),,
					Отказ);
				
			КонецЕсли;
		КонецЦикла;
		
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудники.ФизическоеЛицо");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		МетаданныеОбъекта = Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Если ДанныеЗаполнения.Свойство("Сотрудники") Тогда
			Для Каждого СтрокаЗначенийЗаполнения Из ДанныеЗаполнения.Сотрудники Цикл
				ЗаполнитьЗначенияСвойств(Сотрудники.Добавить(), СтрокаЗначенийЗаполнения);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(НомерРеестра) Тогда
		Если ПустаяСтрока(Номер) Тогда
			УстановитьНовыйНомер();
		КонецЕсли;
		НомерРеестра = ОбменСБанкамиПоЗарплатнымПроектам.СтрокаВЧисло(Номер);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И ОбъектЗафиксирован() Тогда
		ФиксацияВторичныхДанныхВДокументах.ЗафиксироватьВторичныеДанныеДокумента(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	НомерРеестра = 0;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак изменения данных, влияющих на формирование электронного документа.
// 
Функция ИзменилисьКлючевыеРеквизитыЭлектронногоДокумента() Экспорт
	
	ИзменилисьКлючевыеРеквизиты = 
		ЭлектронноеВзаимодействиеБЗК.ИзменилисьРеквизитыОбъекта(ЭтотОбъект, "Дата, Номер, Организация, ЗарплатныйПроект, НомерРеестра, ПометкаУдаления")	
		Или ЭлектронноеВзаимодействиеБЗК.ИзмениласьТабличнаяЧастьОбъекта(ЭтотОбъект, "Сотрудники", "Сотрудник, ДатаЗакрытия, ЛицевойСчет");
		
	Возврат ИзменилисьКлючевыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСотрудников(ДатаПолученияДанных) Экспорт
	
	Сотрудники.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТЗакрытиеЛицевыхСчетов(Запрос.МенеджерВременныхТаблиц, Ссылка, Организация, ЗарплатныйПроект, Подразделение, ДатаПолученияДанных);
	Выборка = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляЗакрытияЛицевыхСчетов(Запрос.МенеджерВременныхТаблиц).Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТабличнойЧастиСотрудники = Сотрудники.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиСотрудники, Выборка);
	КонецЦикла;
	
КонецПроцедуры

Функция ОбновитьТабличнуюЧастьФизическиеЛица(МассивСотрудников = Неопределено) Экспорт
	
	МассивСотрудников = ОбщегоНазначения.ВыгрузитьКолонку(Сотрудники, "Сотрудник", Истина);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТЗакрытиеЛицевыхСчетов(Запрос.МенеджерВременныхТаблиц, Ссылка, Организация, ЗарплатныйПроект, Подразделение, Дата, МассивСотрудников);
	
	ОписаниеФиксацииРеквизитов = Документы.ЗаявкаНаЗакрытиеЛицевыхСчетовСотрудников.ПараметрыФиксацииВторичныхДанных().ОписаниеФиксацииРеквизитов;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,";
	Для каждого ОписаниеРеквизита Из ОписаниеФиксацииРеквизитов Цикл
		Запрос.Текст = Запрос.Текст + "
		|	ДанныеСотрудников." + ОписаниеРеквизита.Значение.ИмяРеквизита + " КАК " + ОписаниеРеквизита.Значение.ИмяРеквизита + ",";
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТВторичныеДанные
	|ИЗ
	|	ВТЗакрытиеЛицевыхСчетов КАК ДанныеСотрудников";
	
	Запрос.Выполнить();
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, "Сотрудники");
	
КонецФункции

Процедура ЗаполнитьСотрудника(ДатаПолученияДанных, НомерСтроки) Экспорт
	
	Сотрудник = Сотрудники[НомерСтроки-1].Сотрудник;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ОбменСБанкамиПоЗарплатнымПроектам.СоздатьВТЗакрытиеЛицевыхСчетов(Запрос.МенеджерВременныхТаблиц, Ссылка, Организация, ЗарплатныйПроект, Подразделение, ДатаПолученияДанных, Сотрудник);
	Выборка = ОбменСБанкамиПоЗарплатнымПроектам.ДанныеСотрудниковДляЗакрытияЛицевыхСчетов(Запрос.МенеджерВременныхТаблиц).Выбрать();
	
	СтрокаТабличнойЧастиСотрудники = Сотрудники[НомерСтроки-1];
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧастиСотрудники, Выборка);
	Иначе
		СтрокаТабличнойЧастиСотрудники.ДатаЗакрытия = Неопределено;
		СтрокаТабличнойЧастиСотрудники.ЛицевойСчет = Неопределено;
		СтрокаТабличнойЧастиСотрудники.ИдентификаторСтрокиФикс = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Функция ОбъектЗафиксирован() Экспорт
	
	Если Не Проведен Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МассивФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Ссылка, МассивФайлов);
	
	Возврат МассивФайлов.Количество() > 0;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли