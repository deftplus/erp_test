#Область СлужебныйПрограммныйИнтерфейс


// Конструктор параметров процедуры см. РазместитьНаФормеКомандыЭДО
// 
// Возвращаемое значение:
// 	Структура - параметры:
// * Форма - ФормаКлиентскогоПриложения - форма объекта, в которой размещаются команды. 
// * МестоРазмещенияКоманд - ГруппаФормы - группа, в которой будут размещены команды. 
// * Направление - см. ОбменСКонтрагентами.НаправленияДокументов - направление, по которому из объекта могут формироваться документы.  
Функция ПараметрыРазместитьНаФормеКомандыЭДО() Экспорт
	
	Результат = Новый Структура("Форма, МестоРазмещенияКоманд, Направление");
	
	Возврат Результат;
	
КонецФункции

// Формирует подключаемые команды ЭДО.
//
// Параметры:
//  ПараметрыПриСозданииНаСервере - Структура - см. ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаДокумента.
//   
Процедура РазместитьНаФормеКомандыЭДО(ПараметрыПриСозданииНаСервере) Экспорт
	
	Форма = ПараметрыПриСозданииНаСервере.Форма;
	МестоРазмещенияКомандПоУмолчанию = ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд;
	НаправлениеЭД = ПараметрыПриСозданииНаСервере.Направление;
	
	ПодключаемыеКомандыЭДОСлужебный.РазместитьНаФормеКомандыЭДО(Форма, МестоРазмещенияКомандПоУмолчанию, НаправлениеЭД);
	
КонецПроцедуры

#КонецОбласти



