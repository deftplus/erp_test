
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьВозможныеПустыеСсылки() Экспорт

	ПустыеСсылки = Новый Массив;
	Для каждого ДоступныйТип Из Метаданные.ПланыВидовХарактеристик.ВидыСубконтоКорпоративные.Тип.Типы() Цикл	
		ПустыеСсылки.Добавить(ОбщегоНазначенияКлиентСерверУХ.ПустоеЗначениеТипа(ДоступныйТип));
	КонецЦикла;
	
	Возврат ПустыеСсылки;

КонецФункции

Функция ПолучитьШаблонТаблицыРеквизитов()
	
	ТаблицаРеквизитов=Новый ТаблицаЗначений;
	ТаблицаРеквизитов.Колонки.Добавить("Имя",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(100));
	ТаблицаРеквизитов.Колонки.Добавить("Синоним",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(0));
	ТаблицаРеквизитов.Колонки.Добавить("ТипДанных",ОбщегоНазначенияУХ.ПолучитьОписаниеТиповСтроки(0));
	
	Возврат ТаблицаРеквизитов;

КонецФункции // ПолучитьШаблонТаблицыРеквизитов()

Функция ПолучитьТаблицуРеквизитовСинхронизации(ТипЗначения, ТолькоПримитивные = Ложь) Экспорт
	
	ТекстЗапроса="";
	СоответствиеОбъектов=Новый Соответствие;
	СоответствиеОбъектов.Вставить("Справочник",				"Справочник.СправочникиБД");
	СоответствиеОбъектов.Вставить("Документ",				"Справочник.ДокументыБД");
	СоответствиеОбъектов.Вставить("ПланВидовХарактеристик",	"Справочник.ПланыВидовХарактеристикБД");
	
	Если НЕ ТипЗначения=Тип("Строка") Тогда
		
		СтрокаТипов=ОбщегоНазначенияУХ.ПолучитьСтрокуТиповДанныхБД(Неопределено,ТипЗначения,Справочники.ТипыБазДанных.ТекущаяИБ,Ложь);
		
	Иначе
		
		СтрокаТипов=ТипЗначения;
		
	КонецЕсли;	
	
	МассивТипов=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(СтрокаТипов,";");
	ТекстЗапроса="";
	
	ЕстьПеречисление=Ложь;
	КоличествоСсылочных=0;
	
	Запрос=Новый Запрос;
		
	Для Каждого СтрТип ИЗ МассивТипов Цикл
		
		МассивСтрок=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(СтрТип,".");
		
		Если МассивСтрок[0]="Перечисление" Тогда
			
			ЕстьПеречисление=Истина;
			Продолжить;
			
		Иначе
			
			ИмяТаблицы=СоответствиеОбъектов[МассивСтрок[0]];
			
			Если ИмяТаблицы=Неопределено Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			КоличествоСсылочных=КоличествоСсылочных+1;
			
			ТекстЗапроса=ТекстЗапроса+"
			|ОБЪЕДИНИТЬ ВСЕ
			|ВЫБРАТЬ
			|	ТаблицаРеквизитов.Имя КАК Имя,
			|	ВЫРАЗИТЬ(ТаблицаРеквизитов.Синоним КАК СТРОКА(1000)) КАК Синоним,
			|	ВЫРАЗИТЬ(ТаблицаРеквизитов.ТипДанных КАК СТРОКА(1000)) КАК ТипДанных,
			|	1 КАК Вхождение
			|ИЗ "+ИмяТаблицы+".Реквизиты КАК ТаблицаРеквизитов
			|ГДЕ ТаблицаРеквизитов.Ссылка.Владелец=Значение(Справочник.ТипыБазДанных.ТекущаяИБ)
			|И ТаблицаРеквизитов.Ссылка.Наименование="""+МассивСтрок[1]+"""";
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если СтрДлина(ТекстЗапроса)=0 Тогда
		
		ТаблицаРеквизитов=ПолучитьШаблонТаблицыРеквизитов();
		
		Если ЕстьПеречисление Тогда
			
			НоваяСтрока=ТаблицаРеквизитов.Добавить();
			НоваяСтрока.Имя="Наименование";
			НоваяСтрока.Синоним="Наименование";
			
		КонецЕсли;
		
		Возврат ТаблицаРеквизитов;
		
	КонецЕсли;
			
	Запрос=Новый Запрос;
	Запрос.Текст="
	|ВЫБРАТЬ
	|РеквизитыСвод.Имя,
	|РеквизитыСвод.Синоним,
	|РеквизитыСвод.ТипДанных,
	|СУММА(РеквизитыСвод.Вхождение) КАК Вхождение
	|ИЗ ("+Сред(ТекстЗапроса,16)+") КАК РеквизитыСвод
	|СГРУППИРОВАТЬ ПО РеквизитыСвод.Имя,РеквизитыСвод.Синоним,РеквизитыСвод.ТипДанных
	|ИМЕЮЩИЕ СУММА(РеквизитыСвод.Вхождение)="+КоличествоСсылочных+";";
	
	ТаблицаРеквизитов=Запрос.Выполнить().Выгрузить();
	
	Если ЕстьПеречисление Тогда
		
		Если ТаблицаРеквизитов.Количество()=0 Тогда
			
			НоваяСтрока=ТаблицаРеквизитов.Добавить();
			НоваяСтрока.Имя="Наименование";
			НоваяСтрока.Синоним="Наименование";
			
			Возврат ТаблицаРеквизитов;
			
		Иначе
			
			ТаблицаРеквизитов.Очистить();
			Возврат ТаблицаРеквизитов;
			
		КонецЕсли;
					
	ИначеЕсли НЕ ТолькоПримитивные Тогда
		
		Возврат ТаблицаРеквизитов;
		
	Иначе
		
		ТаблицаПримитивных=ТаблицаРеквизитов.СкопироватьКолонки();
		
		Для Каждого Строка ИЗ ТаблицаРеквизитов Цикл
			
			Если ОбщегоНазначенияУХ.ПримитивныйТипСтрока(Строка.ТипДанных) Тогда
				
				НоваяСтрока=ТаблицаПримитивных.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,Строка);
				
			КонецЕсли;
			
		КонецЦикла;
		
		Возврат ТаблицаПримитивных;
		
	КонецЕсли;	
	
