#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
//
Функция ВидЗначенияВГОДляСпособаЭлиминации(СпособЭлиминации) Экспорт
	Если НЕ ЗначениеЗаполнено(СпособЭлиминации) Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ПустаяСсылка();
	КонецЕсли;
	
	Если СпособЭлиминации = Перечисления.СпособыЭлиминации.ЭлиминацияЗапасов Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ОборотЗаПериод;
	ИначеЕсли СпособЭлиминации = Перечисления.СпособыЭлиминации.НеЭлиминировать Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ОборотЗаПериод;
	ИначеЕсли СпособЭлиминации = Перечисления.СпособыЭлиминации.ЭлиминацияОСиНМА Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ОборотЗаПериод;
	ИначеЕсли СпособЭлиминации = Перечисления.СпособыЭлиминации.ЭлиминацияСтатейБаланса Тогда
		Возврат Перечисления.ВидыЗначенийВГО.СальдоКонечное;
	ИначеЕсли СпособЭлиминации = Перечисления.СпособыЭлиминации.ЭлиминацияУслуг Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ОборотЗаПериод;
	ИначеЕсли СпособЭлиминации = Перечисления.СпособыЭлиминации.ЭлиминацияПоказателейОтчетов Тогда
		Возврат Перечисления.ВидыЗначенийВГО.ОборотЗаПериод;
	КонецЕсли;
	
	Возврат Перечисления.ВидыЗначенийВГО.ПустаяСсылка();
КонецФункции

	
#КонецЕсли