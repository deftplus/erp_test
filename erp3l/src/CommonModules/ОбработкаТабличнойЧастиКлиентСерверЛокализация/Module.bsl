#Область ПрограммныйИнтерфейс

Процедура ДополнитьСтруктуруДействийПриИзмененииЭлемента(Форма, Элемент, СтруктураДействий) Экспорт
	
	//++ Локализация
	Если Форма.ИмяФормы = "Документ.ОтчетОРозничныхПродажах.Форма.ФормаДокумента" Тогда
		СтруктураДействий.Вставить("ЗаполнитьПризнакПодакцизныйТовар", Новый Структура("Номенклатура", "ПодакцизныйТовар"));
	КонецЕсли;
	
	Если Не ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ПараметрыИнтеграцииГосИС") Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.ИмяФормы = "Документ.ЧекККМ.Форма.ФормаДокументаРМК"
		Или Форма.ИмяФормы = "Документ.ЧекККМВозврат.Форма.ФормаДокументаРМК" Тогда
		Если Элемент = "Номенклатура" Тогда
			
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено
					Или Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
				СтруктураДействий.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
				СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",
					Новый Структура("Склад, ПараметрыУказанияСерий", Форма.Объект.Склад, Форма.ПараметрыУказанияСерий));
			КонецЕсли;
			
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИСДляЧека(Форма));
			КонецЕсли;
		ИначеЕсли Элемент = "НоменклатураПризнаки" Тогда
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
				СтруктураДействий.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
			КонецЕсли;
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
				СтруктураДействий.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
			КонецЕсли;
		ИначеЕсли Элемент = "Характеристика"
			Или Элемент = "Серия" Тогда
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ЕГАИС")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьНоменклатуруЕГАИС", ПараметрыЗаполненияНоменклатурыЕГАИСДляЧека(Форма));
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Форма.ИмяФормы = "Документ.ВозвратТоваровПоставщику.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.КорректировкаРеализации.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.РеализацияТоваровУслуг.Форма.ФормаДокумента" Тогда
			
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП")<>Неопределено Тогда
				СтруктураДействий.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
				СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
				СтруктураДействий.Вставить("СнятьПризнакМаркируемаяПродукцияАлкоголь", Новый Структура);
			КонецЕсли;
	ИначеЕсли (Форма.ИмяФормы = "Документ.ВозвратТоваровОтПокупателя.Форма.ФормаДокумента"
		Или Форма.ИмяФормы = "Документ.ПриобретениеТоваровУслуг.Форма.ФормаДокумента") Тогда
			
			Если Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП")<>Неопределено 
				И Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП").ВидыПродукции.Количество() > 0 
				И Форма.ПараметрыИнтеграцииГосИС.Получить(
					Форма.ПараметрыИнтеграцииГосИС.Получить("ИСМП").ВидыПродукции[0]).ИспользоватьКолонкуСтатусаПроверкиПодбора Тогда
				СтруктураДействий.Вставить("ЗаполнитьВидПродукцииИС", Новый Структура("Номенклатура", "ВидПродукцииИС"));
				СтруктураДействий.Вставить("ЗаполнитьПризнакМаркируемаяПродукция", Новый Структура("Номенклатура", "МаркируемаяПродукция"));
				СтруктураДействий.Вставить("СнятьПризнакМаркируемаяПродукцияАлкоголь", Новый Структура);
			КонецЕсли;
	КонецЕсли;
	//-- Локализация
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ДополнитьСтруктуруКэшируемыеЗначения(КэшированныеЗначения) Экспорт

	//++ Локализация

	КэшированныеЗначения.Вставить("ПризнакиКатегорииЭксплуатации", Новый Соответствие);
	СтруктураПустойКатегории = Новый Структура;
	//++ НЕ УТ
	СтруктураПустойКатегории.Вставить("ИнвентарныйУчет", Ложь);
	СтруктураПустойКатегории.Вставить("СпособПогашенияСтоимостиБУ", ПредопределенноеЗначение("Перечисление.СпособыПогашенияСтоимостиТМЦ.ПоСроку"));
	//-- НЕ УТ
	СтруктураПустойКатегории.Вставить("СрокЭксплуатации", 0);
	СтруктураПустойКатегории.Вставить("СтатьяРасходов", ПредопределенноеЗначение("ПланВидовХарактеристик.СтатьиРасходов.ПустаяСсылка"));
	КэшированныеЗначения.ПризнакиКатегорииЭксплуатации.Вставить(ПредопределенноеЗначение("Справочник.КатегорииЭксплуатации.ПустаяСсылка"), СтруктураПустойКатегории);
	
	//-- Локализация
	
КонецПроцедуры

#Область Локализация

//++ Локализация

// Пересчитывает количество товара ВЕТИС в текущей строке табличной части документа.
//
// Параметры:
//	ТекущаяСтрока			- Структура - Структура со свойствами строки документа.
//	СтруктураДействий		- Структура - Структура с действиями, которые нужно произвести.
//	КэшированныеЗначения	- Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//
Процедура ПересчитатьКоличествоЕдиницВЕТИСВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Перем ПараметрыПересчетаКоличестваВЕТИС, ТекстОшибки;
	
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницВЕТИС", ПараметрыПересчетаКоличестваВЕТИС) Тогда
		
		ПараметрыПересчета = ОбработкаТабличнойЧастиКлиентСервер.НормализоватьПараметрыПересчетаЕдиниц(ТекущаяСтрока, ПараметрыПересчетаКоличестваВЕТИС);
		
		КоличествоВЕТИС = ИнтеграцияВЕТИСУТКлиентСервер.ПересчитатьКоличествоЕдиницВЕТИС(
											ТекущаяСтрока["Количество"+ПараметрыПересчетаКоличестваВЕТИС.Суффикс],
											ПараметрыПересчета.Номенклатура,
											ПараметрыПересчета.Упаковка,
											ПараметрыПересчета.НужноОкруглять,
											КэшированныеЗначения,
											ТекстОшибки);
		
		Если КоличествоВЕТИС <> Неопределено Тогда
			ИмяКоличестваВЕТИС = "Количество" + ПараметрыПересчетаКоличестваВЕТИС.Суффикс + "ВЕТИС";
			
			ТекущаяСтрока[ИмяКоличестваВЕТИС] = КоличествоВЕТИС;
		ИначеЕсли ТекстОшибки <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Пересчитывает количество товара (в единицах хранения) в текущей строке табличной части документа.
//
// Параметры:
//	ТекущаяСтрока			- Структура - Структура со свойствами строки документа.
//	СтруктураДействий		- Структура - Структура с действиями, которые нужно произвести.
//	КэшированныеЗначения	- Структура - Сохраненные значения параметров, используемых при обработке строки таблицы.
//
Процедура ПересчитатьКоличествоЕдиницПоВЕТИСВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Перем ПараметрыПересчетаКоличества, ТекстОшибки;
	
	Если СтруктураДействий.Свойство("ПересчитатьКоличествоЕдиницПоВЕТИС", ПараметрыПересчетаКоличества) Тогда
		
		ПараметрыПересчета = ОбработкаТабличнойЧастиКлиентСервер.НормализоватьПараметрыПересчетаЕдиниц(ТекущаяСтрока, ПараметрыПересчетаКоличества);
		ИмяКоличестваВЕТИС = "Количество" + ПараметрыПересчетаКоличества.Суффикс + "ВЕТИС";
		
		Количество = ИнтеграцияВЕТИСУТКлиентСервер.ПересчитатьКоличествоЕдиниц(
											ТекущаяСтрока[ИмяКоличестваВЕТИС],
											ПараметрыПересчета.Номенклатура,
											ПараметрыПересчета.Упаковка,
											ПараметрыПересчета.НужноОкруглять,
											КэшированныеЗначения,
											ТекстОшибки);
											
		Если Количество <> Неопределено Тогда
			ТекущаяСтрока["Количество" + ПараметрыПересчетаКоличества.Суффикс] = Количество;
		ИначеЕсли ТекстОшибки <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает сведения о коэффициенте пересчета единицы измерения ВЕТИС.
