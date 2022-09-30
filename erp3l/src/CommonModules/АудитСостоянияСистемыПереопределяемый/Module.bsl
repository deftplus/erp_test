////////////////////////////////////////////////////////////////////////////////
// Подсистема «Аудит состояния системы».
// Переопределяемые процедуры и функции.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет заполнить описание групп проверок.
// Вызывается при заполнении справочника ПроверкиСостоянияСистемы.
//
// Параметры:
//	ТаблицаГруппПроверок - см. АудитСостоянияСистемы.ТаблицаГруппПроверокСостоянияСистемы 
//
Процедура ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок) Экспорт
	
	ЗакрытиеМесяцаСервер.ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок);
	//++ НЕ УТКА
	Документы.ПлановаяКалькуляция2_2.ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок);
	//-- НЕ УТКА
	
	АудитСостоянияСистемыЛокализация.ЗаполнитьГруппыПроверокДляРегистрации(ТаблицаГруппПроверок);
КонецПроцедуры

// Позволяет заполнить описание проверок.
// Вызывается при заполнении справочника ПроверкиСостоянияСистемы.
//
// Параметры:
//	ТаблицаПроверок - см. АудитСостоянияСистемы.ТаблицаПроверокСостоянияСистемы
//
Процедура ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок) Экспорт
	
	ЗакрытиеМесяцаСервер.ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок);
	//++ НЕ УТКА
	Документы.ПлановаяКалькуляция2_2.ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок);
	//-- НЕ УТКА
	
	АудитСостоянияСистемыЛокализация.ЗаполнитьПроверкиДляРегистрации(ТаблицаПроверок);
КонецПроцедуры

#КонецОбласти
