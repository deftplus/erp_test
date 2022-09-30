
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Обработчик = "УправлениеПечатьюБЗККлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Идентификатор = "ПФ_MXL_ЛистокСообщения";
	КомандаПечати.Представление = НСтр("ru = 'Листок сообщения';
										|en = 'Notification slip'");
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПФ_MXL_ЛистокСообщения") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
				КоллекцияПечатныхФорм,
				"ПФ_MXL_ЛистокСообщения", НСтр("ru = 'Листок сообщения';
												|en = 'Notification slip'"),
				ПечатнаяФормаЛисткаСообщения(МассивОбъектов, ОбъектыПечати), ,
				"Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_ЛистокСообщения");
	КонецЕсли;
	
КонецПроцедуры

// Возвращает структуру, содержащие сведения о кратком и полном составе семьи для листка сообщения.
//
Функция СведенияОСоставеСемьи(ФизическоеЛицоСсылка) Экспорт 
	
	Супруга 			 = "";
	Дети 				 = "";
	БлижайшийРодственник = "";
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ФизическоеЛицо", ФизическоеЛицоСсылка);
	Запрос.УстановитьПараметр("Муж",  "01");
	Запрос.УстановитьПараметр("Жена", "02");
	Запрос.УстановитьПараметр("Отец", "03");
	Запрос.УстановитьПараметр("Мать", "04");
	Запрос.УстановитьПараметр("Сын",  "05");
	Запрос.УстановитьПараметр("Дочь", "06");
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РодственникиФизическихЛиц.СтепеньРодства КАК СтепеньРодства,
	|	РодственникиФизическихЛиц.Наименование КАК ФИО,
	|	РодственникиФизическихЛиц.ДатаРождения КАК ДатаРождения,
	|	РодственникиФизическихЛиц.СтепеньРодства.Код КАК СтепеньРодстваКод
	|ПОМЕСТИТЬ ВТСоставСемьи
	|ИЗ
	|	Справочник.РодственникиФизическихЛиц КАК РодственникиФизическихЛиц
	|ГДЕ
	|	РодственникиФизическихЛиц.Владелец = &ФизическоеЛицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТСоставСемьи.СтепеньРодства КАК СтепеньРодства,
	|	ВТСоставСемьи.СтепеньРодстваКод КАК СтепеньРодстваКод,
	|	ВТСоставСемьи.ФИО КАК ФИО,
	|	ВТСоставСемьи.ДатаРождения КАК ДатаРождения
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод В (&Муж, &Жена, &Сын, &Дочь)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТСоставСемьи.ДатаРождения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВТСоставСемьи.СтепеньРодства КАК СтепеньРодства,
	|	ВТСоставСемьи.ФИО КАК ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод = &Мать
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТСоставСемьи.СтепеньРодства,
	|	ВТСоставСемьи.ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	ВТСоставСемьи.СтепеньРодстваКод = &Отец
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВТСоставСемьи.СтепеньРодства,
	|	ВТСоставСемьи.ФИО
	|ИЗ
	|	ВТСоставСемьи КАК ВТСоставСемьи
	|ГДЕ
	|	НЕ ВТСоставСемьи.СтепеньРодстваКод В (&Муж, &Жена, &Отец, &Мать, &Сын, &Дочь)";
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка = РезультатЗапроса[1].Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		Если Выборка.СтепеньРодстваКод = "05" Или Выборка.СтепеньРодстваКод = "06" Тогда 
			Дети = Дети + ?(ЗначениеЗаполнено(Дети), ", ", "") + Выборка.ФИО + ?(ЗначениеЗаполнено(Выборка.ДатаРождения), ", ", "")
				+ Формат(Выборка.ДатаРождения, "ДФ=""гггг 'г. р.'""");
		Иначе 		
			Супруга = НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
		КонецЕсли;	
	КонецЦикла;
	
	Выборка = РезультатЗапроса[2].Выбрать();
	
	Если Выборка.Следующий() Тогда 
		БлижайшийРодственник = НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
	КонецЕсли;
	
	СоставСемьиКраткий = Супруга + ?(ЗначениеЗаполнено(Супруга) И ЗначениеЗаполнено(Дети), ", " + НСтр("ru = 'дети';
																										|en = 'children'") + ": ", "") + Дети;
	
	СоставСемьиПолный  = СоставСемьиКраткий + ?(ЗначениеЗаполнено(СоставСемьиКраткий) И ЗначениеЗаполнено(БлижайшийРодственник), ", ", "") + БлижайшийРодственник;
	СоставСемьиКраткий = ?(ЗначениеЗаполнено(Супруга), СоставСемьиКраткий, СоставСемьиПолный);
	
	Пока Выборка.Следующий() Цикл 
		СоставСемьиПолный = СоставСемьиПолный + ", " + НРег(Выборка.СтепеньРодства) + ": " + Выборка.ФИО;
	КонецЦикла;
	
	СведенияОСемье = Новый Структура;
	
	СведенияОСемье.Вставить("СоставСемьиКраткий", СоставСемьиКраткий);
	СведенияОСемье.Вставить("СоставСемьиПолный", СоставСемьиПолный);
	
	Возврат СведенияОСемье;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ФУНКЦИИ ПЕЧАТИ БЛАНКОВ ВОИНСКОГО УЧЕТА

Функция ПечатнаяФормаЛисткаСообщения(МассивОбъектов, ОбъектыПечати)
	
	НастройкиПечатныхФорм = ЗарплатаКадры.НастройкиПечатныхФорм();
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ЛистокСообщения";
	
	ТабДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	
	ДанныеДляПечати = ДанныеДляПечатиЛисткаСообщения(МассивОбъектов).Выбрать();
	
	Пока ДанныеДляПечати.Следующий() Цикл
	
		Макет = ?(ДанныеДляПечати.Дата >= '20170801',
			УправлениеПечатью.МакетПечатнойФормы("Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_ЛистокСообщения2017"),
			УправлениеПечатью.МакетПечатнойФормы("Документ.ЛистокСообщенияДляВоенкомата.ПФ_MXL_ЛистокСообщения"));
		
		ОбластьМакетаЛисток = Макет.ПолучитьОбласть("Листок");
	
		НомерСтрокиНачало = ТабДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьЗначенияСвойств(ОбластьМакетаЛисток.Параметры, ДанныеДляПечати);
		
		СписокФизическихЛиц = Новый Массив;
		СписокФизическихЛиц.Добавить(ДанныеДляПечати.ФизическоеЛицо);
		СписокФизическихЛиц.Добавить(ДанныеДляПечати.ОтветственныйЗаВУР);
		
		ФИО = КадровыйУчет.КадровыеДанныеФизическихЛиц(
				Истина,
				СписокФизическихЛиц,
				"Фамилия, Имя, Отчество, ИОФамилия",
				ДанныеДляПечати.Дата);
		
		ФИОСотрудника = ФИО.Найти(ДанныеДляПечати.ФизическоеЛицо, "ФизическоеЛицо");
		Если ФИОСотрудника <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ОбластьМакетаЛисток.Параметры, ФИОСотрудника);
		КонецЕсли;
		
		ФИООтветственногоЗаВУР = ФИО.Найти(ДанныеДляПечати.ОтветственныйЗаВУР, "ФизическоеЛицо");
		Если ФИООтветственногоЗаВУР <> Неопределено Тогда 
			ОбластьМакетаЛисток.Параметры.ФИООтветственногоЗаВУР = ФИООтветственногоЗаВУР.ИОФамилия;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ДанныеДляПечати.СоставСемьи) Тогда 
			
			СоставСемьи = Новый Структура;
			
			СоставСемьи.Вставить("СоставСемьи1");
			СоставСемьи.Вставить("СоставСемьи2");
			СоставСемьи.Вставить("СоставСемьи3");
			СоставСемьи.Вставить("СоставСемьи4");
			
			МассивСлов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ДанныеДляПечати.СоставСемьи, " ");
			
			КоличествоЭлементов = МассивСлов.Количество();
			
			Сч = 1;
			
			Для НомерСтроки = 1 По 4 Цикл
			
				Строка1 = Новый Массив;
				
				ДлинаСтроки = 0;
				
				Пока Сч <= КоличествоЭлементов Цикл
					
					ЭлементМассива = МассивСлов[Сч-1];
					
					ДлинаСтроки = ДлинаСтроки + СтрДлина(ЭлементМассива);
					
					Если ДлинаСтроки <= 56 Или НомерСтроки = 4 Тогда
						Строка1.Добавить(ЭлементМассива);
					Иначе
						Прервать;
					КонецЕсли;
					
					Сч = Сч + 1;
					
				КонецЦикла;
				
				СоставСемьи["СоставСемьи"+НомерСтроки] = СтрСоединить(Строка1, " ");
				
			КонецЦикла;
			
			ЗаполнитьЗначенияСвойств(ОбластьМакетаЛисток.Параметры, СоставСемьи);
			
		КонецЕсли;
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(ОбластьМакетаЛисток.Параметры.Подразделение) Тогда
			ОбластьМакетаЛисток.Параметры.Подразделение = ОбластьМакетаЛисток.Параметры.Подразделение.ПолноеНаименование();
		КонецЕсли;
		
		ТабДокумент.Вывести(ОбластьМакетаЛисток); 
		ТабДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеДляПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабДокумент;
	
КонецФункции

Функция ДанныеДляПечатиЛисткаСообщения(МассивСсылок)

	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЛистокСообщенияДляВоенкомата.Ссылка КАК Ссылка,
	|	ЛистокСообщенияДляВоенкомата.Дата КАК Дата,
	|	ЛистокСообщенияДляВоенкомата.Организация КАК Организация,
	|	ЛистокСообщенияДляВоенкомата.Сотрудник КАК Сотрудник,
	|	ЛистокСообщенияДляВоенкомата.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ЛистокСообщенияДляВоенкомата.Статус КАК Статус,
	|	ЛистокСообщенияДляВоенкомата.ДатаВрученияСотруднику КАК ДатаВрученияСотруднику,
	|	ЛистокСообщенияДляВоенкомата.ПричинаНевручения КАК ПричинаНевручения,
	|	ЛистокСообщенияДляВоенкомата.ОписаниеИзменений КАК ОписаниеИзменений,
	|	ЛистокСообщенияДляВоенкомата.Подразделение КАК Подразделение,
	|	ЛистокСообщенияДляВоенкомата.Должность КАК Должность,
	|	ЛистокСообщенияДляВоенкомата.ДатаРождения КАК ДатаРождения,
	|	ЛистокСообщенияДляВоенкомата.Образование КАК Образование,
	|	ЛистокСообщенияДляВоенкомата.СемейноеПоложение КАК СемейноеПоложение,
	|	ЛистокСообщенияДляВоенкомата.Звание КАК Звание,
	|	ЛистокСообщенияДляВоенкомата.ВУС КАК ВУС,
	|	ЛистокСообщенияДляВоенкомата.СостояниеЗдоровья КАК СостояниеЗдоровья,
	|	ЛистокСообщенияДляВоенкомата.АдресМестаПроживанияПредставление КАК АдресМестаПроживанияПредставление,
	|	ЛистокСообщенияДляВоенкомата.СоставСемьи КАК СоставСемьи,
	|	ЛистокСообщенияДляВоенкомата.ОтветственныйЗаВУР КАК ОтветственныйЗаВУР,
	|	ЛистокСообщенияДляВоенкомата.Организация.Наименование + "", "" + ЛистокСообщенияДляВоенкомата.Подразделение.Наименование КАК МестоРаботы
	|ИЗ
	|	Документ.ЛистокСообщенияДляВоенкомата КАК ЛистокСообщенияДляВоенкомата
	|ГДЕ
	|	ЛистокСообщенияДляВоенкомата.Ссылка В(&МассивСсылок)";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#Область МеханизмФиксацииИзменений

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксацияОписаниеФиксацииРеквизитов(), ФиксацияОписанияТЧ())
КонецФункции

Функция ФиксацияОписаниеФиксацииРеквизитов()
	
	ОписаниеФиксацииРеквизитов = Новый Соответствие;
	
	// ЗАПОЛНЯЕМЫЕ АВТОМАТИЧЕСКИ
	ОписаниеФиксацииРеквизитов.Вставить("Подразделение", 						ФиксацияОписаниеФиксацииРеквизита("Подразделение", "ГруппаОсновныеРеквизиты", "Сотрудник", НСтр("ru = 'Подразделение заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и используйте соответствующие документы. Если вы хотите изменить подразделение только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																												|en = 'Business unit is filled in automatically. If you want to edit the data, click ""No"" and use the corresponding documents. If you want to change the business unit only in this document, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("ДатаРождения", 						ФиксацияОписаниеФиксацииРеквизита("ДатаРождения", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'Дата рождения заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить дату рождения только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																													|en = 'Date of birth is filled in automatically. If you want to correct the data, click ""No"" and then click ""Edit employee card"". If you want to change the date of birth only in this document, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("Звание", 								ФиксацияОписаниеФиксацииРеквизита("Звание", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'Звание заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить звание только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																												|en = 'Rank is filled in automatically. To correct the data, click ""No"" and then click ""Edit employee card"". To correct rank only in the document, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("ВУС", 									ФиксацияОписаниеФиксацииРеквизита("ВУС", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'ВУС заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить ВУС только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																												|en = 'MOS is filled in automatically. If you want to correct the data, click ""No"" and then click ""Edit employee card"". If you want to change MOS in this document only, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("Образование", 							ФиксацияОписаниеФиксацииРеквизита("Образование", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'Образование заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить образование только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																														|en = 'Education is filled in automatically. If you want to change the data, click ""No"" and then click ""Edit employee card"". If you want to change education only in this document, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("Должность", 							ФиксацияОписаниеФиксацииРеквизита("Должность", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'Должность заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и используйте соответствующие документы. Если вы хотите изменить подразделение только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																													|en = 'Position is filled in automatically. If you want to correct the data, click ""No"" and use relevant documents. If you want to change the business unit only in this document, click ""Yes"" and continue editing   '")));
	ОписаниеФиксацииРеквизитов.Вставить("АдресМестаПроживанияПредставление", 	ФиксацияОписаниеФиксацииРеквизита("АдресМестаПроживанияПредставление", "ГруппаИнформацияЛеваяКолонка", "Сотрудник", НСтр("ru = 'Адрес заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить адрес только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																																			|en = 'Address is entered automatically. If you want to correct the data, click ""No"" and then click ""Edit employee card"". If you want to change the address in this document only, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("СемейноеПоложение", 					ФиксацияОписаниеФиксацииРеквизита("СемейноеПоложение", "ГруппаИнформацияПраваяКолонка", "Сотрудник", НСтр("ru = 'Семейное положение заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить семейное положение только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																															|en = 'Marital status is filled in automatically.  If you want to correct the data, click ""No"" and then click ""Edit employee card"". If you want to change the marital status in this document only, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("СоставСемьи", 							ФиксацияОписаниеФиксацииРеквизита("СоставСемьи", "ГруппаИнформацияПраваяКолонка", "Сотрудник", НСтр("ru = 'Состав семьи заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и затем используйте ссылку ""Редактировать карточку сотрудника"". Если вы хотите изменить семейное положение только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																														|en = 'Family structure is filled in automatically. If you want to correct the data, click ""No"" and then click ""Edit employee card"". If you want to change the marital status in this document only, click ""Yes"" and continue editing'")));
	ОписаниеФиксацииРеквизитов.Вставить("ОтветственныйЗаВУР", 					ФиксацияОписаниеФиксацииРеквизита("ОтветственныйЗаВУР", "СтраницаОсновное", "Организация", НСтр("ru = 'Ответственный за ВУР заполняется автоматически. Если вы хотите исправить данные, нажмите ""Нет"" и отредактируйте данные организации. Если вы хотите изменить ответственного только в этом документе, нажмите ""Да"" и продолжите редактирование';
																																													|en = 'Person responsible for military registration is filled in automatically. If you want to change data, click ""No"" and edit the company data. If you want to change the responsible person only in this document, click ""Yes"" and continue editing'")));
	
	Возврат ОписаниеФиксацииРеквизитов;  
	
КонецФункции 

Функция ФиксацияОписанияТЧ()
	
	СтруктураКлючевыхПолей = Новый Структура;
	
	Возврат	СтруктураКлючевыхПолей
КонецФункции

Функция ФиксацияОписаниеФиксацииРеквизита(ИмяРеквизита,
	ИмяГруппы, 
	ОснованиеЗаполнения,
	СтрокаПредупреждения =  "",
	Используется = Истина, 
	РеквизитСтроки = Ложь,
	ФиксацияГруппы = Ложь, 
	Путь = "",
	ОтображатьПредупреждение = Истина)
	
	ФиксацияРеквизита = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	ФиксацияРеквизита.Вставить("ИмяРеквизита", ИмяРеквизита);
	ФиксацияРеквизита.Вставить("Используется", Используется);
	ФиксацияРеквизита.Вставить("ИмяГруппы", ИмяГруппы);
	ФиксацияРеквизита.Вставить("ФиксацияГруппы", ФиксацияГруппы);
	ФиксацияРеквизита.Вставить("ОснованиеЗаполнения", ОснованиеЗаполнения);
	ФиксацияРеквизита.Вставить("Путь", Путь);
	ФиксацияРеквизита.Вставить("ОтображатьПредупреждение", ОтображатьПредупреждение);
	Если СтрокаПредупреждения <> "" Тогда
		ФиксацияРеквизита.Вставить("СтрокаПредупреждения", СтрокаПредупреждения);
	КонецЕсли;
	ФиксацияРеквизита.Вставить("РеквизитСтроки", РеквизитСтроки);
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксацииРеквизита(ФиксацияРеквизита)
КонецФункции 

#КонецОбласти

#КонецЕсли