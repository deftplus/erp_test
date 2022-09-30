#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс	
	
// Функция - Выполнить авто заполнение
// Выполняет последовательный расчет документов сначала классическим, а затем расширенным алгоритмом пересчета показателей
// 
// Возвращаемое значение:
//	Структура - Структура с результатами расчета 
//
Функция ВыполнитьАвтоЗаполнение() Экспорт
	
	Если Не ЗначениеЗаполнено(ВидГруппаОтчета) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТзРезультатВыполнения = Новый ТаблицаЗначений;
	ТзРезультатВыполнения.Колонки.Добавить("Результат");
	ТзРезультатВыполнения.Колонки.Добавить("РезультатКлассическийДвижок");
	ТзРезультатВыполнения.Колонки.Добавить("РезультатСравненияЭталон");
	ТзРезультатВыполнения.Колонки.Добавить("РезультатСравненияКлассическийДвижок");
	ТзРезультатВыполнения.Колонки.Добавить("ВидОтчета");
	ТзРезультатВыполнения.Колонки.Добавить("ПравилоОбработки");
	ТзРезультатВыполнения.Колонки.Добавить("ЭкземплярОтчета");
	ТзРезультатВыполнения.Колонки.Добавить("МакетЭталон");
	ТзРезультатВыполнения.Колонки.Добавить("Макет");
	ТзРезультатВыполнения.Колонки.Добавить("МакетКлассическийДвижок");
	ТзРезультатВыполнения.Колонки.Добавить("ВремяВычисления");
	ТзРезультатВыполнения.Колонки.Добавить("ВремяЗаполнения");
	ТзРезультатВыполнения.Колонки.Добавить("ЦелевоеВремяЗаполнения");
	ТзРезультатВыполнения.Колонки.Добавить("ВремяЗаполненияКлассическийДвижок");
	ТзРезультатВыполнения.Колонки.Добавить("ВремяРасчетаПараметрики");
	ТзРезультатВыполнения.Колонки.Добавить("ВремяРасчетаПараметрикиКлассическийДвижок");
	ТзРезультатВыполнения.Колонки.Добавить("ОписаниеОшибки");
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("БылиОшибки",Ложь);
	СтруктураРезультат.Вставить("Протокол");
	
	// Запомним старое значение константы
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Константа.ИспользоватьРасширенныйАлгоритмПересчетаПоказателей");
		Блокировка.Добавить("Константа.ИспользоватьРежимТрассировкиПересчетаПоказателей");
		Блокировка.Заблокировать();
	
		РасширенныйАлгоритмИзначальный = Константы.ИспользоватьРасширенныйАлгоритмПересчетаПоказателей.Получить();
		РежимТрассировкиИзначальный	= Константы.ИспользоватьРежимТрассировкиПересчетаПоказателей.Получить();
	
		Константы.ИспользоватьРежимТрассировкиПересчетаПоказателей.Установить(Ложь);
		
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось выполнить процедуру вычисления, по причине: %1'"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		ОтменитьТранзакцию();
		СтруктураРезультат.БылиОшибки = Истина;
		Возврат СтруктураРезультат; 
	КонецПопытки;
	
	// Если на входе группа - последовательно тестируем все отчеты в группе, упорядоченные по наименованию.
	МассивОбрабатываемыхОтчетов = Новый Массив;
	Если ВидГруппаОтчета.ЭтоГруппа Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыОтчетов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыОтчетов КАК ВидыОтчетов
		|ГДЕ
		|	ВидыОтчетов.ПометкаУдаления = ЛОЖЬ
		|	И ВидыОтчетов.Родитель В ИЕРАРХИИ(&Родитель)
		|	И ВидыОтчетов.ЭтоГруппа = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВидыОтчетов.Наименование УБЫВ";
		
		Запрос.УстановитьПараметр("Родитель",ВидГруппаОтчета);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			МассивОбрабатываемыхОтчетов.Добавить(Выборка.Ссылка);
		КонецЦикла;
		
	Иначе		
		МассивОбрабатываемыхОтчетов.Добавить(ВидГруппаОтчета);	
	КонецЕсли;	
	
	// По выбранным видам отчетов:
	БылиОшибкиВДаннойТранзакции = Ложь;
	Для СчДвижок = 1 По ?(СравнениеСКлассическимАлгоритмомРасчета, 2, 1) Цикл
		
		Для Каждого ВидОтчета Из МассивОбрабатываемыхОтчетов Цикл
			
			Если БылиОшибкиВДаннойТранзакции Тогда
				Прервать;
			КонецЕсли;
			
			// Ищем экземпляры 
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	НастраиваемыйОтчет.Ссылка КАК Ссылка,
				|	ЕСТЬNULL(ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей.ЭталонныйМакет, НЕОПРЕДЕЛЕНО) КАК ЭталонныйМакет,
				|	ЕСТЬNULL(ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей.ЦелевоеВремяЗаполнения, 0) КАК ЦелевоеВремяЗаполнения,
				|	ЕСТЬNULL(ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей.РассчитыватьКлассическимАлгоритмомРасчета, ИСТИНА) КАК РассчитыватьКлассическимАлгоритмомРасчета
				|ИЗ
				|	Документ.НастраиваемыйОтчет КАК НастраиваемыйОтчет
				|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей КАК ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей
				|		ПО (ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей.ЭкземплярОтчета = НастраиваемыйОтчет.Ссылка)
				|ГДЕ
				|	НастраиваемыйОтчет.ВидОтчета = &ВидОтчета
				|	И НастраиваемыйОтчет.Проведен
				|	И НастраиваемыйОтчет.УправлениеПериодом.ВерсияОрганизационнойСтруктуры.РежимМногопериодныхУОП %ОтборРегистратор% %ОтборЭталонныйМакет%
				|
				|УПОРЯДОЧИТЬ ПО
				|	НастраиваемыйОтчет.Организация.Родитель УБЫВ";
		
			Если ЗначениеЗаполнено(ЭкземплярОтчета) Тогда  
				Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ОтборРегистратор%","
				|	И НастраиваемыйОтчет.Ссылка = &Ссылка");
				Запрос.УстановитьПараметр("Ссылка",ЭкземплярОтчета);
			Иначе
				Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ОтборРегистратор%","");
			КонецЕсли;
			
			Если СравнениеСКлассическимАлгоритмомРасчета Тогда
				Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ОтборЭталонныйМакет%","");
			Иначе
				// Только сравнение с эталоном
				Запрос.Текст = СтрЗаменить(Запрос.Текст,"%ОтборЭталонныйМакет%","
				|	И НЕ ХранилищаЭталонныхМакетовТестированияПересчетаПоказателей.ЭталонныйМакет ЕСТЬ NULL");
			КонецЕсли;			
			
			Запрос.УстановитьПараметр("ВидОтчета",ВидОтчета);
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();		
			
			Пока Выборка.Следующий() Цикл
				
				тЭкземплярОбъект 		= Выборка.Ссылка.ПолучитьОбъект();
				ОбъектРасчета 			= тЭкземплярОбъект.ПодготовитьСтруктуруПеременныхДляРасчета();
				
				Если СчДвижок = 1 Тогда					
					
					нСтр 							= ТзРезультатВыполнения.Добавить();
					нСтр.ВидОтчета 					= ВидОтчета;
					нСтр.ЭкземплярОтчета  			= Выборка.Ссылка;
					нСтр.ПравилоОбработки			= ОбъектРасчета.ПравилоОбработки;
					нСтр.ВремяРасчетаПараметрики 	= 0;	
					нСтр.ЦелевоеВремяЗаполнения 	= Выборка.ЦелевоеВремяЗаполнения;
					нСтр.ВремяРасчетаПараметрикиКлассическийДвижок = 0;
					нСтр.РезультатКлассическийДвижок = Ложь;
			
					// Удаляем все предыдущие версии  
					УправлениеРасчетомПоказателей.ОчиститьСтарыеДанные(ОбъектРасчета,Истина,Истина,Истина);
					Попытка
						ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
						УправлениеРасчетомПоказателей.ПолучитьТаблицуРасчетаПоказателейПоПравилуРасчета(ОбъектРасчета.ПравилоОбработки);
						ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
						нСтр.ВремяРасчетаПараметрики = ВремяОкончания - ВремяНачала;
					Исключение 
						
						ИнформацияОбОшибке = ИнформацияОбОшибке();				
						ТекстСообщения = СтрШаблон(НСтр("ru = 'Ошибка подготовки параметрики. Текст ошибки: %1'"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
						
						нСтр.ОписаниеОшибки         = ТекстСообщения;
						нСтр.Результат              = Ложь;
						
						// Если параметрика не рассчиталась, дальнейшие тесты по этому варианту делать не нужно
						СтруктураРезультат.БылиОшибки = Истина;	
						БылиОшибкиВДаннойТранзакции = Истина;
						Продолжить; 		
						
					КонецПопытки;
				ИначеЕсли НЕ Выборка.РассчитыватьКлассическимАлгоритмомРасчета Тогда
					Продолжить;
				Иначе
					нСтр = ТзРезультатВыполнения.Найти(Выборка.Ссылка,"ЭкземплярОтчета");
					УправлениеРасчетомПоказателей.ОчиститьСтарыеДанные(ОбъектРасчета,Истина,Ложь,Истина);
					ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
					УправлениеОтчетамиУХ.ПодготовитьДанныеПараметрическойНастройки(ОбъектРасчета);
					ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
					нСтр.ВремяРасчетаПараметрикиКлассическийДвижок = ВремяОкончания - ВремяНачала;
				КонецЕсли;
				
				Если Выборка.ЭталонныйМакет = Неопределено Тогда
					нСтр.МакетЭталон = Неопределено;
				Иначе
					нСтр.МакетЭталон = Выборка.ЭталонныйМакет.Получить();
				КонецЕсли;
				нСтр.РезультатСравненияКлассическийДвижок = Неопределено;
				нСтр.РезультатСравненияЭталон = Неопределено;
				
				Если СчДвижок = 1 Тогда
					
					// Заполняем по регламенту расширенным алгоритмом
					Константы.ИспользоватьРасширенныйАлгоритмПересчетаПоказателей.Установить(Истина);
			
					Для Сч = 1 По ЧислоВыполнений Цикл
						
						// Расчет												
						Попытка					
							
							ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
							нСтр.Результат = тЭкземплярОбъект.ЗаполнитьОтчетПоУмолчанию();
							ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
							Если Не нСтр.Результат Тогда
								нСтр.ОписаниеОшибки = НСтр("ru = 'Ошибка расчета документа'");
								СтруктураРезультат.БылиОшибки = Истина;
							КонецЕсли;
							тЭкземплярОбъект.Записать();
							
						Исключение
							
							ИнформацияОбОшибке 				= ИнформацияОбОшибке();
			                нСтр.ОписаниеОшибки         	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
							нСтр.Результат              	= Ложь;
							СтруктураРезультат.БылиОшибки 	= Истина;
							БылиОшибкиВДаннойТранзакции		= Истина;

						КонецПопытки;						
						
						Если НЕ нСтр.Результат Тогда
							Прервать;
						КонецЕсли;
						
						Если Сч = 1 Тогда
							// Фиксируем время первого выполнения
							нСтр.ВремяЗаполнения = ВремяОкончания - ВремяНачала;
							Если НЕ тЭкземплярОбъект.ДополнительныеСвойства.Свойство("ОбщееВремяРасчетов",нСтр.ВремяВычисления) Тогда
								нСтр.ВремяВычисления = 0;
							КонецЕсли;
						КонецЕсли;
						
					КонецЦикла;					
					
					Если нСтр.Результат Тогда
						нСтр.Макет = ПолучитьТабДокПоЭкземпляру(ОбъектРасчета);
					КонецЕсли;
					
				ИначеЕсли СчДвижок = 2 И Выборка.РассчитыватьКлассическимАлгоритмомРасчета Тогда					
					// Заполняем по регламенту классическим способом
			
					Константы.ИспользоватьРасширенныйАлгоритмПересчетаПоказателей.Установить(Ложь);
					
					Для Сч = 1 По ЧислоВыполнений Цикл
						
						Попытка		
							
							ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
							нСтр.РезультатКлассическийДвижок = тЭкземплярОбъект.ЗаполнитьОтчетПоУмолчанию();
							ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
							Если НЕ нСтр.РезультатКлассическийДвижок Тогда
								нСтр.ОписаниеОшибки = НСтр("ru = 'Ошибка расчета документа'");
							КонецЕсли;
							тЭкземплярОбъект.Записать();
							
						Исключение
							
							ИнформацияОбОшибке 					= ИнформацияОбОшибке();
					        нСтр.ОписаниеОшибки         		= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
							СтруктураРезультат.БылиОшибки 		= Истина;
							БылиОшибкиВДаннойТранзакции			= Истина;
						
						КонецПопытки;					
						
						Если Не нСтр.РезультатКлассическийДвижок Тогда
							Прервать;
						КонецЕсли;
						
						Если Сч = 1 Тогда
							// Фиксируем время первого выполнения
							нСтр.ВремяЗаполненияКлассическийДвижок	= ВремяОкончания - ВремяНачала;
						КонецЕсли;	
						
					КонецЦикла;
					
					Если нСтр.РезультатКлассическийДвижок Тогда
						нСтр.МакетКлассическийДвижок = ПолучитьТабДокПоЭкземпляру(ОбъектРасчета);
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
				
		КонецЦикла;
		
	КонецЦикла;	
		
	// Вернем исходное значение констант
	Попытка
		
		Константы.ИспользоватьРасширенныйАлгоритмПересчетаПоказателей.Установить(РасширенныйАлгоритмИзначальный);
		Константы.ИспользоватьРежимТрассировкиПересчетаПоказателей.Установить(РежимТрассировкиИзначальный);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось выполнить процедуру вычисления, по причине: %1'"),ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		
	КонецПопытки;	
	
	// Сформируем протокол результатов
	ПолучитьПротоколРезультатов(ТзРезультатВыполнения,СтруктураРезультат,БылиОшибкиВДаннойТранзакции);
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТабДокПоЭкземпляру(ОбъектРасчета)
	
	ПолеТабличногоДокументаМакет = Новый ТабличныйДокумент;
	
	ОтчетАБ = Обработки.АналитическийБланк.Создать();
	ОтчетАБ.Бланк 			 		= ОбъектРасчета.ШаблонОтчета;
	ОтчетАБ.Сценарий				= ОбъектРасчета.Сценарий;
	ОтчетАБ.ПериодОтчета			= ОбъектРасчета.ПериодОтчета;
	ОтчетАБ.ПериодОтчетаОкончание 	= ОбъектРасчета.ПериодОкончания;
	ОтчетАБ.Организация 			= ОбъектРасчета.Организация;
	ОтчетАБ.Проект 			 		= ОбъектРасчета.Проект;
	ОтчетАБ.Валюта 			 		= ОбъектРасчета.ОсновнаяВалюта;		
	ОтчетАБ.ЕдиницаИзмерения 		= ОбъектРасчета.ЕдиницаИзмерения;
	ОтчетАБ.ТекущееПравило          = ОбъектРасчета.ПравилоОбработки;

	Для Инд = 1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
		ОтчетАБ["Аналитика"+Инд] = ОбъектРасчета["Аналитика"+Инд];
	КонецЦикла;		
	
	ДополнительныеНастройки = Новый КомпоновщикНастроекКомпоновкиДанных;
	СтруктураПараметров     = Новый Структура;
	СтруктураПараметров.Вставить("ПолеТабличногоДокументаМакет",ПолеТабличногоДокументаМакет);
	СтруктураПараметров.Вставить("ОбновитьДанные",Истина);
	СтруктураПараметров.Вставить("ДополнительныеНастройки",ДополнительныеНастройки); 
	СтруктураПараметров.Вставить("ТекущаяТочность",ОбъектРасчета.УровеньТочности);
	СтруктураПараметров.Вставить("ТекущийДелитель",ОбъектРасчета.ЕдиницаИзмерения);
	СтруктураПараметров.Вставить("НомерОсновногоЯзыка",ОбъектРасчета.глОсновнойЯзык);
	
	ОтчетАБ.ПолучитьРезультирующийМакет(СтруктураПараметров);
	
	Возврат ПолеТабличногоДокументаМакет;
	
КонецФункции	

Процедура ПолучитьПротоколРезультатов(ТзРезультатВыполнения,СтруктураРезультат,ТестЗавершенДосрочно)
	
	ТабДокПротокол  		= Новый ТабличныйДокумент;
	ТабДокОтличияВМакетах	= Новый ТабличныйДокумент;
	
	тМакет 					= ПолучитьМакет("ШаблонПротоколаТестирования");	
	Если СравнениеСКлассическимАлгоритмомРасчета Тогда
		ПрефиксОбласти = "_КА";
		ВремяЗаполненияРасширенныйДвижокИтого = 0;
		ВремяЗаполненияКлассическийДвижокИтого = 0;	
		ВремяПараметрикаКлассическийДвижокИтого = 0;
	Иначе
		ПрефиксОбласти = "";
	КонецЕсли;
	
	ВремяПараметрикаИтого 	= 0;
	ВремяЗаполненияИтого	= 0;
	ВремяВычисленияИтого	= 0;
	ВремяЦелевоеИтого 		= 0;
	ВремяРазницаИтого 		= 0;
	
	КартинкаОК 				= БиблиотекаКартинок.ЗеленаяГалка;
	КартинкаНеОК 			= БиблиотекаКартинок.КрасныйКрест;
	
	БылиОшибки 				= Ложь;
	ОбработкаСравнения 		= Обработки.СравнениеТабличныхДокументов.Создать();
	
	// Вывод шапки
	ТабДокПротокол.Вывести(тМакет.ПолучитьОбласть("Область_Шапка|Область_Вер1" + ПрефиксОбласти));
	ТабДокПротокол.Присоединить(тМакет.ПолучитьОбласть("Область_Шапка|Область_Вер2" + ПрефиксОбласти)); 
	
	// Вывод строк
	Для Каждого Стр Из ТзРезультатВыполнения Цикл
		
		Область_СтрокаТеста1 = тМакет.ПолучитьОбласть("Область_СтрокаТеста|Область_Вер1" + ПрефиксОбласти);
		Область_СтрокаТеста2 = тМакет.ПолучитьОбласть("Область_СтрокаТеста|Область_Вер2" + ПрефиксОбласти);
		
		Область_СтрокаТеста2.Параметры.ВидОтчета		= Стр.ВидОтчета;
		Область_СтрокаТеста2.Параметры.ЭкземплярОтчета 	= Стр.ЭкземплярОтчета;
		Область_СтрокаТеста2.Параметры.ПравилоОбработки = Стр.ПравилоОбработки;	
		Область_СтрокаТеста2.Параметры.ВремяПараметрика = Стр.ВремяРасчетаПараметрики/1000;
		
		ВремяПараметрикаИтого = ВремяПараметрикаИтого + Стр.ВремяРасчетаПараметрики;
		
		// Области сравнения с классическим движком
		Если СравнениеСКлассическимАлгоритмомРасчета Тогда
			Область_СтрокаТеста2.Параметры.ВремяПараметрикаКлассическийДвижок = Стр.ВремяРасчетаПараметрикиКлассическийДвижок/1000;
			ВремяПараметрикаКлассическийДвижокИтого = ВремяПараметрикаКлассическийДвижокИтого + Стр.ВремяРасчетаПараметрикиКлассическийДвижок;
		КонецЕсли;
		
		Если Стр.Результат Тогда
			
			ВремяЗаполненияИтого = ВремяЗаполненияИтого + Стр.ВремяЗаполнения;
			ВремяВычисленияИтого = ВремяВычисленияИтого + Стр.ВремяВычисления;
			
			Область_СтрокаТеста1.Область(1,2,1,2).Картинка = КартинкаОК;
			Область_СтрокаТеста2.Параметры.ВремяЗаполнения = Стр.ВремяЗаполнения/1000;	
			Область_СтрокаТеста2.Параметры.ВремяВычисления = Стр.ВремяВычисления/1000;
			
			// Сверяем с эталоном
			Если Стр.МакетЭталон <> Неопределено Тогда
				
				РезультатПроверкиМакетов = ОбработкаСравнения.СравнитьДваТабличныхДокумента(Стр.МакетЭталон, Стр.Макет);
				Стр.РезультатСравненияЭталон = РезультатПроверкиМакетов.ДокументыИдентичны;
				Если Стр.РезультатСравненияЭталон Тогда				
					Область_СтрокаТеста1.Область(1,3,1,3).Картинка = КартинкаОК;
					Если Стр.ЦелевоеВремяЗаполнения > 0 Тогда
						Область_СтрокаТеста2.Параметры.ВремяЦелевое = Стр.ЦелевоеВремяЗаполнения/1000;
						ВремяЦелевоеИтого = ВремяЦелевоеИтого + Стр.ЦелевоеВремяЗаполнения;
						Область_СтрокаТеста2.Параметры.ВремяРазница = (Стр.ВремяЗаполнения - Стр.ЦелевоеВремяЗаполнения)/1000;
						ВремяРазницаИтого = ВремяРазницаИтого + (Стр.ВремяЗаполнения - Стр.ЦелевоеВремяЗаполнения);
					КонецЕсли;
				Иначе
					
					БылиОшибки = Истина;
					Ошибки = СтрСоединить(РезультатПроверкиМакетов.Ошибки, Символы.ПС);
					Область_СтрокаТеста1.Область(1,3,1,3).Картинка = КартинкаНеОК;
					Стр.ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Ошибка при сравнении макетов: %1'"), Ошибки);						
					
					ТабДокОтличияВМакетах.НачатьГруппуСтрок(Стр.ЭкземплярОтчета, Ложь);
					ТабДокОтличияВМакетах.Вывести(РезультатПроверкиМакетов.ДокументРезультат);
					ТабДокОтличияВМакетах.ЗакончитьГруппуСтрок();
					
				КонецЕсли;
				
			Иначе
				
				// Сверяем с классическим движком
				Если Стр.РезультатКлассическийДвижок Тогда
					
					ВремяЗаполненияРасширенныйДвижокИтого = ВремяЗаполненияРасширенныйДвижокИтого + Стр.ВремяЗаполнения; 
					ВремяЗаполненияКлассическийДвижокИтого = ВремяЗаполненияКлассическийДвижокИтого + Стр.ВремяЗаполненияКлассическийДвижок;
					Область_СтрокаТеста2.Параметры.ВремяЗаполненияКлассическийДвижок = Стр.ВремяЗаполненияКлассическийДвижок/1000;
					
					РезультатПроверкиМакетов = ОбработкаСравнения.СравнитьДваТабличныхДокумента(Стр.МакетКлассическийДвижок, Стр.Макет);
					Стр.РезультатСравненияКлассическийДвижок = РезультатПроверкиМакетов.ДокументыИдентичны;

					Если Стр.РезультатСравненияКлассическийДвижок Тогда					
						
						Область_СтрокаТеста1.Область(1,4,1,4).Картинка = КартинкаОК;	
						Если Стр.ВремяЗаполнения = 0 Тогда
							Область_СтрокаТеста2.Параметры.ДельтаАБС   		= 0;
							Область_СтрокаТеста2.Параметры.ДельтаОТН   		= 0;
						Иначе
							ДельтаАБС = (Стр.ВремяЗаполненияКлассическийДвижок - Стр.ВремяЗаполнения)/1000;
							Область_СтрокаТеста2.Параметры.ДельтаАБС = ДельтаАБС;
							Если Стр.ВремяЗаполнения = 0 Тогда
								Область_СтрокаТеста2.Параметры.ДельтаОТН = 0;
							ИначеЕсли ДельтаАБС < 0 Тогда
								Область_СтрокаТеста2.Параметры.ДельтаОТН = -1 * (Стр.ВремяЗаполненияКлассическийДвижок)/Стр.ВремяЗаполнения;
							Иначе
								Область_СтрокаТеста2.Параметры.ДельтаОТН   		= (Стр.ВремяЗаполненияКлассическийДвижок)/Стр.ВремяЗаполнения;
							КонецЕсли;
						КонецЕсли;
						
					Иначе
						
						Если Стр.РезультатСравненияЭталон = Неопределено Тогда
							БылиОшибки = Истина;
						КонецЕсли;
						Ошибки = СтрСоединить(РезультатПроверкиМакетов.Ошибки, Символы.ПС);
						
						Область_СтрокаТеста1.Область(1,4,1,4).Картинка = КартинкаНеОК;
						Стр.ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Ошибка при сравнении макетов: %1'"), Ошибки);
						
						ТабДокОтличияВМакетах.НачатьГруппуСтрок(Стр.ЭкземплярОтчета, Ложь);
						ТабДокОтличияВМакетах.Вывести(РезультатПроверкиМакетов.ДокументРезультат);
						ТабДокОтличияВМакетах.ЗакончитьГруппуСтрок();
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			БылиОшибки = Истина;
			Область_СтрокаТеста1.Область(1,2,1,2).Картинка = КартинкаНеОК;			
		КонецЕсли;
		
		ТабДокПротокол.Вывести(Область_СтрокаТеста1);
		ТабДокПротокол.Присоединить(Область_СтрокаТеста2);
		Если НЕ ПустаяСтрока(Стр.ОписаниеОшибки) Тогда			
			ТабДокПротокол.НачатьГруппуСтрок(,Ложь);
			Область_СтрокаОшибки = тМакет.ПолучитьОбласть("Область_СтрокаОшибки|Область_Вер1" + ПрефиксОбласти);
			ТабДокПротокол.Вывести(Область_СтрокаОшибки);
			Область_СтрокаОшибки = тМакет.ПолучитьОбласть("Область_СтрокаОшибки|Область_Вер2" + ПрефиксОбласти);
			Область_СтрокаОшибки.Параметры.ОписаниеОшибки = Стр.ОписаниеОшибки;
			ТабДокПротокол.Присоединить(Область_СтрокаОшибки);
			ТабДокПротокол.ЗакончитьГруппуСтрок();
		КонецЕсли;	
		
	КонецЦикла;
	
	// Выводим подвал
	Область_СтрокаТеста = тМакет.ПолучитьОбласть("Область_Итог|Область_Вер1" + ПрефиксОбласти);
	ТабДокПротокол.Вывести(Область_СтрокаТеста);
	Область_СтрокаТеста = тМакет.ПолучитьОбласть("Область_Итог|Область_Вер2" + ПрефиксОбласти);
	Область_СтрокаТеста.Параметры.ВремяЗаполненияИтого 	= ВремяЗаполненияИтого/1000;
	Область_СтрокаТеста.Параметры.ВремяВычисленияИтого 	= ВремяВычисленияИтого/1000;
	Область_СтрокаТеста.Параметры.ВремяПараметрикаИтого = ВремяПараметрикаИтого/1000;
	Область_СтрокаТеста.Параметры.ВремяЦелевоеИтого 	= ВремяЦелевоеИтого/1000;
	Область_СтрокаТеста.Параметры.ВремяРазницаИтого 	= ВремяРазницаИтого/1000;
	
	// Области сравнения с классическим движком
	Если СравнениеСКлассическимАлгоритмомРасчета Тогда
		Область_СтрокаТеста.Параметры.ВремяЗаполненияКлассическийДвижокИтого = ВремяЗаполненияКлассическийДвижокИтого/1000;
		Область_СтрокаТеста.Параметры.ВремяПараметрикаКлассическийДвижокИтого = ВремяПараметрикаКлассическийДвижокИтого/1000;
		Если ВремяЗаполненияКлассическийДвижокИтого = 0 Тогда
			Область_СтрокаТеста.Параметры.ДельтаАБС = "";
			Область_СтрокаТеста.Параметры.ДельтаОТН = "";
		Иначе
			ДельтаАБС = (ВремяЗаполненияКлассическийДвижокИтого - ВремяЗаполненияРасширенныйДвижокИтого)/1000;
			Область_СтрокаТеста.Параметры.ДельтаАБС = ДельтаАБС;
			Если ВремяЗаполненияРасширенныйДвижокИтого = 0 Тогда
				Область_СтрокаТеста.Параметры.ДельтаОТН = "";
			ИначеЕсли ДельтаАБС < 0 Тогда
				Область_СтрокаТеста.Параметры.ДельтаОТН = -1 * ВремяЗаполненияКлассическийДвижокИтого / ВремяЗаполненияРасширенныйДвижокИтого;
			Иначе
				Область_СтрокаТеста.Параметры.ДельтаОТН = ВремяЗаполненияКлассическийДвижокИтого / ВремяЗаполненияРасширенныйДвижокИтого;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ТабДокПротокол.Присоединить(Область_СтрокаТеста);
	ТабДокПротокол.ФиксацияСверху = 4;
	
	// Если тест был завершен досрочно, то выведем предупреждение
	Если ТестЗавершенДосрочно Тогда
		Область_ЗавершенДосрочно = тМакет.ПолучитьОбласть("ЗавершенДосрочно");
		ТабДокПротокол.Вывести(Область_ЗавершенДосрочно);
	КонецЕсли;
	
	СтруктураРезультат.Вставить("БылиОшибки",БылиОшибки);
	Если ТабДокОтличияВМакетах.ВысотаТаблицы > 0 Тогда
		СтруктураРезультат.Вставить("ОтличияВМакетах",ТабДокОтличияВМакетах);		
	КонецЕсли;
	СтруктураРезультат.Вставить("Протокол",ТабДокПротокол);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли