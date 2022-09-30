
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Ключ.Пустая() Тогда
		Объект.Дата = ОбщегоНазначенияУХ.ПолучитьКонецПериодаОтчета(Объект.ПериодОтчета);
		ПодготовитьФормуНаСервере(ЭтаФорма);
		УправлениеФормой();
	КонецЕсли;

	ЗаполнитьДополнительныеРеквизитыТЧ();	
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если (ИмяСобытия = "ЗагрузитьИзФормыГрафика") И (Источник = ЭтаФорма) Тогда 
		ЗагрузитьДанныеГрафика(Параметр);
	ИначеЕсли (ИмяСобытия = "ВыборПараметровУчетаФИ") И (ТипЗнч(Источник) = Тип("ПолеФормы")) И (ЭтаФорма.Элементы.Найти(Источник.Имя) <> Неопределено) Тогда
		
		Если ЗначениеЗаполнено(ВыборПараметровУчетаФИУХ) Тогда
			Соотв = Новый Соответствие(ВыборПараметровУчетаФИУХ);
		Иначе 
			Соотв = Новый Соответствие;
		КонецЕсли;
						
		Соотв.Вставить(Параметр.ФИ, Параметр);
		ВыборПараметровУчетаФИУХ = Новый ФиксированноеСоответствие(Соотв);

	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере(ЭтаФорма);	
	УправлениеФормой();		
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере(ЭтаФорма);	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	
	Мас = Новый Массив();	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Мас, ТекущийОбъект.Проценты.ВыгрузитьКолонку("ФИ"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Мас, ТекущийОбъект.ОсновнойДолг.ВыгрузитьКолонку("ФИ"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Мас, ТекущийОбъект.ГрафикиМСФО.ВыгрузитьКолонку("ФИ"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Мас, ТекущийОбъект.ДополнительныеРасходы.ВыгрузитьКолонку("ФИ"));
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Мас, ТекущийОбъект.АвансовыеПлатежи.ВыгрузитьКолонку("ФИ"));
	
	МасФИ = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ОбщегоНазначенияКлиентСервер.РазностьМассивов(Мас, ТекущийОбъект.ФинансовыеИнструменты.ВыгрузитьКолонку("ФИ")));
	
	Для каждого УдаляемыйФИ Из МасФИ Цикл
		УдалитьДанныеПоФИ(ЭтаФорма, УдаляемыйФИ);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
				
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьГрафикНСБУ(Команда)
	
	ПараметрыГрафика = Новый Структура("ФИ,ДатаНачала");
	
	СтрокаФИ = Элементы.ФинансовыеИнструменты.ТекущиеДанные;
	Если СтрокаФИ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ПараметрыГрафика, СтрокаФИ);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПараметрыГрафика", 	ПараметрыГрафика);
	ПараметрыФормы.Вставить("АдресТаблицыГрафика", 	ПолучитьАдресГрафикаНСБУ(СтрокаФИ.ФИ, СтрокаФИ.ПараметрыУчетаФинансовогоИнструментаМСФО));
		
	ОткрытьФорму("Обработка.ЗагрузкаГрафикаФИ.Форма.Форма", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокумент(Команда)
	ЗаполнитьДокументСервер();
КонецПроцедуры

&НаКлиенте
Процедура ДанныеУчетаФИ(Команда)
	
	ФИ = Новый Массив;
	Для каждого СтрокаФИ Из Объект.ФинансовыеИнструменты Цикл
		ФИ.Добавить(СтрокаФИ.ФИ);
	КонецЦикла;
		
	ПараметрыОтчета = Новый Структура("Отбор,СформироватьПриОткрытии,КлючВарианта", 
	Новый Структура("ФИ,ПериодОтчета,Организация", ФИ, Объект.ПериодОтчета, Объект.Организация), Истина, "Основной");
	ОткрытьФорму("Отчет.ДанныеУчетаФИМСФО.ФормаОбъекта", ПараметрыОтчета, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьГрафикФИ(Команда)
	
	ДанныеФИ = ПолучитьДанныеФИ();
	Если ДанныеФИ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийФИ = Элементы.ФинансовыеИнструменты.ТекущиеДанные.ФИ;
	Если Не ЗначениеЗаполнено(ТекущийФИ) Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ГрафикФИМСФО.Форма", Новый Структура("ДанныеФИ,Документ,ФИ", ДанныеФИ, ЭтаФорма.Объект.Ссылка, ТекущийФИ), ЭтаФорма, ЭтаФорма);
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	
	УправлениеФормой();	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УправлениеФормой();	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.ПериодОтчета = МСФОВНАВызовСервераУХ.ПолучитьПериодПоДатеПараллельногоУчета(Объект.Дата, Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументОснованиеНеУказанГиперссылкаНажатие(Элемент)
	
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ФинансовыеИнструменты"); 
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДобавитьДокументОснованиеНажатие(Элемент)
	
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ФинансовыеИнструменты"); 
		
КонецПроцедуры

&НаКлиенте
Процедура ТекстДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ФинансовыеИнструменты", СтандартнаяОбработка); 
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	МСФОКлиентУХ.ОткрытьФормуРедактированияМногострочногоТекста(ЭтаФорма, Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаПриИзменении(Элемент)
	Объект.Дата = ОбщегоНазначенияУХ.ПолучитьКонецПериодаОтчета(Объект.ПериодОтчета);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандТабличнойЧасти_ФИ

&НаКлиенте
Процедура ДоговорыПослеУдаления(Элемент)
	
	СтрокиУдаления = Объект.ГрафикиМСФО.НайтиСтроки(Новый Структура("ФИ", Неопределено)); 
	Для каждого СтрокаУдаления Из СтрокиУдаления Цикл
		Объект.ГрафикиМСФО.Удалить(СтрокаУдаления);
	КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДополнительныеПараметрыОповещения = Новый ФиксированнаяСтруктура("ФИ", Элементы.ФинансовыеИнструменты.ТекущиеДанные.ФИ);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьУдалениеСтрокиФИ", ЭтаФорма, ДополнительныеПараметрыОповещения);
	ТекстВопроса = НСтр("ru = 'После удаления данных финансового инструмента - все данные(графики, доп.расходы, начисления НСБУ) будут потеряны. Продолжить?'");
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.ФинансовыеИнструменты.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьЗаголовокСуммаЗадолженности(ТекущаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ФинансовыеИнструментыДатаОкончанияПриИзменении(Элемент)
	ЗаполнитьСтрокуФИ();
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыСуммаОсновнойЗадолженностиНСБУПриИзменении(Элемент)
	ЗаполнитьСтрокуФИ();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандЭлементовТабличнойЧасти_ФИ

&НаКлиенте
Процедура ФинансовыеИнструментыДоговорПриИзменении(Элемент)	
	ЗаполнитьСтрокуФИ();
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыеИнструментыДатаПризнанияПриИзменении(Элемент)
	ЗаполнитьСтрокуФИ();	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыПараметрыУчетаФИПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ФинансовыеИнструменты.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока.Лизинг = ЭтоЛизинг(ТекущаяСтрока.ПараметрыУчетаФинансовогоИнструментаМСФО);	
	
	ЗаполнитьСтрокуФИ();
	
	ОбновитьЗаголовокСуммаЗадолженности(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыКонтрагентПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение_и_расчет

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьПараметрыЗаполненияМСФО()
	
	Возврат 
	Новый Структура(
	"ОбновитьПризнаниеФИ,ЗаполнитьФИМСФО,ЗаполнитьГрафикиМСФО,РассчитатьЭСП,РассчитатьЧПС,ЗаполнитьГрафикиМСФО", 
	Истина, Истина, Истина, Истина, Истина, Истина);
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТекущимиДанными(Команда)
	
	ПараметрыЗаполнения = Новый Структура("ЗаполнитьФИМСФО", Истина);
											
	ЗаполнитьСтрокиСервер(ПараметрыЗаполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРассчитатьМСФО(Команда)
	
	ПараметрыЗаполнения = ПолучитьПараметрыЗаполненияМСФО();
	ЗаполнитьСтрокиСервер(ПараметрыЗаполнения);
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокиСервер(ПараметрыЗаполнения = Неопределено, ЗаполнитьТекущуюСтроку = Ложь) Экспорт

	Если ЗаполнитьТекущуюСтроку Тогда
		
		ТекущаяСтрокаИдентификатор = Элементы.ФинансовыеИнструменты.ТекущаяСтрока;
		Если ТекущаяСтрокаИдентификатор = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТекущаяСтрока = Объект.ФинансовыеИнструменты.НайтиПоИдентификатору(ТекущаяСтрокаИдентификатор);
		Если ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ТаблицаФИ = Новый ТаблицаЗначений;
		ТаблицаФИ.Колонки.Добавить("ФИ", Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов,СправочникСсылка.ЦенныеБумаги"));
		ТаблицаФИ.Колонки.Добавить("ДатаПризнания", Новый ОписаниеТипов("Дата"));
		ТаблицаФИ.Колонки.Добавить("ПараметрыУчетаФинансовогоИнструментаМСФО", Новый ОписаниеТипов("СправочникСсылка.ПараметрыУчетаФинансовыхИнструментовМСФО"));
		
		СтрокаФИ = ТаблицаФИ.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаФИ, ТекущаяСтрока);
		Если СтрокаФИ.ДатаПризнания = Дата(1,1,1) Тогда
			СтрокаФИ.ДатаПризнания = Объект.ПериодОтчета.ДатаОкончания;
		КонецЕсли;
		
	Иначе 
		ТаблицаФИ = Неопределено;
	КонецЕсли;
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Новый Структура("ЗаполнитьДокумент"));
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьГрафикиМСФО(Команда)
	
	ПараметрыЗаполнения = Новый Структура("ЗаполнитьГрафикиМСФО", Истина);
	ЗаполнитьСтрокиСервер(ПараметрыЗаполнения);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПрименятьПоправку(ПараметрыФИ)
	Возврат ПараметрыФИ.ВидОбъектаФинансовогоХарактера.ПрименятьПоправкуПоСправедливойСтоимости;
КонецФункции

#КонецОбласти

#Область ГрафикНСБУ

&НаСервере
Процедура ЗагрузитьДанныеГрафика(АдресДанныеГрафика)

	ДанныеГрафика = ПолучитьИзВременногоХранилища(АдресДанныеГрафика);
	
	Если ТипЗнч(ДанныеГрафика) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;	
	
	ФИ = ДанныеГрафика.СтрокаФИ.ФИ;
	
	УдалитьДанныеПоФИ(ЭтаФорма, ФИ, Ложь, Ложь);
	
	СтрокиФИ = Объект.ФинансовыеИнструменты.НайтиСтроки(Новый Структура("ФИ", ДанныеГрафика.СтрокаФИ.ФИ));
	Для каждого СтрокаФИ Из СтрокиФИ Цикл
		ЗаполнитьЗначенияСвойств(СтрокаФИ, ДанныеГрафика.СтрокаФИ);
	КонецЦикла;
	
	ДанныеГрафика.ГрафикНСБУ.Колонки.Добавить("ФИ");
	ДанныеГрафика.ГрафикНСБУ.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.ГрафикНСБУ, Объект.Проценты);
	
	ДанныеГрафика.ОсновнойДолг.Колонки.Добавить("ФИ");
	ДанныеГрафика.ОсновнойДолг.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.ОсновнойДолг, Объект.ОсновнойДолг);
		
	ДанныеГрафика.ДополнительныеРасходы.Колонки.Добавить("ФИ");
	ДанныеГрафика.ДополнительныеРасходы.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.ДополнительныеРасходы, Объект.ДополнительныеРасходы);
	
	ДанныеГрафика.ВНА.Колонки.Добавить("ФИ");
	ДанныеГрафика.ВНА.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.ВНА, Объект.ВНА);
	
	ДанныеГрафика.ГрафикМСФО.Колонки.Добавить("ФИ");
	ДанныеГрафика.ГрафикМСФО.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.ГрафикМСФО, Объект.ГрафикиМСФО);
	
	ДанныеГрафика.АвансовыеПлатежи.Колонки.Добавить("ФИ");
	ДанныеГрафика.АвансовыеПлатежи.ЗаполнитьЗначения(ФИ, "ФИ");
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(ДанныеГрафика.АвансовыеПлатежи, Объект.АвансовыеПлатежи);
	
	Модифицированность = Истина;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресГрафикаНСБУ(ФИ, ПараметрыУчетаФИ)
	
	ТаблицаГрафик = Объект.Проценты.Выгрузить(Новый Структура("ФИ", ФИ));
	ТаблицаГрафик.Колонки.Удалить("ФИ");
	ТаблицаГрафик.Колонки.Удалить("НомерСтроки");
	ТаблицаГрафик.Колонки.Удалить("ИсходныйНомерСтроки");
	Если Не ПараметрыУчетаФИ.ВидОбъектаФинансовогоХарактера.Лизинг Тогда
		ТаблицаГрафик.Колонки.Удалить("НДС");
	КонецЕсли;
	
	ТаблицаГрафик.Колонки.Дата.Заголовок = НСтр("ru = 'Дата операции (в формате ""dd.MM.yyyy"")'");
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаГрафик);
	
