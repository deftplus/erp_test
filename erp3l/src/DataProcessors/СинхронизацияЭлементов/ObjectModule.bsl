Перем ОбновлятьЭталонныеЭлементы Экспорт;

Процедура ВыполнитьСинхронизациюЭлементов() Экспорт
	
	////////////////////////////////////////////////////////////////
	// Определим параметры объекта метаданных
	
	Если ТипОбъектаКонсолидации="Справочник" Тогда
		
		ОбъектМетаДанных = МетаДанные.Справочники[ИмяОбъектаМетаданных];
								
	ИначеЕсли ТипОбъектаКонсолидации="ВидСубконто" Тогда
		
		ОбъектМетаДанных = ОбщегоНазначенияУХ.ПолучитьСправочникПоВидуСубконто(ИмяОбъектаМетаданных);
 		
	КонецЕсли;
	
	Иерархический=ОбъектМетаДанных.Иерархический И ОбъектМетаДанных.ВидИерархии=Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов; 
	ТаблицаАналитики="Справочник."+ОбъектМетаДанных.Имя;
	ОтборПоВладельцу=(ОбъектМетаДанных.Владельцы.Количество()>0);
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	СоответствиеВнешнимИБ.СоответствиеРеквизитов.(
	|		РеквизитОбъектаКонсолидации,
	|		РеквизитОбъектаВнешнейИБ,
	|		НеИспользоватьДляСинхронизации
	|	) КАК СоответствиеРеквизитов,
	|	СоответствиеВнешнимИБ.Владелец
	|ИЗ
	|	Справочник.СоответствиеВнешнимИБ КАК СоответствиеВнешнимИБ
	|ГДЕ
	|	СоответствиеВнешнимИБ.ИмяОбъектаМетаданных = &ИмяОбъектаМетаданных
	|	И СоответствиеВнешнимИБ.ТипОбъектаКонсолидации = &ТипОбъектаКонсолидации";
	
	Запрос.УстановитьПараметр("ИмяОбъектаМетаданных",ИмяОбъектаМетаданных);
	Запрос.УстановитьПараметр("ТипОбъектаКонсолидации",ТипОбъектаКонсолидации);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ТекстРеквизиты="";
		ТекстСоединение="";
		
		РеквизитыСинхронизации=Результат.СоответствиеРеквизитов.Выбрать();
		
		Пока РеквизитыСинхронизации.Следующий() Цикл
			
			Если РеквизитыСинхронизации.НеИспользоватьДляСинхронизации Тогда
				Продолжить;
			КонецЕсли;
			
			ТекстРеквизиты=ТекстРеквизиты+"
			|ТаблицаАналитики."+РеквизитыСинхронизации.РеквизитОбъектаКонсолидации+" КАК "+РеквизитыСинхронизации.РеквизитОбъектаКонсолидации+",";
			
			ТекстСоединение=ТекстСоединение+" И ЭталонныеЭлементы."+РеквизитыСинхронизации.РеквизитОбъектаКонсолидации+" = ЭлементыДляСинхронизации."+РеквизитыСинхронизации.РеквизитОбъектаКонсолидации;
			
		КонецЦикла;
		
		Если ОтборПоВладельцу Тогда
			
			ТекстРеквизиты=ТекстРеквизиты+"
			|ТаблицаАналитики.Владелец КАК Владелец,";
			
			ТекстСоединение=ТекстСоединение+" И ЭталонныеЭлементы.Владелец = ЭлементыДляСинхронизации.Владелец";
			
		КонецЕсли;
				
		ЗапросРеквизиты=Новый Запрос;
		ЗапросРеквизиты.Текст="ВЫБРАТЬ
		|	ЭталонныеЭлементы.Ссылка КАК ЭталонныйЭлемент,
		|	ЭлементыДляСинхронизации.Ссылка КАК ЭлементВИБ
		|ИЗ
		|	(ВЫБРАТЬ"+ТекстРеквизиты+"
		|		ТаблицаАналитики.Ссылка КАК Ссылка
		|	ИЗ
		|		"+ТаблицаАналитики+" КАК ТаблицаАналитики
		|	ГДЕ
		|		(НЕ ТаблицаАналитики.НСИ_НеАктивный)
		|		И (НЕ ТаблицаАналитики.ПометкаУдаления)";
		
		Если ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
			
			ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
			|И ТаблицаАналитики.Владелец=&Владелец";
			
			Запрос.УстановитьПараметр("Владелец",ИмяОбъектаМетаданных);
			
		КонецЕсли;
		
		Если Иерархический Тогда
			
			ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
			|И (НЕ ТаблицаАналитики.ЭтоГруппа)";
			
		КонецЕсли;
				
		ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
		|		И (НЕ ТаблицаАналитики.НСИ_ТребуетСинхронизации)) КАК ЭталонныеЭлементы
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ"+ТекстРеквизиты+"
		|			ТаблицаАналитики.Ссылка КАК Ссылка
		|		ИЗ
		|			"+ТаблицаАналитики+" КАК ТаблицаАналитики
		|	ГДЕ
		|		(НЕ ТаблицаАналитики.ПометкаУдаления)";
		
		Если ТаблицаАналитики="Справочник.ПроизвольныйКлассификаторУХ" Тогда
			
			ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
			|И ТаблицаАналитики.Владелец=&Владелец";
						
		КонецЕсли;
		
		Если Иерархический Тогда
			
			ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
			|И (НЕ ТаблицаАналитики.ЭтоГруппа)";
			
		КонецЕсли;
		
		Если НЕ ОбновлятьЭталонныеЭлементы Тогда
			
			ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
			|И ТаблицаАналитики.НСИ_ЭталонныйЭлемент=ЗНАЧЕНИЕ("+ТаблицаАналитики+".ПустаяСсылка)";
			
		КонецЕсли;
	
		ЗапросРеквизиты.Текст=ЗапросРеквизиты.Текст+"
		|			И ТаблицаАналитики.НСИ_ТребуетСинхронизации
		|			И ТаблицаАналитики.НСИ_ВИБ.ТипБД = &ТипВИБ) КАК ЭлементыДляСинхронизации
		|		ПО "+Сред(ТекстСоединение,3)+"
		|ИТОГИ ПО
		|	ЭталонныйЭлемент,
		|	ЭлементВИБ";
		
		ЗапросРеквизиты.УстановитьПараметр("ТипВИБ",Результат.Владелец);
		
		ВыборкаЭталон=ЗапросРеквизиты.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"ЭталонныйЭлемент");
		
		Пока ВыборкаЭталон.Следующий() Цикл
			
			ТекЭталон=ВыборкаЭталон.ЭталонныйЭлемент;
			
			ВыборкаВИБ=ВыборкаЭталон.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам,"ЭлементВИБ");
			
			Пока ВыборкаВИБ.Следующий() Цикл
				
				Если НЕ ВыборкаВИБ.ЭлементВИБ=NULL Тогда
					
					СправочникОбъект=ВыборкаВИБ.ЭлементВИБ.ПолучитьОбъект();
					СправочникОбъект.НСИ_ЭталонныйЭлемент=ТекЭталон;
					СправочникОбъект.ОбменДанными.Загрузка=Истина;
					
					Попытка
						
						СправочникОбъект.Записать();
						
					Исключение
						
						ОбщегоНазначенияУХ.СообщитьОбОшибке(СтрШаблон(Нстр("ru = 'Не удалось записать объект %1:
						|%2'"), ВыборкаВИБ.ЭлементВИБ, ОписаниеОшибки()),,,СтатусСообщения.Внимание);
						
					КонецПопытки;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;	
	
КонецПроцедуры // ВыполнитьСинхронизациюЭлементов() 


ОбновлятьЭталонныеЭлементы=Ложь;