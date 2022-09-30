#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс 

// Функция формирует HTML текст оповещения по бюджетной задаче.
//
// Параметры:
//  ВидОповещения - ПеречислениеСсылка.ВидыОповещенийБюджетныхЗадач - Вид оповещения бюджетных задач.
//  Параметры - Структура - Параметры письма.
//   *Исполнитель - СправочникСсылка.Пользователи - Параметр исполнитель.
//   *БюджетнаяЗадача - ЗадачаСсылка.БюджетнаяЗадача - Параметр бюджетная задача.
//  КодЯзыкаИсполнителя - Строка - Код языка, на котором будет написано письмо исполнителю бюджетной задачи. 
//
// Возвращаемое значение:
//  Строка - Текст в формате HTML.
//
Функция ПолучитьПараметрыПисьмаПоШаблону(ВидОповещения, Параметры, КодЯзыкаИсполнителя) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Тема",      Неопределено);
	Результат.Вставить("Тело",      Неопределено);
	Результат.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.HTML);
	Результат.Вставить("Кодировка", "UTF-8");
	Результат.Вставить("Важность",  Неопределено);
	
	Если ВидОповещения = Перечисления.ВидыОповещенийБюджетныхЗадач.ЗадачаПоступила Тогда
		Результат.Тема = НСтр("ru = 'Поступила новая задача';
								|en = 'New task was received'", КодЯзыкаИсполнителя);
		Результат.Важность = ВажностьИнтернетПочтовогоСообщения.Обычная;
		
	ИначеЕсли ВидОповещения = Перечисления.ВидыОповещенийБюджетныхЗадач.ЗадачаПодходитСрок Тогда
		Результат.Тема = НСтр("ru = 'Подходит к концу срок исполнения задачи';
								|en = 'Task deadline is coming to an end'", КодЯзыкаИсполнителя);
		Результат.Важность = ВажностьИнтернетПочтовогоСообщения.Высокая;
		
	ИначеЕсли ВидОповещения = Перечисления.ВидыОповещенийБюджетныхЗадач.ЗадачаПросрочена Тогда
		Результат.Тема = НСтр("ru = 'Просрочено исполнение задачи';
								|en = 'Overdue task execution'", КодЯзыкаИсполнителя);
		Результат.Важность = ВажностьИнтернетПочтовогоСообщения.Наивысшая;
		
	КонецЕсли;
	
	ДобавитьТелоПисьма(ВидОповещения, Параметры, Результат, КодЯзыкаИсполнителя);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьТелоПисьма(ВидОповещения, Параметры, Результат, КодЯзыкаИсполнителя)
	
	Реквизиты = Новый Структура("Пол", "ФизическоеЛицо.Пол");
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Параметры.Исполнитель, Реквизиты);
	
	Параметры.Вставить("Обращение", НСтр("ru = 'Здравствуйте';
										|en = 'Hello'", КодЯзыкаИсполнителя));
	Если Реквизиты.Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
		Параметры.Обращение = НСтр("ru = 'Уважаемый';
									|en = 'Dear'", КодЯзыкаИсполнителя);
		
	ИначеЕсли Реквизиты.Пол = Перечисления.ПолФизическогоЛица.Женский Тогда
		Параметры.Обращение = НСтр("ru = 'Уважаемая';
									|en = 'Dear'", КодЯзыкаИсполнителя);
		
	КонецЕсли;
	
	АдресПубликацииИнформационнойБазыВЛокальнойСети = 
		ОбщегоНазначения.АдресПубликацииИнформационнойБазыВЛокальнойСети();
	Если НЕ ПустаяСтрока(АдресПубликацииИнформационнойБазыВЛокальнойСети) Тогда
		АдресСсылки =
			АдресПубликацииИнформационнойБазыВЛокальнойСети + "#" +  ПолучитьНавигационнуюСсылку(Параметры.БюджетнаяЗадача);
		СсылкаНаЗадачу = НСтр("ru = 'Для просмотра задачи перейдите по ссылке: <a href=""%1"">%2</a>';
								|en = 'To view the task, click: <a href=""%1"">%2</a>'", КодЯзыкаИсполнителя);
		СсылкаНаЗадачу = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СсылкаНаЗадачу, АдресСсылки, АдресСсылки);
		
	Иначе
		ИмяЯрлыкаИБ = НСтр("ru = 'Запустить информационную базу';
							|en = 'Start infobase'", КодЯзыкаИсполнителя);
		Результат.Вставить("ИмяЯрлыкаИБ", ИмяЯрлыкаИБ);
		СсылкаНаЗадачу = 
			НСтр("ru = 'Для того чтобы открыть информационную базу Вы можете воспользоваться вложенным файлом ""%1"".';
				|en = 'To open the infobase, you can use the ""%1"" attached file.'", КодЯзыкаИсполнителя);
		СсылкаНаЗадачу = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СсылкаНаЗадачу, ИмяЯрлыкаИБ);
	
	КонецЕсли;
	
	Параметры.Вставить("СсылкаНаЗадачу", СсылкаНаЗадачу);
	
	Если ВидОповещения = Перечисления.ВидыОповещенийБюджетныхЗадач.ЗадачаПоступила Тогда
		МакетШаблонаТекста = ПолучитьМакет("HTMLШаблонПисьмаПоступила");
	ИначеЕсли ВидОповещения = Перечисления.ВидыОповещенийБюджетныхЗадач.ЗадачаПодходитСрок Тогда
		МакетШаблонаТекста = ПолучитьМакет("HTMLШаблонПисьмаПодходитСрок");
	Иначе
		МакетШаблонаТекста = ПолучитьМакет("HTMLШаблонПисьмаПросрочено");
	КонецЕсли;
	МакетШаблонаТекста.КодЯзыкаМакета = КодЯзыкаИсполнителя;
	
	ТекстHTML = МакетШаблонаТекста.ПолучитьТекст();
	
	ТекстHTML = ЗаполнитьШаблонЗначениямиПодстановки(ТекстHTML, Параметры, КодЯзыкаИсполнителя);
	
	Результат.Тело = ТекстHTML;
	
КонецПроцедуры

Функция ЗаполнитьШаблонЗначениямиПодстановки(ШаблонТекста, ЗначенияПодстановки, КодЯзыкаИсполнителя)
	
	КодФорматнойСтроки = СтрШаблон(НСтр("ru = 'Л=%1; ДЛФ=DD';
										|en = 'L=%1; DLF=DD'", КодЯзыкаИсполнителя), "ru_RU");
	Результат = ШаблонТекста;
	Для Каждого Параметр Из ЗначенияПодстановки Цикл
		Результат = СтрЗаменить(Результат, "[" + Параметр.Ключ + "]",
		                       ?(ТипЗнч(Параметр.Значение) = Тип("Дата"),
		                       Формат(Параметр.Значение, КодФорматнойСтроки), Параметр.Значение));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли