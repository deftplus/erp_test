
&НаКлиенте
Процедура ПериодичностьОтчетностиМСФОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Периодичность.Месяц"));
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Периодичность.Квартал"));
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие"));
	ДанныеВыбора.Добавить(ПредопределенноеЗначение("Перечисление.Периодичность.Год"));
	СтандартнаяОбработка = Ложь;
КонецПроцедуры
