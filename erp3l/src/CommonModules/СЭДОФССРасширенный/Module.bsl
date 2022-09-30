#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ОбщегоНазначенияПереопределяемый.ЗаполнитьТаблицуПереименованияОбъектовМетаданных.
Процедура ЗаполнитьТаблицуПереименованияОбъектовМетаданных(Итог) Экспорт
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.1.17.8",
		"Роль.ДобавлениеИзменениеСообщенийСЭДОФСС",
		"Роль.ДобавлениеИзменениеУведомленийОбЭЛН",
		"ЗарплатаКадрыРасширенная");
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.1.17.8",
		"Роль.ЧтениеСообщенийСЭДОФСС",
		"Роль.ЧтениеУведомленийОбЭЛН",
		"ЗарплатаКадрыРасширенная");
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.1.17.8",
		"Роль.ДобавлениеИзменениеНастроекСЭДОФСС",
		"Роль.ДобавлениеИзменениеНастроекПолученияУведомленийОбЭЛН",
		"ЗарплатаКадрыРасширенная");
	
	ОбщегоНазначения.ДобавитьПереименование(
		Итог,
		"3.1.17.8",
		"Роль.ЧтениеНастроекСЭДОФСС",
		"Роль.ЧтениеНастроекПолученияУведомленийОбЭЛН",
		"ЗарплатаКадрыРасширенная");
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Регистрирует обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - См. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления().
//
Процедура ПриРегистрацииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия          = "3.1.17.2";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("c3688bc8-c767-11ea-80e3-4cedfb43b11a");
	Обработчик.Процедура       = "СЭДОФССРасширенный.АдаптацияКУчетуВРазрезеСтрахователей";
	Обработчик.Комментарий     = НСтр("ru = 'СЭДО ФСС: Заполнение сведений в разрезе страхователей.';
										|en = 'SSF EDI: Filling in information broken down by insurants.'");
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Определяет объекты, в которых есть процедура ДобавитьКомандыПечати().
// Подробнее см. УправлениеПечатьюПереопределяемый.
//
// Параметры:
//  СписокОбъектов - Массив - список менеджеров объектов.
//
Процедура ПриОпределенииОбъектовСКомандамиПечати(СписокОбъектов) Экспорт
	СписокОбъектов.Добавить(Документы.ОтзывСогласияНаУведомлениеОбЭЛН);
	СписокОбъектов.Добавить(Документы.СогласиеНаУведомлениеОбЭЛН);
КонецПроцедуры

#КонецОбласти

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "c89ccf93-44cb-11ea-80d5-4cedfb43b11a", Метаданные.Документы.СогласиеНаУведомлениеОбЭЛН);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "48bc606b-8a2a-11ea-80e1-4cedfb43b11a", Метаданные.Документы.ОтзывСогласияНаУведомлениеОбЭЛН);
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриОпределенииОбработчиковТекущихДел(Обработчики) Экспорт
	Если Не ИспользоватьПроактивныеВыплаты() Тогда
		Обработчики.Добавить(РегистрыСведений.СогласияНаУведомленияОбЭЛН);
	КонецЕсли;
	Обработчики.Добавить(РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН);
КонецПроцедуры

#КонецОбласти

#Область РегламентированнаяОтчетность

// См. ЭлектронныйДокументооборотСФССПереопределяемый.ПослеЗагрузкиУведомленийОНовыхСообщенияхСЭДО.
Процедура ПослеЗагрузкиУведомленийОНовыхСообщенияхСЭДО(Страхователь, Уведомления, ОбработанныеУведомления) Экспорт
	
	Для Каждого Уведомление Из Уведомления Цикл
		
		ТипСообщения = Число(Уведомление.Тип);
		
		Если ТипСообщения = 5 Тогда
			// Сообщение об изменении состояния ЭЛН.
			РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ПриЗагрузкеУведомленияОНовомСообщении(
				Страхователь,
				Уведомление.Идентификатор);
			ОбработанныеУведомления.Добавить(Уведомление);
		ИначеЕсли ТипСообщения = 111 Тогда
			// Уведомление об изменении ЭЛН.
			РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ЗагрузитьУведомлениеОНаличииСообщения111(
				Страхователь,
				Уведомление.Идентификатор);
			ОбработанныеУведомления.Добавить(Уведомление);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// См. ЭлектронныйДокументооборотСФССПереопределяемый.ПослеРасшифровкиСообщенияСЭДО.
Процедура ПослеРасшифровкиСообщенияСЭДО(Страхователь, Сообщение, Результат) Экспорт
	
	ТипСообщения = Число(Сообщение.Тип);
	
	Если ТипСообщения = 5 Тогда
		// Сообщение об изменении состояния ЭЛН.
		РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ПослеРасшифровкиСообщенияОбИзмененииСостоянияЭЛН(
			Страхователь,
			Сообщение.Идентификатор,
			Сообщение.ТекстСообщения,
			Результат);
	ИначеЕсли ТипСообщения = 13 Тогда
		// Сообщение о подписке страхователя на уведомления из изменении состояний ЭЛН.
		РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.ПослеРасшифровкиСообщенияОбИзмененииПодписки(
			Страхователь,
			Сообщение.Идентификатор,
			Сообщение.ТекстСообщения,
			Результат);
	ИначеЕсли ТипСообщения = 111 Тогда
		// Уведомление об изменении ЭЛН.
		РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ЗагрузитьСообщение111(
			Страхователь,
			Сообщение.Идентификатор,
			Сообщение.ТекстСообщения,
			Результат);
	КонецЕсли;
	
КонецПроцедуры

// См. ЭлектронныйДокументооборотСФССПереопределяемый.ПослеПолученияОшибокЛогическогоКонтроляСЭДО.
Процедура ПослеПолученияОшибокЛогическогоКонтроляСЭДО(Страхователь, ИсходноеСообщение, ТекстОшибки, Результат) Экспорт
	
	// Ошибки логического контроля приходят только для исходящих сообщений.
	ТипСообщения = Число(ИсходноеСообщение.Тип);
	
	Если ТипСообщения = 3 Тогда
		// Согласие физического лица на уведомление страхователя об изменении состояния ЭЛН по основному месту работы.
		РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.ПослеПолученияОшибокСообщенияОбИзмененииПодпискиФизическогоЛица(
			Страхователь,
			ИсходноеСообщение.Идентификатор,
			ТекстОшибки,
			Результат);
	ИначеЕсли ТипСообщения = 7 Тогда
		// Согласие страхователя на получение уведомлений об изменении состояния ЭЛН работников.
		РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.ПослеПолученияОшибокСообщенияОбИзмененииПодпискиСтрахователя(
			Страхователь,
			ТекстОшибки,
			Результат);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.СогласиеНаУведомлениеОбЭЛН, Истина);
	Списки.Вставить(Метаданные.Документы.ОтзывСогласияНаУведомлениеОбЭЛН, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.НастройкиПолученияУведомленийОбЭЛН, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.ПодпискиНаУведомленияОбЭЛН, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН, Истина);
	Списки.Вставить(Метаданные.Справочники.СогласиеНаУведомлениеОбЭЛНПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Справочники.ОтзывСогласияНаУведомлениеОбЭЛНПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных.
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	Описание = Описание + "
	|Документ.ОтзывСогласияНаУведомлениеОбЭЛН.Чтение.ГруппыФизическихЛиц
	|Документ.ОтзывСогласияНаУведомлениеОбЭЛН.Чтение.Организации
	|Документ.ОтзывСогласияНаУведомлениеОбЭЛН.Изменение.ГруппыФизическихЛиц
	|Документ.ОтзывСогласияНаУведомлениеОбЭЛН.Изменение.Организации
	|Документ.СогласиеНаУведомлениеОбЭЛН.Чтение.ГруппыФизическихЛиц
	|Документ.СогласиеНаУведомлениеОбЭЛН.Чтение.Организации
	|Документ.СогласиеНаУведомлениеОбЭЛН.Изменение.ГруппыФизическихЛиц
	|Документ.СогласиеНаУведомлениеОбЭЛН.Изменение.Организации
	|РегистрСведений.НастройкиПолученияУведомленийОбЭЛН.Чтение.Организации
	|РегистрСведений.НастройкиПолученияУведомленийОбЭЛН.Изменение.Организации
	|РегистрСведений.ПодпискиНаУведомленияОбЭЛН.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.ПодпискиНаУведомленияОбЭЛН.Чтение.Организации
	|РегистрСведений.ПодпискиНаУведомленияОбЭЛН.Изменение.Организации
	|РегистрСведений.ПодпискиНаУведомленияОбЭЛН.Изменение.ГруппыФизическихЛиц
	|РегистрСведений.СогласияНаУведомленияОбЭЛН.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.СогласияНаУведомленияОбЭЛН.Чтение.Организации
	|РегистрСведений.СогласияНаУведомленияОбЭЛН.Изменение.ГруппыФизическихЛиц
	|РегистрСведений.СогласияНаУведомленияОбЭЛН.Изменение.Организации
	|РегистрСведений.СообщенияФССОбИзмененииСостоянийЭЛН.Чтение.ГруппыФизическихЛиц
	|РегистрСведений.СообщенияФССОбИзмененииСостоянийЭЛН.Чтение.Организации
	|РегистрСведений.СообщенияФССОбИзмененииСостоянийЭЛН.Изменение.ГруппыФизическихЛиц
	|РегистрСведений.СообщенияФССОбИзмененииСостоянийЭЛН.Изменение.Организации
	|Справочник.ОтзывСогласияНаУведомлениеОбЭЛНПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.ОтзывСогласияНаУведомлениеОбЭЛНПрисоединенныеФайлы.Чтение.Организации
	|Справочник.ОтзывСогласияНаУведомлениеОбЭЛНПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.ОтзывСогласияНаУведомлениеОбЭЛНПрисоединенныеФайлы.Изменение.Организации
	|Справочник.СогласиеНаУведомлениеОбЭЛНПрисоединенныеФайлы.Чтение.ГруппыФизическихЛиц
	|Справочник.СогласиеНаУведомлениеОбЭЛНПрисоединенныеФайлы.Чтение.Организации
	|Справочник.СогласиеНаУведомлениеОбЭЛНПрисоединенныеФайлы.Изменение.ГруппыФизическихЛиц
	|Справочник.СогласиеНаУведомлениеОбЭЛНПрисоединенныеФайлы.Изменение.Организации";
	
КонецПроцедуры

#КонецОбласти

#Область ДатыЗапретаИзменения

// См. ДатыЗапретаИзмененияПереопределяемый.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		Метаданные.Документы.ОтзывСогласияНаУведомлениеОбЭЛН.ПолноеИмя(),
		"Дата",
		"ОбработкаПерсональныхДанных");
	
	ДатыЗапретаИзменения.ДобавитьСтроку(
		ИсточникиДанных,
		Метаданные.Документы.СогласиеНаУведомлениеОбЭЛН.ПолноеИмя(),
		"Дата",
		"ОбработкаПерсональныхДанных");
	
КонецПроцедуры

#КонецОбласти

#Область ЗащитаПерсональныхДанных

// См. ЗащитаПерсональныхДанныхПереопределяемый.ЗаполнитьСведенияОПерсональныхДанных.
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "Документ.СогласиеНаУведомлениеОбЭЛН";
	НовыеСведения.ПоляРегистрации = "Сотрудник,ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "ФИОСотрудника,АдресСотрудника,ПаспортСотрудника,Дата,СотрудникПодписалСогласие";
	НовыеСведения.ОбластьДанных   = "ОбработкаПерсональныхДанных";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "РегистрСведений.СогласияНаУведомленияОбЭЛН";
	НовыеСведения.ПоляРегистрации = "Сотрудник,ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Подписано,ДатаСогласия,ДатаОтзываСогласия,Состояние,ОснованиеОтзываСогласия";
	НовыеСведения.ОбластьДанных   = "ОбработкаПерсональныхДанных";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "РегистрСведений.ПодпискиНаУведомленияОбЭЛН";
	НовыеСведения.ПоляРегистрации = "ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "Действует,ДатаОтправки,БудетДействовать";
	НовыеСведения.ОбластьДанных   = "ОбработкаПерсональныхДанных";
	
	НовыеСведения = ТаблицаСведений.Добавить();
	НовыеСведения.Объект          = "РегистрСведений.СообщенияФССОбИзмененииСостоянийЭЛН";
	НовыеСведения.ПоляРегистрации = "СНИЛС,ФизическоеЛицо";
	НовыеСведения.ПоляДоступа     = "НомерЛН,СостояниеЭЛН";
	НовыеСведения.ОбластьДанных   = "СостояниеЗдоровья";
	
КонецПроцедуры

#КонецОбласти

#Область ПрефиксацияОбъектов

// См. ПрефиксацияОбъектовПереопределяемый.ПолучитьПрефиксообразующиеРеквизиты.
Процедура ПолучитьПрефиксообразующиеРеквизиты(Объекты) Экспорт
	
	СтрокаТаблицы = Объекты.Добавить();
	СтрокаТаблицы.Объект = Метаданные.Документы.СогласиеНаУведомлениеОбЭЛН;
	СтрокаТаблицы.Реквизит = "Страхователь";
	
	СтрокаТаблицы = Объекты.Добавить();
	СтрокаТаблицы.Объект = Метаданные.Документы.ОтзывСогласияНаУведомлениеОбЭЛН;
	СтрокаТаблицы.Реквизит = "Страхователь";
	
КонецПроцедуры

#КонецОбласти

#Область ПодпискиНаЭЛН

// Обновляет видимость группы и надписи, напоминающей пользователю о необходимости отключения подписки на ЭЛН.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма с группой "ГруппаНапоминаниеОбОтключенииПодпискиНаЭЛН".
//   ПараметрыОбновленияФормы - Структура - Данные формы.
//   ПараметрыПособий - Структура - Кэш формы в части пособий.
//
Процедура ОбновитьНапоминаниеОбОтключенииПодписокНаЭЛН(Форма, ПараметрыОбновленияФормы, ПараметрыПособий) Экспорт
	Если ИспользоватьПроактивныеВыплаты() Тогда
		Возврат;
	КонецЕсли;
	Группа = Форма.Элементы.Найти("ГруппаНапоминаниеОбОтключенииПодпискиНаЭЛН");
	Если Группа = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не ПараметрыПособий.Свойство("ДоступенОбменЧерезСЭДО") Тогда
		ПараметрыПособий.Вставить("ДоступенОбменЧерезСЭДО", ДоступенОбменЧерезСЭДО());
	КонецЕсли;
	Если Не ПараметрыПособий.ДоступенОбменЧерезСЭДО Тогда
		Группа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	РежимВыбора = ОбщегоНазначенияБЗК.ЗначениеСвойства(Форма.Элементы, "Список.РежимВыбора");
	Если РежимВыбора = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыОбновленияФормы.Организация <> Неопределено
		И ПараметрыОбновленияФормы.Сотрудники <> Неопределено
		И ПараметрыОбновленияФормы.ДатаУвольнения <> Неопределено Тогда
		
		ОбновитьНапоминаниеВУвольнении(Форма, Группа, ПараметрыОбновленияФормы);
		
	Иначе
		
		ОбновитьОбщееНапоминание(Форма, Группа, ПараметрыПособий);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ДокументБольничныйЛист

Процедура ПриЗаписиДокументаБольничныйЛист(БольничныйОбъект, Отказ) Экспорт
	
	Попытка
		РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ОбновитьВторичныеДанные(
			БольничныйОбъект.Организация,
			БольничныйОбъект.НомерЛисткаНетрудоспособности);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		УчетПособийСоциальногоСтрахования.СообщитьОКритичнойОшибкеОбработчикаСобытия(
			"РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН.ОбновитьВторичныеДанные",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			БольничныйОбъект.Ссылка);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПриЗаписиОтпускаПоУходуЗаРебенком(ОтпускПоУходуОбъект, Отказ) Экспорт
	
	Попытка
		Документы.ИзвещениеФСС.ПриЗаписиПервичногоДокумента(ОтпускПоУходуОбъект, Отказ);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		УчетПособийСоциальногоСтрахования.СообщитьОКритичнойОшибкеОбработчикаСобытия(
			"Документы.ИзвещениеФСС.ПриЗаписиПервичногоДокумента",
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
			ОтпускПоУходуОбъект.Ссылка);
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

Процедура АдаптацияКУчетуВРазрезеСтрахователей(ПараметрыОбновления = Неопределено) Экспорт
	
	ОбработкаЗавершена = Истина;
	
	РегистрыСведений.УдалитьПодпискиНаУведомленияОбЭЛН.АдаптацияКУчетуВРазрезеСтрахователей();
	РегистрыСведений.УдалитьСогласияНаУведомленияОбЭЛН.АдаптацияКУчетуВРазрезеСтрахователей();
	Документы.СогласиеНаУведомлениеОбЭЛН.АдаптацияКУчетуВРазрезеСтрахователей(ПараметрыОбновления, ОбработкаЗавершена);
	Документы.ОтзывСогласияНаУведомлениеОбЭЛН.АдаптацияКУчетуВРазрезеСтрахователей(ПараметрыОбновления, ОбработкаЗавершена);
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(
		ПараметрыОбновления,
		"ОбработкаЗавершена",
		ОбработкаЗавершена);
	
КонецПроцедуры

#КонецОбласти

Функция ФизическоеЛицоСотрудника(Сотрудник) Экспорт
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сотрудник, "ФизическоеЛицо", Ложь);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

#Область ОбновлениеФорм

// Продолжение процедуры ОбновитьНапоминаниеОбОтключенииПодписокНаЭЛН для форм документов Увольнение и УвольнениеСписком.
Процедура ОбновитьНапоминаниеВУвольнении(Форма, Группа, ПараметрыОбновленияФормы)
	СотрудникиСДействующейПодпиской = РегистрыСведений.ПодпискиНаУведомленияОбЭЛН.СотрудникиСДействующейПодпиской(
		ПараметрыОбновленияФормы.Организация,
		ПараметрыОбновленияФормы.Сотрудники);
	Если СотрудникиСДействующейПодпиской.Количество() = 0 Тогда
		Группа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Надпись = НадписьНапоминанияОбОтключенииПодпискиНаЭЛН(Форма, Группа);
	Надпись.УстановитьДействие("ОбработкаНавигационнойСсылки", "Подключаемый_ЭлементыПособийОбработкаНавигационнойСсылки");
	Надпись.Заголовок = ЗаголовокНадписиОНеобходимостиОтключенияПодписки(
		СотрудникиСДействующейПодпиской,
		"1",
		Формат(ПараметрыОбновленияФормы.ДатаУвольнения + 86400, "ДЛФ=D"),
		Ложь);
КонецПроцедуры

// Продолжение процедуры ОбновитьНапоминаниеОбОтключенииПодписокНаЭЛН для прочих форм.
Процедура ОбновитьОбщееНапоминание(Форма, Группа, ПараметрыПособий)
	ПодпискиТребующиеОтключения = РегистрыСведений.СогласияНаУведомленияОбЭЛН.ТребованияПоОтключениюПодписокНаЭЛН();
	КоличествоСотрудников = ПодпискиТребующиеОтключения.Количество();
	Если КоличествоСотрудников = 0 Тогда
		Группа.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	Надпись = НадписьНапоминанияОбОтключенииПодпискиНаЭЛН(Форма, Группа);
	
	НесколькоОрганизаций = Неопределено;
	Если Не ПараметрыПособий.Свойство("ИспользоватьНесколькоОрганизаций", НесколькоОрганизаций) Тогда
		НесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизацийЗарплатаКадрыРасширенная");
		ПараметрыПособий.Вставить("ИспользоватьНесколькоОрганизаций", НесколькоОрганизаций);
	КонецЕсли;
	
	Команда = Метаданные.РегистрыСведений.СогласияНаУведомленияОбЭЛН.Команды.ОтключениеЛишнихПодписокНаУведомленияОбЭЛН;
	Надпись.Заголовок = ЗаголовокНадписиОНеобходимостиОтключенияПодписки(
		ПодпискиТребующиеОтключения,
		"e1cib/command/" + Команда.ПолноеИмя(),
		Неопределено,
		НесколькоОрганизаций);
КонецПроцедуры

