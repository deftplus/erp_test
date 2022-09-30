
#Область ПрограммныйИнтерфейс

#Область НастройкиКомпоновкиДанныхВидовЦен

// Возвращает параметров, которые можно изменить в настройках схемы компоновки данных.
//
// Возвращаемое значение:
//  Массив - Имена параметров
//
Функция ИменаРазрешенныхПараметровСхемКомпоновкиДанных() Экспорт
	
	РазрешенныеИмена = Новый Массив;
	РазрешенныеИмена.Добавить("ДатаДокумента");
	РазрешенныеИмена.Добавить("ЭтоВводНаОсновании");
	РазрешенныеИмена.Добавить("ВидЦены");
	РазрешенныеИмена.Добавить("Основание");
	
	РазрешенныеИмена.Добавить("ИспользуетсяОтборПоСегментуНоменклатуры");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки1");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки2");
	РазрешенныеИмена.Добавить("ТекстЗапросаКоэффициентУпаковки3");
	
	Возврат РазрешенныеИмена;
	
КонецФункции

// Возвращает параметров, для которых оставлять пустые значение в настройках схемы компоновки данных.
//
// Возвращаемое значение:
//  Массив - Имена параметров
//
Функция ИменаПараметровСхемКомпоновкиДанныхСРазрешеннымиПустымиЗначениями(РазрешенныеИмена = Неопределено) Экспорт
	
	Если РазрешенныеИмена = Неопределено Тогда
		РазрешенныеИмена = Новый Массив;
	КонецЕсли;	
		
	РазрешенныеИмена.Добавить("ГлубинаАнализа");
	
	Возврат РазрешенныеИмена;
	
КонецФункции

// Проверяет заполненность обязательных параметров схемы компоновки данных
//
// Параметры:
//  ВидЦены - СправочникСсылка.ВидыЦен - Ссылка на вид цены, для которого нужно описание параметров
//  НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных - Настройки компоновки данных
//  ПараметрыСхемКомпоновкиДанныхВидовЦен - ТаблицаЗначений - Таблица параметров схем компоновки данных видов цен
//
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * ОписаниеПараметров - Строка - Описание параметров.
//
Функция ОписаниеПараметровСхемыКомпоновкиДанных(ВидЦены,
	                                            НастройкиКомпоновкиДанных,
	                                            ПараметрыСхемКомпоновкиДанныхВидовЦен) Экспорт
	
	Для Каждого Элемент Из НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы Цикл
		НайденныеСтроки = ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(
			Новый Структура("Имя, ВидЦены", Строка(Элемент.Параметр), ВидЦены));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.Значение      = Элемент.Значение;
			НайденнаяСтрока.Использование = Элемент.Использование;
		КонецЦикла;
	КонецЦикла;
	
	ОписаниеПараметров = "";
	МассивПараметровСхемКомпоновкиДанныхВидовЦен = ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(Новый Структура("ВидЦены", ВидЦены)); // Массив из ПараметрСхемыКомпоновкиДанных
	Для Каждого Параметр Из МассивПараметровСхемКомпоновкиДанныхВидовЦен Цикл
		
		ЗначениеПараметра = Неопределено;
		Если ЗначениеЗаполнено(Параметр.Использование) Тогда
			Если Параметр.ДоступныеЗначения = Неопределено Тогда
				ЗначениеПараметра = Параметр.Значение;
			Иначе
				ДоступноеЗначение = Параметр.ДоступныеЗначения.НайтиПоЗначению(Параметр.Значение);
				Если ДоступноеЗначение <> Неопределено Тогда
					ЗначениеПараметра = ?(ЗначениеЗаполнено(
						ДоступноеЗначение.Представление), ДоступноеЗначение.Представление, Параметр.Значение);
				Иначе
					ЗначениеПараметра = Параметр.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ОписаниеПараметров = ?(ЗначениеЗаполнено(ОписаниеПараметров), ОписаниеПараметров, НСтр("ru = 'Параметры:';
																								|en = 'Parameters:'") + " ")
		                   + ?(Не ЗначениеЗаполнено(ОписаниеПараметров), "" , ", ")
		                   + Параметр.Заголовок
		                   + " = "
		                   + ?(ЗначениеЗаполнено(ЗначениеПараметра), Строка(ЗначениеПараметра), НСтр("ru = '<не заполнен>';
																									|en = '<Not filled in>'"));
	КонецЦикла;
	
	ОписаниеПараметров = ОписаниеПараметров
	                   + ?(ЗначениеЗаполнено(Строка(НастройкиКомпоновкиДанных.Отбор)),
	                      " " + НСтр("ru = 'Отбор:';
									|en = 'Filter:'") + " " + Строка(НастройкиКомпоновкиДанных.Отбор),
	                      "");
	
	Возврат Новый Структура("ОписаниеПараметров", ОписаниеПараметров);
	
КонецФункции

// Возвращает имена и типы полей, которые должны обязательно присутствовать
// в СКД, используемой для заполнения цен по данным ИБ.
//
// Возвращаемое значение:
//  Соответствие - В ключах содержатся имена полей, в значениях - типы полей.
//
Функция ПолучитьОбязательныеПоляСхемыКомпоновкиДанных() Экспорт
	
	Поля = Новый Соответствие();
	
	Поля.Вставить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		Поля.Вставить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	
	Возврат Поля;
	
КонецФункции // ПолучитьОбязательныеПоляСхемыКомпоновкиДанных()

// Проверяет заполненность обязательных параметров схемы компоновки данных
//
// Параметры:
//  ВыбранныеЦены - Массив из СправочникСсылка.ВидыЦен - Массив видов цен, для которых нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Строка, УникальныйИдентификатор - Адрес с настройками компоновки данных для вида цены
//  АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен - Строка, УникальныйИдентификатор - Адрес с настройками параметров 
//                                                     настроек компоновки данных для всех видов цен.
//
// Возвращаемое значение:
//  Массив из Структура - Массив описаний найденных ошибок:
//  * ВидЦены - СправочникСсылка.ВидыЦен - Вид цены
//  * Описание - Строка - Описание
//
Функция ПроверитьЗаполненностьОбязательныхПараметровСхемыКомпоновкиДанных(ВыбранныеЦены,
	                                                                      АдресХранилищаНастройкиКомпоновкиДанных,
	                                                                      АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен) Экспорт
	
	Ошибки = Новый Массив;
	
	РазрешенныеИмена = ИменаРазрешенныхПараметровСхемКомпоновкиДанных();
	РазрешенныеИмена = ИменаПараметровСхемКомпоновкиДанныхСРазрешеннымиПустымиЗначениями(РазрешенныеИмена);
	
	ПараметрыСхемКомпоновкиДанныхВидовЦен = ПолучитьИзВременногоХранилища(АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен);
	ТаблицаНастройкиКомпоновкиДанных      = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных); // см. УстановкаЦенСервер.ЗагрузитьТаблицуНастройкиКомпоновкиДанных
	
	Для Каждого ВидЦены Из ВыбранныеЦены Цикл
		НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
		Если НайденнаяСтрока = Неопределено Тогда
			Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не заполнены обязательные параметры для вида цены ""%1""';
					|en = 'Parameters for the ""%1"" price type are required'"),
				Строка(ВидЦены));
			Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
		Иначе
			НайденныеСтроки = ПараметрыСхемКомпоновкиДанныхВидовЦен.НайтиСтроки(Новый Структура("ВидЦены", ВидЦены)); // Массив из ПараметрСхемыКомпоновкиДанных
			Для Каждого ПараметрДанных Из НайденныеСтроки Цикл
				
				ПроверкаВыполнена = Ложь;
				
				Для Каждого СтрокаТЧ Из НайденнаяСтрока.НастройкиКомпоновкиДанных.ПараметрыДанных.Элементы Цикл
					Если Строка(СтрокаТЧ.Параметр) = ПараметрДанных.Имя Тогда
						Если Не ЗначениеЗаполнено(СтрокаТЧ.Значение)
							И РазрешенныеИмена.Найти(ПараметрДанных.Имя) = Неопределено Тогда
							Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
								НСтр("ru = 'Не заполнено значение параметра ""%1"" для вида цены ""%2""';
									|en = 'Value of ""%1"" parameter is required for the ""%2"" price type'"),
								ПараметрДанных.Заголовок,
								Строка(ВидЦены));
							Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
						КонецЕсли;
						ПроверкаВыполнена = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если Не ПроверкаВыполнена Тогда
					
					Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не заполнено значение параметра ""%1"" для вида цены ""%2""';
							|en = 'Value of ""%1"" parameter is required for the ""%2"" price type'"),
						ПараметрДанных.Заголовок,
						Строка(ВидЦены));
					Ошибки.Добавить(Новый Структура("ВидЦены, Описание", ВидЦены, Описание));
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ошибки;
	
КонецФункции

// Возвращает адрес настроек компоновки данных для вида цены по умолчанию
//
// Параметры:
//  ВидЦены - СправочникСсылка.ВидыЦен - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресСхемыКомпоновкиДанных - Строка - Адрес с настройками компоновки данных для всех видов цены формы
//  УникальныйИдентификатор - УникальныйИдентификатор - Уникальный идентификатор формы.
//
// Возвращаемое значение:
//  Строка - Адрес настроек компоновки данных для вида цены.
//
Функция НастройкиСхемыКомпоновкиДанныхПоУмолчанию(ВидЦены,
	                                              АдресСхемыКомпоновкиДанных,
	                                              УникальныйИдентификатор) Экспорт
	
	НастройкиКомпоновкиДанных = ВидЦены.ХранилищеНастроекКомпоновкиДанных.Получить();

	НастройкиКомпоновкиДанныхОтбораПоНоменклатуре = ВидЦены.ХранилищеНастроекКомпоновкиДанныхОтбораПоНоменклатуре.Получить();
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	Если Не ЗначениеЗаполнено(НастройкиКомпоновкиДанных) Тогда
		
		КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
		УстановитьПривилегированныйРежим(Истина);
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
		УстановитьПривилегированныйРежим(Ложь);
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		
		Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификатор);
		
	Иначе
		
		Если ЗначениеЗаполнено(НастройкиКомпоновкиДанныхОтбораПоНоменклатуре) Тогда
			КомпоновкаДанныхКлиентСервер.СкопироватьОтборКомпоновкиДанных(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, НастройкиКомпоновкиДанныхОтбораПоНоменклатуре);
		КонецЕсли;
		
		Возврат ПоместитьВоВременноеХранилище(НастройкиКомпоновкиДанных, УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

// Устанавливает настройки компоновки данных для вида цены
//
// Параметры:
//  ВидЦены - СправочникСсылка.ВидыЦен - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастроекДляВидаЦены - Строка - Адрес с настройками компоновки данных для вида цены
//  АдресХранилищаНастройкиКомпоновкиДанных - Строка - Адрес с настройками компоновки данных для всех видов цен
//  АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен - Строка - Адрес с настройками параметров схем компоновки данных
//
// Возвращаемое значение:
//  Структура - Описание параметров схемы компоновки данных.
//
Функция УстановитьНастройкиКомпоновкиДанныхДляВидаЦены(ВидЦены,
	                                                   АдресХранилищаНастроекДляВидаЦены,
	                                                   АдресХранилищаНастройкиКомпоновкиДанных,
	                                                   АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен) Экспорт
	
	НастройкиКомпоновкиДанных        = ПолучитьИзВременногоХранилища(АдресХранилищаНастроекДляВидаЦены);
	ТаблицаНастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных);
	
	НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
	Если НайденнаяСтрока = Неопределено Тогда
		НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Добавить();
		НайденнаяСтрока.ВидЦены = ВидЦены;
	КонецЕсли;
	НайденнаяСтрока.НастройкиКомпоновкиДанных = НастройкиКомпоновкиДанных;
	
	ПоместитьВоВременноеХранилище(ТаблицаНастройкиКомпоновкиДанных, АдресХранилищаНастройкиКомпоновкиДанных);
	
	ПараметрыСхемКомпоновкиДанныхВидовЦен = ПолучитьИзВременногоХранилища(АдресХранилищаПараметровСхемКомпоновкиПоВидамЦен);
	Возврат ОписаниеПараметровСхемыКомпоновкиДанных(ВидЦены, НастройкиКомпоновкиДанных, ПараметрыСхемКомпоновкиДанныхВидовЦен);
	
КонецФункции

// Возвращает адрес настроек компоновки данных для вида цены
//
// Параметры:
//  ВидЦены - СправочникСсылка.ВидыЦен - Ссылка на вид цены, для которого нужно получить адрес настроек компоновки данных
//  АдресХранилищаНастройкиКомпоновкиДанных - Строка - Адрес с настройками компоновки данных для всех видов цены формы
//  УникальныйИдентификатор - УникальныйИдентификатор - Уникальный идентификатор формы
//
// Возвращаемое значение:
//  Строка - адрес настроек компоновки данных для вида цены.
//
Функция АдресНастроекКомпоновкиДанныхДляВидаЦены(ВидЦены,
	                                             АдресХранилищаНастройкиКомпоновкиДанных,
	                                             УникальныйИдентификатор) Экспорт
	
	ТаблицаНастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресХранилищаНастройкиКомпоновкиДанных);
	
	НайденнаяСтрока = ТаблицаНастройкиКомпоновкиДанных.Найти(ВидЦены, "ВидЦены");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ПоместитьВоВременноеХранилище(НайденнаяСтрока.НастройкиКомпоновкиДанных, УникальныйИдентификатор);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область РаботаСExcel

