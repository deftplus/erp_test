////////////////////////////////////////////////////////////////////////////////
// Модуль хранит универсальные команды работы с согласованием в контексте 
// клиентского кода.
////////////////////////////////////////////////////////////////////////////////

Процедура Подключаемый_ПринятьКОбработкеЗавершение(РезультатВопроса = Неопределено, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Форма.Прочитать();
	Ссылка = ДополнительныеПараметры.Ссылка;
	
	Если (РезультатВопроса <> Неопределено) Тогда 
		
		Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
			Возврат;			
		Иначе		
			
			Если НЕ Форма.Записать(Новый Структура("РежимЗаписи,НеОтправлятьНаСогласованиеПриПроведении", РежимЗаписиДокумента.Проведение, Истина)) Тогда
				Если ТипЗнч(Ссылка) <> Тип("ДокументСсылка.ЗаявкаНаРасходованиеДенежныхСредств") тогда
					ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Не удалось провести документ!'"),,,,Форма.УникальныйИдентификатор);
				КонецЕсли;
				
				Возврат; //Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	СостояниеЗаявки = МодульУправленияПроцессамиУХ.ПолучитьОбщийСтатусДляСогласования(Ссылка);
	Если (НЕ СостояниеЗаявки = "Утвержден") И (НЕ СостояниеЗаявки = "НаУтверждении") Тогда
		ИмяСобытия = МодульУправленияПроцессамиУХ.ПринятьКОбработке(, Ссылка);	
	Иначе
		// Согласование уже запущено.
	КонецЕсли;
		
	Попытка
		Форма.СостояниеЗаявки = УправлениеПроцессамиСогласованияУХ.ВернутьТекущееСостояние(Форма.Объект.Ссылка);
		Форма.Элементы.Группа_ОбработкаМаршрутаСогласования.ТекущаяСтраница = ?(ЗначениеЗаполнено(Форма.СостояниеЗаявки), Форма.Элементы.МаршрутСогласованияЗапущен, Форма.Элементы.МаршрутСогласованияНеЗапущен);
		Форма.Элементы.ОтменитьСогласование.Доступность = МодульСогласованияДокументовУХ.ЕстьСуперПользователь(ДействияСогласованиеУХСервер.ВернутьЦФОПоОбъекту(Форма.Объект.Ссылка));
		Если НЕ Форма.Элементы.Найти("КартинкаСтатуса") = Неопределено Тогда
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагСиний;
		КонецЕсли;
		Оповестить("СостояниеЗаявкиПриИзменении", Форма.СостояниеЗаявки, Ссылка);
		Оповестить("ОбновитьМоиЗадачиИОповещения");
		Форма.Прочитать();
	Исключение
		Оповестить(ИмяСобытия);		
	КонецПопытки;

КонецПроцедуры

Процедура СнятьСОбработкиЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Форма = ДополнительныеПараметры.Форма;
    
    
    Если ДействияСогласованиеУХСервер.ВозможноПроведениеОбъекта(Форма.Объект.Ссылка) 
        И Форма.Объект.Проведен 
        И РезультатВопроса = КодВозвратаДиалога.Да Тогда
        
        Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
        
    КонецЕсли;

КонецПроцедуры

Процедура ОтменитьСогласованиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Форма = ДополнительныеПараметры.Форма;    
    
    Если ДействияСогласованиеУХСервер.ВозможноПроведениеОбъекта(Форма.Объект.Ссылка) 
        И Форма.Объект.Проведен 
        И РезультатВопроса = КодВозвратаДиалога.Да Тогда
        
        Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
        
    КонецЕсли;

КонецПроцедуры

Процедура ВвестиЗаявкуНаИзменениеЭлемента(Ссылка) Экспорт
	
	ТекЗаявка =  ДействияСогласованиеУХСервер.ПолучитьЗаявкуНСИИзменение(Ссылка); 
	Если ТекЗаявка<>Неопределено Тогда 
		ПоказатьЗначение(, ТекЗаявка);
	КонецЕсли;
		
КонецПроцедуры

Процедура ВвестиЗаявкуНаУдалениеЭлемента(Ссылка) Экспорт
	
	ТекЗаявка =  ДействияСогласованиеУХСервер.ПолучитьЗаявкуНСИУдаление(Ссылка); 
	Если ТекЗаявка<>Неопределено Тогда 
		ПоказатьЗначение(, ТекЗаявка);
	КонецЕсли;

КонецПроцедуры

// Возвращает структуру, в которой содержатся параметры формы
// согласования для объекта или группы объектов ВыбранныеЭлементыВход.
Функция ПолучитьСтруктуруПараметровОткрытияФормыСогласования(ВыбранныеЭлементыВход)
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("СтрокаФормы", "");
	ТипЭтапаОбработка = ПредопределенноеЗначение("Перечисление.ТипыЭтаповУниверсальныхПроцессов.Обработка");
	ТипЭтапаРучнойПереход = ПредопределенноеЗначение("Перечисление.ТипыЭтаповУниверсальныхПроцессов.РучнойПереход");
	ТипЭтапаУсловныйПереход = ПредопределенноеЗначение("Перечисление.ТипыЭтаповУниверсальныхПроцессов.УсловныйПереход");
	ТипЭтапаЭтапСогласования = ПредопределенноеЗначение("Перечисление.ТипыЭтаповУниверсальныхПроцессов.ЭтапСогласования");
	// Массив, состоящий из одного элемента, преобразуем в ссылку на элемент, чтобы отработать как единичное согласование.
	Если ТипЗнч(ВыбранныеЭлементыВход) = Тип("Массив") Тогда
		Если ВыбранныеЭлементыВход.Количество() = 1 Тогда
			ВыбранныеЭлементыРабочий = ВыбранныеЭлементыВход[0];
		Иначе
			ВыбранныеЭлементыРабочий = ВыбранныеЭлементыВход;
		КонецЕсли;
	Иначе
		ВыбранныеЭлементыРабочий = ВыбранныеЭлементыВход;
	КонецЕсли;
	// Проверка типа входного параметра и формирование структуры.
	Если ТипЗнч(ВыбранныеЭлементыРабочий) = Тип("Массив") Тогда
		// Выбрано несколько элементов.
		МассивТиповЭтапов = МодульУправленияПроцессамиУХ.МассивТиповЭтаповСогласованияДляТекущегоПользователя(ВыбранныеЭлементыРабочий);
		РабочийТипЭтапа = Неопределено;
		ЭтапыРазнородные = Ложь;
		// Проверка на разнородность этапов и получение типа этапа.
		Для Каждого ТекМассивТиповЭтапов Из МассивТиповЭтапов Цикл
			Если РабочийТипЭтапа = Неопределено Тогда
				РабочийТипЭтапа = ТекМассивТиповЭтапов;
			Иначе
				Если ТекМассивТиповЭтапов = РабочийТипЭтапа Тогда
					// Типы совпадают. Всё в порядке.
				Иначе
					ЭтапыРазнородные = Истина;			
					Прервать;					// Найдены разные этапы. Не имеет смысла продолжать.
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		// Заполнение параметров формы в зависимости от типа этапа.
		Если НЕ ЭтапыРазнородные Тогда
			Если РабочийТипЭтапа = ТипЭтапаОбработка Тогда
				СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаОбработка);
				РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
				РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаЗавершенияЗадачи");
			ИначеЕсли РабочийТипЭтапа = ТипЭтапаРучнойПереход Тогда
				СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаРучнойПереход);
				РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
				РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаВыбораЭтапаРучногоПерехода");
			ИначеЕсли РабочийТипЭтапа = ТипЭтапаУсловныйПереход Тогда
				СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаУсловныйПереход);
				РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
				РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаВыбораЭтапаРучногоПерехода");
			Иначе	
				ПакетДокументов = Новый СписокЗначений;
				ПакетДокументов.ЗагрузитьЗначения(ВыбранныеЭлементыРабочий);
				РезультатФункции.Вставить("СогласовываемыйДокумент", Неопределено);
				РезультатФункции.Вставить("ПакетДокументов", ПакетДокументов);
				РезультатФункции.Вставить("СтрокаФормы", "ОбщаяФорма.КомментарийИСогласование");
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Этапы согласования у выбранных элементов имеют различный тип. Невозможно их совместное выполнение.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			РезультатФункции.Вставить("СтрокаФормы", "");
		КонецЕсли;
	Иначе
		//Выбран один элемент.
		Если МодульСогласованияДокументовУХ.ТребуетсяВыполнениеЭтапаСТипом(ВыбранныеЭлементыРабочий, ТипЭтапаЭтапСогласования) Тогда
			РезультатФункции.Вставить("СогласовываемыйДокумент", ВыбранныеЭлементыРабочий);
			РезультатФункции.Вставить("СтрокаФормы", "ОбщаяФорма.КомментарийИСогласование");
		ИначеЕсли МодульСогласованияДокументовУХ.ТребуетсяВыполнениеЭтапаСТипом(ВыбранныеЭлементыРабочий, ТипЭтапаОбработка) Тогда
			СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаОбработка);
			РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
			РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаЗавершенияЗадачи");
		ИначеЕсли МодульСогласованияДокументовУХ.ТребуетсяВыполнениеЭтапаСТипом(ВыбранныеЭлементыРабочий, ТипЭтапаРучнойПереход) Тогда
			СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаРучнойПереход);
			РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
			РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаВыбораЭтапаРучногоПерехода");
		ИначеЕсли МодульСогласованияДокументовУХ.ТребуетсяВыполнениеЭтапаСТипом(ВыбранныеЭлементыРабочий, ТипЭтапаУсловныйПереход) Тогда
			СписокЗадач = МодульСогласованияДокументовУХ.ПолучитьСписокЗадачЭтапаСТипомПоОбъекту(ВыбранныеЭлементыРабочий, ТипЭтапаУсловныйПереход);
			РезультатФункции.Вставить("СписокЗадач", СписокЗадач);
			РезультатФункции.Вставить("СтрокаФормы", "Справочник.Задачи.Форма.ФормаВыбораЭтапаРучногоПерехода");
		Иначе	
			РезультатФункции.Вставить("СогласовываемыйДокумент", ВыбранныеЭлементыРабочий);
			РезультатФункции.Вставить("СтрокаФормы", "ОбщаяФорма.КомментарийИСогласование");
		КонецЕсли;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Осуществляет отправку на согласование из формы списка объекта.
Процедура СогласованиеИзФормыСписка(Форма)
	Если Форма.Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;		
	Иначе
		ВыделенныеСтрокиСогласования = Форма.Элементы.Список.ВыделенныеСтроки;
		Если ВыделенныеСтрокиСогласования.Количество() = 0 Тогда
			ОбъектСсылка = Форма.Элементы.Список.ТекущаяСтрока;
			ОтправлятьНаСогласование = Истина;
			ВозможноПроведение = ДействияСогласованиеУХСервер.ВозможноПроведениеОбъекта(Форма.Объект.Ссылка);
			Если ВозможноПроведение Тогда
				ОтправлятьНаСогласование = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ОбъектСсылка, "Проведен");
			Иначе
				ОтправлятьНаСогласование = Истина;
			КонецЕсли;
			ИмяСобытия = МодульУправленияПроцессамиУХ.ПринятьКОбработке(, ОбъектСсылка);	
		Иначе
			НепроведенныеДокументы = ДействияСогласованиеУХСервер.ВернутьМассивНепроведенныхДокументовВыделенныхСтрок(ВыделенныеСтрокиСогласования);
			Если НепроведенныеДокументы.Количество() = 0 Тогда
				Для Каждого ТекВыделенныеСтрокиСогласования Из ВыделенныеСтрокиСогласования Цикл
					ИмяСобытия = МодульУправленияПроцессамиУХ.ПринятьКОбработке(, ТекВыделенныеСтрокиСогласования);	
				КонецЦикла;
			ИначеЕсли НепроведенныеДокументы.Количество() = 1 Тогда	
				ТекстСообщения = НСтр("ru = 'Документ %Документ% не проведён. Отправка на согласование отменена.'");
				ДокументСсылка = НепроведенныеДокументы[0];
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Строка(ДокументСсылка));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			Иначе
				ТекстСообщения = НСтр("ru = 'Обнаружено %Количество% непроведённых документов. Отправка на согласование отменена.'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Количество%", Строка(НепроведенныеДокументы.Количество()));
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
		Форма.Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры		// СогласованиеИзФормыСписка()

// Осуществляет отправку на согласование из формы объекта.
Процедура СогласованиеИзФормыОбъекта(Форма, Ссылка)
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("Форма", Форма);
	ДопПараметры.Вставить("Ссылка", Ссылка);
	Если Форма <> Неопределено Тогда
		ПроверкаПройдена = Ложь;
		Если (ЗначениеЗаполнено(Форма.Объект.Ссылка)) И (НЕ Форма.Модифицированность) Тогда
			Если НЕ ДействияСогласованиеУХСервер.ВозможноПроведениеОбъекта(Форма.Объект.Ссылка) Тогда
				// Объект не проводится. Запишем форму и отправим на согласование.
				Если Форма.Модифицированность Тогда			
					Форма.Записать();			
				КонецЕсли;		
				ПроверкаПройдена = Истина;
			Иначе
				// Объект требует проведения. Проверим это.
				Если НЕ Форма.Объект.Проведен Тогда
					Если (ТипЗнч(Форма.Объект) = Тип("ДокументСсылка.НастраиваемыйОтчет")) ИЛИ ((ТипЗнч(Форма.Объект) = Тип("ДокументСсылка.РакурсДанных"))) Тогда
						Попытка
							ДокументОбъект = Форма.Объект.ПолучитьОбъект();	
							ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
						Исключение
							ТекстСообщения = НСтр("ru = 'Не удалось отправить на согласование документ %Документ%: %ОписаниеОшибки%'");
							ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Документ%", Строка(Форма.Объект));
							ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки());
							ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
						КонецПопытки;
					Иначе
						Оповещение = Новый ОписаниеОповещения("Подключаемый_ПринятьКОбработкеЗавершение", ЭтотОбъект, ДопПараметры);
						ТекстВопроса = НСтр("ru = 'Принять к обработке можно только проведенный документ. Провести?'");
						ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
						Возврат;
					КонецЕсли;
				Иначе
					ПроверкаПройдена = Истина;	
					Подключаемый_ПринятьКОбработкеЗавершение(КодВозвратаДиалога.Да, ДопПараметры);
					Возврат;					
				КонецЕсли;		
			КонецЕсли;	
		Иначе
			ТекстСообщения = НСтр("ru = 'Требуется записать объект перед отправкой на согласование. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			ПроверкаПройдена = Ложь;
		КонецЕсли;
		
		Если ПроверкаПройдена <> Истина Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Подключаемый_ПринятьКОбработкеЗавершение(, ДопПараметры);
	
КонецПроцедуры		// СогласованиеИзФормыОбъекта()

// Осуществляет обработку оповещения формы списка объекта в контексте согласования. 
Процедура ОбработкаОповещенияФормыСписка(ИмяСобытияВход, ЭлементСписокВход) Экспорт
	Если ИмяСобытияВход = "ОбъектСогласован" Тогда
		ЭлементСписокВход.Обновить();
	ИначеЕсли ИмяСобытияВход = "ОбъектОтклонен" Тогда
		ЭлементСписокВход.Обновить();
	ИначеЕсли ИмяСобытияВход = "МаршрутИнициализирован" Тогда
		ЭлементСписокВход.Обновить();
	ИначеЕсли ИмяСобытияВход = "СостояниеЗаявкиПриИзменении" Тогда
		ЭлементСписокВход.Обновить();
	КонецЕсли;
КонецПроцедуры		// ОбработкаОповещенияФормыСписка()

// Выставляет объекту формы Форма новый статус СтатусВход. 
Процедура ИзменитьСостояниеЗаявкиКлиент(СтатусВход, Форма) Экспорт
	ОбъектСогласования = Форма.Объект.Ссылка;
	
	Если ТипЗнч(ОбъектСогласования) = Тип("СправочникСсылка.РеестрыСогласуемыхОбъектов") Тогда
		Результат = ДействияСогласованиеУХСервер.ИзменитьСостояниеЗаявкиСервер(ОбъектСогласования, СтатусВход);
	Иначе		
		Результат = УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(ОбъектСогласования, СтатусВход);	
	КонецЕсли;
	
	Если Результат Тогда
		
		Если Строка(СтатусВход) = "На утверждении" Тогда		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагСиний;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "На утверждении";
		ИначеЕсли Строка(СтатусВход) = "Утвержден"  Тогда		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагЗеленый;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "Утвержден";
		ИначеЕсли Строка(СтатусВход) = "Отклонен" Тогда		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагКрасный;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "Отклонен";		
		ИначеЕсли Строка(СтатусВход) = "Черновик" Тогда		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагКонтур;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "Черновик";	
		ИначеЕсли Строка(СтатусВход) = "Отправлена на уточнение" Тогда		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагЖелтый;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "Отправлен на уточнение";			
		Иначе		
			Форма.Элементы.КартинкаСтатуса.Картинка = БиблиотекаКартинок.ПометкаНовостиФлагКонтур;
			Форма.Элементы.КартинкаСтатуса.Подсказка = "Черновик";
		КонецЕсли;
		
		Форма.Прочитать();
		Форма.СтатусОбъекта = СтатусВход;
		Оповестить("СостояниеЗаявкиПриИзменении", Форма.СостояниеЗаявки, Форма);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось изменить состояние объекта ""%Объект%"" на ""%Состояние%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Объект%", Строка(ОбъектСогласования));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Состояние%", Строка(СтатусВход));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ,"Объект");
	КонецЕсли;
