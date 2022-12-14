
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Считывание переданных параметров.
	СозданиеШаблона			 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "СозданиеШаблона", Ложь);
	НаименованиеШаблона		 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "НаименованиеШаблона", "");
	ОбъектРодитель			 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ОбъектРодитель", Неопределено);
	СписокРеквизитов		 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "СписокРеквизитов", Новый СписокЗначений);
	СписокТабличныхЧастей	 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "СписокТабличныхЧастей", Новый СписокЗначений);
	Если ЭтоАдресВременногоХранилища(ОбъектРодитель) Тогда
		ОбъектРодитель = ПолучитьИзВременногоХранилища(ОбъектРодитель);
	Иначе
		// Не требуется получать объект.
	КонецЕсли;
	// Создание шаблона на основании переданных параметров.
	Если СозданиеШаблона Тогда
		Если ЗначениеЗаполнено(НаименованиеШаблона) Тогда
			НаименованиеШаблонаРабочий = НаименованиеШаблона;
		Иначе
			НаименованиеШаблонаРабочий = Справочники.ШаблоныЗаполнения.ПолучитьНаименованиеШаблонаПоУмолчанию(ОбъектРодитель.Ссылка);
		КонецЕсли;
		ОбъектШаблона = РеквизитФормыВЗначение("Объект");
		ОбъектШаблона.ЗаполнитьИзОбъекта(НаименованиеШаблонаРабочий, ОбъектРодитель);
		ЗначениеВРеквизитФормы(ОбъектШаблона, "Объект");
		ЭтаФорма.Модифицированность = Истина;
	Иначе
		// Не требуется заполнение данных формы.
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Для существующих шаблонов откроем специализированную форму.
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		НазначениеСправочник = (Объект.Назначение = ПредопределенноеЗначение("Перечисление.НазначенияШаблонов.Справочник"));
		ЭтоШаблонЛота						 = (НазначениеСправочник И Объект.ИмяРодителя = "Лоты");
		ЭтоШаблонНастройкиПроцессаВыбора	 = (НазначениеСправочник И Объект.ИмяРодителя = "НастройкиПроцессаВыбора");
		Если ЭтоШаблонЛота Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Ключ", Объект.Ссылка);
			ОткрытьФорму("Справочник.ШаблоныЗаполнения.Форма.ФормаПомощникВводаШаблонаЛота", ПараметрыФормы);
			ЭтаФорма.Закрыть();
		ИначеЕсли ЭтоШаблонНастройкиПроцессаВыбора Тогда
			Форма = ПолучитьФорму("Справочник.НастройкиПроцессаВыбора.Форма.ФормаЭлемента");
			Форма.ТолькоПросмотр = Истина;
			Форма.КоманднаяПанель.Доступность = Ложь;
			Форма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
			УправлениеШаблонамиЗаполненияКлиентУХ.ЗаполнитьФормуПоШаблону(Форма, Объект);
			Форма.Открыть();
			ЭтаФорма.Закрыть();
		Иначе
			// Неизвестный вариант, оставляем стандартную форму.
		КонецЕсли;
	Иначе
		// Новый объект.
	КонецЕсли;
КонецПроцедуры
