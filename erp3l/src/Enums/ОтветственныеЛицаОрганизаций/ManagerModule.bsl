
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	// Общие
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ГлавныйБухгалтер);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Кассир);
	
	//++ Локализация
	//++ НЕ УТ
	// Регл. учет
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаНалоговыеРегистры);
	
	// Регл. отчетность
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.УполномоченныйПредставитель);
	ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.Исполнитель);
	
	// Зарплата
	Если ПолучитьФункциональнуюОпцию("ИспользоватьНачислениеЗарплаты") Тогда
		ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы);
		ДанныеВыбора.Добавить(Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаВУР);
	КонецЕсли;
	//-- НЕ УТ
	//-- Локализация
КонецПроцедуры

#КонецОбласти
