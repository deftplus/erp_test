
Функция ПолучитьПараметры() Экспорт

	Перем ТекущийКласс;
	
	КлассыВНА = МСФОВызовСервераУХ.ПолучитьСтруктуруСоЗначениямиПеречисления("КлассыВНА");
	
	ТабДок = ПолучитьМакет("КлассыВНА");
	Результат = Новый Соответствие;	
		
	Для НомерКолонки = 3 По ТабДок.ШиринаТаблицы Цикл
		
		Если Не КлассыВНА.Свойство(ТабДок.Область(1, НомерКолонки).Текст, ТекущийКласс) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыКласса = Новый Структура;
		
		Для НомерСтроки = 2 По ТабДок.ВысотаТаблицы Цикл
			
			ИмяПараметра = СокрЛП(ТабДок.Область(НомерСтроки, 2).Текст);
			Если ИмяПараметра = "" Тогда
				Продолжить;
			КонецЕсли;
			
			ЗначениеПараметра = СокрЛП(ТабДок.Область(НомерСтроки, НомерКолонки).Текст);
			Если ИмяПараметра = "МодельУчетаВНА" Тогда
				ПараметрыКласса.Вставить(ИмяПараметра, ЗначениеПараметра);
			Иначе 
				ПараметрыКласса.Вставить(ИмяПараметра, ЗначениеПараметра = "+");
			КонецЕсли;
						
		КонецЦикла;
		
		Результат.Вставить(ТекущийКласс, ПараметрыКласса);
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ПолучитьКлассыПоступления() Экспорт
	Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПредопределенноеЗначение("Перечисление.КлассыВНА.НезавершенноеСтроительство"));
КонецФункции

Функция ПолучитьКлассыЭксплуатации() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.КлассыВНА.ОсновноеСредство"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.КлассыВНА.НематериальныйАктив"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.КлассыВНА.ИнвестиционноеИмущество"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.КлассыВНА.БиологическийАктив"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.КлассыВНА.ВнеоборотныйАктивДляПродажи"));
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКлассВНАПоСправочнику(СправочникМетаданные) Экспорт
	
	СоответствиеКлассовВНА = Новый Соответствие;
	СоответствиеКлассовВНА.Вставить(Метаданные.НайтиПоТипу(ВстраиваниеУХКлиентСервер.ПолучитьТипОС()),	Перечисления.КлассыВНА.ОсновноеСредство);
	СоответствиеКлассовВНА.Вставить(Метаданные.Справочники.НематериальныеАктивы, 						Перечисления.КлассыВНА.НематериальныйАктив);
	СоответствиеКлассовВНА.Вставить(Метаданные.Справочники.ОбъектыСтроительства, 						Перечисления.КлассыВНА.НезавершенноеСтроительство);
	
	Результат = СоответствиеКлассовВНА[СправочникМетаданные];
	Если Результат = Неопределено Тогда
		Результат = Перечисления.КлассыВНА.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
