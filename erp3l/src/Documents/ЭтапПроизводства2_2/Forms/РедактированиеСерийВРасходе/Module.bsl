
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СписокРеквизитов = "Ссылка, Подразделение, ДатаРасхода, Назначение, РасходОднойДатой";
	СтруктураОбъекта = Новый Структура(СписокРеквизитов);
	
	Если Параметры.Свойство("Ссылка") Тогда
		ЗаполнитьЗначенияСвойств(СтруктураОбъекта, Параметры, "Ссылка");
	КонецЕсли;
	
	Если Параметры.Свойство("АдресМатериалыДляСерий") Тогда
		АдресМатериалыДляСерий = Параметры.АдресМатериалыДляСерий;
	КонецЕсли;
	ПолучитьМатериалыДляУказанияСерийИзВременногоХранилища();
	
	Если Параметры.Свойство("ПараметрыУказанияСерий") Тогда
		ПараметрыУказанияСерий = ОбщегоНазначения.СкопироватьРекурсивно(Параметры.ПараметрыУказанияСерий);
		ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта = "СтруктураОбъекта";
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		СтруктураОбъекта.Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаРасхода") Тогда
		СтруктураОбъекта.ДатаРасхода = Параметры.ДатаРасхода;
	КонецЕсли;
	
	Если Параметры.Свойство("Назначение") Тогда
		СтруктураОбъекта.Назначение = Параметры.Назначение;
	КонецЕсли;
	
	Если Параметры.Свойство("РасходОднойДатой") Тогда
		СтруктураОбъекта.РасходОднойДатой = Параметры.РасходОднойДатой;
	КонецЕсли;
	
	Если Параметры.Свойство("СостояниеСерий") Тогда
		СостояниеСерий = Параметры.СостояниеСерий;
		УстановитьОтборПоСтатусуСерий(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтаФорма, ПараметрыУказанияСерий, Отказ, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеСерийПриИзменении(Элемент)
	
	УстановитьОтборПоСтатусуСерий(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеСерийОчистка(Элемент, СтандартнаяОбработка)
	
	УстановитьОтборПоСтатусуСерий(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасходМатериаловИРабот

&НаКлиенте
Процедура РасходМатериаловИРаботСерияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.РасходМатериаловИРабот.ТекущиеДанные;
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение            		 = ТекущиеДанные.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущиеДанные.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходМатериаловИРаботСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПоместитьМатериалыДляУказанияСерийВХранилище();
		Закрыть(КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	ПараметрыРазбиенияСтроки = РаботаСТабличнымиЧастямиКлиент.ПараметрыРазбиенияСтроки();
	ПараметрыРазбиенияСтроки.РазрешитьНулевоеКоличество = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуТЧЗавершение", ЭтотОбъект);
	РаботаСТабличнымиЧастямиКлиент.РазбитьСтроку(РасходМатериаловИРабот, Элементы.РасходМатериаловИРабот, Оповещение,
		ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область СтандартноеОформление
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, 
		"РасходМатериаловИРаботНоменклатураЕдиницаИзмерения", 
		"РасходМатериаловИРабот.Упаковка");
		
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтаФорма, 
		"РасходМатериаловИРаботХарактеристика",
		"РасходМатериаловИРабот.ХарактеристикиИспользуются");
		
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтаФорма,
		"СерииВсегдаВТЧТовары",
		"РасходМатериаловИРаботСерия",
		"РасходМатериаловИРабот.СтатусУказанияСерий",
		"РасходМатериаловИРабот.ТипНоменклатуры");
	
	#КонецОбласти
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.Добавить(1);
	СписокСтатусов.Добавить(13);
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	НовыйЭлемент = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	НовыйЭлемент.Поле = Новый ПолеКомпоновкиДанных(Элементы.РасходМатериаловИРаботСерия.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РасходМатериаловИРабот.СтатусУказанияСерий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусуСерий(Форма)
	
	ЭлементТаблицаРасход = Форма.Элементы.РасходМатериаловИРабот;
	
	Если Форма.СостояниеСерий = "1" Тогда
		СтруктураОтбора = Новый ФиксированнаяСтруктура("СтатусУказанияСерий", 1);
		ЭлементТаблицаРасход.ОтборСтрок = СтруктураОтбора;
	Иначе
		СтруктураОтбора = Новый ФиксированнаяСтруктура("СтатусУказанияСерий", 2);
		ЭлементТаблицаРасход.ОтборСтрок = СтруктураОтбора;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиКомандФормыСлужебные

&НаКлиенте
Процедура РазбитьСтрокуТЧЗавершение(НоваяСтрока, ДополнительныеПараметры) Экспорт 
	
	Если НоваяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.РасходМатериаловИРабот.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПроизводствоКлиентСервер.ПараметрыПересчетаКоличестваЕдиниц());
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущиеДанные, СтруктураДействий, КэшированныеЗначения);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ТекущиеДанные.ПолучитьИдентификатор());
	МассивСтрок.Добавить(НоваяСтрока.ПолучитьИдентификатор());
	ПослеИзмененияСтрокТЧПрограммноНаСервере(МассивСтрок, СтруктураДействий);

КонецПроцедуры

#КонецОбласти

#Область Серии

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	
	НуженСерверныйВызов = НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(
							ЭтаФорма,
							ПараметрыУказанияСерий,
							Текст,
							ТекущиеДанные);
	
	Если НуженСерверныйВызов Тогда
		
		Если ТекущиеДанные = Неопределено Тогда
			ТекущиеДанныеИдентификатор = Элементы.РасходМатериаловИРабот.ТекущиеДанные.ПолучитьИдентификатор();
		Иначе
			ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		КонецЕсли;
		
		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		ДополнительныеПараметры = Новый Структура("ПараметрыУказанияСерий,ПараметрыФормыУказанияСерий", 
											ПараметрыУказанияСерий, ПараметрыФормыУказанияСерий);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,
					ПараметрыФормыУказанияСерий,
					ЭтаФорма,,,,
					ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		ОбработатьУказаниеСерийСервер(
				ДополнительныеПараметры.ПараметрыУказанияСерий,
				ДополнительныеПараметры.ПараметрыФормыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(Знач ПараметрыУказанияСерий, Знач ПараметрыФормыУказанияСерий)
	
	НоменклатураСервер.ОбработатьУказаниеСерий(
		ЭтаФорма,
		ПараметрыУказанияСерий,
		ПараметрыФормыУказанияСерий,
		Неопределено);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(
		ЭтаФорма,
		ПараметрыУказанияСерий,
		ТекущиеДанныеИдентификатор,
		ЭтаФорма);
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТабличныхЧастей(СтрокиЗаполнения = Неопределено)
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
		
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(
		РасходМатериаловИРабот,
		СтруктураДействий,
		СтрокиЗаполнения);
	
КонецПроцедуры

// Процедуру следует использовать, если строки были добавлены программно (не интерактивно), при разбиении строк.
// Процедура выполняет действия которые зависят от данных в строках.
//
&НаСервере
Процедура ПослеИзмененияСтрокТЧПрограммноНаСервере(МассивИдентификаторовСтрок = Неопределено, СтруктураРанееВыполненныхДействий = Неопределено)

	МассивСтрок = Неопределено;
	КоллекцияСтрок = РасходМатериаловИРабот;
	Если МассивИдентификаторовСтрок <> Неопределено Тогда
		МассивСтрок = Новый Массив;
		Для каждого ИдентификаторСтроки Из МассивИдентификаторовСтрок Цикл
			МассивСтрок.Добавить(РасходМатериаловИРабот.НайтиПоИдентификатору(ИдентификаторСтроки));
		КонецЦикла;
		КоллекцияСтрок = МассивСтрок;
	КонецЕсли;
	
	Если СтруктураРанееВыполненныхДействий = Неопределено Тогда
		СтруктураРанееВыполненныхДействий = Новый Структура;
	КонецЕсли;
	
	Если НЕ СтруктураРанееВыполненныхДействий.Свойство("ЗаполнитьПризнакХарактеристикиИспользуются")
		ИЛИ НЕ СтруктураРанееВыполненныхДействий.Свойство("ЗаполнитьПризнакАртикул")
		ИЛИ НЕ СтруктураРанееВыполненныхДействий.Свойство("ЗаполнитьПризнакТипНоменклатуры") Тогда
		ЗаполнитьСлужебныеРеквизитыТабличныхЧастей(МассивСтрок);
	КонецЕсли;
	
	Для каждого ТекущиеДанные Из КоллекцияСтрок Цикл
		Если СтруктураОбъекта.РасходОднойДатой И СтруктураОбъекта.ДатаРасхода <> '000101010000' Тогда
			ТекущиеДанные.ДатаРасхода = СтруктураОбъекта.ДатаРасхода;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПоместитьМатериалыДляУказанияСерийВХранилище()
	
	Таблица = РасходМатериаловИРабот.Выгрузить();
	Если ЭтоАдресВременногоХранилища(АдресМатериалыДляСерий) Тогда
		ПоместитьВоВременноеХранилище(Таблица, АдресМатериалыДляСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьМатериалыДляУказанияСерийИзВременногоХранилища()
	
	Если ЭтоАдресВременногоХранилища(АдресМатериалыДляСерий) Тогда
		Таблица = ПолучитьИзВременногоХранилища(АдресМатериалыДляСерий);
		РасходМатериаловИРабот.Загрузить(Таблица);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
