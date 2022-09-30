
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();		
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Ложь, "ВНА");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "ОбщаяФорма.ДокументыОснованияПараллельногоУчета"
	 И ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		
		Объект.ДокументыОснования.Очистить();
		Для Каждого СтрокаСписка Из ВыбранноеЗначение Цикл
			Если СтрокаСписка.Значение.Пустая() Тогда
				Продолжить;
			КонецЕсли; 
			СтрокаТаблицы = Объект.ДокументыОснования.Добавить();
			СтрокаТаблицы.ДокументОснование = СтрокаСписка.Значение;
		КонецЦикла;
		
		МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма, "ВНА", Ложь);
		
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
	
	ПодготовитьФормуНаСервере();
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
	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументМСФО(Команда)
	МСФОКлиентУХ.СоздатьДокументМСФО(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьСтрокиРасхождений(Команда)
	
	Если (Элементы.ВНА.ОтборСтрок = Неопределено) ИЛИ НЕ Элементы.ВНА.ОтборСтрок.Свойство("ЕстьРасхождения") Тогда
		
		Элементы.ВНА.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьРасхождения", Истина);
		Элементы.ВНАОтобратьСтрокиРасхождений.Пометка = Истина;
		Элементы.ВНАОтобратьСтрокиИзменений.Пометка = Ложь;
		
	Иначе
		
		Элементы.ВНА.ОтборСтрок = Неопределено;
		Элементы.ВНАОтобратьСтрокиРасхождений.Пометка = Ложь;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьСтрокиИзменений(Команда)
	
	Если Элементы.ВНА.ОтборСтрок = Неопределено Тогда
		
		Элементы.ВНА.ОтборСтрок = Новый ФиксированнаяСтруктура("ЕстьИзменение", Истина);
		Элементы.ВНАОтобратьСтрокиИзменений.Пометка = Истина;
		
	Иначе
		
		Элементы.ВНА.ОтборСтрок = Неопределено;
		Элементы.ВНАОтобратьСтрокиИзменений.Пометка = Ложь;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодробноВНА(Команда)	
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Истина, "ВНА");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Заполнение

&НаКлиенте
Процедура ЗаполнитьПоОснованиям(Команда)
	
	ДанныеЗаполнения = Новый Структура("ИсточникЗаполнения", "ДокументыОснования");
	МСФОКлиентУХ.ЗаполнитьДокумент(ЭтаФорма, ДанныеЗаполнения, "ВНА");

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИзУчетнойСистемы(Команда)
		
	Если Не МСФОВНАВызовСервераУХ.ИспользоватьДанныеУчетнойСистемы(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура("ИсточникЗаполнения", "ДанныеНСБУ");
	МСФОКлиентУХ.ЗаполнитьДокумент(ЭтаФорма, ДанныеЗаполнения, "ВНА");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТекущимиДаннымиМСФО(Команда)
	ЗаполнитьТекущимиДаннымиСервер(Истина, Истина, Истина, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоКолонкамНСБУ(Команда)
	ЗаполнитьПоКолонкамНСБУСервер();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеВКолонкеПоВыделенным(Команда)	
	МСФОКлиентУХ.УстановитьЗначениеВКолонкеПоВыделеннымСтрокам(ЭтаФорма, "ВНА");
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)	
	УправлениеФормой(ЭтаФорма);	
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВидЗаполненияПриИзменении(Элемент)
	
	МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма, "ВНА", Ложь);	
	Объект.ВНА.Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДокументОснованиеНеУказанГиперссылкаНажатие(Элемент)
	
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ВНА"); 
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьДобавитьДокументОснованиеНажатие(Элемент)
	
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ВНА"); 
		
КонецПроцедуры

&НаКлиенте
Процедура ТекстДокументыОснованияНажатие(Элемент, СтандартнаяОбработка)
	МСФОКлиентУХ.ОткрытьСписокДокументовОснований(ЭтаФорма, "ВНА", СтандартнаяОбработка); 
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	МСФОКлиентУХ.ОткрытьФормуРедактированияМногострочногоТекста(ЭтаФорма, Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ВНАПослеУдаления(Элемент)
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Ложь, "ВНА");
КонецПроцедуры

