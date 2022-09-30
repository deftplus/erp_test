&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПереходВКоробку = Параметры.ЭтоПереходВКоробку;
	
	АдресТаблицы = Параметры.АдресТаблицы;
	ОрганизацииТребующиеНапоминания = ПолучитьИзВременногоХранилища(АдресТаблицы);
	ОрганизацииТребующиеНапоминания.Колонки.Добавить("ЗаявлениеОтправлено", Новый ОписаниеТипов("Булево"));
	
	ТаблицаУчетныхЗаписей.Загрузить(ОрганизацииТребующиеНапоминания);
	
	СформироватьТекстПредупреждения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Инициализируем контекст формы - контейнера клиентских методов
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отложить(Команда)
	
	СохранитьДатуНапоминания();
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Если КонтекстЭДОКлиент = Неопределено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьДатуНапоминания()
	
	// Определяем, когда в следующий раз нужно напоминать пользователю
	ДатаНапоминания = НачалоДня(ТекущаяДатаСеанса());
	Если НапомнитьЧерез = "1" Тогда
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60 * 7;
	ИначеЕсли НапомнитьЧерез = "2" Тогда
		ДатаНапоминания = ДобавитьМесяц(ДатаНапоминания, 1);
	ИначеЕсли НапомнитьЧерез = "-1" Тогда
		ДатаНапоминания = '00010101000000';
	Иначе
		ДатаНапоминания = ДатаНапоминания + 24 * 60 * 60;
	КонецЕсли;
	
	ДатыНапоминанийПоОрганизациям = ХранилищеОбщихНастроек.Загрузить("ДокументооборотСКонтролирующимиОрганами_ДатыНапоминанийОПереходах");
	
	Если ДатыНапоминанийПоОрганизациям = Неопределено Тогда
		ДатыНапоминанийПоОрганизациям = Новый Соответствие;
	КонецЕсли;
	
	Для Каждого ПерешедшаяОрганизация Из ТаблицаУчетныхЗаписей Цикл
		ДатыНапоминанийПоОрганизациям.Вставить(ПерешедшаяОрганизация.УчетнаяЗапись, ДатаНапоминания);
	КонецЦикла;
	
	ХранилищеОбщихНастроек.Сохранить("ДокументооборотСКонтролирующимиОрганами_ДатыНапоминанийОПереходах", , ДатыНапоминанийПоОрганизациям);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеHTMLДокументаПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если ДанныеСобытия.Href <> Неопределено Тогда
		
		Если СтрНайти(ДанныеСобытия.Href, "its.1c.ru") > 0 Тогда
			СтандартнаяОбработка = Истина;
			Возврат;
		КонецЕсли; 
		
		СтандартнаяОбработка = ЛОЖЬ;
		
		КонецМетки = СтрНайти(ДанныеСобытия.Href, "КонецСсылки");
		Если КонецМетки > 0 Тогда
			МеткиВСсылках = Новый Массив;
			МеткиВСсылках.Добавить("&ПросмотрОрганизации");
			МеткиВСсылках.Добавить("&ПросмотрСертификата");
			МеткиВСсылках.Добавить("&ОтправкаЗаявленияНаИзменениеРеквизитовПодключения");
			МеткиВСсылках.Добавить("&ПросмотрУчетнойЗаписи");
			
			Для Каждого МеткаВСсылке Из МеткиВСсылках Цикл
				
				НачалоМетки = СтрНайти(ДанныеСобытия.Href, МеткаВСсылке);
				
				Если НачалоМетки > 0 Тогда
					НачалоНомераВСсылке = НачалоМетки + СтрДлина(МеткаВСсылке);
					НомерВСсылке = Сред(ДанныеСобытия.Href, НачалоНомераВСсылке, КонецМетки - НачалоНомераВСсылке);
					
					Если МеткаВСсылке = "&ПросмотрОрганизации" ИЛИ МеткаВСсылке = "&ОтправкаЗаявленияНаИзменениеРеквизитовПодключения" Тогда
						
						ИндексОрганизации = НомерВСсылке - 1;
						
						// просмотр организации
						Организация = ТаблицаУчетныхЗаписей[ИндексОрганизации].Организация;
						
						Если Организация <> Неопределено Тогда
							Если МеткаВСсылке = "&ПросмотрОрганизации" Тогда
								ПоказатьЗначение(, Организация);
							Иначе
								
								Если ЭтоПереходВКоробку Тогда
									ПроверитьНаличиеКриптопровайдераИОтправитьЗаявлениеОПереходеВКоробку(Организация);
								Иначе
									ОткрытьФормуОтправкиЗаявленияОПереходеВОблако(Организация);
								КонецЕсли;
								
							КонецЕсли;
								
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеКриптопровайдераИОтправитьЗаявлениеОПереходеВКоробку(Организация)
		
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("ЭтоПереходВКоробку", ЭтоПереходВКоробку);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПроверитьНаличиеКриптопровайдераИОтправитьЗаявлениеОПереходеВКоробкуЗавершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры); 
		
	ПредлагатьУстановкуРасширения = Истина;
	
	КонтекстЭДОКлиент.ПроверитьНаличиеКриптопровайдера(ОписаниеОповещения, ПредлагатьУстановкуРасширения, КриптопровайдерПриКонфликте);
		
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНаличиеКриптопровайдераИОтправитьЗаявлениеОПереходеВКоробкуЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	CryptoProCSPУстановлен 	= Результат.CryptoProCSPУстановлен;
	ViPNetCSPУстановлен 	= Результат.ViPNetCSPУстановлен;
		
	Если CryptoProCSPУстановлен И ViPNetCSPУстановлен И НЕ ИгнорироватьКонфликт Тогда
		
		ПредупредитьОКонфликтеПрограммЗащиты(ВходящийКонтекст);
		
	ИначеЕсли CryptoProCSPУстановлен ИЛИ ViPNetCSPУстановлен Тогда
		
		Если CryptoProCSPУстановлен Тогда
			CryptoProCSP = КриптографияЭДКОКлиентСервер.КриптопровайдерCryptoPro();
			ОткрытьФормуОтправкиЗаявленияОПереходеВКоробку(ViPNetCSPУстановлен, CryptoProCSP, ВходящийКонтекст);
		Иначе
			ViPNetCSP = КриптографияЭДКОКлиентСервер.КриптопровайдерViPNet();
			ОткрытьФормуОтправкиЗаявленияОПереходеВКоробку(ViPNetCSPУстановлен, ViPNetCSP, ВходящийКонтекст);
		КонецЕсли;
			
	ИначеЕсли НЕ CryptoProCSPУстановлен И НЕ ViPNetCSPУстановлен Тогда
			
		ОткрытьФормуУстановкиКриптопровайдера(ВходящийКонтекст);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуУстановкиКриптопровайдера(ВходящийКонтекст)
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.УстановкаКриптопровайдера",
		ВходящийКонтекст,
		,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьФормуОтправкиЗаявленияОПереходеВКоробку(ViPNetCSPУстановлен, СвойстваКриптопровайдера, ВходящийКонтекст)
	
	ВходящийКонтекст.Вставить("СвойстваКриптопровайдера", СвойстваКриптопровайдера);
	
	Если ViPNetCSPУстановлен Тогда
		ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet");
	Иначе
		ТипКриптопровайдера = ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro");
	КонецЕсли;
	ВходящийКонтекст.Вставить("ТипКриптопровайдера", ТипКриптопровайдера);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуОтправкиЗаявленияОПереходеВКоробкуЗавершение", 
		ЭтотОбъект,
		ВходящийКонтекст);
		
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ОтправкаЗаявленияОПереходеВКоробку",
		ВходящийКонтекст,
		,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьФормуОтправкиЗаявленияОПереходеВКоробкуЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	ПослеОтправкиЗаявления(Результат, ВходящийКонтекст);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуОтправкиЗаявленияОПереходеВОблако(Организация)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Организация", Организация);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОткрытьФормуОтправкиЗаявленияОПереходеВОблакоЗавершение", 
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ОтправкаЗаявленияОПереходеВОблако",
		ДополнительныеПараметры,
		,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ОткрытьФормуОтправкиЗаявленияОПереходеВОблакоЗавершение(Результат, ВходящийКонтекст) Экспорт
	
	ПослеОтправкиЗаявления(Результат, ВходящийКонтекст);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиЗаявления(Результат, ВходящийКонтекст)
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ЗаявлениеОтправлено")
		И Результат.ЗаявлениеОтправлено Тогда
		
		Отбор = Новый Структура();
		Отбор.Вставить("Организация", ВходящийКонтекст.Организация);
		
		НайденныеСтроки = ТаблицаУчетныхЗаписей.НайтиСтроки(Отбор);
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			НайденнаяСтрока.ЗаявлениеОтправлено = Истина;
		КонецЦикла;
		
		СформироватьТекстПредупреждения();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПредупредитьОКонфликтеПрограммЗащиты(ВходящийКонтекст)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПредупредитьОКонфликтеПрограммЗащиты_Завершение", 
		ЭтотОбъект, 
		ВходящийКонтекст);
		
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ЭтоЗаявлениеНаИзменение", Истина);
	
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.Мастер_КонфликтКриптопровайдеров",
		ДополнительныеПараметры,
		,
		,
		,
		,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПредупредитьОКонфликтеПрограммЗащиты_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("ИгнорироватьКонфликт") Тогда
		
		КриптопровайдерПриКонфликте = Результат.КриптопровайдерПриКонфликте;
		ИгнорироватьКонфликт 		= Результат.ИгнорироватьКонфликт;
		
		ПроверитьНаличиеКриптопровайдераИОтправитьЗаявлениеОПереходеВКоробку(ВходящийКонтекст.Организация);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьТекстПредупреждения()
	
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Если ЭтоПереходВКоробку Тогда
		ИмяМакета = "ПредупреждениеОПереходеВКоробку";
	Иначе
		ИмяМакета = "ПредупреждениеОПереходеВОблако";
	КонецЕсли;
	
	ТекстМакета = КонтекстЭДОСервер.ПолучитьМакетОбработки(ИмяМакета).ПолучитьТекст();
	
	НачалоИнформацииОбОрганизации 	= СтрНайти(ТекстМакета, "<!--НачалоБлока-->");
	КонецИнформацииОбОрганизации 	= СтрНайти(ТекстМакета, "<!--КонецБлока-->");
	СтрокаHTMLТаблицы 				= Сред(ТекстМакета, НачалоИнформацииОбОрганизации, КонецИнформацииОбОрганизации - НачалоИнформацииОбОрганизации);
	
	НачалоКнопки 		= СтрНайти(СтрокаHTMLТаблицы, "<!--НачалоКартинки-->");
	КонецКнопки 		= СтрНайти(СтрокаHTMLТаблицы, "<!--КонецКартинки-->");
	КодКартинкиКнопки 	= Сред(СтрокаHTMLТаблицы, НачалоКнопки, КонецКнопки - НачалоКнопки);
	
	КоличествоОрганизаций = ТаблицаУчетныхЗаписей.Количество();
	
	// Формируем строки HTML таблицы
	HTMLКодТаблицы = "";
	Для НомерСтроки = 1 По КоличествоОрганизаций Цикл
		
		ТекущаяСтрока 	   = ТаблицаУчетныхЗаписей[НомерСтроки - 1];
		ТекущаяОрганизация = ТекущаяСтрока.Организация.Наименование;
		
		// Организация
		ИнформацияОбОрганизацииHTML = "<A style=""color: black"" href=""&amp;ПросмотрОрганизации" + Формат(НомерСтроки, "ЧН=0; ЧГ=") + "КонецСсылки"">" 
			+ КонтекстЭДОСервер.ТекстВHTML(ТекущаяОрганизация) + "</A>";
			
		НоваяСтрокаHTMLТаблицы = СтрЗаменить(СтрокаHTMLТаблицы, "#ИнформацияОбОрганизации#", ИнформацияОбОрганизацииHTML);
			
		// Кнопка "Отправить заявление"
		Если ТекущаяСтрока.ЗаявлениеОтправлено Тогда
			КнопкаОтправкиЗаявление = "<FONT face=Verdana><STRONG>Заявление отправлено</STRONG></FONT>";
		Иначе
			КнопкаОтправкиЗаявление = "<A href=""&amp;ОтправкаЗаявленияНаИзменениеРеквизитовПодключения"
				+ Формат(НомерСтроки, "ЧН=0; ЧГ=") + "КонецСсылки"">" + КодКартинкиКнопки + "</A>";
		КонецЕсли;

		НоваяСтрокаHTMLТаблицы = СтрЗаменить(НоваяСтрокаHTMLТаблицы, КодКартинкиКнопки, КнопкаОтправкиЗаявление);
		
		// Добавляем строку в HTML-документ
		HTMLКодТаблицы = HTMLКодТаблицы + НоваяСтрокаHTMLТаблицы;
		
	КонецЦикла;
	
	// Подставляем в макет сформированную таблицу
	ПолныйHTMLТекстПредупреждения = СтрЗаменить(ТекстМакета, СтрокаHTMLТаблицы, HTMLКодТаблицы);
	ПолныйHTMLТекстПредупреждения = КонтекстЭДОСервер.УбратьФорматированиеДляFirefox(ПолныйHTMLТекстПредупреждения);
	
	HTMLДокумент = ПолныйHTMLТекстПредупреждения;
	
КонецПроцедуры

#КонецОбласти

