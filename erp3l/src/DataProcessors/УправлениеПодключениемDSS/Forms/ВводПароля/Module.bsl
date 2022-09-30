///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

&НаКлиенте
Перем ПрограммноеЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// предусмотрено два режима: ПинКод и ПарольПользователя
	РежимВвода = Параметры.РежимВвода;
	МобильныйКлиент = ОбщегоНазначения.ЭтоМобильныйКлиент();
	НастройкиПользователя = Параметры.НастройкиПользователя;
	ВозможноСохранять = Параметры.ВозможноСохранять;
	Логин = Параметры.Логин;
	СкрыватьПароль = СервисКриптографииDSSСлужебный.НужнаяВерсияПлатформы("8.3.19.0");
	
	НастроитьУсловноеОформление();
	ПодготовитьФорму(Параметры);
	УправлениеФормой(ЭтотОбъект);
	       
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СервисКриптографииDSSСлужебныйКлиент.ПриОткрытииФормы(ЭтотОбъект, ПрограммноеЗакрытие);
	ПодключитьОбработчикОжидания("ОбновитьРазмерыФормы", 0.2, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если СервисКриптографииDSSСлужебныйКлиент.ПередЗакрытиемФормы(
			ЭтотОбъект,
			Отказ,
			ПрограммноеЗакрытие,
			ЗавершениеРаботы) Тогда
		ЗакрытьФорму(РезультатРаботы(Ложь));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьВидимостьЭлемента("Пароль");
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеСледующее 	= Новый ОписаниеОповещения("ВыбратьСертификатПослеПолучения", ЭтотОбъект);
	ПараметрыОперации	= СервисКриптографииDSSСлужебныйКлиент.ПодготовитьПараметрыОперации();
	СервисКриптографииDSSКлиент.ЗагрузитьДанныеИзФайла(ОписаниеСледующее, ".pfx", , Истина, ПараметрыОперации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	
	ЗакрытьФорму(РезультатРаботы(Ложь));
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ПодтвердитьПароль();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьРазмерыФормы()
	
	Элементы.ЗаголовокФормы.Видимость = НЕ Элементы.ЗаголовокФормы.Видимость;
	Элементы.ЗаголовокФормы.Видимость = НЕ Элементы.ЗаголовокФормы.Видимость;
	
КонецПроцедуры

&НаКлиенте
Функция РезультатРаботы(Подтвержден = Истина)
	
	ОбъекПароля = ЗакрытьДанныеПользователя(Пароль, Подтвержден);
	
	Результат = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Подтвержден);
	Результат.Вставить("Результат", ОбъекПароля);
	Результат.Вставить("Сохранить", Сохранить);
	Если ДанныеСертификата <> Неопределено Тогда
		Результат.Вставить("СертификатАвторизации", ДанныеСертификата);
	КонецЕсли;
	
	Если НЕ Подтвержден Тогда
		СервисКриптографииDSSСлужебныйКлиент.ПолучитьОписаниеОшибки(Результат, "ОтказПользователя");
	КонецЕсли;

	Возврат Результат;
	
КонецФункции	

&НаКлиенте
Функция ЗакрытьДанныеПользователя(ВведенноеЗначение, Подтвержден) 
	
	Если Подтвержден Тогда
		Результат = СервисКриптографииDSSКлиент.ПодготовитьОбъектПароля(ВведенноеЗначение);
	Иначе
		Результат = СервисКриптографииDSSКлиент.ПодготовитьОбъектПароля(Неопределено);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФорму(РезультатЗакрытия)
	
	ПрограммноеЗакрытие = Истина;
	Закрыть(РезультатЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПароль()
	
	Если РежимВвода = "ПинКод" И НЕ ЗначениеЗаполнено(Пароль) Тогда
		ТекущийЭлемент = Элементы.Пароль;
		Ошибка = Истина;
		ПодключитьОбработчикОжидания("ОтключитьОшибку", 2, Истина);
		
	Иначе
		ЗакрытьФорму(РезультатРаботы(Истина));
		
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтключитьОшибку()
	
	Ошибка = Ложь;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОткрытьВидимостьЭлемента(ИмяЭлемента)
	
	Элементы[ИмяЭлемента].КартинкаКнопкиВыбора = КартинкаОткрыть;
	Элементы[ИмяЭлемента].РежимПароля = Ложь;
	ЭтотОбъект[ИмяЭлемента] = Элементы[ИмяЭлемента].ТекстРедактирования;
	Если СкрыватьПароль Тогда
		ПодключитьОбработчикОжидания("ПодключаемыйОтключитьВидимостьПароля", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключаемыйОтключитьВидимостьПароля()
	
	ЭлементФормы = Элементы["Пароль"];
	Если ЭлементФормы.РежимПароля <> Истина Тогда
		ЭлементФормы.РежимПароля = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСертификатПослеПолучения(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	Если РезультатВызова.Выполнено Тогда
		ДанныеСертификата = РезультатВызова.Результат.ДанныеФайла;
		УправлениеФормой(ЭтотОбъект);
		ТекущийЭлемент = Элементы.Пароль;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФорму(ПараметрыФормы)
	
	КодЯзыка = СервисКриптографииDSSСлужебный.КодЯзыка();
	
	Заголовок = НСтр("ru = 'Введите пароль';
					|en = 'Enter your password'", КодЯзыка);
	Элементы.Пароль.Заголовок = НСтр("ru = 'Пароль';
									|en = 'Password'", КодЯзыка);
	
	Если РежимВвода = "ПинКод" Тогда
		ЗаголовокФормы = НСтр("ru = 'Введите пароль для доступа к файлу сертификата авторизации';
								|en = 'Type your password to access the authorization certificate file'", КодЯзыка);
	Иначе	
		ЗаголовокФормы = НСтр("ru = 'Введите пароль для авторизации на сервере DSS';
								|en = 'Enter the password to authorize on the DSS server'", КодЯзыка);
		Элементы.ПредставлениеСертификата.Видимость = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыФормы.ПояснениеОперации) Тогда
		ЗаголовокФормы = ПараметрыФормы.ПояснениеОперации;
	КонецЕсли;
	
	Элементы.ЗаголовокФормы.Заголовок = ЗаголовокФормы;
	
	КартинкаОткрыть = БиблиотекаКартинок.ВидимостьПароляОткрыто;
	КартинкаЗакрыть = БиблиотекаКартинок.ВидимостьПароляЗакрыто;
	
	Сохранить = ВозможноСохранять = "Обязательно";

	Элементы.Пароль.КартинкаКнопкиВыбора = КартинкаЗакрыть;
	
	Если НастройкиПользователя <> Неопределено Тогда
		//@skip-warning
		Сервер = СервисКриптографииDSSКлиентСервер.ПолучитьПолеСтруктуры(НастройкиПользователя.Подключение, "Сервер", "");
		Логин = НастройкиПользователя.Логин;
		КоличествоПопыток = НастройкиПользователя.НеудачныхПопыток;
	КонецЕсли;
	
	Если КоличествоПопыток > 0 Тогда
		ТекстЗаголовка = НСтр("ru = 'Количество неудачных попыток: %1';
								|en = 'Number of failed attempts: %1'", КодЯзыка); 
		Элементы.Пароль.РасширеннаяПодсказка.Заголовок = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоПопыток);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура НастроитьУсловноеОформление()
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("BackColor");
	ЭлементЦветаОформления.Значение = ЦветаСтиля.ЦветФонаПредупреждения;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ОтметкаНезаполненного");
	ЭлементЦветаОформления.Значение = Истина;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Ошибка");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("Пароль");
	ЭлементОформляемогоПоля.Использование = Истина;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(УправляемаяФорма)
	
	ВозможноСохранять = УправляемаяФорма.ВозможноСохранять;
	ЕстьСертификат = Ложь;
	
	ЭлементФормы = УправляемаяФорма.Элементы;
	ЭлементФормы.Сохранить.Видимость = ВозможноСохранять = "Опционально" ИЛИ ВозможноСохранять = "Обязательно";
	ЭлементФормы.Сохранить.Доступность = ВозможноСохранять = "Опционально";
	ЭлементФормы.Сервер.Видимость = ЗначениеЗаполнено(УправляемаяФорма.Сервер);
	ЭлементФормы.Логин.Видимость = ЗначениеЗаполнено(УправляемаяФорма.Логин);
	
	Если УправляемаяФорма.НастройкиПользователя <> Неопределено Тогда
		ЕстьСертификат = УправляемаяФорма.НастройкиПользователя.СертификатАвторизации ИЛИ УправляемаяФорма.ДанныеСертификата <> Неопределено;
	КонецЕсли;
	
	УправляемаяФорма.ПредставлениеСертификата = ?(ЕстьСертификат, 
							НСтр("ru = 'Загружен';
								|en = 'Imported'"), 
							НСтр("ru = 'Загрузите файл сертификата';
								|en = 'Import certificate file'"));
	ЭлементФормы.ПредставлениеСертификата.Доступность = НЕ УправляемаяФорма.МобильныйКлиент;
	
КонецПроцедуры

#КонецОбласти