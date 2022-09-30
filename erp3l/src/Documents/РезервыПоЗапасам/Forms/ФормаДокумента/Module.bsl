
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда		
		
		ПодготовитьФормуНаСервере(ЭтаФорма);
		УправлениеФормой(ЭтаФорма);
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
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
	УправлениеФормой(ЭтаФорма);
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

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьПодробно(Команда)	
	
	Элементы.ПоказатьПодробно.Пометка = НЕ Элементы.ПоказатьПодробно.Пометка;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИРассчитать(Команда)
	ЗаполнитьРассчитатьСервер();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОбновитьКэшируемыеЗначенияОрганизации(ЭтаФорма);
			
КонецПроцедуры

&НаКлиенте
Процедура РезервыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.Резервы.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ОбновитьВидимостьСубконтоГруппыПодробно(ЭтаФорма, ТекущаяСтрока, "Резервы");
		
КонецПроцедуры

&НаКлиенте
Процедура РезервыСчетУчетаЗапасовНСБУПриИзменении(Элемент)
	
	Если Элементы.Резервы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элементы.РезервыСчетЗапасовНСБУ, "Резервы");
	ОбновитьСчетРезерваМСФО(ЭтаФорма, Элементы.Резервы.ТекущиеДанные, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РезервыСчетУчетаПриИзменении(Элемент)
	
	Если Элементы.Резервы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элементы.РезервыСчетЗапасов, "Резервы");

	ОбновитьСчетРезерваМСФО(ЭтаФорма, Элементы.Резервы.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыРасчетаСчетРасходаПриИзменении(Элемент)
	
	Если Элементы.Резервы.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элементы.ПараметрыРасчетаСчетРасхода, "Резервы");	

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеОбработчикиСобытийФормы

&НаСервереБезКонтекста
Процедура ПодготовитьФормуНаСервере(Форма)

	Форма.КэшируемыеЗначения = Новый Структура;
	
	Форма.КэшируемыеЗначения.Вставить("ИменаСубконто",			Документы.РезервыПоЗапасам.ПолучитьИменаСубконто());
	Форма.КэшируемыеЗначения.Вставить("РазделыСчетов",			Документы.РезервыПоЗапасам.ПолучитьРазделыСчетов());
	Форма.КэшируемыеЗначения.Вставить("КлючевыеСубконто",		ВстраиваниеУХКлиентСервер.ПолучитьКлючевыеСубконтоМПЗ());
	Форма.КэшируемыеЗначения.Вставить("МоделиУчетаМСФО",		МСФОВызовСервераУХ.ПолучитьСтруктуруСоЗначениямиПеречисления("МоделиУчетаМСФО"));
	Форма.КэшируемыеЗначения.Вставить("СчетаГруппыПодробно",    МСФОУХ.ПолучитьСчетаГруппыПодобно(Форма, "Резервы", Истина));
	
	ОбновитьКэшируемыеЗначенияОрганизации(Форма);
	
	ПланСчетовМСФО = Форма.КэшируемыеЗначения.ПланСчетовМСФО;
	
	Для каждого ИмяТЧ Из Форма.КэшируемыеЗначения.РазделыСчетов Цикл	
		Для каждого ИмяСчета Из ИмяТЧ.Значение Цикл			
			МСФОКлиентСерверУХ.УстановитьПараметрыВыбораСчета(Форма.Элементы[ИмяТЧ.Ключ + ИмяСчета.Ключ], ПланСчетовМСФО, ИмяСчета.Значение);
		КонецЦикла;	
	КонецЦикла;
	
	Форма.Элементы.ГруппаПодробно.Видимость = Ложь;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	Форма.Элементы.ГруппаПодробно.Видимость = Форма.Элементы.ПоказатьПодробно.Пометка;	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьКэшируемыеЗначенияОрганизации(Форма)
	
	МСФОКлиентСерверУХ.ОбновитьРеквизитыУП(Форма);
    
	МСФОКлиентСерверУХ.УстановитьПараметрыВыбораСчета(Форма.Элементы.РезервыСчетЗапасовНСБУ, Форма.КэшируемыеЗначения.ПланСчетовНСБУ);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРассчитатьСервер()

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ЗаполнитьПоНСБУ", Истина);
	ПараметрыЗаполнения.Вставить("ШаблонТрансляции", КэшируемыеЗначения.ШаблонТрансляции);
	
	ДокументОбъект = ЭтаФорма.РеквизитФормыВЗначение("Объект");
	ДокументОбъект.Заполнить(ПараметрыЗаполнения);
	ЭтаФорма.ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользованныеРезервыВидДвиженияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИспользованныеРезервы.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьСчетаПоВидуДвижений", Новый Структура("Контекст", Объект));
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_РезервыМПЗ(ТекущаяСтрока, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСчетРасходаПоРезерву(Знач Номенклатура)
	Возврат Номенклатура.ПараметрыРасчетаРезерваМСФО.СчетРасхода;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСчетРезерваМСФО(Форма, ТекущаяСтрока, ЗаполнитьСчетУчетаМСФО = Ложь)

	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("ЗаполнитьСчетРезерваМСФО");
	Если ЗаполнитьСчетУчетаМСФО Тогда
		СтруктураДействий.Вставить("ЗаполнитьСчетУчетаМСФО", Форма.КэшируемыеЗначения.ШаблонТрансляции);
	КонецЕсли;
		
	КэшируемыеЗначения = Неопределено;
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_РезервыМПЗ(ТекущаяСтрока, СтруктураДействий, КэшируемыеЗначения);
	
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(Форма, Форма.Элементы.РезервыСчетРезерва, "Резервы");
	
КонецПроцедуры

&НаКлиенте
Процедура РезервыСчетРезерваПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элементы.РезервыСчетРезерва, "Резервы");		
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресТаблицыЗагрузки() Экспорт

	//ТаблицаЗагрузки = Документы.РезервыПоЗапасам.ПолучитьТаблицуЗагрузки(Объект);
	//Возврат ПоместитьВоВременноеХранилище(ТаблицаЗагрузки, УникальныйИдентификатор);
	//
КонецФункции

&НаСервере
Функция ЗагрузитьПоАдресу(АдресТаблицы) Экспорт

	ТаблицаИсточник = ПолучитьИзВременногоХранилища(АдресТаблицы);	
	//Документы.РезервыПоЗапасам.ЗагрузитьТаблицу(Объект, ТаблицаИсточник);

	//Для каждого ТекСтрока Из Объект.Резервы Цикл
	//	
	//	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элементы.РезервыСчетЗапасовНСБУ, "Резервы");
	//	ОбновитьСчетРезерваМСФО(ЭтаФорма, ТекСтрока, Истина);
	//
	//КонецЦикла;
	
	ЭтаФорма.Модифицированность = Истина;	
	
КонецФункции

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

#Область ЗаполнениеДокумента

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
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти




