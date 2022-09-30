&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтекстЭДОСервер = КонтекстЭДОСервер();
	
	Если Параметры.Ключ.Пустая() И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда			
		УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
		Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
		
		ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ОргПоУмолчанию)
			И ?(КонтекстЭДОСервер = Неопределено, Истина, КонтекстЭДОСервер.СписокДопустимыхОрганизацийВОбъектахОбмена().Найти(ОргПоУмолчанию) <> Неопределено)
			И ((ЗначениеЗаполнено(ОргПоУмолчанию) И НЕ УчетПоВсемОрганизациям)
			ИЛИ (НЕ ЗначениеЗаполнено(Объект.Организация) И УчетПоВсемОрганизациям И (ЗначениеЗаполнено(ОргПоУмолчанию)))) Тогда
			Объект.Организация = ОргПоУмолчанию;
		КонецЕсли;
		
		СтруктураПараметров = Новый Структура("Организация, ОрганПФР, ВидСверки, ПериодСобытия");
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, Параметры);
		ЗаполнитьДокументПоСтруктуре(СтруктураПараметров);
		
		ПриИзмененииОрганизации();
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ВидУслуги = Перечисления.ВидыУслугПриИОС.СверкаФИОиСНИЛС;
	КонецЕсли;
	
	ОбновитьЗаголовокФормы(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "Организация");
		
	ЗаявлениеОтправлено = ЗаявлениеОтправлено(Объект.Ссылка);
	
	УправлениеФормой(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт

	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОбновитьЗаголовокФормы(ЭтаФорма);
	
	Оповестить("Запись_ЗапросНаИнформационноеОбслуживаниеСтрахователя", , Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ПриИзмененииОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекстСообщения = НСтр("ru = 'Поле ""От кого"" не заполнено';
								|en = 'Поле ""От кого"" не заполнено'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	Если ПоказатьФормуПредложенияПодключиться() Тогда
		СтандартнаяОбработка = Ложь;
		ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьФормуПредложениеОформитьЗаявлениеНаПодключение(Объект.Организация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выгрузить(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		Записать();
	КонецЕсли;

	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		КонтекстЭДОКлиент.ВыгрузитьЗапросИОСВФайл(Объект.Ссылка, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	КонтекстЭДОКлиент.ВыгрузитьЗапросИОСВФайл(Объект.Ссылка, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	 
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;	
	КонецЕсли;
	
	Если КонтекстЭДОКлиент = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьЗавершение", ЭтотОбъект);
		ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	Иначе
		ДополнительныеПараметры = Новый Структура("КонтекстЭДОКлиент", КонтекстЭДОКлиент);
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтправкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		КонтекстЭДОКлиент.ОтправкаЗапросаИОС(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры = Новый Структура("КонтекстЭДОКлиент", КонтекстЭДОКлиент);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтправкиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	КонтекстЭДОКлиент.ОтправкаЗапросаИОС(Объект.Ссылка, Объект.Организация, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = ДополнительныеПараметры.КонтекстЭДОКлиент;
	ЗаявлениеОтправлено = ПослеОтправкиЗавершениеНаСервере();
	
	// Перерисовка статуса отправки в форме Отчетность
	ПараметрыОповещения = Новый Структура(); 
	ПараметрыОповещения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	Оповестить("Завершение отправки", ПараметрыОповещения, Объект.Ссылка);
	
	Если Открыта() И ЗаявлениеОтправлено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПослеОтправкиЗавершениеНаСервере()
	
	ЗаявлениеОтправлено = ЗаявлениеОтправлено(Объект.Ссылка);
	УправлениеФормой(ЭтаФорма);
	
	Возврат ЗаявлениеОтправлено;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьСписокЗастрахованныхЛиц(Команда)
	
	Если Объект.ЗастрахованныеЛица.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Список будет очищен перед заполнением.
			|Продолжить?';
			|en = 'Список будет очищен перед заполнением.
			|Продолжить?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьСписокЗастрахованныхЛицЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ЗаполнитьСписокЗастрахованныхЛицНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокЗастрахованныхЛицЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьСписокЗастрахованныхЛицНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПечатнаяФормаСверки = ТабличныйДокументСверки(Объект.Ссылка);
	КонтекстЭДОКлиент.НапечататьДокумент(ПечатнаяФормаСверки, Строка(Объект.ВидУслуги));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗаголовокФормы(Форма)
	
	Объект = Форма.Объект;
	Если Объект.ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОС.СправкаОСостоянииРасчетов") Тогда 
		Заголовок = НСтр("ru = 'Запрос на сверку ""%1 (%2)""';
						|en = 'Запрос на сверку ""%1 (%2)""'");
	Иначе 
		Заголовок = НСтр("ru = 'Запрос на сверку ""%1""';
						|en = 'Запрос на сверку ""%1""'");
	КонецЕсли;
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, 
		Форма.Объект.ВидУслуги,
		Формат(Форма.Объект.НаДату, "ДФ=dd.MM.yyyy"));
		
	Форма.Заголовок = Заголовок;
	
КонецПроцедуры
	
&НаСервере
Процедура ПриИзмененииОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	СведОрг = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, , "КодОрганаПФР");
	Если НЕ ЗначениеЗаполнено(СведОрг) Тогда
		Объект.Получатель = Неопределено;
		Возврат;
	КонецЕсли;
	
	КодОрганаПФР = СведОрг.КодОрганаПФР;
	Если НЕ ЗначениеЗаполнено(КодОрганаПФР) Тогда
		Объект.Получатель = Неопределено;
		Возврат;
	КонецЕсли;
	
	ОрганПФР = Справочники.ОрганыПФР.НайтиПоКоду(КодОрганаПФР);
	Если НЕ ЗначениеЗаполнено(ОрганПФР) Тогда
		Объект.Получатель = Неопределено;
		Возврат;
	КонецЕсли;
	
	Объект.Получатель = ОрганПФР;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЗастрахованныхЛицНаСервере()
	
	Объект.ЗастрахованныеЛица.Очистить();
	
	ДанныеСотрудников = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСписокЗастрахованныхЛицОрганизации(Объект.Организация, ТекущаяДатаСеанса());
	Если НЕ ЗначениеЗаполнено(ДанныеСотрудников) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Стр Из ДанныеСотрудников Цикл
		НовСтр = Объект.ЗастрахованныеЛица.Добавить();
		НовСтр.Фамилия = СокрЛП(Стр.Фамилия);
		НовСтр.Имя = СокрЛП(Стр.Имя);
		НовСтр.Отчество = СокрЛП(Стр.Отчество);
		НовСтр.СтраховойНомер = Стр.СтраховойНомерПФР;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.НаДату.Видимость = 
		Объект.ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОС.СправкаОСостоянииРасчетов");
		
	Элементы.ГруппаЗастрахованныеЛица.Видимость = 
		Объект.ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОС.СверкаФИОиСНИЛС");
		
	Элементы.ОтступПередКомментарием.Видимость = НЕ Элементы.ГруппаЗастрахованныеЛица.Видимость;
		
	Если Форма.ЗаявлениеОтправлено Тогда
		Элементы.НаДату.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Организация.Вид = ВидПоляФормы.ПолеНадписи;
		Элементы.Получатель.Вид = ВидПоляФормы.ПолеНадписи;
	Иначе
		Элементы.НаДату.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.Организация.Вид = ВидПоляФормы.ПолеВвода;
		Элементы.Получатель.Вид = ВидПоляФормы.ПолеВвода;
	КонецЕсли;
	
	Элементы.ЗастрахованныеЛицаДобавить.Видимость = Не Форма.ЗаявлениеОтправлено;
	Элементы.ЗастрахованныеЛицаИзменить.Видимость = Не Форма.ЗаявлениеОтправлено;
	Элементы.ЗастрахованныеЛицаУдалить.Видимость = Не Форма.ЗаявлениеОтправлено;
	Элементы.ЗастрахованныеЛицаЗаполнить.Видимость = Не Форма.ЗаявлениеОтправлено;
	
	Элементы.ЗастрахованныеЛица.ТолькоПросмотр = Форма.ЗаявлениеОтправлено;
	
	Элементы.Отправить.Видимость = Не Форма.ЗаявлениеОтправлено;
	Элементы.Записать.ТолькоВоВсехДействиях = Форма.ЗаявлениеОтправлено;
	
	ПрорисоватьСтатус(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаявлениеОтправлено(Ссылка)
	
	СтатусОтправки = КонтекстЭДОСервер().ПолучитьСтатусОтправкиОбъекта(Ссылка);
	
	ЗаявлениеОтправлено = 
		ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;
		
	Возврат ЗаявлениеОтправлено;
	
КонецФункции

&НаСервереБезКонтекста
Функция КонтекстЭДОСервер()
	
	Возврат ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПрорисоватьСтатус(Форма)
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, "ПФР");
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
		
КонецФункции

&НаСервере
Функция ТабличныйДокументСверки(Сверка)
	
	Возврат Документы.ЗапросНаИнформационноеОбслуживаниеСтрахователя.ПечатнаяФорма(Сверка);
	
КонецФункции

#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаСервере
Функция ПоказатьФормуПредложенияПодключиться()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ОрганыПФР.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ОрганыПФР КАК ОрганыПФР
		|ГДЕ
		|	ОрганыПФР.ПометкаУдаления = ЛОЖЬ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЕстьОрганыПФР = РезультатЗапроса.Выбрать().Количество() > 0;
	
	Организация   = Объект.Организация;
	УчетнаяЗапись = Организация.УчетнаяЗаписьОбмена;
	
	ПоказатьПредложение = НЕ ЕстьОрганыПФР И НЕ ЗначениеЗаполнено(УчетнаяЗапись);
	
	Возврат ПоказатьПредложение;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументПоСтруктуре(СтруктураПараметров)
	
	Если ЗначениеЗаполнено(СтруктураПараметров.Организация) Тогда
		Объект.Организация = СтруктураПараметров.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураПараметров.ОрганПФР) Тогда
		Объект.Получатель = СтруктураПараметров.ОрганПФР;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураПараметров.ПериодСобытия) Тогда
		Объект.НаДату = КонецДня(СтруктураПараметров.ПериодСобытия);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураПараметров.ВидСверки) Тогда
		Объект.ВидУслуги = СтруктураПараметров.ВидСверки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти