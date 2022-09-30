
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем ТаблицаРедактируемыхДанных;
	
	Объект.ВидОтчета=Параметры.ВидОтчета;
    ТипЭлемента=Параметры.ТипЭлемента;
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	
	СтруктураНачальногоЗаполнения = ТекОбъект.ОпределитьСтруктуруИзменяемыхДанных(Параметры.ТипЭлемента, Параметры.МассивОбъектов, ТаблицаРедактируемыхДанных);
	АдресТаблицыРедактируемыхДанных = ПоместитьВоВременноеХранилище(ТаблицаРедактируемыхДанных, УникальныйИдентификатор);
	
	// Установим значения, общие для всего массива показателей.
	Для Каждого Элемент Из СтруктураНачальногоЗаполнения Цикл
		
		ЭтаФорма[Элемент.Ключ] = Элемент.Значение;
		
	КонецЦикла;
	
	ИзменениеСтрок=Параметры.ТипЭлемента="Строка";
	
	Заголовок = СтрШаблон(НСтр("ru = 'Групповое изменение %1'"), ?(ИзменениеСтрок, НСтр("ru = 'строк'"), НСтр("ru = 'показателей'")));
	
	Элементы.ИзменениеГруппирующейСтроки.Видимость=ИзменениеСтрок;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ИзменитьЭлементы();
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьЭлементы()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ЗаписатьИзмененныеДанные(ЭтаФорма, ПолучитьИзВременногоХранилища(АдресТаблицыРедактируемыхДанных), ТипЭлемента)
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьПараметрыКонвертации()
	
	Элементы.КонвертацияВалюты.Видимость = НЕ НеФинансовый;
	
	Если ВидКурса=Перечисления.ВидыКурсов.КурсНаМоментНачисления Тогда
		Элементы.ПанельСвязанныеПоказатели.ТекущаяСтраница=Элементы.ДатаКурса;
	ИначеЕсли ВидКурса=Перечисления.ВидыКурсов.ЗначениеУказанноеВДокументе Тогда
		Элементы.ПанельСвязанныеПоказатели.ТекущаяСтраница=Элементы.ПоказателиКурса;
	Иначе
		Элементы.ПанельСвязанныеПоказатели.ТекущаяСтраница=Элементы.ПрочиеКурсы;
	КонецЕсли;
		
КонецПроцедуры // ОтобразитьПараметрыКонвертации() 

&НаКлиенте
Процедура ВидКурсаПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	ОтобразитьПараметрыКонвертации();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппирующаяСтрокаПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьСостояниеИзменения(Элемент)
	
	ЭтаФорма[Элемент.Имя+"Изменить"]=Истина;	
		
КонецПроцедуры // ИзменитьСостояниеИзменения() 

&НаКлиенте
Процедура ВидПоказателяПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОбработкиПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипЗначенияПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаРаскрытияПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидИтогаПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НеМасштабируетсяПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура НеФинансовыйПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
	Если НеФинансовый Тогда
		
		ВидКурсаИзменить=Ложь;
		СвязанныйПоказательИзменить=Ложь;
		ПоказателиДляКурсовВалютИзменить=Ложь;
		
	КонецЕсли;
	
	ОтобразитьПараметрыКонвертации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОборотныйПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнутригрупповойПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СвязанныйПоказательПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиДляКурсовВалютПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриАктуализацииПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОценкаПоложительногоОтклоненияПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриходРасходПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДвиженияДенежныхСредствПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютныйПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитыватьВалютнуюСуммуПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредназначениеПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РазделениеПоПроектамПриИзменении(Элемент)
	
	ИзменитьСостояниеИзменения(Элемент);
	
КонецПроцедуры