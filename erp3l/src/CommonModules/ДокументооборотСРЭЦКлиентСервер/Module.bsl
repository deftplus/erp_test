////////////////////////////////////////////////////////////////////////////////
// Подсистема "Документооборот с РЭЦ".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция АдресСервера(Соединение = Неопределено) Экспорт
	
	Если ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования() Тогда
		//Возврат "http://uidm.uidm-dev.d.exportcenter.ru";
		АдресСервера = "https://lk.d.exportcenter.ru";
	Иначе
		АдресСервера = "https://lk.exportcenter.ru";
	КонецЕсли;
	
	#Если Сервер Тогда
	Возврат ДокументооборотСРЭЦВызовСервера.ПолучитьЗаменяемоеЗначениеТестовогоСервера1С(АдресСервера, АдресСервера, Соединение);
	#Иначе
	Возврат ДокументооборотСРЭЦВызовСервера.ПолучитьЗаменяемоеЗначениеТестовогоСервера1С(АдресСервера, АдресСервера, NULL);
	#КонецЕсли
		
КонецФункции  

Функция АдресСтатьиОСервисеРЭЦ() Экспорт
	
	Возврат "https://buh.ru/articles/documents/135633/";
	
КонецФункции

Функция КлиентИнтеграцииСРЭЦ() Экспорт

	Результат = Новый Структура;  
	Если ДокументооборотСКОВызовСервера.ИспользуетсяРежимТестирования() Тогда
		Результат.Вставить("client_id", "zvat-1c-plugin");
		Результат.Вставить("client_secret", "o2mWs8a");     
	Иначе
		Результат.Вставить("client_id", "zvat-1c-plugin");
		Результат.Вставить("client_secret", "j5Wu7Tns29");  
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма) Экспорт
	
	ОтчетСсылка 		= СсылкаНаОтчетПоФорме(Форма);
	ОрганизацияСсылка 	= ПолучитьОрганизациюПоФорме(Форма);
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(
		ОтчетСсылка, 
		ОрганизацияСсылка, 
		"РЭЦ");
			
	Возврат ПараметрыПрорисовкиПанелиОтправки;
	
КонецФункции

Процедура ПриИнициализацииФормыРегламентированногоОтчета(Форма, ПараметрыПрорисовкиПанели = Неопределено) Экспорт
	
	// если кнопка отправки отсутствует, то не будем регулировать
	КнопкаОтправитьВКонтролирующийОрган = Форма.Элементы.Найти("ОтправитьВКонтролирующийОрган");
	Если КнопкаОтправитьВКонтролирующийОрган = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияСсылка = ПолучитьОрганизациюПоФорме(Форма);
	
	// прорисовываем кнопки отправки
	ПараметрыПрорисовкиКнопокОтправки   = ПараметрыПрорисовкиКнопокОтправки(ОрганизацияСсылка);
	// прорисовываем панель отправки
	ПараметрыПрорисовкиПанели 			= ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма);
	
	// регулируем видимость кнопки в зависимости от результата
	УстановитьВидимостьГруппыКнопокОтправки(Форма, ПараметрыПрорисовкиКнопокОтправки);
	
КонецПроцедуры

Функция ПолучитьКодДокументаРЭЦПоНаименованию(НаименованиеОтчета) Экспорт    
	
	Результат = "";
	
	Если СтрНачинаетсяС(НаименованиеОтчета, "NO_NDS_") Тогда
		Результат = "c00379";
	ИначеЕсли СтрНачинаетсяС(НаименованиеОтчета, "NO_NDS.") Тогда
		Результат = "c00380";
	ИначеЕсли СтрНачинаетсяС(НаименованиеОтчета, "KO_RRTDNDS_") Тогда                      
		Результат = "c00389";
	ИначеЕсли СтрНачинаетсяС(НаименованиеОтчета, "KO_RRTDNDS.") Тогда                      
		Результат = "c00390"; 
	ИначеЕсли СтрНачинаетсяС(НаименованиеОтчета, "KO_RRTRDNDS_") Тогда                      
		Результат = "c00389";
	ИначеЕсли СтрНачинаетсяС(НаименованиеОтчета, "KO_RRTRDNDS.") Тогда                      
		Результат = "c00390";
	Иначе        
		// Прочие документы
		Результат = "c00139";	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции  

Функция ПолучитьНаименованиеОтчетаДляРЭЦПоКоду(КодТипаОтчета) Экспорт   
	
	Результат = "";
	
	Если КодТипаОтчета = "c00379" Тогда
		Результат = "Декларация НДС";    
	ИначеЕсли КодТипаОтчета = "c00380" Тогда 
		Результат = "Приложение к декларации НДС";
	ИначеЕсли КодТипаОтчета = "c00389" Тогда 
		Результат = "Реестр таможенных деклараций";
	ИначеЕсли КодТипаОтчета = "c00390" Тогда 
		Результат = "Приложение к реестру таможенных деклараций";
	ИначеЕсли КодТипаОтчета = "c00199" Тогда 
		Результат = "Внешнеторговый (экспортный) договор/контракт";
	ИначеЕсли КодТипаОтчета = "c00139" Тогда
		Результат = "Прочие документы";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СсылкаНаОтчетПоФорме(Форма) Экспорт
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "СтруктураРеквизитовФормы")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.СтруктураРеквизитовФормы, "мСохраненныйДок") Тогда
		Отчет = Форма.СтруктураРеквизитовФормы.мСохраненныйДок;
	ИначеЕсли СтрНайти(Форма.ИмяФормы, "ЭлектронныеПредставленияРегламентированныхОтчетов") <> 0 Тогда
		Отчет = Форма.Объект.Ссылка;
	Иначе
		Отчет = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСерверПереопределяемый.ПолучитьСсылкуНаОтправляемыйДокументПоФорме(Форма);
	КонецЕсли;
	
	Возврат ДокументооборотСРЭЦВызовСервера.ПолучитьПоследнююОтправкуОтчета(Отчет);
	
КонецФункции

Функция ПолучитьОрганизациюПоФорме(Форма) Экспорт
	
	Если РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "СтруктураРеквизитовФормы")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.СтруктураРеквизитовФормы, "Организация") Тогда
		Возврат Форма.СтруктураРеквизитовФормы.Организация;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "Объект")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.Объект, "Организация") Тогда
		Возврат Форма.Объект.Организация;
	ИначеЕсли РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма, "ОтправкаОбъект")
	И РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(Форма.ОтправкаОбъект, "Организация") Тогда
		Возврат Форма.ОтправкаОбъект.Организация;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Процедура УстановитьВидимостьГруппыКнопокОтправки(Форма, ПараметрыПрорисовкиКнопокОтправки) Экспорт
	
	Для Каждого Эл Из ПараметрыПрорисовкиКнопокОтправки Цикл
		ЭУ = Форма.Элементы.Найти(Эл.Ключ);
		Если ЭУ <> Неопределено Тогда
			ЭУ.Видимость = Эл.Значение;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПараметрыПрорисовкиКнопокОтправки(ОрганизацияСсылка) Экспорт
	
	ПараметрыПрорисовкиКнопокОтправки = Новый Структура;	
	ПараметрыПрорисовкиКнопокОтправки.Вставить("ГруппаОтправкаВКонтролирующийОрган", Истина);
	ПараметрыПрорисовкиКнопокОтправки.Вставить("ПроверитьВИнтернете", Ложь);
	
	Возврат ПараметрыПрорисовкиКнопокОтправки;
	
КонецФункции

#КонецОбласти