// По варианту заполнения шаблона ВариантЗаполненияВход возвращает структуру, 
// содержащую СписокРеквизитовДляПереноса и СписокТабличныхЧастейДляПереноса.
Функция ПолучитьСтруктуруРеквизитовВариантаЗаполненияШаблона(ВариантЗаполненияВход) Экспорт
	РезультатФункции = Новый Структура;
	РезультатФункции.Вставить("СписокРеквизитовДляПереноса", Новый СписокЗначений);
	РезультатФункции.Вставить("СписокТабличныхЧастейДляПереноса", Новый СписокЗначений);
	Если ВариантЗаполненияВход = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПоКомиссии Тогда
		СписокРеквизитовДляПереноса = Новый СписокЗначений;
		СписокРеквизитовДляПереноса.Добавить("ПоследнийЭтап");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаОбъекта");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаВладельца");
		СписокРеквизитовДляПереноса.Добавить("СинонимОбъекта");
		СписокРеквизитовДляПереноса.Добавить("СинонимВладельца");
		СписокРеквизитовДляПереноса.Добавить("ПоследующаяОценка");
		СписокТабличныхЧастейДляПереноса = Новый СписокЗначений;
		СписокТабличныхЧастейДляПереноса.Добавить("ОценочнаяКомиссия");
		РезультатФункции.Вставить("СписокРеквизитовДляПереноса",		 СписокРеквизитовДляПереноса);
		РезультатФункции.Вставить("СписокТабличныхЧастейДляПереноса",	 СписокТабличныхЧастейДляПереноса);
	ИначеЕсли ВариантЗаполненияВход = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПоЭтапамИКритериям Тогда
		СписокРеквизитовДляПереноса = Новый СписокЗначений;
		СписокРеквизитовДляПереноса.Добавить("ПоследнийЭтап");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаОбъекта");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаВладельца");
		СписокРеквизитовДляПереноса.Добавить("СинонимОбъекта");
		СписокРеквизитовДляПереноса.Добавить("СинонимВладельца");
		СписокРеквизитовДляПереноса.Добавить("ПоследующаяОценка");
		СписокТабличныхЧастейДляПереноса = Новый СписокЗначений;
		СписокТабличныхЧастейДляПереноса.Добавить("КритерииОценки");
		СписокТабличныхЧастейДляПереноса.Добавить("ЭтапыВыбора");
		РезультатФункции.Вставить("СписокРеквизитовДляПереноса",		 СписокРеквизитовДляПереноса);
		РезультатФункции.Вставить("СписокТабличныхЧастейДляПереноса",	 СписокТабличныхЧастейДляПереноса);
	ИначеЕсли ВариантЗаполненияВход = Справочники.ВариантыЗаполненияШаблонов.НастройкиПроцессаВыбораПолный Тогда
		СписокРеквизитовДляПереноса = Новый СписокЗначений;
		СписокРеквизитовДляПереноса.Добавить("ПоследнийЭтап");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаОбъекта");
		СписокРеквизитовДляПереноса.Добавить("ИмяТипаВладельца");
		СписокРеквизитовДляПереноса.Добавить("СинонимОбъекта");
		СписокРеквизитовДляПереноса.Добавить("СинонимВладельца");
		СписокРеквизитовДляПереноса.Добавить("ПоследующаяОценка");
		СписокТабличныхЧастейДляПереноса = Новый СписокЗначений;
		СписокТабличныхЧастейДляПереноса.Добавить("КритерииОценки");
		СписокТабличныхЧастейДляПереноса.Добавить("ЭтапыВыбора");
		СписокТабличныхЧастейДляПереноса.Добавить("ОценочнаяКомиссия");
		РезультатФункции.Вставить("СписокРеквизитовДляПереноса",		 СписокРеквизитовДляПереноса);
		РезультатФункции.Вставить("СписокТабличныхЧастейДляПереноса",	 СписокТабличныхЧастейДляПереноса);
	Иначе
		РезультатФункции.Вставить("СписокРеквизитовДляПереноса", Новый СписокЗначений);
		РезультатФункции.Вставить("СписокТабличныхЧастейДляПереноса", Новый СписокЗначений);
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции
