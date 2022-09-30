#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СтепениДоходности.Ссылка КАК Ссылка,
	|	СтепениДоходности.ПометкаУдаления КАК ПометкаУдаления,
	|	СтепениДоходности.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СтепениДоходности.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.СтепениДоходности КАК СтепениДоходности
	|ГДЕ
	|	НЕ СтепениДоходности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
	
		Пока Выборка.Следующий() Цикл
		
			ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
		
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
