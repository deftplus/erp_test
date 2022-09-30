
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление = "";
	
	Если Не ПустаяСтрока(Данные.Код) Тогда
		Представление = СокрЛП(Данные.Код);
	КонецЕсли; 
	
	Если Не ПустаяСтрока(Данные.Наименование) Тогда
		
		Если Не ПустаяСтрока(Представление) Тогда
			Представление = Представление + " ";
		КонецЕсли; 
		
		Представление = Представление + "(" + СокрЛП(Данные.Наименование) + ")";
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Используется для получения ссылки на регистрацию в налоговом органе территории.
//
// Параметры:
//  ПодразделениеОрганизации - СправочникСсылка.ТерриторииВыполненияРабот	- территория, для которого нужно получить регистрацию.
//  ДатаАктуальности		 - Дата	 										- дата, на которую необходимо получить регистрацию в НО.
// 
// Возвращаемое значение:
//  СправочникСсылка.РегистрацииВНалоговомОргане - ссылка на существующую регистрацию, либо ПустаяСсылка().
//
Функция РегистрацияВНалоговомОргане(Территория, Знач ДатаАктуальности = Неопределено) Экспорт
	
	ПоследняяРегистрацияВНалоговомОргане = РегистрыСведений.ИсторияРегистрацийВНалоговомОргане.ПолучитьПоследнее(
		ДатаАктуальности,
 		Новый Структура("СтруктурнаяЕдиница", Территория));
	
	Если ЗначениеЗаполнено(ПоследняяРегистрацияВНалоговомОргане.РегистрацияВНалоговомОргане) Тогда
		Возврат ПоследняяРегистрацияВНалоговомОргане.РегистрацияВНалоговомОргане;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Территория.Владелец) Тогда
		Возврат ЗарплатаКадры.РегистрацияВНалоговомОргане(Территория.Владелец, ДатаАктуальности);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
