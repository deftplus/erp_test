
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДокументыКПодтверждению = Параметры.ДокументыКПодтверждению;
	
	КоличествоДокументов = ДокументыКПодтверждению.Количество();
	СформироватьТекстПоОснованиям();
	
	Элементы.НомераКиЗКПодтверждениюДокумент.Видимость = (КоличествоДокументов > 1);
	Элементы.Основание.Видимость = (КоличествоДокументов > 0);
	
	ЗаполнитьИнформациюВФорме();
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияПроблемыДублиКиЗНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокДублейКиЗ", СписокДублейКиЗ);
	ПараметрыФормы.Вставить("ДокументыКПодтверждению", ДокументыКПодтверждению);
	ПараметрыФормы.Вставить("ПоДублям", Истина);
	
	ОткрытьФорму("Обработка.ПодтверждениеПоступившихКиЗГИСМ.Форма.СписокПроблем", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПроблемыСопоставленияНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресТаблицаПроблемыСопоставления", АдресВременногоХранилищаТаблицыПроблемСопоставления());
	ПараметрыФормы.Вставить("ПоПроблемамСопоставления", Истина);
	
	ОткрытьФорму("Обработка.ПодтверждениеПоступившихКиЗГИСМ.Форма.СписокПроблем", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура НомераКиЗКПодтверждениюПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.НомераКиЗКПодтверждению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент.Имя = "НомераКиЗКПодтверждениюДокументПоступления" Тогда
		
		Элементы.НомераКиЗКПодтверждениюДокументПоступления.СписокВыбора.Очистить();
		Элементы.НомераКиЗКПодтверждениюДокументПоступления.СписокВыбора.ЗагрузитьЗначения(ТекущиеДанные.КандидатыВПоступления.ВыгрузитьЗначения());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстПоЗаявкамОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьДокументы" Тогда
		Если ДокументыКПодтверждению.Количество() = 1 Тогда 
			ПоказатьЗначение( , ДокументыКПодтверждению.Получить(0).Значение);
		ИначеЕсли ДокументыКПодтверждению.Количество() > 1 Тогда
			
			ИнтеграцияГИСМКлиентПереопределяемый.ОткрытьФормуСпискаДокументов(ДокументыКПодтверждению, НСтр("ru = 'Заявки на выпуск КиЗ';
																											|en = 'Заявки на выпуск КиЗ'"));
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераКиЗКПодтверждениюДокументПоступленияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НомераКиЗКПодтверждению.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ДокументПоступления) Тогда
		ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить");
	Иначе
	
		Если ТекущиеДанные.КандидатыВПоступления.Количество() > 0 Тогда
			ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление");
		Иначе
			ТекущиеДанные.СостояниеПодтверждения = ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Если Модифицированность Тогда
	
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ОбновитьЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Таблица ""КиЗ к подтверждению"" будет перезаполнена. Продолжить?';
							|en = 'Таблица ""КиЗ к подтверждению"" будет перезаполнена. Продолжить?'");
		ПоказатьВопрос(ОписаниеОповещенияВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
	Иначе
		
		ЗаполнитьИнформациюВФорме();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатВопроса = КодВозвратаДиалога.Да Тогда
		 Возврат;
	КонецЕсли;
	
	ЗаполнитьИнформациюВФорме();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВыбратьПоступление(Команда)
	
	УстановитьОтборСтрокаВыпущенныеКиЗ(ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборКПередаче(Команда)
	
	УстановитьОтборСтрокаВыпущенныеКиЗ(ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборОжидаетсяПоступление(Команда)
	
	УстановитьОтборСтрокаВыпущенныеКиЗ(ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПодтвердить(Команда)
	
	УстановитьОтборСтрокаВыпущенныеКиЗ(ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборОтклоненоГИСМ(Команда)
	
	УстановитьОтборСтрокаВыпущенныеКиЗ(ПредопределенноеЗначение("Перечисление.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ"), Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПоступление(Команда)
	
	Закрыть(ПодтвердитьПоступлениеНаСервере());
	
КонецПроцедуры

&НаСервере
Функция ПодтвердитьПоступлениеНаСервере()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Данные.Документ КАК Документ,
	|	Данные.ДокументПоступления КАК ДокументПоступления,
	|	Данные.НомерКиЗ КАК НомерКиЗ,
	|	Данные.СостояниеПодтверждения КАК СостояниеПодтверждения
	|ПОМЕСТИТЬ Данные
	|ИЗ
	|	&Данные КАК Данные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Документ КАК Документ,
	|	Таблица.ДокументПоступления,
	|	Таблица.НомерКиЗ,
	|	Таблица.СостояниеПодтверждения
	|ИЗ
	|	Данные КАК Таблица
	|ГДЕ
	|	СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить)
	|ИТОГИ ПО
	|	Документ");
	
	Данные = Объект.НомераКиЗКПодтверждению.Выгрузить(,
		"ДокументПоступления, НомерКиЗ, Документ, СостояниеПодтверждения");
	
	Запрос.УстановитьПараметр("Данные", Данные);
	
	ОшибкаБлокировки = Ложь;
	
	ЗаблокированныеДокументы = Новый Соответствие;
	
	ВыборкаПоДокументам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		ДокументОбъект = ВыборкаПоДокументам.Документ.ПолучитьОбъект();
		
		Попытка
			ДокументОбъект.Заблокировать();
		Исключение
			ОшибкаБлокировки = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Не удалось заблокировать для записи документ %1';
								|en = 'Не удалось заблокировать для записи документ %1'"), ВыборкаПоДокументам.Документ),
				ВыборкаПоДокументам.Документ,,,
				ОшибкаБлокировки);
			Прервать;
		КонецПопытки;
		
		ЗаблокированныеДокументы.Вставить(ВыборкаПоДокументам.Документ, ДокументОбъект);
		
	КонецЦикла;
	
	Если ОшибкаБлокировки Тогда
		
		Для Каждого КлючИЗначение Из ЗаблокированныеДокументы Цикл
			КлючИЗначение.Значение.Разблокировать();
		КонецЦикла;
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	ДокументСОшибкой = Неопределено;
	НачатьТранзакцию();
	Попытка
		МассивДокументов = Новый Массив;
		
		ВыборкаПоДокументам.Сбросить();
		Пока ВыборкаПоДокументам.Следующий() Цикл
			
			ДокументОбъект = ЗаблокированныеДокументы.Получить(ВыборкаПоДокументам.Документ);
			Если ТипЗнч(ВыборкаПоДокументам.Документ) = Тип("ДокументСсылка.ЗаявкаНаВыпускКиЗГИСМ") Тогда
				ИмяТЧ = "ВыпущенныеКиЗ";
			ИначеЕсли ТипЗнч(ВыборкаПоДокументам.Документ) = Тип("ДокументСсылка.УведомлениеОПоступленииМаркированныхТоваровГИСМ") Тогда
				ИмяТЧ = "НомераКиЗ";
			КонецЕсли;
			
			Выборка = ВыборкаПоДокументам.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				СтрокаТЧ = ДокументОбъект[ИмяТЧ].Найти(Выборка.НомерКиЗ, "НомерКиЗ");
				Если СтрокаТЧ = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТЧ.ДокументПоступления    = Выборка.ДокументПоступления;
				СтрокаТЧ.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.КПередаче;
				
			КонецЦикла;
			
			Попытка
				ДокументОбъект.Записать();
				ДокументОбъект.Разблокировать();
			Исключение
				ДокументСОшибкой = ДокументОбъект.Ссылка;
				ВызватьИсключение;
			КонецПопытки;
			
			МассивДокументов.Добавить(ВыборкаПоДокументам.Документ);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтрШаблон(НСтр("ru = 'Не удалось изменить состояние подтверждения для документа %1';
							|en = 'Не удалось изменить состояние подтверждения для документа %1'"), ДокументСОшибкой),
			ДокументСОшибкой);
		
		Возврат Неопределено;
		
	КонецПопытки;
	
	Возврат МассивДокументов;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	СписокСостоянийНедоступныИзменения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.СписокСостоянийНедоступныИзмененияПоступления();
	СписокСостоянийНеТребуетсяПоступление = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.СписокСостоянийНеТребуетсяПоступление();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗКПодтверждениюДокументПоступления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗКПодтверждению.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСостоянийНедоступныИзменения;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗКПодтверждениюДокументПоступления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗКПодтверждению.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписокСостоянийНеТребуетсяПоступление;
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НомераКиЗКПодтверждениюДокументПоступления.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект.НомераКиЗКПодтверждению.СостояниеПодтверждения");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюВФорме()
	
	ТаблицаПроблемныхКиЗ.Очистить();
	Объект.НомераКиЗКПодтверждению.Очистить();
	СписокДублейКиЗ.Очистить();
	
	Результат = Новый Структура;
	ИнтеграцияГИСМПереопределяемый.ДанныеПоЗаявкамНаВыпускКиЗ(ДокументыКПодтверждению, Результат);
	Если Результат.Свойство("НомераКиЗКПодтверждению") Тогда
		ЗаполнитьТаблицуНомераКиЗКПодтверждению(Результат.НомераКиЗКПодтверждению);
	КонецЕсли;
	Если Результат.Свойство("ПроблемыДублиКиЗ") Тогда
		ОтобразитьПроблемыДублиКиЗ(Результат.ПроблемыДублиКиЗ);
	КонецЕсли;
	Если Результат.Свойство("ПроблемыСопоставления") Тогда
		ОтобразитьПроблемыСопоставления(Результат.ПроблемыСопоставления);
	КонецЕсли;
	
	Результат = Новый Структура;
	ИнтеграцияГИСМПереопределяемый.ДанныеПоУведомлениямОПоступлении(ДокументыКПодтверждению, Результат);
	Если Результат.Свойство("НомераКиЗКПодтверждению") Тогда
		ЗаполнитьТаблицуНомераКиЗКПодтверждению(Результат.НомераКиЗКПодтверждению);
	КонецЕсли;
	Если Результат.Свойство("ПроблемыДублиКиЗ") Тогда
		ОтобразитьПроблемыДублиКиЗ(Результат.ПроблемыДублиКиЗ);
	КонецЕсли;
	
	Элементы.ГруппаПроблемыДублиКиЗ.Видимость = (СписокДублейКиЗ.Количество() > 0);
	Элементы.ГруппаПроблемыСопоставления.Видимость = (ТаблицаПроблемныхКиЗ.Количество() > 0);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуНомераКиЗКПодтверждению(РезультатЗапроса)

	ПустоеПоступлениеТоваров = Неопределено;
	
	ВыборкаДокумент = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокумент.Следующий() Цикл
		
		ВыборкаНомерКиЗ = ВыборкаДокумент.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаНомерКиЗ.Следующий() Цикл
			
			ВыборкаДокументПоступления = ВыборкаНомерКиЗ.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаДокументПоступления.Следующий() Цикл
				
				ВыборкаСостояниеПодтверждения = ВыборкаДокументПоступления.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				Пока ВыборкаСостояниеПодтверждения.Следующий() Цикл
					
					НоваяСтрока = Объект.НомераКиЗКПодтверждению.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаСостояниеПодтверждения);
					
					КандидатыВПоступления         = Новый Массив;
					РанееСопоставленныеПоступления = Новый Массив;
					ВыборкаДетали = ВыборкаСостояниеПодтверждения.Выбрать();
					Пока ВыборкаДетали.Следующий() Цикл
						
						Если ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступленияКандидат) Тогда
							КандидатыВПоступления.Добавить(ВыборкаДетали.ДокументПоступленияКандидат);
						КонецЕсли;
						
						Если ЗначениеЗаполнено(ВыборкаДетали.ДокументПоступленияУжеСопоставлено) Тогда
							РанееСопоставленныеПоступления.Добавить(ВыборкаДетали.ДокументПоступленияУжеСопоставлено);
						КонецЕсли;
						
					КонецЦикла;
					
					ОбщегоНазначенияКлиентСервер.РазностьМассивов(КандидатыВПоступления, РанееСопоставленныеПоступления);
					НоваяСтрока.КандидатыВПоступления.ЗагрузитьЗначения(КандидатыВПоступления);
					
					Если КандидатыВПоступления.Количество() = 0 Тогда
						НоваяСтрока.ДокументПоступления = ПустоеПоступлениеТоваров;
						НоваяСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОжидаетсяПоступление;
					ИначеЕсли КандидатыВПоступления.Количество() = 1 Тогда
						НоваяСтрока.ДокументПоступления = КандидатыВПоступления[0];
						НоваяСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить;
					Иначе
						Если ЗначениеЗаполнено(НоваяСтрока.ДокументПоступления)
							И КандидатыВПоступления.Найти(НоваяСтрока.ДокументПоступления) = Неопределено Тогда
							НоваяСтрока.ДокументПоступления = ПустоеПоступлениеТоваров;
						КонецЕсли;
						Если ЗначениеЗаполнено(НоваяСтрока.ДокументПоступления) Тогда
							НоваяСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Подтвердить;
						Иначе
							НоваяСтрока.СостояниеПодтверждения = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ВыбратьПоступление;
						КонецЕсли;
					КонецЕсли;
					
				КонецЦикла
			
			КонецЦикла;
			
		КонецЦикла;
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ОтобразитьПроблемыДублиКиЗ(РезультатЗапроса)

	НомераКиЗ = Новый Массив;
	Если Не РезультатЗапроса.Пустой() Тогда
		НомераКиЗ = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("НомерКиЗ");
		Для Каждого НомерКиЗ Из НомераКиЗ Цикл
			СписокДублейКиЗ.Добавить(НомерКиЗ);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОтобразитьПроблемыСопоставления(РезультатЗапроса)
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		ТаблицаПроблемныхКиЗ.Загрузить(РезультатЗапроса.Выгрузить());
		АдресВременногоХранилищаТаблицыПроблемСопоставления = ПоместитьВоВременноеХранилище(ТаблицаПроблемныхКиЗ.Выгрузить());
		
	Иначе
		
		АдресВременногоХранилищаТаблицыПроблемСопоставления = ПоместитьВоВременноеХранилище(ТаблицаПроблемныхКиЗ.Выгрузить());
		
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура УстановитьОтборСтрокаВыпущенныеКиЗ(ЗначениеОтбора, Команда)
	
	Если ЗначениеОтбора = ЗначениеОтбораСтрок Тогда
		Отбор = Неопределено;
	Иначе
		Отбор = Новый ФиксированнаяСтруктура("СостояниеПодтверждения", ЗначениеОтбора);
	КонецЕсли;
	
	Элементы.НомераКиЗКПодтверждению.ОтборСтрок = Отбор;
	ЗначениеОтбораСтрок = ?(Отбор = Неопределено, Неопределено, ЗначениеОтбора);
	
	Для Каждого ЭлементКоманда Из Элементы.УстановитьОтбор.ПодчиненныеЭлементы Цикл
		Если Отбор = Неопределено Тогда
			ЭлементКоманда.Пометка = Ложь;
		Иначе 
			ЭлементКоманда.Пометка = (ЭлементКоманда.ИмяКоманды = Команда.Имя);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстПоОснованиям()

	КоличествоДокументов = ДокументыКПодтверждению.Количество();
	
	Если КоличествоДокументов = 1 Тогда
		
		ТекстЗаголовок = НСтр("ru = 'По документу:';
								|en = 'По документу:'");
		ТекстЗаявка    = Новый ФорматированнаяСтрока(Строка(ДокументыКПодтверждению.Получить(0).Значение),
		                                          Новый Шрифт(,,,,Истина),
		                                          ЦветаСтиля.ЦветГиперссылкиГосИС,
		                                          ,
		                                          "ОткрытьДокументы");
		
		Основание = Новый ФорматированнаяСтрока(ТекстЗаголовок, ТекстЗаявка);
		
	ИначеЕсли КоличествоДокументов > 1 Тогда
		
		Основание = Новый ФорматированнаяСтрока(СтрШаблон(НСтр("ru = 'По документам (%1).';
																|en = 'По документам (%1).'"), КоличествоДокументов),
		                                             Новый Шрифт(,,,,Истина),
		                                             ЦветаСтиля.ЦветГиперссылкиГосИС,
		                                             ,
		                                             "ОткрытьДокументы");
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция АдресВременногоХранилищаТаблицыПроблемСопоставления()

	Возврат ПоместитьВоВременноеХранилище(ТаблицаПроблемныхКиЗ.Выгрузить());

КонецФункции

#КонецОбласти
