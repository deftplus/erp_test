#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.НеОбработана);
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.Отложена);
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.ВключенаВРеестрПлатежей);
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.НаИсполнении);
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.Исполнена);
		ДанныеВыбора.Добавить(Перечисления.СостоянияИсполненияЗаявки.Отменена);
		
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 