////////////////////////////////////////////////////////////////////////////////
// Управление производством: содержит процедуры для управления производством.
// Модуль входит в подсистемы "УправлениеПредприятием".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Этап

// Функция для сравнения статусов
//
// Параметры:
//  Значение1	 - ПеречислениеСсылка.СтатусыЭтаповПроизводства2_2 - Первое значение сравнения.
//  Значение2	 - ПеречислениеСсылка.СтатусыЭтаповПроизводства2_2 - Второе значение сравнения.
// 
// Возвращаемое значение:
//   - Число - Результат < 0 - первое значение меньше второго.
//             Результат > 0 - первое значение больше второго.
//             Результат = 0 - первое значение равно второму.
//
Функция СравнениеСтатусовЭтапа(Значение1, Значение2) Экспорт
	
	СравнениеСтатусов = Новый Соответствие;
	СравнениеСтатусов.Вставить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Формируется"), 0);
	СравнениеСтатусов.Вставить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Сформирован"), 1);
	СравнениеСтатусов.Вставить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.КВыполнению"), 2);
	СравнениеСтатусов.Вставить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Начат"),       3);
	СравнениеСтатусов.Вставить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Завершен"),    4);
	
	Возврат СравнениеСтатусов[Значение1] - СравнениеСтатусов[Значение2];
	
КонецФункции

// Возвращает статусы документа, в которых доступно пооперационное управление этапом производства.
//
// Параметры:
//  Параметры	 - ДанныеФормыСтруктура, Структура	 - структура, содержащая параметры подразделения.
// 
// Возвращаемое значение:
//  Массив - массив статусов документа.
//
Функция СтатусыДоступноПооперационноеУправление(Параметры) Экспорт
	
	Результат = Новый Массив;
	
	Если Параметры.ИспользоватьПооперационноеПланирование ИЛИ Параметры.ИспользоватьСменныеЗадания Тогда
		Результат.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.КВыполнению"));
	КонецЕсли;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Начат"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.СтатусыЭтаповПроизводства2_2.Завершен"));
	
	Возврат Результат;
	
КонецФункции

// Обработка проверки размещения этапа в графике
//
// Параметры:
//  ГрафикПроизводства - Структура - см. СтруктураРазмещенияЭтапаВГрафике()
//  Ссылка - ДокументСсылка.ЭтапПроизводства2_2 - этап производства
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы)
//  Отказ - Булево - выходной параметр.
//
Процедура ПроверитьРазмещениеЭтапаВГрафике(ГрафикПроизводства, Ссылка, ПутьКДанным, Отказ) Экспорт
	
	Если ГрафикПроизводства.НачалоЭтапа = '00010101'
		ИЛИ ГрафикПроизводства.ОкончаниеЭтапа = '00010101' Тогда
		
		ТекстСообщения = НСтр("ru = 'График производства не заполнен.';
								|en = 'Production schedule is not filled in.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, 
			Ссылка,,
			ПутьКДанным,
			Отказ);
			
	ИначеЕсли ГрафикПроизводства.НачалоЭтапа > ГрафикПроизводства.ОкончаниеЭтапа Тогда
		
		ТекстСообщения = НСтр("ru = 'График производства заполнен не правильно.';
								|en = 'Production schedule is filled in incorrectly.'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения, 
			Ссылка,,
			ПутьКДанным,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает список имен таблиц хранящих данные о выходных изделиях этапа
//
// Возвращаемое значение:
//   - Массив - имена таблиц, хранящих данные о выходных изделиях этапа.
//
Функция ИменаТаблицИзделия() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("ВыходныеИзделия");
	Результат.Добавить("ПобочныеИзделия");
	Результат.Добавить("ВыходныеИзделияСерии");
	Результат.Добавить("ПобочныеИзделияСерии");
	
	Возврат Результат;
	
КонецФункции

// Определяет, является ли переданный этап выпускающим продукцию
//
// Параметры:
//  ДанныеЭтапа - Структура - данные этапа
//   *НомерСледующегоЭтапа.
// 
// Возвращаемое значение:
//  Булево - Истина, если переданный этап является выпускающий.
//
Функция ЭтоВыпускающийЭтап(ДанныеЭтапа) Экспорт
	
	Возврат ДанныеЭтапа.НомерСледующегоЭтапа = 0;
	
КонецФункции

#КонецОбласти

#Область ПроизводственнаяОперация

// Возвращает представление единицы измерения операции
//
// Параметры:
//  ЕдиницаИзмерения - СправочникСсылка.УпаковкиЕдиницыИзмерения - единица измерения количества операции
//  Количество		 - Число									 - натуральный измеритель операции в физических единицах количества, длины, площади, объема и проч.
//  Сокращать		 - Булево									 - если устанвоен в истина, тогда представление еденицы измерения будет сокращено.
//  КодЯзыка		 - Строка									 - код языка, исспользуемый для вывода локализованных строк.
// 
// Возвращаемое значение:
//   - Строка - представление единицы измерения.
//
Функция ПредставлениеЕдиницыИзмеренияОперации(ЕдиницаИзмерения, Количество = 0, Сокращать = Ложь, КодЯзыка = "") Экспорт
	
	Результат = "";
	
	Если ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
		
		Результат = Строка(ЕдиницаИзмерения);
		
	Иначе
		
		Если Сокращать Тогда
			
			Результат = НСтр("ru = 'оп.';
							|en = 'op.'", КодЯзыка);
			
		Иначе
			
			Результат = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(Количество,
																		НСтр("ru = 'операция';
																			|en = 'operation'", КодЯзыка),
																		НСтр("ru = 'операции';
																			|en = 'operation'", КодЯзыка),
																		НСтр("ru = 'операций';
																			|en = 'operations'", КодЯзыка),
																		"ж");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПланированиеГрафика

// Определяет настройки отображения шкалы диаграммы Ганта для адекватного представления
// диаграммы в режиме ВсеДанные (свойство ПоддержкаМасштабаДиаграммыГанта).
//
// Параметры:
//  Начало				 - Дата - начало отображаемого интервала.
//  Окончание			 - Дата - окончание отображаемого интервала.
//  КоличествоИнтервалов - Число - количество интервалов, отображаемых на диаграмме.
// 
// Возвращаемое значение:
//  Структура - настройки отображения.
//
Функция НастройкиШкалыДиаграммыГантаВРежимеВсеДанные(Начало, Окончание, КоличествоИнтервалов) Экспорт
	
	РазницаЧасы = ОКР((КонецЧаса(Окончание)-НачалоЧаса(Начало))/(60*60));
	РазницаДни = ОКР((КонецДня(Окончание)-НачалоДня(Начало))/(60*60*24));
	РазницаНедели = ОКР((КонецНедели(Окончание)-НачалоНедели(Начало))/(60*60*24*7));
	РазницаМесяцы = ОКР((КонецМесяца(Окончание)-НачалоМесяца(Начало))/(60*60*24*30));
	РазницаКварталы = ОКР((КонецКвартала(Окончание)-НачалоКвартала(Начало))/(60*60*24*30*3));
	
	Если РазницаЧасы <= КоличествоИнтервалов Тогда
		
		Единица = ТипЕдиницыШкалыВремени.Час;
		Формат = "ДФ='dd.MM HH:mm'";
		НачалоПолногоИнтервала = НачалоЧаса(Начало);
		ОкончаниеПолногоИнтервала = КонецЧаса(Окончание);
		
	ИначеЕсли РазницаДни <= КоличествоИнтервалов Тогда
		
		Единица = ТипЕдиницыШкалыВремени.День;
		Формат = "ДЛФ=D";
		НачалоПолногоИнтервала = НачалоДня(Начало);
		ОкончаниеПолногоИнтервала = КонецДня(Окончание);
		
	ИначеЕсли РазницаНедели <= КоличествоИнтервалов Тогда
		
		Единица = ТипЕдиницыШкалыВремени.Неделя;
		Формат = "ДЛФ=D";
		НачалоПолногоИнтервала = НачалоНедели(Начало);
		ОкончаниеПолногоИнтервала = КонецНедели(Окончание);
		
	ИначеЕсли РазницаМесяцы <= КоличествоИнтервалов Тогда
		
		Единица = ТипЕдиницыШкалыВремени.Месяц;
		Формат = "ДФ='MMMM yyyy'";
		НачалоПолногоИнтервала = НачалоМесяца(Начало);
		ОкончаниеПолногоИнтервала = КонецМесяца(Окончание);
		
	ИначеЕсли РазницаКварталы <= КоличествоИнтервалов Тогда
		
		Единица = ТипЕдиницыШкалыВремени.Квартал;
		
		ФорматШаблон = "ДФ='q ""%1"" yyyy'";
		Формат = СтрШаблон(ФорматШаблон, НСтр("ru = 'кв.';
												|en = 'apt.'"));
		
		НачалоПолногоИнтервала = НачалоКвартала(Начало);
		ОкончаниеПолногоИнтервала = КонецКвартала(Окончание);
		
	Иначе
		
		Единица = ТипЕдиницыШкалыВремени.Год;
		
		ФорматШаблон = "ДФ='yyyy ""%1""'";
		Формат = СтрШаблон(ФорматШаблон, НСтр("ru = 'г.';
												|en = 'year'"));
		
		НачалоПолногоИнтервала = НачалоГода(Начало);
		ОкончаниеПолногоИнтервала = КонецГода(Окончание);
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Единица", Единица);
	Результат.Вставить("Формат", Формат);
	Результат.Вставить("НачалоПолногоИнтервала", НачалоПолногоИнтервала);
	Результат.Вставить("ОкончаниеПолногоИнтервала", ОкончаниеПолногоИнтервала);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Устанавливает тип поля ввода, содержащего исполнителя трудозатрат.
//
// Параметры:
//  Исполнитель					 - СправочникСсылка.Бригады, СправочникСсылка.ФизическиеЛица - значение поля ввода.
//  ИспользоватьБригадныеНаряды	 - Булево - параметр производственного подразделения.
//
Процедура УстановитьТипИсполнителя(Исполнитель, ИспользоватьБригадныеНаряды) Экспорт
	
	Если Исполнитель <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИспользоватьБригадныеНаряды Тогда
		Исполнитель = ПредопределенноеЗначение("Справочник.Бригады.ПустаяСсылка");
	Иначе
		Исполнитель = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

// Возвращает параметры необходимые для выполнения действия "ЗаполнитьДатуПроизводства".
//
// Параметры:
//  ФактическаяДатаПроизводства	 - Дата - фактическая дата производства
//  ПлановаяДатаПроизводства	 - Дата - плановая дата производства.
// 
// Возвращаемое значение:
//  Структура - список параметров.
//
Функция ПараметрыДействияЗаполнитьДатуПроизводства(ФактическаяДатаПроизводства = '00010101', ПлановаяДатаПроизводства = '00010101') Экспорт
	
	ПараметрыДействия = Новый Структура("ФактическаяДатаПроизводства, ПлановаяДатаПроизводства", ФактическаяДатаПроизводства, ПлановаяДатаПроизводства);
	
	Возврат ПараметрыДействия;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ НЕ УТКА

#Область РедактированиеЭтапаПроизводства

#Область Прочее

// Содержит общие действия выполняемые при изменении номенклатуры в этапе или в заказе переработчику 
// ВАЖНО: здесь должны быть действия, которые допустимы как для этапа так и для заказа переработчику.
//
Процедура ДобавитьВСтруктуруДействияПриИзмененииНоменклатуры(ТекущаяСтрока,
															ИмяТЧ,
															Форма,
															Объект,
															СтруктураДействий,
															ВариантОбеспечения = Неопределено) Экспорт

	Если ТекущаяСтрока <> Неопределено Тогда
		СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", 	ТекущаяСтрока.Характеристика);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ТекущаяСтрока.Упаковка);
	КонецЕсли;
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул", Новый Структура("Номенклатура", "Артикул"));
	СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиниц", ПроизводствоКлиентСервер.ПараметрыПересчетаКоличестваЕдиниц());
	
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, ИмяТЧ));
	
	Если ИмяТЧ = "ОбеспечениеМатериаламиИРаботами" Тогда
	
		ПараметрыУказанияСерий = Форма[Форма.ПараметрыРедактированияЭтапа.ИмяРеквизитаПараметрыУказанияСерий][ИмяТЧ];
		
		ПараметрыМетода = Новый Структура();
		ПараметрыМетода.Вставить("ЗаказНаПроизводство",           Объект.Распоряжение);
		ПараметрыМетода.Вставить("Подразделение",                 Объект.Подразделение);
		ПараметрыМетода.Вставить("Ссылка",                        Объект.Ссылка);
		ПараметрыМетода.Вставить("Статус",                        Объект.Статус);
		ПараметрыМетода.Вставить("НазначениеМатериалы",           Объект.НазначениеМатериалы);
		ПараметрыМетода.Вставить("ЗаказПереработчику",            Объект.ЗаказПереработчику);
		ПараметрыМетода.Вставить("ПараметрыУказанияСерий",        ПараметрыУказанияСерий);
		ПараметрыМетода.Вставить("Форма",                         Форма);
		
		ДобавитьВСтруктуруДействияПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства(
			СтруктураДействий,
			ПараметрыМетода,
			ТекущаяСтрока,
			ВариантОбеспечения);
		
		ПараметрыДействия = ОбеспечениеПроизводстваКлиентСервер.ПараметрыДействияПроверитьЗаполнитьНазначениеОбеспеченияВЭтапеПроизводства(
			Объект);
		СтруктураДействий.Вставить("ПроверитьЗаполнитьНазначениеОбеспеченияВЭтапеПроизводства", ПараметрыДействия);
		
	ИначеЕсли ИмяТЧ = "ЭкономияМатериалов" Тогда
		
		Если ТекущаяСтрока = Неопределено ИЛИ НЕ ТекущаяСтрока.СписатьНаРасходы Тогда
			ПроизводствоКлиентСервер.ДобавитьВСтруктуруДействияПроверитьЗаполнитьСкладПроизводства(Объект.Подразделение, СтруктураДействий, "Получатель");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВСтруктуруДействияПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства(СтруктураДействий, Параметры, ТекущаяСтрока, ВариантОбеспечения = Неопределено) Экспорт
	
	ПараметрыДействия = Новый Структура();
	ПараметрыДействия.Вставить("ЗаказНаПроизводство",  Параметры.ЗаказНаПроизводство);
	ПараметрыДействия.Вставить("Подразделение",        Параметры.Подразделение);
	ПараметрыДействия.Вставить("ВариантОбеспечения",   ВариантОбеспечения);
	
	СтруктураДействий.Вставить("ПроверитьЗаполнитьОбеспечениеВЭтапеПроизводства", ПараметрыДействия);
	
	//
	
	ПараметрыПроверкиСерий = Новый Структура;
	ПараметрыПроверкиСерий.Вставить("Склад", ТекущаяСтрока.Склад);
	ПараметрыПроверкиСерий.Вставить("ПараметрыУказанияСерий", Параметры.ПараметрыУказанияСерий);
	
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПараметрыПроверкиСерий);
	
	//
	
	ПараметрыДокумента = Новый Структура();
	ПараметрыДокумента.Вставить("Форма", Параметры.Форма);
	
	ОбеспечениеВДокументахКлиентСервер.ДобавитьДействияОбеспечения(
		СтруктураДействий,
		"СкладОбязателен,ДатаОтгрузкиОбязательна",
		ПараметрыДокумента);
	
	СтруктураДействий.Вставить("ЗаполнитьПризнакЦеховаяКладовая");
	
КонецПроцедуры

Функция ПараметрыЗаполненияЦенВыпуска(ВидЦены, Валюта, Дата = '00010101') Экспорт
	
	СтруктураЗаполненияЦены = Новый Структура("ВидЦены,Валюта,Дата", ВидЦены, Валюта, Дата);
	Возврат СтруктураЗаполненияЦены;
	
КонецФункции

Процедура ДобавитьВСтруктуруДействияЗаполнитьКолонкуДоступно(СтруктураДействий, Параметры, ТекущаяСтрока) Экспорт
	
	ОбеспечениеВДокументахКлиентСервер.ДобавитьДействияОбеспечения(
		СтруктураДействий,
		"ДоступноВДругихСтроках",
		Параметры);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область Этап

// Возвращает параметры необходимые для заполнения спецификации в строке
// 
// Возвращаемое значение:
// 	Структура.
//
Функция ПараметрыЗаполненияСпецификацииВСтроке() Экспорт

	Возврат Новый Структура("Подразделение,Дата");

КонецФункции

Функция СписокВыбораНаправлениеВыпуска(ТекущиеДанные, Форма) Экспорт
	
	Результат = Новый СписокЗначений;
	
	Если ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
		Результат.Добавить(
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыпускПродукцииВПодразделение"),
			НСтр("ru = 'В подразделение';
				|en = 'To business unit'"));
	Иначе
		Результат.Добавить(
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад"),
			НСтр("ru = 'На склад';
				|en = 'To warehouse'"));
	КонецЕсли;
	
	Если Форма.ИспользоватьСписаниеНаРасходы 		
	   И (ТекущиеДанные.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа")
	 		Или Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма.Объект, "ПроизводствоНаСтороне")
	 		Или Не Форма.Объект.ПроизводствоНаСтороне) Тогда
			
		Результат.Добавить(
			ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СписаниеТоваровПоТребованию"),
			НСтр("ru = 'Списать на расходы';
				|en = 'Expense as'"));
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СтруктурыДанных

Функция СтруктураБуферов() Экспорт
	
	ЕдиницаИзмеренияДень = ПредопределенноеЗначение("Перечисление.ЕдиницыИзмеренияВремени.День");
	
	Результат = Новый Структура;
	
	Результат.Вставить("ПредварительныйБуфер", 0);
	Результат.Вставить("ЕдиницаИзмеренияПредварительногоБуфера", ЕдиницаИзмеренияДень);
	Результат.Вставить("ЗавершающийБуфер", 0);
	Результат.Вставить("ЕдиницаИзмеренияЗавершающегоБуфера", ЕдиницаИзмеренияДень);
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураРасчетаБуфера() Экспорт
	
	Буфер = Новый Структура(
		"Длительность,
		|ЕдиницаИзмерения,
		|Дата,
		|ПрямоеРазмещение,
		|ДатаРазмещения");
	
	Возврат Буфер;

КонецФункции

Функция СтруктураРазмещенияЭтапаВГрафике() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Рассчитан", Ложь);
	
	Результат.Вставить("НачалоЭтапа", '00010101');
	Результат.Вставить("ОкончаниеПредварительногоБуфера", '00010101');
	Результат.Вставить("НачалоЗавершающегоБуфера", '00010101');
	Результат.Вставить("ОкончаниеЭтапа", '00010101');
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураЭтапаСпецификации() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ПроизводствоНаСтороне", Ложь);
	
	Возврат Результат;
	
КонецФункции

Функция СтруктураПродукцииЗаказа() Экспорт
	
	Результат = Новый Структура(
		"Номенклатура,
		|Характеристика,
		|Назначение,
		|Спецификация,
		|Склад,
		|Подразделение,
		|Упаковка,
		|Количество,
		|КоличествоУпаковок");
	
	Возврат Результат;

КонецФункции

Функция КлючПроизводственнойОперации() Экспорт
	
	КлючОперации = Новый Структура("Этап,Операция,ИдентификаторОперации");
	Возврат КлючОперации;
	
КонецФункции

Функция СтруктураЗаменыСпецификации() Экспорт
	
	Результат = Новый Структура("Заказ,НомерСтроки,Спецификация,НоваяСпецификация");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция ИмяСобытияОбновитьДиспетчированиеЭтапов() Экспорт
	
	Возврат "ОбновитьДиспетчированиеЭтапов";
	
КонецФункции

Функция МассивЗначений(Значение, СоздатьНовыйМассив = Ложь) Экспорт

	Перем Результат;
	
	Если ТипЗнч(Значение) <> Тип("Массив") Тогда
		
		Результат = Новый Массив;
		
		Если Значение <> Неопределено Тогда
			Результат.Добавить(Значение);
		КонецЕсли;
		
	ИначеЕсли СоздатьНовыйМассив Тогда
		
		Результат = Новый Массив;
		Для каждого ЭлементКоллекции Из Значение Цикл
			Результат.Добавить(ЭлементКоллекции);
		КонецЦикла;
		
	Иначе
		
		Результат = Значение;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОписаниеНастроекПланирования(ПолноеПерепланирование, ОтменитьРучныеИзмененияГрафика) Экспорт
	
	Если ПолноеПерепланирование И ОтменитьРучныеИзмененияГрафика Тогда
		
		Результат = НСтр("ru = 'Планировать график всех этапов производства. Ручные изменения графика будут отменены.';
						|en = 'Plan the schedule for all production stages. Manual changes will be canceled.'");
		
	ИначеЕсли ПолноеПерепланирование И НЕ ОтменитьРучныеИзмененияГрафика Тогда
		
		Результат = НСтр("ru = 'Планировать график всех этапов производства, исключая размещенные вручную этапы.';
						|en = 'Plan the schedule for all production stages except for stages placed manually.'");
		
	ИначеЕсли НЕ ПолноеПерепланирование И ОтменитьРучныеИзмененияГрафика Тогда
		
		Результат = НСтр("ru = 'Планировать график этапов, требующих пересчета. Ручные изменения графика будут отменены.';
						|en = 'Plan the schedule of stages that require rescheduling. Manual changes will be canceled.'");
		
	Иначе
		
		Результат = НСтр("ru = 'Планировать график этапов, требующих пересчета, исключая размещенные вручную этапы.';
						|en = 'Plan the schedule of all stages that require rescheduling except for stages placed manually.'");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеСменногоЗадания(Смена, Дата, Участок, НесколькоСменВПодразделении) Экспорт
	
	Если НесколькоСменВПодразделении Тогда
		
		Возврат Формат(Дата, "ДЛФ=D") + " " + Смена + ?(ЗначениеЗаполнено(Участок), ", " + Участок, "");
		
	Иначе
		
		Возврат Формат(Дата, "ДЛФ=D") + ?(ЗначениеЗаполнено(Участок), ", " + Участок, "");
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти

//-- НЕ УТКА

#КонецОбласти
