#Область ОписаниеПеременных

&НаКлиенте
Перем СтарыеЗначенияКонтролируемыхПолей;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РаботаВБюджетномУчреждении = ПолучитьФункциональнуюОпцию("РаботаВБюджетномУчреждении");
	ИспользоватьСтатьиФинансирования = ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата");
	Если Параметры.ОписаниеДокумента.Свойство("НеРаспределятьПоСтатьямФинансирования")
		И Параметры.ОписаниеДокумента.НеРаспределятьПоСтатьямФинансирования = Истина Тогда
		ИспользоватьСтатьиФинансирования = Ложь;
	КонецЕсли;

	Элементы.ГруппаКнопокПросмотр.Видимость			= ТолькоПросмотр;
	Элементы.ГруппаКнопокРедактирование.Видимость	= Не ТолькоПросмотр;
	Если ТолькоПросмотр Тогда
		Элементы.ФормаЗакрыть.КнопкаПоУмолчанию	= Истина;
	Иначе
		Элементы.ФормаОК.КнопкаПоУмолчанию		= Истина;
	КонецЕсли;
	
	ИмяДокумента = Параметры.ИмяДокумента;
	ОписаниеДокумента = Новый ФиксированнаяСтруктура(Параметры.ОписаниеДокумента);
	
	РеквизитОбъект = Новый РеквизитФормы("Объект", Новый ОписаниеТипов("ДокументОбъект." + ИмяДокумента));
	РеквизитОбъект.СохраняемыеДанные = Истина;
	ИзменитьРеквизиты(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитОбъект));
	
	ДокОбъект = ДанныеФормыВЗначение(Параметры.Объект, Тип("ДокументОбъект." + ИмяДокумента));
	ЗначениеВДанныеФормы(ДокОбъект, ЭтотОбъект["Объект"]);
	
	ЕдинственныйСотрудник = ДокОбъект.Метаданные().Реквизиты.Найти("ФизическоеЛицо") <> Неопределено;
	Если ЕдинственныйСотрудник Тогда
		ФизическоеЛицо = ДокОбъект.ФизическоеЛицо;
	КонецЕсли;
	
	ОписаниеТаблицыУдержаний = ОписаниеТаблицыУдержаний(ОписаниеДокумента);
	РасчетЗарплатыРасширенныйФормы.ДокументыВыполненияНачисленийДополнитьФорму(ЭтотОбъект, ОписаниеТаблицыУдержаний, "Удержания");
	РасчетЗарплатыРасширенныйКлиентСервер.ДокументыВыполненияНачисленийУстановитьРежимОтображенияПодробно(ЭтотОбъект, Ложь, ОписаниеТаблицыУдержаний);
	Если ИспользоватьСтатьиФинансирования Тогда
		РасчетЗарплатыРасширенныйФормы.ДокументыНачисленийДополнитьФормуРезультатыРаспределения(ЭтотОбъект, ОписанияТаблицДляРаспределенияРезультата());
	КонецЕсли;
	
	Удержания.Загрузить(Параметры.Объект.Удержания.Выгрузить());
	Удержания.Сортировать("ФизическоеЛицо,Удержание,ДатаНачала");
	
	Элементы.УдержанияФизическоеЛицо.Видимость = Не ЕдинственныйСотрудник;
	
	Если ЕдинственныйСотрудник Тогда
		Сотрудники = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	Иначе
		Сотрудники = ОбщегоНазначения.ВыгрузитьКолонку(Удержания, "ФизическоеЛицо", Истина);
	КонецЕсли;
	
	Организация = ДокОбъект.Организация;
	ОтборПоОрганизации	= Новый ПараметрВыбора("Отбор.Организация",	ДокОбъект.Организация);
	ОтборПоСотрудникам	= Новый ПараметрВыбора("Отбор.Ссылка",		Новый ФиксированныйМассив(Сотрудники));
	
	МассивПараметровВыбора = Новый Массив;
	МассивПараметровВыбора.Добавить(ОтборПоОрганизации);
	МассивПараметровВыбора.Добавить(ОтборПоСотрудникам);
	
	Элементы.УдержанияФизическоеЛицо.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	Если ЗначениеЗаполнено(ОписаниеДокумента.ПогашениеЗаймовИмя) И ПолучитьФункциональнуюОпцию("ИспользоватьЗаймыСотрудникам") Тогда
		ПогашениеЗаймов.Загрузить(Параметры.Объект.ПогашениеЗаймов.Выгрузить());
	Иначе 
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ПогашениеЗаймовГруппа", "Видимость", Ложь);
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "УдержанияГруппа", "ОтображатьЗаголовок", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОписанияТаблицДляРаспределенияРезультата()

	ОписанияТаблиц = Новый Массив;
	ОписанияТаблиц.Добавить(ОписаниеТаблицыУдержаний(ОписаниеДокумента));
	Если ЗначениеЗаполнено(ОписаниеДокумента.ПогашениеЗаймовИмя) Тогда
		ОписанияТаблиц.Добавить(ОписаниеТаблицыПогашениеЗаймов());
	КонецЕсли;	
	Возврат ОписанияТаблиц;

КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУдержания

&НаКлиенте
Процедура УдержанияПриАктивизацииСтроки(Элемент)
	РасчетЗарплатыРасширенныйКлиент.ДокументыВыполненияНачисленийПриАктивацииСтроки(ЭтотОбъект, "Удержания", Истина);
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если ЕдинственныйСотрудник 
		И ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		
		Элементы.Удержания.ТекущиеДанные.ФизическоеЛицо = ФизическоеЛицо;
	КонецЕсли;
	
	РасчетЗарплатыКлиент.СтрокаРасчетаПриНачалеРедактирования(ЭтотОбъект, "Удержания", Элементы.Удержания.ТекущиеДанные, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	РасчетЗарплатыРасширенныйКлиент.ДобавитьИзмененныеДанные(ИзмененныеДанные, "Удержания", ТекущиеДанные.ФизическоеЛицо, , ТекущиеДанные.Удержание);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ИспользоватьСтатьиФинансирования И ТекущиеДанные <> Неопределено Тогда
		ОтражениеЗарплатыВБухучетеКлиентСерверРасширенный.ПерераспределитьУдержания(ТекущиеДанные, РаботаВБюджетномУчреждении);
	КонецЕсли;
	
	РасчетЗарплатыКлиент.СтрокаРасчетаПриОкончанииРедактирования(ЭтотОбъект, ОписаниеТаблицыУдержаний(ОписаниеДокумента), Ложь, Ложь);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПослеУдаления(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияУдержаниеПриИзменении(Элемент)
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыУдержаний(ОписаниеДокумента);
	ЗарплатаКадрыРасширенныйКлиент.ВводНачисленийНачислениеПриИзменении(ЭтотОбъект, ОписаниеТаблицыВидовРасчета, 2);
КонецПроцедуры

&НаКлиенте
Процедура УдержанияДокументОснованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаДокументаУдержанияПоКатегории(
		Элемент, Элементы.Удержания.ТекущиеДанные, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдержанияОтменитьИсправление(Команда)
	
	РасчетЗарплатыКлиент.ОтменитьИсправление(ЭтотОбъект, ОписаниеТаблицыУдержаний(ОписаниеДокумента));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдержанияОтменитьВсеИсправления(Команда)
	
	РасчетЗарплатыКлиент.ОтменитьВсеИсправления(ЭтотОбъект, ОписаниеТаблицыУдержаний(ОписаниеДокумента));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПогашениеЗаймов

&НаКлиенте
Процедура ПогашениеЗаймовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если СтрНайти(Поле.Имя, "КомандаРедактированияРаспределения") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияРезультатовРаспределенияПоИсточникамФинансирования(
		ЭтотОбъект, 
		ОписаниеТаблицыПогашениеЗаймов(), 
		ВыбраннаяСтрока, 
		ЭтотОбъект["Объект"][ОписаниеДокумента.МесяцНачисленияИмя]);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеЗаймовПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	РасчетЗарплатыРасширенныйКлиент.ДобавитьИзмененныеДанные(ИзмененныеДанные, "ПогашениеЗаймов", ТекущиеДанные.ФизическоеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеЗаймовПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	РасчетЗарплатыРасширенныйКлиент.ДобавитьИзмененныеДанные(ИзмененныеДанные, "ПогашениеЗаймов", ТекущиеДанные.ФизическоеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеЗаймовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ИспользоватьСтатьиФинансирования И ТекущиеДанные <> Неопределено Тогда
		ОтражениеЗарплатыВБухучетеКлиентСерверРасширенный.ПерераспределитьПогашениеЗаймов(ТекущиеДанные, РаботаВБюджетномУчреждении);
	КонецЕсли;
	
	Если ЕдинственныйСотрудник 
		И ЗначениеЗаполнено(ФизическоеЛицо)
		И ТекущиеДанные <> Неопределено Тогда
		
		ТекущиеДанные.ФизическоеЛицо = ФизическоеЛицо;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПогашениеЗаймовПослеУдаления(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	РезультатФормы = РезультатФормы();
	
	// Широковещательное оповещение для обратной совместимости.
	Если РезультатФормы <> Неопределено И ОписаниеОповещенияОЗакрытии = Неопределено Тогда
		Оповестить("ИзмененыРезультатыРасчетаУдержаний", РезультатФормы, ЭтотОбъект);
	КонецЕсли;
	
	ОповеститьОВыборе(РезультатФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПодробно(Команда)
	
	РасчетЗарплатыРасширенныйКлиентСервер.ДокументыВыполненияНачисленийУстановитьРежимОтображенияПодробно(
		ЭтотОбъект, 
		Не Элементы.УдержанияПодробно.Пометка, 
		ОписаниеТаблицыУдержаний(ОписаниеДокумента));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыУдержаний(ОписаниеДокумента)
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	Описание.ИмяРеквизитаВидРасчета       = "Удержание";
	Описание.ИмяТаблицы                   = "Удержания";
	Описание.ПутьКДанным                  = "Удержания";
	Описание.ПутьКДаннымПоказателей       = "Показатели";
	Описание.ИмяПоляДляВставкиПоказателей = "УдержанияРезультат";
	Описание.ИмяРеквизитаПериод           = ОписаниеДокумента.МесяцНачисленияИмя;
	Описание.НомерТаблицы                 = 2;
	Описание.СодержитПолеСотрудник        = Истина;
	Описание.ИмяРеквизитаСотрудник        = "ФизическоеЛицо";
	Описание.ПутьКДаннымРаспределениеРезультатов       = "Объект.РаспределениеРезультатовУдержаний";
	Описание.ИмяПоляДляВставкиРаспределенияРезультатов = "ДатыУдержания";
	
	Возврат Описание;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыПогашениеЗаймов()
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "ПогашениеЗаймов";
	ОписаниеТаблицы.ПутьКДанным = "ПогашениеЗаймов";
	ОписаниеТаблицы.СодержитПолеВидРасчета = Ложь;
	ОписаниеТаблицы.НомерТаблицы = 5;
	ОписаниеТаблицы.ПутьКДаннымРаспределениеРезультатов = "Объект.РаспределениеРезультатовУдержаний";
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "ФизическоеЛицо";
	
	ОписаниеТаблицы.ИмяРеквизитаИдентификаторСтроки = "ИдентификаторСтроки";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов = Истина;
	ОписаниеТаблицы.УстанавливатьИдентификаторСтрокиРаспределенияРезультата = Истина;
	
	ОписаниеТаблицы.ОтменятьВсеИсправления	= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

&НаСервере
Функция ПолучитьКонтролируемыеПоля() Экспорт
	
	УдержанияФиксРасчет = Новый Массив;
	УдержанияФиксРасчет.Добавить("Результат");
	
	СтруктураФикс = Новый Структура("ФиксРасчет, ФиксЗаполнение", УдержанияФиксРасчет, Новый Массив);
	
	КонтролируемыеПоля = Новый Структура("Удержания", СтруктураФикс);
	Возврат КонтролируемыеПоля;
	
КонецФункции

&НаКлиенте
Функция ПолучитьСтарыеЗначенияКонтролируемыхПолей() Экспорт
	Возврат СтарыеЗначенияКонтролируемыхПолей;
КонецФункции

&НаКлиенте
Функция РезультатФормы()
	Если Модифицированность Тогда
		Возврат ПоместитьИзмененныеДанныеВоВременноеХранилище();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПоместитьИзмененныеДанныеВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(Новый Структура("Удержания, ПогашениеЗаймов, ИзмененныеДанные", Удержания, ПогашениеЗаймов, ИзмененныеДанные), УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура ПерезаполнитьНачисленияСотрудника(Сотрудники, СохранятьИсправления = Истина) Экспорт
	
	ВладелецФормы.ПерезаполнитьНачисленияСотрудника(Сотрудники, СохранятьИсправления);
	ЗарплатаКадрыКлиент.ПодключитьОбработчикОжиданияОбработкиСобытия(ЭтотОбъект, "ПерезаполнитьФормуПоОбъекту");
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если СтрНайти(Поле.Имя, "КомандаРедактированияРаспределения") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияРезультатовРаспределенияПоИсточникамФинансирования(
		ЭтотОбъект, 
		ОписаниеТаблицыУдержаний(ОписаниеДокумента), 
		ВыбраннаяСтрока, 
		ЭтотОбъект["Объект"][ОписаниеДокумента.МесяцНачисленияИмя], 
		Организация);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьФормуПоОбъекту()
	
	ЗаполнитьФормуНаСервере(ВладелецФормы.СведенияОбУдержаниях());
		 
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуНаСервере(Знач СведенияОбУдержаниях)
	
	ТабличныеЧастиУдержания = ПолучитьИзВременногоХранилища(СведенияОбУдержаниях);
			
	// Заполнение табличных частей.
	Для каждого ОписаниеТабличнойЧасти Из ТабличныеЧастиУдержания Цикл
		ЭтотОбъект[ОписаниеТабличнойЧасти.Ключ].Загрузить(ОписаниеТабличнойЧасти.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УдержанияПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	РасчетЗарплатыРасширенныйКлиент.ДобавитьИзмененныеДанные(ИзмененныеДанные, "Удержания", ТекущиеДанные.ФизическоеЛицо, , ТекущиеДанные.Удержание);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

СтарыеЗначенияКонтролируемыхПолей = Новый Соответствие;

#КонецОбласти