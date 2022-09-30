#Область СобытияМодуляФормы

#Область ФормаДокумента

#Область СтандартныеОбработчики
	
// нетиповое событие документа. Вызывается перед исполнением основного кода
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	
	// Создаем необходимые реквизиты
	СоздатьРеквизитыФормыДокумента(Форма);
	
	// 
	СоздатьЭлементыФормыДокумента(Форма);
	
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи) Экспорт
	
	АналитикиСтатейБюджетовУХ.ЗаполнитьРеквизитыАналитикВсехСтатей(Форма);
	
КонецПроцедуры

Функция ПолучитьБлокируемыеРеквизитыОбъекта(Результат) Экспорт
	
	Результат.Добавить("ОсновнаяВалютаПлатежей");
	Результат.Добавить("ЗапретПлатежаВПрочихВалютах");
	Результат.Добавить("СпособОпределенияКурсаПлатежа");
	Результат.Добавить("ДатаФиксацииКурсаПлатежа");
	Результат.Добавить("СдвигДатыФиксацииКурсаПлатежа");
	Результат.Добавить("КурсПлатежа");
	Результат.Добавить("КратностьПлатежа");
	Результат.Добавить("КурсПлатежаНеМенее");
	Результат.Добавить("КурсПлатежаНеБолее");
	Результат.Добавить("КурсПлатежаНеМенееВВалютеОплаты");
	Результат.Добавить("КурсПлатежаНеБолееВВалютеОплаты");
	Результат.Добавить("ФиксированныйСчет");
	Результат.Добавить("ФиксированныйСчетПолучателя");
	Результат.Добавить("АналитикаБДДС1");
	Результат.Добавить("АналитикаБДДС2");
	Результат.Добавить("АналитикаБДДС3");
	Результат.Добавить("АналитикаПолучателя1");
	Результат.Добавить("АналитикаПолучателя2");
	Результат.Добавить("АналитикаПолучателя3");
	Результат.Добавить("ОсновнойЦФО");
	Результат.Добавить("ОсновнойПроект");
	Результат.Добавить("ЦФОПолучателя");
	Результат.Добавить("ПроектПолучателя");
	
КонецФункции

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьРеквизитыФормыДокумента(Форма)
	
	//
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	////
	//Реквизиты = Новый Массив;
	//Реквизиты.Добавить(Новый РеквизитФормы("ЕстьСуперПользователь",			Новый ОписаниеТипов("Булево")));
	//Форма.ИзменитьРеквизиты(Реквизиты);
	
КонецПроцедуры

Процедура СоздатьЭлементыФормыДокумента(Форма) 
	
	Если ФормыУХ.ЭлементыФормыУХУжеСозданы(Форма) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	//
	ФормыУХ.ЭлементыФормыУХДобавлены(Форма);
	ПараметрыЭлементов = ПолучитьПараметрыЭлементов();
	
	#Область АналитикиСтатьиБюджета
		
	// Статьи бюджетов
	АСБ = АналитикиСтатейБюджетовУХ;
	МассивОписанийСтатей = Новый Массив;
	
	// Статья в шапке документа Статья и Аналитика в Объекте (ВидАналитики нельзя создать в реквизите формы Объект. Должны быть созданы реквизиты формы)
	ДанныеАналитикиШапки = АСБ.Новый_АналитикиСтатьиБюджета("АналитикаБДДС%1", "Объект", "");
	ПараметрыСтатьиШапки = АСБ.Новый_СтатьяБюджетов("СтатьяДвиженияДенежныхСредств", "Объект", ДанныеАналитикиШапки);
	
	ИмяЭлемента = Элементы.СтатьяДвиженияДенежныхСредств.Имя;
	ИмяРодителя = Элементы.СтатьяДвиженияДенежныхСредств.Родитель.Имя;
	АСБ.СтатьяБюджета_НовыйЭлементФормы(ПараметрыСтатьиШапки, ИмяЭлемента, "Объект", ИмяРодителя);
	АСБ.СтатьяБюджетов_ЭлементыАналитикиИзШаблона(ПараметрыСтатьиШапки, ИмяЭлемента, "АналитикаБДДС%1", "Объект", "");
	
	//
	МассивОписанийСтатей.Добавить(ПараметрыСтатьиШапки);
	
	// СтатьяДвиженияДенежныхСредствПолучателя в шапке документа
	ДанныеАналитикиШапкиЗачисление = АСБ.Новый_АналитикиСтатьиБюджета("АналитикаПолучателя%1", "Объект", "");
	ПараметрыСтатьиШапкиЗачисление = АСБ.Новый_СтатьяБюджетов("СтатьяДвиженияДенежныхСредствПолучателя", "Объект", ДанныеАналитикиШапкиЗачисление);
	
	ИмяЭлемента = Элементы.СтатьяДвиженияДенежныхСредствПолучателя.Имя;
	ИмяРодителя = Элементы.СтатьяДвиженияДенежныхСредствПолучателя.Родитель.Имя;
	АСБ.СтатьяБюджета_НовыйЭлементФормы(ПараметрыСтатьиШапкиЗачисление, ИмяЭлемента, "Объект", ИмяРодителя);
	АСБ.СтатьяБюджетов_ЭлементыАналитикиИзШаблона(ПараметрыСтатьиШапкиЗачисление, ИмяЭлемента, "АналитикаПолучателя%1", "Объект", "");
	
	//
	МассивОписанийСтатей.Добавить(ПараметрыСтатьиШапкиЗачисление);
	
	// Создать элементы формы для статей бюджетов и их аналитик
	АналитикиСтатейБюджетовУХ.СоздатьСтатьиБюджетовИАналитики(Форма, МассивОписанийСтатей, ПараметрыЭлементов.ПолеВвода28);
	#КонецОбласти 
	
	//
	Родитель = Элементы.ГруппаОрганизация;
	Куда = неопределено;
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "ЦФО",		, "Объект.ОсновнойЦФО",,	Родитель, Куда, ПараметрыЭлементов.ПолеВвода28);
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "Проект",	, "Объект.ОсновнойПроект",,	Родитель, Куда, ПараметрыЭлементов.ПолеВвода28);
	
	//
	Родитель = Элементы.ГруппаОрганизацияПолучатель;
	Куда = неопределено;
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "ЦФОПолучателя",	, "Объект.ЦФОПолучателя",,		Родитель, Куда, ПараметрыЭлементов.ПолеВвода28);
	Элемент = ФормыУХ.СоздатьПолеФормы(Элементы, "ПроектПолучателя",, "Объект.ПроектПолучателя",,	Родитель, Куда, ПараметрыЭлементов.ПолеВвода28);
	
	// Фиксированный счет поставщика и покупателя
	Куда = Элементы.БанковскийСчет;
	ГруппаБанковскийСчет			= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаБанковскийСчет", ,,Куда.Родитель,Куда,ПараметрыЭлементов.ГруппаГ);
	Элементы.Переместить(Куда, ГруппаБанковскийСчет);
	ФормыУХ.СоздатьПолеФормы(Элементы, "ФиксированныеСчет", НСтр("ru = 'Фикс.'"), "Объект.ФиксированныйСчет", ВидПоляФормы.ПолеФлажка, Куда.Родитель);
	
	// Фиксированный счет поставщика и покупателя
	Куда = Элементы.БанковскийСчетПолучателя;
	ГруппаБанковскийСчетПолучателя	= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаБанковскийСчетПолучателя", ,,Куда.Родитель,Куда, ПараметрыЭлементов.ГруппаГ);
	Элементы.Переместить(Куда, ГруппаБанковскийСчетПолучателя);
	ФормыУХ.СоздатьПолеФормы(Элементы, "ФиксированныеСчетПолучателя", НСтр("ru = 'Фикс.'"), "Объект.ФиксированныйСчетПолучателя", ВидПоляФормы.ПолеФлажка, Куда.Родитель);
	
	Элементы.ГруппаСтороныДоговора.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	Элементы.ГруппаОрганизация.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	Элементы.ГруппаОрганизация.Объединенная = Истина;
	Элементы.ГруппаОрганизацияПолучатель.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	Элементы.ГруппаОрганизацияПолучатель.Объединенная = Истина;
	ГруппаБанковскийСчет.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	ГруппаБанковскийСчет.Объединенная = Истина;
	ГруппаБанковскийСчетПолучателя.СквозноеВыравнивание = СквозноеВыравнивание.Использовать;
	ГруппаБанковскийСчетПолучателя.Объединенная = Истина;
	
	СоздатьЭлементыГруппуКурсПлатежейПоДоговору(Форма, ПараметрыЭлементов, Элементы.ГруппаПорядокРасчетовПоДоговору,);
	
	ФормыУХ.СоздатьПолеФормы(Элементы, "ПриоритетПлатежа", НСтр("ru = 'Приоритет'"), "Объект.ПриоритетПлатежа", 
							ВидПоляФормы.ПолеВвода, Элементы.ГруппаПодвал,,ПараметрыЭлементов.ПолеВвода28);
	
	
КонецПроцедуры

Функция ПолучитьПараметрыЭлементов()
	
	ПараметрыЭлементов = ФормыУХ.ПолучитьПараметрыЭлементовПоУмолчанию();
	ПараметрыЭлементов.ГруппаВ.ОтображатьЗаголовок  = Ложь;
	ПараметрыЭлементов.ГруппаГ.ОтображатьЗаголовок  = Ложь;
	
	Возврат ПараметрыЭлементов;
	
КонецФункции

Процедура СоздатьЭлементыГруппуКурсПлатежейПоДоговору(Форма, ПараметрыЭлементов, Родитель, Куда)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	СоздатьРеквизитыФормыГруппыКурсПлатежейПоДоговору(Форма);
	
	БезЗаголовка = Новый Структура("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	НадписьВалюта = Новый Структура;
	НадписьВалюта.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	НадписьВалюта.Вставить("РастягиватьПоГоризонтали", Ложь);
	НадписьВалюта.Вставить("Ширина", 3);
	
	//
	Действия = Новый Структура("ПриИзменении", "Подключаемый_ПриИзмененииРеквизитовГруппыКурсПлатежейПоДоговору");
	
	// Валюта платежей
	ГруппаВалютаПлатежей = ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаОсновнаяВалютаПлатежей", НСтр("ru = 'Курс оплаты'"),, Родитель,, ПараметрыЭлементов.ГруппаГ);
	ФормыУХ.СоздатьПолеФормы(Элементы, "ОсновнаяВалютаПлатежей", НСтр("ru = 'Валюта платежей'"), "Объект.ОсновнаяВалютаПлатежей",, ГруппаВалютаПлатежей,,, Действия);
	ФормыУХ.СоздатьПолеФормы(Элементы, "ЗапретПлатежаВПрочихВалютах", НСтр("ru = 'Запрет платежей в прочих валютах'"), "Объект.ЗапретПлатежаВПрочихВалютах", ВидПоляФормы.ПолеФлажка, ГруппаВалютаПлатежей);
	
	// Курс платежей по договору
	ГруппаКурсПлатежа = ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКурсПлатежа", НСтр("ru = 'Курс оплаты'"),,Родитель,,ПараметрыЭлементов.ГруппаВ);
	ГруппаКурсПлатежа.ОтображатьЗаголовок = Истина;
	ГруппаКурсПлатежа.Поведение = ПоведениеОбычнойГруппы.Свертываемая;
	ГруппаКурсПлатежа.ОтображениеУправления = ОтображениеУправленияОбычнойГруппы.Картинка;
	ГруппаКурсПлатежа.ВертикальныйИнтервал = ИнтервалМеждуЭлементамиФормы.Половинный;
	
	ГруппаКурс				= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКурс", НСтр("ru = 'Курс оплаты'"),,ГруппаКурсПлатежа,,ПараметрыЭлементов.ГруппаГ);
	ГруппаФиксКурс			= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаФиксированныйКурс",,,ГруппаКурсПлатежа,,ПараметрыЭлементов.ГруппаГ);
	ГруппаКоридор			= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКоридор",,,ГруппаКурсПлатежа,,ПараметрыЭлементов.ГруппаВ);
	// 
	ГруппаКоридорНеМенее	= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКоридорНеМенее",,,ГруппаКоридор,,ПараметрыЭлементов.ГруппаГ);
	ГруппаКориодорНеБолее	= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКориодорНеБолее",,,ГруппаКоридор,,ПараметрыЭлементов.ГруппаГ);
	
	//ГруппаКурс
	СпособОпределенияКурса	= ФормыУХ.СоздатьПолеФормы(Элементы, "СпособОпределенияКурса",, "Объект.СпособОпределенияКурсаПлатежа",,ГруппаКурс,, БезЗаголовка, Действия);
	ГруппаКурсНаДатуПлатежа	= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКурсНаДатуПлатежа",,,ГруппаКурс,,ПараметрыЭлементов.ГруппаГ);
	НадписьМинус			= ФормыУХ.СоздатьДекорациюФормы(Элементы, "НадписьМинус", НСтр("ru = '-'"),,ГруппаКурсНаДатуПлатежа);
	СдвигДатыФиксации		= ФормыУХ.СоздатьПолеФормы(Элементы, "СдвигДатыФиксацииКурсаПлатежа",,"Объект.СдвигДатыФиксацииКурсаПлатежа",,ГруппаКурсНаДатуПлатежа,, БезЗаголовка);
	НадписьДней				= ФормыУХ.СоздатьДекорациюФормы(Элементы, "НадписьДней", НСтр("ru = 'дн.'"),,ГруппаКурсНаДатуПлатежа);
	ГруппаКурсНаФиксДату	= ФормыУХ.СоздатьГруппуФормы(Элементы, "ГруппаКурсНаФиксированнуюДату",,,ГруппаКурс,,ПараметрыЭлементов.ГруппаГ);
	ДатаФиксацииКурсаПлатежа= ФормыУХ.СоздатьПолеФормы(Элементы, "ДатаФиксацииКурсаПлатежа",, "Объект.ДатаФиксацииКурсаПлатежа",,ГруппаКурсНаФиксДату,, БезЗаголовка);
	
	//ГруппаФиксированныйКурс
	КурсПлатежа				= ФормыУХ.СоздатьПолеФормы(Элементы, "КурсПлатежа",, "Объект.КурсПлатежа",, ГруппаФиксКурс,, БезЗаголовка);
	ВалютаПлатежейНадпись1	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаПлатежейНадпись1",, "Объект.ОсновнаяВалютаПлатежей", ВидПоляФормы.ПолеНадписи, ГруппаФиксКурс,, НадписьВалюта);
	НадписьЗа				= ФормыУХ.СоздатьДекорациюФормы(Элементы, "НадписьЗа", НСтр("ru = 'за'"),,ГруппаФиксКурс);
	КратностьПлатежа		= ФормыУХ.СоздатьПолеФормы(Элементы, "КратностьПлатежа",, "Объект.КратностьПлатежа",,ГруппаФиксКурс,, БезЗаголовка);
	КратностьПлатежа.Ширина = 10;
	ВалютаРасчетовНадпись1	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаВзаиморасчетовНадпись",, "Объект.ВалютаВзаиморасчетов", ВидПоляФормы.ПолеНадписи, ГруппаФиксКурс,, НадписьВалюта);
	
	//ГруппаКоридор
	//ГруппаКоридорНеМенее
	КурсПлатежаНеМенее		= ФормыУХ.СоздатьПолеФормы(Элементы, "КурсПлатежаНеМенее", НСтр("ru = 'Не менее'"), "Объект.КурсПлатежаНеМенее",,ГруппаКоридорНеМенее,,, Действия);
	ВалютаПлатежейНадпись2	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаПлатежейНадпись2",, "Объект.ОсновнаяВалютаПлатежей",ВидПоляФормы.ПолеНадписи,ГруппаКоридорНеМенее,, НадписьВалюта);
	КурсПлатежаНеМенееВВО	= ФормыУХ.СоздатьПолеФормы(Элементы, "КурсПлатежаНеМенееВВалютеОплаты", НСтр("ru = 'за'"), "Объект.КурсПлатежаНеМенееВВалютеОплаты",,ГруппаКоридорНеМенее,,, Действия);
	ВалютаРасчетовНадпись2	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаРасчетовНадпись2",, "Объект.ВалютаВзаиморасчетов",ВидПоляФормы.ПолеНадписи, ГруппаКоридорНеМенее,, НадписьВалюта);
	ИтоговыйКурсНеМенее		= ФормыУХ.СоздатьПолеФормы(Элементы, "ИтоговыйКурсНеМенее",, "ИтоговыйКурсНеМенее",ВидПоляФормы.ПолеНадписи, ГруппаКоридорНеМенее,, БезЗаголовка);
	ИтоговыйКурсНеМенее.Подсказка = НСтр("ru = 'Итоговый курс (Не менее)'");
	//ГруппаКориодорНеБолее
	КурсПлатежаНеБолее		= ФормыУХ.СоздатьПолеФормы(Элементы, "КурсПлатежаНеБолее", НСтр("ru = 'Не более'"), "Объект.КурсПлатежаНеБолее",, ГруппаКориодорНеБолее,,, Действия);
	ВалютаПлатежейНадпись3	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаПлатежейНадпись3",, "Объект.ОсновнаяВалютаПлатежей", ВидПоляФормы.ПолеНадписи, ГруппаКориодорНеБолее,, НадписьВалюта);
	КурсПлатежаНеБолееВВО	= ФормыУХ.СоздатьПолеФормы(Элементы, "КурсПлатежаНеБолееВВалютеОплаты", НСтр("ru = 'за'"), "Объект.КурсПлатежаНеБолееВВалютеОплаты",,ГруппаКориодорНеБолее,,, Действия);
	ВалютаРасчетовНадпись3	= ФормыУХ.СоздатьПолеФормы(Элементы, "ВалютаРасчетовНадпись3",, "Объект.ВалютаВзаиморасчетов", ВидПоляФормы.ПолеНадписи, ГруппаКориодорНеБолее,, НадписьВалюта);
	ИтоговыйКурсНеБолее		= ФормыУХ.СоздатьПолеФормы(Элементы, "ИтоговыйКурсНеБолее",, "ИтоговыйКурсНеБолее", ВидПоляФормы.ПолеНадписи, ГруппаКориодорНеБолее,, БезЗаголовка);
	ИтоговыйКурсНеБолее.Подсказка = НСтр("ru = 'Итоговый курс (Не более)'");
	
	//
	ГруппаКурсПлатежа.Скрыть();
	
КонецПроцедуры

Процедура СоздатьРеквизитыФормыГруппыКурсПлатежейПоДоговору(Форма)
	
	//
	Реквизиты = Новый Массив;
	Реквизиты.Добавить(Новый РеквизитФормы("ИтоговыйКурсНеМенее", ОбщегоНазначения.ОписаниеТипаЧисло(15, 4, ДопустимыйЗнак.Любой)));
	Реквизиты.Добавить(Новый РеквизитФормы("ИтоговыйКурсНеБолее", ОбщегоНазначения.ОписаниеТипаЧисло(15, 4, ДопустимыйЗнак.Любой)));
	Форма.ИзменитьРеквизиты(Реквизиты);
	
КонецПроцедуры

#КонецОбласти 

#КонецОбласти 

#КонецОбласти 

#Область МодульОбъекта

#КонецОбласти 

#Область МодульМенеджера

#КонецОбласти 

	