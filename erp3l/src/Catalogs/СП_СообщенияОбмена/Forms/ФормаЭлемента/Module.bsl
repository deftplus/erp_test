
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВидимостьДоступностьЗакладкиОшибкиДоступа=ПроверитьВидимостьДоступностьЗакладкиОшибкиДоступа();
	Элементы.СтраницаОшибка.Видимость = ВидимостьДоступностьЗакладкиОшибкиДоступа;	
	
	
	РазделитьТекстСообщенияJSON();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеСообщенияПриИзменении(Элемент)
	
	Элементы.СтраницаОшибка.Видимость =  ПроверитьВидимостьДоступностьЗакладкиОшибкиДоступа();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьВидимостьДоступностьЗакладкиОшибкиДоступа()
	
	ЗакладкаОшибкиДоступна = (Объект.СостояниеСообщения = Перечисления.СП_СостоянияСообщений.Ошибка) или ЗначениеЗаполнено(Объект.ТекстОшибки);
	Возврат(ЗакладкаОшибкиДоступна);	
	//Элементы.СтраницаОшибка.Видимость = ЗакладкаОшибкиДоступна;
	
КонецФункции                    


&НаСервере

Процедура РазделитьТекстСообщенияJSON()   
	
		   КопияСтрокиJSON=Объект.ТелоСообщения;
		   
		   ПозицияЗакрывающейСкобкиHEAD=стрНайти(КопияСтрокиJSON,"}",,10,1);
		   Если ПозицияЗакрывающейСкобкиHEAD<>0 тогда
				 ЭтаФОрма.ТекстСообщенияhead=сред(КопияСтрокиJSON,11,ПозицияЗакрывающейСкобкиHEAD-11);					   
			   
		   КонецЕсли;
		   
		   ПозицияCAPTION=стрНайти(КопияСтрокиJSON,"""caption"": {");
		   
		   Если ПозицияCAPTION<>0 тогда
			   
			   ПозицияЗакрывающейСкобкиCAPTION=стрНайти(КопияСтрокиJSON,"}",,ПозицияCAPTION+12,1);
			   
			   Если ПозицияЗакрывающейСкобкиCAPTION<>0 тогда
			   	ЭтаФОрма.ТекстСообщенияCaption=сред(КопияСтрокиJSON,ПозицияCAPTION+12,ПозицияЗакрывающейСкобкиCAPTION-ПозицияCAPTION-12);						   
				   
			   КонецЕсли;
		   КонецЕсли;	   
		   
		   Если СтрНайти(КопияСтрокиJSON,"""detail"": []")>0 тогда возврат; конецЕсли;
		   
		   ПозицияDETAIL=стрНайти(КопияСтрокиJSON,"""detail"": [");	 
	       Если ПозицияDETAIL<>0 тогда
				ЭтаФОрма.ТекстСообщенияDETAIL=сред(КопияСтрокиJSON,ПозицияDETAIL+11,стрДлина(КопияСтрокиJSON)-ПозицияDETAIL-12);			                 		   
				ЭтафОРМА.ТекстСообщенияDETAIL=СТРзАМЕНИТЬ(ЭтаФОрма.ТекстСообщенияDETAIL,"}, ","},"+Символы.ВК); 
				
			   
	       КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Распознать(Команда)
	РаспознатьНаСервере(); 
	ЭтотОбъект.Прочитать();
	Элементы.СтраницаОшибка.Видимость =  ПроверитьВидимостьДоступностьЗакладкиОшибкиДоступа();
КонецПроцедуры

&НаСервере
Процедура РаспознатьНаСервере()
	
	ОбъектСообщения=РеквизитФормыВЗначение("Объект"); 
	ОбъектСообщения.СсылкаНаОбъект=неопределено;
	ОбъектСообщения.СостояниеСообщения=Перечисления.СП_СостоянияСообщений.Новое;
	ОбъектСообщения.ТекстОшибки=""; ОбъектСообщения.Результатв1С="Обрабатывается";
	ОбъектСообщения.Записать();

	МассивКРаспознаванию=Новый Массив();
	МассивКраспознаванию.Добавить(ОбъектСообщения.Ссылка);
	СП_РаботаССообщениями.ллл_ВыполнитьОбработкуВходящихСообщений(истина,МассивКраспознаванию,истина);
	
	//инт_ПроцедурыПоискаСоответствийОбмена.ОбработатьСП_Сообщение(ОбъектСообщения,неопределено,истина);
	ЗначениеВРеквизитФормы(ОбъектСообщения,"Объект");	
КонецПроцедуры

&НаСервере
Процедура РаспознатьВФонеНаСервере()
	ОбъектСообщения=РеквизитФормыВЗначение("Объект"); 
	ОбъектСообщения.СсылкаНаОбъект=неопределено;
	ОбъектСообщения.СостояниеСообщения=Перечисления.СП_СостоянияСообщений.Новое;
	ОбъектСообщения.ТекстОшибки=""; ОбъектСообщения.Результатв1С="Обрабатывается";
	ОбъектСообщения.Записать();
	//инт_ПроцедурыПоискаСоответствийОбмена.ОбработатьСП_СообщениеВФоне(Объект.Ссылка,неопределено,истина); 
	
	МассивКРаспознаванию=Новый Массив();
	МассивКраспознаванию.Добавить(ОбъектСообщения.Ссылка);                                                             
	
	МассивПараметров=Новый Массив();
	МассивПараметров.Добавить(истина);
	МассивПараметров.Добавить(МассивКраспознаванию);
	Массивпараметров.Добавить(ложь);
	МассивПараметров.Добавить(Справочники.инт_СоответствиеОбъектовЗначениямИнтеграции.ПустаяСсылка());
	
	задание=ФоновыеЗадания.Выполнить("СП_РаботаССообщениями.ллл_ВыполнитьОбработкуВходящихСообщений",МассивПараметров);
	пока не ДлительныеОперации.ЗаданиеВыполнено(Задание.УникальныйИдентификатор) цикл
		
	КонецЦикла;		
	
	
	
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура РаспознатьВФоне(Команда)
	РаспознатьВФонеНаСервере();
	ЭтотОбъект.Прочитать();
	Элементы.СтраницаОшибка.Видимость =  ПроверитьВидимостьДоступностьЗакладкиОшибкиДоступа();

КонецПроцедуры


#КонецОбласти