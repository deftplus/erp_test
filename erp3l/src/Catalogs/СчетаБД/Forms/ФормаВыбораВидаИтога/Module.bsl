
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	СчетаБД.Ссылка КАК Счет,
	|	СчетаБД.Код КАК КодСчета,
	|	"""" КАК СНД,
	|	"""" КАК СНК,
	|	"""" КАК ДО,
	|	"""" КАК КО,
	|	"""" КАК СКК,
	|	"""" КАК СКД,
	|	СчетаБД.Наименование КАК НаименованиеСчета
	|ИЗ
	|	Справочник.СчетаБД КАК СчетаБД
	|ГДЕ
	|	СчетаБД.Владелец = &ПланСчетов
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодСчета ИЕРАРХИЯ";
	
	Запрос.УстановитьПараметр("ПланСчетов",Параметры.ПланСчетов);
	
	ЗначениеВРеквизитФормы(Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией),"ТаблицаОСВ");
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОСВВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя="КодСчета" Тогда
		
		ТекстИтога=СокрЛП(Элементы.ТаблицаОСВ.ТекущиеДанные.КодСчета);
		
	Иначе
		
		ТекстИтога=Поле.Имя+СокрЛП(Элементы.ТаблицаОСВ.ТекущиеДанные.КодСчета);
		
	КонецЕсли;
	
	Оповестить("ВыбранИтогПоСчету",ТекстИтога);
	
	Закрыть();
			
КонецПроцедуры
