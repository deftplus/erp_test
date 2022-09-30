#Область СлужебныйПрограммныйИнтерфейс

// Устанавливает признак наличия гражданства на форме
//
// Параметры:
//  Форма            - ФормаКлиентскогоПриложения
//  ДанныеСправки    - ДанныеФормыСтруктура
//
Процедура УстановитьПризнакНаличияГражданства(Форма, ДанныеСправки) Экспорт
	Если ДанныеСправки.Гражданство = ПредопределенноеЗначение("Справочник.СтраныМира.ПустаяСсылка") Тогда
		Форма.ЛицоБезГражданства = 1;
		Форма.Элементы.Гражданство.Доступность = Ложь;
	Иначе
		Форма.ЛицоБезГражданства = 0;
		Форма.Элементы.Гражданство.Доступность = Истина;
	КонецЕсли;			
КонецПроцедуры

// Устанавливает свойств для фиксированных элементов
//
// Параметры:
//  Форма            - ФормаКлиентскогоПриложения
//  ДанныеСправки    - ДанныеФормыСтруктура
//  ДокументПроведен - Булево
//
Процедура УстановитьСвойстваЭлементовСФиксациейДанных(Форма, ДанныеСправки, ДокументПроведен = Ложь) Экспорт
	ИменаФиксируемыхПолей = ИменаФиксируемыхПолей();
	
	ЕстьФиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ИменаФиксируемыхПолей Цикл
		УстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен);	
		
		ЕстьФиксированныеДанные = ЕстьФиксированныеДанные Или ДанныеСправки["Фикс" + ИмяПоля];
	КонецЦикла;	
	
	Форма.Элементы.ОтменитьИсправленияДанныхСотрудника.Доступность = ЕстьФиксированныеДанные;
КонецПроцедуры

// Устанавливает соответствующую надпись в зависимости от документа вызова, 
// наличия фиксированных данных и проведенности документа.
//
// Параметры:
//  Инфонадпись          - Строка	 - текущая надпись
//  ДанныеСправки		 - ДанныеФормыСтруктура
//  ДокументПроведен	 - Булево
//  ДляНалогаНаПрибыль	 - Булево
//
Процедура УстановитьИнфонадписьИсправления(Инфонадпись, ДанныеСправки, ДокументПроведен = Ложь, ДляНалогаНаПрибыль = Ложь) Экспорт
	ФиксируемыеПоля = ИменаФиксируемыхПолей();
	
	ЕстьЗафиксированныеДанные = Ложь;
	Для Каждого ИмяПоля Из ФиксируемыеПоля Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] Тогда	
			ЕстьЗафиксированныеДанные = Истина;
		КонецЕсли;	
	КонецЦикла;
	
	Если ДляНалогаНаПрибыль Тогда
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru = 'Документ проведен, данные получателя дохода зафиксированы и могут отличаться от данных в его карточке';
								|en = 'The document is posted, income recipient data is registered and can differ from their card data'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru = 'Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке получателя дохода';
								|en = 'The data shown in bold type was recorded in the document and may differ from information in the income recipient card'");	
		Иначе
			Инфонадпись = НСтр("ru = 'Данные о получателе дохода берутся из его карточки автоматически.';
								|en = 'Data on income recipient is automatically taken from their card.'");		
		КонецЕсли;	
	Иначе
		Если ДокументПроведен Тогда
			Инфонадпись = НСтр("ru = 'Документ проведен, данные сотрудника зафиксированы и могут отличаться от данных в карточке сотрудника';
								|en = 'The document is posted, income employee data is registered and can differ from their card data'");	
		ИначеЕсли ЕстьЗафиксированныеДанные Тогда
			Инфонадпись = НСтр("ru = 'Выделенные жирным шрифтом данные были зафиксированы в документе и могут отличаться от данных в карточке сотрудника';
								|en = 'The data shown in bold type was recorded in the document and may differ from information in the employee card'");	
		Иначе
			Инфонадпись = НСтр("ru = 'Данные о сотруднике берутся из карточки сотрудника автоматически.';
								|en = 'Data on employee is automatically taken from their card.'");		
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИменаФиксируемыхПолей() Экспорт
	ЗаполняемыеПоля = Новый Массив;
	ЗаполняемыеПоля.Добавить("ИНН");
	ЗаполняемыеПоля.Добавить("Фамилия");
	ЗаполняемыеПоля.Добавить("Имя");
	ЗаполняемыеПоля.Добавить("Отчество");
	ЗаполняемыеПоля.Добавить("Адрес");
	ЗаполняемыеПоля.Добавить("ВидДокумента");
	ЗаполняемыеПоля.Добавить("СерияДокумента");
	ЗаполняемыеПоля.Добавить("НомерДокумента");
	ЗаполняемыеПоля.Добавить("СтранаВыдачиДокумента");
	ЗаполняемыеПоля.Добавить("Гражданство");
	ЗаполняемыеПоля.Добавить("ДатаРождения");
	ЗаполняемыеПоля.Добавить("СтатусНалогоплательщика");
	ЗаполняемыеПоля.Добавить("АдресЗарубежом");	
	
	Возврат ЗаполняемыеПоля;
КонецФункции

Процедура УстановитьСвойстваЭлементаФиксируемыхДанных(Форма, ДанныеСправки, ИмяПоля, ДокументПроведен = Ложь)
	Элементы = Новый Массив;
	Элементы.Добавить(Форма.Элементы[ИмяПоля]);
	Если ИмяПоля = "Гражданство" Тогда
		Элементы.Добавить(Форма.Элементы["ЛицоБезГражданства"]);
		ИННвСтранеГражданства = Форма.Элементы.Найти("ИННвСтранеГражданства");
		Если ИННвСтранеГражданства <> Неопределено Тогда
			Элементы.Добавить(ИННвСтранеГражданства);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ДанныеСправки["Фикс" + ИмяПоля] 
			И Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;
			
		ИначеЕсли Элемент.ОтображениеПредупрежденияПриРедактировании =  ОтображениеПредупрежденияПриРедактировании.НеОтображать
			И Не ДанныеСправки["Фикс" + ИмяПоля] И Не ДокументПроведен Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать;	
		ИначеЕсли ДокументПроведен И Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.Отображать Тогда
			
			Элемент.ОтображениеПредупрежденияПриРедактировании = ОтображениеПредупрежденияПриРедактировании.НеОтображать;	
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры	

#КонецОбласти