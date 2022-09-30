// Функции для отчета АнализИсполненияПрограммыЗакупок

Функция ПлановаяДлительностьЗакупкиПоОрганизацииИНоменклатуре(ДатаПроверки, СпособВыбораПоставщика, Организация, Номенклатура, Переторжка = Ложь) экспорт
	
	//
	ТребуетсяАкредитация = АнализИсполненияПрограммыЗакупокПовтИсп.НоменклатураТребуетАккредитацииПоставщиков(ДатаПроверки, Организация, Номенклатура);
	Возврат АнализИсполненияПрограммыЗакупокПовтИсп.ПолучитьПлановуюДлительностьЗакупки(СпособВыбораПоставщика, ТребуетсяАкредитация, Переторжка);
	
КонецФункции

Функция НоменклатураТребуетАккредитацииПоставщиков(ДатаПроверки, Организация, Номенклатура) экспорт
	
	Возврат  АккредитацияПоставщиковУХ.НоменклатураТребуетАккредитацииПоставщиков(ДатаПроверки, Организация, Номенклатура);	
	
КонецФункции

Функция ПолучитьПлановуюДлительностьЗакупки(СпособВыбораПоставщика, ТребуетсяАкредитация, Переторжка=Ложь) экспорт
	
	Возврат МероприятияВыборПоставщиков.ПолучитьПлановуюДлительностьЗакупки(СпособВыбораПоставщика, Переторжка, ТребуетсяАкредитация);
	
КонецФункции