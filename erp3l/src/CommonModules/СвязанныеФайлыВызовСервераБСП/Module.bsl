////////////////////////////////////////////////////////////////////////////////
// Работа со связанными файлами в ДО и в текущей ИБ
//

#Область ПрограммныйИнтерфейс

// Возвращает массив структур, описывающих файлы владельца.
//
// Параметры:
//   Владелец - ЛюбаяСсылка - объект-владелец связанных файлов
//   ДокументID - не заполняется. Используется для унификации ДО и БСП.
//   ДокументТип - не заполняется.  Используется для унификации ДО и БСП.
//   ВключатьПомеченныеНаУдаление - Булево - Истина, если требуется получить и помеченные на удаление.
//
// Возвращаемое значение:
//   Массив - структуры, описывающие реквизиты связанных файлов
//
Функция СвязанныеФайлыПоВладельцу(Владелец, ДокументID = "", ДокументТип = "", 
				ВключатьПомеченныеНаУдаление = Ложь) Экспорт
	
	МассивФайлов = Новый Массив;
	ЗапросФайлыПоВладельцу = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА Файлы.ПометкаУдаления
		|			ТОГДА Файлы.ИндексКартинки + 1
		|		ИНАЧЕ Файлы.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинки,
		|	Файлы.Наименование КАК Наименование,
		|	Файлы.Расширение КАК Расширение,
		|	Файлы.Ссылка КАК Ссылка,
		|	Файлы.ДатаМодификацииУниверсальная КАК ДатаМодификацииУниверсальная,
		|	Файлы.Размер КАК Размер,
		|	Файлы.ПометкаУдаления КАК ПометкаУдаления,
		|	Файлы.Описание КАК Описание
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОбъектыСвязанныхФайлов КАК СвязанныеФайлы
		|		ПО (СвязанныеФайлы.СвязанныйФайл = Файлы.Ссылка)
		|ГДЕ
		|	СвязанныеФайлы.ИмпортированныйОбъект = &Владелец");
	
	Если Не ВключатьПомеченныеНаУдаление Тогда
		ЗапросФайлыПоВладельцу.Текст = ЗапросФайлыПоВладельцу.Текст + "
		|	И НЕ Файлы.ПометкаУдаления";
	КонецЕсли;
	
	ЗапросФайлыПоВладельцу.УстановитьПараметр("Владелец", Владелец);
	Выборка = ЗапросФайлыПоВладельцу.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОписаниеФайла = Новый Структура;
		ОписаниеФайла.Вставить("ИндексКартинки", Выборка.ИндексКартинки);
		ОписаниеФайла.Вставить("Наименование", Выборка.Наименование);
		ОписаниеФайла.Вставить("Расширение", Выборка.Расширение);
		ОписаниеФайла.Вставить("СвязанныйФайл", Выборка.Ссылка);
		ОписаниеФайла.Вставить("Идентификатор", Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		ОписаниеФайла.Вставить("ДатаТекущейВерсии", Выборка.ДатаМодификацииУниверсальная);
		ОписаниеФайла.Вставить("Размер", Выборка.Размер);
		ОписаниеФайла.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
		ОписаниеФайла.Вставить("Комментарий", Выборка.Описание);
		МассивФайлов.Добавить(ОписаниеФайла);
	КонецЦикла;
		
	Возврат МассивФайлов;
КонецФункции

// Возвращает структуру, описывающую файл, найденный по идентификатору.
//
// Параметры:
//   ИдентификаторФайла - идентификатор связанного объекта ДО или УИД Справочник.Файлы
//
// Возвращаемое значение:
//  Структура, описывающая реквизиты найденного файла, если файл найден. 
//		Описание полей см. СвязанныеФайлыВызовСервера.ПолучитьШаблонОписанияФайла().
//	Неопределено, если файл не найден.
//
Функция ПолучитьФайлПоИдентификатору(ИдентификаторФайла) Экспорт
	ОписаниеФайла = Неопределено;
	
	Если НЕ ПустаяСтрока(ИдентификаторФайла) Тогда
		СсылкаНаФайл = Справочники.Файлы.ПолучитьСсылку(
				Новый УникальныйИдентификатор(ИдентификаторФайла));
		Если ЗначениеЗаполнено(СсылкаНаФайл) Тогда
			ОписаниеФайла = СвязанныеФайлыВызовСервера.ПолучитьШаблонОписанияФайла();
			ОписаниеФайла.ИндексКартинки = СсылкаНаФайл.ИндексКартинки + Число(СсылкаНаФайл.ПометкаУдаления);
			ОписаниеФайла.Наименование = СсылкаНаФайл.Наименование;
			ОписаниеФайла.Расширение = СсылкаНаФайл.Расширение;
			ОписаниеФайла.СвязанныйФайл = СсылкаНаФайл.Ссылка;
			ОписаниеФайла.Идентификатор = ИдентификаторФайла;
			ОписаниеФайла.ДатаТекущейВерсии = СсылкаНаФайл.УдалитьТекущаяВерсияДатаМодификацииФайла;
			ОписаниеФайла.Размер = СсылкаНаФайл.Размер;
			ОписаниеФайла.ПометкаУдаления = СсылкаНаФайл.ПометкаУдаления;
			ОписаниеФайла.Комментарий = СсылкаНаФайл.Описание;
		КонецЕсли;	
	КонецЕсли;
		
	Возврат ОписаниеФайла;
КонецФункции

// Возвращает структуру, описывающую файл, найденный по ссылке.
// Аналогична функции ПолучитьФайлПоИдентификатору.
//
Функция ПолучитьФайлПоСсылке(СсылкаНаФайл) Экспорт
	Возврат ПолучитьФайлПоИдентификатору(
				ПолучитьИдентификаторФайлаПоСсылке(СсылкаНаФайл));
КонецФункции

// Возвращает файл, добавленный владельцу из временного хранилища и помещенный в ДО или в эту ИБ.
// Может приводить к автоматическому созданию связанного объекта.
//
// Параметры:
//   Владелец - ЛюбаяСсылка - объект-владелец связанных файлов
//   АдресВременногоХранилищаФайла - Строка - адрес временного хранилища, где размещен файл
//   Имя - Строка - имя помещаемого файла
//   Расширение - Строка - расширение помещаемого файла
//   Размер - Число - размер помещаемого файла
//   ВремяИзменения - Дата - дата и время файла на диске
//   ВремяИзмененияУниверсальное - Дата - дата и время UTC файла на диске 
//   ДокументID - не заполняется. Используется для унификации с работой 1С: Документооборота.
//   ДокументТип - не заполняется. Используется для унификации с работой 1С: Документооборота.
//
// Возвращаемое значение:
//   СправочникСсылка.Файлы или Строка (идентификатор файла ДО)
//
Функция ДобавитьФайлИзВременногоХранилища(Владелец, АдресВременногоХранилищаФайла, Имя, Расширение, Размер,
			ВремяИзменения, ВремяИзмененияУниверсальное, ДокументID = "", ДокументТип = "") Экспорт
			
	ПапкаВладелец = Константы.ПапкаСвязанныхФайлов.Получить();
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
	СведенияОФайле.Вставить("ИмяБезРасширения", Имя);
	СведенияОФайле.Вставить("ХранитьВерсии", Истина);
	СведенияОФайле.Вставить("Автор", ПараметрыСеанса.ТекущийПользователь); 
	СведенияОФайле.Вставить("РасширениеБезТочки", Расширение);
	СведенияОФайле.Вставить("ВремяИзменения", ВремяИзменения);
	СведенияОФайле.Вставить("ВремяИзмененияУниверсальное", ВремяИзмененияУниверсальное);
	СведенияОФайле.Вставить("Размер", Размер);
	СведенияОФайле.Вставить("АдресВременногоХранилищаФайла", АдресВременногоХранилищаФайла);
	СведенияОФайле.Вставить("ЗаписатьВИсторию", Истина);
	Результат = РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(
					ПапкаВладелец, СведенияОФайле);
		
	ЗаписьРегистра = РегистрыСведений.ОбъектыСвязанныхФайлов.СоздатьМенеджерЗаписи();
	ЗаписьРегистра.ИмпортированныйОбъект = Владелец;
	ЗаписьРегистра.СвязанныйФайл = Результат;
	ЗаписьРегистра.Записать(Истина);
			
	Возврат Результат;	
КонецФункции

// Возвращает файл, добавленный владельцу копированием шаблона и помещенный в ДО или в эту ИБ.
// Может приводить к автоматическому созданию связанного объекта.
//
// Параметры:
//   Владелец - ЛюбаяСсылка - объект-владелец связанных файлов или папка при хранении в этой ИБ
//   Шаблон - СправочникСсылка.Файлы - шаблон для копирования
//   ДокументID - не заполняется. Используется для унификации с работой 1С: Документооборота.
//   ДокументТип - не заполняется. Используется для унификации с работой 1С: Документооборота.
//
// Возвращаемое значение:
//   СправочникСсылка.Файлы или Строка (идентификатор файла ДО)
//
Функция ДобавитьФайлИзШаблона(Владелец, Шаблон, ДокументID = "", ДокументТип = "") Экспорт
	Если Не Шаблон.ТекущаяВерсия.Пустая() Тогда
			
		ПапкаВладелец = Константы.ПапкаСвязанныхФайлов.Получить();
		
		ДанныеФайлаИДвоичныеДанные = РаботаСФайламиСлужебныйВызовСервера
										.ДанныеФайлаИДвоичныеДанные(Шаблон.ТекущаяВерсия);
		ДвоичныеДанные = ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные;
		ХранилищеФайла = Новый ХранилищеЗначения(ДвоичныеДанные);
	
		СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
		СведенияОФайле.Вставить("ИмяБезРасширения", Шаблон.Наименование);
		СведенияОФайле.Вставить("РасширениеБезТочки", Шаблон.Расширение);
		СведенияОФайле.Вставить("Автор", ПараметрыСеанса.ТекущийПользователь); 
		СведенияОФайле.Вставить("ХранитьВерсии", Истина);
		
		СведенияОФайле.Вставить("ВремяИзменения", ТекущаяДатаСеанса());
		СведенияОФайле.Вставить("ВремяИзмененияУниверсальное", ТекущаяУниверсальнаяДата());
		СведенияОФайле.Вставить("Размер", Шаблон.ТекущаяВерсия.Размер);
		СведенияОФайле.Вставить("АдресВременногоХранилищаФайла", ХранилищеФайла);
		СведенияОФайле.Вставить("АдресВременногоХранилищаТекста", Шаблон.ТекущаяВерсия.ТекстХранилище);
		СведенияОФайле.Вставить("СсылкаНаВерсиюИсточник", Шаблон.ТекущаяВерсия);
		
		Файл = РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(ПапкаВладелец,
			СведенияОФайле);
		
		ЗаписьРегистра = РегистрыСведений.ОбъектыСвязанныхФайлов.СоздатьМенеджерЗаписи();
		ЗаписьРегистра.ИмпортированныйОбъект = Владелец;
		ЗаписьРегистра.СвязанныйФайл = Файл.Ссылка;
		ЗаписьРегистра.Записать(Истина);
		
		Возврат Файл.Ссылка;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Обновить файл, добавленный владельцу из временного хранилища и помещенный в эту ИБ.
// Может приводить к автоматическому созданию связанного объекта.
//
// Параметры:
//   Владелец - ЛюбаяСсылка - объект-владелец связанных файлов
//   АдресВременногоХранилищаФайла - Строка - адрес временного хранилища, где размещен файл
//   Имя - Строка - имя помещаемого файла
//   Расширение - Строка - расширение помещаемого файла
//   Размер - Число - размер помещаемого файла
//   ВремяИзменения - Дата - дата и время файла на диске
//   ВремяИзмененияУниверсальное - Дата - дата и время UTC файла на диске 
//   ДокументID - идентификатор связанного объекта ДО (если не передан, будет определен автоматически)
//   ДокументТип - тип связанного объекта ДО (если не передан, будет определен автоматически)
//
// Возвращаемое значение:
//   Булево - Истина, если файл обновлен успешно.
//
Функция ОбновитьФайлИзВременногоХранилища(ИдентификаторФайла, Владелец, АдресВременногоХранилищаФайла, Имя, Расширение, Размер,
			ВремяИзменения, ВремяИзмененияУниверсальное) Экспорт
			
	Результат = Ложь;
		
	ПапкаВладелец = Константы.ПапкаСвязанныхФайлов.Получить();
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
	СведенияОФайле.Вставить("ИмяБезРасширения", Имя);
	СведенияОФайле.Вставить("ХранитьВерсии", Истина);
	СведенияОФайле.Вставить("Автор", ПараметрыСеанса.ТекущийПользователь); 
	СведенияОФайле.Вставить("РасширениеБезТочки", Расширение);
	СведенияОФайле.Вставить("ВремяИзменения", ВремяИзменения);
	СведенияОФайле.Вставить("ВремяИзмененияУниверсальное", ВремяИзмененияУниверсальное);
	СведенияОФайле.Вставить("Размер", Размер);
	СведенияОФайле.Вставить("АдресВременногоХранилищаФайла", АдресВременногоХранилищаФайла);
	СведенияОФайле.Вставить("ЗаписатьВИсторию", Истина);
	
	СсылкаНаФайл = ПолучитьСсылкуНаФайл(ИдентификаторФайла);
	ВерсияФайла = РаботаСФайламиСлужебный.СоздатьВерсию(СсылкаНаФайл, СведенияОФайле);
	Если ВерсияФайла <> Неопределено Тогда
		Результат = УстановитьАктивнуюВерсиюФайла(ВерсияФайла);
	КонецЕсли;
		
	Возврат Результат;	
КонецФункции

// Возвращает массив структур, описывающих версии файла в БСП.
//
// Параметры:
//   Файл - СправочникСсылка.Файла - файл для получения версий.
//   ВключатьПомеченныеНаУдаление - Булево - Истина, если требуется получить и помеченные на удаление.
//
// Возвращаемое значение:
//   Массив - структуры, описывающие реквизиты версий файла
//
Функция ВерсииФайла(Файл, ВключатьПомеченныеНаУдаление = Ложь) Экспорт
	МассивВерсий = Новый Массив;
	
	ЗапросВерсииФайла = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВЫБОР
		|		КОГДА ВерсииФайлов.ПометкаУдаления
		|			ТОГДА ВерсииФайлов.ИндексКартинки + 1
		|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
		|	КОНЕЦ КАК ИндексКартинки,
		|	ВерсииФайлов.Наименование,
		|	ВерсииФайлов.Расширение,
		|	ВерсииФайлов.Ссылка,
		|	ВерсииФайлов.ДатаСоздания,
		|	ВерсииФайлов.Размер,
		|	ВерсииФайлов.ПометкаУдаления
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.Владелец = &Владелец");
		
	Если Не ВключатьПомеченныеНаУдаление Тогда
		ЗапросВерсииФайла.Текст = ЗапросВерсииФайла.Текст + "
		|	И НЕ ВерсииФайлов.ПометкаУдаления";
	КонецЕсли;
	
	ЗапросВерсииФайла.УстановитьПараметр("Владелец", Файл);
	Выборка = ЗапросВерсииФайла.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОписаниеВерсии = Новый Структура;
		ОписаниеВерсии.Вставить("ИндексКартинки", Выборка.ИндексКартинки);
		ОписаниеВерсии.Вставить("Наименование", Выборка.Наименование);
		ОписаниеВерсии.Вставить("Расширение", Выборка.Расширение);
		ОписаниеВерсии.Вставить("ВерсияФайла", Выборка.Ссылка);
		ОписаниеВерсии.Вставить("Идентификатор", Строка(Выборка.Ссылка.УникальныйИдентификатор()));
		ОписаниеВерсии.Вставить("ДатаСоздания", Выборка.ДатаСоздания);
		ОписаниеВерсии.Вставить("Размер", Выборка.Размер);
		ОписаниеВерсии.Вставить("ПометкаУдаления", Выборка.ПометкаУдаления);
		МассивВерсий.Добавить(ОписаниеВерсии);
	КонецЦикла;
		
	Возврат МассивВерсий;
КонецФункции

// Помечает на удаление или снимает пометку с указанного файла.
//
// Параметры:
//   ИдентификаторФайла - СправочникСсылка.Файла - файл для пометки на удаление.
//
Процедура ПометитьНаУдалениеСнятьПометку(ИдентификаторФайла) Экспорт
	СсылкаНаФайл = ПолучитьСсылкуНаФайл(ИдентификаторФайла);
	
	Если ЗначениеЗаполнено(СсылкаНаФайл) Тогда
		ФайлОбъект = СсылкаНаФайл.ПолучитьОбъект();
		Если ЗначениеЗаполнено(СсылкаНаФайл.Редактирует) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файл ""%1"" не может быть удален, так как занят
					|для редактирования пользователем %2.'"),
				Строка(ФайлОбъект),
				Строка(ФайлОбъект.Редактирует));
		КонецЕсли;
		ФайлОбъект.Заблокировать();
		ФайлОбъект.УстановитьПометкуУдаления(Не ФайлОбъект.ПометкаУдаления);
	КонецЕсли;
