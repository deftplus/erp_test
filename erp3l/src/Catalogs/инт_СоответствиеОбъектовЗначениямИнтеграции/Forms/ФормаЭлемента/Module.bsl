
&НаСервере
Процедура ПриОткрытииНаСервере()
	Если не ЗначениеЗаполнено(Объект.ДатаИзменения) тогда
		Объект.ДатаИзменения = ТекущаяДата();
	КонецЕсли;
	
	Если не ЗначениеЗаполнено(Объект.АвторИзменения) тогда
		Объект.АвторИзменения = ПараметрыСеанса.текущийПОльзователь;
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииНаСервере();
	
	Если ЗначениеЗаполнено(Объект.ИмяОбъектаМетаданных) тогда
		Если стрНайти(Объект.ИмяОбъектаМетаданных,"Документ")>0 тогда
			Элементы.ГруппаСтраницаУсловияПроведения.Видимость = истина;
		иначе
			Элементы.ГруппаСтраницаУсловияПроведения.Видимость = ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если не ЗначениеЗаполнено(Объект.ИмяОбъектаМетаданных) тогда
		Элементы.ГруппаСтраницаУсловияПроведения.Видимость = ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыПроцедураПоискаСоответствияОткрытие(Элемент, СтандартнаяОбработка) 
	
	СтандартнаяОбработка = ложь;
	ид = Элементы.Реквизиты.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,1);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",1));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры




&НаСервере 
Функция ПолучитьРедактируемоеЗначение(ид,гдеискать)
	РедактируемоеЗначение = "";
	Если ГдеИскать = 1 тогда	
		РедактируемаяСтрока = Объект.Реквизиты.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.ПроцедураПоискаСоответствия;
	иначеЕсли Гдеискать = 2 тогда
		РедактируемаяСтрока = Объект.Реквизиты.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.ПроцедураЗаполнения;
	иначеЕсли ГдеИскать = 3 тогда
		РедактируемаяСтрока = Объект.ПостОбработка.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.ПроцедураЗаполнения;
	иначеЕсли ГдеИскать = 4 тогда
		РедактируемаяСтрока = Объект.ПостОбработка.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.УсловиеПримененияПроцедурыЗаполнения;
	иначеЕсли ГдеИскать = 5 тогда
		РедактируемаяСтрока = Объект.Реквизиты.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.УсловиеОтказаПерезаполнения;
	иначеЕсли ГдеИскать = 6 тогда
		РедактируемаяСтрока = Объект.УсловияОтказаПерезаписи.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.УсловиеОтказаПерезаписи;
	иначеЕсли ГдеИскать = 7 тогда
		РедактируемаяСтрока = Объект.УсловияПерепроведения.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.УсловиеПерепроведения;
	иначеЕсли ГдеИскать = 8 тогда
		РедактируемаяСтрока = Объект.УсловияПереопределенияПравилаОбработки.НайтиПоИдентификатору(ид);
		РедактируемоеЗначение = РедактируемаяСтрока.УсловиеПереопределения;
		
		
	КонецЕсли;
	возврат(РедактируемоеЗначение);
КонецФункции



&НаКлиенте
Процедура РеквизитыПроцедураЗаполненияОткрытие(Элемент, СтандартнаяОбработка)  
	СтандартнаяОбработка = ложь;
	ид = Элементы.Реквизиты.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,2);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",2));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	
КонецПроцедуры   


&наКлиенте
Процедура ПослеРедактированияТекстаПроцедур(РезультатЗакрытия, ДополнительныеПараметры) экспорт
	
	Если Результатзакрытия = Истина Тогда
		ОтредактированноеЗначение = ДополнительныеПараметры.Результатзакрытия;
		КудаВозвращатьЗначение = ДополнительныеПараметры.КудаВозвращатьЗначение;
		Если КудаВозвращатьЗначение = 1 или КудаВозвращатьЗначение = 2 или КудаВозвращатьЗначение = 5 тогда 
			ИДСтроки = Элементы.реквизиты.ТекущаяСтрока;
		ИначеЕсли КудаВозвращатьЗначение = 3 или КудаВозвращатьЗначение = 4 тогда 
			ИДСтроки = Элементы.ПостОбработка.ТекущаяСтрока;
		ИначеЕсли КудаВозвращатьЗначение = 6 тогда 
			ИДСтроки = Элементы.УсловияОтказаПерезаписи.ТекущаяСтрока;
		ИначеЕсли КудаВозвращатьЗначение = 7 тогда 
			ИДСтроки = Элементы.УсловияПерепроведения.ТекущаяСтрока;
		ИначеЕсли КудаВозвращатьЗначение = 8 тогда 
			ИДСтроки = Элементы.УсловияПереопределенияПравилаОбработки.ТекущаяСтрока;
		иначе
			возврат;
		КонецЕсли;
		ПоместитьОтредактированноеЗначение(ОтредактированноеЗначение,КудаВозвращатьЗначение,ИдСТроки);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере 
