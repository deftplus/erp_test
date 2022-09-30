
Функция ПолучитьТекстСправки(ПеречислениеСсылка) Экспорт
	
	СтрокаРезультат = "";
	Если ПеречислениеСсылка = Перечисления.КодыПлательщикаБанковскойКомиссии.BEN Тогда
		СтрокаРезультат = НСтр("ru = 'Получатель оплачивает все расходы'");
	ИначеЕсли ПеречислениеСсылка = Перечисления.КодыПлательщикаБанковскойКомиссии.OUR Тогда
		СтрокаРезультат = НСтр("ru = 'Плательщик оплачивает все расходы'");
	ИначеЕсли ПеречислениеСсылка = Перечисления.КодыПлательщикаБанковскойКомиссии.SHA Тогда
		СтрокаРезультат = НСтр("ru = 'Плательщик оплачивает комиссию банка-отправителя, получатель - прочие расходы'");
	КонецЕсли;
	
	Возврат СтрокаРезультат;
	
КонецФункции