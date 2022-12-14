
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы="ФормаОбъекта" Тогда
		
		ВыбраннаяФорма=Метаданные.Обработки.НастройкиФормированияПроводокПоДокументам.Формы.ФормаНастройкиПроводки;
				
		СтандартнаяОбработка=Ложь;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Наименование");
	Поля.Добавить("ПредставлениеИсточника");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Представление=СокрЛ(Данные.Наименование)+"; "+СокрЛ(Данные.ПредставлениеИсточника);
	
КонецПроцедуры

#КонецЕсли