Процедура ПоместитьОтредактированноеЗначение(ОтредактированноеЗначение,КудаВозвращатьЗначение,ИдСТроки)
	Если КудаВозвращатьЗначение = 3 тогда
		стр = Объект.ПостОбработка.НайтиПоИдентификатору(ИдСтроки);
		стр.ПроцедураЗаполнения = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 1 тогда
		стр = Объект.Реквизиты.НайтиПоИдентификатору(ИДСтроки);
		стр.ПроцедураПоискаСоответствия = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 2 тогда
		стр = Объект.Реквизиты.НайтиПоИдентификатору(ИДСтроки);
		стр.ПроцедураЗаполнения = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 4 тогда
		стр = Объект.ПостОбработка.НайтиПоИдентификатору(ИдСтроки);
		стр.УсловиеПримененияПроцедурыЗаполнения = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 5 тогда
		стр = Объект.Реквизиты.НайтиПоИдентификатору(ИдСтроки);
		стр.УсловиеОтказаПерезаполнения = ОтредактированноеЗначение;
	КонецЕсли;
	
	
	Если КудаВозвращатьЗначение = 6 тогда
		стр = Объект.УсловияОтказаПерезаписи.НайтиПоИдентификатору(ИдСтроки);
		стр.УсловиеОтказаПерезаписи = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 7 тогда
		стр = Объект.УсловияПерепроведения.НайтиПоИдентификатору(ИдСтроки);
		стр.УсловиеПерепроведения = ОтредактированноеЗначение;
	КонецЕсли;
	
	Если КудаВозвращатьЗначение = 8 тогда
		стр = Объект.УсловияПереопределенияПравилаОбработки.НайтиПоИдентификатору(ИдСтроки);
		стр.УсловиеПереопределения = ОтредактированноеЗначение;
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура ПостОбработкаПроцедураЗаполненияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	СтандартнаяОбработка = ложь;
	ид = Элементы.ПостОбработка.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,3);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",3));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПостОбработкаУсловиеПримененияПроцедурыЗаполненияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ид = Элементы.ПостОбработка.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,4);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",4));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура РеквизитыУсловиеОтказаПерезаполненияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ид = Элементы.Реквизиты.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,5);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",5));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
КонецПроцедуры

&НаКлиенте
Процедура УсловияОтказаПерезаписиУсловиеОтказаПерезаписиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ид = Элементы.УсловияОтказаПерезаписи.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,6);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",6));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПерепроведенияУсловиеПерепроведенияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ид = Элементы.УсловияПерепроведения.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,7);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",7));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПереопределенияПравилаОбработкиУсловиеПереопределенияОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	ид = Элементы.УсловияПереопределенияПравилаОбработки.ТекущаяСтрока;
	редактируемоеЗначение = ПолучитьРедактируемоеЗначение(ид,8);
	
	ОписаниеПостОбработкиОткрытияФормы = Новый ОписаниеОповещения("ПослеРедактированияТекстаПроцедур",ЭтаФорма,Новый Структура("РезультатЗакрытия,КудаВозвращатьЗначение","",8));
	
	Ф = ОткрытьФорму("ОбщаяФорма.инт_РедактированиеТекстаПроцедур",Новый Структура("Ключ",редактируемоеЗначение),
	ЭтаФОрма,,,,ОписаниеПостОбработкиОткрытияФормы,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюИзменитьВерсию()
	
	Объект.ДатаИзменения   =  ТекущаяДата();
	Объект.АвторИзменения  =  ПараметрыСеанса.ТекущийПользователь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Модифицированность Тогда
		ПередЗаписьюИзменитьВерсию();
	КонецЕсли;
	
КонецПроцедуры