КонецФункции

#КонецОбласти

#Область Отображение

&НаКлиенте
Процедура ОбновитьЗаголовокСуммаЗадолженности(ТекущаяСтрока)	
	Элементы.ДоговорыСуммаОсновнойЗадолженностиНСБУ.Заголовок = ?(ТекущаяСтрока.Лизинг, НСтр("ru = 'Сумма арендованных ВНА'"), НСтр("ru = 'Сумма основной задолженности, без НДС (НСБУ)'"));
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОтобразитьРСП(Этаформа, ИДСтрокиФИ)

	Если ИДСтрокиФИ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаФИ = Этаформа.Объект.ФинансовыеИнструменты.НайтиПоИдентификатору(ИДСтрокиФИ);
	Если СтрокаФИ = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ПолучитьПрименятьПоправку(СтрокаФИ.ПараметрыУчетаФинансовогоИнструментаМСФО);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидимостьВидРекласса(Форма, СтрокаФИ)
	
	Элементы = Форма.Элементы;
	
	//ЭтоПризнание = СтрокаФИ.ПараметрыУчетаФИДоРекласса.Пустая() И Не ЗначениеЗаполнено(СтрокаФИ.ДатаПризнанияДоРекласса);
	//ЭтоРекласс = Не СпособУчетаПоАмортизированнойСтоимости(СтрокаФИ.ПараметрыУчетаФИДоРекласса);
	ЭтоПризнание = (Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоФинансовымИнструментамМСФО.Признание"));
	ЭтоРекласс = (Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоФинансовымИнструментамМСФО.Рекласс"));
	ЭтоИзменение = (Форма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоФинансовымИнструментамМСФО.ИзменениеНачислений"));
	
	ОбщегоНазначенияКлиентСерверУХ.УстановитьНовоеЗначение(Элементы.ГруппаПризнание.Видимость, ЭтоПризнание);
	ОбщегоНазначенияКлиентСерверУХ.УстановитьНовоеЗначение(Элементы.ГруппаРеклассИзСпрС.Видимость, ЭтоРекласс);
	ОбщегоНазначенияКлиентСерверУХ.УстановитьНовоеЗначение(Элементы.ГруппаРеструктуризация.Видимость, ЭтоИзменение);

КонецФункции

&НаСервереБезКонтекста
Функция СпособУчетаПоАмортизированнойСтоимости(ПараметрыУчетаФИ)
	Возврат ПараметрыУчетаФИ.ВидОбъектаФинансовогоХарактера.СпособУчета = Перечисления.СпособыУчетаФинансовыхИнструментов.ПоАмортизированнойСтоимости;	
КонецФункции

&НаКлиенте
Процедура ОбработатьУдалениеСтрокиФИ(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьДанныеПоФИ(этаФорма, ДополнительныеПараметры.ФИ);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьДанныеПоФИ(Форма, ФИ, тчФИ = Истина, ДанныеСторно = Истина)
	
	Объект = Форма.Объект;
	
	ОтборУдаления = Новый Структура("ФИ", ФИ);
	
	Для каждого СтрокаУдаления Из Объект.Проценты.НайтиСтроки(ОтборУдаления) Цикл
		Объект.Проценты.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Для каждого СтрокаУдаления Из Объект.ГрафикиМСФО.НайтиСтроки(ОтборУдаления) Цикл
		Объект.ГрафикиМСФО.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Для каждого СтрокаУдаления Из Объект.ВНА.НайтиСтроки(ОтборУдаления) Цикл
		Объект.ВНА.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Для каждого СтрокаУдаления Из Объект.ДополнительныеРасходы.НайтиСтроки(ОтборУдаления) Цикл
		Объект.ДополнительныеРасходы.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Для каждого СтрокаУдаления Из Объект.ОсновнойДолг.НайтиСтроки(ОтборУдаления) Цикл
		Объект.ОсновнойДолг.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Для каждого СтрокаУдаления Из Объект.АвансовыеПлатежи.НайтиСтроки(ОтборУдаления) Цикл
		Объект.АвансовыеПлатежи.Удалить(СтрокаУдаления);
	КонецЦикла;
	
	Если ДанныеСторно Тогда
		
		Для каждого СтрокаУдаления Из Объект.АмортизацияНСБУ.НайтиСтроки(ОтборУдаления) Цикл
			Объект.АмортизацияНСБУ.Удалить(СтрокаУдаления);
		КонецЦикла;
		
		Для каждого СтрокаУдаления Из Объект.ПроцентыНСБУ.НайтиСтроки(ОтборУдаления) Цикл
			Объект.ПроцентыНСБУ.Удалить(СтрокаУдаления);
		КонецЦикла;	
		
	КонецЕсли;
	
	Если тчФИ Тогда
		
		Для каждого СтрокаУдаления Из Объект.ФинансовыеИнструменты.НайтиСтроки(ОтборУдаления) Цикл
			Объект.ФинансовыеИнструменты.Удалить(СтрокаУдаления);
		КонецЦикла;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДоступноЗаполнениеСтроки(СтрокаФИ)

	Возврат 
	(СтрокаФИ <> Неопределено) 
	И (СтрокаФИ.ФИ <> Неопределено)
	И Не СтрокаФИ.ФИ .Пустая() 
	И (СтрокаФИ.ДатаПризнания <> Дата(1,1,1));

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Стандартные

&НаСервере
Процедура УправлениеФормой()
	
	МСФОУХ.ЗаполнитьКэшируемыеЗначения(ЭтаФорма);
	
	ЭтоИзменение = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоФинансовымИнструментамМСФО.ИзменениеНачислений"));
	ЭтоВыбытие = (Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоФинансовымИнструментамМСФО.Выбытие"));
	
	Элементы.ФинансовыеИнструментыДатаПризнания.Заголовок = ?(ЭтоИзменение, НСтр("ru = 'Дата изменения графика'"), НСтр("ru = 'Дата начала графика'"));
	
	Элементы.ДоговорыВалютаФинансовогоИнструмента.ТолькоПросмотр = ЭтоВыбытие;
	//Элементы.ФинансовыеИнструментыДатаПризнания.ТолькоПросмотр = ЭтоВыбытие;
	Элементы.ФинансовыеИнструментыПараметрыУчетаФИ.ТолькоПросмотр = ЭтоВыбытие;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПодготовитьФормуНаСервере(ЭтаФорма)

	Объект = ЭтаФорма.Объект;
	
	Если ЭтаФорма.КэшируемыеЗначения = Неопределено Тогда
		ЭтаФорма.КэшируемыеЗначения = Новый Структура;
	КонецЕсли;
			
	ПутьВидФИ = "Объект.ФинансовыеИнструменты.ПараметрыУчетаФинансовогоИнструментаМСФО.ВидОбъектаФинансовогоХарактера.Лизинг"; 
	
	ПоляОформления = Новый Массив;
	ПоляОформления.Добавить("ФинансовыеИнструментыРыночнаяПроцентнаяСтавкаМСФО");
	МСФОУХ.ДобавитьУсловноеОформлениеТолькоПросмотр(ЭтаФорма, ПоляОформления, ПутьВидФИ, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДополнительныеРеквизитыТЧ()
	
	Перем Запрос, ПараметрыУчетаАренды, СтрокаФИ;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	тчФИ.ПараметрыУчетаФинансовогоИнструментаМСФО КАК ПараметрыУчетаФИ
	|ИЗ
	|	Документ.ВводСведенийОФинансовыхИнструментах.ФинансовыеИнструменты КАК тчФИ
	|ГДЕ
	|	тчФИ.ПараметрыУчетаФинансовогоИнструментаМСФО.ВидОбъектаФинансовогоХарактера.Лизинг
	|	И тчФИ.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	ПараметрыУчетаАренды = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ПараметрыУчетаФИ");
	
	Для каждого СтрокаФИ Из Объект.ФинансовыеИнструменты Цикл	
		СтрокаФИ.Лизинг = ПараметрыУчетаАренды.Найти(СтрокаФИ.ПараметрыУчетаФинансовогоИнструментаМСФО) <> Неопределено;
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоЛизинг(ПараметрыУчетаФИ)
	Возврат ПараметрыУчетаФИ.ВидОбъектаФинансовогоХарактера.Лизинг;
КонецФункции

&НаСервере
Процедура ЗаполнитьДокументСервер()

	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ТекущийОбъект.Заполнить(Новый Структура("ЗаполнитьДокумент", Истина));
	ЗначениеВРеквизитФормы(ТекущийОбъект, "Объект");

КонецПроцедуры
	
#КонецОбласти

&НаСервере
Функция ПолучитьДанныеФИ()

	ТекущаяСтрокаНомер = Элементы.ФинансовыеИнструменты.ТекущаяСтрока;
	Если ТекущаяСтрокаНомер = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаФИ = Объект.ФинансовыеИнструменты.НайтиПоИдентификатору(ТекущаяСтрокаНомер);
	Если СтрокаФИ = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	СтрокаОбъектаФИ = ТекущийОбъект.ФинансовыеИнструменты.Выгрузить(Новый Структура("ФИ", СтрокаФИ.ФИ)).Получить(0);
	
	ДанныеФИ = Документы.ВводСведенийОФинансовыхИнструментах.ПолучитьДанныеФИ(ТекущийОбъект, СтрокаОбъектаФИ);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеФИ, УникальныйИдентификатор); 
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСтрокуФИ()

	ТекущаяСтрокаНомер = Элементы.ФинансовыеИнструменты.ТекущаяСтрока;
	Если ТекущаяСтрокаНомер = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Объект.ФинансовыеИнструменты.НайтиПоИдентификатору(ТекущаяСтрокаНомер);
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыСтроки(ТекущаяСтрока);
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	СтрокаОбъектаФИ = ТекущийОбъект.ФинансовыеИнструменты.Выгрузить(Новый Структура("ФИ", ТекущаяСтрока.ФИ)).Получить(0);
	
	ДанныеФИ = Документы.ВводСведенийОФинансовыхИнструментах.ПолучитьДанныеФИ(ТекущийОбъект, СтрокаОбъектаФИ);

	ДанныеФИ.ГрафикМСФО.Колонки.Добавить("ОтчетнаяДата");
		
	УчетФинансовыхИнструментовМСФОКлиентСерверУХ.ЗаполнитьГрафик(ДанныеФИ, Новый Структура("ЗаполнитьОсновнойДолг"));
		
	ДанныеФИ.ГрафикМСФО.ЗаполнитьЗначения(ТекущаяСтрока.ФИ, "ФИ");
	
	СтрокиСтарогоГрафика = Объект.ГрафикиМСФО.НайтиСтроки(Новый Структура("ФИ", ТекущаяСтрока.ФИ));
	Для каждого СтрокаТаб Из СтрокиСтарогоГрафика Цикл
		Объект.ГрафикиМСФО.Удалить(СтрокаТаб);
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеФИ.СтрокаФИ); 
	ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ДанныеФИ.ГрафикМСФО, Объект.ГрафикиМСФО);
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыСтроки(ТекущаяСтрока)
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ФИ) Тогда
		Возврат; 
	ИначеЕсли Не ТекущаяСтрока.ВалютаФИ.Пустая() И Не ТекущаяСтрока.ПараметрыУчетаФинансовогоИнструментаМСФО.Пустая() Тогда
		Возврат;		
	КонецЕсли;
	
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТекущаяСтрока.ФИ, "");

КонецПроцедуры

#КонецОбласти

