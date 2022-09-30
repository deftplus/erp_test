#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	КадровыйУчетРасширенныйВызовСервера.ОбработкаПолученияДанныхВыбораСправочникаВидыОтпусков(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Или ВидФормы = "ФормаСписка" Тогда
		ПараметрИзменен = Ложь;
		
		Если Не Параметры.Свойство("Отбор") Тогда
			Параметры.Вставить("Отбор", Новый Структура("Недействителен", Ложь));
			ПараметрИзменен = Истина;
		ИначеЕсли Не Параметры.Отбор.Свойство("Недействителен") Тогда
			Параметры.Отбор.Вставить("Недействителен", Ложь);
			ПараметрИзменен = Истина;
		КонецЕсли;
		
		// Этот код нужен, чтобы были использованы измененные нами значения параметров.
		Если ПараметрИзменен Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСписка"; // передаем имя формы выбора
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыВыбораВидаОтпуска() Экспорт
	
	ПараметрыВыбора = Новый Структура(
		"Отбор_ОтпускЯвляетсяЕжегодным,
		|Отбор_ОтпускБезОплаты, 
		|Дополнительно_СоздаватьНачисления, 
		|Отбор_ИсключатьОтпускНаСанаторноКурортноеЛечение");
	
	ПараметрыВыбора.Отбор_ОтпускЯвляетсяЕжегодным = Истина;
	ПараметрыВыбора.Отбор_ОтпускБезОплаты = Ложь;
	ПараметрыВыбора.Отбор_ИсключатьОтпускНаСанаторноКурортноеЛечение = Истина;
	ПараметрыВыбора.Дополнительно_СоздаватьНачисления = Ложь;
	
	Возврат ПараметрыВыбора;
	
КонецФункции

#Область БлокФункцийПервоначальногоЗаполненияИОбновленияИБ

// Процедура создает виды отпусков в зависимости от настроек расчета зарплаты.
//  Параметры: 
//		ПараметрыПланаВидовРасчета - см. РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета.
//
Процедура СоздатьВидыОтпусковПоНастройкам(ПараметрыПланаВидовРасчета = Неопределено, НастройкиРасчетаЗарплаты = Неопределено) Экспорт
	
	Если ПараметрыПланаВидовРасчета = Неопределено Тогда
		ПараметрыПланаВидовРасчета = РасчетЗарплатыРасширенный.ОписаниеПараметровПланаВидовРасчета();
	КонецЕсли;
	
	Если НастройкиРасчетаЗарплаты = Неопределено Тогда
		НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	КонецЕсли;
	
	ИспользоватьОтпускаБезОплаты = НастройкиРасчетаЗарплаты.ИспользоватьОтпускаБезОплаты 
									Или Константы.НеИспользоватьНачислениеЗарплаты.Получить();
									
	СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
	
	Если ИспользоватьОтпускаБезОплаты Тогда
		
		ОбновитьПовторноИспользуемыеЗначения();
		
		// Отпуск без оплаты согласно ТК РФ (отпустить обязаны).
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускБезОплатыПоТКРФ);
		
		// Отпуск за свой счет (требуется согласие администрации).
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускЗаСвойСчет);
		
		// Дополнительный учебный отпуск без оплаты.
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускБезОплатыУчебный);
		
	КонецЕсли;
	
	ОбновитьИспользуемостьВидаОтпуска("ОтпускБезОплатыПоТКРФ", ИспользоватьОтпускаБезОплаты);
	ОбновитьИспользуемостьВидаОтпуска("ОтпускЗаСвойСчет", ИспользоватьОтпускаБезОплаты);
	ОбновитьИспользуемостьВидаОтпуска("ОтпускБезОплатыУчебный", ИспользоватьОтпускаБезОплаты);
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаУчебные Тогда
		// Учебный отпуск (оплачиваемый).
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускУчебный);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускУчебный", НастройкиРасчетаЗарплаты.ИспользоватьОтпускаУчебные);
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС Тогда
		// Дополнительный отпуск пострадавшим в аварии на ЧАЭС.
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускПострадавшимВАварииЧАЭС);
		// Дополнительный отпуск пострадавшим в аварии на ЧАЭС (оплачиваемый).
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускПострадавшимВАварииЧАЭСОплачиваемый);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускПострадавшимВАварииЧАЭС", НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС);
	ОбновитьИспользуемостьВидаОтпуска("ОтпускПострадавшимВАварииЧАЭСОплачиваемый", НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС);
	
	// Отпуск за вредные условия труда.
	СоздатьВидОтпускаЗаВредныеУсловияТруда(НастройкиРасчетаЗарплаты, СвойстваВидовОтпусков);	
	
	ДополнительныеОтпуска = ПараметрыПланаВидовРасчета.ДополнительныеОтпуска;
	Для Каждого ДополнительныйОтпуск Из ДополнительныеОтпуска.ДополнительныеОтпуска Цикл
		
		НаименованиеОтпуска = СОКРЛП(ДополнительныйОтпуск.Наименование);
		Если ПустаяСтрока(НаименованиеОтпуска) Тогда
			Продолжить;
		КонецЕсли;
		
		ОтпускСсылка = Справочники.ВидыОтпусков.НайтиПоНаименованию(НаименованиеОтпуска, Истина);
		Если ОтпускСсылка.Пустая() Тогда
			ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
			ОписаниеВидаОтпуска.Наименование			= НаименованиеОтпуска;
			ОписаниеВидаОтпуска.НаименованиеПолное		= НаименованиеОтпуска;
			ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным = ДополнительныйОтпуск.ОтпускЯвляетсяЕжегодным;
			ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам = ДополнительныйОтпуск.ПредоставлятьОтпускВсемСотрудникам;
			ОписаниеВидаОтпуска.КоличествоДнейВГод = ДополнительныйОтпуск.КоличествоДнейВГод;
			ОписаниеВидаОтпуска.СпособРасчетаОтпуска = Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
			ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска = Ложь;
			ОтпускОбъект = НовыйВидОтпуска(ОписаниеВидаОтпуска);
			ОтпускСсылка = ОтпускОбъект.Ссылка;
		КонецЕсли;
		
		ДополнительныйОтпуск.ВидОтпуска = ОтпускСсылка;
		
	КонецЦикла;
	
	Если СвойстваВидовОтпусков.Свойство("ОтпускЗаВыслугуЛетНаГосударственнойСлужбе") Тогда
		// Отпуска за выслугу лет
		НовыйОтпуск = НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускЗаВыслугуЛетНаГосударственнойСлужбе);
		// Заполняем шкалу стажа.
		ТаблицаШкалы = НовыйОтпуск.ШкалаОценкиСтажа;
		Если ТаблицаШкалы.Количество() = 0 Тогда
			Для СчЛет = 1 По 10 Цикл
				НоваяСтрока = ТаблицаШкалы.Добавить();
				НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = СчЛет*12;
				НоваяСтрока.КоличествоДнейВГод = СчЛет-1;
			КонецЦикла; 
			НоваяСтрока = ТаблицаШкалы.Добавить();
			НоваяСтрока.ВерхняяГраницаИнтервалаСтажа = 0;
			НоваяСтрока.КоличествоДнейВГод = 10;
			
			НовыйОтпуск.Записать();
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура СоздатьВидОтпускаЗаВредныеУсловияТруда(НастройкиРасчетаЗарплаты, СвойстваВидовОтпусков = Неопределено) Экспорт
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность Тогда
		Если СвойстваВидовОтпусков = Неопределено Тогда
			СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
		КонецЕсли;
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускЗаВредность);
	КонецЕсли;
	ОбновитьИспользуемостьВидаОтпуска("ОтпускЗаВредность", НастройкиРасчетаЗарплаты.ИспользоватьНадбавкуЗаВредность);
	
КонецПроцедуры

#КонецОбласти

Функция КоличествоВидовОтпуска() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВидыОтпусков.Ссылка) КАК Количество
	|ИЗ
	|	Справочник.ВидыОтпусков КАК ВидыОтпусков
	|ГДЕ
	|	ВидыОтпусков.Предопределенный = ЛОЖЬ");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Количество;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Возвращает виды ежегодных оплачиваемых отпусков
// 
// Возвращаемое значение:
//  - Массив из СправочникСсылка.ВидыОтпусков - виды ежегодных оплачиваемых отпусков.
//
Функция ВидыЕжегодныхОплачиваемыхОтпусков() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыОтпусков.Ссылка КАК ВидОтпуска
		|ИЗ
		|	Справочник.ВидыОтпусков КАК ВидыОтпусков
		|ГДЕ
		|	НЕ ВидыОтпусков.ОтпускБезОплаты
		|	И ВидыОтпусков.ОтпускЯвляетсяЕжегодным";
	
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидОтпуска");
	
	Возврат Результат;
	
КонецФункции

Функция СвойстваПредопределенныхВидовОтпусков() Экспорт
	
	СвойстваВидовОтпусков = Новый Структура;
	
	// Основной
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска			= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных			= "Основной";
	ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'Основной';
																	|en = 'Main'");
	ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Основной отпуск';
																	|en = 'Basic leave'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска				= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхИлиРабочихДняхВЗависимостиОтТрудовогоДоговора;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным				= Истина;
	ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Истина;
	ОписаниеВидаОтпуска.КоличествоДнейВГод					= 28;
	ОписаниеВидаОтпуска.ОсновнойОтпуск						= Истина;
	СвойстваВидовОтпусков.Вставить("Основной", ОписаниеВидаОтпуска);
	
	// Отпуск за вредность
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускЗаВредность";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск за вредность';
															|en = 'Leave for harmful conditions'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск за вредность';
															|en = 'Leave for harmful conditions'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтРабочегоМеста");
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
	ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Ложь;
	ОписаниеВидаОтпуска.КоличествоДнейВГод			= 0;
	СвойстваВидовОтпусков.Вставить("ОтпускЗаВредность", ОписаниеВидаОтпуска);
	
	// Северный
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "Северный";
	ОписаниеВидаОтпуска.Наименование 				= НСтр("ru = 'Северный';
															|en = 'Northern'");
	ОписаниеВидаОтпуска.НаименованиеПолное 			= НСтр("ru = 'Северный';
																|en = 'Northern'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтРабочегоМеста");
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным 	= Истина;
	ОписаниеВидаОтпуска.КоличествоДнейВГод 			= 0;
	СвойстваВидовОтпусков.Вставить("Северный", ОписаниеВидаОтпуска);
	
	// Отпуск на санаторно-курортное лечение
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускНаСанаторноКурортноеЛечение";
	ОписаниеВидаОтпуска.Наименование 				= НСтр("ru = 'Отпуск на период санаторно-курортного лечения (за счет ФСС)';
															|en = 'Health resort treatment leave (out of SSF funds)'");
	ОписаниеВидаОтпуска.НаименованиеПолное 			= НСтр("ru = 'Отпуск на СКЛ (за счет ФСС)';
																|en = 'HRT leave (at SSF expense)'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным 	= Ложь;
	СвойстваВидовОтпусков.Вставить("ОтпускНаСанаторноКурортноеЛечение", ОписаниеВидаОтпуска);
	
	// Отпуск без оплаты согласно ТК РФ (отпустить обязаны).
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускБезОплатыПоТКРФ";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 2 статьи 128 ТК РФ';
															|en = 'Unpaid leave according to part 2 of article 128 of the Labor Code of the Russian Federation'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 2 статьи 128 ТК РФ';
															|en = 'Unpaid leave according to part 2 of article 128 of the Labor Code of the Russian Federation'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
	СвойстваВидовОтпусков.Вставить("ОтпускБезОплатыПоТКРФ", ОписаниеВидаОтпуска);
	
	// Отпуск за свой счет (требуется согласие администрации).
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускЗаСвойСчет";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 1 статьи 128 ТК РФ';
															|en = 'Unpaid leave according to part 1 of article 128 of the Labor Code of the Russian Federation'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Отпуск без оплаты в соотв. с частью 1 статьи 128 ТК РФ';
															|en = 'Unpaid leave according to part 1 of article 128 of the Labor Code of the Russian Federation'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
	СвойстваВидовОтпусков.Вставить("ОтпускЗаСвойСчет", ОписаниеВидаОтпуска);
		
	// Дополнительный учебный отпуск без оплаты.
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускБезОплатыУчебный";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный учебный отпуск без оплаты';
															|en = 'Excess study leave (unpaid)'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный учебный отпуск без оплаты';
															|en = 'Excess study leave (unpaid)'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
	СвойстваВидовОтпусков.Вставить("ОтпускБезОплатыУчебный", ОписаниеВидаОтпуска);
	
	// Отпуск учебный (оплачиваемый).
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускУчебный";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный учебный отпуск (оплачиваемый)';
															|en = 'Excess study leave (paid)'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный учебный отпуск (оплачиваемый)';
															|en = 'Excess study leave (paid)'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Ложь;
	СвойстваВидовОтпусков.Вставить("ОтпускУчебный", ОписаниеВидаОтпуска);
	
	// Отпуск пострадавшим в аварии на ЧАЭС.
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускПострадавшимВАварииЧАЭС";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный неоплачиваемый отпуск пострадавшим на ЧАЭС';
															|en = 'Excess unpaid leaves for citizens exposed to radiation at the Chernobyl NPP'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный неоплачиваемый отпуск пострадавшим в аварии на ЧАЭС';
															|en = 'Excess unpaid leaves for citizens exposed to radiation at the Chernobyl NPP'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.КоличествоДнейВГод			= 14;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Истина;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
	СвойстваВидовОтпусков.Вставить("ОтпускПострадавшимВАварииЧАЭС", ОписаниеВидаОтпуска);
	
	// Отпуск пострадавшим в аварии на ЧАЭС (оплачиваемый)
	ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
	ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска 	= Истина;
	ОписаниеВидаОтпуска.ИмяПредопределенныхДанных 	= "ОтпускПострадавшимВАварииЧАЭСОплачиваемый";
	ОписаниеВидаОтпуска.Наименование				= НСтр("ru = 'Дополнительный оплачиваемый отпуск пострадавшим на ЧАЭС';
															|en = 'Excess paid leaves for citizens exposed to radiation at the Chernobyl NPP'");
	ОписаниеВидаОтпуска.НаименованиеПолное			= НСтр("ru = 'Дополнительный оплачиваемый отпуск пострадавшим в аварии на ЧАЭС';
															|en = 'Excess paid leaves for citizens exposed to radiation at the Chernobyl NPP'");
	ОписаниеВидаОтпуска.СпособРасчетаОтпуска 		= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхДнях;
	ОписаниеВидаОтпуска.КоличествоДнейВГод			= 14;
	ОписаниеВидаОтпуска.ОтпускБезОплаты				= Ложь;
	ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным		= Истина;
	СвойстваВидовОтпусков.Вставить("ОтпускПострадавшимВАварииЧАЭСОплачиваемый", ОписаниеВидаОтпуска);
	
	// Отпуска за выслугу лет
	НастройкиПрограммы = ЗарплатаКадрыРасширенный.НастройкиПрограммыБюджетногоУчреждения();
	Если НастройкиПрограммы.РаботаВБюджетномУчреждении 
		И (НастройкиПрограммы.ИспользоватьГосударственнуюСлужбу Или НастройкиПрограммы.ИспользоватьМуниципальнуюСлужбу) Тогда
		
		ОписаниеВидаОтпуска = ПустоеОписаниеВидаОтпуска();
		ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска			= Истина;
		ОписаниеВидаОтпуска.ИмяПредопределенныхДанных			= "ОтпускЗаВыслугуЛетНаГосударственнойСлужбе";
		
		Если НастройкиПрограммы.ИспользоватьГосударственнуюСлужбу Тогда
			ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'За выслугу лет на гос. службе';
																			|en = 'For public service seniority'");
			ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Отпуск за выслугу лет на гос. службе';
																			|en = 'Leave for long public service'");
		Иначе
			ОписаниеВидаОтпуска.Наименование						= НСтр("ru = 'За выслугу лет на муниц. службе';
																			|en = 'For municipal service seniority'");
			ОписаниеВидаОтпуска.НаименованиеПолное					= НСтр("ru = 'Отпуск за выслугу лет на муниц. службе';
																			|en = 'Leave for long municip. service'");
		КонецЕсли;
		
		ОписаниеВидаОтпуска.СпособРасчетаОтпуска				= Перечисления.СпособыРасчетаОтпуска.ВКалендарныхИлиРабочихДняхВЗависимостиОтТрудовогоДоговора;
		ОписаниеВидаОтпуска.ОтпускЯвляетсяЕжегодным				= Истина;
		ОписаниеВидаОтпуска.ПредоставлятьОтпускВсемСотрудникам	= Ложь;
		ОписаниеВидаОтпуска.КоличествоДнейВГод					= 0;
		ОписаниеВидаОтпуска.ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтСтажа");
		
		СтажиГосслужащих = Справочники.ВидыСтажа.ВидыСтажаПоКатегории(Перечисления.КатегорииСтажа.ВыслугаЛетНаГосударственнойСлужбе);
		Если СтажиГосслужащих.Количество() > 0 Тогда
			ОписаниеВидаОтпуска.ВидСтажа						= СтажиГосслужащих[0];
		КонецЕсли;
		
		СвойстваВидовОтпусков.Вставить("ОтпускЗаВыслугуЛетНаГосударственнойСлужбе", ОписаниеВидаОтпуска);
		
	КонецЕсли;
	
	Возврат СвойстваВидовОтпусков;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПустоеОписаниеВидаОтпуска()
	
	Возврат Новый Структура("
	|Наименование,
	|НаименованиеПолное,
	|ОтпускБезОплаты,
	|ОтпускЯвляетсяЕжегодным,
	|ПредоставлятьОтпускВсемСотрудникам,
	|КоличествоДнейВГод,
	|СпособРасчетаОтпуска,
	|ПредопределенныйВидОтпуска,
	|ИмяПредопределенныхДанных,
	|ХарактерЗависимостиДнейОтпуска,
	|ВидСтажа,
	|ОсновнойОтпуск");
	
КонецФункции

Функция НовыйВидОтпуска(ОписаниеВидаОтпуска)
	
	ВидОтпускаОбъект = Неопределено;
	Если ОписаниеВидаОтпуска.ПредопределенныйВидОтпуска Тогда 
		ВидОтпускаСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ОписаниеВидаОтпуска.ИмяПредопределенныхДанных);
		Если ВидОтпускаСсылка <> Неопределено Тогда 
			ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
			Возврат ВидОтпускаОбъект;
		КонецЕсли;
	КонецЕсли;
	
	Если ВидОтпускаОбъект = Неопределено Тогда 
		ВидОтпускаОбъект = Справочники.ВидыОтпусков.СоздатьЭлемент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ВидОтпускаОбъект, ОписаниеВидаОтпуска);
	ВидОтпускаОбъект.Записать();
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат ВидОтпускаОбъект;
	
КонецФункции

Процедура ОбновитьИспользуемостьВидаОтпуска(ИмяПредопределенныхДанных, Действителен)
	
	ВидОтпускаСсылка = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков." + ИмяПредопределенныхДанных);
	
	Если ВидОтпускаСсылка <> Неопределено Тогда 
		ВидОтпускаОбъект = ВидОтпускаСсылка.ПолучитьОбъект();
		ВидОтпускаОбъект.Недействителен = Не Действителен;
		ВидОтпускаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

// Процедура устанавливает используемость Северного отпуска.
//
Процедура ОбновитьИспользуемостьСеверногоОтпуска(Действителен) Экспорт
	
	ОбновитьИспользуемостьВидаОтпуска("Северный", Действителен);
	
КонецПроцедуры

// Процедура производит первоначальное заполнение предопределенных видов отпуска.
Процедура ОписатьВидОтпускаОсновнойОтпуск(СвойстваВидовОтпусков = Неопределено) Экспорт

	ОбновитьПовторноИспользуемыеЗначения();
	
	Если СвойстваВидовОтпусков = Неопределено Тогда
		СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
	КонецЕсли;
	
	НовыйВидОтпуска(СвойстваВидовОтпусков.Основной);
	
КонецПроцедуры

// Процедура производит первоначальное заполнение предопределенных видов отпуска.
Процедура ОписатьВидОтпускаСеверныйОтпуск(Действителен = Неопределено, СвойстваВидовОтпусков = Неопределено) Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если Действителен = Неопределено Тогда
		Действителен = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Северный") <> Неопределено;
	КонецЕсли;	
	
	Если Действителен Тогда
		Если СвойстваВидовОтпусков = Неопределено Тогда
			СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
		КонецЕсли;
		НовыйВидОтпуска(СвойстваВидовОтпусков.Северный);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.Северный") <> Неопределено Тогда 
		Справочники.ВидыОтпусков.ОбновитьИспользуемостьСеверногоОтпуска(Действителен);		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОписатьВидОтпускаДополнительныйОтпускНаСанаторноКурортноеЛечение(СвойстваВидовОтпусков = Неопределено) Экспорт
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если СвойстваВидовОтпусков = Неопределено Тогда
		СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
	КонецЕсли;
	
	НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускНаСанаторноКурортноеЛечение);
	
КонецПроцедуры

Процедура ОписатьВидОтпускаДополнительныйОтпускПострадавшимВАварииЧАЭСОплачиваемый(ПараметрыОбновления = Неопределено) Экспорт
	
	НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС Тогда
		СвойстваВидовОтпусков = СвойстваПредопределенныхВидовОтпусков();
		НовыйВидОтпуска(СвойстваВидовОтпусков.ОтпускПострадавшимВАварииЧАЭСОплачиваемый);
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);			
		
КонецПроцедуры

Процедура ИзменитьПредставлениеОтпускПострадавшимВАварииЧАЭС(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	НастройкиРасчетаЗарплаты = РасчетЗарплатыРасширенный.НастройкиРасчетаЗарплаты();
	Если НастройкиРасчетаЗарплаты.ИспользоватьОтпускаДляПострадавшихВАварииЧАЭС Тогда		
		
		ВидОтпускаОтпускПострадавшимВАварииЧАЭС = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускПострадавшимВАварииЧАЭС");
		
		// АПК:1297-выкл Наименования не локализуются, т.к. являются частью регламентированных форм, применяемых в РФ.
		Наименование       = "Дополнительный неоплачиваемый отпуск пострадавшим на ЧАЭС";         
		НаименованиеПолное = "Дополнительный неоплачиваемый отпуск пострадавшим в аварии на ЧАЭС";
		// АПК:1297-вкл
		
		Если ВидОтпускаОтпускПострадавшимВАварииЧАЭС <> Неопределено  
			И ВидОтпускаОтпускПострадавшимВАварииЧАЭС.Наименование <> Наименование Тогда
			
			ОбработкаЗавершена = Ложь;
			
			Если ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "Справочник.ВидыОтпусков", "Ссылка", ВидОтпускаОтпускПострадавшимВАварииЧАЭС) Тогда
				
				ОбъектВидОтпуска = ВидОтпускаОтпускПострадавшимВАварииЧАЭС.ПолучитьОбъект();
				ОбъектВидОтпуска.Наименование       = Наименование;
				ОбъектВидОтпуска.НаименованиеПолное = НаименованиеПолное;
				
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектВидОтпуска);
				
				ОбработкаЗавершена = Истина;
				
				ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
			КонецЕсли;
			
		КонецЕсли;	
				
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", ОбработкаЗавершена);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
