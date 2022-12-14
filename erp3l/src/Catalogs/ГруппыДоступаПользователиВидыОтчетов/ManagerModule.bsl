Функция ПроверитьВхождениеВГруппу(Ссылка,ТекПользователи) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ТекПользователи.Пользователь КАК Пользователь
	|ПОМЕСТИТЬ ТекПользователи
	|ИЗ
	|	&ТекПользователи КАК ТекПользователи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТекПользователи.Пользователь КАК Пользователь,
	|	ГруппыДоступаКПользователямПользователи.Ссылка КАК ГруппаДоступа
	|ИЗ
	|	ТекПользователи КАК ТекПользователи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступаПользователиВидыОтчетов.Пользователи КАК ГруппыДоступаКПользователямПользователи
	|		ПО ТекПользователи.Пользователь = ГруппыДоступаКПользователямПользователи.Пользователь
	|			И (НЕ ГруппыДоступаКПользователямПользователи.Ссылка = &Ссылка)"; 
	
	Запрос.УстановитьПараметр("ТекПользователи",ТекПользователи);
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	ТекстПроверки="";
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ТекстПроверки=ТекстПроверки+Символы.ПС+СтрШаблон(Нстр("ru = 'Права доступа к данным по видам отчетов пользователя %1 настраиваются в группе доступа %2'"),Результат.Пользователь,Результат.ГруппаДоступа);
	
	КонецЦикла;
	
	Возврат Сред(ТекстПроверки,2);
	
КонецФункции // ПроверитьВхождениеВГруппу()