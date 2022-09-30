
#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	//++ Локализация
	//++ НЕ УТ
	МеханизмыДокумента.Добавить("РегламентированныйУчет");
	//-- НЕ УТ
	//-- Локализация
	
КонецПроцедуры

//++ НЕ УТ

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	//++ Локализация
	
	ТекстыОтражения = Новый Массив;
	
	#Область СписаниеАвансаОтРозничногоКлиента
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание аванса от розничного клиента (Дт 76.09 :: Кт 91.01)
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	СуммыРегл.СуммаРегл КАК Сумма,
	|	ВЫБОР КОГДА Строки.ПодарочныйСертификат.Владелец.Валюта = &ВалютаУпрУчета
	|		ТОГДА Строки.СуммаВВалютеСертификата
	|		ИНАЧЕ Строки.СуммаВВалютеСертификата * КурсТекущейВалюты.Курс / КурсВалютыУпрУчета.Курс
	|	КОНЕЦ КАК СуммаУУ,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.РасчетыПоПодарочнымСертификатам) КАК ВидСчетаДт,
	|	Строки.ПодарочныйСертификат.Владелец КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	Строки.ПодарочныйСертификат.Владелец.Валюта КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПустаяСсылка) КАК СчетДт,
	|	ЗНАЧЕНИЕ(Справочник.Контрагенты.РозничныйПокупатель) КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	Строки.СуммаВВалютеСертификата КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидыСчетовРеглУчета.Доходы) КАК ВидСчетаКт,
	|	Строки.ПодарочныйСертификат.Владелец.СтатьяДоходов КАК АналитикаУчетаКт,
	|	ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка) КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеКт,
	|	Строки.ПодарочныйСертификат.Владелец.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетКт,
	|	Строки.ПодарочныйСертификат.Владелец.СтатьяДоходов КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Списание аванса от розничного клиента"" КАК Содержание
	|ИЗ 
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.АннулированиеПодарочныхСертификатов КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.АннулированиеПодарочныхСертификатов.ПодарочныеСертификаты КАК Строки
	|	ПО
	|		ДокументыКОтражению.Ссылка = Строки.Ссылка
	|		
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрНакопления.ПодарочныеСертификаты КАК СуммыРегл
	|	ПО
	|		СуммыРегл.Регистратор = Строки.Ссылка
	|		И СуммыРегл.ПодарочныйСертификат = Строки.ПодарочныйСертификат
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсВалютыУпрУчета
	|	ПО
	|		КурсВалютыУпрУчета.Валюта = &ВалютаУпрУчета
	|		И КурсВалютыУпрУчета.Дата = НАЧАЛОПЕРИОДА(Операция.Дата, День)
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		КурсыВалют КАК КурсТекущейВалюты
	|	ПО
	|		КурсТекущейВалюты.Дата = Операция.Дата
	|		И КурсТекущейВалюты.Валюта = Строки.ПодарочныйСертификат.Владелец.Валюта
	|";
	ТекстыОтражения.Добавить(ТекстЗапроса);	
	#КонецОбласти
	
	Возврат СтрСоединить(ТекстыОтражения, ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	
	//-- Локализация
	Возврат "";
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц,
// необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#КонецОбласти