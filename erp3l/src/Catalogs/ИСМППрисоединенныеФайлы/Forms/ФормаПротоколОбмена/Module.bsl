#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИС.ОтработатьВходящийДокументПротоколаОбмена(ЭтотОбъект);
	
	Если НЕ Метаданные.ОпределяемыеТипы.ДокументыИСМП.Тип.СодержитТип(ТипЗнч(Документ)) Тогда
		РеквизитыДокументаОснования = Новый ФиксированнаяСтруктура(
			ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Ссылка, Проведен"));
		Организация = ИнтеграцияИС.ОрганизацияИзПрикладногоОбъекта(Документ);
	Иначе
		Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Организация");
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	ЗаполнитьДеревоФайлов();
	
	// ИнтеграцияИС
	Если РеквизитыДокументаОснования <> Неопределено Тогда
		ИнтеграцияИС.ПриСозданииНаСервереВФормеДокументаОснования(
			ЭтотОбъект,
			РеквизитыДокументаОснования,
			ИнтеграцияИС.ПараметрыИнтеграцииВФорме("ИСМП",ИнтеграцияИС.ИмяЭлементаДляРазмещения()));
	КонецЕсли;
	// Конец ИнтеграцияИС
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ПерезаполнитьДерево = Ложь;
	
	Если ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененоСостояние(ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы())
	 И (Параметр.Ссылка = Документ Или (Параметр.Свойство("Основание") И Параметр.Основание = Документ)) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	ИначеЕсли ИмяСобытия = ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы())
	 И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	ИначеЕсли СтрНачинаетсяС(ИмяСобытия, ИнтеграцияИСКлиентСервер.ИмяСобытияИзмененОбъект(ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы())) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	КонецЕсли;
	
	Если ПерезаполнитьДерево Тогда
		ОбновитьДерево();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстДокументаИСМПОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	// ИнтеграцияИС
	Если РеквизитыДокументаОснования <> Неопределено Тогда
		ИнтеграцияИСКлиент.ОбработкаНавигационнойСсылкиВФормеДокументаОснования(
			ЭтотОбъект,
			РеквизитыДокументаОснования,
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка);
	КонецЕсли;
	// Конец ИнтеграцияИС
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовДереваФайлов

