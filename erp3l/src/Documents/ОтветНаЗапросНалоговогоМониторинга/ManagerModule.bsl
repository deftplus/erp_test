#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
// Возвращает ссылку на документ Ответ на запрос данных налогового мониторинга, 
// который сопоставлен документу ДокументЗапросВход.
Функция НайтиОтветНаЗапросДанных(ДокументЗапросВход, ЗапросОтклоненВход) Экспорт
	РезультатФункции = Документы.ОтветНаЗапросНалоговогоМониторинга.ПустаяСсылка();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ОтветНаЗапросНалоговогоМониторинга.Ссылка КАК Ссылка,
		|	ОтветНаЗапросНалоговогоМониторинга.Основание КАК Основание
		|ИЗ
		|	Документ.ОтветНаЗапросНалоговогоМониторинга КАК ОтветНаЗапросНалоговогоМониторинга
		|ГДЕ
		|	ОтветНаЗапросНалоговогоМониторинга.Основание = &Основание
		|	И НЕ ОтветНаЗапросНалоговогоМониторинга.ПометкаУдаления
		|	И ОтветНаЗапросНалоговогоМониторинга.ЗапросОтклонен = &ЗапросОтклонен";
	Запрос.УстановитьПараметр("Основание", ДокументЗапросВход);
	Запрос.УстановитьПараметр("ЗапросОтклонен", ЗапросОтклоненВход);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции = ВыборкаДетальныеЗаписи.Ссылка
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции		 // НайтиОтветНаЗапросДанных()

	
#КонецЕсли	