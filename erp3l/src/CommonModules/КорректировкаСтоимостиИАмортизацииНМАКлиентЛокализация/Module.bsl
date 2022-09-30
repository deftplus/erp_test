////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Корректировка стоимости и амортизации НМА".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ФормаДокумента

// 
// Параметры:
// 	Элемент - ПолеФормы - 
// 	Форма - ФормаКлиентскогоПриложения - 
Процедура ПриИзмененииРеквизита(Элемент, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	ПродолжитьИзменениеРеквизита = Истина;
	
	//++ Локализация
	
	Элементы = Форма.Элементы;
	
	Если Элемент = Элементы.ВидИмущества
		ИЛИ Элемент = Элементы.ПередаватьРасходыВДругуюОрганизацию Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Выполнить_НастроитьЗависимыеЭлементыФормы", Элемент.Имя);
		
	КонецЕсли;
	
	//-- Локализация
	
	Если ПродолжитьИзменениеРеквизита Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьИзменениеРеквизита(
			Форма, 
			Элемент.Имя, 
			ТребуетсяВызовСервера,
			ДополнительныеПараметры);
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
