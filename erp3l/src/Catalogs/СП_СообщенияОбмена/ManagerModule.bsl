Функция ОпределитьSubtype(сообщение) Экспорт
	
	текстJSON = Сообщение.ТелоСообщения;
	текстJSON = стрЗаменить(текстJSON, """subtype"":", """subtype"":" + Символы.ПС);
	ВтораяСтрока = "";
	Попытка
		ВтораяПодстрока = стрПолучитьСтроку(текстJSON, 2);
		МассивРазделенныхЧастейВторойПодстроки = стрРазделить(ВтораяПодстрока, ",{}[] ", ложь);
		ЗначениеSubtype = МассивРазделенныхЧастейВторойПодстроки[0];
		ЗначениеSubtype = сокрЛП(стрЗаменить(ЗначениеSubtype, """", ""));
		
		возврат(ЗначениеSubtype);
	Исключение
		возврат("");
	КонецПопытки;
	
КонецФункции