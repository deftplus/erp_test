
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПериодРасчета                 = Константы.ПериодРасчетаТоварныхОграничений.Получить();
	КоличествоПериодовРасчета     = Константы.КоличествоПериодовРасчетаТоварныхОграничений.Получить();
	ВариантУчетаСезонныхКолебаний = Константы.ВариантУчетаСезонныхКолебаний.Получить();
	
	НастроитьФормуПоПравамИФункциональнымОпциям();
	УстановитьБлокировкуПоСезоннымКоэффицентам();
	
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант"
		И (Источник = "ИспользоватьСезонныеКоэффициенты" Или Источник = "ИспользоватьТоварныеКатегории")Тогда
		
		НастроитьФормуПоПравамИФункциональнымОпциям();
		УстановитьЗаголовкиПодсказок(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодРасчетаТоварныхОграниченийПриИзменении(Элемент)
	
	ЭтоГод = ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
	Если ЭтоГод Или ПредыдущийПериодРасчетаБылГод Тогда
		УстановитьБлокировкуПоСезоннымКоэффицентам();
	КонецЕсли;
	
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПериодовРасчетаТоварныхОграниченийПриИзменении(Элемент)
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура НеУчитыватьПриИзменении(Элемент)
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПоСезоннымКоэффициентамПриИзменении(Элемент)
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПоАналогичномуПериодуПрошлогоГодаПриИзменении(Элемент)
	УстановитьЗаголовкиПодсказок(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		СохранитьПараметры();
		
		КодВозврата = Новый Структура;
		КодВозврата.Вставить("ПериодРасчетаТоварныхОграничений", ПериодРасчета);
		КодВозврата.Вставить("КоличествоПериодовРасчетаТоварныхОграничений", КоличествоПериодовРасчета);
		КодВозврата.Вставить("ВариантУчетаСезонныхКолебаний", ВариантУчетаСезонныхКолебаний);
		
		Оповестить("ЗакрытиеФормы", , ЭтаФорма);
		Закрыть(КодВозврата);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФормуПоПравамИФункциональнымОпциям()
	
	ИспользоватьСезонныеКоэффициенты = ПолучитьФункциональнуюОпцию("ИспользоватьСезонныеКоэффициенты");
	Элементы.ПоСезоннымКоэффициентам.Доступность                   = ИспользоватьСезонныеКоэффициенты
		И ПериодРасчета <> Перечисления.Периодичность.Год;
	Элементы.КомментарийДоступностиСезонныхКоэффициентов.Видимость = Не ИспользоватьСезонныеКоэффициенты;
	
	ИспользоватьТоварныеКатегории = ПолучитьФункциональнуюОпцию("ИспользоватьТоварныеКатегории");
	Элементы.ПоАналогичномуПериодуПрошлогоГода.Доступность = ИспользоватьТоварныеКатегории;
	Элементы.КомментарийДоступностиАППГ.Видимость          = Не ИспользоватьТоварныеКатегории;
	
	ДоступныСезонныеКоэффициенты = ИспользоватьСезонныеКоэффициенты
		И ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.СезонныеКоэффициенты);
	
	// Скроем от пользователя некорректный вариант
	Если (ВариантУчетаСезонныхКолебаний = Перечисления.УчетСезонныхКолебаний.ПоСезоннымКоэффициентам
		И Не ИспользоватьСезонныеКоэффициенты)
		Или (ВариантУчетаСезонныхКолебаний = Перечисления.УчетСезонныхКолебаний.ПоАналогичномуПериодуПрошлогоГода
		И Не ИспользоватьТоварныеКатегории) Тогда
		ВариантУчетаСезонныхКолебаний = Перечисления.УчетСезонныхКолебаний.НеУчитывать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовкиПодсказок(Форма)
	
	Если Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.День") Тогда
		ТекущийПериод     = НСтр("ru = 'текущий день';
								|en = 'current day'");
		АналогичныйПериод = НСтр("ru = 'аналогичный текущему день прошлого года';
								|en = 'day of the last year similar to the current day'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Неделя") Тогда
		ТекущийПериод     = НСтр("ru = 'текущая неделя';
								|en = 'current week'");
		АналогичныйПериод = НСтр("ru = 'аналогичная текущей неделя прошлого года';
								|en = 'week of the last year similar to the current week'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Декада") Тогда
		ТекущийПериод     = НСтр("ru = 'текущая декада';
								|en = 'current ten-day period'");
		АналогичныйПериод = НСтр("ru = 'аналогичная текущей декада прошлого года';
								|en = 'ten-day period of the last year similar to the current ten-day period'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		ТекущийПериод     = НСтр("ru = 'текущий месяц';
								|en = 'current month'");
		АналогичныйПериод = НСтр("ru = 'аналогичный текущему месяц прошлого года';
								|en = 'month of the last year similar to the current month'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		ТекущийПериод     = НСтр("ru = 'текущий квартал';
								|en = 'current quarter'");
		АналогичныйПериод = НСтр("ru = 'аналогичный текущему квартал прошлого года';
								|en = 'quarter of the last year similar to the current quarter'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		ТекущийПериод     = НСтр("ru = 'текущее полугодие';
								|en = 'current half-year'");
		АналогичныйПериод = НСтр("ru = 'аналогичное текущему полугодие прошлого года';
								|en = 'half-year of the last year similar to the current half-year'");
	ИначеЕсли Форма.ПериодРасчета = ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		ТекущийПериод     = НСтр("ru = 'текущий год';
								|en = 'current year'");
		АналогичныйПериод = НСтр("ru = 'прошлый год';
								|en = 'previous year'");
	Иначе
		ТекущийПериод     = НСтр("ru = '<период не указан>';
								|en = '<period is not specified>'");
		АналогичныйПериод = НСтр("ru = '<период не указан>';
								|en = '<period is not specified>'");
	КонецЕсли;
	
	ПредыдущийПериод = ОбеспечениеКлиентСервер.ОписаниеНастройки(Форма.ПериодРасчета, Форма.КоличествоПериодовРасчета);
	
	Форма.ПодсказкаПериодДействияРасчета = СтрШаблон(НСтр("ru = 'Период действия расчета: %1.';
															|en = 'Settlement validity period:%1.'"), ТекущийПериод);
	
	РасчетСреднедневного = НСтр("ru = 'Среднедневное потребление расчитывается по данным за период: %1.';
								|en = 'Average daily consumption is calculated according to data for the period:%1.'");
	
	Если Форма.ВариантУчетаСезонныхКолебаний = ПредопределенноеЗначение("Перечисление.УчетСезонныхКолебаний.ПоАналогичномуПериодуПрошлогоГода") Тогда
		Коррекция = НСтр("ru = 'Среднедневное потребление корректируется согласно динамике потребления соответствующей товарной категории. Динамика потребления по товарной категории формируется по данным за %1 и за аналогичный период относительно прошлого года.';
						|en = 'Average daily consumption is adjusted according to consumption trends of the relevant product category. Consumption trends of the product category are generated based on data for %1 and the similar period relative to the previous year.'");
		
		Форма.ПодсказкаРасчетСреднедневногоПотребления = Новый ФорматированнаяСтрока(
			СтрШаблон(РасчетСреднедневного, АналогичныйПериод), Символы.ПС, СтрШаблон(Коррекция, ПредыдущийПериод));
	ИначеЕсли Форма.ВариантУчетаСезонныхКолебаний = ПредопределенноеЗначение("Перечисление.УчетСезонныхКолебаний.ПоСезоннымКоэффициентам") Тогда
		СсылкаНаФорму = ?(Форма.ДоступныСезонныеКоэффициенты, "e1cib/command/РегистрСведений.СезонныеКоэффициенты.Команда.СезонныеКоэффициенты", "");
		Коррекция = Новый ФорматированнаяСтрока(
			НСтр("ru = 'Среднедневное потребление корректируется согласно';
				|en = 'Average daily consumption is corrected according to'"),
			" ",
			Новый ФорматированнаяСтрока(НСтр("ru = 'сезонным коэффициентам';
											|en = 'seasonal indexes'"),,,, СсылкаНаФорму),
			" ",
			НСтр("ru = 'соответствующей сезонной группы.';
				|en = 'of the corresponding seasonal group.'"));
		
		Форма.ПодсказкаРасчетСреднедневногоПотребления = Новый ФорматированнаяСтрока(
			СтрШаблон(РасчетСреднедневного, ПредыдущийПериод), Символы.ПС, Коррекция);
	Иначе
		Форма.ПодсказкаРасчетСреднедневногоПотребления = Новый ФорматированнаяСтрока(
			СтрШаблон(РасчетСреднедневного, ПредыдущийПериод));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБлокировкуПоСезоннымКоэффицентам()
	
	ЭтоГод = ПериодРасчета = Перечисления.Периодичность.Год;
	
	Элементы.ПоСезоннымКоэффициентам.Доступность                     = Не ЭтоГод И ПолучитьФункциональнуюОпцию("ИспользоватьСезонныеКоэффициенты");
	Элементы.КомментарийНевозможностиСезонныхКоэффициентов.Видимость = ЭтоГод;
	
	Если ЭтоГод И ВариантУчетаСезонныхКолебаний = Перечисления.УчетСезонныхКолебаний.ПоСезоннымКоэффициентам Тогда
		ВариантУчетаСезонныхКолебаний = Перечисления.УчетСезонныхКолебаний.НеУчитывать;
	КонецЕсли;
	
	ПредыдущийПериодРасчетаБылГод = ЭтоГод;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметры()
	
	// Запись констант осуществляется в привелигированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	Константы.ПериодРасчетаТоварныхОграничений.Установить(ПериодРасчета);
	Константы.КоличествоПериодовРасчетаТоварныхОграничений.Установить(КоличествоПериодовРасчета);
	Константы.ВариантУчетаСезонныхКолебаний.Установить(ВариантУчетаСезонныхКолебаний);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти
