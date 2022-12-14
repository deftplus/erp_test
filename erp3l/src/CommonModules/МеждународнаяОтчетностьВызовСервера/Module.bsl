
////////////////////////////////////////////////////////////////////////////////
//  Процедуры и функции, обеспечивающие работу генератора финансовых отчетов
//  для получения финансовой отчетности.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область РаботаСФормулами

// Функция добавляет сохраненные операнды в таблицу операндов
//
// Параметры:
//  Операнд - см. МеждународнаяОтчетностьКлиентСервер.НовыеДанныеОперанда
//  ИдентификаторГлавногоХранилища - УникальныйИдентификатор - идентификатор формы отчета.
//
// Возвращаемое значение:
//   Массив - массив добавленных строк таблицы операндов.
//
Функция ДобавитьСохраненныйОперанд(Операнд, ИдентификаторГлавногоХранилища) Экспорт
	
	ФинОтчеты = ФинансоваяОтчетностьВызовСервера;
	АдресСтруктурыЭлемента = МеждународнаяОтчетностьКлиентСервер.ПоместитьКопиюЭлементаВХранилище(
								Операнд.СвязанныйЭлемент,
								ИдентификаторГлавногоХранилища);
	ДанныеОперанда = ПолучитьИзВременногоХранилища(АдресСтруктурыЭлемента); // см. МеждународнаяОтчетностьКлиентСервер.НовыеДанныеОперанда
	НовыеОперанды = Новый Массив;
	Если ДанныеОперанда.ВидЭлемента = ВидЭлемента("МонетарныйПоказатель") Тогда
		
		НовыйОперанд = ДобавитьОперанд(Операнд, АдресСтруктурыЭлемента);
		НовыйОперанд.СчетПоказательИзмерение = Операнд.СчетПланаСчетов;
		НовыйОперанд.Код = ФинОтчеты.ЗначениеРеквизитаОбъекта(НовыйОперанд.СчетПоказательИзмерение,"Порядок");
		НовыеОперанды.Добавить(НовыйОперанд);
		
	ИначеЕсли ДанныеОперанда.ВидЭлемента = ВидЭлемента("НемонетарныйПоказатель") Тогда
		
		НовыйОперанд = ДобавитьОперанд(Операнд, АдресСтруктурыЭлемента);
		НовыйОперанд.СчетПоказательИзмерение = Операнд.НемонетарныйПоказатель;
		НовыйОперанд.Код = ФинОтчеты.ЗначениеРеквизитаОбъекта(НовыйОперанд.СчетПоказательИзмерение,"Код");
		НовыеОперанды.Добавить(НовыйОперанд);
		
	ИначеЕсли ДанныеОперанда.ВидЭлемента = ВидЭлемента("ПроизводныйПоказатель") Тогда
		Формула = ФинОтчеты.ЗначениеДополнительногоРеквизита(ДанныеОперанда,"Формула");
		ОперандыФормулы = ДанныеОперанда.ОперандыФормулы; // см. МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы.ТаблицаОперандов
		Для Каждого ОперандФормулы Из ОперандыФормулы Цикл
			
			АдресОперанда = ОперандФормулы.АдресСтруктурыЭлемента;
			Данные = ПолучитьИзВременногоХранилища(АдресОперанда);
			НовыйОперанд = ДобавитьОперанд(Данные, АдресОперанда);
			НовыйОперанд.Идентификатор = ОперандФормулы.Идентификатор;
			Если Данные.ВидЭлемента = ВидЭлемента("МонетарныйПоказатель") Тогда
				НовыйОперанд.СчетПоказательИзмерение = ФинОтчеты.ЗначениеДополнительногоРеквизита(Данные,"СчетПланаСчетов");
				НовыйОперанд.СчетПланаСчетов = НовыйОперанд.СчетПоказательИзмерение;
				НовыйОперанд.ТипИтога = ФинОтчеты.ЗначениеДополнительногоРеквизита(Данные,"ТипИтога");
				НовыйОперанд.НачальноеСальдо = ФинОтчеты.ЗначениеДополнительногоРеквизита(Данные,"НачальноеСальдо");
			ИначеЕсли Данные.ВидЭлемента = ВидЭлемента("НемонетарныйПоказатель") Тогда
				НовыйОперанд.СчетПоказательИзмерение = ФинОтчеты.ЗначениеДополнительногоРеквизита(Данные,"НемонетарныйПоказатель");
			КонецЕсли;
			
			НовыеОперанды.Добавить(НовыйОперанд);
			
		КонецЦикла;
	КонецЕсли;
	
	Возврат Новый Структура("Формула,НовыеОперанды",Формула,НовыеОперанды);
	
КонецФункции

// Проверяет на исполнимость формулу производного показателя генератора финансовой отчетности.
//
// Параметры:
//  Формула - Строка - текст формулы расчета производного показателя.
//  Операнды - см. МеждународнаяОтчетностьКлиент.ДобавитьОперандыФормулы.ТаблицаОперандов
//  Отказ - Булево - Истина, если не удалось выполнить расчет по формуле.
//  Поле - Строка - Имя реквизита формы содержащего формулу.
//  ПутьКДанным - Строка - путь к реквизиту формы содержащего формулу.
//
Процедура ПроверитьФормулу(Формула, Операнды, Отказ, Поле = "", ПутьКДанным = "") Экспорт
	
	ФинОтчеты = ФинансоваяОтчетностьСервер;
	ЗначенияОперандов = ПустаяТаблицаЭлементаПоказателя();
	
	Если ПустаяСтрока(Формула) Тогда
		ТекстУведомления = НСтр("ru = 'Не указан текст формулы.';
								|en = 'Formula text is not specified.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстУведомления, , Поле, ПутьКДанным,);
	КонецЕсли;
	
	ПериодВыборки = МеждународнаяОтчетностьСервер.ПериодОтчета(Дата('00010101'), Дата('00010101'));
	ИнтервалыОтчета = МеждународнаяОтчетностьСервер.ИнтервалыОтчета(ПериодВыборки);
	
	СхемаКД = Справочники.ЭлементыФинансовыхОтчетов.ПолучитьМакет("ПроизводныйПоказатель");
	ТипЧисло = ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля();
	ПсТаб = Символы.ПС + Символы.Таб;
	НеИспользуемыеОперанды = "";
	Монетарный = Перечисления.ВидыЭлементовФинансовогоОтчета.МонетарныйПоказатель;
	Для Каждого Операнд Из Операнды Цикл
		ФинОтчеты.НовоеПолеНабора(СхемаКД.НаборыДанных.ЗначенияОперандов, Операнд.Идентификатор,,,ТипЧисло);
		ЗначенияОперандов.Колонки.Добавить(Операнд.Идентификатор, ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
		Идентификатор = "["+Операнд.Идентификатор+"]";
		Если СтрНайти(Формула, Идентификатор) = 0 Тогда
			НеИспользуемыеОперанды = НеИспользуемыеОперанды + Идентификатор + " " + Операнд.НаименованиеДляПечати + ПсТаб;
		КонецЕсли;
		Если Операнд.ВидЭлемента = Монетарный И НЕ ЗначениеЗаполнено(Операнд.СчетПланаСчетов) Тогда
			Шаблон = НСтр("ru = 'В настройках операнда [%1] %2
								|не указан счет плана счетов.';
								|en = 'Account of chart of accounts is not specified in the settings of operand [%1] %2
								|.'");
			Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Операнд.Идентификатор, Операнд.НаименованиеДляПечати);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, , Поле, ПутьКДанным,);
		КонецЕсли;
	КонецЦикла;
	Если НЕ ПустаяСтрока(НеИспользуемыеОперанды) Тогда
		ТекстУведомления = НСтр("ru = 'Найдены не используемые операнды:';
								|en = 'Unused operands are detected:'") + ПсТаб + НеИспользуемыеОперанды;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстУведомления, , Поле, ПутьКДанным,);
	КонецЕсли;
	ПолеЗначения = СхемаКД.ВычисляемыеПоля[0];
	ПолеЗначения.Выражение = ?(ЗначениеЗаполнено(Формула),Формула,"0");
	Компоновщик = ФинОтчеты.КомпоновщикСхемы(СхемаКД);
	Настройки = Компоновщик.ПолучитьНастройки();
	ВнешниеНаборы = Новый Структура;
	ВнешниеНаборы.Вставить("ЗначенияОперандов", ЗначенияОперандов);
	ВнешниеНаборы.Вставить("ИнтервалыОтчета", ИнтервалыОтчета);
	
	Попытка
		ФинОтчеты.ВыгрузитьРезультатСКД(СхемаКД, Настройки, ВнешниеНаборы);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ТекстОписанияОшибки = Инфо.Причина.Причина.Описание;
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					ТекстОписанияОшибки,
					,
					Поле,
					ПутьКДанным,);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииОбработкиЭлементовОтчета

// Возвращает сумму выделенных ячеек табличного документа.
//
// Параметры:
//	Результат - ТабличныйДокумент - Табличный документ, содержащий ячейки для суммирования.
//	КэшВыделеннойОбласти - Структура - Содержит ячейки выделенной области.
//
// Возвращаемое значение:
//	Число - Сумма значений ячеек.
//
Функция ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(Знач Результат, КэшВыделеннойОбласти) Экспорт
	
	Сумма = 0;
	Для Каждого КлючИЗначение Из КэшВыделеннойОбласти Цикл
		СтруктураАдресВыделеннойОбласти = КлючИЗначение.Значение;
		Для ИндексСтрока = СтруктураАдресВыделеннойОбласти.Верх По СтруктураАдресВыделеннойОбласти.Низ Цикл
			Для ИндексКолонка = СтруктураАдресВыделеннойОбласти.Лево По СтруктураАдресВыделеннойОбласти.Право Цикл
				Попытка
					Ячейка = Результат.Область(ИндексСтрока, ИндексКолонка, ИндексСтрока, ИндексКолонка);
					Если Ячейка.Видимость = Истина Тогда
						Если Ячейка.СодержитЗначение И ТипЗнч(Ячейка.Значение) = Тип("Число") Тогда
							Сумма = Сумма + Ячейка.Значение;
						ИначеЕсли ЗначениеЗаполнено(Ячейка.Текст) Тогда
							ЧислоВЯчейке = Число(СтроковыеФункцииКлиентСервер.ЗаменитьОдниСимволыДругими(Символ(32)+Символ(43), Ячейка.Текст, Символ(0)));
							Сумма = Сумма + ЧислоВЯчейке;
						КонецЕсли;
					КонецЕсли;
				Исключение
					// Запись в журнал регистрации не требуется.
				КонецПопытки;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	КэшВыделеннойОбласти.Вставить("Сумма", Сумма);
	
	Возврат Сумма;
	
КонецФункции


// Ищет ссылки в других отчетах на переданный элемент финансового отчета
//
//  ЭлементОтчета - СправочникСсылка.ЭлементыФинансовыхОтчетов
//  КоличествоСсылок - Число - будет помещено найденное количество ссылок.
//
// Возвращаемое значение:
//  Булево - Истина, если на текущий элемент отчета есть ссылки в других отчетах.
//
Функция ЕстьСсылки(ЭлементОтчета, КоличествоСсылок = 0) Экспорт

	ЕстьСсылки = Ложь;
	Запрос = Новый Запрос;
	МенеджерВременныхТаблиц = ФинансоваяОтчетностьСервер.ВременнаяТаблицаИндексовКартинок();
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = МеждународнаяОтчетностьСервер.ТекстЗапросаСсылокНаЭлементОтчета();
	Запрос.УстановитьПараметр("ЭлементОтчета", ЭлементОтчета);
	Запрос.УстановитьПараметр("Владелец", ЭлементОтчета.Владелец);
	
	Выборка = Запрос.Выполнить().Выбрать();
	КоличествоСсылок = Выборка.Количество();
	Если Выборка.Следующий() Тогда
		ЕстьСсылки = Истина;
	КонецЕсли;
	Возврат ЕстьСсылки;

КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииРасшифровкиОтчета

// Подготавливает параметры для расшифровочного отчета по данным стандартной расшифровки СКД и параметров вызывающего отчета.
// 
// Параметры:
//  Расшифровка - Структура из КлючИЗначение - содержит значение полей текущей группировки дополненная:
//   *ДатаНачала - Дата -
//   *ДатаОкончания - Дата - 
//   *Точность - Число -
//  ПараметрыОтчета - Структура из КлючИЗначение - Параметры вызывающего отчета.
// 
// Возвращаемое значение:
//  Структура - Содержащая параметры для расшифровочного отчета.
//
Функция ПараметрыРасшифровкиОтчета(Расшифровка, ПараметрыОтчета) Экспорт
	
	ПараметрыРасшифровки = НовыеПараметрыРасшифровкиОтчета();
	ЗаполнитьЗначенияСвойств(ПараметрыРасшифровки, ПараметрыОтчета);
	ЗаполнитьЗначенияСвойств(ПараметрыРасшифровки.Отбор, ПараметрыОтчета);
	
	Если ТипЗнч(Расшифровка) <> Тип("Структура") Тогда
		Возврат ПараметрыРасшифровки;
	КонецЕсли;
	
	Если Расшифровка.Свойство("Отбор") Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыРасшифровки.Отбор, Расшифровка.Отбор);
		
		НомерСубконто = 1;
		Для каждого ЭлементОтбора Из Расшифровка.Отбор Цикл
			Если СтрНайти(ЭлементОтбора.Ключ, "Аналитика")  Тогда
				ПараметрыРасшифровки.Отбор.Вставить ("Субконто"+НомерСубконто, ЭлементОтбора.Значение);
				НомерСубконто = НомерСубконто + 1;
			ИначеЕсли СтрНайти(ЭлементОтбора.Ключ, "Субконто") Тогда
				ПараметрыРасшифровки.Отбор.Вставить (ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
			КонецЕсли;
		КонецЦикла; 
		
	КонецЕсли;
	
	Если Расшифровка.Свойство("ВидСубконто") Тогда
		ПараметрыРасшифровки.Вставить("ВидСубконто", Расшифровка.ВидСубконто);
	КонецЕсли;
	
	ПараметрыРасшифровки.Показатель = Расшифровка.Показатель;
	
	Если ПараметрыРасшифровки.Показатель = Неопределено Тогда
		Возврат ПараметрыРасшифровки;
	КонецЕсли;
	
	ПериодОтчета = Новый СтандартныйПериод;
	ПериодОтчета.ДатаНачала = Расшифровка.ДатаНачала;
	ПериодОтчета.ДатаОкончания = Расшифровка.ДатаОкончания;
	ПараметрыРасшифровки.Вставить("ПериодОтчета", ПериодОтчета);
	
	РеквизитыПоказателя = РеквизитыПоказателя(ПараметрыРасшифровки.Показатель);
	РеквизитыПоказателя.Вставить("Значение", ПараметрыОтчета.Значение);
	Если Расшифровка.Свойство("Точность") Тогда
		РеквизитыПоказателя.Вставить("Точность",  Расшифровка.Точность);
	Иначе
		РеквизитыПоказателя.Вставить("Точность",  0);
	КонецЕсли;
	Для каждого ОтборПараметровРасшифровки Из ПараметрыРасшифровки Цикл
		Если СтрНайти(ОтборПараметровРасшифровки.Ключ, "Субконто")  И ОтборПараметровРасшифровки.Ключ <> "ВидСубконто" Тогда
			ПараметрыРасшифровки.Отбор.Вставить(ОтборПараметровРасшифровки.Ключ, ОтборПараметровРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла; 
	
	ПараметрыРасшифровки.Показатель = РеквизитыПоказателя;
	ПараметрыРасшифровки.Вставить("ПустаяСсылка", Справочники.ЭлементыФинансовыхОтчетов.ПустаяСсылка());
	
	// Подготовим настройки отчетов расшифровки
	Если ТипЗнч(РеквизитыПоказателя.СчетПланаСчетов) = РеглУчетКлиентСервер.ТипПланСчетов() Тогда
		
		ПараметрыРасшифровки.Отбор.Вставить("Счет", ПараметрыРасшифровки.Показатель.СчетПланаСчетов);
		НастройкаАнализаСчета = НастроитьАнализСчетаХозрасчетный(ПараметрыОтчета.АдресНастроек, ПараметрыРасшифровки);
		
	ИначеЕсли ТипЗнч(РеквизитыПоказателя.СчетПланаСчетов) = МеждународныйУчетКлиентСервер.ТипПланСчетов() Тогда
		
		НастройкаАнализаСчета = НастроитьАнализСчетаМеждународный(ПараметрыРасшифровки);
		
	КонецЕсли;
	
	ПараметрыРасшифровки.Вставить("НастройкаАнализаСчета", НастройкаАнализаСчета);
	
	АктуальныйОтбор = Новый Структура;
	Для каждого ОтборРасшифровки Из ПараметрыРасшифровки.Отбор Цикл
		Если ОтборРасшифровки.Значение <> Неопределено Или СтрНачинаетсяС(ОтборРасшифровки.Ключ, "Субконто") Тогда
			АктуальныйОтбор.Вставить(ОтборРасшифровки.Ключ, ОтборРасшифровки.Значение);
		КонецЕсли;
	КонецЦикла; 
	ПараметрыРасшифровки.Отбор = АктуальныйОтбор;
	
	Возврат ПараметрыРасшифровки;
	
КонецФункции

// Подготавливает параметры для расшифровочного отчета АнализСчетаХозрасчетный
//
// Параметры:
//  Адрес - Строка - адрес во временном хранилище данных расшифровки вызывающего отчета
//  Параметры - Структура - параметры вызывающего отчета.
//
// Возвращаемое значение:
//  Структура - содержащая параметры настройки отчета АнализСчетаХозрасчетный.
//
Функция НастроитьАнализСчетаХозрасчетный(Адрес, Параметры) Экспорт
	
	// Настройки отчета расшифровки
	НастройкаОтчета = Новый Структура("АдресНастроек", Адрес);
	
	АнализСчета = Новый Структура("АнализСчета");
	ДанныеРасшифровки = Новый Структура("НастройкиРасшифровки", АнализСчета);
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскийОтбор = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ПользовательскийОтбор.ИдентификаторПользовательскойНастройки = "Отбор";
	
	// Передадим отбор монетарного показателя
	НастройкиОтбора = Параметры.Показатель.ДополнительныйОтбор.Получить();
	Если НастройкиОтбора <> Неопределено Тогда
		ФинансоваяОтчетностьСервер.СкопироватьОтбор(
				НастройкиОтбора.Отбор,
				ПользовательскийОтбор,
				Истина);
	КонецЕсли;
	
	// Передадим реквизиты отчета
	РеквизитыОтчета = ПользовательскиеНастройки.ДополнительныеСвойства;
	РеквизитыОтчета.Вставить("ПоказательБУ", Истина);
	РеквизитыОтчета.Вставить("РежимРасшифровки", Истина);
	РеквизитыОтчета.Вставить("НачалоПериода", Параметры.ПериодОтчета.ДатаНачала);
	РеквизитыОтчета.Вставить("КонецПериода",  Параметры.ПериодОтчета.ДатаОкончания);
	
	Для Каждого Параметр Из Параметры.Отбор Цикл
		Если ЗначениеЗаполнено(Параметр.Значение) Тогда
			РеквизитыОтчета.Вставить(Параметр.Ключ, Параметр.Значение);
			Если (Параметр.Ключ = "Организация" ИЛИ Параметр.Ключ = "Подразделение" ИЛИ Параметр.Ключ = "НаправлениеДеятельности")
				И ТипЗнч(Параметр.Значение) = Тип("Массив") Тогда
				РеквизитыОтчета.Вставить(Параметр.Ключ, Параметр.Значение[0]);
			ИначеЕсли СтрНачинаетсяС(Параметр.Ключ, "Субконто") Тогда
				ФинансоваяОтчетностьСервер.НовыйОтбор(ПользовательскийОтбор, Параметр.Ключ, Параметр.Значение); 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ДанныеРасшифровки.НастройкиРасшифровки.АнализСчета = ПользовательскиеНастройки;
	ПоместитьВоВременноеХранилище(ДанныеРасшифровки, Адрес);
	
	Возврат НастройкаОтчета;
	
КонецФункции

// Подготавливает параметры для расшифровочного отчета АнализСчетаХозрасчетный
//
// Параметры:
//  Параметры - Структура - параметры вызывающего отчета.
//
// Возвращаемое значение:
//  Структура - содержащая параметры настройки отчета АнализСчетаХозрасчетный.
//
Функция НастроитьАнализСчетаМеждународный(Знач Параметры) Экспорт
	
	// Настройки отчета расшифровки
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	ИмяСхемы = Метаданные.Отчеты.БухгалтерскийОтчетМеждународный.ОсновнаяСхемаКомпоновкиДанных.Имя;
	СхемаРасшифровки = Отчеты.БухгалтерскийОтчетМеждународный.ПолучитьМакет(ИмяСхемы);
	НастройкиВарианта = СхемаРасшифровки.ВариантыНастроек.АнализСчетаМеждународный.Настройки;
	КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиВарианта);
	ПользовательскиеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки;
	ПользовательскийОтбор = КомпоновщикНастроек.ФиксированныеНастройки.Отбор;
	Для Каждого Элемент Из ПользовательскиеНастройки.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ОтборКомпоновкиДанных") Тогда
			ПользовательскийОтбор = Элемент;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	// Установим параметры отчета расшифровки
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПериодОтчета", Параметры.ПериодОтчета);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПредставлениеСчетовПоКоду", Истина);
	ЭтоФункциональнаяВалюта = Параметры.Ресурс = "Сумма";
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПоказательСумма", ЭтоФункциональнаяВалюта);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПоказательСуммаПредставления", НЕ ЭтоФункциональнаяВалюта);
		
	// Установим отборы на точное соответствие
	ФинОтчеты = ФинансоваяОтчетностьСервер;
	Для Каждого Отбор Из Параметры.Отбор Цикл
		Если ЗначениеЗаполнено(Отбор.Значение) Тогда
			ЗначениеОтбора = Отбор.Значение;
			Если ТипЗнч(ЗначениеОтбора) = Тип("Массив") Тогда
				ЗначениеОтбора = Новый СписокЗначений;
				ЗначениеОтбора.ЗагрузитьЗначения(Отбор.Значение);
			КонецЕсли;
			ФинОтчеты.НовыйОтбор(ПользовательскийОтбор,Отбор.Ключ,ЗначениеОтбора);
		ИначеЕсли СтрНачинаетсяС(Отбор.Ключ, "Субконто") Тогда
			ФинОтчеты.НовыйОтбор(ПользовательскийОтбор, Отбор.Ключ, , , ВидСравненияКомпоновкиДанных.НеЗаполнено);
		КонецЕсли;
	КонецЦикла;
	
	// Установим отбор по монетарному показателю
	Если Параметры.Свойство("Показатель") Тогда
		ОтборСчета = ФинОтчеты.НовыйОтбор(ПользовательскийОтбор,"Счет",Параметры.Показатель.СчетПланаСчетов);
		ОтборСчета.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		НастройкиОтбора = Параметры.Показатель.ДополнительныйОтбор.Получить();
		Если НастройкиОтбора <> Неопределено Тогда
			Отбор = Справочники.ЭлементыФинансовыхОтчетов.ПереименоватьСубконтоИзДопОтбора(НастройкиОтбора.Отбор, Параметры.Показатель, Параметры.ВидСубконто);
			ФинОтчеты.СкопироватьОтбор(
					Отбор,
					ПользовательскийОтбор,
					Истина);
		КонецЕсли;
		
		ПланСчетовМеждународногоУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Показатель.СчетПланаСчетов, "ПланСчетов");
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПланСчетов", ПланСчетовМеждународногоУчета);
		
		КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("ТипИтога", 			Параметры.Показатель.ТипИтога);
		КомпоновщикНастроек.ФиксированныеНастройки.ДополнительныеСвойства.Вставить("НачальноеСальдо", 	Параметры.Показатель.НачальноеСальдо);
		
		Если Параметры.Свойство("ВидСубконто") И ЗначениеЗаполнено(Параметры.ВидСубконто) Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ВидСубконто", Параметры.ВидСубконто);
		КонецЕсли;
		
	ИначеЕсли Параметры.Свойство("Счет") Тогда
		
		ОтборСчета = ФинОтчеты.НовыйОтбор(ПользовательскийОтбор,"Счет",Параметры.Счет);
		ОтборСчета.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
		
		ПланСчетовМеждународногоУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Счет, "ПланСчетов");
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПользовательскиеНастройки, "ПланСчетов", ПланСчетовМеждународногоУчета);
		
	КонецЕсли;
	
	Возврат КомпоновщикНастроек;
	
КонецФункции

#КонецОбласти

// Функция получает реквизит "ЭтоГруппаШаблонов" для переданного шаблона проводки
//
// Параметры:
//	ШаблонПроводки - СправочникСсылка.ШаблоныПроводокДляМеждународногоУчета - шаблон проводки.
//
// Возвращаемое значение:
//	Булево - Истина если шаблон проводки является группой шаблонов.
//
Функция ЭтоГруппаШаблонов(Знач ШаблонПроводки) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ШаблонПроводки, "ЭтоГруппаШаблонов");
КонецФункции

// Формирует текстовое представление документа РегламентнаяОперацияМеждународныйУчет
// с хоз. операцией ЗакрытиеСчетовДоходовРасходов.
//
// Параметры:
//  ПредставлениеСсылки - Булево - Истина, возвращается шаблон представления для последующего заполнения
//                                 в обработчике ОбработкаПолученияПредставления.
//
// Возвращаемое значение:
//  Строка - Строка представления документа.
//
Функция ПредставлениеЗакрытияДоходовРасходов(ПредставлениеСсылки = Истина) Экспорт
	
	Представление = НСтр("ru = 'Закрытие счетов учета доходов и расходов (международный учет)';
						|en = 'Closing of ledger accounts of income and expenses (financial accounting)'");
	Если ПредставлениеСсылки Тогда
		Представление = Представление + " "+НСтр("ru = '%1 от %2';
												|en = '%1 from %2'");
	КонецЕсли;
	Возврат Представление;
	
КонецФункции

// Формирует текстовое представление документа РегламентнаяОперацияМеждународныйУчет
// с хоз. операцией РасчетКурсовыхРазницФункциональнаяВалюта.
//
// Параметры:
//  ПредставлениеСсылки - Булево - Истина, возвращается шаблон представления для последующего заполнения
//                                 в обработчике ОбработкаПолученияПредставления.
//
// Возвращаемое значение:
//  Строка - Строка представления документа.
//
Функция ПредставлениеРасчетКурсовыхРазницФункциональнойВалюте(ПредставлениеСсылки = Истина) Экспорт
	
	Представление = НСтр("ru = 'Расчет курсовых разниц в функциональной валюте (международный учет)';
						|en = 'Exchange difference calculation in the functional currency (financial accounting)'");
	Если ПредставлениеСсылки Тогда
		Представление = Представление + " "+НСтр("ru = '%1 от %2';
												|en = '%1 from %2'");
	КонецЕсли;
	Возврат Представление;
	
КонецФункции

// Формирует текстовое представление документа РегламентнаяОперацияМеждународныйУчет
// с хоз. операцией РасчетКурсовыхРазницВалютаПредставления.
//
// Параметры:
//  ПредставлениеСсылки - Булево - Истина, возвращается шаблон представления для последующего заполнения
//                                 в обработчике ОбработкаПолученияПредставления.
//
// Возвращаемое значение:
//  Строка - Строка представления документа.
//
Функция ПредставлениеРасчетКурсовыхРазницВалютеПредставления(ПредставлениеСсылки = Истина) Экспорт
	
	Представление = НСтр("ru = 'Расчет курсовых разниц в валюте представления (международный учет)';
						|en = 'Exchange difference calculation in the presentation currency (financial accounting)'");
	Если ПредставлениеСсылки Тогда
		Представление = Представление + " "+НСтр("ru = '%1 от %2';
												|en = '%1 from %2'");
	КонецЕсли;
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РеквизитыПоказателя(Знач Показатель)
	
	ДанныеЭлемента = ФинансоваяОтчетностьКлиентСервер.СтруктураЭлементаОтчета();
	Реквизиты = "СчетПланаСчетов,НемонетарныйПоказатель,Формула,ТипИтога,НачальноеСальдо";
	Если ЗначениеЗаполнено(Показатель.СвязанныйЭлемент) Тогда
		Показатель = Показатель.СвязанныйЭлемент;
	КонецЕсли;
	
	ТаблицыЭлемента = "РеквизитыВидаЭлемента,ИсточникиЗначений,ОперандыФормулы,ЭлементыТаблицы,ДополнительныеПоля,ЭлементыОформления,ОформляемыеСтроки,ОформляемыеКолонки,РасшифровкаПолейОтбораЭО";
	
	ДопРеквизиты = ФинансоваяОтчетностьВызовСервера.ЗначенияДополнительныхРеквизитов(Показатель, Реквизиты);
	ЗаполнитьЗначенияСвойств(ДанныеЭлемента, Показатель,,ТаблицыЭлемента);
	Для Каждого Реквизит Из ДопРеквизиты Цикл
		ДанныеЭлемента.Вставить(Реквизит.Ключ, Реквизит.Значение);
	КонецЦикла;
	
	Возврат ДанныеЭлемента;
	
КонецФункции

Функция НовыеПараметрыРасшифровкиОтчета()
	
	Результат = Новый Структура;
	Результат.Вставить("ВидОтчета");
	Результат.Вставить("КомплектОтчетности");
	Результат.Вставить("Показатель");
	Результат.Вставить("Ресурс");
	Результат.Вставить("Значение");
	Результат.Вставить("ВидСубконто");
	Результат.Вставить("КратностьСумм");
	Результат.Вставить("Точность");
	
	Отбор = Новый Структура("Организация,Подразделение,НаправлениеДеятельности");
	Результат.Вставить("Отбор", Отбор);
	
	Возврат Результат;
	
КонецФункции

Функция ПустаяТаблицаЭлементаПоказателя()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Показатель",    Новый ОписаниеТипов("СправочникСсылка.ЭлементыФинансовыхОтчетов"));
	Результат.Колонки.Добавить("Примечание",    Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(100)));
	Результат.Колонки.Добавить("КодСтроки",     Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)));
	Результат.Колонки.Добавить("ДатаНачала",    Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	Результат.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	Результат.Колонки.Добавить("Значение",      ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля());
	Возврат Результат;
	
КонецФункции

Функция ВидЭлемента(ИмяВидаЭлемента)
	
	Возврат Перечисления.ВидыЭлементовФинансовогоОтчета[ИмяВидаЭлемента];
	
КонецФункции

Функция ДобавитьОперанд(ДанныеОперанда, АдресСтруктурыЭлемента)
	
	НовыйОперанд = МеждународнаяОтчетностьКлиентСервер.НовыеДанныеОперанда();
	ЗаполнитьЗначенияСвойств(НовыйОперанд, ДанныеОперанда,,"СвязанныйЭлемент");
	НовыйОперанд.АдресСтруктурыЭлемента = АдресСтруктурыЭлемента;
	НовыйОперанд.ЭтоСвязанный = Ложь;
	НовыйОперанд.НестандартнаяКартинка = ФинансоваяОтчетностьПовтИсп.НестандартнаяКартинка(ДанныеОперанда.ВидЭлемента);
	
	Возврат НовыйОперанд;
	
КонецФункции

#КонецОбласти
