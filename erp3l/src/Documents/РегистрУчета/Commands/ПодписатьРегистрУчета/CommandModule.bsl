
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	СвойстваФайла = ПолучитьСвойстваПрисоединенногоФайла(ПараметрКоманды);
	
	СообщениеОбОшибке = "";
	
	Если НЕ СвойстваФайла.ФайлРегистраУчетаПрисоединен Тогда
		СообщениеОбОшибке = СтрШаблон(НСтр("ru = '%1 не содержит присоединенного файла';
											|en = '%1 does not contain an attached file'"), ПараметрКоманды);
	КонецЕсли;
	
	Если ПустаяСтрока(СообщениеОбОшибке) И НЕ СвойстваФайла.ИспользоватьЭП Тогда
		СообщениеОбОшибке = НСтр("ru = 'Для подписи регистра включите использование ЭП в настройках программы';
								|en = 'Enable the digital signature in the application settings to sign the register'");
	КонецЕсли;
	
	Если ПустаяСтрока(СообщениеОбОшибке) И СвойстваФайла.ПодписанЭП Тогда
		СообщениеОбОшибке = СтрШаблон(НСтр("ru = '%1 уже подписан ЭП';
											|en = '%1 is already digitally signed'"), ПараметрКоманды);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СообщениеОбОшибке) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, ПараметрКоманды);
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ПодписатьФайл(СвойстваФайла.ПрисоединенныйФайл, Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСвойстваПрисоединенногоФайла(ДокументРегистр)
	
	СвойстваФайла = Документы.РегистрУчета.ПолучитьСвойстваПрисоединенногоФайлаРегистра(ДокументРегистр, Истина);
	
	СвойстваФайла.Вставить("ИспользоватьЭП", ПолучитьФункциональнуюОпцию("ИспользоватьЭлектронныеПодписи"));
	
	Возврат СвойстваФайла;
	
КонецФункции

#КонецОбласти
