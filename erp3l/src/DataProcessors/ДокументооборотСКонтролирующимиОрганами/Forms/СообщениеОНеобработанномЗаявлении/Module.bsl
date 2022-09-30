
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаОбъект 	= Параметры.СсылкаНаОбъект;
	Заявление 		= Параметры.Заявление;
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	ВидОбъекта = ДлительнаяОтправкаКлиентСервер.ВидОбъекта(СсылкаНаОбъект);
	
	Если ВидОбъекта.ЭтоПисьмо Тогда
		Заголовок = НСтр("ru = 'Письмо не может быть отправлено';
						|en = 'Cannot send the email'");
	ИначеЕсли ВидОбъекта.ЭтоОтветНаТребование Тогда
		Заголовок = НСтр("ru = 'Ответ на требование не может быть отправлен';
						|en = 'Cannot send the response to the request'");
	ИначеЕсли ВидОбъекта.ЭтоПакетСДопДокументами Тогда
		Заголовок = ДокументооборотСКОКлиентСервер.ПредставлениеПакетаСДопДокументами() + НСтр("ru = ' не может быть отправлен';
																								|en = ' cannot be sent'");
	ИначеЕсли ВидОбъекта.ЭтоСверка Тогда
		Заголовок = НСтр("ru = 'Запрос на сверку не может быть отправлен';
						|en = 'Cannot sent the reconciliation request'");
	ИначеЕсли ВидОбъекта.ЭтоЕГРЮЛ Тогда
		Заголовок = НСтр("ru = 'Запрос на выписку не может быть отправлен';
						|en = 'Cannot send the request for an extract'");
	ИначеЕсли ВидОбъекта.ЭтоМакетПФР Тогда
		Заголовок = НСтр("ru = 'Макет пенсионных дел не может быть отправлен';
						|en = 'Cannot send a pension file template'");
	ИначеЕсли ВидОбъекта.ЭтоЗаявлениеОПенсии Тогда
		Заголовок = НСтр("ru = 'Заявление о назначении и доставке пенсии не может быть отправлено';
						|en = 'Cannot send the application about award and delivery of pension'");
	Иначе
		Заголовок = НСтр("ru = 'Отчет не может быть отправлен';
						|en = 'Cannot send the report'");
	КонецЕсли;
	
	ЭтоРежимБесплатнойНулевойОтчетности = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ЭтоРежимБесплатнойНулевойОтчетности();
	
	Если ЭтоРежимБесплатнойНулевойОтчетности Тогда
		Элементы.Рекомендация.ТекущаяСтраница = Элементы.БизнесСтарт;
	Иначе
		Элементы.Рекомендация.ТекущаяСтраница = Элементы.ОбщийРежим;
	КонецЕсли;
	
	// Представление заявления
	КонтекстЭДОСервер  =  ДокументооборотСКО.ПолучитьОбработкуЭДО();
	КонтекстЭДОСервер.УстановитьПредставлениеЗаявленияВВидеФорматированнойСтроки(Заявление, Элементы.ИнформацияПоЗаявлению);
	
КонецПроцедуры

#КонецОбласти