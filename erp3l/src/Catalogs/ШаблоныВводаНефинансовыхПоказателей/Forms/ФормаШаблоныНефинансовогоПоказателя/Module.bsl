
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("Показатель") Тогда
		ТекстСообщения = НСтр("ru = 'Непосредственное открытие этой формы не предусмотрено. Для открытия формы можно воспользоваться командой ""Шаблоны ввода"" в форме нефинансовых показателей.';
								|en = 'Application cannot open this form explicitly. It opens implicitly when you select ""Input templates"" command in the ""Non-financial item"" form.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Параметр = Список.Параметры.Элементы.Найти("Показатель");
	Параметр.Значение = Параметры.Показатель;
	Параметр.Использование = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	ПараметрыФормы = Новый Структура("ПоказательЗаполнения", Список.Параметры.Элементы.Найти("Показатель").Значение);
	ОткрытьФорму("Справочник.ШаблоныВводаНефинансовыхПоказателей.Форма.ФормаЭлемента", ПараметрыФормы);
	
КонецПроцедуры
