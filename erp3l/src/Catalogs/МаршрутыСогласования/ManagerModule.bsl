
Функция ЕстьЭтапыСогласования(МаршрутСогласования) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЭтапыСогласования.Ссылка
	|ИЗ
	|	Справочник.ЭтапыСогласования КАК ЭтапыСогласования
	|ГДЕ
	|	ЭтапыСогласования.Владелец = &МаршрутСогласования";
	Запрос.УстановитьПараметр("МаршрутСогласования", МаршрутСогласования);
	ЕстьЭтапы = НЕ Запрос.Выполнить().Пустой();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЕстьЭтапы;
	
КонецФункции