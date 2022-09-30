
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область Обновление

Функция ОбновитьПредопределенные(Параметры = Неопределено) Экспорт

	Макет = ПолучитьМакет("Предопределенные"); 
	
	Обл = Макет.ПолучитьОбласть("Предопределенные");
	
	Для НомерСтроки = 2 По Обл.ВысотаТаблицы Цикл	
		
		ОбъектСвязь = Справочники.ВидыСвязейОбъектов[СокрЛП(Обл.Область(НомерСтроки, 1).Текст)].ПолучитьОбъект();
		
		ОбъектСвязь.ОдинаковаяОрганизация	= ИспользоватьПризнак(Обл, НомерСтроки, 2);
		ОбъектСвязь.ОдинаковыйКонтрагент 	= ИспользоватьПризнак(Обл, НомерСтроки, 3);
		ОбъектСвязь.ОдинаковаяВалюта	 	= ИспользоватьПризнак(Обл, НомерСтроки, 4);
		ОбъектСвязь.ОдинаковаяСумма 		= ИспользоватьПризнак(Обл, НомерСтроки, 5);
		ОбъектСвязь.Внутригрупповой 		= ИспользоватьПризнак(Обл, НомерСтроки, 6);
		ОбъектСвязь.ТолькоОдин 				= ИспользоватьПризнак(Обл, НомерСтроки, 7);
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектСвязь);
				
	КонецЦикла;

КонецФункции

Функция ИспользоватьПризнак(Обл, НомерСтроки, НомерКолонки)
	Возврат ВРег(СокрЛП(Обл.Область(НомерСтроки, НомерКолонки).Текст)) = "ИСТИНА";
КонецФункции

#КонецОбласти

Функция ПолучитьВнутригрупповыеВидыСвязейДоговоров() Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыСвязейОбъектов.Ссылка
	|ИЗ
	|	Справочник.ВидыСвязейОбъектов КАК ВидыСвязейОбъектов
	|ГДЕ
	|	ВидыСвязейОбъектов.Внутригрупповой
	|	И НЕ ВидыСвязейОбъектов.ПометкаУдаления");
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

#КонецЕсли