&НаКлиенте
Процедура ДеревоФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьСообщенияОперации(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ОчиститьСообщения();
	
	РезультатОбмена = ИнтеграцияИСМПВызовСервера.ВыполнитьОбмен(
		Организация, УникальныйИдентификатор, Документ);
	
	ИнтеграцияИСМПСлужебныйКлиент.ОбработатьРезультатОбмена(
		РезультатОбмена, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщенияXML(Команда)
	
	ПоказатьСообщенияОперации(Элементы.ДеревоФайлов.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтатус(Команда)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьСтатусНаСервере(ТекущиеДанные.Документ);
	
	Оповестить(ИнтеграцияИСКлиентСервер.ИмяСобытияВыполненОбмен(ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы()));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДерево()
	
	ЗаполнитьДеревоФайлов();
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ИнтеграцияИС.УстановитьУсловноеОформлениеПротоколаОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьСтатусНаСервере(ДокументСсылка)
	
	ИнтеграцияИСМП.РассчитатьСтатусДокументаПоДаннымПротоколаОбмена(ДокументСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеОперации(СтрокаПоследовательности, ДокументСсылка, ВыборкаПоФайлам = Неопределено, ТаблицаРасчетаКоличества = Неопределено)
	
	Если СтрокаПоследовательности = Неопределено Тогда
		
		Возврат "";
		
	ИначеЕсли СтрокаПоследовательности.ТипСообщения = Перечисления.ТипыЗапросовИС.Исходящий Тогда
		
		Если ВыборкаПоФайлам = Неопределено Тогда
			Возврат ИнтеграцияИСМПСлужебный.ОписаниеОперацииПередачиДанных(СтрокаПоследовательности.Операция, Неопределено, Неопределено);
		Иначе
			
			ТекстПоКоличествуСообщений = Неопределено;
			
			Если ТаблицаРасчетаКоличества <> Неопределено Тогда
				
				СтруктураПоиска = Новый Структура();
				СтруктураПоиска.Вставить("Ссылка",   ВыборкаПоФайлам.Ссылка);
				СтруктураПоиска.Вставить("Версия",   ВыборкаПоФайлам.Версия);
				СтруктураПоиска.Вставить("Операция", ВыборкаПоФайлам.Операция);
				
				ПоискСтрок = ТаблицаРасчетаКоличества.НайтиСтроки(СтруктураПоиска);
				
				Если ПоискСтрок.Количество() > 0 И ПоискСтрок[0].СоставнаяОперация Тогда
					ТекстПоКоличествуСообщений = СтрШаблон(
						НСтр("ru = '%1 из %2';
							|en = '%1 из %2'"), ПоискСтрок[0].ТекущийНомер , ПоискСтрок[0].Количество);
				КонецЕсли;
				
			КонецЕсли;
			
			Возврат ИнтеграцияИСМПСлужебный.ОписаниеОперацииПередачиДанных(
				СтрокаПоследовательности.Операция, Неопределено, ВыборкаПоФайлам.Версия, ТекстПоКоличествуСообщений);
			
		КонецЕсли;
		
	ИначеЕсли СтрокаПоследовательности.ТипСообщения = Перечисления.ТипыЗапросовИС.Входящий Тогда
		
		Возврат ИнтеграцияИСМПСлужебный.ОписаниеОперацииПолученияДанных(СтрокаПоследовательности.Операция);
		
	Иначе
		
		Возврат Строка(СтрокаПоследовательности.Операция);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ТаблицаДокументы(Документ = Неопределено)
	
	ТаблицаДокументы = Новый ТаблицаЗначений;
	ТаблицаДокументы.Колонки.Добавить("Ссылка",              Метаданные.Справочники.ИСМППрисоединенныеФайлы.Реквизиты.Документ.Тип);
	ТаблицаДокументы.Колонки.Добавить("Статус",              Метаданные.РегистрыСведений.СтатусыДокументовИСМП.Ресурсы.Статус.Тип);
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие1", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП"));
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие2", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП"));
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие3", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюИСМП"));
	
	Если Документ <> Неопределено Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Таблица.Документ            КАК Ссылка,
		|	Таблица.Статус              КАК Статус,
		|	Таблица.ДальнейшееДействие1 КАК ДальнейшееДействие1,
		|	Таблица.ДальнейшееДействие2 КАК ДальнейшееДействие2,
		|	Таблица.ДальнейшееДействие3 КАК ДальнейшееДействие3
		|ИЗ
		|	РегистрСведений.СтатусыДокументовИСМП КАК Таблица
		|ГДЕ
		|	Таблица.Документ = &ДокументСсылка
		|");
		
		Запрос.УстановитьПараметр("ДокументСсылка", Документ);
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаДокументы.Добавить(), Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДокументы;
	
КонецФункции

&НаСервере
Процедура РассчитатьКоличествоДляПредставления(ТаблицаРасчетаКоличества)

	ВременнаяТаблицаРасчета = ТаблицаРасчетаКоличества.Скопировать();
	ВременнаяТаблицаРасчета.Свернуть("Версия, Операция", "Количество");
	
	Для Каждого СтрокаГруппы Из ВременнаяТаблицаРасчета Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Версия",   СтрокаГруппы.Версия);
		СтруктураПоиска.Вставить("Операция", СтрокаГруппы.Операция);
		
		ПоискСтрок = ТаблицаРасчетаКоличества.НайтиСтроки(СтруктураПоиска);
		Для Каждого НайденнаяСтрока Из ПоискСтрок Цикл
			НайденнаяСтрока.Количество        = СтрокаГруппы.Количество;
			НайденнаяСтрока.ТекущийНомер      = ПоискСтрок.Найти(НайденнаяСтрока) + 1;
			НайденнаяСтрока.СоставнаяОперация = ПоискСтрок.Количество() > 1;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция НоваяТаблицаРасчетаКоличестваОпераций()
	
	ТаблицаРасчетаКоличества = Новый ТаблицаЗначений();
	ТаблицаРасчетаКоличества.Колонки.Добавить("Версия");
	ТаблицаРасчетаКоличества.Колонки.Добавить("Операция");
	ТаблицаРасчетаКоличества.Колонки.Добавить("Ссылка");
	ТаблицаРасчетаКоличества.Колонки.Добавить("ТекущийНомер");
	ТаблицаРасчетаКоличества.Колонки.Добавить("Количество");
	ТаблицаРасчетаКоличества.Колонки.Добавить("СоставнаяОперация");
	
	ТаблицаРасчетаКоличества.Индексы.Добавить("Версия, Операция");
	ТаблицаРасчетаКоличества.Индексы.Добавить("Ссылка, Версия, Операция");
	
	Возврат ТаблицаРасчетаКоличества;
	