&НаКлиенте
Процедура ВНАПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Ложь, "ВНА");
	ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	МСФОКлиентУХ.ТабличнаяЧастьПриОкончанииРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ВНАВНАПриИзменении(Элемент)
	ЗаполнитьТекущимиДаннымиСервер(Истина, Истина, Истина, Истина);
	ОбновитьОтборНовыхПараметровУчетаВНА();
КонецПроцедуры

&НаКлиенте
Процедура ВНАГруппаВНАМСФОПриИзменении(Элемент)
	ОбновитьОтборНовыхПараметровУчетаВНА();	
КонецПроцедуры

&НаКлиенте
Процедура ВНАНоваяГруппаВНАМСФОПриИзменении(Элемент)
	КолонкаИсточник = Прав(Элемент.Имя, СтрДлина(Элемент.Имя)-3); //убираем префикс ТЧ
	МСФОКлиентСерверУХ.ОбновитьЗависимыеРеквизиты(Элементы.ВНА.ТекущиеДанные, ЭтаФорма, КолонкаИсточник);
КонецПроцедуры

&НаКлиенте
Процедура ВНАНовыеПараметрыАмортизацииВНАМСФОПриИзменении(Элемент)
	КолонкаИсточник = Прав(Элемент.Имя, СтрДлина(Элемент.Имя)-3); //убираем префикс ТЧ
	МСФОКлиентСерверУХ.ОбновитьЗависимыеРеквизиты(Элементы.ВНА.ТекущиеДанные, ЭтаФорма, КолонкаИсточник);
КонецПроцедуры

&НаКлиенте
Процедура ВНАМетодНачисленияАмортизацииНСБУПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАМетодНачисленияАмортизацииМСФОПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАПередНачаломИзменения(Элемент, Отказ)
	ОбновитьОтборНовыхПараметровУчетаВНА();	
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

#Область СтандартныеОбработчики

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЭтаФорма.КэшируемыеЗначения = Новый Структура;
	ЭтаФорма.КэшируемыеЗначения.Вставить("СпособыНачисленияАмортизации", 	МСФОВНАВызовСервераУХ.ПолучитьВозможныеСпособыНачисленияАмортизации());
		
	МСФОУХ.ПодготовитьФормуНаСервере(ЭтаФорма);
	МСФОУХ.ОбновитьУсловноеОформлениеФормы(ЭтаФорма);
	МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма,, Ложь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	МСФОКлиентСерверУХ.УправлениеФормой(Форма, "ВНА", Ложь);
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеРеквизитовСтрокиТЧ

&НаСервере
Процедура ЗаполнитьПоКолонкамНСБУСервер()
	МСФОУХ.ЗаполнитьПоКолонкамНСБУСервер(ЭтаФорма);
КонецПроцедуры    

#КонецОбласти

#Область ЗаполнениеТЧ

&НаКлиенте
Процедура Подключаемый_ЗаполнитьДокумент(РезультатВопроса = Неопределено, ДанныеЗаполнения) Экспорт
	
	Если (РезультатВопроса <> Неопределено) И (РезультатВопроса <> КодВозвратаДиалога.Да) Тогда
		Возврат;	
	КонецЕсли;
    
    ЗаполнитьДокумент(ДанныеЗаполнения);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокумент(ДанныеЗаполнения)

	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(ДанныеЗаполнения);
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	МСФОУХ.ЗаполнитьПоКолонкамНСБУСервер(ЭтаФорма);
	МСФОКлиентСерверУХ.ОбновитьВидимостьДокументыОснования(ЭтаФорма);
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТекущимиДаннымиСервер(ЗаполнитьРеквизиты = Ложь, ЗаполнитьНСБУ = Ложь, ЗаполнитьМСФО = Ложь, СтрокаВНА = Ложь) 
	
	Если НЕ СтрокаВНА Тогда		
		СтрокиДляЗаполнения = Объект.ВНА;
	Иначе
		СтрокиДляЗаполнения = Новый Массив;
		СтрокиДляЗаполнения.Добавить(Объект.ВНА.НайтиПоИдентификатору(Элементы.ВНА.ТекущаяСтрока));	
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура("ЗаполнитьРеквизиты,ЗаполнитьНСБУ,ЗаполнитьМСФО", ЗаполнитьРеквизиты, ЗаполнитьНСБУ, ЗаполнитьМСФО);
	Документы.ИзменениеПараметровВНАМСФО.ЗаполнитьСтроки(СтрокиДляЗаполнения, ЭтаФорма, ПараметрыЗаполнения);
	
