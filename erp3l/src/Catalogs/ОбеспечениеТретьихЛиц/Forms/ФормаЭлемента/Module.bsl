
&НаКлиенте
Процедура ФормаОбеспеченияПриИзменении(Элемент)
	
	УстановитьЗаголовкиПолейФормы()

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьЗаголовкиПолейФормы()

КонецПроцедуры

&НаКлиенте
Процедура НаправлениеОбеспеченияПриИзменении(Элемент)
	
	УстановитьЗаголовкиПолейФормы()

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовкиПолейФормы()
	
	Если Объект.ФормаОбеспечения = Перечисления.ФормыОбеспеченияОбязательств.Аккредитив Тогда
		ИмяПоляКонтрагента = НСтр("ru = 'Эмитент'");
	ИначеЕсли Объект.ФормаОбеспечения = Перечисления.ФормыОбеспеченияОбязательств.БанковскаяГарантия Тогда
		ИмяПоляКонтрагента = НСтр("ru = 'Гарант'");
	ИначеЕсли Объект.ФормаОбеспечения = Перечисления.ФормыОбеспеченияОбязательств.Залог Тогда
		ИмяПоляКонтрагента = НСтр("ru = 'Залогодатель'");
	ИначеЕсли Объект.ФормаОбеспечения = Перечисления.ФормыОбеспеченияОбязательств.Поручительство Тогда
		ИмяПоляКонтрагента = НСтр("ru = 'Поручитель'");
	Иначе
		ИмяПоляКонтрагента = НСтр("ru = 'Контрагент'");
	КонецЕсли;
	
	Элементы.Контрагент.Заголовок = ИмяПоляКонтрагента;
	
	Если Объект.НаправлениеОбеспечения = Перечисления.НаправленияПредоставленияОбеспечения.Полученное Тогда
		Элементы.Бенефициар.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
	Иначе
		
		Элементы.Бенефициар.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		
	КонецЕсли;
	
КонецПроцедуры
