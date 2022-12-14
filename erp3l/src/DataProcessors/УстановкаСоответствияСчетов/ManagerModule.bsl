
Функция ПолучитьДанныеШаблона(ШаблонТрансляции) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ШаблоныТрансляций.ПланСчетовИсточник,
	|	ШаблоныТрансляций.ПланСчетовПриемник,
	|	ШаблоныТрансляций.РегистрБухгалтерииИсточник,
	|	ШаблоныТрансляций.РегистрБухгалтерииПриемник,
	|	ШаблоныТрансляций.ПланСчетовИсточник.Владелец КАК ТипБД,
	|	ШаблоныТрансляций.НаправлениеТрансляции,
	|	ШаблоныТрансляций.ВидОтчетаОСВИсточник,
	|	ШаблоныТрансляций.ВидОтчетаОСВПриемник,
	|	ВЫБОР
	|		КОГДА (ШаблоныТрансляций.НаправлениеТрансляции = ЗНАЧЕНИЕ(Перечисление.НаправленияТрансляцииДанных.ПоказателиВПоказатели)
	|				ИЛИ ШаблоныТрансляций.НаправлениеТрансляции = ЗНАЧЕНИЕ(Перечисление.НаправленияТрансляцииДанных.РегистрБухгалтерииВПоказатели))
	|				И ШаблоныТрансляций.ВидОтчетаОСВПриемник.СокращеннаяОСВ
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК СокращеннаяОСВ
	|ИЗ
	|	Справочник.ШаблоныТрансляций КАК ШаблоныТрансляций
	|ГДЕ
	|	ШаблоныТрансляций.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка",ШаблонТрансляции);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Результат.Следующий();
	
	СтруктураПараметров=Новый Структура("ПланСчетовИсточник,ПланСчетовПриемник,РегистрБухгалтерииИсточник,РегистрБухгалтерииПриемник,ВидОтчетаОСВИсточник,ВидОтчетаОСВПриемник,ТипБД,НаправлениеТрансляции,СокращеннаяОСВ");
	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров,Результат);
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	МАКСИМУМ(СоответствияСчетовДляТрансляции.ИдентификаторСоответствия) КАК ИдентификаторСоответствия
	|ИЗ
	|	Справочник.СоответствияСчетовДляТрансляции КАК СоответствияСчетовДляТрансляции
	|ГДЕ
	|	СоответствияСчетовДляТрансляции.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец",ШаблонТрансляции);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ТекущийИдентификатор=Результат.ИдентификаторСоответствия;
		
	Иначе
		
		ТекущийИдентификатор=0;
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ТекущийИдентификатор",ТекущийИдентификатор);
	
	Возврат СтруктураПараметров;
		
КонецФункции // ПолучитьСписокНаправленийТрансляции()