// Возвращает номер документа в пределах дня
//
// Параметры:
//  МассивДокументов - Массив - документы для выгрузки
//  УникальныйИдентификатор - УникальныйИдентификатор - Уникальный идентификатор формы
//  ПараметрыПечати - Структура - параметры печати, используемые при подготовке документов к выгрузке.
//
// Возвращаемое значение:
//  Массив из Структура - Данные о созданных файлах.
//
Функция ВыгрузитьВExcel(МассивДокументов, УникальныйИдентификатор, ПараметрыПечати) Экспорт
	
	ВозвращаемыеДанные = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого Документ Из МассивДокументов Цикл
	
		АдресФайлаВоВременномХранилище = ВыгрузитьВExcelБезСсылки(Документ, УникальныйИдентификатор, ПараметрыПечати);
		
		ПараметрыФайла = Новый Структура();
		ПараметрыФайла.Вставить("Автор", Пользователи.АвторизованныйПользователь());
		ПараметрыФайла.Вставить("ВладелецФайлов", Документ);
		ПараметрыФайла.Вставить("ИмяБезРасширения", "Excel" + " " + Формат(ТекущаяДатаСеанса(), НСтр("ru = 'ДФ=''dd.MM.yyyy ЧЧ.мм.сс''';
																									|en = 'DF=''MM.dd.yyyy HH.mm.ss'''")));
		ПараметрыФайла.Вставить("РасширениеБезТочки", "xls");
		ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ТекущаяДатаСеанса());
		
		Файл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайлаВоВременномХранилище, Неопределено);
			
		Если Файл <> Неопределено Тогда
			РаботаСФайламиСлужебный.ЗанятьФайлДляРедактированияСервер(Файл);
			ДанныеФайла = РаботаСФайлами.ДанныеФайла(Файл, УникальныйИдентификатор, Истина);
			СтрокаДанных = Новый Структура("ДанныеФайла, Файл", ДанныеФайла, Файл);
			ВозвращаемыеДанные.Добавить(СтрокаДанных);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат ВозвращаемыеДанные;
	
КонецФункции

// Возвращает номер документа в пределах дня
//
// Параметры:
//  Документ - ДокументСсылка - документы для выгрузки
//  УникальныйИдентификатор - УникальныйИдентификатор - Уникальный идентификатор формы
//  ПараметрыПечати - Структура - параметры печати, используемые при подготовке документов к выгрузке.
//
// Возвращаемое значение:
//  Массив из Структура - Данные о созданных файлах.
//
Функция ВыгрузитьВExcelБезСсылки(Документ, УникальныйИдентификатор, ПараметрыПечати) Экспорт
	
	МассивОбъектов = Новый Массив;
	ОбъектыПечати  = Новый СписокЗначений;
	
	МассивОбъектов.Добавить(Документ);
	ОбъектыПечати.Добавить(Документ);
	
	ТабличныйДокумент = Документы.УстановкаЦенНоменклатуры.СформироватьПечатнуюФормуУстановкиЦенНоменклатуры(
		МассивОбъектов,
		ОбъектыПечати,
		ПараметрыПечати);
		
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ТабличныйДокумент.Записать(ИмяВременногоФайла, ТипФайлаТабличногоДокумента.XLS97);
	
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(
		Новый ДвоичныеДанные(ИмяВременногоФайла), УникальныйИдентификатор);
	
	Попытка
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		
		ТекстИсключения = НСтр("ru = '%1';
								|en = '%1'", ОбщегоНазначения.КодОсновногоЯзыка());
		ТекстИсключения = СтрШаблон(ТекстИсключения, "УстановкаЦенНоменклатуры.ВыгрузкаВExcel");
		
		ЗаписьЖурналаРегистрации(ТекстИсключения,
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Документы.УстановкаЦенНоменклатуры,,
			ОписаниеОшибки());
	КонецПопытки;
	
	Возврат АдресФайлаВоВременномХранилище;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Возвращает номер документа в пределах дня
//
// Параметры:
//  ДатаДокумента - Дата - Дата, на которую нужно рассчитать номер
//  Ссылка - ДокументСсылка.УстановкаЦенНоменклатуры - Ссылка на документ установки цен
//
// Возвращаемое значение:
//  Число - Номер документа
//
Функция РассчитатьНомерВПределахДня(ДатаДокумента, Ссылка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(Т.Период), ДАТАВРЕМЯ(1, 1, 1)) КАК Дата
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК Т
	|ГДЕ
	|	Т.Регистратор <> &Ссылка
	|	И Т.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(МАКСИМУМ(Т2.Период), ДАТАВРЕМЯ(1, 1, 1))
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры25 КАК Т2
	|ГДЕ
	|	Т2.Регистратор <> &Ссылка
	|	И Т2.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|УПОРЯДОЧИТЬ ПО
	|	Дата УБЫВ");
	
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ДатаДокумента));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ДатаДокумента));
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.Дата) Тогда
		// Начало дня - 0 секунда. Так как как минимум один документ уже существует, то
		// нужно прибавить 1 (0 секунда соответствует номеру документа 1).
		// Так же прибавим единицу, так как нам требуется номер следующего документа.
		Возврат Выборка.Дата - НачалоДня(ДатаДокумента) + 2;
	Иначе
		Возврат 1;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти
