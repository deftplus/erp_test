#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Сформировать печатные формы объектов
//
// Параметры:
// 		МассивОбъектов - Массив - Массив ссылок на объекты которые нужно распечатать
// 		ПараметрыПечати - Структура - Структура дополнительных параметров печати
// 		КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
// 		ОбъектыПечати - Объекты печати
// 		ПараметрыВывода - Структура - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС4") Тогда
		ИмяМакета = "ОС4";
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОС4_Разукомплектация") Тогда
		ИмяМакета = "ОС4_Разукомплектация";
	Иначе
		ИмяМакета = Неопределено;
	КонецЕсли;
	
	Если ИмяМакета <> Неопределено Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			ИмяМакета,
			НСтр("ru = 'ОС-4 (Акт о списании ОС)';
				|en = 'FA-4 (FA retirement certificate)'"),
			СформироватьПечатнуюФормуОС4(
				МассивОбъектов,
				ОбъектыПечати,
				ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

Функция СформироватьПечатнуюФормуОС4(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураТипов = ОбщегоНазначенияУТ.СоответствиеМассивовПоТипамОбъектов(МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОС4";
	
	НомерТипаДокумента = 0;
	
	СведенияАктуальны = Истина;
		
	Для Каждого СтруктураОбъектов Из СтруктураТипов Цикл
		
		НомерТипаДокумента = НомерТипаДокумента + 1;
		Если НомерТипаДокумента > 1 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(СтруктураОбъектов.Ключ);
		ДанныеДляПечати = МенеджерОбъекта.ПолучитьДанныеДляПечатнойФормыОС4(СтруктураОбъектов.Значение);
		
		ЗаполнитьТабличныйДокументОС4(ТабличныйДокумент, ДанныеДляПечати, ОбъектыПечати, СведенияАктуальны);
		
	КонецЦикла;
	
	ВнеоборотныеАктивы.ДобавитьПредупреждениеЕслиСведенияНеАктуальны(СведенияАктуальны);
	
	Возврат ТабличныйДокумент;
	
КонецФункции

Процедура ЗаполнитьТабличныйДокументОС4(ТабличныйДокумент, ДанныеПечатнойФормы, ОбъектыПечати, СведенияАктуальны)
	
	ИспользоватьУчетДМ = ПолучитьФункциональнуюОпцию("ИспользоватьУчетДрагоценныхМатериалов");
	
	МакетОС4  = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС4.ПФ_MXL_ОС4");
	МакетОС4А = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС4.ПФ_MXL_ОС4а");
	МакетОС4Б = УправлениеПечатью.МакетПечатнойФормы("Обработка.ПечатьОС4.ПФ_MXL_ОС4б");
	
	Результат = ДанныеПечатнойФормы.ПоДокументам;
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеПечатнойФормы.ПоПрочимОприходованиям <> Неопределено Тогда
		ВыборкаПрочихОприходований = ДанныеПечатнойФормы.ПоПрочимОприходованиям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		ВыборкаПрочихОприходований = Неопределено;
	КонецЕсли;
	
	ВыборкаДокументов = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ШаблонСообщенияОбОшибке = НСтр("ru = 'Для документа %1 не требуется акт о списании (ОС-4)';
									|en = 'Retirement certificate (FA-4) is not required for the %1 document'");
	ПервыйДокумент = Истина;
	
	СведенияАктуальны = Истина;
	
	Пока ВыборкаДокументов.Следующий() Цикл
		
		Если ВыборкаДокументов.ЧастичнаяЛиквидация Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(ШаблонСообщенияОбОшибке, ВыборкаДокументов.Ссылка),
				ВыборкаДокументов.Ссылка);
			
			Продолжить;
		КонецЕсли;
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		ЭтоАвто = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОбОрганизации= БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(ВыборкаДокументов.Организация, ВыборкаДокументов.Дата);
		ПредставлениеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");
		
		ПодразделениеОтветственныхЛиц = ВыборкаДокументов.ПодразделениеОрганизации;
		
		ОтветственныеЛица = ОтветственныеЛицаБП.ОтветственныеЛица(ВыборкаДокументов.Организация, ВыборкаДокументов.Дата, ПодразделениеОтветственныхЛиц);
		
		ВыборкаСтрок = ВыборкаДокументов.Выбрать(ОбходРезультатаЗапроса.Прямой);
		
		Если ВыборкаСтрок.Количество() = 1 Тогда
			ВыборкаСтрок.Следующий();
			
			ЭтоАвто = (ВыборкаСтрок.Автотранспорт);
			Макет = ?(ЭтоАвто, МакетОС4А, МакетОС4);
			
			ДанныеФизЛица = УправлениеВнеоборотнымиАктивамиПереопределяемый.ДанныеФизЛица(ВыборкаДокументов.Организация, ВыборкаДокументов.МОЛ, ВыборкаДокументов.Дата, Истина);
			
			Страница1 = Макет.ПолучитьОбласть("Страница1");
			Страница1.Параметры.Заполнить(ВыборкаСтрок);
			Страница1.Параметры.Организация = ПредставлениеОрганизации;
			Страница1.Параметры.ТабНомерМОЛ = ДанныеФизЛица.ТабельныйНомер;
			
			ДокументВводаВЭксплуатацию = ВыборкаСтрок.ДокументВводаВЭксплуатацию;
			ВведеноВЭксплуатацию = ВыборкаСтрок.ДатаПринятияКУчету;
			
			Если ЭтоАвто Тогда
				Страница1.Параметры.ВведеноВЭксплуатацию = ВведеноВЭксплуатацию;
				Если ДокументВводаВЭксплуатацию = Неопределено Тогда
					Страница1.Параметры.Пробег = ПолучитьПробегАвто(ВыборкаСтрок.ОС, ВыборкаСтрок.Дата, ВыборкаСтрок.Дата, ВыборкаСтрок.Организация);
				Иначе
					Страница1.Параметры.Пробег = ПолучитьПробегАвто(ВыборкаСтрок.ОС, ДокументВводаВЭксплуатацию.Дата, ВыборкаСтрок.Дата, ВыборкаСтрок.Организация);
				КонецЕсли;
			Иначе
				Страница1.Параметры.СрокЭкспл = ?(
					ЗначениеЗаполнено(ВведеноВЭксплуатацию),
					ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
						УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ВведеноВЭксплуатацию, ВыборкаСтрок.Дата), Ложь),
					0);
			КонецЕсли;
			
			СтоимостьОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				ВыборкаСтрок.НачСтоимость,
				ВыборкаСтрок.Стоимость);
			
			АмортизацияОС = ?(ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				0,
				ВыборкаСтрок.НачАмортизация);
			
			Страница1.Параметры.ГодВыпуска     = ?(ЗначениеЗаполнено(ВыборкаСтрок.ГодВыпуска), Год(ВыборкаСтрок.ГодВыпуска), 0);
			Страница1.Параметры.ПринятоКУчету  = ВведеноВЭксплуатацию;
			Страница1.Параметры.НачСтоимость   = СтоимостьОС;
			Страница1.Параметры.НачАмортизация = АмортизацияОС;
			
			Страница1.Параметры.ОстСтоимость = ?(
				ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
				0,
				СтоимостьОС - АмортизацияОС);
			
			Страница1.Параметры.Руководитель          = ОтветственныеЛица.РуководительПредставление;
			Страница1.Параметры.ДолжностьРуководителя = ОтветственныеЛица.РуководительДолжностьПредставление;
			
			Страница1.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаСтрок.Номер);
			
			ТабличныйДокумент.Вывести(Страница1);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			Страница2_Шапка = Макет.ПолучитьОбласть("Страница2_Шапка");
			ТабличныйДокумент.Вывести(Страница2_Шапка);
			
			Если ЭтоАвто Тогда
				
				Страница2_Таблица3_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица3_Шапка");
				ТабличныйДокумент.Вывести(Страница2_Таблица3_Шапка);
				
				Страница2_Таблица3_Строка = Макет.ПолучитьОбласть("Страница2_Таблица3_Строка");
				ТаблицаДМ = ВыборкаСтрок.ДрагоценныеМатериалы.Выгрузить();
				Если ИспользоватьУчетДМ И ТаблицаДМ.Количество()<>0 Тогда
					Для Каждого СтрокаДМ Из ТаблицаДМ Цикл
						Страница2_Таблица3_Строка.Параметры.Заполнить(СтрокаДМ);
						ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
					КонецЦикла;
				Иначе
					Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
						ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
					КонецЦикла;
				КонецЕсли;
				Страница2_Таблица3_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица3_Подвал");
				ТабличныйДокумент.Вывести(Страница2_Таблица3_Подвал);
				
				Страница2_Подвал = Макет.ПолучитьОбласть("Страница2_Подвал");
				ТабличныйДокумент.Вывести(Страница2_Подвал);
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
				Страница3_Шапка = Макет.ПолучитьОбласть("Страница3_Шапка");
				ТабличныйДокумент.Вывести(Страница3_Шапка);
				Страница3_Таблица4_Шапка = Макет.ПолучитьОбласть("Страница3_Таблица4_Шапка");
				ТабличныйДокумент.Вывести(Страница3_Таблица4_Шапка);
				Страница3_Таблица4_Строка = Макет.ПолучитьОбласть("Страница3_Таблица4_Строка");
				Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
					ТабличныйДокумент.Вывести(Страница3_Таблица4_Строка);
				КонецЦикла;
				Страница3_Таблица4_Подвал = Макет.ПолучитьОбласть("Страница3_Таблица4_Подвал");
				ТабличныйДокумент.Вывести(Страница3_Таблица4_Подвал);
				Страница3_Таблица5_Шапка = Макет.ПолучитьОбласть("Страница3_Таблица5_Шапка");
				ТабличныйДокумент.Вывести(Страница3_Таблица5_Шапка);
				Страница3_Таблица5_Строка = Макет.ПолучитьОбласть("Страница3_Таблица5_Строка");
				
				ИтогСумма = 0;
				НетПрочихОприходований = Истина;
				Если ВыборкаПрочихОприходований <> Неопределено Тогда
					ВыборкаПрочихОприходований.Сбросить();
					Если ВыборкаПрочихОприходований.НайтиСледующий(Новый Структура("Ссылка", ВыборкаСтрок.Ссылка)) Тогда
						НетПрочихОприходований = Ложь;
						ВыборкаТоваров = ВыборкаПрочихОприходований.Выбрать();
						Пока ВыборкаТоваров.Следующий() Цикл
							ИтогСумма = ИтогСумма + ВыборкаТоваров.УзелСумма;
							Страница3_Таблица5_Строка.Параметры.Заполнить(ВыборкаТоваров);
							ДанныеДокумента = Новый Структура(
								"Номер,Дата",
								ВыборкаТоваров.УзелДокументНомер, ВыборкаТоваров.УзелДокументДата);
							Страница3_Таблица5_Строка.Параметры.УзелДокумент = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
								ДанныеДокумента,
								НСтр("ru = 'Прочее оприходование';
									|en = 'Other recording as received'"));
							Страница3_Таблица5_Строка.Параметры.УзелНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
								ВыборкаТоваров.УзелНоменклатураНаименованиеПолное,
								ВыборкаТоваров.УзелХарактеристикаНаименованиеПолное);
							ТабличныйДокумент.Вывести(Страница3_Таблица5_Строка);
						КонецЦикла;
					КонецЕсли;
				КонецЕсли; 
					
				Если НетПрочихОприходований Тогда
					Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
						ТабличныйДокумент.Вывести(Страница3_Таблица5_Строка);
					КонецЦикла;
				КонецЕсли;
				
				Страница3_Таблица5_Подвал = Макет.ПолучитьОбласть("Страница3_Таблица5_Подвал");
				Страница3_Таблица5_Подвал.Параметры.ИтогСумма = ИтогСумма;
				ТабличныйДокумент.Вывести(Страница3_Таблица5_Подвал);
				
			Иначе
				Страница2_Таблица2_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица2_Шапка");
				ТабличныйДокумент.Вывести(Страница2_Таблица2_Шапка);
				
				Страница2_Таблица2_Строка = Макет.ПолучитьОбласть("Страница2_Таблица2_Строка");
				ТаблицаДМ = ВыборкаСтрок.ДрагоценныеМатериалы.Выгрузить();
				Если ИспользоватьУчетДМ И ТаблицаДМ.Количество()<>0 Тогда
					Для Каждого СтрокаДМ Из ТаблицаДМ Цикл
						Страница2_Таблица2_Строка.Параметры.Заполнить(СтрокаДМ);
						ТабличныйДокумент.Вывести(Страница2_Таблица2_Строка);
					КонецЦикла;
				Иначе
					Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
						ТабличныйДокумент.Вывести(Страница2_Таблица2_Строка);
					КонецЦикла;
				КонецЕсли;
				Страница2_Таблица2_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица2_Подвал");
				ТабличныйДокумент.Вывести(Страница2_Таблица2_Подвал);
				
				Страница2_Таблица3_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица3_Шапка");
				ТабличныйДокумент.Вывести(Страница2_Таблица3_Шапка);
				Страница2_Таблица3_Строка = Макет.ПолучитьОбласть("Страница2_Таблица3_Строка");
				
				ИтогСумма = 0;
				НетПрочихОприходований = Истина;
				Если ВыборкаПрочихОприходований <> Неопределено Тогда
					ВыборкаПрочихОприходований.Сбросить();
					Если ВыборкаПрочихОприходований.НайтиСледующий(Новый Структура("Ссылка", ВыборкаСтрок.Ссылка)) Тогда
						НетПрочихОприходований = Ложь;
						ВыборкаТоваров = ВыборкаПрочихОприходований.Выбрать();
						Пока ВыборкаТоваров.Следующий() Цикл
							ИтогСумма = ИтогСумма + ВыборкаТоваров.УзелСумма;
							Страница2_Таблица3_Строка.Параметры.Заполнить(ВыборкаТоваров);
							ДанныеДокумента = Новый Структура(
								"Номер,Дата",
								ВыборкаТоваров.УзелДокументНомер, ВыборкаТоваров.УзелДокументДата);
							Страница2_Таблица3_Строка.Параметры.УзелДокумент = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(
								ДанныеДокумента,
								НСтр("ru = 'Прочее оприходование';
									|en = 'Other recording as received'"));
							Страница2_Таблица3_Строка.Параметры.УзелНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
								ВыборкаТоваров.УзелНоменклатураНаименованиеПолное,
								ВыборкаТоваров.УзелХарактеристикаНаименованиеПолное);
							ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
						КонецЦикла;
					КонецЕсли; 
				КонецЕсли;
					
				Если НетПрочихОприходований Тогда
					Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
						ТабличныйДокумент.Вывести(Страница2_Таблица3_Строка);
					КонецЦикла;
				КонецЕсли;
				
				Страница2_Таблица3_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица3_Подвал");
				Страница2_Таблица3_Подвал.Параметры.ИтогСумма = ИтогСумма;
				ТабличныйДокумент.Вывести(Страница2_Таблица3_Подвал);
				
			КонецЕсли;
			
		Иначе // Табличная часть состоит из нескольких строк
			
			Макет = МакетОС4Б;
			
			ДанныеФизЛица = УправлениеВнеоборотнымиАктивамиПереопределяемый.ДанныеФизЛица(ВыборкаДокументов.Организация, ВыборкаДокументов.МОЛ, ВыборкаДокументов.Дата, Истина);
			
			ПерваяИтерация = Истина;
			СсылкаДокумента = Неопределено;
			Пока ВыборкаСтрок.Следующий() Цикл
				
				Если ПерваяИтерация Тогда
					
					СсылкаДокумента = ВыборкаСтрок.Ссылка;
					
					Страница1_Шапка = Макет.ПолучитьОбласть("Страница1_Шапка");
					
					Страница1_Шапка.Параметры.Заполнить(ВыборкаСтрок);
					Страница1_Шапка.Параметры.Организация           = ПредставлениеОрганизации;
					Страница1_Шапка.Параметры.Руководитель          = ОтветственныеЛица.РуководительПредставление;
					Страница1_Шапка.Параметры.ДолжностьРуководителя = ОтветственныеЛица.РуководительДолжностьПредставление;
					Страница1_Шапка.Параметры.ТабНомерМОЛ           = ДанныеФизЛица.ТабельныйНомер;
					
					Страница1_Шапка.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаСтрок.Номер);
					
					ТабличныйДокумент.Вывести(Страница1_Шапка);
					
					Страница1_Таблица1_Шапка = Макет.ПолучитьОбласть("Страница1_Таблица1_Шапка");
					Страница1_Таблица1_Шапка.Параметры.Заполнить(ВыборкаСтрок);
					ТабличныйДокумент.Вывести(Страница1_Таблица1_Шапка);
					
					ПерваяИтерация = Ложь;
					
				КонецЕсли;
				
				Страница1_Таблица1_Строка = Макет.ПолучитьОбласть("Страница1_Таблица1_Строка");
				Страница1_Таблица1_Строка.Параметры.Заполнить(ВыборкаСтрок);
				СтоимостьОС = ?(
					ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					ВыборкаСтрок.НачСтоимость,
					ВыборкаСтрок.Стоимость);
				АмортизацияОС = ?(
					ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					0,
					ВыборкаСтрок.НачАмортизация);
				
				Страница1_Таблица1_Строка.Параметры.НачСтоимость = СтоимостьОС;
				Страница1_Таблица1_Строка.Параметры.НачАмортизация = АмортизацияОС;
				Страница1_Таблица1_Строка.Параметры.ОстСтоимость = ?(
					ВыборкаСтрок.ПорядокПогашенияСтоимости = Перечисления.ПорядокПогашенияСтоимостиОС.СписаниеПриПринятииКУчету,
					0,
					СтоимостьОС - АмортизацияОС);
				
				Страница1_Таблица1_Строка.Параметры.Причина = ВыборкаСтрок.ПричинаСписания;
				
				ДокументВводаВЭксплуатацию = ВыборкаСтрок.ДокументВводаВЭксплуатацию;
				ВведеноВЭксплуатацию       = ВыборкаСтрок.ДатаПринятияКУчету;
				
				Страница1_Таблица1_Строка.Параметры.СрокЭкспл = ?(
					ЗначениеЗаполнено(ВведеноВЭксплуатацию),
					ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
						УправлениеВнеоборотнымиАктивами.ОпределитьФактическийСрокИспользования(ВведеноВЭксплуатацию, ВыборкаСтрок.Дата), Ложь),
					0);
				
				ПерваяИтерацияДМ = Истина;
				ТаблицаДМ = ВыборкаСтрок.ДрагоценныеМатериалы.Выгрузить();
				Если ИспользоватьУчетДМ И ТаблицаДМ.Количество()<>0 Тогда
					Для Каждого СтрокаДМ Из ТаблицаДМ Цикл
						Если Не ПерваяИтерацияДМ Тогда
							Страница1_Таблица1_Строка = Макет.ПолучитьОбласть("Страница1_Таблица1_Строка");
						КонецЕсли;
						ПерваяИтерацияДМ = Ложь;
						Страница1_Таблица1_Строка.Параметры.Заполнить(СтрокаДМ);
						ТабличныйДокумент.Вывести(Страница1_Таблица1_Строка);
					КонецЦикла;
				Иначе
					ТабличныйДокумент.Вывести(Страница1_Таблица1_Строка);
				КонецЕсли;
				
			КонецЦикла;
			Страница1_Подвал = Макет.ПолучитьОбласть("Страница1_Подвал");
			ТабличныйДокумент.Вывести(Страница1_Подвал);
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
			Страница2_Шапка = Макет.ПолучитьОбласть("Страница2_Шапка");
			ТабличныйДокумент.Вывести(Страница2_Шапка);
			Страница2_Таблица2_Шапка = Макет.ПолучитьОбласть("Страница2_Таблица2_Шапка");
			ТабличныйДокумент.Вывести(Страница2_Таблица2_Шапка);
			Страница2_Таблица2_Строка = Макет.ПолучитьОбласть("Страница2_Таблица2_Строка");
			
			ИтогСумма = 0;
			НетПрочихОприходований = Истина;
			Если ВыборкаПрочихОприходований <> Неопределено Тогда
				ВыборкаПрочихОприходований.Сбросить();
				Если ВыборкаПрочихОприходований.НайтиСледующий(Новый Структура("Ссылка", СсылкаДокумента)) Тогда
					НетПрочихОприходований = Ложь;
					ВыборкаТоваров = ВыборкаПрочихОприходований.Выбрать();
					Пока ВыборкаТоваров.Следующий() Цикл
						ИтогСумма = ИтогСумма + ВыборкаТоваров.УзелСумма;
						Страница2_Таблица2_Строка.Параметры.Заполнить(ВыборкаТоваров);
						Страница2_Таблица2_Строка.Параметры.УзелДокументНаименование = НСтр("ru = 'Прочее оприходование';
																							|en = 'Other recording as received'");
						Страница2_Таблица2_Строка.Параметры.УзелДокументНомер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
							ВыборкаТоваров.УзелДокументНомер);
						Страница2_Таблица2_Строка.Параметры.УзелНаименование = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
							ВыборкаТоваров.УзелНоменклатураНаименованиеПолное,
							ВыборкаТоваров.УзелХарактеристикаНаименованиеПолное);
						ТабличныйДокумент.Вывести(Страница2_Таблица2_Строка);
					КонецЦикла;
				КонецЕсли; 
			КонецЕсли; 
			
			Если НетПрочихОприходований Тогда
				Для к=0 По 6 Цикл // Пустые строки для заполнения вручную
					ТабличныйДокумент.Вывести(Страница2_Таблица2_Строка);
				КонецЦикла;
			КонецЕсли;
			Страница2_Таблица2_Подвал = Макет.ПолучитьОбласть("Страница2_Таблица2_Подвал");
			Страница2_Таблица2_Подвал.Параметры.ИтогСумма = ИтогСумма;
			ТабличныйДокумент.Вывести(Страница2_Таблица2_Подвал);
			
		КонецЕсли;
		
		Подвал = Макет.ПолучитьОбласть(?(ЭтоАвто, "Страница3_Подвал", "Страница2_Подвал"));
		Подвал.Параметры.ГлавБух = ОтветственныеЛица.ГлавныйБухгалтерПредставление;
		ТабличныйДокумент.Вывести(Подвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаДокументов.Ссылка);
		
		Если НЕ ВыборкаДокументов.СведенияАктуальны Тогда
			СведенияАктуальны = Ложь;
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПробегАвто(ОбъектОС, НачДата, КонДата, Организация)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ЕСТЬNULL(НаработкиПериодОкончание.Значение, 0) - ЕСТЬNULL(НаработкиПериодНачало.Значение, 0) КАК Пробег
		|ИЗ
		|	РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(&НачГраница, ОбъектЭксплуатации = &ОС) КАК НаработкиПериодНачало
		|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.НаработкиОбъектовЭксплуатации.СрезПоследних(&КонГраница, ОбъектЭксплуатации = &ОС) КАК НаработкиПериодОкончание
		|		ПО НаработкиПериодНачало.ОбъектЭксплуатации = НаработкиПериодОкончание.ОбъектЭксплуатации
		|			И НаработкиПериодНачало.ПоказательНаработки = НаработкиПериодОкончание.ПоказательНаработки");
	
	Запрос.УстановитьПараметр("НачГраница", Новый Граница(НачДата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("КонГраница", Новый Граница(КонДата, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ОС", ОбъектОС);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Пробег;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
