#Область ПрограммныйИнтерфейс

// Функция - Порядок учета убытков прошлых лет
// 
// Возвращаемое значение:
//  Структура
//
Функция ПорядокУчетаУбытковПрошлыхЛет() Экспорт
	
	// Учет убытков прошлых лет для целей налогообложения устроен совсем не так, как это следует из правил бухгалтерского учета.
	// А именно убытки прошлых лет к переносу на будущие годы отражаются по дебету счета 97 по статьям РБП специального вида.
	// При этом год получения убытка зашифрован в периоде списания расхода - это год, предшествующий году начала списания.
	//
	// В бухгалтерском учете накопленный убыток отражается на счете 84.02.
	// При этом в программе бухгалтерский учет убытка ведется сводно, а не по годам возникновения.
	// 
	// Поэтому здесь учитываются только суммы, отраженные по виду учета НУ.
	
	ПорядокУчета = Новый Структура;
	ПорядокУчета.Вставить("СчетУчетаУбытков",          ПланыСчетов.Хозрасчетный.УбыткиПрошлыхЛет);
	ПорядокУчета.Вставить("СчетаУчетаУбытков",         БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПорядокУчета.СчетУчетаУбытков));
	ПорядокУчета.Вставить("СчетУчетаПрибыли",          ПланыСчетов.Хозрасчетный.ПрибылиИУбыткиНеЕНВД);
	ПорядокУчета.Вставить("ВидСтатьиРБП",              Перечисления.ВидыРБП.УбыткиПрошлыхЛет);
	ПорядокУчета.Вставить("ПредставлениеСчетаУбытков", Строка(ПорядокУчета.СчетУчетаУбытков));
	ПорядокУчета.Вставить("ПредставлениеСчетаПрибыли", Строка(ПорядокУчета.СчетУчетаПрибыли));
	ПорядокУчета.Вставить("ПредставлениеВидаСтатьи",   Строка(ПорядокУчета.ВидСтатьиРБП));
	
	Возврат ПорядокУчета;
	
КонецФункции

// Функция - Убыток перенесенный на будущее
//
// Параметры:
//  НачалоПериода	 - Дата - начало отчетного периода
//  КонецПериода	 - Дата - конец отчетного периода
//  Организации		 - Массив, ФиксированныйМассив из СправочникСсылка.Организации
// 
// Возвращаемое значение:
//  Число - сумма убытка по НУ, перенесенная на будущий период
//
Функция УбытокПеренесенныйНаБудущее(НачалоПериода, КонецПериода, Организации) Экспорт
	
	ПорядокУчета = ПорядокУчетаУбытковПрошлыхЛет();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода",     НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",      КонецПериода);
	Запрос.УстановитьПараметр("Организации",       Организации);
	Запрос.УстановитьПараметр("СчетУчетаПрибыли",  ПорядокУчета.СчетУчетаПрибыли);
	Запрос.УстановитьПараметр("СчетаУчетаУбытков", ПорядокУчета.СчетаУчетаУбытков);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПереносУбытка.СубконтоДт1 КАК СтатьяУбытка,
	|	СУММА(ПереносУбытка.СуммаНУОборотДт) КАК СуммаНУ
	|ПОМЕСТИТЬ СуммыУбытка
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.ОборотыДтКт(&НачалоПериода, &КонецПериода, , СчетДт В (&СчетаУчетаУбытков), ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.РасходыБудущихПериодов), СчетКт = &СчетУчетаПрибыли, , Организация В (&Организации)) КАК ПереносУбытка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПереносУбытка.СубконтоДт1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(СУММА(СуммыУбытка.СуммаНУ), 0) КАК СуммаНУ
	|ИЗ
	|	СуммыУбытка КАК СуммыУбытка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УбыткиПрошлыхЛет КАК УбыткиПрошлыхЛет
	|		ПО СуммыУбытка.СтатьяУбытка = УбыткиПрошлыхЛет.Ссылка
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий(); // ровно одна запись
	
	Возврат Выборка.СуммаНУ;
	
КонецФункции

#КонецОбласти