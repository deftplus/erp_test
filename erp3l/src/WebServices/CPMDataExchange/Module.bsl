
// Основная функции подготовки данных для запроса и получения результирующего набора данных.
//
Функция QueryProcessing(InitialData)
	
	Перем ЕстьОбороты;
	Перем ПланСчетов;
	
	ПолученныеДанные = InitialData.Получить();
	ТаблицаСчетовОперанда = Новый ТаблицаЗначений;
	
	ТаблицаСчетовОперанда.Колонки.Добавить("КодОперанда");
	ТаблицаСчетовОперанда.Колонки.Добавить("СчетДанные");
	ТаблицаСчетовОперанда.Колонки.Добавить("КоррСчетДанные");
	
	// Возможно, что передан параметр некорректного типа.
	Если ТипЗнч(ПолученныеДанные) <> Тип("Структура") Тогда
		Возврат Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
		
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.ДобавлениеПредставлений=ТипДобавленияПредставлений.НеДобавлять;
	
	Если НЕ ПолученныеДанные.Свойство("ТекстЗапроса", ПостроительЗапроса.Текст) Тогда
		Возврат Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	ПостроительЗапроса.ЗаполнитьНастройки();
	
	ЕстьОбороты = Найти(ПостроительЗапроса.Текст,"&СчетДт")>0;
	СтруктураОтвета = Новый Структура;
	
	Если ПолученныеДанные.Свойство("ТабСчетаСписок") Тогда
		
		ПолученныеДанные.Свойство("ИспользуемыйПланСчетов", ПланСчетов);
		
		СписокСчетов    = Новый СписокЗначений;
		
		Если ЕстьОбороты Тогда
			СписокКоррСчетов    = Новый СписокЗначений;
		КонецЕсли;
		
		Для Каждого ТекСчет Из ПолученныеДанные.ТабСчетаСписок Цикл
			
			ТаблицаСчетов = ПолучитьСчетаВИерархии(ТекСчет.Счет, ПланСчетов);
			
			Если ЕстьОбороты Тогда
				ТаблицаКоррСчетов = ПолучитьСчетаВИерархии(ТекСчет.КоррСчет, ПланСчетов);
			КонецЕсли;
			
			Для Каждого Запись Из ТаблицаСчетов Цикл
				
				СписокСчетов.Добавить(Запись.Код);
				
				Если ЕстьОбороты Тогда
					Для Каждого Запись_Корр Из ТаблицаКоррСчетов Цикл
						СписокКоррСчетов.Добавить(Запись_Корр.Код);
						НоваяЗапись                = ТаблицаСчетовОперанда.Добавить();
						НоваяЗапись.КодОперанда    = ТекСчет.Операнд;
						НоваяЗапись.СчетДанные     = Запись.Код;
						НоваяЗапись.КоррСчетДанные = Запись_Корр.Код;
					КонецЦикла;
				Иначе
					НоваяЗапись          = ТаблицаСчетовОперанда.Добавить();
					НоваяЗапись.КодОперанда = ТекСчет.Операнд;
					НоваяЗапись.СчетДанные  = Запись.Код;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если ЕстьОбороты Тогда
			ПостроительЗапроса.Параметры.Вставить("СчетДт", СписокСчетов);
			ПостроительЗапроса.Параметры.Вставить("СчетКт", СписокКоррСчетов);
		Иначе
			ПостроительЗапроса.Параметры.Вставить("Счет", СписокСчетов);
		КонецЕсли;
		
		СтруктураОтвета.Вставить("ИспользуемыеСчета", ТаблицаСчетовОперанда);
		
	ИначеЕсли ПолученныеДанные.Свойство("ТабСтатьиСписок") Тогда
		
		СписокСтатей = Новый СписокЗначений;
		
		Для Каждого СтрокаСтатья ИЗ ПолученныеДанные.ТабСтатьиСписок Цикл
				
			ТаблицаСтатей = ПолучитьСтатьиВИерархии(СтрокаСтатья.Статья);
			СписокСтатейЛок=Новый СписокЗначений;
			ДобавитьМассивВСписокЗначений(СписокСтатейЛок, ТаблицаСтатей.ВыгрузитьКолонку("Код"));
			СтрокаСтатья.СписокСтатей = СписокСтатейЛок;
			ДобавитьМассивВСписокЗначений(СписокСтатей, ТаблицаСтатей.ВыгрузитьКолонку("Ссылка"));
				
		КонецЦикла;
			
		ПостроительЗапроса.Параметры.Вставить("Статья",СписокСтатей);
		СтруктураОтвета.Вставить("ИспользуемыеСтатьи", ПолученныеДанные.ТабСтатьиСписок);
		
	КонецЕсли;
	
	МассивПараметров = Новый Массив;
	
	Для Каждого Элемент Из ПостроительЗапроса.ПолучитьЗапрос().НАйтиПараметры() Цикл
		МассивПараметров.Добавить(Элемент.Имя);
	КонецЦикла;
	
	
	Если ПолученныеДанные.Свойство("ИспользуемыеПараметры") Тогда
		Для Каждого Запись Из ПолученныеДанные.ИспользуемыеПараметры Цикл
			ПостроительЗапроса.Параметры.Вставить(Запись.ИмяПараметра, Запись.ЗначениеПараметра);
		КонецЦикла;
	КонецЕсли;
	
	Если ПолученныеДанные.Свойство("ИспользуемыеОтборы") Тогда
		
		Для Каждого Запись Из ПолученныеДанные.ИспользуемыеОтборы Цикл
			Если Запись.Рассчитывается И ТипЗнч(Запись.Значение) = Тип("Структура") Тогда
				ТекЗначение = ПолучитьЗначениеОтбора(Запись.Значение);
			Иначе
				ТекЗначение = Новый СписокЗначений;
				ТекЗначение.Добавить(Запись.Значение);
			КонецЕсли;
			
			Если МассивПараметров.Найти(Запись.ИмяОтбора) <> Неопределено Тогда
				
				Если ТекЗначение.Количество() = 1 Тогда
					ПостроительЗапроса.Параметры.Вставить(Запись.ИмяОтбора, ТекЗначение.Получить(0).Значение);
				Иначе
					ПостроительЗапроса.Параметры.Вставить(Запись.ИмяОтбора, ТекЗначение);
				КонецЕсли;
				
			Иначе
				
				Отбор = ПостроительЗапроса.Отбор.Добавить(Запись.ИмяОтбора);
				Отбор.Использование = Истина;
				
				Если Запись.ТипОтбора = ВидСравнения.ВСписке
				 ИЛИ Запись.ТипОтбора = ВидСравнения.ВСпискеПоИерархии Тогда
					Если ТекЗначение.Количество() = 1 Тогда
						Отбор.ВидСравнения = ВидСравнения.Равно;
						Отбор.Значение = ТекЗначение[0].Значение;
					Иначе
						Отбор.ВидСравнения = Запись.ТипОтбора;
						Отбор.Значение = ТекЗначение;
					КонецЕсли;
				ИначеЕсли Запись.ТипОтбора = ВидСравнения.НеВСписке
				 ИЛИ Запись.ТипОтбора = ВидСравнения.НеВСпискеПоИерархии Тогда
					Если ТекЗначение.Количество() = 1 Тогда
						Отбор.ВидСравнения = ВидСравнения.НеРавно;
						Отбор.Значение = ТекЗначение[0].Значение;
					Иначе
						Отбор.ВидСравнения = Запись.ТипОтбора;
						Отбор.Значение = ТекЗначение;
					КонецЕсли;
				ИначеЕсли ТекЗначение.Количество() > 0 И ТекЗначение[0].Значение <> Неопределено Тогда
					Отбор.ВидСравнения = Запись.ТипОтбора;
					Отбор.Значение = ТекЗначение[0].Значение;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	МассивИменПолей                = Новый Массив;	
	
	Если ПолученныеДанные.Свойство("ИспользуемыеПоля") И ЗначениеЗаполнено(ПолученныеДанные.ИспользуемыеПоля) Тогда
		ПостроительЗапроса.ВыбранныеПоля.Очистить();
		Для Каждого Запись Из ПолученныеДанные.ИспользуемыеПоля Цикл
			ПостроительЗапроса.ВыбранныеПоля.Добавить(Запись.ПутьКДанным, Запись.ИмяПоля);
		КонецЦикла;
	Иначе
		
		МассивДобавляемыхПредставлений = Новый Массив;
		ОписаниеПримитивныхТипов = Новый ОписаниеТипов("Строка, Число, Дата, Булево");
		
		Для Каждого Поле Из ПостроительЗапроса.ВыбранныеПоля Цикл
			ОписаниеПоля = ПостроительЗапроса.ДоступныеПоля.Найти(Поле.Имя);
			Если ОписаниеПоля <> Неопределено Тогда
				Для Каждого ТекТип Из ОписаниеПоля.ТипЗначения.Типы() Цикл
					Если НЕ ОписаниеПримитивныхТипов.СодержитТип(ТекТип) Тогда
						МассивДобавляемыхПредставлений.Добавить(Поле);
						МассивИменПолей.Добавить(Поле.Имя);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		//Для Каждого Элемент Из МассивДобавляемыхПредставлений Цикл
		//	ПостроительЗапроса.ВыбранныеПоля.Добавить(Элемент.ПутьКДанным + ".Представление", Элемент.Имя + "_Представление");
		//КонецЦикла;
		
	КонецЕсли;
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ПреобразоватьТаблицуКПримитивнымТипам(ПостроительЗапроса.Результат.Выгрузить(),ТаблицаДанных);

	
	СтруктураОтвета.Вставить("РезультатЗапроса", ТаблицаДанных);
	СтруктураОтвета.Вставить("МассивИменПолей", МассивИменПолей);
	
	Возврат Новый ХранилищеЗначения(СтруктураОтвета, Новый СжатиеДанных(9));
	
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// КОПИИ ФУНКЦИЙ, ИСПОЛЬЗУЕМЫХ ПРИ ПОДГОТОВКЕ ЗАПРОСА ДЛЯ ПОЛУЧЕНИЯ ДАННЫХ ИЗ
// ВИБ В УХ
//

// Функция получает таблицу иерархически подчиненных счетов счету, код которого задан
// параметром КодОсновногоСчета.
//
Функция ПолучитьСчетаВИерархии(КодОсновногоСчета, ПланСчетов)
	
	Запрос       = Новый Запрос;
	
	Запрос.Текст =" 
	|ВЫБРАТЬ
	|ПланСчетов.Ссылка КАК Ссылка,
	|ПланСчетов.Код КАК Код
	|ИЗ
	|ПланСчетов."+ПланСчетов+" КАК ПланСчетов
	|ГДЕ
	|ПланСчетов.Ссылка В ИЕРАРХИИ
	|		(ВЫБРАТЬ
	|			ПланОтбор.Ссылка
	|		ИЗ
	|			ПланСчетов."+ПланСчетов+" КАК ПланОтбор
	|		ГДЕ ПланОтбор.Код=&КодОсновногоСчета)";
	
	Запрос.УстановитьПараметр("КодОсновногоСчета",КодОсновногоСчета);
	
	Возврат Запрос.Выполнить().Выгрузить();

	
КонецФункции

// Функция возвращает таблицу иерархически подчиненных статей статье, код которой
// передан в параметре КодОсновнойСтатьи.
//
Функция ПолучитьСтатьиВИерархии(КодОсновнойСтатьи)
	
	Запрос       = Новый Запрос;
	Запрос.Текст="
	|ВЫБРАТЬ
	|СтатьиОборотовПоБюджетам.Ссылка,
	|СтатьиОборотовПоБюджетам.Код
	|ИЗ
	|Справочник.СтатьиОборотовПоБюджетам КАК СтатьиОборотовПоБюджетам
	|ГДЕ
	|(НЕ СтатьиОборотовПоБюджетам.ЭтоГруппа)
	|И СтатьиОборотовПоБюджетам.Ссылка В ИЕРАРХИИ
	|(ВЫБРАТЬ
	|	СтатьиОборотовПоБюджетам.Ссылка
	|ИЗ
	|	Справочник.СтатьиОборотовПоБюджетам КАК СтатьиОборотовПоБюджетам
	|ГДЕ
	|	СтатьиОборотовПоБюджетам.Код = &КодОсновнойСтатьи)";
		
	Запрос.УстановитьПараметр("КодОсновнойСтатьи",КодОсновнойСтатьи);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьЗначениеОтбора(ЗначениеОтбора)
	
	СписокЗначений = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	
	ИмяСправочника = ?(ЗначениеОтбора.Свойство("_Справочник"), ЗначениеОтбора._Справочник, ЗначениеОтбора._Справочники.СправочникБД);
	
	Для Каждого Элемент Из ЗначениеОтбора.МассивОтбора Цикл
		
		Запрос.Текст = "ВЫБРАТЬ Ссылка ИЗ " + ИмяСправочника + " ГДЕ ";
		
		Для Каждого КлючИЗначение Из Элемент Цикл
			Если КлючИЗначение.Ключ = "_ЗначениеКонсолидации" Тогда
				Продолжить;
			ИначеЕсли КлючИЗначение.Ключ = "Ссылка" И Найти(ВРЕГ(КлючИЗначение.Значение), "ЗНАЧЕНИЕ") > 0 Тогда
				Запрос.Текст = Запрос.Текст + " " + КлючИЗначение.Ключ + " = " + КлючИЗначение.Значение + " И ";
			Иначе
				КлючЗначения = СтрЗаменить(КлючИЗначение.Ключ, ".", "_");
				Запрос.Текст = Запрос.Текст + " " + КлючИЗначение.Ключ + " = &" + КлючЗначения + " И ";
				Запрос.УстановитьПараметр(КлючЗначения, КлючИЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Запрос.Текст = Лев(Запрос.Текст, СтрДлина(Запрос.Текст) - 2);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			СписокЗначений.Добавить(Выборка.Ссылка);
			
		Иначе
			
			Если Найти(ИмяСправочника, "Справочник.") > 0 Тогда
				ПустоеЗначение = Справочники[СтрЗаменить(ИмяСправочника, "Справочник.", "")].ПустаяСсылка();
			ИначеЕсли Найти(ИмяСправочника, "ПланСчетов.") > 0 Тогда
				ПустоеЗначение = ПланыСчетов[СтрЗаменить(ИмяСправочника, "ПланСчетов.", "")].ПустаяСсылка();
			ИначеЕсли Найти(ИмяСправочника, "ПланВидовХарактеристик.") > 0 Тогда
				ПустоеЗначение = ПланыВидовХарактеристик[СтрЗаменить(ИмяСправочника, "ПланВидовХарактеристик.", "")].ПустаяСсылка();
			Иначе
				ПустоеЗначение = Перечисления[СтрЗаменить(ИмяСправочника, "Перечисление.", "")].ПустаяСсылка();
			КонецЕсли;
			
			СписокЗначений.Добавить(ПустоеЗначение);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СписокЗначений;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРА ПРЕОБРАЗОВАНИЯ ТАБЛИЦЫ К ПРИМТИТИВНЫМ ТИПАМ.
//
Процедура ПреобразоватьТаблицуКПримитивнымТипам(ТаблицаСсылки, ЛокальнаяТаблица)
	
	ТипКОМБулево = XMLTypeOf(истина);
	ТипКОМЧисло = XMLTypeOf(20);
	ТипКОМСтрока = XMLTypeOf(" ");
	ТипКОМДата = XMLTypeOf(ТекущаяДата());
		
	ЕстьСсылочныеТипы=Ложь;
	
	Для Инд = 0 По ТаблицаСсылки.Columns.Count()-1 Цикл
		
		ОписаниеТипов = Новый ОписаниеТипов;
		
		ТипКомМассив = ТаблицаСсылки.Columns.Get(Инд).ValueType.Types();
		Для Каждого ЭлементМассива Из ТипКомМассив Цикл
			ИмяКолонки = ТаблицаСсылки.Columns.Get(Инд).Title;
			Если XMLType(ЭлементМассива) = ТипКОМБулево Тогда
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТипов, "Булево");
			ИначеЕсли XMLType(ЭлементМассива) = ТипКОМЧисло Тогда
				COM_Digits              = ТаблицаСсылки.Columns.Get(Инд).ValueType.NumberQualifiers.Digits;
				COM_FractionDigits      = ТаблицаСсылки.Columns.Get(Инд).ValueType.NumberQualifiers.FractionDigits;
				COM_AllowedSign         = ТаблицаСсылки.Columns.Get(Инд).ValueType.NumberQualifiers.AllowedSign;
				ЛюбойЗнак           = AllowedSign.Any;
				НеотрицательныйЗнак = AllowedSign.Nonnegative;
				Если COM_AllowedSign = ЛюбойЗнак Тогда
					Знак = ДопустимыйЗнак.Любой;
				КонецЕсли;
				Если COM_AllowedSign = НеотрицательныйЗнак Тогда
					Знак = ДопустимыйЗнак.Неотрицательный;
				КонецЕсли;
				Квалификатор = Новый КвалификаторыЧисла(COM_Digits, COM_FractionDigits, Знак);
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТипов,"Число",, Квалификатор);
			ИначеЕсли XMLType(ЭлементМассива) = ТипКОМСтрока Тогда
				COM_Length = ТаблицаСсылки.Columns.Get(Инд).ValueType.StringQualifiers.Length;
				COM_AllowedLength = ТаблицаСсылки.Columns.Get(Инд).ValueType.StringQualifiers.AllowedLength;
				ДлинаФиксированная = AllowedLength.Variable;
				ДлинаПеременная = AllowedLength.Fixed;
				Квалификатор = Новый КвалификаторыСтроки(COM_Length, ДопустимаяДлина.Переменная);
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТипов,"Строка",,,Квалификатор);
			ИначеЕсли XMLType(ЭлементМассива) = ТипКОМДата Тогда
				COM_DateFractions = ТаблицаСсылки.Columns.Get(Инд).ValueType.DateQualifiers.DateFractions;
				ТолькоДата    = DateFractions.Date;
				ТолькоВремя   = DateFractions.Time;
				ДатаВремя     = DateFractions.DateTime;
				Если COM_DateFractions = ТолькоДата Тогда
					ДатаЧасть = ЧастиДаты.Дата;
				КонецЕсли;
				Если COM_DateFractions = ТолькоВремя Тогда
					ДатаЧасть = ЧастиДаты.Время;
				КонецЕсли;
				Если COM_DateFractions = ДатаВремя Тогда
					ДатаЧасть = ЧастиДаты.ДатаВремя;
				КонецЕсли;
				Квалификатор = Новый КвалификаторыДаты(ДатаЧасть);
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТипов,"Дата",,,,Квалификатор);
				
			ИначеЕсли НЕ XMLType(ЭлементМассива).TypeName="Null" Тогда // По умолчанию подставляем строку
				
				ЕстьСсылочныеТипы=Истина;
				
				Квалификатор = Новый КвалификаторыСтроки(150, ДопустимаяДлина.Переменная);
				ОписаниеТипов = Новый ОписаниеТипов(ОписаниеТипов,"Строка",,,Квалификатор);
								
			КонецЕсли;
			
		КонецЦикла;// Построение типов
		
		ЛокальнаяТаблица.Колонки.Добавить(ИмяКолонки,ОписаниеТипов,ИмяКолонки);
		
	КонецЦикла;
	
	Для Каждого СтрокаРезультатовСсылки Из ТаблицаСсылки Цикл
		
		НоваяСтрока = ЛокальнаяТаблица.Добавить();
		Для Инд1 = 0 По ТаблицаСсылки.Columns.Count()-1 Цикл
			
			Если ЕстьСсылочныеТипы Тогда
				
				ТипДанных=XMLTypeof(СтрокаРезультатовСсылки.Get(Инд1));
				
				Если ТипДанных=Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаТипа=XMLTypeof(СтрокаРезультатовСсылки.Get(Инд1)).TypeName;
				
				Если СтрНайти(СтрокаТипа,"EnumRef")>0 Тогда
					
					НоваяСтрока[Инд1] =ПолучитьТекстПеречисленияИЗВИБ(СтрокаРезультатовСсылки.Get(Инд1));
					
				ИначеЕсли СтрНайти(СтрокаТипа,"DocumentRef")>0 Тогда
					
					МассивПутей=РазложитьСтрокуВМассивПодстрок(ТаблицаСсылки.Columns.Get(Инд1).Name,"vzv");
					
					СтрРеквизит=МассивПутей[МассивПутей.Количество()-1];
					
					Если СтрРеквизит="Ссылка" Тогда
						
						НоваяСтрока[Инд1]=СтрЗаменить(СтрокаТипа,"DocumentRef","Документ");
						
					ИначеЕсли СтрРеквизит="ЭлементСсылка" ИЛИ СтрРеквизит="Ref" Тогда
						
						НоваяСтрока[Инд1] = XMLСтрока(СтрокаРезультатовСсылки.Get(Инд1));
						
					КонецЕсли;
						
				ИначеЕсли СтрНайти(СтрокаТипа,"CatalogRef")>0 Тогда
					
					МассивПутей=РазложитьСтрокуВМассивПодстрок(ТаблицаСсылки.Columns.Get(Инд1).Name,"vzv");
					
					СтрРеквизит=МассивПутей[МассивПутей.Количество()-1];
					
					Если СтрРеквизит="Ссылка" Тогда
						
						НоваяСтрока[Инд1]=СтрЗаменить(СтрокаТипа,"CatalogRef","Справочник");
						
					ИначеЕсли СтрРеквизит="ЭлементСсылка" ИЛИ СтрРеквизит="Ref" Тогда
						
						НоваяСтрока[Инд1] = XMLСтрока(СтрокаРезультатовСсылки.Get(Инд1));
						
					КонецЕсли;
					
				ИначеЕсли СтрНайти(СтрокаТипа,"ChartOfCharacteristicTypesRef")>0 Тогда
					
					МассивПутей=РазложитьСтрокуВМассивПодстрок(ТаблицаСсылки.Columns.Get(Инд1).Name,"vzv");
					
					СтрРеквизит=МассивПутей[МассивПутей.Количество()-1];
					
					Если СтрРеквизит="Ссылка" Тогда
						
						НоваяСтрока[Инд1]=СтрЗаменить(СтрокаТипа,"ChartOfCharacteristicTypesRef","ПланВидовХарактеристик");
						
					ИначеЕсли СтрРеквизит="ЭлементСсылка" ИЛИ СтрРеквизит="Ref" Тогда
						
						НоваяСтрока[Инд1] = XMLСтрока(СтрокаРезультатовСсылки.Get(Инд1));
						
					КонецЕсли;
					
				Иначе
					
					МассивПутей=РазложитьСтрокуВМассивПодстрок(ТаблицаСсылки.Columns.Get(Инд1).Name,"vzv");
					СтрРеквизит=МассивПутей[МассивПутей.Количество()-1];
					
					Если СтрРеквизит="ЭлементСсылка" ИЛИ СтрРеквизит="Ref" Тогда
						
						НоваяСтрока[Инд1] = XMLСтрока(СтрокаРезультатовСсылки.Get(Инд1));
						
					Иначе
						
						НоваяСтрока[Инд1] = СтрокаРезультатовСсылки.Get(Инд1);
						
					КонецЕсли;
					
				КонецЕсли;
	 		
			Иначе	
				
				НоваяСтрока[Инд1] = СтрокаРезультатовСсылки.Get(Инд1);
				
			КонецЕсли;
			
		КонецЦикла
		
	КонецЦикла;
	
КонецПроцедуры

// Функция "расщепляет" строку на подстроки, используя заданный 
//		разделитель. Разделитель может иметь любую длину. 
//		Если в качестве разделителя задан пробел, рядом стоящие пробелы 
//		считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр
//		игнорируются.
//		Например, 
//		РазложитьСтрокуВМассивПодстрок(",ку,,,му", ",") возвратит массив значений из пяти элементов, 
//		три из которых - пустые строки, а 
//		РазложитьСтрокуВМассивПодстрок(" ку   му", " ") возвратит массив значений из двух элементов
//
//	Параметры: 
//		Стр - 			строка, которую необходимо разложить на подстроки. 
//						Параметр передается по значению.
//		Разделитель - 	строка-разделитель, по умолчанию - запятая.
//
//
//	Возвращаемое значение:
//		массив значений, элементы которого - подстроки
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	Возврат РаботаСОбъектамиМетаданныхВнешнийУХ.РазложитьСтрокуВМассивПодстрок(Стр, Разделитель,Ложь);
	
КонецФункции // глРазложить

Функция ПолучитьТекстПеречисленияИЗВИБ(ЗначениеПеречисления) Экспорт
	
	Возврат XMLString(ЗначениеПеречисления);
		
КонецФункции // ПолучитьТекстПеречисленияИЗВИБ()

Процедура ДобавитьМассивВСписокЗначений(Список, мЗначений)
	Если ТипЗнч(мЗначений) <> Тип("Массив") ИЛИ ТипЗнч(мЗначений) <> Тип("ФиксированныйМассив") Тогда
		Возврат;
	КонецЕсли;
	Для Каждого ЭлементМассива Из мЗначений Цикл
		Список.Добавить(ЭлементМассива);
	КонецЦикла;
КонецПроцедуры

Функция ПолучитьПредставлениеСсылки(ТекСсылка)
	
	Попытка
		Возврат Новый Структура("ТипЗначения, Значение", XMLТипЗнч(ТекСсылка).ИмяТипа, XMLСтрока(ТекСсылка));
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция GetReportRepresentation(StringPresentation)
	
	ЦветФонаРеквизита         = Новый Цвет(255, 233, 188);
	ЦветФонаЗначения          = Новый Цвет(255, 247, 229);
	ЦветФонаТабличнойЧасти    = Новый Цвет(230, 230, 240);
	ЦветРамкиРеквизита        = Новый Цвет(128, 0, 0);
	ЦветРамкиТабличнойЧасти   = Новый Цвет(100, 100, 150);
	ЦветаТабличнойЧасти = Новый Массив;
	ЦветаТабличнойЧасти.Добавить(Новый Цвет(230, 230, 250));
	ЦветаТабличнойЧасти.Добавить(Новый Цвет(245, 245, 250));
	
	СтруктураИмен = Новый Структура("Справочник, Документ, ПланСчетов, ПланВидовХарактеристик, ПланВидовРасчетов", "Справочники"
									, "Документы"
									, "ПланыСчетов"
									, "ПланыВидовХарактеристик"
									, "ПланыВидовРасчетов");
	
	Позиция = Найти(StringPresentation, "&&");
	НаименованиеМетаданных = Лев(StringPresentation, Позиция - 1);
	
	ТекСсылка = Неопределено;
	Для Каждого Запись Из СтруктураИмен Цикл
		КлючПоиска = Запись.Ключ + ".";
		Если СтрЧислоВхождений(НаименованиеМетаданных, КлючПоиска) > 0 Тогда
			ИмяОбъекта    = СтрЗаменить(НаименованиеМетаданных, КлючПоиска, "");
			Попытка
				ТекСсылка    = Вычислить(Запись.Значение + "." + ИмяОбъекта + ".ПолучитьСсылку(Новый УникальныйИдентификатор(""" + Сред(StringPresentation, Позиция + 2)+ """))");
			Исключение
				Возврат Новый ХранилищеЗначения(Неопределено);
			КонецПопытки;
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если ТЕкСсылка = Неопределено Тогда
		Возврат Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
	ТабличныйДокумент = Новый Табличныйдокумент;
	ТекМетаданные = Метаданные.НайтиПоПолномуИмени(StringPresentation.ТипЗначения);
	
	СоответствиеШиринКолонок = Новый Соответствие;
	
	ОписаниеПримитивныхТипов = Новый ОписаниеТИпов("Строка, Число, Булево, Дата");
	
	ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,1, 1, Запись.Ключ, СоответствиеШиринКолонок, 12, Истина);
	ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,2, 1, ТекМетаданные.Синоним, СоответствиеШиринКолонок, 12, Истина);
	
	Если Запись.Ключ = "Документ" Тогда
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,3, 1, Нстр("ru = 'Номер '"), СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,3, 2, ТекСсылка.Номер, СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,4, 1, Нстр("ru = ' от '"), СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,4, 2, ТекСсылка.Дата, СоответствиеШиринКолонок, 10, Истина);
	Иначе
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,3, 1, Нстр("ru = 'Код '"), СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,3, 2, ТекСсылка.Код, СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,4, 1, "Наименование", СоответствиеШиринКолонок, 10, Истина);
		ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,4, 2, ТекСсылка.Наименование, СоответствиеШиринКолонок, 10, Истина);
	КонецЕсли;
	
	ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,6, 1, Нстр("ru = 'Реквизиты:  '"), СоответствиеШиринКолонок, 10, Истина);
	
	ТекСтрока = 7;
	
	Для Каждого Реквизит Из ТекМетаданные.Реквизиты Цикл
		Если ЗначениеЗаполнено(ТекСсылка[Реквизит.Имя]) Тогда
			ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,ТекСтрока, 1, Реквизит.Синоним, СоответствиеШиринКолонок, , Истина, Истина, ЦветФонаРеквизита, ЦветРамкиРеквизита);
			ВывестиПоКоординатам(ОписаниеПримитивныхТипов, ТабличныйДокумент,ТекСтрока, 2, ТекСсылка[Реквизит.Имя], СоответствиеШиринКолонок, , , Истина, ЦветФонаЗначения, ЦветРамкиРеквизита);
			ТекСтрока = ТекСтрока + 1;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТабличнаяЧасть Из ТекМетаданные.ТабличныеЧасти Цикл
		
		ТекТаблЧасть = ТекСсылка[ТабличнаяЧасть.Имя];
		
		Если ТекТаблЧасть.Количество() > 0 Тогда
			
			ТекСтрока = ТекСтрока + 1;
			ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,ТекСтрока, 1, ТабличнаяЧасть.Синоним, , 10, Истина,);
			МассивРеквизитов = Новый Массив;
			ТекСтрока = ТекСтрока + 1;
			ТекКолонка = 1;
			НачалоСтрок = ТекСтрока;
			
			Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
				МассивРеквизитов.Добавить(Реквизит.Имя);
				ВывестиПоКоординатам(Неопределено, ТабличныйДокумент,ТекСтрока, ТекКолонка, Реквизит.Синоним, , ,Истина, Истина, ЦветФонаТабличнойЧасти, ЦветРамкиТабличнойЧасти);
				ТекКолонка = ТекКолонка + 1;
			КонецЦикла;
			
			ТекСтрока = ТекСтрока + 1;
			
			ТекИнд = 0;
			
			Для Каждого Строка Из ТекТаблЧасть Цикл
				ТекКолонка = 1;
				Для Каждого Реквизит Из МассивРеквизитов Цикл
					ВывестиПоКоординатам(ОписаниеПримитивныхТипов, ТабличныйДокумент,ТекСтрока, ТекКолонка, Строка[Реквизит], СоответствиеШиринКолонок, , , Истина, ЦветаТабличнойЧасти[ТекИнд], ЦветРамкиТабличнойЧасти);
					ТекКолонка = ТекКолонка + 1;
				КонецЦикла;
				ТекИнд = ?(ТекИнд = 0, 1, 0);
				ТекСтрока = ТекСтрока + 1;
			КонецЦикла;
		
			ТабличныйДокумент.Область(НачалоСтрок, , ТекСтрока).Сгруппировать();
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Запись Из СоответствиеШиринКолонок Цикл
		ТабличныйДокумент.Область(1, Запись.Ключ, ТекСтрока).ШиринаКолонки = ?(Запись.Значение < 8, 8, ?(Запись.Значение > 40, 40, Запись.Значение));
	КонецЦикла;

	Возврат Новый ХранилищеЗначения(ТабличныйДокумент);
	
КонецФункции

Функция ВернутьРасшифровку(ОписаниеПримитивныхТипов, ЗначениеПоказателя)
	
	Если НЕ ОписаниеПримитивныхТипов.СодержитТип(ТипЗнч(ЗначениеПоказателя)) Тогда
		Возврат ПолучитьПредставлениеСсылки(ЗначениеПОказателя);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура ВывестиПоКоординатам(ОписаниеПримитивныхТипов, ТабличныйДокумент, Строка, Столбец, Значение, СоответствиеШиринКолонок = Неопределено, Размер = 8, Жирный = Ложь, Обвести = Ложь, ЦветФона = Неопределено, ЦветРамки = Неопределено)
	
	Если ЦветФона = Неопределено Тогда
		ЦветФона = Новый Цвет;
	КонецЕсли;
	
	Если ЦветРамки = Неопределено Тогда
		ЦветРамки = Новый Цвет;
	КонецЕсли;
	
	ТекОбласть       = ТабличныйДокумент.Область(Строка, Столбец);
	ТекОБласть.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
	
	ТекОбласть.ЦветФона  = ЦветФона;
	ТекОбласть.ЦветРамки = ЦветРамки;
	ТекОбласть.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
	ТекОбласть.Шрифт = Новый Шрифт(ТекОбласть.Шрифт, , Размер, Жирный);
	
	Если ТипЗнч(Значение) = Тип("Булево") Тогда
		Если Значение Тогда
			ТекОбласть.Текст = "да";
			ТекОбласть.ЦветТекста = WebЦвета.Зеленый;
		Иначе
			ТекОбласть.Текст = "нет";
			ТекОбласть.ЦветТекста = WebЦвета.Красный;
		КонецЕсли;
		
		ТекОБласть.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		
	Иначе
		
		Если ОписаниеПримитивныхТипов <> Неопределено Тогда
			ТекОбласть.Расшифровка = ВернутьРасшифровку(ОписаниеПримитивныхТипов, Значение);
		КонецЕсли;

		ТекОбласть.Текст = Значение;
	КонецЕсли;
	
	Если Обвести Тогда
		Линия = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
		ТекОбласть.Обвести(Линия, Линия, Линия, Линия);
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(СокрЛП(ТабличныйДокумент.Область(Строка, Столбец).текст));
	
	Если СоответствиеШиринКолонок <> Неопределено Тогда
		Если СоответствиеШиринКолонок[Столбец] = Неопределено ИЛИ СоответствиеШиринКолонок[Столбец] <= ДлинаСтроки Тогда
			СоответствиеШиринКолонок.Вставить(Столбец, ДлинаСтроки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция GetPropertiesOfMetadataObject(InitialData)
	
	ШаблонОписания = InitialData.Получить();
	ШаблонОписания.Вставить("ТекущаяИБ", Ложь);
	
	ТекСоединениеВИБ = ПолучитьКоннекторИБ(ШаблонОписания);
	
	Результат = СтруктураОписанияОбъекта(ШаблонОписания, ТекСоединениеВИБ);			
	Возврат Новый ХранилищеЗначения(Результат, Новый СжатиеДанных(9));
		
КонецФункции

Функция СтруктураОписанияОбъекта(ШаблонОписания, ТекСоединениеВИБ, Кэш = Неопределено)
	
	М = РаботаСОбъектамиМетаданныхВнешнийУХ;
	
	Если ШаблонОписания.Свойство("Tabular") Тогда
		
		Возврат М.ПолучитьМассивСтруктурТабличныхЧастей1CПредприятие8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
	
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "Catalogs" Тогда
		
		Возврат М.СтруктураОписанияСправочника8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
				
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "Documents" Тогда
		
		Возврат М.СтруктураОписанияДокумента8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "ChartsOfCharacteristicTypes" Тогда
		
		Возврат М.СтруктураОписанияПланаВидовХарактеристик8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "Enums" Тогда
		
		Возврат М.СтруктураОписанияПеречисления8х(ШаблонОписания, ТекСоединениеВИБ);
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "AccumulationRegisters" Тогда
		
		Возврат М.СтруктураОписанияРегистраНакопления8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "AccountingRegisters" Тогда
		
		Возврат М.СтруктураОписанияРегистраБухгалтерии8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "ChartsOfAccounts" Тогда
		
		СтруктураОписания = М.СтруктураОписанияПланаСчетов8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		Если СтруктураОписания.Свойство("ПланСчетовБД") Тогда
			СтруктураОписания.Удалить("ПланСчетовБД"); // объект метаданных, не сериализуется
		КонецЕсли;
		Возврат СтруктураОписания;
		
	ИначеЕсли ШаблонОписания.ТипОбъектаМетаданных = "InformationRegisters" Тогда
		
		Возврат М.СтруктураОписанияРегистраСведений8х(ШаблонОписания, ТекСоединениеВИБ, Кэш);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция GetArrayOfMetadataObjectsName(InitialData)
	
	ДанныеОбъектаМетаданных=InitialData.Получить();
	
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеОбъектаМетаданных);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.ПолучитьМассивИменОбъектов8x(ДанныеОбъектаМетаданных.ТипОбъектаМетаданных,ТекСоединениеВИБ),Новый СжатиеДанных(9));
		
КонецФункции

Функция GetDescriptionOfCustomQuery(InitialData)
	
	ДанныеЗапроса=InitialData.Получить();
	
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеЗапроса);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.СтруктураОписанияПроизвольногоЗапроса8х(ТекСоединениеВИБ,ДанныеЗапроса.ТекстЗапросаМодуля),Новый СжатиеДанных(9));
		
КонецФункции

Функция GetTableOfObjectsID(InitialData)
	
	ДанныеОбъектаМД=InitialData.Получить();
	
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеОбъектаМД);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.ПолучитьТаблицуИдентификаторовОбъектов8х(ТекСоединениеВИБ,ДанныеОбъектаМД.ТаблицаАналитики),Новый СжатиеДанных(9));
	
КонецФункции

Функция ПолучитьКоннекторИБ(СтруктураПараметров)
	
	Перем ПараметрыПодключения;
	
	СтруктураПараметров.Свойство("ПараметрыПодключения",ПараметрыПодключения);
	
	Если ПараметрыПодключения=Неопределено Тогда 
		
		Возврат Обработки.РаботаСМетаданнымиУХ.Создать();
		
	Иначе // Вызываем получение коннектора к ВИБ
		
		
			
	КонецЕсли;
		
КонецФункции // ПолучитьКоннекторИБ()

Функция GetWorkingDataTable(InitialData)
	
	ДанныеДляЗапроса=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеДляЗапроса);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.ПолучитьРабочуюТаблицуДанных8х(ТекСоединениеВИБ,ДанныеДляЗапроса),Новый СжатиеДанных(9));

КонецФункции

Функция FillInAnalyticsByRules(InitialData)
	
	Параметрыфункции=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(Параметрыфункции);
	
	РезультатФункции=РаботаСОбъектамиМетаданныхВнешнийУХ.ВИБ_ЗаполнитьАналитикуПоПравилам(ТекСоединениеВИБ,
			Параметрыфункции.ТаблицаДанных,
			Параметрыфункции.ТабПравилаДляВыгрузки,
			Параметрыфункции.СтруктураКлючевыхРеквизитов,
			Параметрыфункции.СтруктураПодчиненныхРеквизитов);
	
	Возврат Новый ХранилищеЗначения(РезультатФункции,Новый СжатиеДанных(9));

КонецФункции

Функция FillInMissingItems(InitialData)
	
	Параметрыфункции=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(Параметрыфункции);
	
	РезультатФункции=РаботаСОбъектамиМетаданныхВнешнийУХ.ВИБ_ЗаполнитьНедостающиеАналитики(ТекСоединениеВИБ,
										Параметрыфункции.ТаблицаИмпорта,
										Параметрыфункции.СтруктураКлючевыхРеквизитов,
										Параметрыфункции.СтруктураПодчиненныхРеквизитов,
										Параметрыфункции.ПравилаИспользованияПолей,
										Параметрыфункции.ОбновлениеДочернихЭлементов);
	
	Возврат Новый ХранилищеЗначения(РезультатФункции,Новый СжатиеДанных(9));

КонецФункции

Функция GetDataForReportRegister(ReportParameters, ConnectionParameters)
	
	ТекПараметрыПодключения=ConnectionParameters.Получить();
	
	ОбработкаОбъект=Обработки.УниверсальнаяОтчетностьПоРегистрамУХ.Создать();
	ОбработкаОбъект.ПараметрыОтчета=ReportParameters;
	ОбработкаОбъект.ТекСоединениеВИБ=ПолучитьКоннекторИБ(ТекПараметрыПодключения);
	
	ДанныеДляВывода=ОбработкаОбъект.СформироватьОтчет();
	
	Возврат Новый ХранилищеЗначения(ДанныеДляВывода,Новый СжатиеДанных(9));
	
КонецФункции

Функция GetObjectRepresentation(ObjectParameters, ConnectionParameters)
	
	ТекПараметрыПодключения=ConnectionParameters.Получить();
	
	ОбработкаОбъект=Обработки.УниверсальнаяОтчетностьПоРегистрамУХ.Создать();
	ОбработкаОбъект.ПараметрыОбъектаДляОтображения=ObjectParameters;
	ОбработкаОбъект.ТекСоединениеВИБ=ПолучитьКоннекторИБ(ТекПараметрыПодключения);
			
	ДанныеДляОтображения=ОбработкаОбъект.ПолучитьОтображениеОбъектаБД();
	
	Возврат Новый ХранилищеЗначения(ДанныеДляОтображения,Новый СжатиеДанных(9));
	
КонецФункции

Функция FillValueTreeForCatalog(InitialData)
	
	ДанныеЗапроса=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеЗапроса);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.ЗаполнитьДеревоЗначенийДляСправочника8х(ТекСоединениеВИБ,ДанныеЗапроса.РабочиеПараметры),Новый СжатиеДанных(9));

КонецФункции

Функция FillValueTreeForEnum(InitialData)
	
	ДанныеЗапроса=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(ДанныеЗапроса);
	
	Возврат Новый ХранилищеЗначения(РаботаСОбъектамиМетаданныхВнешнийУХ.ЗаполнитьДеревоЗначенийДляПеречисления8х(ТекСоединениеВИБ,ДанныеЗапроса.РабочиеПараметры),Новый СжатиеДанных(9));
		
КонецФункции

Функция СкопироватьШаблонОписания(ШаблонОписания)
	
	КопияШаблона = Новый Структура;
	Для каждого Элемент ИЗ ШаблонОписания Цикл
		
		Значение = Элемент.Значение;
		Если ТипЗнч(Значение) = Тип("ТаблицаЗначений") Тогда
			Значение = Значение.СкопироватьКолонки();
		КонецЕсли;
		
		КопияШаблона.Вставить(Элемент.Ключ, Значение);
		
	КонецЦикла;
	
	Возврат КопияШаблона;
	
КонецФункции	

Функция GetObjectsMetadata(InitialData)
	
	МассивЗапросов = InitialData.Получить();
	СоответствиеМетаданных = Новый Соответствие;
	
	ТекСоединениеВИБ = ПолучитьКоннекторИБ(Новый Структура);
	Кэш = РаботаСОбъектамиМетаданныхУХ.НовыйКэшОбновленияМетаданных();
	РаботаСОбъектамиМетаданныхУХ.ИнициализироватьКэш(Кэш, ТекСоединениеВИБ);
	
	Для каждого ДанныеЗапроса Из МассивЗапросов Цикл
		
		ТипОбъектаМетаданных = ДанныеЗапроса.ТипОбъектаМетаданных;
		ЕстьТабличныеЧасти = ДанныеЗапроса.ЕстьТабличныеЧасти;
		ОбщийШаблонОписания = ДанныеЗапроса.ШаблонОписания;
			
		ОписаниеМетаданных = Новый Структура;
		ОписаниеМетаданных.Вставить("ИменаОбъектов", 
		РаботаСОбъектамиМетаданныхВнешнийУХ.ПолучитьМассивИменОбъектов8x(ТипОбъектаМетаданных, ТекСоединениеВИБ));
		
		ОписанияОбъектов = Новый Соответствие;	
		Для каждого ИмяОбъекта Из ОписаниеМетаданных.ИменаОбъектов Цикл
			
			ШаблонОписания = СкопироватьШаблонОписания(ОбщийШаблонОписания);
			ШаблонОписания.Вставить("ИмяОбъектаМетаданных",	ИмяОбъекта);
			ШаблонОписания.Вставить("ТекущаяИБ", Ложь);
			
			СтруктураОписания = СтруктураОписанияОбъекта(ШаблонОписания, ТекСоединениеВИБ, Кэш);		
			ОписанияОбъектов.Вставить(ИмяОбъекта, СтруктураОписания);
			
		КонецЦикла;
		
		ОписаниеМетаданных.Вставить("ОписанияОбъектов", ОписанияОбъектов);
		
		Если ЕстьТабличныеЧасти Тогда
			
			ТабличныеЧастиОбъектов = Новый Соответствие;
			Для каждого ИмяОбъекта Из ОписаниеМетаданных.ИменаОбъектов Цикл		
				
				ШаблонОписания = СкопироватьШаблонОписания(ОбщийШаблонОписания);
				ШаблонОписания.Вставить("ИмяОбъектаМетаданных",	ИмяОбъекта);
				ШаблонОписания.Вставить("Tabular", Истина);
				ШаблонОписания.Вставить("ТекущаяИБ", Ложь);
				
				СтруктураОписания = СтруктураОписанияОбъекта(ШаблонОписания, ТекСоединениеВИБ, Кэш);
				ТабличныеЧастиОбъектов.Вставить(ИмяОбъекта, СтруктураОписания);
			КонецЦикла;
			
			ОписаниеМетаданных.Вставить("ТабличныеЧастиОбъектов", ТабличныеЧастиОбъектов);
			
		КонецЕсли;
		
		СоответствиеМетаданных.Вставить(ТипОбъектаМетаданных, ОписаниеМетаданных);
		
	КонецЦикла;
		
	Возврат Новый ХранилищеЗначения(СоответствиеМетаданных, Новый СжатиеДанных(9));
		
КонецФункции

Функция FillInAssociatedTables(InitialData)
	
	Параметрыфункции=InitialData.Получить();
	ТекСоединениеВИБ=ПолучитьКоннекторИБ(Параметрыфункции);
	
	РезультатФункции=РаботаСОбъектамиМетаданныхВнешнийУХ.ВИБ_ЗаполнитьСвязанныеТаблицы(ТекСоединениеВИБ,
										Параметрыфункции.ПравилаДляВыгрузки,
										Параметрыфункции.СоответствиеНаборов,
										Параметрыфункции.ДанныеПриемника);
	
	Возврат Новый ХранилищеЗначения(РезультатФункции,Новый СжатиеДанных(9));
	
	
КонецФункции
