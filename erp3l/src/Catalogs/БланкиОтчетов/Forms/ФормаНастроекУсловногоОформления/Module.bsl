

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ПустаяСтрока(Параметры.АдресСхемыСКД) Тогда	 	 	
		НастройкиКД.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.АдресСхемыСКД));
		Если Параметры.АдресДопНастроекУО <> "" Тогда
			НастройкиКД.ЗагрузитьНастройки(ПолучитьИзВременногоХранилища(Параметры.АдресДопНастроекУО));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	
	СтруктураПараметров = Новый Структура("АдресДопНастроекУО",ПоместитьВоВременноеХранилище(НастройкиКД.Настройки,Новый УникальныйИдентификатор));                   
	
	Закрыть(СтруктураПараметров);
	
КонецПроцедуры





