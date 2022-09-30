////////////////////////////////////////////////////////////////////////////////
// Проверка контрагентов в Декларации по НДС
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	ПроверкаКонтрагентовБРОКлиентСервер.ИнициализироватьРеквизитыПроверкиКонтрагентов(Форма);
	
	// Предлагаем заменить стандартное поведение
	Если НЕ СтандартноеДействиеПриСозданииНаСервереОтчета(Форма) Тогда
		Возврат;
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	ЕстьПравоНаИспользованиеПроверки = ЕстьПравоНаИспользованиеПроверки();
	
	Форма.Элементы.ПроверитьКонтрагентовВОтчетеКоманда.Видимость = ЕстьПравоНаИспользованиеПроверки;
	
КонецПроцедуры

Функция ПолучитьРезультатРаботыФоновогоЗадания(Форма) Экспорт
	
	Если ЭтоАдресВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища) Тогда
		
		РезультатПроверкиКонтрагентов = ПолучитьИзВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
		Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища = Неопределено;
		
		Если РезультатПроверкиКонтрагентов <> Неопределено Тогда
			
			// Копируем результаты проверок из фонового задания в реквизиты формы.
			ЗаполнитьЗначенияСвойств(Форма.РеквизитыПроверкиКонтрагентов, РезультатПроверкиКонтрагентов);
			
			Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
				// Записываем новые значения реквизитов в регистр.
				ЗаписатьРеквизитыПроверкиКонтрагентовВРегистрПриСохраненииДекларации(Форма);
			КонецЕсли;
			
		КонецЕсли;
		
		// Проверяем заново, может доступ в интернет уже появился.
		Форма.Модифицированность = Ложь;
		
		Возврат РезультатПроверкиКонтрагентов;
		
	КонецЕсли;
	
	Возврат Новый Структура;
	
КонецФункции

Процедура ПроверитьКонтрагентовВОтчете(Форма, ДополнительныеПараметры) Экспорт
	
	Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания = Неопределено;

	// Очистка в форме.
	ОчиститьРезультатыПроверкиКонтрагентов(Форма);
	// Очистка в регистре.
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
		ОчиститьСохраненныеРезультатыПроверкиВРегистре(Форма);
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ЭтоЗапускПроверкиПослеЗаполнения") Тогда
		ОтклонитьПроверкуКонтрагентов = Не ПроверкаКонтрагентовВключена();
		Если ОтклонитьПроверкуКонтрагентов Тогда
			Форма.РеквизитыПроверкиКонтрагентов.Вставить("ПроверкаКонтрагентовОтклонена", ОтклонитьПроверкуКонтрагентов);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Параметры = ПараметрыФоновогоЗадания(Форма, ДополнительныеПараметры);
	
	Если Параметры = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	НаименованиеЗадания = НСтр("ru = 'Проверка контрагентов в отчетах по НДС';
								|en = 'Проверка контрагентов в отчетах по НДС'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		Форма.УникальныйИдентификатор,
		"ПроверкаКонтрагентовБРО.ПроверитьКонтрагентовВОтчетахФоновоеЗадание",
		Параметры,
		НаименованиеЗадания);
		
	Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища       = Результат.АдресХранилища;
	Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
КонецПроцедуры

Процедура ВосстановитьРезультатыПроверкиПриСозданииНаСервере(Форма) Экспорт
	
	Если НЕ Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Возврат;
	КонецЕсли;
	
	ОтчетДобавленКопированием = ЗначениеЗаполнено(Форма.СтруктураРеквизитовФормы.мСкопированаФорма);
	
	Если НЕ ОтчетДобавленКопированием Тогда
		
		ВосстановитьРеквизитыПроверкиКонтрагентовИзРегистра(Форма);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СохранитьРезультатыПроверкиПриСохраненииДекларации(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		ЗаписатьРеквизитыПроверкиКонтрагентовВРегистрПриСохраненииДекларации(Форма);
	Иначе
		ОчиститьСохраненныеРезультатыПроверкиВРегистре(Форма);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКонтрагентовВОтчетахФоновоеЗадание(Знач Параметры, АдресХранилища) Экспорт
	
	РезультатПроверки = ПроверкаКонтрагентовБРОКлиентСервер.ПустойРезультатПроверки();
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(РезультатПроверки, Параметры, Истина);
	
	РезультатПроверки.ЕстьДоступКВебСервисуФНС = ЕстьДоступКВебСервисуФНС();
	
	Если РезультатПроверки.ЕстьДоступКВебСервисуФНС Тогда
		
		Если Параметры.Свойство("ЭтоДекларацияПоНДС") Тогда 
			ВсеНекорректныеКонтрагенты = ПроверитьВсехКонтрагентовВДекларации(Параметры, РезультатПроверки);
		Иначе
			ВсеНекорректныеКонтрагенты = ПроверитьВсехКонтрагентовВОтчетеПоНДС(Параметры, РезультатПроверки);
		КонецЕсли;
		
		Если РезультатПроверки.ЕстьДоступКВебСервисуФНС Тогда
			ТабличныйДокумент = Отчеты.ОтчетПоНекорректнымКонтрагентам.СформироватьОтчет(ВсеНекорректныеКонтрагенты, Параметры);
			
			Если Параметры.Свойство("ЭтоДекларацияПоНДС") Тогда 
				ЗаписатьТабличныйДокументВРегистр(Параметры.ДекларацияНДС, ТабличныйДокумент);
			Иначе
				// Нельзя возвращать результат во временном хранилище, 
				// так как из фонового задания такие результаты возвращаются пустыми.
				// Поэтому возвращаем табличный документ как он есть.
				РезультатПроверки.Вставить("ТабДок", ТабличныйДокумент);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РезультатПроверки.Свойство("СтраницыРазделов") Тогда
		РезультатПроверки.Удалить("СтраницыРазделов");
	КонецЕсли;
	
	Если РезультатПроверки.Свойство("ВсеКонтрагенты") Тогда
		РезультатПроверки.Удалить("ВсеКонтрагенты");
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(РезультатПроверки, АдресХранилища);
	
КонецПроцедуры

Процедура ОчиститьРезультатыПроверкиКонтрагентов(Форма) Экспорт

	Если НЕ Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Возврат;
	КонецЕсли;
	
	// Обнуляем значения в структуре до исходных значений
	ЗаполнитьЗначенияСвойств(
		Форма.РеквизитыПроверкиКонтрагентов, 
		ПроверкаКонтрагентовБРОКлиентСервер.ПустойРезультатПроверки());
	
КонецПроцедуры

Процедура ПередФормированиемОтчета(Форма) Экспорт
	
	// Инициализируем параметры заново, так как при проверке контрагентов мы их удалили.
	ПроверкаКонтрагентов.ИнициализироватьРеквизитыФормыОтчета(Форма, Истина);
	
	// Подменяем признак ПроверкаИспользуется.
	// Проверяем всегда, когда можно, а не когда проверка включена централизованно.
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(
		Форма.РеквизитыПроверкиКонтрагентов, 
		ПроверкаКонтрагентовБРОКлиентСервер.ПрочиеРеквизиты(Ложь), 
		Истина); 
		
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Форма.РеквизитыПроверкиКонтрагентов.ЕстьДоступКВебСервисуФНС = ЕстьДоступКВебСервисуФНС();
		Форма.РеквизитыПроверкиКонтрагентов.ВыведеныВсеСтроки = Истина;
		Форма.РеквизитыПроверкиКонтрагентов.НедействующиеКонтрагентыКоличество = 0;
		Форма.РеквизитыПроверкиКонтрагентов.КонтрагентыСПустымСостояниемКоличество = 0;
		Если ЭтоАдресВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища) Тогда
			УдалитьИзВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
		КонецЕсли;
		Если ЭтоАдресВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресДанныхОтчета) Тогда
			УдалитьИзВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресДанныхОтчета);
		КонецЕсли;
		Если ЭтоАдресВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресРезультатаЗаполненияОтчета) Тогда
			УдалитьИзВременногоХранилища(Форма.РеквизитыПроверкиКонтрагентов.АдресРезультатаЗаполненияОтчета);
		КонецЕсли;
		Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища 					= "";
		Форма.РеквизитыПроверкиКонтрагентов.АдресДанныхОтчета 				= "";
		Форма.РеквизитыПроверкиКонтрагентов.АдресРезультатаЗаполненияОтчета	= "";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодменитьТаблицуНедействующихКонтрагенты(Форма, ПараметрыОтчета) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		ПараметрыОтчета.ДанныеДляПроверкиКонтрагентов.НедействующиеКонтрагенты = ШаблонТаблицыДанныеКонтрагента();

	КонецЕсли;

КонецПроцедуры

