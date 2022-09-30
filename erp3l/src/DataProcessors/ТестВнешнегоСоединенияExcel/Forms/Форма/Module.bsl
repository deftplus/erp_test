
&НаСервереБезКонтекста
Функция ПодключитьНаСервере(СтрокаПодключения, ВерсияПлатформы, Сообщения)
	Попытка
		ПозФ = СтрНайти(СтрокаПодключения, "File=");
		Если ПозФ > 0 Тогда
			флФайлСуществует = Ложь;
			КолСим = 0;
			ВремСтр = Сред(СтрокаПодключения, ПозФ+4);
			ПозНач = СтрНайти(ВремСтр, """");
			Если ПозНач > 0 Тогда
				ПозНач = ПозНач+1;
				ВремСтр = Сред(ВремСтр, ПозНач);
				ПозКон = СтрНайти(ВремСтр, """");
				Если ПозКон > 0 Тогда
					КолСим = ПозКон - ПозНач;
				КонеЦЕсли;
			КонецЕсли;
			Если ПозНач > 0 И КолСим > 0 Тогда
				ПутьКФайлу = Сред(СтрокаПодключения,ПозФ+3+ПозНач, КолСим+2) + "/1Cv8.1CD";
				Файл = Новый ФАйл(ПутьКФайлу);
				флФайлСуществует = ФАйл.Существует();
			КонецЕсли;
			
			Если флФайлСуществует Тогда
				Сообщения = Сообщения + "Файл: """ + ПутьКФайлу + """ существует." + Символы.ПС;
			Иначе
				Сообщения = Сообщения + "Нет доступа к файлу: """ + ПутьКФайлу + """." + Символы.ПС;
				Возврат 1;
			КонецЕсли;
		КонецЕсли;
		
		COMПодключение = Новый COMОбъект("V" + ВерсияПлатформы + ".COMConnector");
		ВнешнееПодключение = COMПодключение.Connect(СтрокаПодключения);
		Если ВнешнееПодключение = Неопределено Тогда
			Сообщения = Сообщения + "Подключение установить не удалось по непонятной причине." + Символы.ПС;
		Иначе
			Сообщения = Сообщения + "Подключение установлено." + Символы.ПС;
			
			внМетаданные = ВнешнееПодключение.Метаданные;
			ИмяКонфигурации = внМетаданные.Имя;
			Если ИмяКонфигурации = "УправлениеХолдингом" Тогда
				Сообщения = Сообщения + "Конфигурация 1С: Управление холдингом." + Символы.ПС;
			КонецЕсли;
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Сообщения = Сообщения + "Исключительная ситуация: " + Символы.ПС + ТекстОшибки + Символы.ПС;
	КонецПопытки;
	
	Возврат 0;
КонецФункции

&НаКлиенте
Процедура Подключить(Команда)
	ПодключитьНаСервере(СтрокаПодключения + "usr=""" + Пользователь + """;pwd=""" + Пароль + """;", ВерсияПлатформы, Сообщения);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВерсияПлатформы = "83";
	СтрокаПодключения = УдалитьУчетныеДанные(СтрокаСоединенияИнформационнойБазы());
	Пользователь = "Excel";
	Пароль = "111";
КонецПроцедуры

&НаСервереБезКонтекста
Функция УдалитьУчетныеДанные(Знач СтрокаСоединенияИБ)
	мСтрок = ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(СтрокаСоединенияИБ, ";");
	ОбработаннаяСтрока = "";
	Для Каждого Строка_ Из мСтрок Цикл
		ИмяПараметра = НРег(Сред(СокрЛ(Строка_),1,3));
		Если ИмяПараметра <> "usr" И ИмяПараметра <> "pwd"  И СокрЛП(Строка_ <> "") Тогда
			ОбработаннаяСтрока = ОбработаннаяСтрока + Строка_ + ";";
		КонеЦЕсли;
	КонецЦикла;
	
	возврат ОбработаннаяСтрока;
КонецФункции
