///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УчетнаяЗапись 			= Параметры.УчетнаяЗапись;
	СостояниеЗаявления		= Параметры.СостояниеЗаявления;
	ОбновитьАвтоматически	= Параметры.ОбновитьАвтоматически;
	РежимВвода				= Параметры.РежимВвода;
	ДоступныеРазделы		= ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ДоступныеРазделы", Новый Массив);
	
	Если РежимВвода Тогда
		ВсеРеквизиты = ПолучитьДанныеЗаявления(Параметры.СодержимоеЗаявления);
	ИначеЕсли СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено Тогда
		ВсеРеквизиты = ПолучитьДанныеЗаявления(Справочники.УчетныеЗаписиDSS.ПустаяСсылка());
		ВсеРеквизиты.СостояниеЗаявления = СостояниеЗаявления;
	Иначе
		ВсеРеквизиты = ПолучитьДанныеЗаявления(УчетнаяЗапись);
	КонецЕсли;
	
	ЗаполнитьФормуДаннымиЗаявления(ВсеРеквизиты);
	
	Если НЕ ЗначениеЗаполнено(СостояниеЗаявления) Тогда
		СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено;
	КонецЕсли;
	
	УжеОтправлено = СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Отправлено
					ИЛИ СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Отклонено
					ИЛИ СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.Исполнено;
					
	Если СостояниеЗаявления = Перечисления.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено Тогда
		ПолучитьДанныеИзПредыдущегоЗаявленияНаСертификат();
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ИнтернетПоддержкаПользователейПодключена = МодульИнтернетПоддержкаПользователей.ЗаполненыДанныеАутентификацииПользователяИнтернетПоддержки();
	КонецЕсли;
	
	ПодготовитьОформлениеФормы(ДоступныеРазделы);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Режим_СменаКонтактов Тогда
		
		Если НЕ ЗначениеЗаполнено(Телефон) И НЕ ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
			ПроверяемыеРеквизиты.Добавить("ЭлектроннаяПочта");
			ПроверяемыеРеквизиты.Добавить("Телефон");
			Отказ = Истина;
		КонецЕсли;
		
		Если НЕ ПроверитьЭлектроннуюПочту(ЭлектроннаяПочта) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Некорректно заполнен адрес электронной почты.';
														|en = 'The email address is incorrect.'"), , "ЭлектроннаяПочта", , Отказ)
		КонецЕсли;
		
		Если НЕ ПроверитьНомерТелефона(Телефон) Тогда
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Некорректно заполнен номер телефона.';
														|en = 'The phone number is incorrect.'"), , "Телефон", , Отказ)
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	НастроитьДоступностьЭлементов();
	ПодключитьОбработчикОжидания("Подключаемый_ИзменитьРазмерыФормы", 0.2, Истина);
	
	Если ОбновитьАвтоматически Тогда
		Если СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Подготовлено") Тогда
			ОтправитьЗаявление();
		ИначеЕсли СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Отправлено")
			ИЛИ СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Исполнено") Тогда
			ЗавершитьНастройки();
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность И НЕ ЗавершениеРаботы Тогда
		Отказ = Истина;
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытиеФормы", 0.1, Истина);
	Иначе
		ЗакрытьФорму();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("ИнтернетПоддержкаПодключена") Тогда
		ИнтернетПоддержкаПользователейПодключена = Истина;
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ИнтернетПоддержкаОтключена") Тогда
		ИнтернетПоддержкаПользователейПодключена = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
										
&НаКлиенте
Процедура Режим_СменаПароляПриИзменении(Элемент)
	
	СменаРежима();
	
КонецПроцедуры

&НаКлиенте
Процедура Режим_СменаКлючаМобильногоПриложенияПриИзменении(Элемент)
	
	СменаРежима();
	
КонецПроцедуры

&НаКлиенте
Процедура Режим_ПовторнаяОтправкаКодаАктивацииПриИзменении(Элемент)
	
	СменаРежима();
	
КонецПроцедуры

&НаКлиенте
Процедура Режим_ПовторнаяОтправкаКлючМобильногоПриложенияПриИзменении(Элемент)
	
	СменаРежима();
	
КонецПроцедуры

&НаКлиенте
Процедура Режим_СменаКонтактовПриИзменении(Элемент)
	
	СменаРежима();
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонПриИзменении(Элемент)
	
	Элементы.Телефон.ОтметкаНезаполненного = НЕ ПроверитьНомерТелефона(Телефон);
	ТелефонXML = ЗначениеТелефонаОблачнойПодписиПоПредставлению(Телефон);
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
			"УправлениеКонтактнойИнформациейКлиент");
		
		ПараметрыФормы = МодульУправлениеКонтактнойИнформациейКлиент.ПараметрыФормыКонтактнойИнформации(
			ВидКонтактнойИнформацииТелефон(), ТелефонXML, Телефон);
		
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Мобильный телефон владельца';
													|en = 'Owner phone number'"));
		
		МодульУправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТелефонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ТелефонXML = ВыбранноеЗначение.Значение;
		Телефон = ПолучитьПредставлениеТелефона(ВыбранноеЗначение.Представление);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВвода Тогда
		Ответ = РезультатРаботы(Истина);
		ЗакрытьФорму(Ответ);
	ИначеЕсли УжеОтправлено Тогда
		ЗавершитьНастройки();
	Иначе	
		ОтправитьЗаявление();
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьТекстЗаявления(Команда)
	
	Если ЗначениеЗаполнено(ТекстЗаявления) Тогда
		ИмяФайла = ИдентификаторЗаявления + ".xml";
		ДанныеФайла = ПолучитьДвоичныеДанныеИзBase64Строки(ТекстЗаявления);
		АдресФайла = ПоместитьВоВременноеХранилище(ДанныеФайла);
		ФайловаяСистемаКлиент.СохранитьФайл(Неопределено, АдресФайла, ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗаявление(Команда)
	
	Дополнение = ?(УжеОтправлено, НСтр("ru = 'и отправленного';
										|en = 'and the sent application'"), "");
	ТекстВопроса = НСтр("ru = 'Данные заявления будет потеряны безвозвратно.
					|Хотите отказаться от оформленного %1 заявления.';
					|en = 'Application data will be lost.
					|Want to cancel the completed %1 application'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Дополнение);
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ОтменитьЗаявлениеЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОповещениеСледующее,
				ТекстВопроса,
				РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЦиклОкончанияНастройки

&НаКлиенте
Процедура ЗавершитьНастройки()
	
	СтатусПроцессаОжидания(Истина);
	
	Результат = ПолучитьСостояниеЗаявления();
	Если Результат.Выполнено И Результат.РегистрацияУспешна Тогда
		ИдентификаторАбонента = Результат.ИдентификаторАбонента;
		
		ПараметрыВызова = Новый Структура;
		ПараметрыВызова.Вставить("УчетнаяЗапись", УчетнаяЗапись);
		ПараметрыВызова.Вставить("Сертификат", Результат.ДанныеСертификата);
		ПараметрыВызова.Вставить("ШифрованныйБлок", Результат.ДанныеШифрованногоБлока);
		ПараметрыВызова.Вставить("УстановитьСертификат", Ложь);
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ОтобразитьОшибку", Истина);
		
		ОповещениеСледующее = Новый ОписаниеОповещения("ЗавершитьНастройкиОкончание", ЭтотОбъект);
		СервисКриптографииDSSСлужебныйКлиент.АктивироватьИУстановитьСертификат(ОповещениеСледующее, ПараметрыВызова, ПараметрыОперации);
		
	ИначеЕсли Результат.Выполнено И НЕ Результат.РегистрацияУспешна Тогда	
		СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Отклонено");
		ЗавершитьНастройкиРезультат(Истина);
		
	ИначеЕсли ОбновитьАвтоматически Тогда
		ЗавершитьНастройкиРезультат(Ложь);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНастройкиОкончание(РезультатВыполнения, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыполнения.Выполнено Тогда
		СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Исполнено");
		ЗавершитьНастройкиРезультат(Истина);
	Иначе
		СтатусПроцессаОжидания(Ложь);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНастройкиРезультат(Успешно)
	
	СтатусПроцессаОжидания(Ложь);
	
	ЗакрытьФорму(РезультатРаботы(Успешно));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСостояниеЗаявления()
	
	КлючПоиска	= Обработки.УправлениеПодключениемDSS.КлючПоискаУчетнойЗаписи(УчетнаяЗапись);
	Результат 	= Обработки.УправлениеПодключениемDSS.ПолучитьСостояниеЗаявления(УчетнаяЗапись, ИдентификаторЗаявления, КлючПоиска);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ЦиклОтправкиЗаявления

&НаКлиенте
Процедура ОтправитьЗаявление()
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ОтправитьЗаявлениеСформироватьЗаявлениеРезультат", ЭтотОбъект);
	
	ПараметрыЦикла = Новый Структура;
	ПараметрыЦикла.Вставить("Заявление", Неопределено);
	ПараметрыЦикла.Вставить("Подпись", Неопределено);
	ПараметрыЦикла.Вставить("ТикетПоддержки", Неопределено);
	ПараметрыЦикла.Вставить("ОповещениеОЗавершении", ОповещениеСледующее);
	
	СтатусПроцессаОжидания(Истина);
	
	Если ИнтернетПоддержкаПользователейПодключена Тогда
		ОтправитьЗаявлениеСформироватьЗаявление(ПараметрыЦикла);
	Иначе
		ОтправитьЗаявлениеПодключитьИнтернетПоддержку(ПараметрыЦикла);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОтправитьЗаявлениеПодключитьИнтернетПоддержку(ПараметрыЦикла)
	
	ОповещениеОЗавершении = ПараметрыЦикла.ОповещениеОЗавершении;
	
	Если Не ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ПоказатьОшибку(ОповещениеОЗавершении, НСтр("ru = 'Невозможно подключиться к порталу интернет-поддержки по причине:
			|Библиотека интернет поддержки пользователей не внедрена в конфигурацию.';
			|en = 'Cannot connect to online user support portal as:
			|Online user support library is not implemented in the configuration.'"));
		Возврат;
	КонецЕсли;
	
	МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль(
		"ИнтернетПоддержкаПользователейКлиент");
	
	Если МодульИнтернетПоддержкаПользователейКлиент.ДоступноПодключениеИнтернетПоддержки() Тогда
		ОповещениеОПодключении = Новый ОписаниеОповещения("ОтправитьЗаявлениеПослеПодключенияИнтернетПоддержки", ЭтотОбъект, ПараметрыЦикла);
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеОПодключении, ЭтотОбъект);
		
	Иначе
		ПоказатьОшибку(ОповещениеОЗавершении, НСтр("ru = 'Для отправки заявления необходимо подключить Интернет-поддержку пользователей.';
													|en = 'To send the application, connect to online user support.'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеПослеПодключенияИнтернетПоддержки(РезультатВыполнения, ПараметрыЦикла) Экспорт
	
	ОповещениеОЗавершении = ПараметрыЦикла.ОповещениеОЗавершении;
	ЛогинПоддержки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатВыполнения, "Логин");
	ИнтернетПоддержкаПользователейПодключена = ЗначениеЗаполнено(ЛогинПоддержки);
	
	Если ИнтернетПоддержкаПользователейПодключена Тогда
		ОтправитьЗаявлениеСформироватьЗаявление(ПараметрыЦикла);
	Иначе
		ПоказатьОшибку(ОповещениеОЗавершении, НСтр("ru = 'Для отправки заявления необходимо проверить подключение услуги Интернет-поддержки пользователей.';
													|en = 'To send an application, check that the online user support service is enabled.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеСформироватьЗаявление(ПараметрыЦикла)
	
	ДлительнаяОперация = ПолучитьТикетИнтернетПоддержки();
						
	ОбъектОповещения = Новый ОписаниеОповещения("ОтправитьЗаявлениеСформироватьЗаявлениеПолучениеТикета", ЭтотОбъект, ПараметрыЦикла);
	СервисКриптографииDSSСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(ОбъектОповещения, ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеСформироватьЗаявлениеПолучениеТикета(ОтветСервиса, ПараметрыЦикла) Экспорт
	
	ОповещениеОЗавершении = ПараметрыЦикла.ОповещениеОЗавершении;
	РезультатВыполнения = СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(ОтветСервиса, ПараметрыЦикла);
	
	Если НЕ РезультатВыполнения.Выполнено Тогда
		ПоказатьОшибку(ОповещениеОЗавершении, НСтр("ru = 'Не удалось получить тикет Интернет-поддержки.';
													|en = 'Cannot get an online support ticket.'"));
		
	ИначеЕсли ЗначениеЗаполнено(РезультатВыполнения.Тикет) Тогда
		ПараметрыЦикла.ТикетПоддержки = РезультатВыполнения;
		ПараметрыЦикла.Заявление = ПодготовитьТекстЗаявления(РезультатВыполнения);
		
		ДанныеДляПодписи = ПолучитьДвоичныеДанныеИзСтроки(ПараметрыЦикла.Заявление, "windows-1251");
		СвойстваСертификата = Новый Структура("Отпечаток", ОтпечатокСертификата);
		
		СвойстваПодписи = СервисКриптографииDSSКлиентСервер.ПолучитьСвойствоПодписиCMS(Истина, Ложь);
		СервисКриптографииDSSКлиентСервер.ПолучитьИнформациюДокументаДляПодписи(СвойстваПодписи, НСтр("ru = 'Подпись отправляемого заявления';
																										|en = 'Signature of application to send'"), "xml");
		
		ПараметрыОперации = Новый Структура;
		ПараметрыОперации.Вставить("ОтобразитьОшибку", Истина);

		ОповещениеСледующее = Новый ОписаниеОповещения("ОтправитьЗаявлениеСформироватьЗаявлениеПослеПодписание", ЭтотОбъект, ПараметрыЦикла);
		СервисКриптографииDSSКлиент.Подписать(ОповещениеСледующее, УчетнаяЗапись, ДанныеДляПодписи, СвойстваПодписи, СвойстваСертификата, ПараметрыОперации);
		
	Иначе
		ИнтернетПоддержкаПользователейПодключена = Ложь;
		ПоказатьОшибку(ОповещениеОЗавершении, НСтр("ru = 'Неверные параметры подключения к Интернет-поддержке';
													|en = 'Invalid online support connection parameters'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеСформироватьЗаявлениеПослеПодписание(РезультатВыполнения, ПараметрыЦикла) Экспорт
	
	ОповещениеОЗавершении = ПараметрыЦикла.ОповещениеОЗавершении;
	
	Если РезультатВыполнения.Выполнено Тогда
		ПараметрыЦикла.Подпись = РезультатВыполнения.Результат;
		ДлительнаяОперация = ОтправитьЗаявлениеНаСервере(ПараметрыЦикла.Заявление, ПараметрыЦикла.Подпись, ПараметрыЦикла.ТикетПоддержки);
							
		ОбъектОповещения = Новый ОписаниеОповещения("ОтправитьЗаявлениеСформироватьЗаявлениеЗавершение", ЭтотОбъект, ПараметрыЦикла);
		СервисКриптографииDSSСлужебныйКлиент.ОжидатьЗавершенияВыполненияВФоне(ОбъектОповещения, ДлительнаяОперация);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, Неопределено);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеСформироватьЗаявлениеЗавершение(ОтветСервиса, ПараметрыЦикла) Экспорт
	
	ОповещениеОЗавершении = ПараметрыЦикла.ОповещениеОЗавершении;
	
	РезультатВыполнения = СервисКриптографииDSSСлужебныйКлиент.ПолучитьРезультатВыполненияВФоне(ОтветСервиса, ПараметрыЦикла);
	Если РезультатВыполнения.Выполнено Тогда
		СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Отправлено");
		ДатаЗаявления = РезультатВыполнения.ДатаОтправки;
		ИдентификаторЗаявления = РезультатВыполнения.ИдентификаторДокументооборота;
		СтатусПроцессаОжидания(Ложь);
		ЗакрытьФорму(РезультатРаботы(Истина));
	Иначе
		ПоказатьОшибку(ОповещениеОЗавершении, РезультатВыполнения.Ошибка);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗаявлениеСформироватьЗаявлениеРезультат(РезультатВыполнения, ПараметрыЦикла) Экспорт
	
	СтатусПроцессаОжидания(Ложь);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьТекстЗаявления(ТикетПоддержки)
	
	РеквизитыЗаявления = ПодготовитьДанныеЗаявления();
	Результат = Обработки.УправлениеПодключениемDSS.ПодготовитьЗаявлениеXML(РеквизитыЗаявления, УчетнаяЗапись, ТикетПоддержки);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьТикетИнтернетПоддержки()
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("АдресРезультата", АдресРезультата);
	
	Возврат СервисКриптографииDSSСлужебный.ВыполнитьВФоне("Обработки.УправлениеПодключениемDSS.ПолучитьТикетИнтернетПоддержкиПользователя", ПараметрыВызова);
	
КонецФункции

&НаСервере
Функция ОтправитьЗаявлениеНаСервере(Заявление, Подпись, ТикетПоддержки)
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
	ПараметрыВызова = Новый Структура;
	ПараметрыВызова.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВызова.Вставить("Заявление", Заявление);
	ПараметрыВызова.Вставить("ПодписьЗаявления", Подпись);
	ПараметрыВызова.Вставить("ТикетПользователя", ТикетПоддержки);
	ПараметрыВызова.Вставить("ИдентификаторДокументооборота", ИдентификаторЗаявления);
	
	Возврат СервисКриптографииDSSСлужебный.ВыполнитьВФоне("Обработки.УправлениеПодключениемDSS.ОтправитьЗаявлениеНаПортал", ПараметрыВызова);
	
КонецФункции

#КонецОбласти

#Область Прочие

&НаКлиенте
Процедура ПоказатьОшибку(ОповещениеЗавершения, ТекстОшибки)
	
	СервисКриптографииDSSКлиент.ВывестиОшибку(ОповещениеЗавершения, ТекстОшибки);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусПроцессаОжидания(НовыйСтатус)
	
	ПроцессОжидания = НовыйСтатус;
	НастроитьДоступностьЭлементов();

КонецПроцедуры

&НаКлиенте
Процедура СменаРежима()
	
	Модифицированность = Истина;
	НастроитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьДоступностьЭлементов()
	
	Изменять = Истина;
	Если СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Подготовлено") Тогда
		Изменять = НЕ ОбновитьАвтоматически;
	ИначеЕсли СостояниеЗаявления <> ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено") Тогда
		Изменять = Ложь;
	КонецЕсли;
	
	ДоступныКонтакты = Режим_СменаКлючаМобильногоПриложения ИЛИ Режим_СменаПароля
						ИЛИ Режим_ПовторнаяОтправкаКлючМобильногоПриложения
						ИЛИ Режим_ПовторнаяОтправкаКодаАктивации;
	Элементы.ГруппаКонтактыПерваяСтрока.Доступность = Изменять И ДоступныКонтакты;
	Элементы.Телефон.Доступность = Режим_СменаКонтактов И Изменять И ДоступныКонтакты;
	
	Элементы.ГруппаСменаПароля.Доступность = НЕ Режим_СменаКлючаМобильногоПриложения И Изменять;
	Элементы.ГруппаСменаКлюча.Доступность = НЕ Режим_СменаПароля И Изменять
					И НЕ Режим_ПовторнаяОтправкаКлючМобильногоПриложения И НЕ Режим_ПовторнаяОтправкаКодаАктивации;
	Элементы.ГруппаПовторКлюча.Доступность = НЕ Режим_СменаКлючаМобильногоПриложения И Изменять;
	Элементы.ГруппаПовторКодаАвторизации.Доступность = НЕ Режим_СменаКлючаМобильногоПриложения И Изменять;
	Элементы.ГруппаПовторКодаАвторизации.Доступность = НЕ Режим_СменаКлючаМобильногоПриложения И Изменять;
	Элементы.Отправить.Доступность = Изменять И НЕ ОбновитьАвтоматически И НЕ ПроцессОжидания;
	Элементы.ПолучитьТекстЗаявления.Доступность = ЗначениеЗаполнено(ТекстЗаявления);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьРазмерыФормы()
	
	Элементы.ГруппаКонтакты.Видимость = НЕ Элементы.ГруппаКонтакты.Видимость;
	Элементы.ГруппаКонтакты.Видимость = НЕ Элементы.ГруппаКонтакты.Видимость;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытиеФормы()
	
	ОповещениеСледующее = Новый ОписаниеОповещения("ЗакрытьФормуПослеВыбора", ЭтотОбъект);
	ПоказатьВопрос(ОповещениеСледующее, 
				НСтр("ru = 'Сохранить изменения?';
					|en = 'Save changes?'"),
				РежимДиалогаВопрос.ДаНет);
				
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(РезультатВыбора = Неопределено)
	
	Модифицированность = Ложь;
	Закрыть(РезультатВыбора);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатРаботы(Успешно = Истина)
	
	ДанныеЗаявления = ПодготовитьДанныеЗаявления();
	
	Результат = СервисКриптографииDSSКлиент.ОтветСервисаПоУмолчанию(Успешно);
	Результат.Вставить("Результат", Новый Структура);
	Результат.Результат.Вставить("СодержаниеЗаявления", ДанныеЗаявления);
	Результат.Результат.Вставить("СостояниеЗаявления", СостояниеЗаявления);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьФормуПослеВыбора(ВыборПользователя, ДополнительныеПараметры) Экспорт
	
	Если ВыборПользователя = КодВозвратаДиалога.Да Тогда
		Если СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.НеПодготовлено") Тогда
			СостояниеЗаявления = ПредопределенноеЗначение("Перечисление.СостоянияЗаявленияУчетнойЗаписиDSS.Подготовлено");
		КонецЕсли;	
		Ответ = РезультатРаботы(Истина);
	Иначе
		Ответ = РезультатРаботы(Ложь);
	КонецЕсли;	
	
	ЗакрытьФорму(Ответ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьЗаявлениеЗавершение(ВыборПользователя, ДополнительныеПараметры) Экспорт
	
	ОчиститьЗаявление();
	Ответ = РезультатРаботы(Истина);
	ЗакрытьФорму(Ответ);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЭлектроннуюПочту(ЭлектроннаяПочта)
	
	Результат = НЕ ЗначениеЗаполнено(ЭлектроннаяПочта) 
					ИЛИ ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьНомерТелефона(НомерТелефона)
	
	Представление = Обработки.УправлениеПодключениемDSS.ПолучитьПредставлениеТелефона(НомерТелефона);
	Результат = ЗначениеЗаполнено(Представление) ИЛИ НЕ ЗначениеЗаполнено(НомерТелефона);
	
	Возврат Результат;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ВидКонтактнойИнформацииТелефон()
	
	МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
	Результат = МодульУправлениеКонтактнойИнформацией.ПараметрыВидаКонтактнойИнформации(Перечисления["ТипыКонтактнойИнформации"].Телефон);
			
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеТелефонаОблачнойПодписиПоПредставлению(ТекущийТелефон)
	
	Результат = "";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		Результат = МодульУправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(ТекущийТелефон, Перечисления["ТипыКонтактнойИнформации"].Телефон);
	КонецЕсли;	
	
	Возврат Результат;
			
КонецФункции

&НаСервере
Процедура ЗаполнитьФормуДаннымиЗаявления(ВсеРеквизиты)
	
	ДатаЗаявления			= ВсеРеквизиты.ДатаЗаявления;
	ИдентификаторЗаявления	= ВсеРеквизиты.ИдентификаторЗаявления;
	ИдентификаторАбонента	= ВсеРеквизиты.ИдентификаторАбонента;
	СостояниеЗаявления		= ВсеРеквизиты.СостояниеЗаявления;
	ИНН 					= ВсеРеквизиты.ИНН;
	КПП 					= ВсеРеквизиты.КПП;
	Телефон 				= ВсеРеквизиты.НомерТелефона;
	ТелефонXML 				= ВсеРеквизиты.НомерТелефонаXML;
	НомерТелефонаПроверен 	= ВсеРеквизиты.НомерТелефонаПроверен;
	ЭлектроннаяПочта    	= ВсеРеквизиты.ЭлектроннаяПочта;
	ЭлектроннаяПочтаПроверена = ВсеРеквизиты.ЭлектроннаяПочтаПроверена;
	Режим_СменаКонтактов 	= ВсеРеквизиты.Режим_СменаКонтактов;
	Режим_ПовторнаяОтправкаКлючМобильногоПриложения = ВсеРеквизиты.Режим_ПовторнаяОтправкаКлючМобильногоПриложения;
	Режим_ПовторнаяОтправкаКодаАктивации = ВсеРеквизиты.Режим_ПовторнаяОтправкаКодаАктивации;
	Режим_СменаКлючаМобильногоПриложения = ВсеРеквизиты.Режим_СменаКлючаМобильногоПриложения;
	Режим_СменаПароля 		= ВсеРеквизиты.Режим_СменаПароля;
	ТекстЗаявления			= ВсеРеквизиты.ТекстЗаявления;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеЗаявления(СодержимоеЗаявления = Неопределено)
	
	Результат = Обработки.УправлениеПодключениемDSS.СтруктураРеквизитовЗаявления();
	ДанныеЗаявления = Неопределено;
	
	Если ТипЗнч(СодержимоеЗаявления) = Тип("СправочникСсылка.УчетныеЗаписиDSS") Тогда
		
		РеквизитЗаявления = Неопределено;
		Если СервисКриптографииDSSСлужебный.ПроверитьПраво("УчетныеЗаписиDSS") Тогда
			РеквизитЗаявления	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СодержимоеЗаявления, "СодержаниеЗаявления", Истина);
		КонецЕсли;
		
		Если РеквизитЗаявления <> Неопределено Тогда
			ДанныеЗаявления	= РеквизитЗаявления.Получить();
		КонецЕсли;
				
	Иначе
		ДанныеЗаявления = СодержимоеЗаявления;	
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаявления) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Результат, ДанныеЗаявления);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПодготовитьДанныеЗаявления()
	
	Результат = Обработки.УправлениеПодключениемDSS.СтруктураРеквизитовЗаявления();
	Результат.ДатаЗаявления = ДатаЗаявления;
	Результат.ИдентификаторЗаявления = ИдентификаторЗаявления;
	Результат.ИдентификаторАбонента = ИдентификаторАбонента;
	Результат.СостояниеЗаявления = СостояниеЗаявления;
	Результат.ИНН = ИНН;
	Результат.КПП = КПП;
	Результат.НомерТелефона = Телефон;
	Результат.НомерТелефонаXML = ТелефонXML;
	Результат.НомерТелефонаПроверен = НомерТелефонаПроверен;
	Результат.ЭлектроннаяПочта = ЭлектроннаяПочта;
	Результат.ЭлектроннаяПочтаПроверена = ЭлектроннаяПочтаПроверена;
	Результат.СрокQRКода = СрокQRКода;
	Результат.Режим_СменаКонтактов = Режим_СменаКонтактов;
	Результат.Режим_ПовторнаяОтправкаКлючМобильногоПриложения = Режим_ПовторнаяОтправкаКлючМобильногоПриложения;
	Результат.Режим_ПовторнаяОтправкаКодаАктивации = Режим_ПовторнаяОтправкаКодаАктивации;
	Результат.Режим_СменаКлючаМобильногоПриложения = Режим_СменаКлючаМобильногоПриложения;
	Результат.Режим_СменаПароля = Режим_СменаПароля;
	Результат.ТекстЗаявления = ТекстЗаявления;
	Результат.ОтпечатокСертификата = ОтпечатокСертификата;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ОчиститьЗаявление()
	
	ВсеРеквизиты = Обработки.УправлениеПодключениемDSS.СтруктураРеквизитовЗаявления();
	ЗаполнитьФормуДаннымиЗаявления(ВсеРеквизиты);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьОформлениеФормы(ДоступныеРазделы)
	
	Если ЗначениеЗаполнено(ТекущийНомер) Тогда
		Элементы.ДекорацияТекущийНомер.Заголовок = НСтр("ru = 'Текущий номер телефона';
														|en = 'Current phone number'") + ": " + ТекущийНомер;
	Иначе
		Элементы.ДекорацияТекущийНомер.Заголовок = "";
	КонецЕсли;	
	Элементы.ДекорацияТекущийНомер.Видимость = ЗначениеЗаполнено(Элементы.ДекорацияТекущийНомер.Заголовок);
	
	Элементы.ДекорацияЛогина.Заголовок = НСтр("ru = 'Настройка для';
												|en = 'Setting for'") + ": " + СокрЛП(УчетнаяЗапись);
	Элементы.СостояниеЗаявления.Видимость = НЕ РежимВвода;
	Элементы.ДатаЗаявления.Видимость = НЕ РежимВвода;
	Элементы.ПолучитьТекстЗаявления.Видимость = НЕ РежимВвода;
	Элементы.ОтменитьЗаявление.Видимость = НЕ РежимВвода И УжеОтправлено;
	
	Если РежимВвода Тогда
		Заголовок = НСтр("ru = 'Дополнительные настройки издания сертификата';
						|en = 'Additional settings for certificate issuance'");
		Элементы.ДекорацияЛогина.Видимость = Ложь;
		Элементы.Отправить.Заголовок = НСтр("ru = 'ОК';
											|en = 'OK'");
	ИначеЕсли УжеОтправлено Тогда
		Элементы.Отправить.Заголовок = НСтр("ru = 'Обновить';
											|en = 'Update'");
	Иначе
		Элементы.Отправить.Заголовок = НСтр("ru = 'Отправить';
											|en = 'Send'");
	КонецЕсли;
	
	Раздел1 = 1;
	Раздел2 = 2;
	Раздел3 = 3;
	Раздел4 = 4;
	
	СписокРазделов = Новый Структура;
	СписокРазделов.Вставить("Пароль", "Раздел1");
	СписокРазделов.Вставить("НовыйQRКод", "Раздел2");
	СписокРазделов.Вставить("Повтор", "Раздел3");
	СписокРазделов.Вставить("Контакты", "Раздел4");

	Если ДоступныеРазделы.Количество() = 0 Тогда
		Для каждого СтрокаКлюча Из СписокРазделов Цикл
			ДоступныеРазделы.Добавить(СтрокаКлюча.Ключ);
		КонецЦикла;	
	КонецЕсли;
	
	Для каждого СтрокаКлюча Из СписокРазделов Цикл
		ИмяЭлемента = СтрокаКлюча.Значение;
		Элементы[ИмяЭлемента].Доступность = ДоступныеРазделы.Найти(СтрокаКлюча.Ключ) <> Неопределено;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеИзПредыдущегоЗаявленияНаСертификат()
	
	ДанныеЗаявления = Обработки.УправлениеПодключениемDSS.ПолучитьДанныеИзПредыдущегоЗаявленияНаСертификат(УчетнаяЗапись);
		
	ТекущаяЭлектроннаяПочта = ДанныеЗаявления.ОблачнаяПодписьЭлектроннаяПочта;
	ТекущийНомер = ДанныеЗаявления.ОблачнаяПодписьМобильныйТелефон;
	ТекущийНомерXML = ДанныеЗаявления.ОблачнаяПодписьМобильныйТелефонXML;
	ИНН = ДанныеЗаявления.ИНН;
	КПП = ДанныеЗаявления.КПП;
	ОтпечатокСертификата = ДанныеЗаявления.ОтпечатокСертификата;
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторАбонента) Тогда
		ИдентификаторАбонента = ДанныеЗаявления.ИдентификаторАбонента;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПредставлениеТелефона(ТекущийНомерТелефона)
	
	Результат = Обработки.УправлениеПодключениемDSS.ПолучитьПредставлениеТелефона(ТекущийНомерТелефона);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
