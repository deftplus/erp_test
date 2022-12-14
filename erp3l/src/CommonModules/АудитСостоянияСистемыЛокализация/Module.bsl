////////////////////////////////////////////////////////////////////////////////
// Подсистема «Аудит состояния системы».
// Переопределяемые процедуры и функции.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет заполнить описание групп проверок.
// Вызывается при заполнении справочника ПроверкиСостоянияСистемы.
//
// Параметры:
//	ТаблицаГруппПроверок - ТаблицаЗначений - см. АудитСостоянияСистемы.ТаблицаГруппПроверокСостоянияСистемы().
//
Процедура ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок) Экспорт
	//++ Локализация
	
	//++ НЕ УТ
	Обработки.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок);
	//-- НЕ УТ
	
	//-- Локализация
КонецПроцедуры

// Позволяет заполнить описание проверок.
// Вызывается при заполнении справочника ПроверкиСостоянияСистемы.
//
// Параметры:
//	ТаблицаПроверок - ТаблицаЗначений - см. АудитСостоянияСистемы.ТаблицаПроверокСостоянияСистемы().
//
Процедура ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок) Экспорт
	//++ Локализация
	
	//++ НЕ УТ
	Обработки.ПомощникПереходаНаУчетВнеоборотныхАктивовВерсии24.ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок);
	//-- НЕ УТ
	
	//-- Локализация
КонецПроцедуры

#КонецОбласти