КонецПроцедуры

// Изменить пометку на удаление для файлов принадлежащих Владельцу.
//
// Параметры:
//	ПометкаНаУдаление - Булево, Истина - установить, Ложь - снять пометку на удаление.
//	Владелец - ЛюбаяСсылка - объект-владелец связанных файлов.
//	ДокументID - идентификатор связанного объекта ДО (если не передан, будет определен автоматически).
//	ДокументТип - тип связанного объекта ДО (если не передан, будет определен автоматически).
//
Процедура ПометитьНаУдалениеПоВладельцу(ПометкаНаУдаление, Владелец, ДокументID = "", ДокументТип = "") Экспорт
	мФайлы = СвязанныеФайлыПоВладельцу(Владелец, ДокументID, ДокументТип, НЕ ПометкаНаУдаление);
	
	Для Каждого ОписаниеФайла Из мФайлы Цикл
		Если ОписаниеФайла.ПометкаУдаления <> ПометкаНаУдаление Тогда
			ПометитьНаУдалениеСнятьПометку(ОписаниеФайла.СвязанныйФайл);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Получить ссылку на файл по его идентификатору.
// Необходима для унифицированной обработки идентификатора файла,
// с целью последующей передачи в другие функции.
//
// Параметры:
//   ИдентификаторФайла - СправочникСсылка.Файла, Строка - ссылка на файл
//		или уникальный идентификатор элемента справочника.
//
// Возвращает:
//	Строка, если используется документооборот, то возвращает переданный идентификатор файла.
//	СправочникСсылка.Файлы - если используется внутреннее хранение файлов.
Функция ПолучитьСсылкуНаФайл(ИдентификаторФайла) Экспорт
	Если ТипЗнч(ИдентификаторФайла) = Тип("СправочникСсылка.Файлы")
		ИЛИ ТипЗнч(ИдентификаторФайла) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		Возврат ИдентификаторФайла; // это уже ссылка
	КонецЕсли;
		
	Возврат Справочники.Файлы.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторФайла));
