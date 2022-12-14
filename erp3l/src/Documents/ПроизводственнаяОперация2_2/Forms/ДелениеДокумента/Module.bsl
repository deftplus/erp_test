
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Документ.Ссылка                КАК Ссылка,
		|	Документ.Номер                 КАК Номер,
		|	Документ.Подразделение         КАК Подразделение,
		|	Документ.Этап                  КАК Этап,
		|	Документ.Операция              КАК Операция,
		|	Документ.ИдентификаторОперации КАК ИдентификаторОперации,
		|	Документ.Исполнитель           КАК Исполнитель,
		|	Документ.Исполнитель           КАК ИсполнительНов,
		|	Документ.ВидРабочегоЦентра     КАК ВидРабочегоЦентра,
		|	Документ.ВидРабочегоЦентра     КАК ВидРабочегоЦентраНов,
		|	Документ.РабочийЦентр          КАК РабочийЦентр,
		|	Документ.РабочийЦентр          КАК РабочийЦентрНов,
		|	Документ.Количество            КАК Количество,
		|	Документ.Количество            КАК КоличествоДок,
		|	Документ.ВремяВыполнения       КАК ВремяВыполнения,
		|	Документ.ВремяВыполнения       КАК ВремяВыполненияДок,
		|	Документ.ВремяВыполненияЕдИзм  КАК ВремяВыполненияЕдИзм,
		|	Документ.Операция.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|ИЗ
		|	Документ.ПроизводственнаяОперация2_2 КАК Документ
		|ГДЕ
		|	Документ.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Параметры.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Выборка);
	ЗаполнитьПредставлениеЕдиницыИзмерения(ЭтаФорма);
	
	Заголовок = СтрШаблон(НСтр("ru = 'Деление операции %1';
								|en = 'Operation division %1'"), Выборка.Номер);
	
	Элементы.КоличествоНов.МаксимальноеЗначение = КоличествоДок;
	Элементы.ВремяВыполненияНов.МаксимальноеЗначение = ВремяВыполненияДок;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		АдаптироватьПодМобильныйКлиент();
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ДанныеРазблокированы Тогда
		РазблокироватьДанные(Ссылка, ВладелецФормы.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Разбить(Команда)
	
	Если Количество = 0 ИЛИ КоличествоНов = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Введены некорректные данные';
								|en = 'Incorrect data entered'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"КоличествоНов");
		
		Возврат;
		
	ИначеЕсли ВремяВыполнения = 0 ИЛИ ВремяВыполненияНов = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Введены некорректные данные';
								|en = 'Incorrect data entered'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения,,"ВремяВыполненияНов");
		
		Возврат;
		
	КонецЕсли;
	
	РазбитьНаСервере(ВладелецФормы.УникальныйИдентификатор);
	
	ОповеститьОбИзменении(Ссылка);
	
	КлючОперации = УправлениеПроизводствомКлиентСервер.КлючПроизводственнойОперации();
	ЗаполнитьЗначенияСвойств(КлючОперации, ЭтаФорма);
	
	ПараметрОповещения = Новый Структура;
	ПараметрОповещения.Вставить("Подразделение", Подразделение);
	ПараметрОповещения.Вставить("КлючОперации",  КлючОперации);
	ПараметрОповещения.Вставить("Ссылка",        Ссылка);
	Оповестить("Запись_ПроизводственнаяОперация", ПараметрОповещения, УникальныйИдентификатор);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИсполнительНовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИсполнительНовНачалоВыбораЗавершение", ЭтотОбъект);
	
	ПроизводствоКлиент.ОткрытьФормуВыбораИсполнителя(
		Организация,
		Подразделение,
		ИсполнительНов,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНовНачалоВыбораЗавершение(Результат, Параметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ИсполнительНов = Результат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполнительНовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоНовПриИзменении(Элемент)
	
	Если КоличествоДок <> 0 Тогда
		ВремяВыполненияНов = КоличествоНов*ВремяВыполненияДок/КоличествоДок;
	Иначе
		ВремяВыполненияНов = 0;
	КонецЕсли;
	
	Количество = КоличествоДок - КоличествоНов;
	ВремяВыполнения = ВремяВыполненияДок - ВремяВыполненияНов;
	
	ЗаполнитьПредставлениеЕдиницыИзмерения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВремяВыполненияНовПриИзменении(Элемент)
	
	Если ВремяВыполненияДок <> 0 Тогда
		КоличествоНов = ВремяВыполненияНов*КоличествоДок/ВремяВыполненияДок;
	Иначе
		КоличествоНов = 0;
	КонецЕсли;
	
	Количество = КоличествоДок - КоличествоНов;
	ВремяВыполнения = ВремяВыполненияДок - ВремяВыполненияНов;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПредставлениеЕдиницыИзмерения(Форма)

	Форма.ЕдиницаИзмеренияПредставление = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
		Форма.ЕдиницаИзмерения,
		Форма.Количество);
		
	Форма.ЕдиницаИзмеренияПредставлениеНов = УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
		Форма.ЕдиницаИзмерения,
		Форма.КоличествоНов);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИсполнительПолучениеДанныхВыбора(ДанныеВыбора, Текст, Подразделение)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПараметрыОтбора = Новый Структура("Организация, Подразделение");
	ПараметрыОтбора.Подразделение = Подразделение;
	ПроизводствоСервер.ЗаполнитьДанныеВыбораПриВводеИсполнителя(ДанныеВыбора, Текст, ПараметрыОтбора);
	
КонецПроцедуры

&НаСервере
Процедура РазбитьНаСервере(ИдентификаторФормы)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Исполнитель",       ИсполнительНов);
	ЗначенияЗаполнения.Вставить("ВидРабочегоЦентра", ВидРабочегоЦентраНов);
	ЗначенияЗаполнения.Вставить("РабочийЦентр",      РабочийЦентрНов);
	ЗначенияЗаполнения.Вставить("Количество",        КоличествоНов);
	ЗначенияЗаполнения.Вставить("ВремяВыполнения",   ВремяВыполненияНов);
	
	Попытка
		
		Документы.ПроизводственнаяОперация2_2.Разделить(Ссылка, ЗначенияЗаполнения, Ложь);
		
	Исключение
		
		РазблокироватьДанныеДляРедактирования(Ссылка, ИдентификаторФормы);
		ДанныеРазблокированы = Истина;
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Не удалось выполнить действие по причине: %1';
				|en = 'Cannot perform the action. Reason: %1'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(Ссылка, ИдентификаторФормы);
	ДанныеРазблокированы = Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура РазблокироватьДанные(Ссылка, ИдентификаторФормы)
	
	РазблокироватьДанныеДляРедактирования(Ссылка, ИдентификаторФормы);
	
КонецПроцедуры

&НаСервере
Процедура АдаптироватьПодМобильныйКлиент()
	
	Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	Заголовок = НСтр("ru = 'Новая операция';
					|en = 'New operation'");
	
	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	
	Элементы.ФормаРазбить.Отображение = ОтображениеКнопки.Картинка;
	Элементы.ФормаРазбить.Картинка    = БиблиотекаКартинок.ЗаписатьИЗакрыть;
	
	Элементы.Группа4.ОтображатьЗаголовок = Ложь;
	
	Элементы.Группа2.Видимость = Ложь;
	Элементы.Группа5.Видимость = Ложь;
	
	Элементы.ИсполнительНов.ПоложениеЗаголовка       = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.ВидРабочегоЦентраНов.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.РабочийЦентрНов.ПоложениеЗаголовка      = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.КоличествоНов.ПоложениеЗаголовка        = ПоложениеЗаголовкаЭлементаФормы.Лево;
	Элементы.ВремяВыполненияНов.ПоложениеЗаголовка   = ПоложениеЗаголовкаЭлементаФормы.Лево;
	
	Элементы.ВремяВыполненияНов.Ширина = 0;
	Элементы.ВремяВыполненияНов.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	Элементы.ВремяВыполненияЕдИзм1.Ширина = 0;
	Элементы.ВремяВыполненияЕдИзм1.АвтоМаксимальнаяШирина = Ложь;
	Элементы.ВремяВыполненияЕдИзм1.МаксимальнаяШирина = 7;
	Элементы.ВремяВыполненияЕдИзм1.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
	
	Элементы.КоличествоНов.Ширина = 0;
	Элементы.КоличествоНов.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Право;
	Элементы.ЕдиницаИзмеренияПредставлениеНов.Ширина = 0;
	Элементы.ЕдиницаИзмеренияПредставлениеНов.АвтоМаксимальнаяШирина = Ложь;
	Элементы.ЕдиницаИзмеренияПредставлениеНов.МаксимальнаяШирина = 7;
	Элементы.ЕдиницаИзмеренияПредставлениеНов.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;

	
	Элементы.ВидРабочегоЦентраНов.Заголовок = НСтр("ru = 'Вид РЦ';
													|en = 'Work center type'");
	Элементы.РабочийЦентрНов.Заголовок      = НСтр("ru = 'Рабочий центр';
													|en = 'Work center'");
	
	КоличествоНов      = Количество;
	Количество         = 0;
	ВремяВыполненияНов = ВремяВыполнения;
	ВремяВыполнения    = 0
КонецПроцедуры

#КонецОбласти
