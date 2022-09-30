#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьНачисленияОтпускаИКомпенсации();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ОтпускБезОплаты Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "СпособРасчетаОтпуска");
	КонецЕсли;
	
	Если Не ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.НеЗависит") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоДнейВГод");
	КонецЕсли;
	
	Если Недействителен И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,"Недействителен") = Ложь Тогда
		ПроверитьАктуальностьОтпуска(Отказ);
	КонецЕсли;
	
	Если Не ХарактерЗависимостиДнейОтпуска = ПредопределенноеЗначение("Перечисление.ХарактерЗависимостиКоличестваДнейОтпуска.ЗависитОтСтажа") Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидСтажа");
	КонецЕсли;
	
	Если Не ОтпускЯвляетсяЕжегодным Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "КоличествоДнейВГод");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ОбъектКопирования.Предопределенный Тогда
		ОтпускЯвляетсяЕжегодным 			= Неопределено;
		СпособРасчетаОтпуска 				= Неопределено;
		ПредоставлятьОтпускВсемСотрудникам 	= Неопределено;
		КоличествоДнейВГод 					= Неопределено;
		ОтпускБезОплаты 					= Неопределено;
		Недействителен 						= Ложь;
		ОсновнойОтпуск 						= Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Метод устанавливает признак необходимости создания начислений для записи вида отпуска.
//  Параметры: 
//		СоздаватьНачисления - булево, если Истина, то начисления будут созданы.
//
Процедура УстановитьНеобходимостьСоздаватьНачислениеОтпуска(СоздаватьНачисления) Экспорт
	ДополнительныеСвойства.Вставить("СоздаватьНачислениеОтпуска", СоздаватьНачисления);
КонецПроцедуры

// Метод устанавливает признак необходимости создания только начислений компенсации отпуска при записи вида отпуска.
//  Параметры: 
//		СоздаватьНачисления - булево, если Истина, то начисления будут созданы.
//
Процедура УстановитьНеобходимостьСоздаватьНачислениеКомпенсацииОтпуска(СоздаватьНачисления) Экспорт
	ДополнительныеСвойства.Вставить("СоздаватьНачислениеКомпенсацииОтпуска", СоздаватьНачисления);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьНачисленияОтпускаИКомпенсации()

	Если Предопределенный И ИмяПредопределенныхДанных <> "ОтпускЗаВредность" Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписанНовыйОбъект = Ложь;
	Если ДополнительныеСвойства.Свойство("ЭтоНовый") Тогда
		ЗаписанНовыйОбъект = ДополнительныеСвойства.ЭтоНовый;
	КонецЕсли;
	
	СоздаватьНачислениеОтпуска = ЗаписанНовыйОбъект;
	Если ДополнительныеСвойства.Свойство("СоздаватьНачислениеОтпуска") Тогда
		СоздаватьНачислениеОтпуска = ДополнительныеСвойства.СоздаватьНачислениеОтпуска;
	КонецЕсли;
	
	СоздаватьНачислениеКомпенсацииОтпуска = ЗаписанНовыйОбъект И ОтпускЯвляетсяЕжегодным И Не ОтпускБезОплаты;
	Если ДополнительныеСвойства.Свойство("СоздаватьНачислениеКомпенсацииОтпуска") Тогда
		СоздаватьНачислениеКомпенсацииОтпуска = ДополнительныеСвойства.СоздаватьНачислениеКомпенсацииОтпуска;
	КонецЕсли;
	
	Если СоздаватьНачислениеОтпуска Или СоздаватьНачислениеКомпенсацииОтпуска Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		ПланыВидовРасчета.Начисления.СоздатьНачисленияОтпускаИКомпенсации(Ссылка, Наименование, СоздаватьНачислениеОтпуска, СоздаватьНачислениеКомпенсацииОтпуска);
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") И Константы.ИспользоватьРасчетСохраняемогоДенежногоСодержания.Получить() Тогда
			НаименованиеОтпуска = Наименование + " " +НСтр("ru = '(сохр. ден. содержание)';
															|en = '(retain. monet. pay)'");
			ПланыВидовРасчета.Начисления.СоздатьНачисленияОтпускаИКомпенсации(Ссылка, НаименованиеОтпуска, СоздаватьНачислениеОтпуска, СоздаватьНачислениеКомпенсацииОтпуска,,,,Истина);
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;

КонецПроцедуры

// Проверяет наличие актуальных позиций штатного расписания, использующих данный вид отпуска
//	и положенных видов отпусков сотрудников, в случае наличия таковых - устанавливает Отказ = Истина
//	и выводит предупреждения пользователю.
Процедура ПроверитьАктуальностьОтпуска(Отказ)
	
	Запрос = Новый Запрос;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ
		|	ШтатноеРасписание.Наименование КАК ПозицияШтатногоРасписания,
		|	ШтатноеРасписание.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШтатноеРасписание.ЕжегодныеОтпуска КАК ШтатноеРасписаниеЕжегодныеОтпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|		ПО ШтатноеРасписаниеЕжегодныеОтпуска.Ссылка = ШтатноеРасписание.Ссылка
		|ГДЕ
		|	ШтатноеРасписаниеЕжегодныеОтпуска.ВидЕжегодногоОтпуска = &Ссылка
		|	И НЕ ШтатноеРасписание.ПометкаУдаления
		|	И ШтатноеРасписание.Утверждена
		|	И НЕ ШтатноеРасписание.Закрыта
		|;
		|////////////////////////////////////////////////////////////////////////////////";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
		|ВЫБРАТЬ
		|	ПоложенныеВидыЕжегодныхОтпусковСрезПоследних.Сотрудник КАК Ссылка,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПоложенныеВидыЕжегодныхОтпусковСрезПоследних.Сотрудник) КАК СотрудникНаименование
		|ИЗ
		|	РегистрСведений.ПоложенныеВидыЕжегодныхОтпусков.СрезПоследних(&Дата, ВидЕжегодногоОтпуска = &Ссылка) КАК ПоложенныеВидыЕжегодныхОтпусковСрезПоследних";
	
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса());
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ВыводитьСообщениеОбОшибке = Ложь;
	
	Для каждого РезультатЗапроса Из РезультатыЗапроса Цикл
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Отказ = Истина;
			ВыводитьСообщениеОбОшибке = Истина;
		КонецЕсли;
	КонецЦикла; 
	
	Если ВыводитьСообщениеОбОшибке Тогда
		
		ТекстСообщения = НСтр("ru = 'Нельзя сделать недействительным вид отпуска,
		| который связан с актуальными правами на отпуск сотрудников или используется в действующей позиции штатного расписания.';
		|en = 'You cannot make invalid a leave kind
		|which is related to relevant leave entitlement of employees or used in a valid staff list position.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, , , Отказ);	
		
		Выборка = РезультатыЗапроса[РезультатыЗапроса.Количество()-1].Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекстСообщения = НСтр("ru = '- право на отпуск сотрудника ""%1""';
									|en = '- leave entitlement of the ""%1"" employee '");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.СотрудникНаименование);
	        ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Недействителен" , , Отказ);
		КонецЦикла;	
		
		Если ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание") Тогда
		
			Выборка = РезультатыЗапроса[РезультатыЗапроса.Количество()-2].Выбрать();
			Пока Выборка.Следующий() Цикл
				ТекстСообщения = НСтр("ru = '- позиция штатного расписания ""%1""';
										|en = '- the ""%1"" staff list position'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстСообщения,
				Выборка.ПозицияШтатногоРасписания);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.Недействителен" , , Отказ);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли