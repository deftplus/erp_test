#Область СлужебныеПроцедурыИФункции

Функция ИмяФормыНастройкиРасчетаРезервовОтпусков() Экспорт

	Возврат "ОбщаяФорма.ОрганизацияНастройкиРасчетаРезервовОтпусков";

КонецФункции

Процедура СправкаПоОтпускам(Форма, МассивСотрудников) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.НачислениеОценочныхОбязательствПоОтпускам",
		"ПФ_MXL_СправкаПоОтпускамСотрудника",
		МассивСотрудников,
		Форма,
		Новый Структура("ПериодРегистрации", Форма.Объект.ПериодРегистрации));
	
КонецПроцедуры

Функция ОткрытьФормуВводаСреднегоЗаработкаОбщий(Форма, Сотрудник, ПериодРасчетаСреднегоЗаработкаНачало, ПериодРасчетаСреднегоЗаработкаОкончание) Экспорт

	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка",            Форма.Объект.Ссылка);
	ОписаниеОбъекта.Вставить("Организация",       Форма.Объект.Организация);
	ОписаниеОбъекта.Вставить("ПериодРегистрации", Форма.Объект.ПериодРегистрации);
	ОписаниеОбъекта.Вставить("Сотрудник",         Сотрудник);
	ОписаниеОбъекта.Вставить("ДатаНачала",        ПериодРасчетаСреднегоЗаработкаНачало);
	ОписаниеОбъекта.Вставить("ДатаОкончания",     ПериодРасчетаСреднегоЗаработкаОкончание);
	
	Оповещение = Новый ОписаниеОповещения("ОткрытьСреднийЗаработокЗавершение", Форма);

	ПараметрыРедактирования = РезервОтпусковРасширенныйВызовСервера.ПараметрыРедактированияСреднегоЗаработка(ОписаниеОбъекта);
	УчетСреднегоЗаработкаКлиент.ОткрытьФормуВводаСреднегоЗаработкаОбщий(ПараметрыРедактирования, Форма, Оповещение);

КонецФункции

Функция ОткрытьФормуВводаСохраняемогоДенежногоСодержания(Форма, Сотрудник) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
		
		Оповещение = Новый ОписаниеОповещения("ОткрытьСреднийЗаработокЗавершение", Форма);
		
		ПараметрыРедактирования = РезервОтпусковРасширенныйВызовСервера.ПараметрыРедактированияСохраняемогоДенежногоСодержания(Сотрудник, Форма.Объект.ПериодРегистрации, Форма.Объект.Ссылка, Форма.Объект.Организация);
		ПараметрыРедактирования.Вставить("УникальныйИдентификатор",	Форма.УникальныйИдентификатор);
						
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("РасчетДенежногоСодержанияКлиент");
		Модуль.ОткрытьФормуВводаСохраняемогоДенежногоСодержания(ПараметрыРедактирования, "Отпуск","ЕжегодныйОтпуск", Форма, Оповещение);
				
	КонецЕсли;
	
КонецФункции

Процедура ОткрытьФормуСреднегоЗаработка(Форма) Экспорт
	
	СтрокаТаблицы = Форма.Элементы.РасчетРезерваОтпусков.ТекущиеДанные;
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если СтрокаТаблицы.РасчетПоСохраняемомуЗаработку Тогда
		ОткрытьФормуВводаСохраняемогоДенежногоСодержания(Форма, СтрокаТаблицы.Сотрудник); 	
	Иначе
		ОткрытьФормуВводаСреднегоЗаработкаОбщий(Форма,
			СтрокаТаблицы.Сотрудник,
			СтрокаТаблицы.ПериодРасчетаСреднегоЗаработкаНачало,
			СтрокаТаблицы.ПериодРасчетаСреднегоЗаработкаОкончание);
	КонецЕсли;		
			
КонецПроцедуры

#КонецОбласти
