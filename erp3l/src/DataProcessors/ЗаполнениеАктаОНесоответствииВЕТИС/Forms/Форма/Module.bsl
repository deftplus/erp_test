#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораПричиныНесоответствия();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,Параметры,"ДатаАктаНесоответствия,НомерАктаНесоответствия,Основание,ПричинаНесоответствия,СерияАктаНесоответствия");
	
	Если НЕ ЗначениеЗаполнено(ПричинаНесоответствия) Тогда
		Если ТипЗнч(Основание) = Тип("ДокументСсылка.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
			ПричинаНесоответствия = Элементы.ПричинаНесоответствия.СписокВыбора[0].Значение;
		Иначе
			ПричинаНесоответствия = Элементы.ПричинаНесоответствия.СписокВыбора[1].Значение;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьВыявленныеНесоответствия();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ЗаполнениеКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = ИнтеграцияВЕТИСКлиентСервер.ПараметрыФормыАктаОНесоответствииВЕТИС(Ложь);
	ЗаполнитьЗначенияСвойств(Реквизиты,ЭтотОбъект);
	Закрыть(Реквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция  ЗаполнениеКорректно()
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	
	Если НЕ ЗначениеЗаполнено(НомерАктаНесоответствия) Тогда
		ТекстОшибки = НСтр("ru = 'Не указан номер акта несоответствия';
							|en = 'Не указан номер акта несоответствия'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"НомерАктаНесоответствия",
			,
			Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаАктаНесоответствия) Тогда
		ТекстОшибки = НСтр("ru = 'Не указана дата акта несоответствия';
							|en = 'Не указана дата акта несоответствия'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"ДатаАктаНесоответствия",
			,
			Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПричинаНесоответствия)Тогда 
		ТекстОшибки = НСтр("ru = 'Не указана причина несоответствия';
							|en = 'Не указана причина несоответствия'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"ПричинаНесоответствия",
			,
			Отказ);
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции
	
&НаСервере
Процедура ЗаполнитьВыявленныеНесоответствия()
	
	ВыявленныеНесоответствия.Очистить();
	Если Основание = Неопределено Тогда
		Возврат;
	ИначеЕсли Основание.Пустая() Тогда
		Возврат;
	КонецЕсли;
	ДанныеДокумента = Документы[Основание.Метаданные().Имя].ПолучитьДанныеДляПечатнойФормыАктаОНесоответствии(Неопределено,Основание);
	
	ПараметрыПечати = Новый Структура("ИмяМакета,ТолькоТаблицыРасхождений","Обработка.ЗаполнениеАктаОНесоответствииВЕТИС.ПФ_MXL_АктОНесоответствии_Сжатый");
	
	ОбъектыПечати = Новый СписокЗначений;
	ОбъектыПечати.Добавить(Основание);
	Обработки.ЗаполнениеАктаОНесоответствииВЕТИС.ЗаполнитьТабличныйДокументАктОНесоответствииВЕТИС(ВыявленныеНесоответствия,ДанныеДокумента,ОбъектыПечати,ПараметрыПечати);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораПричиныНесоответствия()
	
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Выпуск живых животных и рыбы в естественную среду обитания';
			|en = 'Выпуск живых животных и рыбы в естественную среду обитания'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Приемка продукции, поступившей по бумажному ветеринарному сертификату или без ВСД';
			|en = 'Приемка продукции, поступившей по бумажному ветеринарному сертификату или без ВСД'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Сопоставление фактически имеющейся продукции с учетными данными (выявление отклонений)';
			|en = 'Сопоставление фактически имеющейся продукции с учетными данными (выявление отклонений)'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Списание остатков в случае естественной убыли продукции (усушка, выветривание, таяние и т.д.)';
			|en = 'Списание остатков в случае естественной убыли продукции (усушка, выветривание, таяние и т.д.)'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Списание остатков в случае технологических потерь продукции (порча, бой, хищение и т.д.)';
			|en = 'Списание остатков в случае технологических потерь продукции (порча, бой, хищение и т.д.)'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Списание остатков в случае ошибочного гашения ветеринарных сертификатов (задублированные сертификаты)';
			|en = 'Списание остатков в случае ошибочного гашения ветеринарных сертификатов (задублированные сертификаты)'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Списание остатков, не предназначенных для реализации (использование продукции для внутреннего потребления сотрудниками, в зарплату сотрудникам и т.д.';
			|en = 'Списание остатков, не предназначенных для реализации (использование продукции для внутреннего потребления сотрудниками, в зарплату сотрудникам и т.д.'"));
	Элементы.ПричинаНесоответствия.СписокВыбора.Добавить(
		НСтр("ru = 'Списание остатков, реализуемых физическому лицу для личного потребления в предприятиях розничной торговли';
			|en = 'Списание остатков, реализуемых физическому лицу для личного потребления в предприятиях розничной торговли'"));
	
КонецПроцедуры

#КонецОбласти