КонецФункции

#Область ЗаполнениеДереваФайлов

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаЗаказНаЭмиссиюКодовМаркировкиСУЗ(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаМаркировкаТоваровИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.МаркировкаТоваровИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаВыводИзОборотаИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ВыводИзОборотаИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаСписаниеКодовМаркировкиИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.СписаниеКодовМаркировкиИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаПеремаркировкаТоваровИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ПеремаркировкаТоваровИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаОтгрузкаТоваровИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ОтгрузкаТоваровИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаПриемкаТоваровИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ПриемкаТоваровИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаВозвратВОборотИСМП(ДокументОснование)
	
	МетаданныеДокумента = Метаданные.Документы.ВозвратВОборотИСМП;
	
	ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокумента, ДокументОснование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаИСМП(МетаданныеДокументаИСМП, ДокументОснование, ДобавитьГиперссылку = Истина)
	
	ШаблонТекстаЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка                   КАК Ссылка,
	|	СтатусыДокументовИСМП.Статус              КАК Статус,
	|	СтатусыДокументовИСМП.ДальнейшееДействие1 КАК ДальнейшееДействие1,
	|	СтатусыДокументовИСМП.ДальнейшееДействие2 КАК ДальнейшееДействие2,
	|	СтатусыДокументовИСМП.ДальнейшееДействие3 КАК ДальнейшееДействие3
	|ИЗ
	|	Документ.%1 КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыДокументовИСМП КАК СтатусыДокументовИСМП
	|		ПО СтатусыДокументовИСМП.Документ = ТаблицаДокумента.Ссылка
	|ГДЕ
	|	ТаблицаДокумента.ДокументОснование = &ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокумента.Дата";
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонТекстаЗапроса,
		МетаданныеДокументаИСМП.Имя);
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	ТаблицаДокументы = ТаблицаДокументы();
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаДокументы.Добавить(), Выборка);
	КонецЦикла;
	
	ЗаполнитьПоДокументу(ТаблицаДокументы, Истина);
	
	Если НЕ ДобавитьГиперссылку Тогда
		Возврат;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтатусыОформленияДокументовИСМП.Документ,
	|	СтатусыОформленияДокументовИСМП.СтатусОформления КАК Статус,
	|	СтатусыОформленияДокументовИСМП.Архивный КАК Архивный
	|ИЗ
	|	РегистрСведений.СтатусыОформленияДокументовИСМП КАК СтатусыОформленияДокументовИСМП
	|ГДЕ
	|	СтатусыОформленияДокументовИСМП.Основание = &ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтатусыОформления = Новый Структура;
	Пока Выборка.Следующий() Цикл
		СтатусыОформления.Вставить(Выборка.Документ.Метаданные().Имя, 
			Новый Структура("Статус, Архивный", Выборка.Статус, Выборка.Архивный));
	КонецЦикла;
	
	Если СтатусыОформления.Свойство(МетаданныеДокументаИСМП.Имя)
		И СтатусыОформления[МетаданныеДокументаИСМП.Имя].Статус <> Перечисления.СтатусыОформленияДокументовГосИС.Оформлено
		И Не СтатусыОформления[МетаданныеДокументаИСМП.Имя].Архивный Тогда
		
		ПравоДобавления = ПравоДоступа("Добавление", МетаданныеДокументаИСМП);
		
		Шаблон = ИнтеграцияИСМП.ШаблонПредставленияДокументаДляПоляИнтеграции(
			МетаданныеДокументаИСМП,
			ДокументОснование);
		
		Если Не ПравоДобавления Тогда
			ТекстНадписи = Шаблон.ДокументНеСоздан;
			ИмяКоманды   = Неопределено;
		ИначеЕсли МетаданныеДокументаИСМП = Метаданные.Документы.ЗаказНаЭмиссиюКодовМаркировкиСУЗ Тогда
			ТекстНадписи = Шаблон.ПредставлениеКомандыПулКодовМаркировки;
			ИмяКоманды   = Шаблон.ИмяКомандыПулКодовМаркировки;
		Иначе
			ТекстНадписи = Шаблон.ПредставлениеКомандыСоздать;
			ИмяКоманды   = Шаблон.ИмяКомандыСоздать;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстНадписи) Тогда
			
			ФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				ТекстНадписи,
				,
				?(ЗначениеЗаполнено(ИмяКоманды), ЦветаСтиля.ГиперссылкаЦвет, Неопределено),
				,
				ИмяКоманды);
			
			Строки = Новый Массив;
			
			Если ЗначениеЗаполнено(ТекстДокументаИСМП) Тогда
				Строки.Добавить(ТекстДокументаИСМП);
				Строки.Добавить(", ");
			КонецЕсли;
			Строки.Добавить(ФорматированнаяСтрока);
			
			ТекстДокументаИСМП = Новый ФорматированнаяСтрока(Строки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументу(ТаблицаДокументы, ОтображатьСИерархией = Ложь)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
	|ИЗ
	|	&ТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИСМППрисоединенныеФайлы.ДатаМодификацииУниверсальная       КАК ДатаМодификацииУниверсальная,
	|	ИСМППрисоединенныеФайлы.Документ                           КАК Документ,
	|	ИСМППрисоединенныеФайлы.Ссылка                             КАК Ссылка,
	|	ИСМППрисоединенныеФайлы.ТипСообщения                       КАК ТипСообщения,
	|	ИСМППрисоединенныеФайлы.Операция                           КАК Операция,
	|	ИСМППрисоединенныеФайлы.СтатусОбработки                    КАК СтатусОбработки,
	|	
	|	// Версия и Описание - из присоединенных файлов
	|	ВЫРАЗИТЬ(ИСМППрисоединенныеФайлы.Описание КАК Строка(255)) КАК Описание,
	|	ИСМППрисоединенныеФайлы.Версия                             КАК Версия,
	|	НЕОПРЕДЕЛЕНО                                               КАК РеквизитыИсходящегоСообщения
	|ПОМЕСТИТЬ Сообщения
	|ИЗ
	|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ИСМППрисоединенныеФайлы КАК ИСМППрисоединенныеФайлы
	|		ПО ИСМППрисоединенныеФайлы.Документ = ВременнаяТаблицаДокументы.Ссылка
	|ГДЕ
	|	НЕ ИСМППрисоединенныеФайлы.Операция В (&АбстрактныеОперации)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОчередьСообщенийИСМП.ДатаСоздания КАК ДатаМодификацииУниверсальная,
	|	ОчередьСообщенийИСМП.Документ     КАК Документ,
	|	ОчередьСообщенийИСМП.Сообщение    КАК Ссылка,
	|	НЕОПРЕДЕЛЕНО                      КАК ТипСообщения,
	|	ОчередьСообщенийИСМП.Операция     КАК Операция,
	|	
	|	ВЫБОР КОГДА ОчередьСообщенийИСМП.ИдентификаторЗаявки = """" ТОГДА
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийИСМП.КПередаче)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиСообщенийИСМП.ЗаявкаОбрабатывается)
	|	КОНЕЦ КАК СтатусОбработки,
	|	
	|	// Версия и Описание - из реквизитов исходящего сообщения
	|	""""                                              КАК Описание,
	|	НЕОПРЕДЕЛЕНО                                      КАК Версия,
	|	ОчередьСообщенийИСМП.РеквизитыИсходящегоСообщения КАК РеквизитыИсходящегоСообщения
	|ИЗ
	|	РегистрСведений.ОчередьСообщенийИСМП КАК ОчередьСообщенийИСМП
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ПО ОчередьСообщенийИСМП.Документ = ВременнаяТаблицаДокументы.Ссылка
	|ГДЕ
	|	ОчередьСообщенийИСМП.СообщениеОснование В(&ПустоеОснование)
	|	И НЕ ОчередьСообщенийИСМП.Операция В (&АбстрактныеОперации)
	|;
	|
	|//////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка                                     КАК Документ,
	|	ЕСТЬNULL(Сообщения.Ссылка, &ПустаяСсылка)                            КАК Ссылка,
	|	ЕСТЬNULL(Сообщения.Операция, НЕОПРЕДЕЛЕНО)                           КАК Операция,
	|	ЕСТЬNULL(Сообщения.ДатаМодификацииУниверсальная, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаМодификацииУниверсальная,
	|	ЕСТЬNULL(Сообщения.Описание, """")                                   КАК Описание,
	|	ЕСТЬNULL(Сообщения.Версия, 1)                                        КАК Версия,
	|	ЕСТЬNULL(Сообщения.РеквизитыИсходящегоСообщения, НЕОПРЕДЕЛЕНО)       КАК РеквизитыИсходящегоСообщения
	|ИЗ
	|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК Сообщения
	|		ПО Сообщения.Документ = ВременнаяТаблицаДокументы.Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	Сообщения.ДатаМодификацииУниверсальная
	|ИТОГИ
	|	МАКСИМУМ(ДатаМодификацииУниверсальная)
	|ПО
	|	Документ
	|");
	
	ПустыеОснования = Новый Массив;
	ПустыеОснования.Добавить(Неопределено);
	ПустыеОснования.Добавить("");
	ПустыеОснования.Добавить(Справочники.ИСМППрисоединенныеФайлы.ПустаяСсылка());
	
	Запрос.УстановитьПараметр("ТаблицаДокументы", ТаблицаДокументы);
	Запрос.УстановитьПараметр("ПустоеОснование",  ПустыеОснования);
	Запрос.УстановитьПараметр("ПустаяСсылка",     Справочники.ИСМППрисоединенныеФайлы.ПустаяСсылка());
	
	АбстрактныеОперации = Новый Массив;
	АбстрактныеОперации.Добавить(Перечисления.ВидыОперацийИСМП.ЗаказНаЭмиссиюКодовМаркировкиРасчетСтатуса);
	АбстрактныеОперации.Добавить(Перечисления.ВидыОперацийИСМП.АгрегацияРасчетСтатуса);
	АбстрактныеОперации.Добавить(Перечисления.ВидыОперацийИСМП.ОтчетОбИспользованииРасчетСтатуса);
	АбстрактныеОперации.Добавить(Перечисления.ВидыОперацийИСМП.ОтчетОбИспользованииПроверкаСтатусаКодовМаркировки);
	Запрос.УстановитьПараметр("АбстрактныеОперации", АбстрактныеОперации);
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВыборкаПоДокументам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		ПолноеИмя = ВыборкаПоДокументам.Документ.Метаданные().ПолноеИмя();
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		ПоследовательностьОпераций = МенеджерОбъекта.ПоследовательностьОпераций(ВыборкаПоДокументам.Документ, Истина);
		
		Если ОтображатьСИерархией Тогда
			СтрокаПервогоУровня = ДеревоФайлов.ПолучитьЭлементы().Добавить();
			СтрокаПервогоУровня.Документ       = ВыборкаПоДокументам.Документ;
			СтрокаПервогоУровня.Представление  = ВыборкаПоДокументам.Документ;
			СтрокаПервогоУровня.ИндексКартинки = 5;
		Иначе
			СтрокаПервогоУровня = ДеревоФайлов;
		КонецЕсли;
		
		Операция          = Неопределено;
		ЕстьОшибка        = Ложь;
		ТребуетсяОжидание = Ложь;
		
		ВыборкаПоФайлам = ВыборкаПоДокументам.Выбрать();
		
		ТаблицаРасчетаКоличества = НоваяТаблицаРасчетаКоличестваОпераций();
		
		Пока ВыборкаПоФайлам.Следующий() Цикл
			
			Версия = Неопределено;
			Если ТипЗнч(ВыборкаПоФайлам.Ссылка) = Тип("Строка") Тогда
				Реквизиты = ВыборкаПоФайлам.РеквизитыИсходящегоСообщения.Получить();
				Если Реквизиты <> Неопределено Тогда
					Версия = Реквизиты.Версия;
				КонецЕсли;
			Иначе
				Версия = ВыборкаПоФайлам.Версия;
			КонецЕсли;
			
			НоваяСтрока            = ТаблицаРасчетаКоличества.Добавить();
			НоваяСтрока.Версия     = Версия;
			НоваяСтрока.Операция   = ВыборкаПоФайлам.Операция;
			НоваяСтрока.Ссылка     = ВыборкаПоФайлам.Ссылка;
			НоваяСтрока.Количество = 1;
			
		КонецЦикла;
		
		РассчитатьКоличествоДляПредставления(ТаблицаРасчетаКоличества);
		
		ВыборкаПоФайлам.Сбросить();
		
		Пока ВыборкаПоФайлам.Следующий() Цикл
			
			Операция = ВыборкаПоФайлам.Операция;
			
			Если НЕ ЗначениеЗаполнено(ВыборкаПоФайлам.Ссылка) Тогда
				// Если по документу еще не создано файлов
				Если ЗначениеЗаполнено(ПоследовательностьОпераций) Тогда
					Операция = ПоследовательностьОпераций[0].Операция;
				Иначе
					Операция = Неопределено;
				КонецЕсли;
			КонецЕсли;
			
			ПараметрыОтбора = Новый Структура;
			ПараметрыОтбора.Вставить("Операция", Операция);
			НайденныеСтроки = ПоследовательностьОпераций.НайтиСтроки(ПараметрыОтбора);
			Если НайденныеСтроки.Количество() = 0 Тогда
				СтрокаПоследовательности = Неопределено;
			Иначе
				СтрокаПоследовательности = НайденныеСтроки[НайденныеСтроки.Количество() - 1];
			КонецЕсли;
			
			СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
			СтрокаВторогоУровня.Документ       = ВыборкаПоФайлам.Документ;
			СтрокаВторогоУровня.Файл           = ВыборкаПоФайлам.Ссылка;
			СтрокаВторогоУровня.Операция       = Операция;
			Если ЗначениеЗаполнено(ВыборкаПоФайлам.ДатаМодификацииУниверсальная) Тогда
				СтрокаВторогоУровня.Дата = МестноеВремя(ВыборкаПоФайлам.ДатаМодификацииУниверсальная);
			КонецЕсли;

			Если ТипЗнч(ВыборкаПоФайлам.Ссылка) = Тип("Строка") Тогда
				
				РеквизитыИсходящегоСообщения = ВыборкаПоФайлам.РеквизитыИсходящегоСообщения.Получить();
				РеквизитыИсходящегоСообщения.Вставить("Ссылка", ВыборкаПоФайлам.Ссылка);
				
				СтрокаВторогоУровня.Представление = ПредставлениеОперации(
					СтрокаПоследовательности,
					ВыборкаПоФайлам.Документ,
					РеквизитыИсходящегоСообщения,
					ТаблицаРасчетаКоличества);
					
			Иначе
				СтрокаВторогоУровня.Представление  = ПредставлениеОперации(
					СтрокаПоследовательности, ВыборкаПоФайлам.Документ, ВыборкаПоФайлам, ТаблицаРасчетаКоличества);
			КонецЕсли;
			
			ЕстьОшибкаСтроки  = ЗначениеЗаполнено(ВыборкаПоФайлам.Описание);
			ТребуетсяОжидание = ТипЗнч(ВыборкаПоФайлам.Ссылка) = Тип("Строка");
			
			Если Не ТребуетсяОжидание И СтрокаПоследовательности <> Неопределено Тогда
				Для Каждого ДальнейшееДействие Из СтрокаПоследовательности.ДальнейшиеДействия Цикл
					СтрокаВторогоУровня.ДальнейшиеДействия.Добавить(ДальнейшееДействие);
				КонецЦикла;
			КонецЕсли;
			
			Если ЕстьОшибкаСтроки Тогда
				СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
				СтрокаВторогоУровня.ИндексКартинки     = 4;
				ЕстьОшибка = Истина;
			ИначеЕсли ТипЗнч(ВыборкаПоФайлам.Ссылка) = Тип("Строка") Тогда
				СтрокаВторогоУровня.ИндексКартинки = 3;
			ИначеЕсли Не ЗначениеЗаполнено(ВыборкаПоФайлам.Ссылка) Тогда
				СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
				СтрокаВторогоУровня.ИндексКартинки     = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаПоследовательности, Истина);
			Иначе
				СтрокаВторогоУровня.ИндексКартинки = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаПоследовательности);
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьОшибка Тогда
			СтрокаПоследовательности = ИнтеграцияИС.ПредыдущаяОперация(ПоследовательностьОпераций, СтрокаПоследовательности);
		КонецЕсли;
		
		Если СтрокаПоследовательности <> Неопределено Тогда
			
			Индекс = ПоследовательностьОпераций.Индекс(СтрокаПоследовательности);
			
			Для Итератор = Индекс + 1 По ПоследовательностьОпераций.Количество() - 1 Цикл
				
				СтрокаСледующаяОперация = ПоследовательностьОпераций.Получить(Итератор);
				Если СтрокаСледующаяОперация.Индекс = 0
					Или СтрокаПоследовательности.Индекс = СтрокаСледующаяОперация.Индекс Тогда
					
					СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
					СтрокаВторогоУровня.Документ           = ВыборкаПоДокументам.Документ;
					СтрокаВторогоУровня.Операция           = СтрокаСледующаяОперация.Операция;
					СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
					СтрокаВторогоУровня.Представление      = ПредставлениеОперации(СтрокаСледующаяОперация, СтрокаВторогоУровня.Документ, Неопределено);
					СтрокаВторогоУровня.ИндексКартинки     = ИнтеграцияИС.ИндексКартинкиЗапроса(СтрокаСледующаяОперация, Истина);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоФайлов()
	
	ТекстДокументаИСМП = "";
	ДеревоФайлов.ПолучитьЭлементы().Очистить();
	
	Строки = Новый Массив;
	Строки.Добавить(НСтр("ru = 'Основание:';
						|en = 'Основание:'"));
	Строки.Добавить(" ");
	Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Документ),,,,ПолучитьНавигационнуюСсылку(Документ)));
	ТекстДокумент = Новый ФорматированнаяСтрока(Строки);
	
	ТипДокумента = ТипЗнч(Документ);
	
	ЭтоДокументИСМП = Метаданные.ОпределяемыеТипы.ДокументыИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено;
	
	Если ЭтоДокументИСМП Тогда
		
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Документ:';
							|en = 'Документ:'"));
		Строки.Добавить(" ");
		Строки.Добавить(Новый ФорматированнаяСтрока(Строка(Документ),,,,ПолучитьНавигационнуюСсылку(Документ)));
		ТекстДокумент = Новый ФорматированнаяСтрока(Строки);
		
		ЗаполнитьПоДокументу(ТаблицаДокументы(Документ));
		Возврат;
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеМаркировкаТоваровИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаМаркировкаТоваровИСМП(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеЗаказНаЭмиссиюКодовМаркировкиИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаЗаказНаЭмиссиюКодовМаркировкиСУЗ(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеВыводаИзОборотаИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаВыводИзОборотаИСМП(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеСписаниеКодовМаркировкиИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаСписаниеКодовМаркировкиИСМП(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеПеремаркировкиТоваровИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаПеремаркировкаТоваровИСМП(Документ);
		
	ИначеЕсли Метаданные.ОпределяемыеТипы.ОснованиеВозвратВОборотИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаВозвратВОборотИСМП(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеОтгрузкаТоваровИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаОтгрузкаТоваровИСМП(Документ);
		
	КонецЕсли;
	
	Если Метаданные.ОпределяемыеТипы.ОснованиеПриемкаТоваровИСМП.Тип.Типы().Найти(ТипДокумента) <> Неопределено Тогда
		
		ЗаполнитьПоОснованиюДокументаПриемкаТоваровИСМП(Документ);
		
	КонецЕсли;
	
	Элементы.ИнтеграцияИСМП_ИнформацияОДокументах.Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()
	
	ИнтеграцияИСМПСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщенияОперации(ВыбраннаяСтрока)
	
	ДанныеСтроки = Элементы.ДеревоФайлов.ДанныеСтроки(ВыбраннаяСтрока);
	Если ДанныеСтроки <> Неопределено И ДанныеСтроки.ПолучитьЭлементы().Количество() = 0 Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Источник", ДанныеСтроки.Файл);
		ПараметрыФормы.Вставить("Заголовок", СтрШаблон(НСтр("ru = 'Сообщения операции: %1';
															|en = 'Сообщения операции: %1'"), ДанныеСтроки.Операция));
		
		ОткрытьФорму(
			"ОбщаяФорма.ЛогОбменаИСМП",
			ПараметрыФормы,
			ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ИнтеграцияИСКлиент.ПоказатьСообщенияОперации(ЭтотОбъект, "ИСМП", ВыбраннаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти