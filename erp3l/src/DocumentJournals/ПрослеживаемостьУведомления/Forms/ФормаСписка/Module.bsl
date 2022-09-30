
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.Список.КоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	НастроитьДинамическийСписок();
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма);
	
	УстановитьУсловноеОформление();
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ЗаполнитьСписокТиповУведомлений(Элементы.ОтборТипУведомлений.СписокВыбора);
	
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ТипУведомления", ТипУведомлений);
	Если Не Параметры.Свойство("Состояние", СтатусОтправки) Тогда
		СтатусОтправки = "Все";
	КонецЕсли;
	
	КОформлению =
		ЖурналыДокументов.ПрослеживаемостьУведомления.СформироватьГиперссылкиКОформлению(Ложь);
	ОтборыПоСостоянию =
		ЖурналыДокументов.ПрослеживаемостьУведомления.СформироватьГиперссылкиУправленияОтборами(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);
	ИначеЕсли ИмяСобытия = "Запись_ОприходованиеПрослеживаемыхТоваров"
		ИЛИ ИмяСобытия = "Запись_УведомлениеОВвозеПрослеживаемыхТоваров"
		ИЛИ ИмяСобытия = "Запись_УведомлениеОПеремещенииПрослеживаемыхТоваров" Тогда
		ОбновитьГиперссылкиУправленияОтборами();
		ОбновитьГиперссылкиКОформлению();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьОтборСписка();
	ОбновитьГиперссылкиУправленияОтборами();
	ОбновитьГиперссылкиКОформлению();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	Для каждого ТекущаяСтрока Из Строки Цикл
		
		Данные = ТекущаяСтрока.Значение.Данные;
		
		ПредставлениеТипДокумента = НСтр("ru = 'Уведомление %1';
										|en = 'Notification %1'");
		
		Если Данные.НомерКорректировки > 0 Тогда
			
			ПредставлениеТипДокумента = НСтр("ru = 'Корректировочное уведомление %1';
											|en = 'Corrective notification %1'");
			
			Данные.ПредставлениеНомер = ТекстНомераПреставления(
				НомерНаПечатьИсправленногоУведомления(Данные.ДокументУведомление), Данные.НомерКорректировки);
			
		Иначе
			
			Данные.ПредставлениеНомер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Данные.Номер, Истина, Ложь);
				
		КонецЕсли;
		
		Данные.ПредставлениеДата = Формат(Данные.Дата, "ДЛФ=D");
		
		Если ТипЗнч(Данные.Ссылка) = Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров") Тогда
			ПредставлениеТипДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПредставлениеТипДокумента, НСтр("ru = 'об остатках';
												|en = 'of balance'"));
		ИначеЕсли ТипЗнч(Данные.Ссылка) = Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров") Тогда
			ПредставлениеТипДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПредставлениеТипДокумента, НСтр("ru = 'о перемещении';
												|en = 'of transfer'"));
		Иначе
			ПредставлениеТипДокумента = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПредставлениеТипДокумента, НСтр("ru = 'о ввозе';
												|en = 'of import'"));
		КонецЕсли;
		
		Данные.ПредставлениеТипДокумента = ПредставлениеТипДокумента;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборСписка();
	
	ОбновитьГиперссылкиУправленияОтборами();
	ОбновитьГиперссылкиКОформлению();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипУведомленийПриИзменении(Элемент)
	
	УстановитьОтборСписка();
	
	ОбновитьГиперссылкиУправленияОтборами();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПоСостояниюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтатусОтправки = НавигационнаяСсылкаФорматированнойСтроки;
	УстановитьОтборСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура КОформлениюОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Организация);
	Если НавигационнаяСсылкаФорматированнойСтроки = "УведомленияОбОстатках" Тогда
		ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаРабочееМесто",
			ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.Независимый);
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "УведомленияОПеремещениях" Тогда
		ОткрытьФорму("ОбщаяФорма.ФормированиеУведомленийОВвозеПеремещении",
			ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.Независимый);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьУведомлениеОбОстатках(Команда)
	
	ПараметрыОткрытия = Новый Структура("ЗаполнениеПоОстаткам", Истина);
	
	Обработчик = Новый ОписаниеОповещения("ДействиеСоздатьУведомлениеЗавершение", ЭтотОбъект, ПараметрыОткрытия);
		
		ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.Форма.ФормаДанныеПервичногоДокумента",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Обработчик,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеСоздатьУведомлениеЗавершение(РеквизитыПервичногоДокумента, ДополнительныеПараметры) Экспорт
	
	Если РеквизитыПервичногоДокумента = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.УведомлениеОбОстаткахПрослеживаемыхТоваров.ФормаОбъекта", РеквизитыПервичногоДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьУведомлениеОВвозеИзЕАЭС(Команда)
	ОткрытьФорму("Документ.УведомлениеОВвозеПрослеживаемыхТоваров.ФормаОбъекта");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьУведомлениеОВывозеВЕАЭС(Команда)
	ОткрытьФорму("Документ.УведомлениеОПеремещенииПрослеживаемыхТоваров.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервереБезКонтекста
Функция ТекстНомераПреставления(Номер, НомерКорректировки)
	
	ТекстНомера = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (корр. %2)';
																				|en = '%1 (corr. %2)'"),
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Ложь), 
		НомерКорректировки);
		
	Возврат ТекстНомера;
	
КонецФункции

&НаСервереБезКонтекста
Функция НомерНаПечатьИсправленногоУведомления(ДокументУведомление)
	
	Возврат ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументУведомление, "Номер"));
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Состояние

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Состояние");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Список.Состояние", ВидСравненияКомпоновкиДанных.НеЗаполнено);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Не отправлено';
																	|en = 'Not sent'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(Организация));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Тип", ТипУведомлений, ВидСравненияКомпоновкиДанных.Равно, , ЗначениеЗаполнено(ТипУведомлений));
	
	Если СтатусОтправки = "ОжидаютОтправки" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Статус", Неопределено, ВидСравненияКомпоновкиДанных.НеЗаполнено, , Истина);
	//++ НЕ УТ
	ИначеЕсли СтатусОтправки = "ОжидаютПолучения" Тогда
		СписокСтатусов = Новый СписокЗначений;
		СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыОтправки.Отправлен"));
		СписокСтатусов.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыОтправки.Доставлен"));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Статус", СписокСтатусов, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	//-- НЕ УТ
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Статус", Неопределено, ВидСравненияКомпоновкиДанных.Равно, , Ложь);
	КонецЕсли;
	
	Если СтатусОтправки = "Завершены" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "РНПТ", "", ВидСравненияКомпоновкиДанных.Заполнено, , Истина);
	ИначеЕсли СтатусОтправки = "Все" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "РНПТ", "", ВидСравненияКомпоновкиДанных.Заполнено, , Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "РНПТ", "", ВидСравненияКомпоновкиДанных.НеЗаполнено, , Истина);
	КонецЕсли;
	
	Если СтатусОтправки = "Все" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно, , Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Проведен", Истина, ВидСравненияКомпоновкиДанных.Равно, , Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДинамическийСписок()
	
	Если ПолучитьФункциональнуюОпцию("УправлениеТорговлей") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеВРаботе", НСтр("ru = 'В работе';
											|en = 'In progress'"));
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "СостояниеСдано", НСтр("ru = 'Сдано, получен РНПТ';
											|en = 'Submitted, goods batch registration number received'"));
	//++ НЕ УТ
	Иначе
		ПараметрыСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
		ПараметрыСписка.ТекстЗапроса = ТекстЗапросаДинамическогоСписка();
		ПараметрыСписка.ОсновнаяТаблица = "ЖурналДокументов.ПрослеживаемостьУведомления";
		ПараметрыСписка.ДинамическоеСчитываниеДанных = Истина;
		ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, ПараметрыСписка);
	//-- НЕ УТ
	КонецЕсли;
	
КонецПроцедуры

//++ НЕ УТ

&НаСервереБезКонтекста
Функция ТекстЗапросаДинамическогоСписка()
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЖурналДокументовПрослеживаемостьУведомления.Ссылка КАК Ссылка,
	|	ЖурналДокументовПрослеживаемостьУведомления.Дата КАК Дата,
	|	ЖурналДокументовПрослеживаемостьУведомления.ПометкаУдаления КАК ПометкаУдаления,
	|	ЖурналДокументовПрослеживаемостьУведомления.Номер КАК Номер,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(15)) КАК ПредставлениеНомер,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(12)) КАК ПредставлениеДата,
	|	ВЫРАЗИТЬ("""" КАК СТРОКА(45)) КАК ПредставлениеТипДокумента,
	|	ЖурналДокументовПрослеживаемостьУведомления.Проведен КАК Проведен,
	|	ЖурналДокументовПрослеживаемостьУведомления.Организация КАК Организация,
	|	ЖурналДокументовПрослеживаемостьУведомления.ТНВЭД КАК ТНВЭД,
	|	ЖурналДокументовПрослеживаемостьУведомления.Основание КАК Основание,
	|	ЖурналДокументовПрослеживаемостьУведомления.РНПТ КАК РНПТ,
	|	ЖурналДокументовПрослеживаемостьУведомления.ДокументУведомление КАК ДокументУведомление,
	|	ЖурналДокументовПрослеживаемостьУведомления.НомерКорректировки КАК НомерКорректировки,
	|	ЖурналДокументовПрослеживаемостьУведомления.Тип КАК Тип,
	|	ЖурналОтчетовСтатусы.Статус КАК Состояние,
	|	СтатусыОтправки.Статус КАК Статус,
	|	ЖурналДокументовПрослеживаемостьУведомления.Ответственный КАК Ответственный,
	|	ЖурналДокументовПрослеживаемостьУведомления.Комментарий КАК Комментарий
	|ИЗ
	|	ЖурналДокументов.ПрослеживаемостьУведомления КАК ЖурналДокументовПрослеживаемостьУведомления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОтправки КАК СтатусыОтправки
	|		ПО ЖурналДокументовПрослеживаемостьУведомления.Ссылка = СтатусыОтправки.Объект
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЖурналОтчетовСтатусы КАК ЖурналОтчетовСтатусы
	|		ПО ЖурналДокументовПрослеживаемостьУведомления.Ссылка = ЖурналОтчетовСтатусы.Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокТиповУведомлений(СписокВыбора)
	
	СписокВыбора.Добавить(Тип("ДокументСсылка.УведомлениеОбОстаткахПрослеживаемыхТоваров"), НСтр("ru = 'Уведомления об остатках';
																								|en = 'Balance notification'"));
	СписокВыбора.Добавить(Тип("ДокументСсылка.УведомлениеОВвозеПрослеживаемыхТоваров"), НСтр("ru = 'Уведомления о ввозе';
																							|en = 'Import notification'"));
	СписокВыбора.Добавить(Тип("ДокументСсылка.УведомлениеОПеремещенииПрослеживаемыхТоваров"), НСтр("ru = 'Уведомления о перемещении';
																									|en = 'Transfer notification'"));
	
КонецПроцедуры

#Область УправлениеГиперссылками

&НаКлиенте
Процедура ОбновитьГиперссылкиУправленияОтборами()
	
	Элементы.ДекорацияПустая.Видимость = Ложь;
	Элементы.ДекорацияОжидание.Видимость = Истина;
	
	ФоновоеЗадание = ОбновитьГиперссылкиУправленияОтборамиНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьГиперссылкиУправленияОтборамиЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьГиперссылкиУправленияОтборамиНаСервере()
	
	ПараметрыОтбора = Новый Структура("ТипУведомлений, Организация", ТипУведомлений, Организация);
	ИмяПроцедуры = "ЖурналыДокументов.ПрослеживаемостьУведомления.СформироватьГиперссылкиУправленияОтборами";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяПроцедуры, Истина, ПараметрыОтбора);

КонецФункции

&НаКлиенте
Процедура ОбновитьГиперссылкиУправленияОтборамиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.ДекорацияПустая.Видимость = Истина;
	Элементы.ДекорацияОжидание.Видимость = Ложь;
	
	Если Не Результат = Неопределено Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатВыполнения) Тогда
		ОтборыПоСостоянию = РезультатВыполнения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГиперссылкиКОформлению()
	
	ФоновоеЗадание = ОбновитьГиперссылкиКОформлениюНаСервере();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьГиперссылкиКОформлениюЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ФоновоеЗадание, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьГиперссылкиКОформлениюНаСервере()
	
	ИмяПроцедуры = "ЖурналыДокументов.ПрослеживаемостьУведомления.СформироватьГиперссылкиКОформлению";
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяПроцедуры, Истина, Организация);

КонецФункции

&НаКлиенте
Процедура ОбновитьГиперссылкиКОформлениюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не Результат = Неопределено Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РезультатВыполнения) Тогда
		КОформлению = РезультатВыполнения;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
