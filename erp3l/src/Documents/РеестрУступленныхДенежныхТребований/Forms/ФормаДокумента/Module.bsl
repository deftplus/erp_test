
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоговорКонтрагентаПриИзменении(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда 
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПолучитьПараметрыДоговораФакторинга(Объект.ДоговорКонтрагента));
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыУступленныеТребования

&НаКлиенте
Процедура УступленныеТребованияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование И Элементы.УступленныеТребования.ТекущиеДанные <> Неопределено Тогда
		Элементы.УступленныеТребования.ТекущиеДанные.ПроцентАванса = ПроцентАвансаПоФакторингу;
		Элементы.УступленныеТребования.ТекущиеДанные.Комиссия = КомиссияЗаОбработкуСчетаФактуры;
		Элементы.УступленныеТребования.ТекущиеДанные.СтавкаПоФакторингу = ПроцентнаяСтавкаПоФакторингу;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УступленныеТребованияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Если ВыбранноеЗначение.Свойство("РасчетныйДокумент") И ВыбранноеЗначение.Свойство("СрокПогашения") Тогда
			
			СтандартнаяОбработка = Ложь;
			
			СтруктураПоиска = Новый Структура("РасчетныйДокумент, СрокПогашения");
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, ВыбранноеЗначение);
			
			Если Объект.УступленныеТребования.НайтиСтроки(СтруктураПоиска).Количество() = 0 Тогда
				
				НоваяСтрока = Объект.УступленныеТребования.Добавить();
				НоваяСтрока.Контрагент = ВыбранноеЗначение.Контрагент;
				НоваяСтрока.Договор = ВыбранноеЗначение.ДоговорКонтрагента;
				НоваяСтрока.ОбъектРасчетов = ВыбранноеЗначение.ОбъектРасчетов;
				НоваяСтрока.РасчетныйДокумент = ВыбранноеЗначение.РасчетныйДокумент;
				НоваяСтрока.СуммаОбязательства = ВыбранноеЗначение.Сумма;
				НоваяСтрока.Валюта = ВыбранноеЗначение.Валюта;
				НоваяСтрока.СрокПогашения = ВыбранноеЗначение.СрокПогашения;
				НоваяСтрока.ПроцентАванса = ПроцентАвансаПоФакторингу;
				НоваяСтрока.Комиссия = КомиссияЗаОбработкуСчетаФактуры;
				НоваяСтрока.СтавкаПоФакторингу = ПроцентнаяСтавкаПоФакторингу;
				НоваяСтрока.СрокПоступления = РасчетОжидаемойДатыФакторинга(ВыбранноеЗначение.СрокПогашения,
					СпособВычисленияДатыФакторинга, КоличествоДнейОтсрочкиФакторинга);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиентеНаСервереБезКонтекста
Функция РасчетОжидаемойДатыФакторинга(ОжидаемаяДата, СпособВычисленияДатыФакторинга, КоличествоДнейОтсрочкиФакторинга)
	Если СпособВычисленияДатыФакторинга = ПредопределенноеЗначение("Перечисление.СпособыВычисленияДатыФакторинга.ВКонцеМесяца") Тогда
		Возврат КонецМесяца(ОжидаемаяДата); 
	Иначе
		Возврат ОжидаемаяДата + КоличествоДнейОтсрочкиФакторинга * 86400;
	КонецЕсли;
КонецФункции


&НаКлиенте
Процедура Подбор(Команда)
	ПараметрыПодбора = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор, Организация", Ложь, Истина, Объект.Организация);
	ОткрытьФорму("Документ.РеестрУступленныхДенежныхТребований.Форма.ФормаПодбораДокументов", ПараметрыПодбора, Элементы.УступленныеТребования,);
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	Если Не ЗначениеЗаполнено(Объект.ДатаФинансирования) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не заполнена дата аванса'"), Объект.Ссылка, "ДатаФинансирования");
		Возврат;
	КонецЕсли;
	Ошибки = Неопределено;
	Для каждого Стр Из Объект.УступленныеТребования Цикл
		Если Стр.СрокПоступления < Объект.ДатаФинансирования Тогда
			ТекстОшибки = СтрШаблон(НСтр("ru='Ожидаемый срок получения средств в строке %1 меньше даты получения аванса'"), Объект.УступленныеТребования.Индекс(Стр) + 1);
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "", ТекстОшибки, "УступленныеТребованияСрокПоступления", Объект.УступленныеТребования.Индекс(Стр) + 1, ТекстОшибки);
		КонецЕсли;
	КонецЦикла;
	Если Ошибки <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
		Возврат;
	КонецЕсли;
	Если Объект.ГрафикРасчета.Количество() <> 0 Тогда 
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?'"), РежимДиалогаВопрос.ДаНет, 20);
	Иначе
		ЗаполнитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	Для каждого Стр Из Элементы.УступленныеТребования.ВыделенныеСтроки Цикл
	    Элементы.УступленныеТребования.ДанныеСтроки(Стр).Отклонено = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	Для каждого Стр Из Элементы.УступленныеТребования.ВыделенныеСтроки Цикл
	    Элементы.УступленныеТребования.ДанныеСтроки(Стр).Отклонено = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПроцентАванса(Команда)
	Значение = Объект.ПроцентАвансаПоФакторингу;
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПроцентАвансаЗавершение", ЭтотОбъект), НСтр("ru = 'Заполнить введенным значением процента аванса все выделенные строки?'"), РежимДиалогаВопрос.ДаНет, 20);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПересчетТабличнойЧастиУступленныеТребования()
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Таблица.Контрагент,
		|	Таблица.СуммаОбязательства,
		|	Таблица.СрокПоступления,
		|	Таблица.СтавкаПоФакторингу,
		|	Таблица.Комиссия,
		|	Таблица.ПроцентАванса,
		|	Таблица.Отклонено
		|ПОМЕСТИТЬ Таблица
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Контрагент,
		|	Таблица.СуммаОбязательства,
		|	Таблица.СрокПоступления КАК СрокПогашения,
		|	Таблица.СуммаОбязательства * Таблица.ПроцентАванса / 100 КАК СуммаАванса,
		|	Таблица.ПроцентАванса,
		|	Таблица.Комиссия,
		|	Таблица.СтавкаПоФакторингу
		|ПОМЕСТИТЬ Расчет
		|ИЗ
		|	Таблица КАК Таблица
		|ГДЕ
		|	НЕ Таблица.Отклонено
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Расчет.Контрагент,
		|	Расчет.СуммаОбязательства - Расчет.СуммаАванса КАК Сумма,
		|	Расчет.СрокПогашения,
		|	Расчет.СуммаОбязательства * Расчет.ПроцентАванса / 100 * Расчет.СтавкаПоФакторингу / 100 / 365 * РАЗНОСТЬДАТ(&ДатаФинансирования, Расчет.СрокПогашения, ДЕНЬ) + Расчет.Комиссия КАК Комиссия
		|ПОМЕСТИТЬ ИтогиРасчет
		|ИЗ
		|	Расчет КАК Расчет
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Расчет.Контрагент,
		|	Расчет.СуммаАванса,
		|	&ДатаФинансирования,
		|	0
		|ИЗ
		|	Расчет КАК Расчет
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИтогиРасчет.Контрагент,
		|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка) КАК СтатьяДвиженияДенежныхСредств,
		|	СУММА(ИтогиРасчет.Сумма) КАК Сумма,
		|	ИтогиРасчет.СрокПогашения КАК Дата,
		|	СУММА(ИтогиРасчет.Комиссия) КАК Комиссия,
		|	СУММА(ИтогиРасчет.Сумма - ИтогиРасчет.Комиссия) КАК СуммаПоступления
		|ИЗ
		|	ИтогиРасчет КАК ИтогиРасчет
		|
		|СГРУППИРОВАТЬ ПО
		|	ИтогиРасчет.СрокПогашения,
		|	ИтогиРасчет.Контрагент
		|
		|УПОРЯДОЧИТЬ ПО
		|	Дата";
	
	Запрос.УстановитьПараметр("ДатаФинансирования", Объект.ДатаФинансирования);
	Запрос.УстановитьПараметр("Таблица", Объект.УступленныеТребования.Выгрузить());
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Заполнение = РезультатЗапроса.Выгрузить();
	Заполнение.ЗаполнитьЗначения(Объект.ДоговорКонтрагента.СтатьяДвиженияДенежныхСредств, "СтатьяДвиженияДенежныхСредств");
	
	Объект.ГрафикРасчета.Загрузить(Заполнение);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыДоговораФакторинга(Договор)
	РеквизитыДоговораФакторинга = "ПроцентАвансаПоФакторингу, ПроцентнаяСтавкаПоФакторингу, 
	|	КомиссияЗаОбработкуСчетаФактуры, КоличествоДнейОтсрочкиФакторинга, СпособВычисленияДатыФакторинга";
	Если Договор.ВидФинансовогоИнструмента = Перечисления.ВидыФинансовыхИнструментов.Факторинг Тогда
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, РеквизитыДоговораФакторинга);
	Иначе
		Возврат Новый Структура(РеквизитыДоговораФакторинга);
	КонецЕсли;
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура УступленныеТребованияКонтрагентПриИзменении(Элемент)
	РеквизитВзаиморасчетовПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УступленныеТребованияДоговорПриИзменении(Элемент)
	РеквизитВзаиморасчетовПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УступленныеТребованияОбъектРасчетовПриИзменении(Элемент)
	РеквизитВзаиморасчетовПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УступленныеТребованияРасчетныйДокументПриИзменении(Элемент)
	РеквизитВзаиморасчетовПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура РеквизитВзаиморасчетовПриИзмененииНаСервере()

	ТекущаяСтрока = Элементы.УступленныеТребования.ТекущаяСтрока;
	ДанныеСтроки = Объект.УступленныеТребования.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ДанныеСтроки = неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСуммуОбязательств(ДанныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммуОбязательств(ДанныеСтроки)
	
	ПараметрыЗапроса = Новый Структура();
	ПараметрыЗапроса.Вставить("Организация");
	ПараметрыЗапроса.Вставить("Контрагент");
	ПараметрыЗапроса.Вставить("Договор");
	ПараметрыЗапроса.Вставить("ОбъектРасчетов");
	ПараметрыЗапроса.Вставить("РасчетныйДокумент");
	ЗаполнитьЗначенияСвойств(ПараметрыЗапроса, ДанныеСтроки);
	ПараметрыЗапроса.Организация = Объект.Организация;
	
	Результат = ПретензииУХ.ДебиторскаяЗадолженностьПоПараметрам(ПараметрыЗапроса);
	
	ДанныеСтроки.СуммаОбязательства = Результат.СуммаОбязательства;
	ДанныеСтроки.Валюта = Результат.Валюта;
	ДанныеСтроки.СрокПогашения = Результат.ДатаПлановогоПогашения;
	ДанныеСтроки.СрокПоступления = РасчетОжидаемойДатыФакторинга(
		ДанныеСтроки.СрокПогашения, СпособВычисленияДатыФакторинга, КоличествоДнейОтсрочкиФакторинга);
	
КонецПроцедуры