#Область СлужебныйПрограммныйИнтерфейс

#Область ДоступностьПоПравам

// Определяет, доступен ли виджет пользователю по правам
// 
// Параметры:
// 	Виджет - ПеречислениеСсылка.ДоступныеВиджетыТекущихДелEDI - виджет, для которого требуется определить доступность.
// Возвращаемое значение:
// 	Булево - признак доступности виджета.
//
Функция ВиджетДоступенПоПравам(Виджет) Экспорт
	
	Для Каждого РазделВиджета Из ТекущиеДелаEDIКлиентСервер.РазделыВиджета(Виджет) Цикл
		Если РазделВиджетаДоступенПоПравам(РазделВиджета) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Определяет, доступен ли раздел виджета пользователю по правам
// 
// Параметры:
// 	РазделВиджета - ПеречислениеСсылка.РазделыВиджетовEDI - раздел виджета, для которого требуется определить доступность.
// Возвращаемое значение:
// 	Булево - признак доступности раздела виджета.
//
Функция РазделВиджетаДоступенПоПравам(РазделВиджета) Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.РазделВиджетаДоступенПоПравам(РазделВиджета);
	
КонецФункции

// Возвращает массив доступных по правам групп виджетов.
// 
// Возвращаемое значение:
// 	Массив - массив доступных по правам групп виджетов.
//
Функция МассивГруппВиджетовДоступныхПоПравам() Экспорт

	МассивДоступныхГрупп = Новый Массив;
	
	Для Каждого ГруппаВиджетов Из МассивДоступныхГруппВиджетов() Цикл
		
		Если МассивВиджетовГруппы(ГруппаВиджетов).Количество() > 0 Тогда
			МассивДоступныхГрупп.Добавить(ГруппаВиджетов);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДоступныхГрупп;
	
КонецФункции

// Возвращает массив доступных по правам виджетов.
// 
// Возвращаемое значение:
// 	Массив - массив доступных по правам виджетов.
//
Функция ВсеВиджетыДоступныеПоПравам() Экспорт
	
	МассивВиджетов = Новый Массив;
	
	Для Каждого ГруппаВиджетов Из МассивГруппВиджетовДоступныхПоПравам() Цикл

		Для Каждого Виджет Из МассивВиджетовГруппы(ГруппаВиджетов) Цикл
			МассивВиджетов.Добавить(Виджет);
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат МассивВиджетов;
	
КонецФункции

#КонецОбласти

#Область НастройкиПоУмолчанию

// Возвращает массив виджетов по умолчанию.
// 
// Возвращаемое значение:
// 	Массив - массив массив виджетов по умолчанию.
//
Функция ВиджетыПоУмолчанию() Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.ВиджетыПоУмолчанию();
	
КонецФункции

// Возвращает массив разделов виджетов по умолчанию.
// 
// Возвращаемое значение:
// 	Массив - массив массив разделов по умолчанию.
//
Функция РазделыПоУмолчанию(Виджет) Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.РазделыПоУмолчанию(Виджет);
	
КонецФункции

#КонецОбласти

#Область ДанныеПоВиджетамИГруппам

// Возвращает соответствие групп виджетов группам формы текущих дел.
// 
// Возвращаемое значение:
// 	Соответствие - соответствие групп виджетов группам формы текущих дел..
//
Функция СоответствиеГруппВиджетовГруппамФормы() Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.СоответствиеГруппВиджетовГруппамФормы();
	
КонецФункции

// Возвращает массив доступных по правам групп виджетов.
// 
// Возвращаемое значение:
// 	Массив - массив доступных по правам групп виджетов.
//
Функция МассивДоступныхГруппВиджетов() Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.МассивДоступныхГруппВиджетов();
	
КонецФункции

// Возвращает массив виджетов группы.
// 
// Возвращаемое значение:
// 	Массив - массив виджетов группы.
//
Функция МассивВиджетовГруппы(ГруппаВиджетов) Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.МассивВиджетовГруппы(ГруппаВиджетов);
	
КонецФункции

#КонецОбласти

#Область ПодготовкаДанныхИВыводИнформации

// Описание
// 
// Параметры:
// 	Форма                   - ФормаКлиентскогоПриложения - форма текущих дел, в которую выводятся виджеты.
// 	ПараметрыВыводаВиджетов - Структура - параметры вывода виджетов.
//
Процедура ВывестиВиджеты(Форма, ПараметрыВыводаВиджетов) Экспорт
	
	Для Каждого ЭлементСпискаВиджетов Из ПараметрыВыводаВиджетов.ИспользуемыеВиджеты Цикл
		
		ТекущиеДелаEDIИнтеграция.ВывестиИнформациюПоВиджету(Форма, ЭлементСпискаВиджетов.Значение, ПараметрыВыводаВиджетов);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ТаблицаЗависимостей

// Удаляет группу элементов формы виджета из таблицы зависимостей
// 
// Параметры:
// 	Форма     - ФормаКлиентскогоПриложения - форма текущих дел.
// 	ИмяГруппы - Строка                     - имя удаляемой группы.
//
Процедура УдалитьГруппуИзТаблицыЗависимостей(Форма, ИмяГруппы) Экспорт
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ИмяПодчиненнойГруппы", ИмяГруппы);
	
	НайденныеСтроки = Форма.ЗависимостиСворачиваемыхГрупп.НайтиСтроки(ПараметрыПоиска);
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		Форма.ЗависимостиСворачиваемыхГрупп.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

// Добавляет группу элементов формы виджета в таблицу зависимостей
// 
// Параметры:
// 	Форма     - ФормаКлиентскогоПриложения - форма текущих дел.
// 	Параметры - Структура                  - параметры добавляемой группы.
//
Процедура ДобавитьСтрокуТаблицыЗависимостей(Форма, Параметры) Экспорт
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ИмяПодчиненнойГруппы", Параметры.ИмяПодчиненнойГруппы);
	
	НайденныеСтроки = Форма.ЗависимостиСворачиваемыхГрупп.НайтиСтроки(ПараметрыПоиска);
	Если НайденныеСтроки.Количество() <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Форма.ЗависимостиСворачиваемыхГрупп.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Параметры);
	
КонецПроцедуры

// Конструктор строки таблицы зависимости групп элементов формы виджетов.
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Включена                  - Булево - 
// * ИмяПодчиненнойГруппы      - Строка - имя подчиненной группы.
// * ИмяСворачиваемогоЭлемента - Строка - имя сворачиваемого элемента.
// * Виджет                    - ПеречислениеСсылка.ДоступныеВиджетыТекущихДелEDI - отрисовываемый виджет.
//
Функция ПараметрыСтрокиТаблицыЗависимостей() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Виджет",                    Перечисления.ДоступныеВиджетыТекущихДелEDI.ПустаяСсылка());
	Параметры.Вставить("ИмяСворачиваемогоЭлемента", "");
	Параметры.Вставить("ИмяПодчиненнойГруппы",      "");
	Параметры.Вставить("Включена",                  Ложь);
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#Область ДекорацииВиджетов

// Определяет имя следующей декорации при выводе виджета
// 
// Параметры:
// 	ИмяТекущейДекорации - Строка - определяемое имя декорации
// 	ИмяДекорации        - Строка - имя выводимой декорации
// 	ТекущийПостфикс     - Число - постфикс декорации
//
Процедура ОпределитьИмяСледующейДекорации(ИмяТекущейДекорации, ИмяДекорации, ТекущийПостфикс) Экспорт
	
	ИнкрементироватьПостфиксДекорации(ТекущийПостфикс);
	ИмяТекущейДекорации = ИмяДекорации + ТекущийПостфикс;
	
КонецПроцедуры

// Отключает видимость декорации группы начиная с определенного номера
// 
// Параметры:
// 	Группа       - ГруппаФормы - группа элементов формы, для подчиненных элементов которой определяется видимость.
// 	ИмяДекорации - Строка      - имя декорации формы.
// 	Постфикс     - Число       - постфикс последней видимой декорации.
// 	Сдвиг        - Число       - сдвиг постфикса.
//
Процедура ОтключитьВидимостьДекорацийГруппыНачинаяСПостфикса(Группа, ИмяДекорации, Постфикс, Сдвиг = 0) Экспорт
	
	ПодчиненныеЭлементы = Группа.ПодчиненныеЭлементы;
	КоличествоЭлементовГруппы = ПодчиненныеЭлементы.Количество() + Сдвиг;
	Пока ПостфиксВЧисло(Постфикс) <= КоличествоЭлементовГруппы Цикл
		ПодчиненныеЭлементы[ИмяДекорации + Постфикс].Видимость = Ложь;
		ИнкрементироватьПостфиксДекорации(Постфикс);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Сохраняет пользовательские настройки виджетов
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма текущих дел.
//
Процедура СохранитьНастройкиВиджетов(Форма) Экспорт

	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить("ВиджетыEDI", "ВыбранныеВиджеты",   Форма.ИспользуемыеВиджеты);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить("ВиджетыEDI", "ВыбранныеРазделы",   Форма.ИспользуемыеРазделы);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить("ВиджетыEDI", "РазвернутостьГрупп", Форма.ЗависимостиСворачиваемыхГрупп.Выгрузить());

КонецПроцедуры

// Описание
// 
// Параметры:
// 	ТаблицаВиджетов  - ТаблицаЗначений - таблица выводимых виджетов.
// 	ВыбранныеВиджеты - Массив - выбранные для вывода виджеты.
//
Процедура ЗаполнитьТаблицуВиджетов(ТаблицаВиджетов, ВыбранныеВиджеты) Экспорт
	
	МассивГруппВиджетов = МассивДоступныхГруппВиджетов();
	Для Каждого ГруппаВиджетов Из МассивГруппВиджетов Цикл
		ДобавитьГруппуВиджетов(ТаблицаВиджетов, ГруппаВиджетов);
	КонецЦикла;
	
	УстановитьПометкиТаблицаВиджетовСогласноВыбраннымЗначениям(ТаблицаВиджетов, ВыбранныеВиджеты);
	
КонецПроцедуры

// Включает видимость декорации и выводит в нее данные виджета
// 
// Параметры:
// 	Форма        - ФормаКлиентскогоПриложения - форма текущих дел.
// 	Заголовок    - Строка - выводимая в виджет информация.
// 	Гиперссылка  - Строка - навигационная ссылка информации.
// 	ИмяДекорации - Строка - имя декорации виджета.
//
Процедура ВывестиДекорацию(Форма, Заголовок, Гиперссылка, ИмяДекорации) Экспорт
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить("     ");
	МассивСтрок.Добавить(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '<a href = ""%1"">%2</a>.';
																						|en = '<a href = ""%1"">%2</a>.'"), Гиперссылка, Заголовок));
	ЗаголовокЭлемента = СтрСоединить(МассивСтрок);
	
	ЗаголовокЭлемента = СтроковыеФункции.ФорматированнаяСтрока(ЗаголовокЭлемента);
	
	Форма.Элементы[ИмяДекорации].Заголовок = ЗаголовокЭлемента;
	Форма.Элементы[ИмяДекорации].Видимость = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ИдентификаторыДокументов

// Возвращает массив идентификаторов документов закупки.
// 
// Возвращаемое значение:
// 	Массив - массив идентификаторов документов закупки.
//
Функция ИдентификаторыДокументовЗакупки() Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.ИдентификаторыДокументовЗакупки();
	
КонецФункции

// Возвращает массив идентификаторов документов продажи.
// 
// Возвращаемое значение:
// 	Массив - массив идентификаторов документов продажи.
//
Функция ИдентификаторыДокументовПродажи() Экспорт
	
	Возврат ТекущиеДелаEDIИнтеграция.ИдентификаторыДокументовПродажи();
	
КонецФункции

#КонецОбласти

// Подготавливает и помещает во временное хранилище данные для вывода в виджеты.
// 
// Параметры:
// 	ПараметрыПодготовки - Структура - содержит:
// 	 * ИспользуемыеВиджеты - Массив - используемые виджеты.
// 	 * ИспользуемыеРазделы - Массив - используемые разделы. 
// 	АдресХранилища - Строка - адрес временного хранилища, в которое будут помещены данные.
//
Процедура ПодготовитьИнформациюДляВыводаВиджетов(ПараметрыПодготовки, АдресХранилища) Экспорт
	
	ПодготовленныеДанныеДляВиджетов = ПодготовленныеДанныеДляВиджетов(ПараметрыПодготовки.ИспользуемыеВиджеты, ПараметрыПодготовки.ИспользуемыеРазделы);
	
	ПоместитьВоВременноеХранилище(ПодготовленныеДанныеДляВиджетов, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодготовкаДанныхИВыводИнформации

// Подготавливает данные для вывода в виджеты текущих дел
// 
// Параметры:
// 	ИспользуемыеВиджеты - Массив - массив используемых виджетов.
// 	ИспользуемыеРазделы - Массив - массив используемых разделов виджета.
// Возвращаемое значение:
// 	Соответствие - содержит подготовленные данные для вывода виджетов.
//
Функция ПодготовленныеДанныеДляВиджетов(ИспользуемыеВиджеты, ИспользуемыеРазделы)
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ПараметрыЗапроса", Новый Структура);
	ПараметрыФормирования.Вставить("РазделыЗапросы",   Новый Соответствие);
	ПараметрыФормирования.Вставить("Запрос",           Новый Запрос);
	ПараметрыФормирования.Вставить("ТекущийНомерЗапроса", -1); 
	
	ПараметрыФормирования.Запрос.УстановитьПараметр("ТекущийПользователь", ТекущиеДелаEDIИнтеграция.ТекущийМенеджер());
	ПараметрыФормирования.Запрос.УстановитьПараметр("НачалоТекущейДаты", НачалоДня(ТекущаяДатаСеанса()));
	
	Для Каждого ИспользуемыйРаздел Из ИспользуемыеРазделы Цикл
		
		ТекущиеДелаEDIИнтеграция.ПодготовитьДанныеЗапросаПоРазделу(ПараметрыФормирования, ИспользуемыйРаздел.Значение);
		
	КонецЦикла;
	
	ДанныеДляВиджетов = Новый Соответствие;
	
	Если ПараметрыФормирования.ТекущийНомерЗапроса > -1 Тогда
		
		ПараметрыФормирования.Вставить("РезультатЗапроса", ПараметрыФормирования.Запрос.ВыполнитьПакет());
		
	КонецЕсли;
		
	Для Каждого ИспользуемыйРаздел Из ИспользуемыеРазделы Цикл
		
		ТекущиеДелаEDIИнтеграция.ПодготовитьДанныеПоРезультатамЗапросаПоРазделу(ПараметрыФормирования, ДанныеДляВиджетов, ИспользуемыйРаздел.Значение);
		ТекущиеДелаEDIИнтеграция.ПодготовитьДанныеПравоДоступаПоРазделу(ДанныеДляВиджетов, ИспользуемыйРаздел.Значение);
		
	КонецЦикла;
	
	Возврат ДанныеДляВиджетов;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Добавляет новую строку таблицы виджетов
// 
// Параметры:
// 	ТаблицаВиджетов - ТаблицаЗначений - таблица виджетов
// 	Виджет - ПеречислениеСсылка.ДоступныеВиджетыТекущихДелEDI - добавляемый виджет
// 	Группировка - ПеречислениеСсылка.ГруппыВиджетовEDI - группа, в которую входит виджет.
// Возвращаемое значение:
// 	СтрокаТаблицыЗначений - добавленная строка таблицы значений.
//
Функция НоваяСтрокаТаблицыВиджетов(ТаблицаВиджетов, Виджет, Группировка)
	
	НоваяСтрока  = ТаблицаВиджетов.Добавить();
	
	НоваяСтрока.Представление = Строка(Виджет);
	НоваяСтрока.Виджет        = Виджет;
	НоваяСтрока.Группировка   = Группировка;
	
	Возврат НоваяСтрока;
	
КонецФункции

// Добавляет группу виджетов в таблицу виджетов.
// 
// Параметры:
// 	ТаблицаВиджетов - ТаблицаЗначений - таблица, в которую происходит добавление.
// 	ГруппаВиджетов  - ПеречислениеСсылка.ГруппыВиджетовEDI - добавляемая группа виджетов.
//
Процедура ДобавитьГруппуВиджетов(ТаблицаВиджетов, ГруппаВиджетов)
	
	МассивВиджетовГруппы = МассивВиджетовГруппы(ГруппаВиджетов);
	
	Если МассивВиджетовГруппы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементМассива Из МассивВиджетовГруппы Цикл
		
		Если ВиджетДоступенПоПравам(ЭлементМассива) Тогда
			НоваяСтрокаТаблицыВиджетов(ТаблицаВиджетов, ЭлементМассива, ГруппаВиджетов);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Процедура УстановитьПометкиТаблицаВиджетовСогласноВыбраннымЗначениям(ТаблицаВиджетов, ВыбранныеВиджеты)
	
	Для Каждого СтрокаТаблицы Из ТаблицаВиджетов Цикл
		
		Если ВыбранныеВиджеты.Найти(СтрокаТаблицы.Виджет) <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ИнкрементироватьПостфиксДекорации(Постфикс)
	
	Если Постфикс = "Первая" Тогда
		Постфикс = "Вторая";
	ИначеЕсли Постфикс = "Вторая" Тогда
		Постфикс = "Третья";
	ИначеЕсли Постфикс = "Третья" Тогда
		Постфикс = "Четвертая";
	ИначеЕсли Постфикс = "Четвертая" Тогда
		Постфикс = "Пятая";
	ИначеЕсли Постфикс = "Пятая" Тогда
		Постфикс = "Шестая";
	КонецЕсли;
	
КонецПроцедуры

Функция ПостфиксВЧисло(Постфикс)
	
	Если Постфикс = "Первая" Тогда
		Возврат 1;
	ИначеЕсли Постфикс = "Вторая" Тогда
		Возврат 2;
	ИначеЕсли Постфикс = "Третья" Тогда
		Возврат 3;
	ИначеЕсли Постфикс = "Четвертая" Тогда
		Возврат 4;
	ИначеЕсли Постфикс = "Пятая" Тогда
		Возврат 5;
	ИначеЕсли Постфикс = "Шестая" Тогда
		Возврат 6;
	КонецЕсли; 
	
КонецФункции

#КонецОбласти

