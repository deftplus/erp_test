///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Элементы.Валюты.РежимВыбора = Параметры.РежимВыбора;
	
	ДатаКурса = НачалоДня(ТекущаяДатаСеанса());
	Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ДатаКурса", ДатаКурса);
	
	ИзменяемыеПоля = Новый Массив;
	ИзменяемыеПоля.Добавить("ОтносительныйКурс");
	Список.УстановитьОграниченияИспользованияВГруппировке(ИзменяемыеПоля);
	Список.УстановитьОграниченияИспользованияВПорядке(ИзменяемыеПоля);
	Список.УстановитьОграниченияИспользованияВОтборе(ИзменяемыеПоля);
	
	ДоступноИзменениеВалют = ПравоДоступа("Изменение", Метаданные.РегистрыСведений.КурсыВалют);
	ДоступнаЗагрузкаКурсов = Метаданные.Обработки.Найти("ЗагрузкаКурсовВалют") <> Неопределено И ДоступноИзменениеВалют;
	
	Элементы.ФормаПодборИзКлассификатора.Видимость = ДоступнаЗагрузкаКурсов;
	Элементы.ФормаЗагрузитьКурсыВалют.Видимость = ДоступнаЗагрузкаКурсов;
	Если ДоступноИзменениеВалют Тогда
		ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФормаПодборИзМеждународногоКлассификатора",
			"Видимость",
			Ложь);
	КонецЕсли;
	
	Если ДоступнаЗагрузкаКурсов и ДоступноИзменениеВалют Тогда
		Элементы.ГруппаЗагрузитьКурсыВалют.Видимость = Истина;
	Иначе
		Элементы.ГруппаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ДоступнаЗагрузкаКурсов Тогда
		Если ДоступноИзменениеВалют Тогда
			Элементы.СоздатьВалюту.Заголовок = НСтр("ru = 'Создать';
													|en = 'Create'");
		КонецЕсли;
		Элементы.Создать.Вид = ВидГруппыФормы.ГруппаКнопок;
	КонецЕсли;
	
	//++ НЕ ГОСИС
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют") Тогда
		Элементы.Валюты.ИзменятьСоставСтрок = Ложь;
		Элементы.ФормаПодборИзКлассификатора.Видимость = Ложь;
		Элементы.ФормаЗагрузитьКурсыВалют.Видимость = Ложь;
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(РезультатВыбора, ИсточникВыбора)
	
	Элементы.Валюты.Обновить();
	Элементы.Валюты.ТекущаяСтрока = РезультатВыбора;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_КурсыВалют"
		Или ИмяСобытия = "Запись_ЗагрузкаКурсовВалют"
		Или ИмяСобытия = "Запись_ОтносительныеКурсыВалют"
		Или ИмяСобытия = "Запись_ЗагрузкаОтносительныхКурсовВалют"Тогда
		Элементы.Валюты.Обновить();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВалюты

&НаСервереБезКонтекста
Процедура ВалютыПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	
	Перем ДатаКурса;
	
	Если Не Настройки.ДополнительныеСвойства.Свойство("ДатаКурса", ДатаКурса) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КурсыВалют.Валюта КАК Валюта,
	|	КурсыВалют.БазоваяВалюта КАК БазоваяВалюта,
	|	КурсыВалют.КурсЧислитель КАК КурсЧислитель,
	|	КурсыВалют.КурсЗнаменатель КАК КурсЗнаменатель
	|ИЗ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&КонецПериода, Валюта В (&Валюты)) КАК КурсыВалют
	|ИТОГИ ПО
	|	Валюта";
	Запрос.УстановитьПараметр("Валюты", Строки.ПолучитьКлючи());
	Запрос.УстановитьПараметр("КонецПериода", ДатаКурса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаВалюта = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаВалюта.Следующий() Цикл
		
		СтрокаСписка = Строки[ВыборкаВалюта.Валюта];
		
		ВыборкаДетальныеЗаписи = ВыборкаВалюта.Выбрать();
		ОтносительныйКурс = "";
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Если ВыборкаДетальныеЗаписи.Валюта <> ВыборкаДетальныеЗаписи.БазоваяВалюта Тогда
				ОтносительныйКурс = ?(ПустаяСтрока(ОтносительныйКурс), "", ОтносительныйКурс + ", ") + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																										НСтр("ru = '%1 %2 за %3 %4';
																											|en = '%1 %2 for %3 %4'"), 
																										ВыборкаДетальныеЗаписи.КурсЗнаменатель,
																										ВыборкаДетальныеЗаписи.Валюта,
																										ВыборкаДетальныеЗаписи.КурсЧислитель,
																										ВыборкаДетальныеЗаписи.БазоваяВалюта);
			КонецЕсли;
		КонецЦикла;
		
		СтрокаСписка.Данные["ОтносительныйКурс"] = ОтносительныйКурс;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборИзКлассификатора(Команда)
	
	ИмяФормыПодбора = "Обработка.ЗагрузкаКурсовВалют.Форма.ПодборВалютИзКлассификатора";
	ОткрытьФорму(ИмяФормыПодбора, , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКурсыВалют(Команда)
	
	ИмяФормыЗагрузки = "Обработка.ЗагрузкаКурсовВалют.Форма";
	ПараметрыФормы = Новый Структура("ОткрытиеИзСписка");
	ОткрытьФорму(ИмяФормыЗагрузки, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
