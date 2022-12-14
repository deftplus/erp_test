
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Предназначение = Параметры.Предназначение;
	СтатьяБюджета = Параметры.СтатьяБюджета;
	
	Если ЗначениеЗаполнено(Предназначение) Тогда
		ЭтоБДДС = Предназначение = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
		ЭтоБДР = Предназначение = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДоходовИРасходов;
		ЭтоБЗ = Предназначение = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияРесурсов;
	КонецЕсли;
	
	Если НЕ ЭтоБДДС И НЕ ЭтоБДР И НЕ ЭтоБЗ Тогда
		Предназначение = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияДенежныхСредств;
		ЭтоБДДС = Истина;
	КонецЕсли;
	
	Если ЭтоБДДС Тогда
		СправочникСтатья = "СтатьиДвиженияДенежныхСредств";
		РеквизитСтатья 	 = "СтатьяДвиженияДенежныхСредств";
	ИначеЕсли ЭтоБДР Тогда
		СправочникСтатья = "СтатьиДоходовИРасходов";
		РеквизитСтатья 	 = "СтатьяДоходовИРасходов";
	Иначе
		СправочникСтатья = "СтатьиДвиженияРесурсов";
		РеквизитСтатья 	 = "СтатьяДвиженияРесурсов";
	КонецЕсли;
	
	Заголовок = Метаданные.Справочники[СправочникСтатья].Синоним;
	
	ИзменитьСвойстваДинамическогоСписка();
	
	Если ЗначениеЗаполнено(Параметры.СтатьяБюджета) Тогда
		Элементы.СписокСтатей.ТекущаяСтрока = Параметры.СтатьяБюджета;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокСтатейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элементы.СписокСтатей.ВыделенныеСтроки.Количество()=0 Тогда
		Возврат;
	Иначе
		ОповеститьОВыборе(Элементы.СписокСтатей.ВыделенныеСтроки[0]);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИзменитьСвойстваДинамическогоСписка()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СтатьиБюджета.Ссылка КАК Ссылка,
	|	СтатьиБюджета.ВидАналитики1 КАК ВидАналитики1,
	|	СтатьиБюджета.ВидАналитики2 КАК ВидАналитики2,
	|	СтатьиБюджета.ВидАналитики3 КАК ВидАналитики3,
	|	СтатьиБюджета.ВидАналитики4 КАК ВидАналитики4,
	|	СтатьиБюджета.ВидАналитики5 КАК ВидАналитики5,
	|	СтатьиБюджета.ВидАналитики6 КАК ВидАналитики6,
	|	ДанныеПоСтрокамОтчетов.СтрокаОтчета.Владелец КАК ВидОтчета,
	|	ЕСТЬNULL(ДанныеПоСтрокамОтчетов.ИспользованаВСтроках, 0) КАК ИспользованаВСтроках,
	|	ДанныеПоСтрокамОтчетов.СтрокаОтчета КАК СтрокаОтчета,
	|	ДанныеПоСтрокамОтчетов.СтрокаОтчета.Предназначение КАК Предназначение,
	|	ДанныеПоСтрокамОтчетов.СтрокаОтчета.ГруппаРаскрытия КАК ГруппаРаскрытия
	|ИЗ
	|	Справочник.СтатьиДвиженияДенежныхСредств КАК СтатьиБюджета
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СтрокиОтчетов.СтатьяДвиженияДенежныхСредств КАК СтатьяБюджета,
	|			МАКСИМУМ(СтрокиОтчетов.Ссылка) КАК СтрокаОтчета,
	|			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтрокиОтчетов.Ссылка) КАК ИспользованаВСтроках
	|		ИЗ
	|			Справочник.СтрокиОтчетов КАК СтрокиОтчетов
	|		ГДЕ
	|			НЕ СтрокиОтчетов.ПометкаУдаления
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СтрокиОтчетов.СтатьяДвиженияДенежныхСредств) КАК ДанныеПоСтрокамОтчетов
	|		ПО СтатьиБюджета.Ссылка = ДанныеПоСтрокамОтчетов.СтатьяБюджета";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник.СтатьиДвиженияДенежныхСредств", "Справочник."+СправочникСтатья);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "СтрокиОтчетов.СтатьяДвиженияДенежныхСредств", "СтрокиОтчетов."+РеквизитСтатья);
	
	ПараметрыДинамическогоСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	ПараметрыДинамическогоСписка.ТекстЗапроса = ТекстЗапроса;
	ПараметрыДинамическогоСписка.ОсновнаяТаблица = "Справочник."+СправочникСтатья;
	ПараметрыДинамическогоСписка.ДинамическоеСчитываниеДанных = Истина;
	
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.СписокСтатей, ПараметрыДинамическогоСписка);
	
КонецПроцедуры

#КонецОбласти

