//++ Устарело_Производство21
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Параметры.ЗаказНаПроизводство.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("АдресСпецификация", АдресСпецификация) Тогда
		ЗаписыватьРезультатРедактирования = Истина;
	КонецЕсли;
	
	ДанныеСтрокиЗаказа = ПолучитьДанныеСтрокиЗаказа();
	УстановитьЗаголовок(Ложь, ДанныеСтрокиЗаказа);
	
	ЗапуститьВыполнениеВФоне = Истина;
	КлючСвязиПродукция = ДанныеСтрокиЗаказа.КлючСвязиПродукция;
	
	ПараметрыОтбора = ХранилищеНастроекДанныхФорм.Загрузить("СокращениеПроизводства", "ПараметрыОтбора");
	Если ЗначениеЗаполнено(ПараметрыОтбора) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыОтбора);
	Иначе
		ПоказыватьЭтапы = Истина;
	КонецЕсли;
	
	РезультатРасчета = ПолучитьСостояниеЗаказовНаСервере();
	
	Если РезультатРасчета.ЗаданиеВыполнено Тогда
		
		АдресХранилища = РезультатРасчета.АдресХранилища;
		ЗаполнитьСостояниеЗаказовНаСервере();
		
	Иначе
		
		ИдентификаторЗадания = РезультатРасчета.ИдентификаторЗадания;
		АдресХранилища       = РезультатРасчета.АдресХранилища;
		
		ОткрытьФормуДлительнойОперацииПриОткрытии = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОткрытьФормуДлительнойОперацииПриОткрытии Тогда
		ПодключитьОбработчикОжидания("ОткрытьФормуДлительнойОперации", 0.1, Истина);
	Иначе
		РазвернутьВсе();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		Если ВыбранноеЗначение.Действие = "СократитьПроизводство" Тогда
			
			СократитьПроизводствоНаСервере(ВыбранноеЗначение.Параметры);
			РазвернутьВсе();
			
			Если ТекущийИдентификаторСтроки <> -1 Тогда
				Элементы.СостояниеЗаказов.ТекущаяСтрока = ТекущийИдентификаторСтроки;
			КонецЕсли; 
			
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Продолжить?';
									|en = 'Data was changed. Continue?'");
		
		ОповещениеСохранитьИЗакрыть = Новый ОписаниеОповещения(
			"ПередЗакрытиемВопросЗавершение", ЭтотОбъект);
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
			ОповещениеСохранитьИЗакрыть, Отказ, ЗавершениеРаботы, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ЭтаФорма.Закрыть();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПоказыватьЭтапыПриИзменении(Элемент)
	
	ЗаполнитьСостояниеЗаказов(Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура СостояниеЗаказовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СостояниеЗаказовКоличествоЗапланировано Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяСтрока = СостояниеЗаказов.НайтиПоИдентификатору(ВыбраннаяСтрока);
		
		Если ВыбраннаяСтрока.ТипСтроки = 3 Тогда
			СократитьПроизводство(ВыбраннаяСтрока.ПолучитьРодителя());
		Иначе
			СократитьПроизводство(ВыбраннаяСтрока);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьДанные(Команда)
	
	Если Модифицированность Тогда
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("КомандаОбновитьДанныеЗавершение", ЭтотОбъект), 
			НСтр("ru = 'Данные были изменены. Продолжить?';
				|en = 'Data was changed. Continue?'"), 
			РежимДиалогаВопрос.ДаНет,, 
			КодВозвратаДиалога.Нет
		);		

	Иначе
		
		ПолучитьСостояниеЗаказов();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДанныеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьСостояниеЗаказов();
	
КонецПроцедуры

&НаКлиенте
Процедура СократитьПроизводствоПоПродукции(Команда)
	
	КоллекцияСтрокПродукции = СостояниеЗаказов.ПолучитьЭлементы();
	
	Если КоллекцияСтрокПродукции.Количество() > 0 Тогда 
		
		СократитьПроизводство(КоллекцияСтрокПродукции[0]);
		
	КонецЕсли;
					
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если СохранитьИзмененияНаСервере() Тогда
		
		ПараметрыОповещения = Новый Структура;
		ПараметрыОповещения.Вставить("РежимЗаписи", РежимЗаписиДокумента.Проведение);
		
		Оповестить("Запись_ЗаказНаПроизводство", ПараметрыОповещения, Параметры.ЗаказНаПроизводство);
		
		Модифицированность = Ложь;
		
		ЭтаФорма.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	АдресВХранилище = ЗавершитьРедактированиеНаСервере();
	
	РезультатРедактирования = Новый Структура;
	РезультатРедактирования.Вставить("ВыполняемаяОперация", "СокращениеПроизводства");
	РезультатРедактирования.Вставить("АдресВХранилище", АдресВХранилище);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(РезультатРедактирования);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКонтекстнойПанелиТаблицыСостояниеЗаказов

&НаКлиенте
Процедура ПерейтиКМаршрутнымЛистамОтЭтапов(Команда)
	
	ТекущиеДанные = Элементы.СостояниеЗаказов.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено ИЛИ ТекущиеДанные.ТипСтроки <> 3 Тогда
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта.';
									|en = 'Cannot run the command for the specified object.'");
		ПоказатьПредупреждение(Неопределено, ТекстПредупреждения);
		Возврат;
	КонецЕсли;

	СписокЭтапов = ПолучитьЭтапыГрафика(ТекущиеДанные.Заказ, 
										ТекущиеДанные.КодСтрокиПродукция, 
										ТекущиеДанные.КлючСвязи);
	
	Если СписокЭтапов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НеЗагружатьОтборы", Истина);
	ПараметрыФормы.Вставить("ОтборПоСпискуЭтаповГрафика", СписокЭтапов);
	
	ОткрытьФорму("Документ.МаршрутныйЛистПроизводства.ФормаСписка", 
					ПараметрыФормы,, Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СохранениеИзмененийИЗавершитьРедактирование

&НаСервере
Функция СохранитьИзмененияНаСервере()
	
	ЗаказОбъект = Параметры.ЗаказНаПроизводство.ПолучитьОбъект();
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("Заказ", Параметры.ЗаказНаПроизводство);
	ПараметрыКоманды.Вставить("КодСтрокиПродукция", Параметры.КодСтрокиПродукция);
	ПараметрыКоманды.Вставить("КлючСвязиПродукция", КлючСвязиПродукция);
	
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("АдресСпецификация", ПланированиеПроизводства.ДанныеСпецификацииЗаказаВХранилище(
		ЗаказОбъект, КлючСвязиПродукция, УникальныйИдентификатор));
	
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ПланированиеПроизводства.УдалитьДанныеСпецификацииПоКлючу(ЗаказОбъект, КлючСвязиПродукция);
	
	РезультатРедактирования = Обработки.СокращениеПроизводства.РезультатРедактированияСтрокиСпецификацииЗаказа(ПараметрыКоманды);
	
	ЗаказОбъект.СтатусГрафикаПроизводства = Перечисления.СтатусыГрафикаПроизводстваВЗаказеНаПроизводство.ТребуетсяРассчитать;
	
	 // Запись изменений в табличную часть Продукция.
	ДанныеПродукции = ЗаказОбъект.Продукция.Найти(РезультатРедактирования.СтруктураПродукции.КлючСвязи, "КлючСвязи");
	
	ЗаполнитьЗначенияСвойств(ДанныеПродукции, РезультатРедактирования.СтруктураПродукции, "Упаковка, КоличествоУпаковок, Количество, ДатаПотребности,
		|НачатьНеРанее, РазмещениеВыпуска, Склад, Назначение, ЕстьСоответствиеСтандартнойСпецификации");
	ДанныеПродукции.ГрафикРассчитан = Ложь;
	
	ПараметрыРедактированияМатериалов = Обработки.ВводКорректировкиЗаказаМатериалов.ПараметрыРедактированияМатериалов(УникальныйИдентификатор);
	
	// Запись изменений в табличную часть Этапы.
	Для Каждого Строка Из РезультатРедактирования.Этапы Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.Этапы.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВыходныеИзделия.
	Для Каждого Строка Из РезультатРедактирования.ВыходныеИзделия Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВыходныеИзделия.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВозвратныеОтходы.
	Для Каждого Строка Из РезультатРедактирования.ВозвратныеОтходы Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВозвратныеОтходы.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть МатериалыИУслуги.
	Для Каждого Строка Из РезультатРедактирования.МатериалыИУслуги Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.МатериалыИУслуги.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть Трудозатраты.
	Для Каждого Строка Из РезультатРедактирования.Трудозатраты Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.Трудозатраты.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ВидыРабочихЦентров.
	Для Каждого Строка Из РезультатРедактирования.ВидыРабочихЦентров Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ВидыРабочихЦентров.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть АльтернативныеВидыРабочихЦентров.
	Для Каждого Строка Из РезультатРедактирования.АльтернативныеВидыРабочихЦентров Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.АльтернативныеВидыРабочихЦентров.Добавить(), Строка);
	КонецЦикла;
	
	// Запись изменений в табличную часть ЭтапыВосстановленияБрака.
	Для Каждого Строка Из РезультатРедактирования.ЭтапыВосстановленияБрака Цикл
		ЗаполнитьЗначенияСвойств(ЗаказОбъект.ЭтапыВосстановленияБрака.Добавить(), Строка);
	КонецЦикла;
	
	НачатьТранзакцию();
	
	Попытка
		
		Обработки.ВводКорректировкиЗаказаМатериалов.СохранитьКорректировкиЗаказаМатериаловПоЗаказуНаПроизводство(ЗаказОбъект, 
			ПараметрыРедактированияМатериалов, РезультатРедактирования.КорректировкиЗаказаМатериалов);
			
		ЗаказОбъект.ИнициализироватьПараметрыАктуализацииМаршрутныхЛистов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Параметры.КодСтрокиПродукция));
		
		ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ЗавершитьРедактированиеНаСервере()
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("Заказ", Параметры.ЗаказНаПроизводство);
	ПараметрыКоманды.Вставить("КодСтрокиПродукция", Параметры.КодСтрокиПродукция);
	ПараметрыКоманды.Вставить("КлючСвязиПродукция", КлючСвязиПродукция);
	
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("АдресСпецификация", АдресСпецификация);
	
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	РезультатРедактирования = Обработки.СокращениеПроизводства.РезультатРедактированияСтрокиСпецификацииЗаказа(ПараметрыКоманды);
	
	Возврат ПоместитьВоВременноеХранилище(РезультатРедактирования, УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти

#Область ЗаполнениеДанных

&НаКлиенте
Процедура ПолучитьСостояниеЗаказов()
	
	РезультатРасчета = ПолучитьСостояниеЗаказовНаСервере();
	
	Если РезультатРасчета.ЗаданиеВыполнено Тогда
		
		АдресХранилища = РезультатРасчета.АдресХранилища;
		ЗаполнитьСостояниеЗаказов();
		
	Иначе
		
		ИдентификаторЗадания = РезультатРасчета.ИдентификаторЗадания;
		АдресХранилища       = РезультатРасчета.АдресХранилища;
		
		ОткрытьФормуДлительнойОперации();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСостояниеЗаказовНаСервере()
	
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.Добавить(Параметры.ЗаказНаПроизводство);
	
	СписокКодовСтрокПродукции = Новый СписокЗначений;
	СписокКодовСтрокПродукции.Добавить(Параметры.КодСтрокиПродукция);
	
	ПараметрыЗадания = Новый Структура;
	
	ПараметрыЗадания.Вставить("СписокЗаказов", СписокЗаказов);
	ПараметрыЗадания.Вставить("СписокКодовСтрокПродукции", СписокКодовСтрокПродукции);
	
	ПараметрыЗадания.Вставить("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	
	Если ЗапуститьВыполнениеВФоне Тогда
		
		НаименованиеЗадания = НСтр("ru = 'Получение состояния выполнения заказов на производство';
									|en = 'Receiving production order state'");
		РезультатРасчета = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
							УникальныйИдентификатор,
							"Обработки.СокращениеПроизводства.СостояниеЗаказовНаПроизводство",
							ПараметрыЗадания,
							НаименованиеЗадания);
							
	Иначе
	
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.СокращениеПроизводства.СостояниеЗаказовНаПроизводство(ПараметрыЗадания, АдресХранилища);
		
		РезультатРасчета = Новый Структура;
		РезультатРасчета.Вставить("АдресХранилища",   АдресХранилища);
		РезультатРасчета.Вставить("ЗаданиеВыполнено", Истина);
		
	КонецЕсли; 
	
	Возврат РезультатРасчета;

КонецФункции

&НаКлиенте
Процедура ЗаполнитьСостояниеЗаказов(СохранитьПараметрыОтбора = Ложь)

	ЗаполнитьСостояниеЗаказовНаСервере(СохранитьПараметрыОтбора);
	РазвернутьВсе();

	Если ТекущийИдентификаторСтроки <> -1 Тогда
		Элементы.СостояниеЗаказов.ТекущаяСтрока = ТекущийИдентификаторСтроки;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСостояниеЗаказовНаСервере(СохранитьПараметрыОтбора = Ложь)

	Если СохранитьПараметрыОтбора Тогда
		СохранитьПараметрыОтбора();
	КонецЕсли;
	
	ПустойКлюч = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");	
	
	// Запомним текущую строку чтобы потом ее восстановить
	ТекущийИдентификаторСтроки = -1;
	ТекущийЗаказ = Документы.ЗаказНаПроизводство.ПустаяСсылка();
	ТекущийКлючСвязиПродукция = ПустойКлюч;
	ТекущийКлючСвязиПолуфабрикат = ПустойКлюч;
	ТекущийКлючСвязи = ПустойКлюч;
	
	ТекущаяСтрока = Элементы.СостояниеЗаказов.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ДанныеСтроки = СостояниеЗаказов.НайтиПоИдентификатору(ТекущаяСтрока);
		Если ДанныеСтроки <> Неопределено Тогда
			ТекущийЗаказ = ДанныеСтроки.Заказ;
			ТекущийКлючСвязиПродукция = ДанныеСтроки.КлючСвязиПродукция;
			ТекущийКлючСвязиПолуфабрикат = ДанныеСтроки.КлючСвязиПолуфабрикат;
			ТекущийКлючСвязи = ДанныеСтроки.КлючСвязи;
		КонецЕсли;
	КонецЕсли;
	
	// Сформируем дерево состояния заказов
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("ПоказыватьЭтапы", ПоказыватьЭтапы);
	
	СостояниеЗаказовДерево = Обработки.СокращениеПроизводства.ПостроитьДеревоСостояниеЗаказовНаПроизводство(ПараметрыКоманды);
	ЗначениеВРеквизитФормы(СостояниеЗаказовДерево, "СостояниеЗаказов");
	
	// Восстановим текущую строку
	Если НЕ ТекущийЗаказ.Пустая() Тогда
		НайтиТекущуюСтроку(СостояниеЗаказов.ПолучитьЭлементы());
	КонецЕсли;
	
	УстановитьЗаголовок();
	УстановитьДоступностьЭлементовФормы();

	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
 
	Попытка
		
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				
				ЗаполнитьСостояниеЗаказов();
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
				
			Иначе
				
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
					
			КонецЕсли;
				
		КонецЕсли;
		
	Исключение
		
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуДлительнойОперации()

	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	
	ПараметрыОбработчикаОжидания.КоэффициентУвеличенияИнтервала = 1;
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);

КонецПроцедуры

&НаСервере
Процедура СократитьПроизводствоНаСервере(ПараметрыСокращения)

	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("АдресХранилища", АдресХранилища);
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	
	ПараметрыКоманды.Вставить("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	ПараметрыКоманды.Вставить("ПоказыватьЭтапы", ПоказыватьЭтапы);
	
	ПараметрыКоманды.Вставить("ПараметрыСокращения", ПараметрыСокращения);

	АдресХранилища = Обработки.СокращениеПроизводства.СократитьПроизводство(ПараметрыКоманды);

	ЗаполнитьСостояниеЗаказовНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	#Область ВыделитьЖирнымПродукцию
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,, Истина));
	#КонецОбласти
		
	#Область ВыделитьСветлосерым
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеЗаказов.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.СтатусВыполнения");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 1;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СерыйЦветТекста1);
	#КонецОбласти
		
	#Область ВыделитьКраснымТекст
		
	// Излишки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеЗаказовКоличествоИзлишек.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.КоличествоИзлишек");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.ТипСтроки");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 3;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	
	// Выполняется
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеЗаказовКоличествоВыполняется.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.КоличествоВыполняется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.КоличествоОсталось");

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОсобогоТекста);
	#КонецОбласти
	
	#Область СкрытьДефицитЕслиЭтапыВыполнены
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СостояниеЗаказовКоличествоВыполняется.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеЗаказов.ПоказыватьВыполняется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "");

	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура НайтиТекущуюСтроку(КоллекцияСтрока)

	Для Каждого ДанныеСтроки Из КоллекцияСтрока Цикл
		
		Если ДанныеСтроки.Заказ = ТекущийЗаказ
			И ДанныеСтроки.КлючСвязиПродукция = ТекущийКлючСвязиПродукция
			И ДанныеСтроки.КлючСвязиПолуфабрикат = ТекущийКлючСвязиПолуфабрикат
			И ДанныеСтроки.КлючСвязи = ТекущийКлючСвязи Тогда
			
			ТекущийИдентификаторСтроки = ДанныеСтроки.ПолучитьИдентификатор();
			Возврат;
			
		Иначе
			
			НайтиТекущуюСтроку(ДанныеСтроки.ПолучитьЭлементы());
			
			Если ТекущийИдентификаторСтроки <> -1 Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе()

	СтрокиЗаказов = СостояниеЗаказов.ПолучитьЭлементы();
	Для каждого СтрокаЗаказа Из СтрокиЗаказов Цикл
		Элементы.СостояниеЗаказов.Развернуть(СтрокаЗаказа.ПолучитьИдентификатор(), Истина);
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыОтбора()

	ХранилищеНастроекДанныхФорм.Сохранить(
		"СокращениеПроизводства", 
		"ПараметрыОтбора", 
		Новый Структура("ПоказыватьЭтапы", ПоказыватьЭтапы));

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок(ОбновитьЗаголовок = Истина, Знач ДанныеСтрокиЗаказа = Неопределено)
	
	Если ДанныеСтрокиЗаказа = Неопределено Тогда 
		ДанныеСтрокиЗаказа = ПолучитьДанныеСтрокиЗаказа();
	КонецЕсли;
	
	ТекстЗаголовок = НСтр("ru = 'Сокращение производства по заказу %1';
							|en = 'Production decrease against order %1'");
	ТекстДополнение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = '№ %1 от %2 (строка %3)';
											|en = 'No. %1 from %2 (line %3)'"),
										?(ЗначениеЗаполнено(ДанныеСтрокиЗаказа.Номер), " " + ДанныеСтрокиЗаказа.Номер, ""),
										Формат(ДанныеСтрокиЗаказа.Дата, "ДЛФ=D"),
										ДанныеСтрокиЗаказа.НомерСтроки);
	
	Если ОбновитьЗаголовок И ПолучитьДанныеПоПродукции().ГрафикРассчитан = Ложь Тогда 

		ТекстДополнение = ТекстДополнение + " " + НСтр("ru = 'невозможно';
														|en = 'cannot'");
		
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовок, ТекстДополнение);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементовФормы()
	
	ГрафикРассчитан = ПолучитьДанныеПоПродукции().ГрафикРассчитан;
	
	Элементы.ГруппаОтборыИКомандыФормы.Доступность 	= ГрафикРассчитан;
	
	Элементы.СохранитьИзменения.Видимость = ГрафикРассчитан И ЗаписыватьРезультатРедактирования;
	Элементы.СохранитьИзменения.КнопкаПоУмолчанию = ГрафикРассчитан И ЗаписыватьРезультатРедактирования;
	
	Элементы.ЗавершитьРедактирование.Видимость = ГрафикРассчитан И НЕ ЗаписыватьРезультатРедактирования;
	Элементы.ЗавершитьРедактирование.КнопкаПоУмолчанию = ГрафикРассчитан И НЕ ЗаписыватьРезультатРедактирования;
		
	Элементы.ФормаЗакрыть.Видимость = НЕ ГрафикРассчитан;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = НЕ ГрафикРассчитан;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеСтрокиЗаказа()
	
	Результат = Новый Структура("Номер, Дата, НомерСтроки, КлючСвязиПродукция");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗаказНаПроизводствоПродукция.Ссылка.Номер КАК Номер,
	|	ЗаказНаПроизводствоПродукция.Ссылка.Дата КАК Дата,
	|	ЗаказНаПроизводствоПродукция.НомерСтроки КАК НомерСтроки,
	|	ЗаказНаПроизводствоПродукция.КлючСвязи КАК КлючСвязиПродукция
	|ИЗ
	|	Документ.ЗаказНаПроизводство.Продукция КАК ЗаказНаПроизводствоПродукция
	|ГДЕ
	|	ЗаказНаПроизводствоПродукция.Ссылка = &ЗаказНаПроизводство
	|	И ЗаказНаПроизводствоПродукция.КодСтроки = &КодСтрокиПродукция";
	
	Запрос.УстановитьПараметр("ЗаказНаПроизводство", Параметры.ЗаказНаПроизводство);
	Запрос.УстановитьПараметр("КодСтрокиПродукция",  Параметры.КодСтрокиПродукция);
	
	ДанныеСтрокиЗаказа = Запрос.Выполнить().Выбрать();
	ДанныеСтрокиЗаказа.Следующий();

	ЗаполнитьЗначенияСвойств(Результат, ДанныеСтрокиЗаказа);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьДанныеПоПродукции()
	
	Результат = Новый Структура;

	Результат.Вставить("КлючСвязиПродукция");
	Результат.Вставить("КлючСвязиПолуфабрикат");
	Результат.Вставить("КлючСвязи");
	
	Результат.Вставить("ГрафикРассчитан", Ложь);
	Результат.Вставить("КоличествоВыполняетсяСУчетомПолуфабрикатов", 0);
	
	КоллекцияСтрокПродукции = СостояниеЗаказов.ПолучитьЭлементы();
	
	Если КоллекцияСтрокПродукции.Количество() > 0 Тогда 
		
		ЗаполнитьЗначенияСвойств(Результат, КоллекцияСтрокПродукции[0]);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЭтапыГрафика(Заказ, КодСтрокиПродукция, КлючСвязиЭтапы)
	
	СписокЭтапов = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Т.КодСтроки КАК КодСтроки
		|ИЗ
		|	Документ.ЗаказНаПроизводство.ЭтапыГрафик КАК Т
		|ГДЕ
		|	Т.Ссылка = &Ссылка
		|	И Т.КлючСвязиЭтапы = &КлючСвязиЭтапы");
		
	Запрос.УстановитьПараметр("Ссылка", Заказ);
	Запрос.УстановитьПараметр("КлючСвязиЭтапы", КлючСвязиЭтапы);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
		
			ДанныеЭтапа = Новый Структура;
			ДанныеЭтапа.Вставить("Заказ",                Заказ);
			ДанныеЭтапа.Вставить("КодСтрокиПродукция",   КодСтрокиПродукция);
			ДанныеЭтапа.Вставить("КодСтрокиЭтапыГрафик", Выборка.КодСтроки);
			
			СписокЭтапов.Добавить(ДанныеЭтапа);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат СписокЭтапов;
	
КонецФункции

&НаКлиенте
Процедура СократитьПроизводство(ВыбраннаяСтрока)
	
	Если НЕ ВыбраннаяСтрока.ГрафикРассчитан Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'График производства не рассчитан.';
										|en = 'Production schedule is not calculated.'"));
		Возврат;
		
	ИначеЕсли ВыбраннаяСтрока.КоличествоПоЗаказу = 0
		ИЛИ ВыбраннаяСтрока.КоличествоПоЗаказу = ВыбраннаяСтрока.КоличествоВыполнено + ВыбраннаяСтрока.КоличествоВыполняется
		ИЛИ (ВыбраннаяСтрока.ТипСтроки = 2 И ВыбраннаяСтрока.КоличествоОсталось = (ВыбраннаяСтрока.КоличествоТребуется - ВыбраннаяСтрока.КоличествоВыполнено)
			И ВыбраннаяСтрока.КоличествоЗапланировано - ВыбраннаяСтрока.КоличествоПоЗаказу = 0) Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Сократить производство на данном этапе невозможно.';
										|en = 'Cannot decrease production at this stage.'"));
		Возврат;
		
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("Заголовок", Заголовок);
	ЗначенияЗаполнения.Вставить("АдресДанных", АдресХранилища);
	ЗначенияЗаполнения.Вставить("СтруктураПоиска", Новый Структура);
	ЗначенияЗаполнения.Вставить("Показатели", Новый Структура);
	
	ЗначенияЗаполнения.СтруктураПоиска.Вставить("Заказ", ВыбраннаяСтрока.Заказ);
	ЗначенияЗаполнения.СтруктураПоиска.Вставить("КлючСвязиПродукция", ВыбраннаяСтрока.КлючСвязиПродукция);
	ЗначенияЗаполнения.СтруктураПоиска.Вставить("КлючСвязиПолуфабрикат", ВыбраннаяСтрока.КлючСвязиПолуфабрикат);
	
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоПоЗаказу", ВыбраннаяСтрока.КоличествоПоЗаказу);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоЗапланировано", ВыбраннаяСтрока.КоличествоЗапланировано);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоВыполнено", ВыбраннаяСтрока.КоличествоВыполнено);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоВыполняется", ВыбраннаяСтрока.КоличествоВыполняется);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоВыполняетсяСУчетомПолуфабрикатов", ВыбраннаяСтрока.КоличествоВыполняетсяСУчетомПолуфабрикатов);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоТребуется", ВыбраннаяСтрока.КоличествоТребуется);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоОсталось", ВыбраннаяСтрока.КоличествоОсталось);
	ЗначенияЗаполнения.Показатели.Вставить("КоличествоИзлишек", ВыбраннаяСтрока.КоличествоИзлишек);
	
	ОткрытьФорму("Обработка.СокращениеПроизводства.Форма.ФормаВыбораСпособаСокращения", 
		Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения), 
		ЭтаФорма);
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти
//-- Устарело_Производство21