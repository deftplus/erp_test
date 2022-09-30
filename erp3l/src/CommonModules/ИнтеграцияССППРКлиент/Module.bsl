////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с СППР"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает функциональную модель раздела интерфейса
//
// Параметры:
//  РазделИнтерфейса	- Строка - Имя раздела интерфейса.
//
Процедура ОткрытьФункциональнуюМодельРаздела(РазделИнтерфейса) Экспорт

	ПараметрыФормы = Новый Структура("РазделИнтерфейса", РазделИнтерфейса);
	ОткрытьФорму("Обработка.ИнтеграцияССППР.Форма.ФункциональнаяМодель", ПараметрыФормы);
	
	// Если форма уже открыта, то оповестим ее, чтобы показать новые данные
	Оповестить("СППР_ФункциональнаяМодель", ПараметрыФормы);
	
КонецПроцедуры

// Выполняет команду интеграции с СППР
//
// Параметры:
//  Форма					- ФормаКлиентскогоПриложения - Форма в которой расположена команда
//  Команда					- КомандаФормы - Команда, которую нужно выполнить
//  ДополнительныеПараметры	- Структура - Дополнительные параметры.
//
Процедура ВыполнитьКомандуИнтеграцииССППР(Форма, Команда, ДополнительныеПараметры) Экспорт

	Если СтрНайти(Команда.Имя, "КомандаСППР") = 0 Тогда
		// Это не команда интеграции с СППР
		Возврат;
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура("ИмяФормы,Заголовок,ДополнительныеПараметры", Форма.ИмяФормы, Форма.Заголовок, ДополнительныеПараметры);
	ОткрытьФорму("Обработка.ИнтеграцияССППР.Форма.ФункциональнаяМодель", ПараметрыФормы);
	
	// Если форма уже открыта, то оповестим ее, чтобы показать новые данные
	Оповестить("СППР_ФункциональнаяМодель", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти
