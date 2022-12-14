
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда				
		ПодготовитьФормуНаСервере();		
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	МСФОУХ.ОбновитьУсловноеОформлениеФормы(ЭтаФорма);
	МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма);
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
		
		МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма);
		
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
	
	ПодготовитьФормуНаСервере(ТекущийОбъект);
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
	
	ПодготовитьФормуНаСервере(ТекущийОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументМСФО(Команда)
	МСФОКлиентУХ.СоздатьДокументМСФО(ЭтаФорма);
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
Процедура ЗаполнитьТекущимиДаннымиНСБУ(Команда)
	ЗаполнитьТекущимиДаннымиСервер(Истина, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТекущимиДаннымиМСФО(Команда)
	ЗаполнитьТекущимиДаннымиСервер(Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоКолонкамНСБУ(Команда)
	ЗаполнитьПоКолонкамНСБУСервер();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначениеВКолонкеПоВыделенным(Команда)
	МСФОКлиентУХ.УстановитьЗначениеВКолонкеПоВыделеннымСтрокам(ЭтаФорма, "ВНА");	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьАмортизациюЗаПредыдущиеПериодыМСФО(Команда)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.ПериодОтчета = МСФОВНАВызовСервераУХ.ПолучитьПериодПоДатеПараллельногоУчета(Объект.Дата, Неопределено);
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере();
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтчетаПриИзменении(Элемент)
	Объект.Дата = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Объект.ПериодОтчета, "ДатаОкончания");
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура СценарийПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЗаполненияПриИзменении(Элемент)
	
	МСФОКлиентСерверУХ.УправлениеФормой(ЭтаФорма);	
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

#Область ОбработчикиКомандТабличнойЧасти

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

#Область ОбработчикиСобытийЭлементовТаблицФормы

&НаКлиенте
Процедура ВНАПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	МСФОКлиентСерверУХ.ОбновитьВидимостьСубконтоГруппыПодробно(ЭтаФорма, ТекущаяСтрока, "ВНА");
	МСФОКлиентСерверУХ.ОбновитьДоступностьЗависимыхРеквизитов(ЭтаФорма, ТекущаяСтрока, "ВНА");
	
	ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока);
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Ложь, "ВНА");
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАПередНачаломИзменения(Элемент, Отказ)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	ИменаСубконто = Этаформа.КэшируемыеЗначения.ИменаСубконто;
	
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчетаТЧ(Этаформа, ТекущаяСтрока, "СчетУчетаМСФО", "ВНА", ИменаСубконто);
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчетаТЧ(Этаформа, ТекущаяСтрока, "СчетАмортизацииМСФО", "ВНА", ИменаСубконто);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)	
	МСФОКлиентУХ.ТабличнаяЧастьПриОкончанииРедактирования(ЭтаФорма, Элемент, НоваяСтрока, ОтменаРедактирования);
КонецПроцедуры

&НаКлиенте
Процедура ВНАГруппаВНАПриИзменении(Элемент)
	КолонкаИсточник = Прав(Элемент.Имя, СтрДлина(Элемент.Имя)-3); //убираем префикс ТЧ
	МСФОКлиентСерверУХ.ОбновитьЗависимыеРеквизиты(Элементы.ВНА.ТекущиеДанные, ЭтаФорма, КолонкаИсточник);	
КонецПроцедуры

&НаКлиенте
Процедура ВНАПараметрыАмортизацииВНАМСФОПриИзменении(Элемент)
	КолонкаИсточник = Прав(Элемент.Имя, СтрДлина(Элемент.Имя)-3); //убираем префикс ТЧ
	МСФОКлиентСерверУХ.ОбновитьЗависимыеРеквизиты(Элементы.ВНА.ТекущиеДанные, ЭтаФорма, КолонкаИсточник);	
КонецПроцедуры

&НаКлиенте
Процедура ВНАСпособНачисленияАмортизацииНСБУПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ОбновитьВидимостьПараметровАмортизации(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАДатаПринятияКУчетуМСФОПриИзменении(Элемент)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(Элементы.ВНА.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВНАПервоначальнаяСтоимостьМСФОПриИзменении(Элемент)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(Элементы.ВНА.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВНАЛиквидационнаяСтоимостьМСФОПриИзменении(Элемент)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(Элементы.ВНА.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВНАСпособНачисленияАмортизацииМСФОПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущаяСтрока;	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(ТекущаяСтрока);
	ОбновитьВидимостьПараметровАмортизации(Элементы.ВНА.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАСрокПолезногоИспользованияНСБУПриИзменении(Элемент)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(Элементы.ВНА.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВНАСрокПолезногоИспользованияМСФОПриИзменении(Элемент)
	РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(Элементы.ВНА.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВНАВНАПриИзменении(Элемент)
	ЗаполнитьТекущимиДаннымиСервер(Истина, Истина, Истина, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВНАПослеУдаления(Элемент)
	МСФОКлиентСерверУХ.ВидимостьПодробно(ЭтаФорма, Ложь, "ВНА");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСчетовТаблицФормы

&НаКлиенте
Процедура ВНАСчетАмортизацииНСБУПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");
КонецПроцедуры

&НаКлиенте
Процедура ВНАСчетУчетаНСБУПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ВНА.ТекущиеДанные;
	ИменаСубконто = Этаформа.КэшируемыеЗначения.ИменаСубконто;
		
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчетаТЧ(Этаформа, ТекущаяСтрока, "СчетУчетаНСБУ", "ВНА", ИменаСубконто);
	
КонецПроцедуры

&НаКлиенте
Процедура ВНАСчетАмортизацииМСФОПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");	
КонецПроцедуры

&НаКлиенте
Процедура ВНАСчетУчетаМСФОПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");	
КонецПроцедуры

&НаКлиенте
Процедура ВНАКоррСчетМодернизацияМСФОПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");	
КонецПроцедуры

&НаКлиенте
Процедура ВНАКоррСчетПереоценкаМСФОПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");	
КонецПроцедуры

&НаКлиенте
Процедура ВНАКоррСчетПереоценкаАмортизацииМСФОПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "ВНА");
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

&НаСервере
Процедура ПодготовитьФормуНаСервере(ТекущийОбъект = Неопределено)
	
	ЭтаФорма.КэшируемыеЗначения = Новый Структура;	
	ЭтаФорма.КэшируемыеЗначения.Вставить("СпособыНачисленияАмортизации", 	МСФОВНАВызовСервераУХ.ПолучитьВозможныеСпособыНачисленияАмортизации());
	ЭтаФорма.КэшируемыеЗначения.Вставить("ИменаСубконто", 					Документы.ВводНачальныхОстатковВНАМСФО.ПолучитьИменаСубконто());
	
	МСФОУХ.ПодготовитьФормуНаСервере(ЭтаФорма);
	
	СчетаГруппыПодробно = МСФОУХ.ПолучитьСчетаГруппыПодобно(ЭтаФорма, "ВНА");
	ЭтаФорма.КэшируемыеЗначения.Вставить("СчетаГруппыПодробно", СчетаГруппыПодробно);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	МСФОКлиентСерверУХ.УправлениеФормой(Форма,, Ложь);
	
КонецПроцедуры

#Область ЗаполнениеРеквизитовСтрокиТЧ

&НаСервере
Процедура ЗаполнитьПоКолонкамНСБУСервер()
	МСФОУХ.ЗаполнитьПоКолонкамНСБУСервер(ЭтаФорма);
КонецПроцедуры    

#КонецОбласти

#Область ЗаполнениеТЧ

&НаКлиенте
Процедура ЗаполнитьТекущимиДанными(Команда)
	ЗаполнитьТекущимиДаннымиСервер(Истина, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаполнитьДокумент(РезультатВопроса = Неопределено, ДанныеЗаполнения) Экспорт
	
	Если (РезультатВопроса <> Неопределено) И (РезультатВопроса <> КодВозвратаДиалога.Да) Тогда
		Возврат;	
	КонецЕсли;
    
    ЗаполнитьДокумент(ДанныеЗаполнения);
		
	Для каждого Стр Из Объект.ВНА Цикл
	    МСФОКлиентСерверУХ.ОбновитьЗависимыеРеквизиты(Стр, ЭтаФорма, "ГруппаВНАМСФО");
	КонецЦикла;

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
	Документы[ЭтаФорма.КэшируемыеЗначения.МетаданныеДокумента.Имя].ЗаполнитьСтроки(СтрокиДляЗаполнения, ЭтаФорма, ПараметрыЗаполнения);
	
КонецПроцедуры

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
Функция ПолучитьРеквизитыПараметровАмортизации(РеквизитыМСФО = Истина)

	Результат = Новый Структура;
	
	Если РеквизитыМСФО = Истина Тогда
		
		Результат.Вставить("СрокПолезногоИспользования", 				"ВНАСрокПолезногоИспользованияМСФО");		
		Результат.Вставить("КоэффициентУскорения", 						"ВНАКоэффициентУскоренияМСФО");
		Результат.Вставить("ПараметрВыработки", 						"ВНАПараметрВыработкиМСФО");
		Результат.Вставить("ПредполагаемыйОбъемПродукции", 				"ВНАПредполагаемыйОбъемПродукцииМСФО");
		
	Иначе
		
		Результат.Вставить("СрокПолезногоИспользования", 				"ВНАСрокПолезногоИспользованияНСБУ");		
		Результат.Вставить("КоэффициентУскорения", 						"ВНАКоэффициентУскоренияНСБУ");
		Результат.Вставить("ПараметрВыработки", 						"ВНАПараметрВыработкиНСБУ");
		Результат.Вставить("ПредполагаемыйОбъемПродукции", 				"ВНАПредполагаемыйОбъемПродукцииНСБУ");
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура РассчитатьАмортизациюЗаПредыдущиеПериодыМСФОНаСервере(ИдентификаторСтроки = Неопределено)
	
	КонецРасчетногоПериода = КонецГода(Объект.Дата); // конец предыдущего года
	АлгоритмРСБУ = Константы.АлгоритмНачиcленияАмортизацииАналогичноРСБУ.Получить();
	
	Если ИдентификаторСтроки = Неопределено Тогда
		КоллекцияСтрок = Объект.ВНА;
	Иначе 
		КоллекцияСтрок = Новый Массив;
		КоллекцияСтрок.Добавить(Объект.ВНА.НайтиПоИдентификатору(ИдентификаторСтроки));
	КонецЕсли;
	
	Для каждого СтрокаВНА Из КоллекцияСтрок Цикл
		
		ПараметрыРасчета = Новый Структура;
		ПараметрыРасчета.Вставить("ДатаДокумента", 					Объект.Дата);
		ПараметрыРасчета.Вставить("КонецРасчетногоПериода", 		КонецРасчетногоПериода);
		ПараметрыРасчета.Вставить("ДатаПринятияКУчету", 			СтрокаВНА.ДатаПринятияКУчетуМСФО);
		ПараметрыРасчета.Вставить("ПервоначальнаяСтоимость", 		(СтрокаВНА.ТекущаяСтоимостьНСБУ - СтрокаВНА.ЛиквидационнаяСтоимостьМСФО));
		ПараметрыРасчета.Вставить("СпособНачисленияАмортизации", 	СтрокаВНА.СпособНачисленияАмортизацииМСФО);
		ПараметрыРасчета.Вставить("СрокПолезногоИспользования", 	СтрокаВНА.СрокПолезногоИспользованияМСФО);
		
		СтрокаВНА.НакопленнаяАмортизацияМСФО = МСФОВНАВызовСервераУХ.РасчетАмортизацииРетро(ПараметрыРасчета, АлгоритмРСБУ);

	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
