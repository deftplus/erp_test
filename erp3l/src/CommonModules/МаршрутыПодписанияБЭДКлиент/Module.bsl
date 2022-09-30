
#Область СлужебныйПрограммныйИнтерфейс

// Открывает формы выбора маршрутов подписания.
// 
// Параметры:
// 	Отбор - см. НовыйОтборМаршрутовПодписания
// 	ТекущийМаршрут - СправочникСсылка.МаршрутыПодписания
// 	Уникальность - Произвольный
// 	Оповещение - ОписаниеОповещения
Процедура ВыбратьМаршрутПодписания(Отбор, ТекущийМаршрут, Уникальность, Оповещение) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура("ПараметрыОтбора", Отбор);

	ПараметрыОткрытияФормы.Вставить("ТекущаяСтрока", ТекущийМаршрут);
	ОткрытьФорму("Справочник.МаршрутыПодписания.Форма.ФормаВыбора", ПараметрыОткрытияФормы,, 
		Уникальность,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 

КонецПроцедуры

Процедура ОткрытьВыборМаршрутаПодписанияПоПараметрам(ФормаВладелец, АдресПараметровВыбораМаршрута, ВидПодписи, Организация, 
	ОповещениеОЗакрытии = Неопределено, ТолькоПросмотр = Ложь) Экспорт
	
	ПараметрыОткрытияФормы = Новый Структура("ПараметрыМаршрута, Организация, ТолькоПросмотр, ВидПодписи", 
		АдресПараметровВыбораМаршрута, Организация, ТолькоПросмотр, ВидПодписи);
	ОткрытьФорму("Справочник.МаршрутыПодписания.Форма.ВыборМаршрута", ПараметрыОткрытияФормы, ФормаВладелец, 
		ФормаВладелец.УникальныйИдентификатор,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 

КонецПроцедуры

// Конструктор параметров отбора маршрутов подписания.
// 
// Возвращаемое значение:
// 	Структура:
// * ВидПодписи - ПеречислениеСсылка.ВидыЭлектронныхПодписей
// * СхемыПодписания - Массив из ПеречислениеСсылка.СхемыПодписанияЭД
// * Организация - ОпределяемыйТип.Организация
Функция НовыйОтборМаршрутовПодписания() Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("Организация", Неопределено);
	Отбор.Вставить("СхемыПодписания", Новый Массив);
	Отбор.Вставить("ВидПодписи", ПредопределенноеЗначение("Перечисление.ВидыЭлектронныхПодписей.ПустаяСсылка"));
	
	Возврат Отбор;
	
КонецФункции

Функция ПредопределенныеМаршруты() Экспорт
	
	Результат = Новый Структура;
	
	МаршрутУказыватьПриСоздании = ПредопределенноеЗначение("Справочник.МаршрутыПодписания.УказыватьПриСоздании");
	Результат.Вставить("УказыватьПриСоздании", МаршрутУказыватьПриСоздании);
	ОднойДоступнойПодписью = ПредопределенноеЗначение("Справочник.МаршрутыПодписания.ОднойДоступнойПодписью");
	Результат.Свойство("ОднойДоступнойПодписью", ОднойДоступнойПодписью);
	
	Возврат Результат;
	
КонецФункции

// Открывает форму списка маршрутов подписания.
//
Процедура ОткрытьСписокМаршрутовПодписания() Экспорт
	
	ОткрытьФорму("Справочник.МаршрутыПодписания.ФормаСписка");
	
КонецПроцедуры

#Область ДляВызоваИзДругихПодсистем

// ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

// Открывает форму исправления ошибок с отображением маршрутов подписания.
// 
// Параметры:
// 	КонтекстДиагностики - см. ОбработкаНеисправностейБЭДКлиент.НовыйКонтекстДиагностики
// 	ДополнительныеПараметры - Произвольный - см. ключ ПараметрыОбработчиков структуры, возвращаемой методом
//                                           см. ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки
Процедура ОткрытьОшибкиМаршрутовПодписания(КонтекстДиагностики, ДополнительныеПараметры) Экспорт
	
	Ошибки = ОбработкаНеисправностейБЭДКлиентСервер.ПолучитьОшибки(КонтекстДиагностики);
	Маршруты = ОбработкаНеисправностейБЭДКлиентСервер.ЗначенияСвойствОшибок(Ошибки, "СсылкаНаОбъект");
	
	ПараметрыИсправленияОшибок = ОбработкаНеисправностейБЭДКлиент.НовыеПараметрыИсправленияОшибок();
	
	Если Ошибки.Количество() > 0 Тогда
		ПараметрыИсправленияОшибок.Заголовок = Ошибки[0].ВидОшибки.ЗаголовокПроблемы;
	КонецЕсли;
	
	Команда = ОбработкаНеисправностейБЭДКлиент.НовоеОписаниеКомандыФормыИсправленияОшибок();
	Команда.Заголовок = НСтр("ru = 'Посмотреть маршрут';
							|en = 'View route'");
	Команда.Обработчик = "ОбработкаНеисправностейБЭДКлиент.ОткрытьЭлементТаблицы";
	
	ПараметрыИсправленияОшибок.Команды.Добавить(Команда);
	
	ОбработкаНеисправностейБЭДКлиент.ИсправитьОшибки(Маршруты, ПараметрыИсправленияОшибок);
	
КонецПроцедуры

// Конец ЭлектронноеВзаимодействие.БазоваяФункциональность.ОбработкаНеисправностей

#КонецОбласти

#КонецОбласти