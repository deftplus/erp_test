#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьСостояниеОткрытияЛицевыхСчетов(
		ПервичныйДокумент,
		Отказ,
		ОбменСБанкамиПоЗарплатнымПроектам.СостояниеОткрытияЛицевыхСчетов(Ссылка),
		Ссылка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	СтандартнаяОбработка = Истина;
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(
		ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, СтандартнаяОбработка);
	
	Если СтандартнаяОбработка Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.УстановитьПараметр("ПервичныйДокумент", ПервичныйДокумент);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ХешФайла", ХешФайла);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка
		|ИЗ
		|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
		|ГДЕ
		|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПервичныйДокумент = &ПервичныйДокумент
		|	И НЕ ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка = &Ссылка
		|	И ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Проведен
		|	И ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ХешФайла = &ХешФайла";
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если НЕ Результат.Пустой() Тогда
			ТекстОшибки = НСтр("ru = 'Подтверждение по первичному документу уже зарегистрировано.';
								|en = 'Confirmation of the source document is already registered.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, ЭтотОбъект, "ПервичныйДокумент", , Отказ);
			Возврат;
		КонецЕсли;
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.ФизическоеЛицо КАК ФизическоеЛицо
		|ИЗ
		|	Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Сотрудники КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники
		|ГДЕ
		|	ЗаявкаНаОткрытиеЛицевыхСчетовСотрудниковСотрудники.Ссылка = &ПервичныйДокумент";
		СотрудникиПервичногоДокумента = Запрос.Выполнить().Выгрузить();
		СотрудникиПервичногоДокумента.Индексы.Добавить("ФизическоеЛицо");
		
		Для Каждого СтрокаДокумента Из Сотрудники Цикл
			
			Если СотрудникиПервичногоДокумента.Найти(СтрокаДокумента.ФизическоеЛицо, "ФизическоеЛицо") = Неопределено Тогда
				
				ОбщегоНазначения.СообщитьПользователю(
					СтрШаблон(
						НСтр("ru = 'Сотрудник %1 отсутствует в первичном документе.';
							|en = 'Employee %1 is missing in the source document.'"), 
						СтрокаДокумента.ФизическоеЛицо), 
					ЭтотОбъект, 
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
						"Сотрудники", 
						СтрокаДокумента.НомерСтроки, 
						"ФизическоеЛицо"),, 
					Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ОбменСБанкамиПоЗарплатнымПроектам.ОтменитьРегистрациюЛицевыхСчетовФизическихЛиц(Ссылка);
	
	ЛицевыеСчетаФизическихЛицДляРегистрации = ЛицевыеСчетаФизическихЛицДляРегистрации();
	ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьЛицевыеСчетаФизическихЛиц(ЛицевыеСчетаФизическихЛицДляРегистрации);
	
	ОбменСБанкамиПоЗарплатнымПроектам.ЗарегистрироватьИзмененияЛицевыхСчетов(ЛицевыеСчетаФизическихЛицДляРегистрации, Организация, МесяцОткрытия);
	
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
		
		ЗаполняемыеЗначения = Новый Структура;
		ЗаполняемыеЗначения.Вставить("Ответственный");
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
		Ответственный = ЗаполняемыеЗначения.Ответственный;
		
		Если ДанныеЗаполнения.Свойство("Сотрудники") Тогда
			Для Каждого СтрокаЗначенийЗаполнения Из ДанныеЗаполнения.Сотрудники Цикл
				ЗаполнитьЗначенияСвойств(Сотрудники.Добавить(), СтрокаЗначенийЗаполнения);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЛицевыеСчетаФизическихЛицДляРегистрации()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка.МесяцОткрытия, МЕСЯЦ) КАК МесяцОткрытия,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Организация,
	|	ЗарплатныеПроекты.Ссылка КАК ЗарплатныйПроект,
	|	СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников.ФизическоеЛицо,
	|	СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников.НомерЛицевогоСчета,
	|	ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка КАК ДокументОснование
	|ИЗ
	|	Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Сотрудники КАК СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПодтверждениеОткрытияЛицевыхСчетовСотрудников КАК ПодтверждениеОткрытияЛицевыхСчетовСотрудников
	|		ПО СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка = ПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников КАК ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников
	|		ПО (ПодтверждениеОткрытияЛицевыхСчетовСотрудников.ПервичныйДокумент = ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗарплатныеПроекты КАК ЗарплатныеПроекты
	|		ПО (ЗаявкаНаОткрытиеЛицевыхСчетовСотрудников.ЗарплатныйПроект = ЗарплатныеПроекты.Ссылка)
	|ГДЕ
	|	СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников.Ссылка = &Ссылка
	|	И СотрудникиПодтверждениеОткрытияЛицевыхСчетовСотрудников.РезультатОткрытияСчета = ЗНАЧЕНИЕ(Перечисление.РезультатыОткрытияЛицевыхСчетовСотрудников.СчетОткрыт)";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Область ПроцедурыИФункцииДляПолученияФайлаПодтверждения

Процедура ЗаполнитьДокументИзОбъектаXDTO(ОбъектXDTO, ХешСумма, СсылкаНаПервичныйДокумент, Отказ) Экспорт
	
	ПервичныйДокумент = СсылкаНаПервичныйДокумент;
	
	СтруктураДанныхДляЗаполненияДокумента = ОбменСБанкамиПоЗарплатнымПроектам.СтруктураДляЗаполненияДокументаПоПодтверждениюБанка(
			"ПодтверждениеОткрытияЛицевыхСчетовСотрудников", ОбъектXDTO, ХешСумма, ПервичныйДокумент, Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаСотрудников = СтруктураДанныхДляЗаполненияДокумента.Сотрудники;
	
	ФизическиеЛицаДокумента = ОбменСБанкамиПоЗарплатнымПроектам.ФизическиеЛицаПоДокументамУдостоверяющимЛичность(
		ПервичныйДокумент, ТаблицаСотрудников);
	
	КолонкиТЗ = ТаблицаСотрудников.Колонки;
	Если КолонкиТЗ.Найти("ФизическоеЛицо") = Неопределено Тогда
		КолонкиТЗ.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("СправочникСсылка.ФизическиеЛица"));
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из ТаблицаСотрудников Цикл
		Отбор = Новый Структура();
		Отбор.Вставить("ДокументВид", СтрокаТЧ.ДокументВид);
		Отбор.Вставить("КодВидаДокумента", СтрокаТЧ.КодВидаДокумента);
		Отбор.Вставить("ДокументСерия", СтрокаТЧ.ДокументСерия);
		Отбор.Вставить("ДокументНомер", СтрокаТЧ.ДокументНомер);
		СтрокаЛС = ФизическиеЛицаДокумента.НайтиСтроки(Отбор);
		Если СтрокаЛС.Количество() = 0 Тогда
			СтрокаТЧ.ФизическоеЛицо = Неопределено;
		Иначе
			СтрокаТЧ.ФизическоеЛицо = СтрокаЛС[0].ФизическоеЛицо
		КонецЕсли
	КонецЦикла;
	
	Сотрудники.Очистить();
	Заполнить(СтруктураДанныхДляЗаполненияДокумента);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли