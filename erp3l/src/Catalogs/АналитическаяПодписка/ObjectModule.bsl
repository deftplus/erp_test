// Добавляет в табличную часть ТабличастьИмяВход объекта строку
// и выставляет полю ПолеТабЧастиВход значение ЗначениеПоляВход.
// Возвращает добавленную строку.
Функция ДобавитьСтрокуТабличнойЧасти(ТабличастьИмяВход, ПолеТабЧастиВход, ЗначениеПоляВход) Экспорт
	РезультатФункции = ЭтотОбъект[ТабличастьИмяВход].Добавить();
	РезультатФункции[ПолеТабЧастиВход] = ЗначениеПоляВход;
	Возврат РезультатФункции;
КонецФункции		// ДобавитьСтрокуТабличнойЧасти()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	// Заполнение шаблона по умолчанию.
	Макет = Справочники.АналитическаяПодписка.ПолучитьМакет("ПоставляемыйМакетРассылки");
	ТекстПоУмолчанию = Макет.ПолучитьТекст();
	ТекстДок = Новый ТекстовыйДокумент;
	ТекстДок.УстановитьТекст(ТекстПоУмолчанию);
	Для Счетчик = 1 По ТекстДок.КоличествоСтрок() Цикл
		Стр = ТекстДок.ПолучитьСтроку(Счетчик); 
		ЭтотОбъект.ШаблонСообщения = ЭтотОбъект.ШаблонСообщения + Стр + "<br>";
	КонецЦикла;
	// Заполнение Рассылаемых состояний и Рассылаемых трендов.
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеСостояния", "СостояниеПоказателяМКП", Перечисления.СостоянияПоказателейМКП.Хорошее);
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеСостояния", "СостояниеПоказателяМКП", Перечисления.СостоянияПоказателейМКП.Нормальное);
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеСостояния", "СостояниеПоказателяМКП", Перечисления.СостоянияПоказателейМКП.Тревожное);
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеТренды", "ТрендПоказателяМКП", Перечисления.ТрендыПоказателейМКП.Отрицательный);
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеТренды", "ТрендПоказателяМКП", Перечисления.ТрендыПоказателейМКП.Нулевой);
	ДобавитьСтрокуТабличнойЧасти("РассылаемыеТренды", "ТрендПоказателяМКП", Перечисления.ТрендыПоказателейМКП.Положительный);
КонецПроцедуры
