#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
	
Процедура ОбработкаПроведения(Отказ, Режим)
	Движения.ТребованияКвалификацииКНоменклатуреПоставщиков.Записывать = Истина;
	Для Каждого ТекСтрокаТребования Из Требования Цикл
		Движение = Движения.ТребованияКвалификацииКНоменклатуреПоставщиков.Добавить();
		Движение.Период = Дата;
		Движение.Организация = Организация;
		Движение.Номенклатура = Номенклатура;
		Движение.ТребованиеКПоставщику = ТекСтрокаТребования.ТребованиеКПоставщику;
		Движение.Критерий = ТекСтрокаТребования.Критерий;
		Движение.ТребованиеКДокументу = ТекСтрокаТребования.ТребованиеКДокументу;
	КонецЦикла;
КонецПроцедуры


Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
КонецПроцедуры


#КонецЕсли

