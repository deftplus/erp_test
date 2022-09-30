///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОписаниеПеременных

// Хранение контекста взаимодействия с сервисом
&НаКлиенте
Перем КонтекстВзаимодействия Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтоДобавлениеСертификата = (Параметры.ToAddCert = "YES");
	
	Элементы.НадписьЛогина.Заголовок = НСтр("ru = 'Логин:';
											|en = 'Login:'") + " " + Параметры.login;
	
	СтатусЗаявки           = Параметры.applicationStatusED;
	НомерЗаявки            = Параметры.numberRequestED;
	ИдентификаторУчастника = Параметры.identifierTaxcomED;
	СтрокаДатыЗаявки       = Параметры.dateRequestED;
	СертификатЭП           = Параметры.IDCertificateED;
	Организация            = Параметры.IDOrganizationED;
	
	// Преобразование строковых параметров к нужному виду
	ДатаЗаявки             = ПолучитьДатуИзСтрокиДатыССервера(СтрокаДатыЗаявки);
	
	УстановитьСтатусФормы();
	
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаИнформации.Отображение = ОтображениеОбычнойГруппы.Нет;
		Элементы.ГруппаСведенийОСертификате.Отображение = ОтображениеОбычнойГруппы.Нет;
	КонецЕсли;
	
	Элементы.ДекорацияТехПоддержка.Видимость
		= ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Подключение1СТакскомКлиент.ОбработатьОткрытиеФормы(КонтекстВзаимодействия, ЭтотОбъект);
	
	Если СтатусЗаявки = "notconsidered" Тогда
		ВремяОжиданияСек = 60;
		УстановитьНадписьНаГиперссылкеОбновленияСтатуса();
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО", 1, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО");
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если СтатусЗаявки = "obtained" Тогда
		
		Если КонтекстВзаимодействия.ОбработчикиЗавершенияБизнесПроцесса <> Неопределено
			И КонтекстВзаимодействия.ОбработчикиЗавершенияБизнесПроцесса.Обработчик <> Неопределено Тогда
			ОбработчикЗавершения = КонтекстВзаимодействия.ОбработчикиЗавершенияБизнесПроцесса.Обработчик;
		Иначе
			ОбработчикЗавершения = Неопределено;
		КонецЕсли;
		
		Если ОбработчикЗавершения <> Неопределено Тогда
			// Вызов через новый программный интерфейс.
			
			КонтекстВзаимодействия.ОбработчикиЗавершенияБизнесПроцесса.Обработано = Истина;
			
			Если ЭтоДобавлениеСертификата Тогда
				ВыполнитьОбработкуОповещения(ОбработчикЗавершения, Истина);
			Иначе
				ВыполнитьОбработкуОповещения(ОбработчикЗавершения, ИдентификаторУчастника);
			КонецЕсли;
			
		Иначе
			
			// Поддержка устаревшего программного интерфейса.
			ИдентификаторФормы = Подключение1СТакскомКлиент.ЗначениеСессионногоПараметра(
				КонтекстВзаимодействия.КСКонтекст,
				"IDParentForm");
			
			Оповестить(
				"ОповещениеОПолученииУникальногоИдентификатораУчастникаОбменаЭД",
				ИдентификаторУчастника,
				ИдентификаторФормы);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ПрограммноеЗакрытие
		И Не Подключение1СТакскомКлиент.ФормаОткрыта(
			КонтекстВзаимодействия,
			"Обработка.Подключение1СТакском.Форма.ЛичныйКабинетАбонента") Тогда
		Подключение1СТакскомКлиент.ЗавершитьБизнесПроцесс(КонтекстВзаимодействия, ЗавершениеРаботы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьОбновитьНажатие(Элемент)
	
	ОтключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО");
	// Обновить статус заявки
	Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
		КонтекстВзаимодействия,
		ЭтотОбъект,
		"getApplicationStatus");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаявкаНажатие(Элемент)
	
	// Открытие заявки на просмотр
	Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
		КонтекстВзаимодействия,
		Неопределено,
		"showEDRequest");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЛичныйКабинетНажатие(Элемент)
	
	// Переход в личный кабинет
	Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
		КонтекстВзаимодействия,
		Неопределено,
		"showPrivateED");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаявка1Нажатие(Элемент)
	
	// Открытие заявки на просмотр
	Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
		КонтекстВзаимодействия,
		Неопределено,
		"showEDRequest");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьИзменитьНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ПоказатьПричинуОтклоненияЗаявкиЭДО(КонтекстВзаимодействия);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыходНажатие(Элемент)
	
	Подключение1СТакскомКлиент.ОбработатьВыходПользователя(КонтекстВзаимодействия, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылкиТехПоддержка(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "TechSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения =
			НСтр("ru = 'Не получается отправить заявку на регистрацию участника обмена ЭД.
				|
				|%1';
				|en = 'Cannot send a request for registering ED exchange participant. 
				|
				|%1'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Подключение1СТакскомКлиент.ТекстТехническихПараметровЭДО(КонтекстВзаимодействия, СертификатЭП));
		
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("Получатель", "taxcom");
		ДанныеСообщения.Вставить("Тема",       НСтр("ru = 'Интернет-поддержка. Заявка на регистрацию участника обмена ЭД в 1С-Такском.';
													|en = 'Online support. Request for registration of ED exchange participant in 1C:Taxcom.'"));
		ДанныеСообщения.Вставить("Сообщение",  ТекстСообщения);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	
	Если НЕ ЗначениеЗаполнено(СтатусЗаявки)
		ИЛИ СтатусЗаявки = "none"
		ИЛИ СтатусЗаявки = "rejected" Тогда
		// Новая заявка
		
		Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
			КонтекстВзаимодействия,
			ЭтотОбъект,
			"newApplicationED");
		
	ИначеЕсли СтатусЗаявки = "obtained" Тогда
		
		// При закрытии формы будет выполнено оповещение о получении идентификатора,
		// а также будет закрыт бизнес-процесс.
		Закрыть();
		
		// В других случаях кнопка не видна.
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет преобразование строки даты из формата сервиса ИПП
// во внутреннее представление даты в платформе.
//
// Параметры:
// - СтрокаДаты (Строка) - строка даты в формате "YYYY-MM-DD hh:mm:ss".
//
// Возвращаемое значение: Дата - дата, преобразованная в формат даты платформы
&НаСервере
Функция ПолучитьДатуИзСтрокиДатыССервера(СтрокаДаты)
	
	Если ПустаяСтрока(СтрокаДаты) Тогда
		ПеремДата = Дата(1,1,1);
	Иначе
		Попытка
			ПеремДата = Дата(СтрЗаменить
								(СтрЗаменить
									(СтрЗаменить
										(СтрЗаменить
											(СтрокаДаты,
											".",
											""),
										"-",
										""),
									" ",
									""),
								":",
								""));
		Исключение
			ПеремДата = Дата(1,1,1);
		КонецПопытки;
	КонецЕсли;
	
	Возврат ПеремДата;
	
КонецФункции

// Процедура для установки внешнего вида формы
// в зависимости от статуса заявки.
&НаСервере
Процедура УстановитьСтатусФормы()
	
	Если НЕ ЗначениеЗаполнено(СтатусЗаявки)
		ИЛИ СтатусЗаявки = "none" Тогда
		// Новая заявка
		
		Элементы.СтраницаНеЗарегистрировано.Видимость = Истина;
		Элементы.СтраницаНеРассмотрено.Видимость      = Ложь;
		Элементы.СтраницаРассмотрено.Видимость        = Ложь;
		Элементы.СтраницаОтказано.Видимость           = Ложь;
		
		Элементы.ПанельИнформацииОРегистрации.ТекущаяСтраница = Элементы.СтраницаНеЗарегистрировано;
		Элементы.ВыполнитьДействие.Заголовок = НСтр("ru = 'Создать заявку';
													|en = 'Create request'");
		Элементы.ВыполнитьДействие.Видимость  = Истина;
		
	ИначеЕсли СтатусЗаявки = "notconsidered" Тогда
		// Ожидается
		
		Элементы.СтраницаНеЗарегистрировано.Видимость = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость      = Истина;
		Элементы.СтраницаРассмотрено.Видимость        = Ложь;
		Элементы.СтраницаОтказано.Видимость           = Ложь;
		
		Элементы.ПанельИнформацииОРегистрации.ТекущаяСтраница = Элементы.СтраницаНеРассмотрено;
		
		Элементы.ВыполнитьДействие.Видимость = Ложь;
		Элементы.Закрыть.КнопкаПоУмолчанию   = Истина;
		Элементы.НадписьЗаявка.Заголовок = НСтр("ru = 'Заявка №';
												|en = 'Request No'")
			+ " " + ?(ЗначениеЗаполнено(НомерЗаявки), НомерЗаявки, "");
		Если ДатаЗаявки <> Дата(1,1,1) Тогда
			Элементы.НадписьЗаявка.Заголовок = Элементы.НадписьЗаявка.Заголовок
				+ " " + НСтр("ru = 'от';
							|en = 'dated'") + " "
				+ Формат(ДатаЗаявки, "ДЛФ=DDT");
		КонецЕсли;
		
		Элементы.ДекорацияЗаголовокРегистрацияСертификата.Видимость = ЭтоДобавлениеСертификата;
		Элементы.ДекорацияЗаголовокПолучениеИдентификатора.Видимость = НЕ Элементы.ДекорацияЗаголовокРегистрацияСертификата.Видимость;
		
	ИначеЕсли СтатусЗаявки = "rejected" Тогда
		// Отклонена
		
		Элементы.СтраницаНеЗарегистрировано.Видимость = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость      = Ложь;
		Элементы.СтраницаРассмотрено.Видимость        = Ложь;
		Элементы.СтраницаОтказано.Видимость           = Истина;
		
		Элементы.ПанельИнформацииОРегистрации.ТекущаяСтраница = Элементы.СтраницаОтказано;
		Элементы.ВыполнитьДействие.Заголовок = НСтр("ru = 'Создать заявку';
													|en = 'Create request'");
		Элементы.ВыполнитьДействие.Видимость = Истина;
		Элементы.НадписьЗаявка1.Заголовок = НСтр("ru = 'Заявка №';
												|en = 'Request No'")
			+ " " + ?(ЗначениеЗаполнено(НомерЗаявки), НомерЗаявки, "");
		Если ДатаЗаявки <> Дата(1,1,1) Тогда
			Элементы.НадписьЗаявка1.Заголовок = Элементы.НадписьЗаявка1.Заголовок
				+ " " + НСтр("ru = 'от';
							|en = 'dated'") + " "
				+ Формат(ДатаЗаявки, "ДЛФ=DDT");
		КонецЕсли;
		
		Элементы.ДекорацияОтказРегистрацияСертификата.Видимость = ЭтоДобавлениеСертификата;
		Элементы.ДекорацияОтказПолучениеИдентификатора.Видимость   = НЕ Элементы.ДекорацияОтказРегистрацияСертификата.Видимость;
		
	Иначе
		
		// Получена СтатусЗаявки = "obtained"
		
		Элементы.СтраницаНеЗарегистрировано.Видимость = Ложь;
		Элементы.СтраницаНеРассмотрено.Видимость      = Ложь;
		Элементы.СтраницаРассмотрено.Видимость        = Истина;
		Элементы.СтраницаОтказано.Видимость           = Ложь;
		
		Элементы.ПанельИнформацииОРегистрации.ТекущаяСтраница = Элементы.СтраницаРассмотрено;
		Элементы.ВыполнитьДействие.Заголовок                  = НСтр("ru = 'ОК';
																	|en = 'OK'");
		Элементы.ВыполнитьДействие.Видимость                  = Истина;
		Элементы.НадписьУникальныйИдентификатор.Заголовок     = ?(ЗначениеЗаполнено(ИдентификаторУчастника),
			ИдентификаторУчастника,
			"");
		
		Элементы.ДекорацияСертификатДобавлен.Видимость = ЭтоДобавлениеСертификата;
		Элементы.ДекорацияИдентификаторПолучен.Видимость   = НЕ Элементы.ДекорацияСертификатДобавлен.Видимость;
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает надпись на гиперссылке обновления статуса заявки - количество
// секунд до автоматического обновления.
&НаКлиенте
Процедура УстановитьНадписьНаГиперссылкеОбновленияСтатуса()
	
	ТекстЗаголовка = НСтр("ru = 'Проверить выполнение заявки (осталось %1 сек.)';
							|en = 'Check the request processing (%1 sec. left)'");
	ТекстЗаголовка = СтрЗаменить(ТекстЗаголовка, "%1", Строка(ВремяОжиданияСек));
	Элементы.НадписьОбновить.Заголовок = ТекстЗаголовка;
	
КонецПроцедуры

// Обрабатывает ожидание обновления статуса заявки
&НаКлиенте
Процедура ОбработчикОжиданияОбновленияСтатусаЭДО()
	
	Если ВремяОжиданияСек < 1 Тогда
		
		ОтключитьОбработчикОжидания("ОбработчикОжиданияОбновленияСтатусаЭДО");
		// Обновить статус заявки
		Подключение1СТакскомКлиент.ОбработатьКомандуФормы(
			КонтекстВзаимодействия,
			ЭтотОбъект,
			"getApplicationStatus");
		
	Иначе
		
		ВремяОжиданияСек = ВремяОжиданияСек - 1;
		УстановитьНадписьНаГиперссылкеОбновленияСтатуса();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