КонецФункции // ПолучитьТаблицуРеквизитовСинхронизации()

Функция ПолучитьВидыСубконтоПоТипуЧерезСубконтоСчетов(ПолноеИмяМетаданных) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СчетаБДВидыСубконто.ВидСубконтоСсылка КАК ВидСубконтоСсылка
	|ИЗ
	|	Справочник.СчетаБД.ВидыСубконто КАК СчетаБДВидыСубконто
	|ГДЕ
	|	СчетаБДВидыСубконто.ТипДанных ПОДОБНО &ПолноеИмяМетаданных
	|	И СчетаБДВидыСубконто.Ссылка.Владелец = &ПланСчетовБД
	|	И СчетаБДВидыСубконто.ВидСубконтоСсылка <> ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоКорпоративные.ПустаяСсылка)");
	
	Запрос.УстановитьПараметр("ПолноеИмяМетаданных", ПолноеИмяМетаданных);

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидСубконтоСсылка");
	
КонецФункции

Функция ПолучитьОписаниеТиповСтрокой(ЗначениеОписаниеТипов) Экспорт

	Результат = Новый Массив;
	
	Для каждого ТекущийТип Из ЗначениеОписаниеТипов.Типы() Цикл	
		Результат.Добавить(Метаданные.НайтиПоТипу(ТекущийТип).ПолноеИмя());	
	КонецЦикла;
	
	Возврат СтрСоединить(Результат, ",");

КонецФункции

// Функция возвращает ПВХ по описанию типа
Функция ПолучитьПоОписаниюТипов(ОписаниеТипа) экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыСубконтоКорпоративные.Ссылка КАК Ссылка,
	|	ВидыСубконтоКорпоративные.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконтоКорпоративные";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если ОписаниеТипа = Выборка.ТипЗначения Тогда
			Возврат Выборка.Ссылка;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьПоТипам(ТипыДляПоиска) Экспорт

	Результат = Новый Соответствие;
	Для каждого ТекущийТип Из ТипыДляПоиска Цикл
		Результат.Вставить(ТекущийТип, Новый Массив);
	КонецЦикла;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыСубконтоКорпоративные.Ссылка КАК Ссылка,
	|	ВидыСубконтоКорпоративные.ТипЗначения КАК ТипЗначения
	|ИЗ
	|	ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконтоКорпоративные");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл		
		Для каждого ТекущийТип Из ТипыДляПоиска Цикл			
			
			Если Не Выборка.ТипЗначения.СодержитТип(ТекущийТип) Тогда
				Продолжить;
			КонецЕсли;
			
			СубконтоПоТипу = Результат.Получить(ТекущийТип);
			СубконтоПоТипу.Добавить(Выборка.Ссылка);
			Результат.Вставить(ТекущийТип, СубконтоПоТипу);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли