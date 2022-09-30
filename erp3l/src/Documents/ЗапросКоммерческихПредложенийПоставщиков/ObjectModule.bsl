
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")Тогда 
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
	КонецЕсли;
	
	Автор = Пользователи.ТекущийПользователь();
	
	КоммерческиеПредложенияДокументыПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ТаблицаДляПроверки = Товары.Выгрузить(,"НомерСтроки, ИсточникДобавленияТовара, Номенклатура,
		|НоменклатураВСервисеИдентификатор, НоменклатураВСервисеПредставление, НоменклатураТекстом, КатегорияВСервисеПредставление");
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.Номенклатура" );
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НоменклатураВСервисеПредставление" );
	МассивНепроверяемыхРеквизитов.Добавить("Товары.НоменклатураТекстом" );
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КатегорияВСервисеПредставление");
	
	Для Каждого СтрокаТаблицы Из ТаблицаДляПроверки Цикл
		Если СтрокаТаблицы.ИсточникДобавленияТовара = 0 Тогда
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Номенклатура) Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "Номенклатура", "Номенклатура", Отказ);
			ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.КатегорияВСервисеПредставление)
				И Не ЗначениеЗаполнено(СтрокаТаблицы.НоменклатураВСервисеИдентификатор)Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "КатегорияВСервисеПредставление", "Категория", Отказ);
			КонецЕсли;
		ИначеЕсли СтрокаТаблицы.ИсточникДобавленияТовара = 1 Тогда
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.НоменклатураВСервисеПредставление) Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "НоменклатураВСервисеПредставление", "Номенклатура", Отказ);
			ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.КатегорияВСервисеПредставление) Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "КатегорияВСервисеПредставление", "Категория", Отказ);
			КонецЕсли;
		ИначеЕсли СтрокаТаблицы.ИсточникДобавленияТовара = 2 Тогда
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.НоменклатураТекстом) Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "НоменклатураТекстом", "Номенклатура", Отказ);
			ИначеЕсли Не ЗначениеЗаполнено(СтрокаТаблицы.КатегорияВСервисеПредставление) Тогда
				СообщитьПользователю("Товары", СтрокаТаблицы.НомерСтроки, "КатегорияВСервисеПредставление", "Категория", Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Менеджер) Тогда
		КонтактнаяИнформацияМенеджера = КоммерческиеПредложенияДокументы.КонтактнаяИнформацияМенеджера(Менеджер);
		
		Если ПустаяСтрока(КонтактнаяИнформацияМенеджера.Email) Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для менеджера %1 не указан адрес электронной почты.';
											|en = 'The email address is not specified for the manager %1.'"), Менеджер);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Менеджер", , Отказ);
			
		ИначеЕсли Не КонтактнаяИнформацияМенеджера.EmailСоответствуетТребованиям Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Для менеджера %1 указан некорректный адрес электронной почты ""%2"".';
											|en = 'The incorrect email address ""%2"" is specified for the manager %1.'"),
				Менеджер, КонтактнаяИнформацияМенеджера.Email);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "Менеджер", , Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	КоммерческиеПредложенияДокументыПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если ЗначениеЗаполнено(МассивНепроверяемыхРеквизитов) Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	Если Не ЗначениеЗаполнено(Автор) И ЭтоНовый() Тогда
		Автор = Пользователи.ТекущийПользователь();
	КонецЕсли;

	КоммерческиеПредложенияДокументыПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Если ПустаяСтрока(НомерЭД) Тогда
		НомерЭД = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Номер, Истина, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	КоммерческиеПредложенияДокументыПереопределяемый.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Для Каждого Товар Из Товары Цикл
		
		Товар.ИдентификаторСтрокиЗапроса = Новый УникальныйИдентификатор;
		
	КонецЦикла;
	
	ВыбранныеИсточники.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СообщитьПользователю(ИмяТабличнойЧасти, НомерСтроки, ИмяКолонки, ЗаголовокКолонки, Отказ)

	ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнена колонка ""%3"" в строке %1 списка ""%2""';
									|en = 'The ""%3"" column is not filled in line %1 of the ""%2"" list.'"),
			НомерСтроки, ИмяТабличнойЧасти, ЗаголовокКолонки);
	
	Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(ИмяТабличнойЧасти, НомерСтроки, ИмяКолонки);
	
	ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, Поле, "Объект", Отказ);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