//
// Параметры:
//	ЕдиницаИзмеренияВЕТИС	- СправочникСсылка.ЕдиницыИзмеренияВЕТИС	- Единица измерения ВЕТИС, коэффициент которой нужно 
//																		получить.
//	КэшированныеЗначения	- Структура									- Сохраненные значения параметров, используемых при обработке 
//																		строки таблицы.
//	Номенклатура			- СправочникСсылка.Номенклатура				- Номенклатура для единицы хранения, которой осуществляется 
//																		получение коэффициента пересчета.
//
// Возвращаемое значение:
//	Структура - Структура со свойствами:
//		* КодОшибки						- Число				- Код ошибки получения коэффициента.
//																0 - Нет ошибок;
//																1 - Не заполнена единица измерения в справочнике 'ЕдиницыИзмеренияВЕТИС';
//																2 - В справочнике 'Номенклатура' выключена возможность пересчета количества 
//																	в соответствующую мерную единицу измерения;
//																3 - Не удалось сопоставить единицу хранения справочника 'Номенклатура' 
//																	с единицей измерения справочника 'ЕдиницыИзмеренияВЕТИС'.
//		* Коэффициент					- Число				- Коэффициент пересчета единицы измерения ВЕТИС.
//		* ТипИзмеряемойВеличины			- ПеречислениеСсылка.ТипыИзмеряемыхВеличин - Тип измеряемой величины единицы измерения 
//																						справочника 'ЕдиницыИзмеренияВЕТИС'.
//		* НужноОкруглятьКоличество		- Булево, Истина	- Признак необходимости округления количества при пересчете.
//		* НужноОкруглятьКоличествоВЕТИС	- Булево, Истина	- Признак необходимости округления количества ВетИС при пересчете.
//
Функция ПолучитьКоэффициентЕдиницыИзмеренияВЕТИС(ЕдиницаИзмеренияВЕТИС, КэшированныеЗначения, Номенклатура = Неопределено) Экспорт
	
	ИменаКлючей = "КодОшибки, Коэффициент, ТипИзмеряемойВеличины, НужноОкруглятьКоличество,"
					+ "НужноОкруглятьКоличествоВЕТИС";
	
	Результат = Новый Структура(ИменаКлючей);
	
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС) Тогда
		
		КлючКоэффициента = ОбработкаТабличнойЧастиКлиентСервер.КлючКэшаУпаковки(Номенклатура, ЕдиницаИзмеренияВЕТИС);
		Кэш              = КэшированныеЗначения.КоэффициентыУпаковок[КлючКоэффициента];
		
		Если Кэш = Неопределено Тогда
			#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
				ЗначенияРеквизитов = ОбработкаТабличнойЧастиСерверЛокализация.ДанныеЕдиницыИзмеренияВЕТИС(
										ЕдиницаИзмеренияВЕТИС, 
										Номенклатура,
										КэшированныеЗначения);
				
				ЗаполнитьЗначенияСвойств(Результат, ЗначенияРеквизитов);
			#Иначе
				ТекстИсключения = НСтр("ru = 'Попытка получения коэффициента единицы измерения ВетИС на клиенте.';
										|en = 'Attempt to receive factor of VetIS unit of measure on client.'");
				ВызватьИсключение ТекстИсключения;
			#КонецЕсли
		Иначе
			Результат = Кэш;
		КонецЕсли;
	Иначе
		Результат.КодОшибки                     = 0;
		Результат.Коэффициент                   = 1;
		Результат.ТипИзмеряемойВеличины         = Неопределено;
		Результат.НужноОкруглятьКоличество      = Ложь;
		Результат.НужноОкруглятьКоличествоВЕТИС = Ложь;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//-- Локализация

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

//++ Локализация

Функция ПараметрыЗаполненияНоменклатурыЕГАИСДляЧека(Форма) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ИмяКолонки", "НоменклатураЕГАИС");
	ПараметрыЗаполнения.Вставить("Серии", Форма.Объект.Серии);
	Возврат ПараметрыЗаполнения;
	
КонецФункции

//-- Локализация
#КонецОбласти