// Формирует форматированную строку для заголовка декорации о необходимости отключения подписки.
Функция ЗаголовокНадписиОНеобходимостиОтключенияПодписки(ТаблицаСотрудников, НавигационнаяСсылка, ДоКакого, ДобавлятьОрганизацию)
	КоличествоСотрудников = ТаблицаСотрудников.Количество();
	
	Если КоличествоСотрудников = 1 Тогда
		КоличествоОрганизаций = 1;
		ЧтоСделать = СтрШаблон(
			НСтр("ru = 'отключить подписку на уведомления ФСС об изменении состояний ЭЛН %1';
				|en = 'disable subscription to SSF notifications about ESLR status changes %1'"),
			СклонениеПредставленийОбъектов.ПросклонятьПредставление(
				Строка(ТаблицаСотрудников[0].ФизическоеЛицо),
				2));
	Иначе
		ТаблицаСотрудников.Свернуть("Страхователь");
		КоличествоОрганизаций = ТаблицаСотрудников.Количество();
		ЧтоСделать = СтрШаблон(
			НСтр("ru = 'отключить подписки на уведомления ФСС об изменении состояний ЭЛН %1 сотрудников';
				|en = 'disable subscriptions to SSF notifications about ESLR status changes for %1 employees'"),
			Формат(КоличествоСотрудников, "ЧГ="));
	КонецЕсли;
	
	Если КоличествоОрганизаций = 1 Тогда
		Если ЗначениеЗаполнено(ДоКакого) Тогда
			Шаблон = СтрШаблон(
				НСтр("ru = 'До <b>%1</b> необходимо <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.';
					|en = 'Before <b>%1</b> you need to <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.'"),
				ДоКакого);
		ИначеЕсли ДобавлятьОрганизацию Тогда
			Шаблон = СтрШаблон(
				НСтр("ru = '%1 необходимо <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.';
					|en = '%1 is required <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.'"),
				Строка(ТаблицаСотрудников[0].Страхователь));
		Иначе
			Шаблон = НСтр("ru = 'Необходимо <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.';
							|en = 'You need to <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.'");
		КонецЕсли;
	Иначе
		Шаблон = СтрШаблон(
			НСтр("ru = '%1 организациям необходимо <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.';
				|en = '%1 companies need to <a href = ""[НавигационнаяСсылка]"">[ЧтоСделать]</a>.'"),
			Строка(КоличествоОрганизаций));
	КонецЕсли;
	
	Шаблон = СтрЗаменить(Шаблон, "[НавигационнаяСсылка]", НавигационнаяСсылка);
	Шаблон = СтрЗаменить(Шаблон, "[ЧтоСделать]", ЧтоСделать);
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(Шаблон);
КонецФункции

// Осуществляет начальную настройку элементов в группе и поиск надписи.
Функция НадписьНапоминанияОбОтключенииПодпискиНаЭЛН(Форма, Группа)
	Группа.Видимость = Истина;
	
	Если Группа.ПодчиненныеЭлементы.Количество() = 0 Тогда
		Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда;
		Группа.ГоризонтальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
		Группа.Заголовок = НСтр("ru = 'Напоминание об отключении подписки на ЭЛН';
								|en = 'Reminder of disabling subscription to ESLR'");
		
		Картинка = Форма.Элементы.Добавить("КартинкаНапоминаниеОбОтключенииПодпискиНаЭЛН", Тип("ДекорацияФормы"), Группа);
		Картинка.Вид = ВидДекорацииФормы.Картинка;
		Картинка.Картинка = БиблиотекаКартинок.Предупреждение;
		
		Надпись = Форма.Элементы.Добавить("НадписьНапоминаниеОбОтключенииПодпискиНаЭЛН", Тип("ДекорацияФормы"), Группа);
		Надпись.Вид = ВидДекорацииФормы.Надпись;
		Надпись.АвтоМаксимальнаяШирина = Ложь;
	Иначе
		Надпись = Форма.Элементы.НадписьНапоминаниеОбОтключенииПодпискиНаЭЛН;
	КонецЕсли;
	
	Возврат Надпись;
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписьюОснованияОтзываСогласия(ДокументОбъект) Экспорт
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтзывСогласияНаУведомлениеОбЭЛН") Тогда
		Возврат; // См. модуль объекта документа.
	КонецЕсли;
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	Если ДокументОбъект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	МассивФизическихЛицПередЗаписью = ФизическиеЛицаРегистратора(ДокументОбъект.Ссылка);
	ДокументОбъект.ДополнительныеСвойства.Вставить("МассивФизическихЛицПередЗаписью", МассивФизическихЛицПередЗаписью);
КонецПроцедуры

Процедура ПриЗаписиОснованияОтзываСогласия(ДокументОбъект, Отказ) Экспорт
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ОтзывСогласияНаУведомлениеОбЭЛН") Тогда
		Возврат; // См. модуль объекта документа.
	КонецЕсли;
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ДокументОбъект) Тогда
		ЗаписьЖурналаРегистрации(
			ИмяСобытияЖурнала(),
			УровеньЖурналаРегистрации.Примечание,
			ДокументОбъект.Метаданные(),
			ДокументОбъект.Ссылка,
			НСтр("ru = 'Состав изменений не вычислен, поскольку документ был записан в режиме отключения бизнес логики. Вероятно, он был изменен в другой информационной базе.';
				|en = 'The composition of the changes has not been calculated because the document was written with business logic disabled. It was probably changed in another infobase.'"),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		Возврат;
	КонецЕсли;
	МассивФизическихЛицПередЗаписью = ОбщегоНазначенияБЗК.ЗначениеСвойства(
		ДокументОбъект.ДополнительныеСвойства,
		"МассивФизическихЛицПередЗаписью");
	
	ПредставлениеОперации = НСтр("ru = 'Обновление сведений о согласиях на уведомления об ЭЛН';
								|en = 'Updating information about consents to ESLR notifications'");
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("МассивФизическихЛицПередЗаписью", МассивФизическихЛицПередЗаписью);
	ПараметрыПроцедуры.Вставить("Ссылка", ДокументОбъект.Ссылка);
	ПараметрыПроцедуры.Вставить("ВерсияДанных", ДокументОбъект.ВерсияДанных);
	ПараметрыПроцедуры.Вставить("ПредставлениеОперации", ПредставлениеОперации);
	ПараметрыЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(Неопределено);
	ПараметрыЗапуска.ОжидатьЗавершение = 0;
	ПараметрыЗапуска.НаименованиеФоновогоЗадания = ПредставлениеОперации;
	ПараметрыЗапуска.ЗапуститьВФоне = Истина;
	ДлительныеОперации.ВыполнитьВФоне(
		"СЭДОФССРасширенный.ОбновитьСведенияОСогласииВФоне",
		ПараметрыПроцедуры,
		ПараметрыЗапуска);
КонецПроцедуры

Процедура ОбновитьСведенияОСогласииВФоне(Параметры, АдресХранилища) Экспорт
	ДождалисьОкончанияЗаписи = ДождатьсяОкончанияЗаписиОбъекта(
		Параметры.Ссылка,
		Параметры.ВерсияДанных,
		Параметры.ПредставлениеОперации);
	Если Не ДождалисьОкончанияЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	МассивФизическихЛиц = ФизическиеЛицаРегистратора(Параметры.Ссылка);
	
	МассивФизическихЛицПередЗаписью = Параметры.МассивФизическихЛицПередЗаписью;
	Если МассивФизическихЛицПередЗаписью <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			МассивФизическихЛиц,
			МассивФизическихЛицПередЗаписью,
			Истина);
	КонецЕсли;
	
	РегистрыСведений.СогласияНаУведомленияОбЭЛН.ОбновитьПоФизическимЛицам(МассивФизическихЛиц);
	
КонецПроцедуры

Функция ДождатьсяОкончанияЗаписиОбъекта(Ссылка, ВерсияДанных, ПредставлениеОперации)
	Если ВерсияДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВерсияДанных") Тогда
		Возврат Истина; // Объект записан.
	КонецЕсли;
	
	ОбъектМетаданных = Ссылка.Метаданные();
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурнала(),
		УровеньЖурналаРегистрации.Примечание,
		ОбъектМетаданных,
		Ссылка,
		СтрШаблон(НСтр("ru = '%1: Ожидание записи объекта: Начало';
						|en = '%1: Waiting for object writing: Starting'"), ПредставлениеОперации));
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить(ОбъектМетаданных.ПолноеИмя());
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
		Блокировка.Заблокировать();
		ОтменитьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = СтрШаблон(
			НСтр("ru = '%1: Не удалось дождаться записи объекта по причине: %2';
				|en = '%1: Cannot wait for object writing. Reason: %2'"),
			ПредставлениеОперации,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ЗаписьЖурналаРегистрации(
			ИмяСобытияЖурнала(),
			УровеньЖурналаРегистрации.Ошибка,
			ОбъектМетаданных,
			Ссылка,
			ТекстСообщения);
		Возврат Ложь;
	КонецПопытки;
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурнала(),
		УровеньЖурналаРегистрации.Примечание,
		ОбъектМетаданных,
		Ссылка,
		СтрШаблон(НСтр("ru = '%1: Ожидание записи объекта: Завершение';
						|en = '%1: Waiting for object writing: Finalizing'"), ПредставлениеОперации));
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область ЖурналРегистрации

Функция ИмяСобытияЖурнала() Экспорт
	Возврат НСтр("ru = 'Обмен с ФСС.СЭДО';
				|en = 'Exchange with ФСС.СЭДО'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

#КонецОбласти

Функция ВключенОбменЧерезСЭДО()
	Возврат ПолучитьФункциональнуюОпцию("ПолучатьУведомленияОбЭЛН");
КонецФункции

Функция ДоступенОбменЧерезСЭДО()
	Возврат ВключенОбменЧерезСЭДО()
		И Пользователи.РолиДоступны("ПравоНаЗащищенныйДокументооборотСКонтролирующимиОрганами", , Ложь)
		И ПравоДоступа("Просмотр", Метаданные.РегистрыСведений.СообщенияФССОбИзмененииСостоянийЭЛН);
КонецФункции

Функция ИзменитьПометкуУдаления(МассивСсылок, ПометкаУдаления) Экспорт
	Измененные = Новый Массив;
	
	Право = ?(ПометкаУдаления, "ИнтерактивнаяПометкаУдаления", "ИнтерактивноеСнятиеПометкиУдаления");
	
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Заблокированные = Новый Массив;
		Для Каждого Ссылка Из МассивСсылок Цикл
			ОбъектМетаданных = Ссылка.Метаданные();
			Если Не ПравоДоступа(Право, ОбъектМетаданных) Тогда
				Продолжить;
			КонецЕсли;
			ЭлементБлокировки = Блокировка.Добавить(ОбъектМетаданных.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
			Заблокированные.Добавить(Ссылка);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		Для Каждого Ссылка Из Заблокированные Цикл
			ИзменяемыйОбъект = Ссылка.ПолучитьОбъект();
			Если ИзменяемыйОбъект = Неопределено
				Или ИзменяемыйОбъект.ПометкаУдаления = ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
			ИзменяемыйОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
			Измененные.Добавить(Ссылка);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Измененные;
КонецФункции

// Возвращает дату вступления в силу Федерального закона от 30.04.2021 № 126-ФЗ.
Функция ИспользоватьПроактивныеВыплаты(Дата = Неопределено) Экспорт
	Если Дата = Неопределено Тогда
		Дата = ТекущаяДатаСеанса();
	КонецЕсли;
	Возврат Дата >= ДатаНачалаПроактивныхВыплат();
КонецФункции

// Возвращает дату вступления в силу Федерального закона от 30.04.2021 № 126-ФЗ.
Функция ДатаНачалаПроактивныхВыплат()
	Возврат '20220101';
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ФизическиеЛицаРегистратора(Ссылка)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КадроваяИсторияСотрудников.ФизическоеЛицо КАК ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.КадроваяИсторияСотрудников КАК КадроваяИсторияСотрудников
	|ГДЕ
	|	КадроваяИсторияСотрудников.Регистратор = &Регистратор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЗанятостиСотрудников.ФизическоеЛицо
	|ИЗ
	|	РегистрСведений.ВидыЗанятостиСотрудников КАК ВидыЗанятостиСотрудников
	|ГДЕ
	|	ВидыЗанятостиСотрудников.Регистратор = &Регистратор";
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	Таблица = Запрос.Выполнить().Выгрузить();
	Таблица.Свернуть("ФизическоеЛицо");
	Возврат Таблица.ВыгрузитьКолонку("ФизическоеЛицо");
КонецФункции

#КонецОбласти
