#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	НастройкиИспользованияСерий        = ПараметрыПроверки.НастройкиИспользованияСерий;
	ТолькоРедактированиеКоличества     = ПараметрыПроверки.ТолькоРедактированиеКоличества;
	ЗначенияПолейСвязи                 = ПараметрыПроверки.ЗначенияПолейСвязи;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	
	ТаблицаПроверки = Серии.Выгрузить();
	ТаблицаПроверки.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаПроверки.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ТаблицаПроверки.ЗаполнитьЗначения(ЗначенияПолейСвязи.Номенклатура, "Номенклатура");
	ТаблицаПроверки.ЗаполнитьЗначения(ПараметрыПроверки.Упаковка, "Упаковка");
	
	ПараметрыПроверкиКоличества = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверкиКоличества.ИмяТЧ = "Серии";
	ПараметрыПроверкиКоличества.ПроверяемаяТаблица = ТаблицаПроверки;
	
	Если ТолькоРедактированиеКоличества Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Серии.Количество");
		МассивНепроверяемыхРеквизитов.Добавить("Серии.КоличествоУпаковок");
	Иначе
		НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверкиКоличества);
	КонецЕсли;
	
	КлючевыеРеквизиты          = Новый Массив;
	ИспользоватьRFIDМеткиСерии = Ложь;
	УникальностьПроконтролированаПоОдномуРеквизиту = Ложь;
	
	Для Каждого Описание Из НастройкиИспользованияСерий.ОписанияИспользованияРеквизитовСерии Цикл
		
		Если Описание.ИмяНастройки <> "ИспользоватьRFIDМеткиСерии" Тогда
			Если Описание.Использование Тогда
				
				Если Не Описание.ПроверятьЗаполнение Тогда			
					МассивНепроверяемыхРеквизитов.Добавить("Серии." + Описание.ИмяРеквизита);
				ИначеЕсли Описание.ПроверятьУникальностьЗначения Тогда
					Если Не НастройкиИспользованияСерий.ИспользоватьКоличествоСерии Тогда
						ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект,"Серии", Описание.ИмяРеквизита, Отказ);
						УникальностьПроконтролированаПоОдномуРеквизиту = Истина;	
					КонецЕсли;
				Иначе
					КлючевыеРеквизиты.Добавить(Описание.ИмяРеквизита);	
				КонецЕсли;
				
			Иначе
				МассивНепроверяемыхРеквизитов.Добавить("Серии." + Описание.ИмяРеквизита);	
			КонецЕсли;
		Иначе
			Если Описание.Использование Тогда
				ИспользоватьRFIDМеткиСерии = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не НастройкиИспользованияСерий.ИспользоватьКоличествоСерии
		И Не УникальностьПроконтролированаПоОдномуРеквизиту
		И КлючевыеРеквизиты.Количество() > 0 Тогда
		ОбщегоНазначенияУТ.ПроверитьНаличиеДублейСтрокТЧ(ЭтотОбъект,"Серии", КлючевыеРеквизиты, Отказ);
	КонецЕсли;
	
	Если ИспользоватьRFIDМеткиСерии Тогда
		
		Для каждого СтрТабл Из Серии Цикл
			
			Если СтрТабл.ЗаполненRFIDTID
				И СтрТабл.НужноЗаписатьМетку Тогда
				
				ТекстСообщения = НСтр("ru = 'Требуется записать RFID-метку, информация о которой содержится в строке %НомерСтроки%.';
										|en = 'Save RFID tag specified in line %НомерСтроки%.'");
				
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", Строка(СтрТабл.НомерСтроки));
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Серии", СтрТабл.НомерСтроки, "СтатусРаботыRFID");
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,Поле,"Объект",Отказ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	НоменклатураЛокализация.ПроверитьЗаполнениеРеквизитовСерий(ЭтотОбъект,
																МассивНепроверяемыхРеквизитов,
																ПараметрыПроверки,
																Отказ); 
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли