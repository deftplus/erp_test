
&НаСервереБезКонтекста
Процедура ЗаполнитьПредопределенныеНаСервере()
	Справочники.РасширенияПанелиНалоговогоМониторинга.ЗаполнитьПоставляемыеДанные();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредопределенные(Команда)
	ЗаполнитьПредопределенныеНаСервере();
КонецПроцедуры