КонецПроцедуры		// ИзменитьСостояниеЗаявкиКлиент()

#Область ОбработкаУниверсальныхКомандСогласования
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ОБРАБОТКИ КОМАНД ИНТЕРФЕЙСА СОГЛАСОВАНИЯ.
//

Процедура ПринятьКСогласованию(Форма, Ссылка) Экспорт
	
	Если Форма.Элементы.Найти("Список") <> Неопределено Тогда
		СогласованиеИзФормыСписка(Форма);
	Иначе
		СогласованиеИзФормыОбъекта(Форма, Ссылка);
	КонецЕсли;
		
КонецПроцедуры

Процедура СогласоватьДокумент(Форма, СсылкаВход = Неопределено) Экспорт
	// Получение параметров согласования.
	Если Форма.Элементы.Найти("Список") <> Неопределено Тогда
		// На форме есть список элементов. Открытие из формы списка/формы выбора.
		Если Форма.Элементы.Список.ТекущаяСтрока=Неопределено Тогда
			Возврат;
		Иначе
			ВыделенныеСтрокиСогласования = Форма.Элементы.Список.ВыделенныеСтроки;
			СтруктураПараметров = ПолучитьСтруктуруПараметровОткрытияФормыСогласования(ВыделенныеСтрокиСогласования);
		КонецЕсли;
	Иначе
		// Списка элементов на форме нет. Открытие из формы элемента.
		ОбъектСсылка = СсылкаВход;
		Если СсылкаВход <> Неопределено Тогда
			ОбъектСсылка = СсылкаВход;
		Иначе
			ОбъектСсылка = Форма.Объект.Ссылка;
		КонецЕсли;
		СтруктураПараметров = ПолучитьСтруктуруПараметровОткрытияФормыСогласования(ОбъектСсылка);
	КонецЕсли;    
	// Открытие нужной формы.
	Если ЗначениеЗаполнено(СтруктураПараметров.СтрокаФормы) Тогда
		ОткрытьФорму(СтруктураПараметров.СтрокаФормы, СтруктураПараметров, Форма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось определить форму согласования для выбранных объектов. Операция отменена.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

Процедура ПослеВводаПричиныОтменыСогласования(Значение, ДополнительныеПараметры) Экспорт
	Если Значение <> Неопределено Тогда
		СсылкаНаОбъект = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры, "СсылкаНаОбъект", Неопределено);
		Если СсылкаНаОбъект <> Неопределено Тогда
			МодульУправленияПроцессамиУХ.ОтменитьСогласование(, СсылкаНаОбъект, , Значение);
			Оповестить("ОбъектОтклонен");
			Форма = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеПараметры, "Форма", Неопределено);
			Если Форма <> Неопределено Тогда
				Форма.Прочитать();
			Иначе
				// Форма не получена, не обновляем её.
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось определить объект согласования. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		// Пользователь отказался. Ничего не делаем.
	КонецЕсли;
КонецПроцедуры		// ПослеВводаПричиныОтменыСогласования()

Процедура ОтменитьСогласование(Форма = Неопределено, СсылкаВход = Неопределено) Экспорт
	Если Форма <> Неопределено Тогда
		Если Форма.Элементы.Найти("Список") <> Неопределено Тогда
			// Отмена согласования из формы списка.
			Если Форма.Элементы.Список.ТекущаяСтрока = Неопределено Тогда
				Возврат;
			Иначе
				ВыделенныеСтрокиСогласования = Форма.Элементы.Список.ВыделенныеСтроки;
				Если ВыделенныеСтрокиСогласования.Количество() = 0 Тогда
					ОбъектСсылка=Форма.Элементы.Список.ТекущаяСтрока;
					МодульУправленияПроцессамиУХ.ОтменитьСогласование(, ОбъектСсылка);	
				Иначе
					Для Каждого ТекВыделенныеСтрокиСогласования Из ВыделенныеСтрокиСогласования Цикл
						МодульУправленияПроцессамиУХ.ОтменитьСогласование(, ТекВыделенныеСтрокиСогласования);	
					КонецЦикла;
				КонецЕсли;
				Форма.Элементы.Список.Обновить();
			КонецЕсли;
		Иначе
			// Отмена согласования из формы объекта.
			СсылкаНаОбъект = Форма.Объект.Ссылка;
			Если ЗначениеЗаполнено(СсылкаНаОбъект) И (НЕ Форма.Модифицированность) Тогда
				Если МодульУправленияПроцессамиУХ.ЭтоИнициаторСогласования(СсылкаНаОбъект) Тогда
					СтруктураДополнительныеПараметры = Новый Структура;
					СтруктураДополнительныеПараметры.Вставить("СсылкаНаОбъект", СсылкаНаОбъект);
					СтруктураДополнительныеПараметры.Вставить("Форма", Форма);
					Оповещение = Новый ОписаниеОповещения("ПослеВводаПричиныОтменыСогласования", ЭтотОбъект, СтруктураДополнительныеПараметры);
					Подсказка = НСтр("ru = 'Причина отмены согласования'");
					ПоказатьВводСтроки(Оповещение, "", Подсказка, 0, Истина);
				Иначе	
					МодульУправленияПроцессамиУХ.ОтменитьСогласование(, СсылкаНаОбъект);
					Оповестить("ОбъектОтклонен");
					Форма.Прочитать();
				КонецЕсли;
			Иначе
				ТекстСообщения = НСтр("ru = 'Требуется записать объект. Операция отменена.'");
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	Иначе
		// Отмена согласования по ссылке.
		Если ЗначениеЗаполнено(СсылкаВход) Тогда
			МодульУправленияПроцессамиУХ.ОтменитьСогласование(, СсылкаВход);
			Оповестить("ОбъектОтклонен");
		Иначе
			ТекстСообщения = НСтр("ru = 'Требуется записать объект. Операция отменена.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	КонецЕсли;
	Оповестить("ОбновитьМоиЗадачиИОповещения");	
КонецПроцедуры

Процедура ИсторияСогласования(Форма,Ссылка) Экспорт
	
	Если НЕ Форма.Элементы.Найти("Список")=Неопределено Тогда
		
		Если Форма.Элементы.Список.ТекущаяСтрока=Неопределено Тогда
			
			Возврат
			
		Иначе
			Если Форма.Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
				ОбъектСсылка=Форма.Элементы.Список.ТекущаяСтрока;
			Иначе
				ТекстСообщения = НСтр("ru = 'Требуется выбрать один объект согласования. Операция отменена.'");
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ОбъектСсылка=Ссылка;
		
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ИсторияСогласования.Форма.ФормаОтчета", Новый Структура("КлючевойОбъектПроцесса", ОбъектСсылка), Форма);
		
КонецПроцедуры

Процедура МаршрутСогласования(Форма, Ссылка) Экспорт
	
	Если НЕ Форма.Элементы.Найти("Список")=Неопределено Тогда
		
		Если Форма.Элементы.Список.ТекущаяСтрока=Неопределено Тогда
			
			Возврат
			
		Иначе
			Если Форма.Элементы.Список.ВыделенныеСтроки.Количество() = 1 Тогда
				ОбъектСсылка=Форма.Элементы.Список.ТекущаяСтрока;
				Согласующий=МодульУправленияПроцессамиУХ.ПолучитьОтветственногоЗаТипОбъекта(Ссылка,,,,"Согласующий",Истина);
			Иначе
				ТекстСообщения = НСтр("ru = 'Требуется выбрать один объект согласования. Операция отменена.'");
				ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		ОбъектСсылка=Ссылка;
		Согласующий = МодульУправленияПроцессамиУХ.ПолучитьОтветственногоЗаТипОбъекта(Ссылка,,,,"Согласующий",Истина);		// Чтобы избежать проблемы неактуальных кэшей, будем получать согласующего на ходу.
		
	КонецЕсли;
			
	Если НЕ Согласующий = Неопределено Тогда
		Если Не ТипЗнч(Согласующий) = Тип("СправочникСсылка.ШаблоныУниверсальныхПроцессов") Тогда	
			Согласующий = ПредопределенноеЗначение("Справочник.ШаблоныУниверсальныхПроцессов.Автоутверждение");	
		КонецЕсли;	
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СогласуемыйОбъект", ОбъектСсылка);
	ПараметрыФормы.Вставить("ШаблонПроцесса", Согласующий);
	ПараметрыФормы.Вставить("Режим", "УправлениеСогласованием");
	ОткрытьФорму("Обработка.КонсольУправленияПроцессом.Форма.Форма", ПараметрыФормы);
		
КонецПроцедуры

Процедура ТелеграмВложенныеФайлы(Форма, Ссылка) Экспорт
	// Для совместимости
КонецПроцедуры

#КонецОбласти



