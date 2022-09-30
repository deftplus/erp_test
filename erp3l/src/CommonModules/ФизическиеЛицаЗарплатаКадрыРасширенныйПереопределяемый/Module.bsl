
#Область ПрограммныйИнтерфейс

// Событие ОбработкаПолученияФормы для справочника ФизическиеЛица.
//
// Параметры:
//  ВидФормы - строка - имя стандартной формы.
//  Параметры - структура - параметры формы.
//  ВыбраннаяФорма - имя открываемой формы или объект метаданных Форма.
//  ДополнительнаяИнформация - структура - дополнительная информация открытия формы.
//  СтандартнаяОбработка - булево - признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаПолученияФормыСправочникаФизическиеЛица(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	ИспользоватьУпрощеннуюФорму = Ложь;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		
		Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.Сотрудники) Тогда
			ИспользоватьУпрощеннуюФорму = Истина;
		КонецЕсли;
		
		Если НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.РолиФизическихЛиц) Тогда
			ИспользоватьУпрощеннуюФорму = Истина;
		КонецЕсли;
		
	Иначе
		ИспользоватьУпрощеннуюФорму = Истина;
	КонецЕсли;
	
	Если ИспользоватьУпрощеннуюФорму Тогда
		Если ВидФормы = "ФормаВыбора" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаВыбораУП";
		ИначеЕсли ВидФормы = "ФормаОбъекта" Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаЭлементаУП";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти