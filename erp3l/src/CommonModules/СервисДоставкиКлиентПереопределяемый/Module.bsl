////////////////////////////////////////////////////////////////////////////////
// Подсистема "Сервис доставки".
// ОбщийМодуль.СервисДоставкиКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Устанавливает имя формы выбора объекта, если она отличается от формы выбора по умолчанию.
//
// Параметры:
//  ИмяОбъекта - Строка - имя объекта метаданных.
//  ИмяФормыВыбора - Строка - полное имя формы выбора объекта. Например, "Документ.ЗаказПокупателя.ФормаВыбора".
//
Процедура УстановитьИмяФормыВыбораОбъектаПоИмени(ИмяОбъекта, ИмяФормыВыбора) Экспорт
	//
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании переданного объекта
// в параметре "МассивСсылок". Вызывается из подсистемы "ПодключаемыеКоманды".
//
// Параметры:
//  МассивСсылок - Массив из ЛюбаяСсылка - объект или список объектов.
//  ПараметрыВыполнения - см. ПодключаемыеКомандыКлиентСервер.ПараметрыВыполненияКоманды
//
Процедура ЗаказНаДоставкуСоздатьНаОсновании(МассивСсылок, ПараметрыВыполнения) Экспорт
	
	ПараметрыВыполненияКоманды = Новый Структура("Источник,Уникальность,Окно,НавигационнаяСсылка");
	ОписаниеКоманды = ПараметрыВыполнения.ОписаниеКоманды; // Структура
	ЗаполнитьЗначенияСвойств(ПараметрыВыполненияКоманды, ОписаниеКоманды.ДополнительныеПараметры); 
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ПараметрыВыполненияКоманды", ПараметрыВыполненияКоманды);
	
	СписокОснований = Новый СписокЗначений();
	Если ТипЗнч(МассивСсылок) = Тип("Массив")
			И МассивСсылок.Количество() > 0 Тогда
		СписокОснований.ЗагрузитьЗначения(МассивСсылок);
	Иначе
		СписокОснований.Добавить(МассивСсылок);
	КонецЕсли;
	
	ТипГрузоперевозки = 0;
	
	Если ОписаниеКоманды.Идентификатор = "СоздатьНовыйЗаказНаДоставку" Тогда
		ТипГрузоперевозки = 1;
	ИначеЕсли ОписаниеКоманды.Идентификатор = "СоздатьНовыйЗаказНаКурьерскуюДоставку" Тогда
		ТипГрузоперевозки = 2;
	КонецЕсли;
	
	Если ТипГрузоперевозки <> 0 Тогда
		ПараметрыОткрытия.Вставить("ТипГрузоперевозки", ТипГрузоперевозки);
	КонецЕсли;
	
	ПараметрыОткрытия.Вставить("ДокументыОснования", СписокОснований);
		
	СервисДоставкиКлиент.ОткрытьФормуКарточкиЗаказаНаДоставку(ПараметрыОткрытия);
	
КонецПроцедуры

// Открытие формы нового заказа на доставку, создаваемого на основании документа.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//
Процедура ОткрытьФормуНовогоЗаказаНаДоставку(Форма) Экспорт
	
	// Запись в форме объекта.
	Если Не Форма.Объект.Проведен 
		ИЛИ Форма.Модифицированность Тогда
			
		ТекстВопроса = НСтр("ru = 'Для создания заказа на доставку
			|документ будет проведен. Продолжить?';
			|en = 'The document will be posted
			|to generate devliery order. Continue?'");
		
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.ОК, НСтр("ru = 'Провести и продолжить';
													|en = 'Post and continue'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		Обработчик = Новый ОписаниеОповещения("ПродолжитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку", ЭтотОбъект, Форма);
		
		ПоказатьВопрос(Обработчик, ТекстВопроса, Кнопки);
		Возврат;
		
	КонецЕсли;
	
	ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма);
	
КонецПроцедуры

// Обработка выбора заказа на доставку из списка выбора заказов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - Форма документа.
//  ВыбранныйЗаказ - ДанныеФормыЭлементКоллекции, Неопределено - Строка списка заказов.
//  ИмяПроцедурыОбработки - Строка - Имя процедуры обработки выбора заказа в списке заказов.
//
Процедура ОбработатьРезультатВыбораЗаказаНаДоставку(Форма, ВыбранныйЗаказ, ИмяПроцедурыОбработки) Экспорт
	//
КонецПроцедуры

// Перейти к списку платежных документов.
Процедура ПерейтиКСпискуПлатежныхДокументов() Экспорт
	
	ОткрытьФорму("Документ.ОперацияПоПлатежнойКарте.ФормаСписка");
	
КонецПроцедуры

// Открывает форму текущих настроек синхронизации.
//
Процедура ОткрытьФормуНастройкиСозданиеПлатежныхДокументов() Экспорт
	
	ОткрытьФорму("РегистрСведений.НастройкиЗагрузкиНаложенныхПлатежейСервисДоставки.ФормаСписка");
	
КонецПроцедуры

#Область НаложенныеПлатежи

// Заполняет перечень типов документов-оснований, для которых можно оформить оплату доставки наложенным платежом.
//  
// Параметры:
//	КоллекцияТиповДокументов - Массив из ОписаниеТипов
Процедура ТипыОснованийДляНаложенногоПлатежа(КоллекцияТиповДокументов) Экспорт
	
	КоллекцияТиповДокументов.Добавить(Тип("ДокументСсылка.ЗаказКлиента"));
	КоллекцияТиповДокументов.Добавить(Тип("ДокументСсылка.РеализацияТоваровУслуг"));
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Параметры:
//	Ответ - КодВозвратаДиалога
//	Форма - ФормаКлиентскогоПриложения -
//
Процедура ПродолжитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Ответ, Форма) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ОчиститьСообщения();
		
		РежимЗаписи = РежимЗаписиДокумента.Проведение;
		Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписи));
		
		Если Не Форма.Объект.Проведен 
			ИЛИ Форма.Модифицированность Тогда
			Возврат; // Проведение не удалось, сообщения о причинах выводит платформа.
		КонецЕсли;
	Иначе
		Возврат;
	КонецЕсли;
	
	ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма);
	
КонецПроцедуры

// Параметры:
//	Форма - ФормаКлиентскогоПриложения:
//	*Объект - Структура - коллекция реквизитов заказа на доставку:
//	**Ссылка - ДокументСсылка, Неопределено - 
Процедура ЗавершитьВыполнениеКомандыОткрытьФормуНовогоЗаказаНаДоставку(Форма)
	
	ПараметрыОткрытия = Новый Структура();
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ПараметрыОткрытия.Вставить("ДокументОснование", Форма.Объект.Ссылка);
	КонецЕсли;
	
	СервисДоставкиКлиент.ОткрытьФормуКарточкиЗаказаНаДоставку(ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти
