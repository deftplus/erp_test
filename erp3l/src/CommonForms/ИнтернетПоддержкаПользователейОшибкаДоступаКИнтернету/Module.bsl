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
	
	МестоЗапуска = Параметры.МестоЗапуска;
	
	Элементы.НадписьСообщенияВТехПоддержку.Заголовок =
		ИнтернетПоддержкаПользователейКлиентСервер.ФорматированныйЗаголовок(
			ИнтернетПоддержкаПользователейКлиентСервер.ПодставитьДомен(
				НСтр("ru = '<body>При возникновении проблем отправьте письмо по адресу <a href=""SendMail"">webits-info@1c.ru</a></body>';
					|en = '<body>If any issues occur, send an email to <a href=""SendMail"">webits-info@1c.ru</a></body>'"),
				ИнтернетПоддержкаПользователей.НастройкиСоединенияССерверами().ДоменРасположенияСерверовИПП));
	
	ОписаниеОшибки = Параметры.ОписаниеОшибки;
	ОписаниеОшибкиЗаполнено = НЕ ПустаяСтрока(ОписаниеОшибки);
	КлючСохраненияПоложенияОкна = МестоЗапуска + Строка(ОписаниеОшибкиЗаполнено);
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ПодробноеОписаниеОшибки, ПриНачалеРаботыСистемы, Логин");
	
	Если ТипЗнч(Параметры.СтартовыеПараметры) = Тип("Структура") Тогда
		СтартовыеПараметры = Параметры.СтартовыеПараметры;
	Иначе
		СтартовыеПараметры = Новый Структура;
	КонецЕсли;
	
	Элементы.ОписаниеОшибки.Видимость = ОписаниеОшибкиЗаполнено;
	
	Если Параметры.ПриНачалеРаботыСистемы Тогда
		ЗапускатьПриСтарте = Истина;
	Иначе
		Элементы.ЗапускатьПриСтарте.Видимость = Ложь;
	КонецЕсли;
	
	// Настройка внешнего вида формы
	Если КлиентскоеПриложение.ТекущийВариантИнтерфейса() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ГруппаЗаголовка.Отображение           = ОтображениеОбычнойГруппы.СлабоеВыделение;
		Элементы.ГруппаИнформационнойЧасти.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
	КонецЕсли;
	
	Элементы.НадписьСообщенияВТехПоддержку.Видимость = ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НадписьСообщенияВТехПоддержкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "SendMail" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если МестоЗапуска = "handStartNew"
			Или МестоЗапуска = "systemStartNew" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к монитору Интернет-поддержки.';
						|en = 'Online support. Contact online support dashboard.'");
			Тело = НСтр("ru = 'Возникает ошибка обращения к монитору Интернет-поддержки.';
						|en = 'An error occurs when contacting Online support dashboard.'");
			
		ИначеЕсли МестоЗапуска = "taxcomGetID" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к 1С-Такском';
						|en = 'Online support. Contact 1C:Taxcom'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису получения идентификатора 1С-Такском.';
						|en = 'An error occurs when contacting the service of 1C:Taxcom ID receipt.'");
			
		ИначеЕсли МестоЗапуска = "taxcomPrivat" Тогда
			
			Тема = НСтр("ru = 'Интернет-поддержка. Обращение к 1С-Такском';
						|en = 'Online support. Contact 1C:Taxcom'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису получения идентификатора 1С-Такском.';
						|en = 'An error occurs when contacting the service of 1C:Taxcom ID receipt.'");
			
		Иначе
			
			// В случае, если имя бизнес-процесса не было передано до возникновения ошибки
			Тема = НСтр("ru = 'Интернет-поддержка. Ошибка обращения к сервису';
						|en = 'Online support. Service request error'");
			Тело = НСтр("ru = 'Возникает ошибка при обращении к сервису Интернет-поддержки.';
						|en = 'An error occurs when contacting the online support service.'");
			
		КонецЕсли;
		
		
		Если Не ПустаяСтрока(ПодробноеОписаниеОшибки) Тогда
			Тело = Тело + Символы.ПС + НСтр("ru = 'Описание ошибки:';
											|en = 'Error details:'")
				+ Символы.ПС + ПодробноеОписаниеОшибки;
		ИначеЕсли Не ПустаяСтрока(ОписаниеОшибки) Тогда
			Тело = Тело + Символы.ПС + НСтр("ru = 'Описание ошибки:';
											|en = 'Error details:'")
				+ Символы.ПС + ОписаниеОшибки;
		КонецЕсли;
		
		ДанныеСообщения = Новый Структура;
		ДанныеСообщения.Вставить("Получатель", "webIts");
		ДанныеСообщения.Вставить("Тема",       Тема);
		ДанныеСообщения.Вставить("Сообщение",  Тело);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускатьПриСтартеПриИзменении(Элемент)
	
	УстановитьНастройкуЗапускатьПриСтарте(ЗапускатьПриСтарте);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияИнформационнойЧастиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "open:log" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя()));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПовторитьПопыткуПодключения(Команда)
	
	Закрыть();
	Подключение1СТакскомКлиент.ВыполнитьСценарий(
		МестоЗапуска,
		СтартовыеПараметры,
		Истина,
		?(КонтекстВзаимодействия = Неопределено Или Не КонтекстВзаимодействия.Свойство("ДопПараметрыДляПовтораБизнесПроцесса"),
			Неопределено,
			КонтекстВзаимодействия.ДопПараметрыДляПовтораБизнесПроцесса));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьНастройкуЗапускатьПриСтарте(ЗначениеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ИнтернетПоддержкаПользователей",
		"ВсегдаПоказыватьПриСтартеПрограммы",
		ЗначениеНастройки);
	
КонецПроцедуры

#КонецОбласти