Процедура ПриЗакрытииОтчета(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается так же из книг и журнала.
Процедура ЗаполнитьДанныеКонтрагента(
		ДанныеКонтрагентов, 
		Контрагент, 
		КонтрагентНаименование, 
		ИНН, 
		КПП, 
		Дата, 
		Документ,
		ПредставлениеДокумента,
		Сумма,
		Номер) Экспорт
	
	НоваяСтрока 			= ДанныеКонтрагентов.Добавить();
	НоваяСтрока.Контрагент 	= Контрагент;
	НоваяСтрока.КонтрагентНаименование = КонтрагентНаименование;
	НоваяСтрока.ИНН 		= ИНН;
	НоваяСтрока.КПП 		= КПП;
	НоваяСтрока.Дата 		= Дата;
	НоваяСтрока.Документ 	= Документ;
	НоваяСтрока.ПредставлениеДокумента = ПредставлениеДокумента;
	НоваяСтрока.Сумма 		= Сумма;
	НоваяСтрока.Номер 		= Номер;

КонецПроцедуры

#Область ОболочкаДляПодсистемыБСП

Функция РаботаСКонтрагентамиСуществует() Экспорт
	Возврат ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКонтрагентами");
КонецФункции

#Область Функции

Функция ЕстьПравоНаИспользованиеПроверки() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Ложь;
	
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
		
		СтандартнаяОбработка 	= Истина; 
		Модуль.ЕстьПравоНаИспользованиеПроверки(Результат, СтандартнаяОбработка);
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Возврат Модуль.ЕстьПравоНаИспользованиеПроверки();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЕстьПравоНаРедактированиеНастроек() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Ложь;
			
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
		
		СтандартнаяОбработка 	= Истина;
		Модуль.ЕстьПравоНаРедактированиеНастроек(Результат, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Возврат Модуль.ЕстьПравоНаРедактированиеНастроек();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЕстьДоступКВебСервисуФНС() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Ложь;
	
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда

		СтандартнаяОбработка = Истина;
		Модуль.ЕстьДоступКВебСервисуФНС(Результат, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Возврат Модуль.ЕстьДоступКВебСервисуФНС();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПроверкаКонтрагентовВключена() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Ложь;
			
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
	
		СтандартнаяОбработка = Истина; 
		Модуль.ПроверкаКонтрагентовВключена(Результат, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Возврат Модуль.ПроверкаКонтрагентовВключена();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СостоянияНедействующегоКонтрагента(ДополнятьСостояниемСОшибкой = Ложь, ДополнятьПустымСостоянием = Ложь) Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Новый Массив;
	
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
		
		СтандартнаяОбработка = Истина; 
		Модуль.СостоянияНедействующегоКонтрагента(ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием, Результат, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентовКлиентСервер");
		Возврат Модуль.СостоянияНедействующегоКонтрагента(ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СсылкаНаИнструкцию() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Результат = Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее о проверке';
												|en = 'Подробнее о проверке'"),,,, "e1cib/app/Обработка.ИнструкцияПоИспользованиюПроверкиКонтрагента");
	
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
		
		СтандартнаяОбработка = Истина; 
		Модуль.СсылкаНаИнструкцию(Результат, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Результат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентовКлиентСервер");
		Возврат Модуль.СсылкаНаИнструкцию();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Процедуры

Процедура ПроверитьВебСервисомФНС(ДанныеКонтрагентов, ДополнительныеПараметры) Экспорт
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Модуль.ПроверитьВебСервисомФНС(ДанныеКонтрагентов, ДополнительныеПараметры);
	КонецЕсли;
		
КонецПроцедуры

Процедура ВключитьВыключитьПроверкуКонтрагентов(ВключитьПроверку) Экспорт
	
	// Предлагаем заменить стандартное поведение
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
	
		СтандартнаяОбработка = Истина; 
		Модуль.ВключитьВыключитьПроверкуКонтрагентов(ВключитьПроверку, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Модуль.ВключитьВыключитьПроверкуКонтрагентов(ВключитьПроверку);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьКонтрагентовПослеВключенияПроверкиФоновоеЗадание() Экспорт
	
	// Предлагаем заменить стандартное поведение
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
			
		СтандартнаяОбработка = Истина; 
		Модуль.ПроверитьКонтрагентовПослеВключенияПроверкиФоновоеЗадание(СтандартнаяОбработка);
		Если НЕ СтандартнаяОбработка Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	// Конец. Предлагаем заменить стандартное поведение
	
	Если РаботаСКонтрагентамиСуществует() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентов");
		Модуль.ПроверитьКонтрагентовПослеВключенияПроверкиФоновоеЗадание();
	КонецЕсли;
	
КонецПроцедуры

Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	
	ВариантыОтчетовСуществуют = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов");
	
	Если ВариантыОтчетовСуществуют Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
		Модуль.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ОтчетПоНекорректнымКонтрагентам).Включен = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

#Область СохранениеИВосстановление

Процедура ОчиститьСохраненныеРезультатыПроверкиВРегистре(Форма)
	
	// Очистка данных в регистре.
	ОчиститьРезультатПроверкиРазделаВРегистре(Форма, "РеквизитыПроверкиКонтрагентов");
	ОчиститьРезультатПроверкиРазделаВРегистре(Форма, "ПроверкаКонтрагентов_ТабличныйДокумент");
	
КонецПроцедуры

Процедура ЗаписатьРеквизитыПроверкиКонтрагентовВРегистрПриСохраненииДекларации(Форма)
	
	ВидДополнительногоФайла 	= "РеквизитыПроверкиКонтрагентов";
	Ссылка 						= Форма.СтруктураРеквизитовФормы.мСохраненныйДок.Ссылка;
	Данные						= Форма.РеквизитыПроверкиКонтрагентов;
	
	ЗаписатьДанныеВРегистр(Ссылка, ВидДополнительногоФайла, Данные);
	
КонецПроцедуры

Процедура ЗаписатьТабличныйДокументВРегистр(Ссылка, ТабличныйДокумент)
	
	ВидДополнительногоФайла 	= "ПроверкаКонтрагентов_ТабличныйДокумент";
	Данные						= ТабличныйДокумент;
	
	ЗаписатьДанныеВРегистр(Ссылка, ВидДополнительногоФайла, Данные);
	
КонецПроцедуры

Процедура ЗаписатьДанныеВРегистр(Ссылка, ВидДополнительногоФайла, Данные)
	
	ЗаписьРегистраСведений = РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов.СоздатьМенеджерЗаписи();
	ЗаписьРегистраСведений.РегламентированныйОтчет 	= Ссылка;
	ЗаписьРегистраСведений.ВидДополнительногоФайла 	= ВидДополнительногоФайла;
	ЗаписьРегистраСведений.СодержимоеФайла 			= Новый ХранилищеЗначения(Данные);
	ЗаписьРегистраСведений.ИмяФайла 				= ВидДополнительногоФайла + ".mxl";
	ЗаписьРегистраСведений.Размер 					= 1;
	ЗаписьРегистраСведений.ДатаДобавления 			= ТекущаяДатаСеанса();
	ЗаписьРегистраСведений.Записать();
	
КонецПроцедуры

Процедура ОчиститьРезультатПроверкиРазделаВРегистре(Форма, ВидДополнительногоФайла)
	
	СтруктураРеквизитовФормы = Форма.СтруктураРеквизитовФормы;
	
	ЗаписьРегистраСведений = РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов.СоздатьМенеджерЗаписи();
	ЗаписьРегистраСведений.РегламентированныйОтчет = СтруктураРеквизитовФормы.мСохраненныйДок.Ссылка;
	ЗаписьРегистраСведений.ВидДополнительногоФайла = ВидДополнительногоФайла;
	
	ЗаписьРегистраСведений.Удалить();
	
КонецПроцедуры

Функция ПрочитатьДанныеИзРегистра(Ссылка, ВидДополнительногоФайла) Экспорт
	
	ЗаписьРегистраСведений = РегистрыСведений.ДополнительныеФайлыРегламентированныхОтчетов.СоздатьМенеджерЗаписи();
	ЗаписьРегистраСведений.РегламентированныйОтчет = Ссылка;
	ЗаписьРегистраСведений.ВидДополнительногоФайла = ВидДополнительногоФайла;
	
	ЗаписьРегистраСведений.Прочитать();
	
	Возврат ЗаписьРегистраСведений;
	
КонецФункции

Процедура ВосстановитьРеквизитыПроверкиКонтрагентовИзРегистра(Форма)
	
	ВидДополнительногоФайла = "РеквизитыПроверкиКонтрагентов";
	Ссылка = Форма.СтруктураРеквизитовФормы.мСохраненныйДок;
	
	ЗаписьРегистраСведений = ПрочитатьДанныеИзРегистра(Ссылка, ВидДополнительногоФайла);
	
	Если ЗначениеЗаполнено(ЗаписьРегистраСведений.ВидДополнительногоФайла) Тогда
		
		ВосстановленныеРеквизитыПроверкиКонтрагентов = ЗаписьРегистраСведений.СодержимоеФайла.Получить();
		
		Для каждого Свойство Из Форма.РеквизитыПроверкиКонтрагентов Цикл
			Ключ = Свойство.Ключ;
			
			Если Ключ <> "ПроверкаИспользуется" Тогда  
				
				Если ВосстановленныеРеквизитыПроверкиКонтрагентов.Свойство(Ключ) Тогда
					Форма.РеквизитыПроверкиКонтрагентов[Ключ] = ВосстановленныеРеквизитыПроверкиКонтрагентов[Ключ];
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла; 
		
	КонецЕсли;
	
	Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область Проверка

Функция ПроверитьВсехКонтрагентовВДекларации(Параметры, РезультатПроверки)
	
	КоличествоКонтрагентов = 0;
	ВсеНекорректныеКонтрагенты = ШаблонТаблицыДанныеКонтрагента();
	
	Разделы = ПроверкаКонтрагентовБРОКлиентСервер.ПроверяемыеРазделыДекларацииПоНДС();
	
	Для НомерРаздела = Разделы.Начальный По Разделы.Конечный Цикл
	
		СтраницыРаздела = Параметры.СтраницыРазделов["СтраницыРаздел" + Формат(НомерРаздела, "ЧГ=0")];
		Для каждого СтраницаРаздела Из СтраницыРаздела Цикл
			
			ВсеКонтрагентыСтраницыРаздела 			= ВсеКонтрагентыСтраницыРаздела(Параметры, НомерРаздела, СтраницаРаздела);
			КоличествоКонтрагентовСтраницыРаздела 	= ВсеКонтрагентыСтраницыРаздела.Количество();

			Если КоличествоКонтрагентовСтраницыРаздела = 0 Тогда
				Продолжить;
			Иначе
				КоличествоКонтрагентов = КоличествоКонтрагентов + КоличествоКонтрагентовСтраницыРаздела;
			КонецЕсли;
			
			НекорректныеКонтрагентыСтраницыРаздела 	= НекорректныеКонтрагенты(
				ВсеКонтрагентыСтраницыРаздела,
				РезультатПроверки.ЕстьДоступКВебСервисуФНС);
				
			// В ходе длительной проверки сервис ФНС может отвалиться на одном из проверяемых блоков данных.
			// Тогда всю проверку считаем несостоявшейся.
			Если НЕ РезультатПроверки.ЕстьДоступКВебСервисуФНС Тогда
				Возврат Неопределено;
			КонецЕсли;
				
			ВсеКонтрагентыСтраницыРаздела = Неопределено; // Очищаем, чтобы не было переполнения памяти
			
			// Добавляем контрагентов этой страницы этого раздела к полному списку некорректных контрагентов.
			ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(НекорректныеКонтрагентыСтраницыРаздела, ВсеНекорректныеКонтрагенты);
			НекорректныеКонтрагентыСтраницыРаздела = Неопределено; // Очищаем, чтобы не было переполнения памяти 
			
		КонецЦикла;
		
	КонецЦикла;
	
	// Нас интересуют только три состояния.
	УдалитьСтрокиСНезначимымСостоянием(ВсеНекорректныеКонтрагенты);
	
	РезультатПроверки.ВсегоКонтрагентов 					= КоличествоКонтрагентов;
	РезультатПроверки.КоличествоНекорректныхКонтрагентов 	= ВсеНекорректныеКонтрагенты.Количество();
	
	Возврат ВсеНекорректныеКонтрагенты;
	
КонецФункции

Функция ПроверитьВсехКонтрагентовВОтчетеПоНДС(Параметры, РезультатПроверки)
	
	ВсеКонтрагенты 			= Параметры.ВсеКонтрагенты;
	КоличествоКонтрагентов 	= ВсеКонтрагенты.Количество();
	
	ЕстьДоступКВебСервисуФНС = Истина;
	ВсеНекорректныеКонтрагенты 	= НекорректныеКонтрагенты(ВсеКонтрагенты, ЕстьДоступКВебСервисуФНС);
	
	// Нас интересуют только три состояния.
	УдалитьСтрокиСНезначимымСостоянием(ВсеНекорректныеКонтрагенты);
	
	РезультатПроверки.ВсегоКонтрагентов 					= КоличествоКонтрагентов;
	РезультатПроверки.КоличествоНекорректныхКонтрагентов 	= ВсеНекорректныеКонтрагенты.Количество();
	
	Возврат ВсеНекорректныеКонтрагенты;
	
КонецФункции

Функция ЭтоЗначимоеСостояние(Состояние)
	
	Возврат Состояние = Перечисления.СостоянияСуществованияКонтрагента.КонтрагентОтсутствуетВБазеФНС
		ИЛИ Состояние = Перечисления.СостоянияСуществованияКонтрагента.КППНеСоответствуетДаннымБазыФНС
		ИЛИ Состояние = Перечисления.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП;
	
КонецФункции

Процедура УдалитьСтрокиСНезначимымСостоянием(ДанныеКонтрагентов)
	
	// Оставляем в таблице только контрагентов с нужными состояниями.
	Количество 	= ДанныеКонтрагентов.Количество();
	Индекс 		= Количество - 1; 
	Пока Индекс >= 0 Цикл 
		Состояние = ДанныеКонтрагентов[Индекс].Состояние;
		Если НЕ ЭтоЗначимоеСостояние(Состояние) Тогда 
			ДанныеКонтрагентов.Удалить(Индекс); 
		КонецЕсли; 
		Индекс = Индекс - 1; 
	КонецЦикла;
	
	СвернутьТаблицу(ДанныеКонтрагентов);
	
КонецПроцедуры

Функция НекорректныеКонтрагенты(ПроверяемыеКонтрагенты, ЕстьДоступКВебСервисуФНС)
	
	АдресХранилища 		= ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	ДанныеКонтрагентов 	= ПроверяемыеКонтрагенты.Скопировать();
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("АдресХранилища", 		АдресХранилища);
	ДополнительныеПараметры.Вставить("ЭтоПроверкаОтчета", 	Истина);
	
	ПроверитьВебСервисомФНС(ДанныеКонтрагентов, ДополнительныеПараметры);
	
	// Двухступенчатая проверка наличия доступа к веб-сервису ФНС:
	// 1. По результату пинга перед отправкой блока данных на проверку.
	// 2. По тому, заполнились ли состояния в результате проверки.
	ЕстьДоступКВебСервисуФНС = ДополнительныеПараметры.ЕстьДоступКВебСервисуФНС;
	
	Если ЕстьДоступКВебСервисуФНС Тогда
		
		// Если все состояния после проверки пустые, то сервис недоступен.
		ОтборПустыхСостояний = Новый Структура(
			"Состояние",
			Перечисления.СостоянияСуществованияКонтрагента.ПустаяСсылка());
			
		ЕстьДоступКВебСервисуФНС = 
			ДанныеКонтрагентов.НайтиСтроки(ОтборПустыхСостояний).Количество() <> 
			ДанныеКонтрагентов.Количество();
		
	КонецЕсли;
	
	// Не интересуют контрагенты с состоянием КонтрагентСодержитОшибкиВДанных 
	СостоянияНедействующегоКонтрагента = СостоянияНедействующегоКонтрагента();
	ЗаполнитьСостояния(ПроверяемыеКонтрагенты, ДанныеКонтрагентов, СостоянияНедействующегоКонтрагента);
	
	СвернутьТаблицу(ПроверяемыеКонтрагенты);
	
	Возврат ПроверяемыеКонтрагенты;

КонецФункции

Процедура СвернутьТаблицу(ДанныеКонтрагентов)
	
	ДанныеКонтрагентов.Свернуть(КолонкиТаблицы(ДанныеКонтрагентов, "ДополнительныеПараметры"));
	// Сортируем таблицу так, как данные будут выводиться в отчете.
	ДанныеКонтрагентов.Сортировать("Состояние, КонтрагентНаименование, Контрагент, ИНН, КПП, Дата", Новый СравнениеЗначений);

КонецПроцедуры

Функция КолонкиТаблицы(ДанныеКонтрагентов, ИсключаяКолонки = "")
	
	МассивКолонокКИсключению = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсключаяКолонки, ",", Истина, Истина);
	
	// Порядок колонок берется из процедуры ШаблонТаблицыДанныеКонтрагента
	МассивКолонок = Новый Массив;
	Для каждого Колонка Из ДанныеКонтрагентов.Колонки Цикл
		
		Если МассивКолонокКИсключению.Найти(Колонка.Имя) = Неопределено Тогда
			МассивКолонок.Добавить(Колонка.Имя);
		КонецЕсли;
		
	КонецЦикла;
	
	Колонки = СтрСоединить(МассивКолонок, ",");

	Возврат Колонки;

КонецФункции

Функция ВсеКонтрагентыСтраницыРаздела(Параметры, НомерРаздела, СтраницаРаздела)
	
	ТаблицаРаздела = РегламентированнаяОтчетность.СегментДанныхРазделаДекларацииНДС(
		Параметры.ДекларацияНДС, 
		"Раздел" + Строка(НомерРаздела), 
		СтраницаРаздела.НомерПервойСтроки);
	
	ДанныеКонтрагентов = ШаблонТаблицыДанныеКонтрагента();
	
	ДобавитьКонтрагентовИзТаблицыКДаннымКонтрагентов(Параметры, ТаблицаРаздела, НомерРаздела, ДанныеКонтрагентов);
	
	Возврат ДанныеКонтрагентов;
	
КонецФункции

Процедура ДобавитьКонтрагентовИзТаблицыКДаннымКонтрагентов(Параметры, ТаблицаРаздела, НомерРаздела, ДанныеКонтрагентов)
	
	Если ТаблицаРаздела <> Неопределено Тогда
		
		Для каждого СтрокаРаздела Из ТаблицаРаздела Цикл
			
			ДобавитьКонтрагента(Параметры, ДанныеКонтрагентов, НомерРаздела, СтрокаРаздела);
					
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры

Функция ИмяПоляКонтрагентаРаздела(НомерРаздела)
	
	Если НомерРаздела = 8
		ИЛИ НомерРаздела = 11 Тогда
		Имя = "СвПрод";
	ИначеЕсли НомерРаздела = 9
		ИЛИ НомерРаздела = 10
		ИЛИ НомерРаздела = 12 Тогда
		Имя = "СвПокуп";
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

Функция ШаблонТаблицыДанныеКонтрагента()
	
	ДанныеКонтрагентов = Новый ТаблицаЗначений;
	
	// Список колонок должен быть строго таким.
	// Потом эта последовательность учитывается при сортировке и свертке таблицы.
	ДанныеКонтрагентов.Колонки.Добавить("Состояние", 	Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияСуществованияКонтрагента"));
	ДанныеКонтрагентов.Колонки.Добавить("Контрагент", 	Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДанныеКонтрагентов.Колонки.Добавить("КонтрагентНаименование", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(200)));
	ДанныеКонтрагентов.Колонки.Добавить("ИНН", 			Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(12)));
	ДанныеКонтрагентов.Колонки.Добавить("КПП", 			Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(9)));
	ДанныеКонтрагентов.Колонки.Добавить("Документ", 	Документы.ТипВсеСсылки());
	ДанныеКонтрагентов.Колонки.Добавить("ПредставлениеДокумента", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(200)));
	ДанныеКонтрагентов.Колонки.Добавить("Сумма", 		Новый ОписаниеТипов("Число"	, Новый КвалификаторыЧисла(19, 2)));
	ДанныеКонтрагентов.Колонки.Добавить("Дата", 		Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	ДанныеКонтрагентов.Колонки.Добавить("Номер", 		Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(30)));
	ДанныеКонтрагентов.Колонки.Добавить("ДополнительныеПараметры", Новый ОписаниеТипов("Структура"));
	
	ДобавитьКолонкуОбластьДанных(ДанныеКонтрагентов);
	
	Возврат ДанныеКонтрагентов;
	
КонецФункции

Процедура ДобавитьКонтрагента(Параметры, ДанныеКонтрагентов, НомерРаздела, СтрокаРаздела) 
	
	ДанныеКонтрагента 	= СтрокаРаздела[ИмяПоляКонтрагентаРаздела(НомерРаздела)];
	Дата 				= ДатаСчетаФактурыВДекларации(СтрокаРаздела, НомерРаздела);
	Документ			= ДополнительныеСведения(Параметры, СтрокаРаздела, "Документ");
	ПредставлениеДокументаВДекларации = ДополнительныеСведения(Параметры, СтрокаРаздела, "ПредставлениеДокумента");
	Сумма				= СуммаПоДокументу(Параметры, СтрокаРаздела, НомерРаздела);
	Номер 				= НомерДокумента(СтрокаРаздела, НомерРаздела);

	Если ТипЗнч(ДанныеКонтрагента) = Тип("Структура") Тогда
		
		ЗаполнитьДанныеКонтрагента(
			ДанныеКонтрагентов,
			КонтрагентВДекларации(Параметры, ДанныеКонтрагента),
			НаименованиеКонтрагента(Параметры, ДанныеКонтрагента),
			ИННКонтрагентаВДекларации(ДанныеКонтрагента),
			КППКонтрагентаВДекларации(ДанныеКонтрагента),
			Дата,
			Документ,
			ПредставлениеДокументаВДекларации,
			Сумма,
			Номер);
				
	ИначеЕсли ТипЗнч(ДанныеКонтрагента) = Тип("Массив") Тогда
		
		Для каждого СтрокаДанныхКонтрагента Из ДанныеКонтрагента Цикл
					
			ЗаполнитьДанныеКонтрагента(
				ДанныеКонтрагентов,
				КонтрагентВДекларации(Параметры, СтрокаДанныхКонтрагента),
				НаименованиеКонтрагента(Параметры, СтрокаДанныхКонтрагента),
				ИННКонтрагентаВДекларации(СтрокаДанныхКонтрагента),
				КППКонтрагентаВДекларации(СтрокаДанныхКонтрагента),
				Дата,
				Документ,
				ПредставлениеДокументаВДекларации,
				Сумма,
				Номер);
			
		КонецЦикла;
			
	КонецЕсли;
	
КонецПроцедуры

#Область ПреобразованиеДанныхКНужномуФормату

Функция НомерДокумента(Строка, НомерРаздела)
	
	Номер = "";
	
	Если НомерРаздела = 12 Тогда
		Номер = Строка.НомСчФ;
	Иначе
		
		// Проверка именно в таком порядке:
		// Если есть корректировка, то берем номер корректировки, если нет,
		// то берем обычный номер

		Если ЗначениеЗаполнено(Строка.НомКСчФПрод) Тогда
			Номер = Строка.НомКСчФПрод;
		Иначе
			Номер = Строка.НомСчФПрод;
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Номер;
	
КонецФункции

Функция СуммаПоДокументу(Параметры, Строка, НомерРаздела)
	
	Сумма = 0;
	Если НомерРаздела = 8 Тогда
		Сумма = Строка.СтоимПокупВ;
	ИначеЕсли НомерРаздела = 9 Тогда
		Сумма = Строка.СтоимПродСФ;
	ИначеЕсли НомерРаздела = 10 
		И Параметры.Свойство("ЭтоДекларацияПоНДС")
		И НЕ Параметры.Свойство("ЭтоКонсолидация") Тогда
		// В консолидации нет этого поля.
		Сумма = Строка.СуммаПосрДеят;
	ИначеЕсли НомерРаздела = 11 Тогда
		Сумма = Строка.СтоимТовСчФВс;
	ИначеЕсли НомерРаздела = 12 Тогда
		Сумма = Строка.СтоимТовСНалВс;
	КонецЕсли;
		
	Возврат Сумма;
	
КонецФункции
	
Функция ДополнительныеСведения(Параметры, Строка, Свойство)
	
	Документ = Неопределено;
	
	Если Параметры.Свойство("ЭтоДекларацияПоНДС")
		И НЕ Параметры.Свойство("ЭтоКонсолидация") Тогда
	
		Если ТипЗнч(Строка.ДополнительныеСведения) = Тип("Структура")
			И Строка.ДополнительныеСведения.Свойство(Свойство) Тогда
			Документ = Строка.ДополнительныеСведения[Свойство];
		КонецЕсли;
		
	КонецЕсли;
		
	Возврат Документ;
	
КонецФункции

Функция ДатаСчетаФактурыВДекларации(Строка, НомерРаздела)
	
	Результат = Дата(1,1,1);
	
	Если НомерРаздела = 12 Тогда
		Результат = ДатаИзСтроки(Строка.ДатаСчФ);
	Иначе
		ДатаСчФПрод 	= Строка.ДатаСчФПрод;
		ДатаИспрСчФ 	= Строка.ДатаИспрСчФ;
		ДатаКСчФПрод 	= Строка.ДатаКСчФПрод;
		ДатаИспрКСчФ 	= Строка.ДатаИспрКСчФ;
		
		Если ДатаЗаполнена(ДатаИспрКСчФ) Тогда
			Результат = ДатаИзСтроки(ДатаИспрКСчФ);
		ИначеЕсли ДатаЗаполнена(ДатаКСчФПрод) Тогда
			Результат = ДатаИзСтроки(ДатаКСчФПрод);
		ИначеЕсли ДатаЗаполнена(ДатаИспрСчФ) Тогда
			Результат = ДатаИзСтроки(ДатаИспрСчФ);
		Иначе
			Результат = ДатаИзСтроки(ДатаСчФПрод);
		КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция КонтрагентВДекларации(Параметры, ДанныеКонтрагента)
	
	// В консолидированной декларации нет этого поля.
	Если Параметры.Свойство("ЭтоДекларацияПоНДС")
		И НЕ Параметры.Свойство("ЭтоКонсолидация") Тогда
		Возврат ДанныеКонтрагента.Контрагент;
	Иначе
		Возврат Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция НаименованиеКонтрагента(Параметры, ДанныеКонтрагента)
	
	// В консолидированной декларации нет этого поля.
	Если Параметры.Свойство("ЭтоДекларацияПоНДС")
		И НЕ Параметры.Свойство("ЭтоКонсолидация") Тогда
		Возврат ДанныеКонтрагента.КонтрагентНаименование;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ИННКонтрагентаВДекларации(ДанныеКонтрагента)
	
	ИНН = "";
	
	Если ДанныеКонтрагента <> Неопределено Тогда
		Если ДанныеКонтрагента.Свойство("ИННФЛ") Тогда
			ИНН = ДанныеКонтрагента.ИННФЛ;
		ИначеЕсли ДанныеКонтрагента.Свойство("ИННЮЛ") Тогда
			ИНН = ДанныеКонтрагента.ИННЮЛ;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИНН;
	
КонецФункции

Функция КППКонтрагентаВДекларации(ДанныеКонтрагента)
	
	КПП = "";
	
	Если ДанныеКонтрагента <> Неопределено Тогда
		Если ДанныеКонтрагента.Свойство("КПП") Тогда
			КПП = ДанныеКонтрагента.КПП;
		КонецЕсли;
	КонецЕсли;
	
	Возврат КПП;
	
КонецФункции

Функция ДатаИзСтроки(ДатаДляПреобразования)
	
	Результат = Дата(1,1,1);
	
	Если ДатаЗаполнена(ДатаДляПреобразования) Тогда
		
		Год 	= Прав(ДатаДляПреобразования, 4);
		Месяц 	= Сред(ДатаДляПреобразования, 4, 2);
		Число	= Лев(ДатаДляПреобразования, 2);
		
		Результат = Дата(Год + Месяц + Число);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ДатаЗаполнена(Дата)
	
	Возврат Дата <> "Нет даты" 
		И Дата <> Дата(1,1,1) 
		И ЗначениеЗаполнено(Дата);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область Вспомогательные

Функция ПараметрыФоновогоЗадания(Форма, Знач ДополнительныеПараметры)
	
	Если Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоДекларацияПоНДС") Тогда
		
		Параметры = ОпределитьПараметрыФоновогоЗаданияДекларацияПоНДС(Форма, ДополнительныеПараметры);
		
	Иначе
		
		Параметры = ОпределитьПараметрыФоновогоЗаданияОтчетовПоНДС(Форма, ДополнительныеПараметры);
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

Функция ОпределитьПараметрыФоновогоЗаданияДекларацияПоНДС(Форма, Знач Параметры)
	
	Параметры.Вставить("Заголовок", 			Форма.Заголовок);
	Параметры.Вставить("ДекларацияНДС", 		Форма.СтруктураРеквизитовФормы.мСохраненныйДок);
	Параметры.Вставить("ЭтоДекларацияПоНДС", 	Истина);
	
	// Формируем список сегментов разделов с данными
	СтраницыРазделов = Новый Структура;
	
	Разделы = ПроверкаКонтрагентовБРОКлиентСервер.ПроверяемыеРазделыДекларацииПоНДС();
	
	НачальныйРаздел = Разделы.Начальный;
	КонечныйРаздел 	= Разделы.Конечный;
	
	Для НомерРаздела = НачальныйРаздел По КонечныйРаздел Цикл
		
		Ключ = "СтраницыРаздел" + Формат(НомерРаздела, "ЧГ=0");
		СтраницыРазделов.Вставить(Ключ, ДанныеФормыВЗначение(Форма[Ключ], Тип("ТаблицаЗначений")));
	
	КонецЦикла;

	Параметры.Вставить("СтраницыРазделов", СтраницыРазделов);
		
	Возврат Параметры;
	
КонецФункции

Функция ОпределитьПараметрыФоновогоЗаданияОтчетовПоНДС(Форма, Знач Параметры)
	
	Параметры.Вставить("Заголовок", Форма.Заголовок);
	АдресРезультатаЗаполненияОтчета = Параметры.АдресРезультатаЗаполненияОтчета;
	
	Если ЭтоАдресВременногоХранилища(АдресРезультатаЗаполненияОтчета) Тогда
		
		РезультатЗаполненияОтчета = ПолучитьИзВременногоХранилища(АдресРезультатаЗаполненияОтчета);
		
		Если РезультатЗаполненияОтчета.Свойство("ДанныеДляПроверкиКонтрагентов")
			И РезультатЗаполненияОтчета.ДанныеДляПроверкиКонтрагентов.Свойство("НедействующиеКонтрагенты") Тогда
		
			Параметры.Вставить("ВсеКонтрагенты",
				РезультатЗаполненияОтчета.ДанныеДляПроверкиКонтрагентов.НедействующиеКонтрагенты);
				
			Параметры.Удалить("АдресРезультатаЗаполненияОтчета");
			
		Иначе
			Параметры = Неопределено;
		КонецЕсли;
		
	Иначе
		Параметры = Неопределено;
	КонецЕсли;

	Возврат Параметры;

КонецФункции

Функция ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.РаботаСКонтрагентами") Тогда
		Возврат ОбщегоНазначения.ОбщийМодуль("ПроверкаКонтрагентовБРОПереопределяемый");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция СтандартноеДействиеПриСозданииНаСервереОтчета(Форма)
	
	// Предлагаем заменить стандартное поведение
	Модуль = ОбщийМодульПроверкаКонтрагентовБРОПереопределяемый();
	Если Модуль <> Неопределено Тогда
		
		СтандартнаяОбработка = Истина; 
		Модуль.ПриСозданииНаСервереДекларацияПоНДС(Форма, СтандартнаяОбработка);
		
		Если НЕ СтандартнаяОбработка Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	// Не позволяем идти дальше, если нет стандартной подсистемы
	Возврат РаботаСКонтрагентамиСуществует();
	
КонецФункции

Процедура ДобавитьКолонкуОбластьДанных(Таблица)
	
	Таблица.Колонки.Добавить("ОбластьДанныхВспомогательныеДанные", 	Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(7, 0, ДопустимыйЗнак.Неотрицательный)));
	
КонецПроцедуры

Процедура ЗаполнитьСостояния(ПроверяемыеКонтрагенты, ДанныеКонтрагентов, Состояния = Неопределено)
	
	// Соединяем результаты проверки с исходной таблицей.
	Запрос = Новый Запрос;
	Если ПроверяемыеКонтрагенты.Колонки.Найти("Состояние") <> Неопределено Тогда
		ПроверяемыеКонтрагенты.Колонки.Удалить("Состояние");
	КонецЕсли;
	
	ПоместитьТаблицуЗначенийВоВременнуюТаблицу(ПроверяемыеКонтрагенты, Запрос, "ПроверяемыеКонтрагенты", ,"ДополнительныеПараметры");
	ПоместитьТаблицуЗначенийВоВременнуюТаблицу(ДанныеКонтрагентов, 	Запрос, "ДанныеКонтрагентов", ,"ДополнительныеПараметры");
	
	// По всем контрагентам определяем состояние.
	// В таблице оставляем только контрагентов с ошибками.
	Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		| 	" + ПредставлениеКолонок(ПроверяемыеКонтрагенты, "ПроверяемыеКонтрагенты.",, "ДополнительныеПараметры") + ", 
		| 	ДанныеКонтрагентов.Состояние КАК Состояние
		|ИЗ 
		|	ПроверяемыеКонтрагенты КАК ПроверяемыеКонтрагенты
		|	ЛЕВОЕ СОЕДИНЕНИЕ ДанныеКонтрагентов КАК ДанныеКонтрагентов
		|	ПО ПроверяемыеКонтрагенты.Контрагент = ДанныеКонтрагентов.Контрагент
		|		И ПроверяемыеКонтрагенты.ИНН = ДанныеКонтрагентов.ИНН
		|		И ПроверяемыеКонтрагенты.КПП = ДанныеКонтрагентов.КПП
		|		И (НАЧАЛОПЕРИОДА(ПроверяемыеКонтрагенты.Дата, День) = НАЧАЛОПЕРИОДА(ДанныеКонтрагентов.Дата, День)
		|		ИЛИ НАЧАЛОПЕРИОДА(ПроверяемыеКонтрагенты.Дата, День) = ДатаВремя(1,1,1))";
		
	Если Состояния <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + "
			|
			|ГДЕ
			|	ДанныеКонтрагентов.Состояние В (&Состояния)";
		
		Запрос.УстановитьПараметр("Состояния", Состояния);
	КонецЕсли;
		
	ПроверяемыеКонтрагенты = Запрос.Выполнить().Выгрузить();
	ПроверяемыеКонтрагенты.Колонки.Добавить("ДополнительныеПараметры", Новый ОписаниеТипов("Структура"));
	
КонецПроцедуры

Процедура ПоместитьТаблицуЗначенийВоВременнуюТаблицу(Таблица, Запрос, ИмяВременнойТаблицы, ПостфиксСинонима = "", ИсключаяКолонки = "")
	
	ПредставлениеКолонок = ПредставлениеКолонок(Таблица, , , ИсключаяКолонки);
	
	Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ 
		| " + ПредставлениеКолонок + "
		| ПОМЕСТИТЬ " + ИмяВременнойТаблицы + "
		| ИЗ &" + ИмяВременнойТаблицы + " КАК " + ИмяВременнойТаблицы + ";
		|//////////////////////////////////////////////////////////////////////////////////////////////////";
	
	Запрос.УстановитьПараметр(ИмяВременнойТаблицы, Таблица);
	
КонецПроцедуры

Функция ПредставлениеКолонок(Таблица, СинонимТаблицы = "", ПостфиксСинонима = "", ИсключаяКолонки = "")
	
	МассивКолонокКИсключению = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИсключаяКолонки, ",", Истина, Истина);
	
	КолонкиИсходнойТаблицы = Новый Массив;
	Для Каждого Колонка Из Таблица.Колонки Цикл
		
		Если МассивКолонокКИсключению.Найти(Колонка.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяПоля     = СинонимТаблицы + Колонка.Имя;
		СинонимПоля = Колонка.Имя + ПостфиксСинонима;
		
		КолонкиИсходнойТаблицы.Добавить(ИмяПоля + " КАК " + СинонимПоля);
		
	КонецЦикла;
	
	ПредставлениеКолонок = СтрСоединить(КолонкиИсходнойТаблицы, "," + Символы.ПС);
	Возврат ПредставлениеКолонок;
	
КонецФункции
	
#КонецОбласти

#КонецОбласти