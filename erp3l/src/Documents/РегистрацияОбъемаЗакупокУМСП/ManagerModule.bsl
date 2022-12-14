#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
#Область ОбщийПрограмныйИнтерфейс


// Возвращает классификатор показателей первого уровня.
//
// Параметры:
//  Версия - Строка(10) - версия классификатора. Если Неопределено, то
//		возвращает последнюю версию. См. функцию КодПоследнейВерсииКлассификатора.
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьКлассификаторПоказателей(Версия=Неопределено) Экспорт
	Если Версия = "20191209" Тогда
		Возврат ПолучитьКлассификаторПоказателейВерсия20191209();
	ИначеЕсли Версия = "20161214" Тогда
		Возврат ПолучитьКлассификаторПоказателейВерсия20161214();
	КонецЕсли;
	Возврат ПолучитьКлассификаторПоказателей(КодПоследнейВерсииКлассификатора());
КонецФункции

// Возвращает код последней версии классификатора
Функция КодПоследнейВерсииКлассификатора() Экспорт
	Возврат "20191209";
КонецФункции

// Возвращает разделитель, используемый в именах областей
// табличного документа. Он разделяет код и вид ресурса
// показателя.
//
Функция ПолучитьРазделительКодаИИмениРесурса() Экспорт
	Возврат "__";
КонецФункции


#КонецОбласти


#Область ВнутреннийПрограммныйИнтерфейс


Функция ПолучитьКлассификаторПоказателейВерсия20191209()
	Классификатор = Новый Массив;
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"1", НСтр("ru='Всего заключено договоров по результатам закупок" + Символы.ПС + "из них:'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"2", НСтр("ru='Всего заключено договоров за вычетом договоров, заключенных по результатам закупок, указанных в абзацах третьем - двадцать девятом позиции 1 настоящей формы, не включающих договоры, заключенные поставщиками (исполнителями, подрядчиками) непосредственно с субъектами малого и среднего предпринимательства в целях исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"3", НСтр("ru='Всего заключено договоров с субъектами малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, утвержденным заказчиком в соответствии с Федеральным законом ""О закупках товаров, работ, услуг отдельными видами юридических лиц"" (далее - положение о закупке), участниками которых являются любые лица, указанные в части 5 статьи 3 Федерального закона ""О закупках товаров, работ, услуг отдельными видами юридических лиц"", в том числе субъекты малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"4", НСтр("ru='Всего заключено договоров с субъектами малого предпринимательства (в том числе с субъектами малого предпринимательства, относящимися к микропредприятиям) по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, участниками которых являются любые лица, указанные в части 5 статьи 3 Федерального закона ""О закупках товаров, работ, услуг отдельными видами юридических лиц"", в том числе субъекты малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"5", НСтр("ru='Всего заключено договоров с субъектами малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"6", НСтр("ru='Всего заключено договоров с субъектами малого предпринимательства (в том числе с субъектами малого предпринимательства, относящимися к микропредприятиям) по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"7", НСтр("ru='Всего заключено договоров непосредственно с субъектами малого и среднего предпринимательства для целей исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается ребование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"8", НСтр("ru='Всего заключено договоров непосредственно с субъектами малого предпринимательства (в том числе с субъектами малого предпринимательства, относящимися к микропредприятиям) для целей исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"9", НСтр("ru='Всего заключено договоров непосредственно с субъектами малого и среднего предпринимательства в целях исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства (по результатам закупок, указанных в абзаце двадцать седьмом позиции 1 настоящей формы)""'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"10", НСтр("ru='Всего заключено договоров непосредственно с субъектами малого предпринимательства (в том числе с субъектами малого предпринимательства, относящимися к микропредприятиям) в целях исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства (по результатам закупок, указанных в абзаце двадцать седьмом позиции 1 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"11", НСтр("ru='Годовой объем закупок у субъектов малого и среднего предпринимательства (рассчитывается как отношение суммы показателей, указанных в графе 5 позиций 3, 5, 7 и 9 настоящей формы, к показателю, указанному в графе 5 позиции 2 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"12", НСтр("ru='Годовой объем закупок у субъектов малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего предпринимательства (рассчитывается как отношение показателя, указанного в графе 5 позиции 5 настоящей формы, к показателю, указанному в графе 5 позиции 2 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"13", НСтр("ru='Годовой объем закупок у субъектов малого предпринимательства (рассчитывается как отношение суммы показателей, указанных в графе 5 позиций 4, 6, 8 и 10 настоящей формы, к показателю, указанному в графе 5 позиции 2 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"14", НСтр("ru='Годовой объем закупок у субъектов малого предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего предпринимательства (рассчитывается как отношение показателя, указанного в графе 5 позиции 6 настоящей формы, к показателю, указанному в графе 5 позиции 2 настоящей формы)'")));
	Возврат Классификатор;
КонецФункции

Функция СоздатьЗначениеКлассификатора(Код, Наименование)
	Значение = Новый Структура(
		"Код, Наименование",
		 Код, Наименование);
	Возврат Значение;
КонецФункции

Функция ПолучитьКлассификаторПоказателейВерсия20161214()
	Классификатор = Новый Массив;
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"1", НСтр("ru='Всего заключено договоров по результатам закупок" + Символы.ПС + "из них:'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"2", НСтр("ru='Всего заключено договоров по результатам закупок (за вычетом договоров, заключенных по результатам закупок, указанных в позиции 1 настоящей формы, не включающих договоры, заключенные поставщиками (исполнителями, подрядчиками) непосредственно с субъектами малого и среднего предпринимательства в целях исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства в соответствии с абзацем двадцать седьмым позиции 1 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"3", НСтр("ru='Всего заключено договоров с субъектами малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, утвержденным заказчиком в соответствии с Федеральным законом ""О закупках товаров, работ, услуг отдельными видами юридических лиц"" (далее - положение о закупке), участниками которых являются любые лица, указанные в части 5 статьи 5 Федерального закона ""О закупках товаров, работ, услуг отдельными видами юридических лиц"", в том числе субъекты малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"4", НСтр("ru='Всего заключено договоров с субъектами малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"5", НСтр("ru='Всего договоров, заключенных поставщиками (исполнителями, подрядчиками) непосредственно с субъектами малого и среднего предпринимательства для целей исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"6", НСтр("ru='Всего договоров, заключенных поставщиками (исполнителями, подрядчиками) непосредственно с субъектами малого и среднего предпринимательства в целях исполнения договоров, заключенных с заказчиком по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в отношении участников которых заказчиком устанавливается требование о привлечении к исполнению договора субподрядчиков (соисполнителей) из числа субъектов малого и среднего предпринимательства (по результатам закупок, указанных в абзаце двадцать седьмом позиции 1 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"7", НСтр("ru='Годовой объем закупок у субъектов малого и среднего предпринимательства (рассчитывается как отношение суммы показателей, предусмотренных позициями 3 - 6 настоящей формы, к показателю, предусмотренному позицией 2 настоящей формы)'")));
	Классификатор.Добавить(СоздатьЗначениеКлассификатора(
		"8", НСтр("ru='Годовой объем закупок у субъектов малого и среднего предпринимательства по результатам проведения торгов, иных способов закупки, предусмотренных положением о закупке, в которых участниками закупок являются только субъекты малого и среднего предпринимательства (рассчитывается как отношение показателя, предусмотренного позицией 4 настоящей формы, к показателю, предусмотренному позицией 2 настоящей формы)'")));
	Возврат Классификатор;
КонецФункции


#КонецОбласти


#КонецЕсли