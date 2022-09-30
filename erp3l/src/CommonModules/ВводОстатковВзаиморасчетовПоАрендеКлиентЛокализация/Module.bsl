////////////////////////////////////////////////////////////////////////////////
// Процедуры, используемые для локализации документа "Ввод остатков взаиморасчетов по аренде".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Параметры:
// 	Команда - КомандаФормы - 
// 	Форма - ФормаКлиентскогоПриложения - 
Процедура ПриВыполненииКоманды(Команда, Форма) Экспорт

	ДополнительныеПараметры = Неопределено;
	ТребуетсяВызовСервера = Ложь;
	ПродолжитьВыполнениеКоманды = Истина;
	
	//++ Локализация
	
	Элементы = Форма.Элементы;

	Если Команда.Имя = Элементы.ЗаполнитьПоДаннымОУ.ИмяКоманды Тогда
		ЗаполнитьПоДаннымОУ(Форма, Команда.Имя, ТребуетсяВызовСервера, ПродолжитьВыполнениеКоманды);
	КонецЕсли; 
	
	//-- Локализация
	
	Если ПродолжитьВыполнениеКоманды Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьВыполнениеКоманды(
			Форма, 
			Команда.Имя, 
			ТребуетсяВызовСервера,
			ДополнительныеПараметры);
			
	КонецЕсли; 
	
КонецПроцедуры

//++ Локализация

Процедура ЗаполнитьПоДаннымОУ(Форма, ИмяКоманды, ТребуетсяВызовСервера, ПродолжитьВыполнениеКоманды)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяКоманды", ИмяКоманды);
	ОповещениеВопросЗаполнитьПоОстаткам = Новый ОписаниеОповещения("ЗаполнитьПоДаннымОУЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ТекстВопроса = НСтр("ru = 'При заполнении текущие данные будут очищены. Продолжить?';
						|en = 'Current data will be cleared upon filling. Continue?'");
	ПоказатьВопрос(ОповещениеВопросЗаполнитьПоОстаткам, ТекстВопроса, РежимДиалогаВопрос.ДаНет);

	ПродолжитьВыполнениеКоманды = Ложь;
		
КонецПроцедуры

Процедура ЗаполнитьПоДаннымОУЗавершение(РезультатВопроса, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ОбщегоНазначенияУТКлиент.ПродолжитьВыполнениеКоманды(
			ДополнительныеПараметры.Форма, 
			ДополнительныеПараметры.ИмяКоманды, 
			Истина,
			Неопределено);
			
	КонецЕсли;
	
КонецПроцедуры

//-- Локализация

#КонецОбласти