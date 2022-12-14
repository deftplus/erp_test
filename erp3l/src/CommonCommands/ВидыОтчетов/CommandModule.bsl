
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ГруппаКИК = РасчетыПоКорпоративнымНалогам.ПолучитьГруппуВидовОтчетаКИК();
	
	Если Не ЗначениеЗаполнено(ГруппаКИК) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось найти группу видов отчетов КИК");
		ОткрытьФорму("Обработка.ГенерацияМоделиОтчетностиКИК.Форма.ФормаВидовОтчетов");
	Иначе
		ЗначениеОтбора = Новый Структура("Родитель", ГруппаКИК);
		ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
		ОткрытьФорму("Обработка.ГенерацияМоделиОтчетностиКИК.Форма.ФормаВидовОтчетов", ПараметрыВыбора);
	КонецЕсли;
КонецПроцедуры
