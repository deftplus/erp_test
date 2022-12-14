
#Область СлужебныйПрограммныйИнтерфейс

//Возвращает максимальный размер принимаемого файла сервисом в байтах.
Функция МаксимальныйРазмерПринимаемогоФайла() Экспорт
	Возврат 5242880;
КонецФункции

// См. УправлениеПечатьюКлиентПереопределяемый.ПечатьДокументовВыполнитьКоманду
//
Процедура ПечатьДокументовВыполнитьКоманду(Форма, Команда, ПродолжитьВыполнениеНаСервере, ДополнительныеПараметры) Экспорт
	
	Если Команда.Имя = "ПередатьПодписанныеPDFВСервисКабинетСотрудника" Тогда
		КадровыйЭДОКлиент.ПодписатьПечатныеФомыПриПечати(Форма,
			ПредопределенноеЗначение("Перечисление.ДействияСПечатнымиФормами.ПередатьВКабинетСотрудников"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьНавигационнуюСсылкуПодробноОСервисе() Экспорт
	
	ИнформационнаяСсылка = "https://welcome.1c-cabinet.ru/app/info?state=about";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИнформационнаяСсылка);

КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуОписаниеДоступаКДанным() Экспорт

	ИнформационнаяСсылка = "https://welcome.1c-cabinet.ru/app/info?state=security";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИнформационнаяСсылка);	

КонецПроцедуры

Процедура ОткрытьНавигационнуюСсылкуПоддерживаемыеБраузеры() Экспорт

	ИнформационнаяСсылка = "https://welcome.1c-cabinet.ru/app/info?state=technicalinfo";
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(ИнформационнаяСсылка);

КонецПроцедуры

Функция ТекстСообщенияОБлокировкеСервиса() Экспорт

	Возврат НСтр("ru = 'Доступ к сервису ограничен: закончился оплаченный (тестовый) период или превышен оплаченный лимит на создание личных кабинетов.';
				|en = 'Service access is restricted: the paid (test) period has ended or the paid limit for creating accounts has been exceeded.'");

КонецФункции

Функция ОписаниеКнопокВопроса() Экспорт

	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Продолжить';
												|en = 'Continue'"));
	Кнопки.Добавить(КодВозвратаДиалога.Отмена);
	
	Возврат Кнопки

КонецФункции

#КонецОбласти