КонецФункции

// Получить строку уникального идентификатора элемента справочника Файлы.
//
// Параметры:
//	СсылкаНаФайл - СпрвочникСсылка.Файлы - ссылка на файл, помещенный в базу.
//
// Возвращает:
//	Строка - уникальный идентификатора элемента справочника Файлы
//
Функция ПолучитьИдентификаторФайлаПоСсылке(СсылкаНаФайл) Экспорт
	Если ТипЗнч(СсылкаНаФайл) = Тип("СправочникСсылка.Файлы") Тогда
		Возврат Строка(СсылкаНаФайл.УникальныйИдентификатор());
	КонецЕсли;
		
	Возврат СсылкаНаФайл;
КонецФункции

// Получить данные для открытия функцией СвязанныеФайлыКлиент.ОткрытьФайлДляПросмотра(ДанныеФайла)
Функция ПолучитьДанныеФайлаДляОткрытия(ИдентификаторФайла, УникальныйИдентификаторФормы) Экспорт
	СвязанныйФайл = ПолучитьСсылкуНаФайл(ИдентификаторФайла);
	
	Если ТипЗнч(ИдентификаторФайла) = Тип("СправочникСсылка.ВерсииФайлов") Тогда
		ВладелецСвязанногоФайла = СвязанныйФайл.Владелец;
		
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(
			ВладелецСвязанногоФайла, СвязанныйФайл, УникальныйИдентификаторФормы);
	Иначе
		ДанныеФайла = РаботаСФайлами.ДанныеФайла(СвязанныйФайл, УникальныйИдентификаторФормы);
	КонецЕсли;
	
	ДанныеФайла.Вставить("ИспользоватьИнтеграциюС1СДокументооборот", Ложь);
	
	Возврат ДанныеФайла;
КонецФункции


#КонецОбласти


#Область ВнутренниеПроцедурыФункции


// Сделать версию файла текущей. Только для варианта внутреннего хранения файлов.
// Параметры:
//	Версия - СправочникСсылка.ВерсииФайлов, версия, которую устанавливаем текущей.
//
// Возвращает:
//	Булево, Истина - операция выполнена успешно. Ложь - операция не выполнена.
//
Функция УстановитьАктивнуюВерсиюФайла(Версия)
	НачатьТранзакцию();
	Результат = Истина;
	Попытка
		ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка);
		ФайлОбъект.ТекущаяВерсия = Версия;
		ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
		ФайлОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка);
		
		ВерсияОбъект = Версия.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(Версия);
		ВерсияОбъект.Записать();
		РазблокироватьДанныеДляРедактирования(Версия);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		Результат = Ложь;
		ОтменитьТранзакцию();
	КонецПопытки;
	
	Возврат Результат;
КонецФункции


#КонецОбласти