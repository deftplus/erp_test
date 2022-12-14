// Выполняет команду обмена с ЭТП.
// В регистр сведений ЖурналОбменаСЭТП делается запись об обмене.
// Параметры:
//	КомандаОбмена - Строка, наименование команды обмена.
//	ЭТП - СправочникСсылка.ЭлектронныеТорговыеПлощадки.
//  ОбъектВыгрузки - Документ.ПрограммаЗакупки. Данные для отправки.
//	ПараметрыПодключенияКЭТП - Структура. Состав полей соответствует значению возвращаемому функцией  ШаблонОписанияПараметровПодключенияКЭТП().
//		Можно получить функцией ПолучитьПараметрыПодключенияКЭТП(ЭТП, Сотрудник).
//	ПоляОписанияТранзакции - Структура. Состав полей соответствует значению возвращаемому функцией ШаблонОписанияТранзакцииОбмена().
//		Поля, обязательные к заполнению: Статус, Сотрудник.
//	ОписаниеОповещенияОбОкончанииОбмена - ОписаниеОповещения - процедура, которая будет вызвана по окончании обмена или при возникновении ошибки.
//		В качестве результата возвращается значение ОписаниеОбмена типа Структура с полями соответствующими аргументам данной функции,
//		и добавлением полей:
//			- ИмяОбработки - Строка - полное имя вызванной формы обработки (если используется клиентский вызов);
//			- флТранзакцияЗавершиласьУспешно - Булево. Истина - обмен прошел успешно. Ложь - возникли ошибки обмена.
//				Описание ошибки см. ПоляОписанияТранзакции.ТекстОшибки, ПоляОписанияТранзакции.ОшибкаОбменаСЭТП.
//      Реквизит "ДополнительныеПараметры" всегда Неопределено.
Процедура ВыполнитьКомандуОбмена(
							КомандаОбмена,
							ЭТП,
							ОбъектВыгрузки,
							ПараметрыПодключенияКЭТП,
							ПоляОписанияТранзакции,
							ОписаниеОповещенияОбОкончанииОбмена) Экспорт
	ОписаниеОбмена = ИнтеграцияЦУЗсЭТПКлиентСерверУХ.ПолучитьОписаниеОбмена(
		КомандаОбмена,
		ЭТП,
		ОбъектВыгрузки,
		ПараметрыПодключенияКЭТП,
		ПоляОписанияТранзакции);
	Если ПоляОписанияТранзакции.ОшибкаОбменаСЭТП Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОбОкончанииОбмена, ОписаниеОбмена);
		Возврат;
	КонецЕсли;
	Попытка
		// Проверяем на сервере заполнение данных.
		// Получаем недостающие.
		// Если обмен осуществляется на сервере, то вызываем функцию обмена!
		ИнтеграцияЦУЗсЭТПСерверУХ.ОбработатьТранзакциюОбменаНаСервере(ОписаниеОбмена);
		Если ОписаниеОбмена.ПоляОписанияТранзакции.ОшибкаОбменаСЭТП
				ИЛИ ОписаниеОбмена.ПараметрыПодключенияКЭТП.ОбменНаСервере Тогда
			// в обработке транзакции на сервере уже записали все данные после обработки.
			ВыполнитьОбработкуОповещения(
				ОписаниеОповещенияОбОкончанииОбмена, 
				ОписаниеОбмена);
			Возврат;
		КонецЕсли;
		// Выполняем обмен на клиенте.
		Параметры = Новый Структура("ОписаниеОбмена", ОписаниеОбмена);
		// Выполняем команду через вызов формы обработки обмена
		ОткрытьФорму(ОписаниеОбмена.ИмяФормыОбмена, Параметры, ИнтеграцияЦУЗсЭТПКлиентУХ, Истина,,, ОписаниеОповещенияОбОкончанииОбмена, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Исключение
		Инфо = ИнформацияОбОшибке();
		ТекстОшибки = ПодробноеПредставлениеОшибки(Инфо);
		ИнтеграцияЦУЗсЭТПСерверУХ.ЗарегистрироватьОшибку(ОписаниеОбмена.ПоляОписанияТранзакции, ТекстОшибки);
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияОбОкончанииОбмена, ОписаниеОбмена);
	КонецПопытки;
КонецПроцедуры
