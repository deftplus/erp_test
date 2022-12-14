
Функция ОбъектыТранслита() Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СправочникиБД.ИмяОбъектаМетаданных КАК Имя
	|ИЗ
	|	Справочник.СправочникиБД КАК СправочникиБД
	|ГДЕ
	|	СправочникиБД.ИспользоватьТранслит");
		
	Результат = Новый Массив; 
	Выборка = Запрос.Выполнить().Выбрать();	
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Тип("СправочникОбъект." + Выборка.Имя));
	КонецЦикла; 

	Возврат Результат;
	
КонецФункции

Функция ТребуетсяТранслит(ПустаяСсылка) Экспорт 

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СправочникиБД.Наименование КАК Имя
	|ИЗ
	|	Справочник.СправочникиБД КАК СправочникиБД
	|ГДЕ
	|	СправочникиБД.ИспользоватьТранслит 
	|	И СправочникиБД.Наименование = &ИмяОбъекта");
	Запрос.УстановитьПараметр("ИмяОбъекта", Метаданные.НайтиПоТипу(ТипЗнч(ПустаяСсылка)).Имя);
		
	Возврат Не Запрос.Выполнить().Пустой();	
	
КонецФункции

Функция ПолучитьКодыЯзыков() Экспорт

	Результат = Новый Соответствие;
	
	Языки = Константы.ДополнительныеЯзыкиВыводаОтчета.Получить().Получить();
	Если Языки <> Неопределено Тогда		
		Для каждого ТекущийЯзык Из Языки Цикл	
			Результат.Вставить(ТекущийЯзык.ПорядковыйНомер, ТекущийЯзык.КодЯзыка);	
		КонецЦикла;	
	КонецЕсли;
	
	Возврат Новый ФиксированноеСоответствие(Результат);

КонецФункции

Функция НомерЯзыкаОтчетности() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Возврат ПараметрыСеанса.ЯзыкОтчетности;
КонецФункции
