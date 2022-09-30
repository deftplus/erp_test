
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Перем РазделОтбор;
	
	Если Параметры.Отбор.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда		
		ПланСчетов = Параметры.Отбор.Владелец;				
	ИначеЕсли Параметры.Свойство("Владелец") И ЗначениеЗаполнено(Параметры.Владелец) Тогда		
		ПланСчетов = Параметры.Владелец;							
	КонецЕсли;
	
	Если (Параметры.Свойство("Раздел", РазделОтбор) И ЗначениеЗаполнено(Параметры.Раздел)) 
		ИЛИ (Параметры.Свойство("РазделПланаСчетов", РазделОтбор) И ЗначениеЗаполнено(Параметры.РазделПланаСчетов)) Тогда
		
		ВидСравненияРаздела = Неопределено;
		Если (ТипЗнч(РазделОтбор) = Тип("СписокЗначений"))
			Или (ТипЗнч(РазделОтбор) = Тип("Массив")) 
			Или (ТипЗнч(РазделОтбор) = Тип("ФиксированныйМассив")) Тогда
			
			ВидСравненияРаздела = ВидСравненияКомпоновкиДанных.ВСписке;
			
		КонецЕсли;
		
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Список, "Раздел", РазделОтбор, Истина, ВидСравненияРаздела);
				
	КонецЕсли;
	
	Если Параметры.Свойство("Забалансовый") Тогда	
		ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Список, "Забалансовый", Параметры.Забалансовый, Истина, ВидСравненияКомпоновкиДанных.Равно);	
	КонецЕсли;
	
	УстановитьОтборПоВладельцу();
	
	Элементы.ВыбратьЭлемент.Видимость 	= НЕ Параметры.РежимВыбораИтогов;
	Элементы.ВыбратьВидИтога.Видимость 	= Параметры.РежимВыбораИтогов;
	
	РежимВыбораИтогов = Параметры.РежимВыбораИтогов;
	
	Если Параметры.Свойство("РодительВерхнегоУровня") И ЗначениеЗаполнено(Параметры.РодительВерхнегоУровня) Тогда
		
		ЭтаФорма.Элементы.Список.РодительВерхнегоУровня = Параметры.РодительВерхнегоУровня;
		ЭтаФорма.Элементы.Список.ТекущийРодитель = Параметры.РодительВерхнегоУровня;
		
	КонецЕсли;
	
	Справочники.ВидыВременныхРазниц.ПодставитьВидРазницы(Список.ТекстЗапроса, "СчетаБД.ВидОтложенногоНалога");

	Если Параметры.Свойство("ПланСчетов_ТолькоПросмотр") Тогда
		Элементы.ПланСчетов.ТолькоПросмотр = Параметры.ПланСчетов_ТолькоПросмотр;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьОтображениеСписка(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПланСчетовПриИзменении(Элемент)
	УстановитьОтборПоВладельцу();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьЭлемент(Команда)
	
	ОбработатьВыбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВидИтога(Команда)
	
	СтандартнаяОбработка=Ложь;
	СписокВидовИтога=ПолучитьСписокВариантовВыбора();
	
	ВыбранныйЭлемент=СписокВидовИтога.ВыбратьЭлемент();
	
	Если НЕ ТекущийЭлемент=Неопределено Тогда
		
		ОповеститьОВыбореИтога(ВыбранныйЭлемент.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаКлиенте
Процедура ОповеститьОВыбореИтога(ВидИтога)
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидИтога="ОБ" Тогда
		
		Если Элементы.Список.ВыделенныеСтроки.Количество()>1 Тогда
			
			ТекстИтога="ОБ"+Элементы.Список.ВыделенныеСтроки[0].Код+","+Элементы.Список.ВыделенныеСтроки[1].Код;
			
		Иначе
			
			ТекстИтога="ОБ"+Элементы.Список.ТекущиеДанные.Код;
			
		КонецЕсли;
		
	Иначе
		
		ТекстИтога=ВидИтога+Элементы.Список.ТекущиеДанные.Код;
		
	КонецЕсли;
	
	Оповестить("ВыбранИтогПоСчету",ТекстИтога);
	
	Закрыть();
			
КонецПроцедуры // ОповеститьОВыбореИтога() 

&НаКлиенте
Функция ПолучитьСписокВариантовВыбора()
	
	СписокВидовИтога=Новый СписокЗначений;
	
	Счет=Элементы.Список.ТекущиеДанные.Код;
	
	СписокВидовИтога.Добавить("",СтрШаблон(Нстр("ru = 'Счет  %1'"), Счет));
	СписокВидовИтога.Добавить("СНД",СтрШаблон(Нстр("ru = 'Дебетовое сальдо на начало периода по счету %1'"), Счет));
	СписокВидовИтога.Добавить("СНК",СтрШаблон(Нстр("ru = 'Кредитовое сальдо на начало периода по счету %1'"), Счет));
	
	Если Элементы.Список.ТекущиеДанные.Вид="АП" Тогда
		
		СписокВидовИтога.Добавить("СНС",СтрШаблон(Нстр("ru = 'Свернутое сальдо на начало периода по счету %1'"), Счет));
		
	КонецЕсли;
	
	СписокВидовИтога.Добавить("ДО",СтрШаблон(Нстр("ru = 'Оборот за период по дебету счета %1'"), Счет));
	СписокВидовИтога.Добавить("КО",СтрШаблон(Нстр("ru = 'Оборот за период по кредиту счета %1'"), Счет));
	СписокВидовИтога.Добавить("СО",СтрШаблон(Нстр("ru = 'Свернутый оборот за период по счету %1'"), Счет));
	
	СписокВидовИтога.Добавить("СКД",СтрШаблон(Нстр("ru = 'Дебетовое сальдо на конец периода по счету %1'"), Счет));
	СписокВидовИтога.Добавить("СКК",СтрШаблон(Нстр("ru = 'Кредитовое сальдо на конец периода по счету %1'"), Счет));
	
	Если Элементы.Список.ТекущиеДанные.Вид="АП" Тогда
		
		СписокВидовИтога.Добавить("СКС",СтрШаблон(Нстр("ru = 'Свернутое сальдо на конец периода по счету %1'"), Счет));
		
	КонецЕсли;
	
	Если Элементы.Список.ВыделенныеСтроки.Количество()>1 Тогда
		
		СчетДт=Элементы.Список.ВыделенныеСтроки[0].Код;
		СчетКт=Элементы.Список.ВыделенныеСтроки[1].Код;

		СписокВидовИтога.Добавить("ОБ",СтрШаблон(Нстр("ru = 'Оборот за период в дебет счета %1 с кредита счета %2'"), СчетДт, СчетКт));
		
	КонецЕсли;
	
	Возврат СписокВидовИтога;	
	
КонецФункции // ПолучитьСписокВариантовВыбора() 

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработатьВыбор(СтандартнаяОбработка);
				
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыбор(СтандартнаяОбработка=Истина)
	
	СтандартнаяОбработка=Ложь;
	
	Если Элементы.Список.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбораИтогов Тогда
		
		СтандартнаяОбработка=Ложь;
		СписокВидовИтога=ПолучитьСписокВариантовВыбора();
		
		ВыбранныйЭлемент=СписокВидовИтога.ВыбратьЭлемент();
		
		Если НЕ ВыбранныйЭлемент=Неопределено Тогда
			
			ОповеститьОВыбореИтога(ВыбранныйЭлемент.Значение);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ЭтаФорма.ВладелецФормы)=Тип("ПолеФормы") 
		И ЭтаФорма.ВладелецФормы.Вид=ВидПоляФормы.ПолеВвода
		И ЭтаФорма.ВладелецФормы.ВыборГруппИЭлементов=ГруппыИЭлементы.Элементы 
		И Элементы.Список.ТекущиеДанные.ГруппирующийСчет Тогда
		
		ПоказатьПредупреждение(, Нстр("ru = 'Выбранный счет является группирующим и не может быть использован.'"),30);
		Возврат;
		
	Иначе
		
		ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработатьВыбор() 

&НаСервере
Процедура УстановитьОтборПоВладельцу()
	
	Справочники.РегистрыБухгалтерииБД.ПроверитьНаличиеОписанийРегистров(ПланСчетов.Владелец);
	
	Элементы.СчетСсылка.Видимость = (ПланСчетов.Владелец = Справочники.ТипыБазДанных.ТекущаяИБ);
	Заголовок = ?(ПланСчетов.Пустая(), "", СтрШаблон(Нстр("ru = 'План счетов (%1)'"), ПланСчетов.Наименование));
	
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Список, "Владелец", ПланСчетов, Не ПланСчетов.Пустая());
	
	НастроитьОтображениеСписка(ЭтаФорма);	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьОтображениеСписка(Форма)
	
	Если Форма.Список.Отбор.Элементы.Количество() > 1 Тогда
		Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