КонецПроцедуры

#КонецОбласти

#Область ДополнительноВНА

&НаКлиенте
Функция ПолучитьРеквизитыПараметровАмортизации(РеквизитыМСФО = Истина)

	Результат = Новый Структура;
	
	Если РеквизитыМСФО = Истина Тогда
		
		Результат.Вставить("КоэффициентУскорения", 			"ВНАКоэффициентУскоренияМСФО");
		Результат.Вставить("ПараметрВыработки", 			"ВНАПараметрВыработкиМСФО");
		Результат.Вставить("ПредполагаемыйОбъемПродукции", 	"ВНАПредполагаемыйОбъемПродукцииМСФО");
		Результат.Вставить("ПрофильРаспределения", 			"ВНАСпособОтраженияРасходовПоАмортизацииМСФО");
				
	Иначе
		
		Результат.Вставить("КоэффициентУскорения", 			"ВНАКоэффициентУскоренияНСБУ");
		Результат.Вставить("ПараметрВыработки", 			"ВНАПараметрВыработкиНСБУ");
		Результат.Вставить("ПредполагаемыйОбъемПродукции", 	"ВНАПредполагаемыйОбъемПродукцииНСБУ");
		Результат.Вставить("ПрофильРаспределения", 			"ВНАСпособОтраженияРасходовПоАмортизацииНСБУ");
				
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока)
	
	МСФОКлиентСерверУХ.ОбновитьДоступностьЗависимыхРеквизитов(ЭтаФорма, ТекущаяСтрока, "ВНА");
	
	МСФОКлиентСерверУХ.ОбновитьОтображениеПараметровАмортизации(
			ЭтаФорма, 
			ТекущаяСтрока.СпособНачисленияАмортизацииНСБУ, 
			ПолучитьРеквизитыПараметровАмортизации(Ложь),
			КэшируемыеЗначения.СпособыНачисленияАмортизации);
			
	МСФОКлиентСерверУХ.ОбновитьОтображениеПараметровАмортизации(
			ЭтаФорма, 
			ТекущаяСтрока.СпособНачисленияАмортизацииМСФО, 
			ПолучитьРеквизитыПараметровАмортизации(Истина),
			КэшируемыеЗначения.СпособыНачисленияАмортизации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОтборНовыхПараметровУчетаВНА()

	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Элементы.ВНАНоваяГруппаВНАМСФО.ПараметрыВыбора = ПолучитьПараметрыВыбораНовойГруппыВНА(ТекущаяСтрока.ВНА);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПараметрыВыбораНовойГруппыВНА(ОбъектВНА)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГруппыВНАМСФО.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.СчетаБД.ВидыСубконто КАК СчетаБДВидыСубконто
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыВНАМСФО КАК ГруппыВНАМСФО
	|		ПО СчетаБДВидыСубконто.Ссылка = ГруппыВНАМСФО.СчетУчетаПервоначальнойСтоимости
	|ГДЕ
	|	(СчетаБДВидыСубконто.ТипДанных ПОДОБНО &ТипДанных
	|			ИЛИ СчетаБДВидыСубконто.ТипДанных ПОДОБНО ""%СправочникСсылка.ГруппыВНАМСФО%"")");
	
	Если ОбъектВНА = Неопределено Тогда
		Возврат Новый ФиксированныйМассив(Новый Массив);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТипДанных", "%" + Метаданные.НайтиПоТипу(ТипЗнч(ОбъектВНА)).ПолноеИмя() + "%");
	
	ИсточникПараметров = Новый Соответствие;
	ИсточникПараметров.Вставить("Отбор.Ссылка", Новый ФиксированныйМассив(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка")));
	Возврат МСФОКлиентСерверУХ.ПолучитьПараметрыВыбора(ИсточникПараметров);
	
КонецФункции

#КонецОбласти

#КонецОбласти
