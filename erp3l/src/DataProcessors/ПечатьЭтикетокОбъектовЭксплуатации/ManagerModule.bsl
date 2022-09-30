#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Печать

Функция СформироватьПечатнуюФормуЭтикеткиОбъектовЭксплуатации(ДанныеПечати, МассивОбъектов) Экспорт
	
	ОбработкаПечатьЭтикетокИЦенников = ЦенообразованиеВызовСервера.ОбработкаПечатьЭтикетокИЦенников();
	
	СтруктураНастроек = ОбработкаПечатьЭтикетокИЦенников.СтруктураНастроек();
	СтруктураНастроек.ОбязательныеПоля.Добавить("ОбъектЭксплуатации");
	
	СтруктураНастроек.ИмяМакетаСхемыКомпоновкиДанных = "ПоляШаблонаОбъектыЭксплуатации";
	
	КоличествоЭкземпляров = ДанныеПечати.КоличествоЭкземпляров;
	
	СтруктураНастроек.ИсходныеДанные = ПолучитьИзВременногоХранилища(ДанныеПечати.АдресВХранилище);
	
	Если Не ДанныеПечати.Свойство("СтруктураМакетаШаблона") Или Не ЗначениеЗаполнено(ДанныеПечати.СтруктураМакетаШаблона) Тогда
		СтруктураШаблона = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеПечати.ШаблонЭтикетки, "Шаблон").Получить();
	Иначе
		СтруктураШаблона = ДанныеПечати.СтруктураМакетаШаблона;
	КонецЕсли;
	
	Для Каждого Элемент Из СтруктураШаблона.ПараметрыШаблона Цикл
		СтруктураНастроек.ОбязательныеПоля.Добавить(Элемент.Ключ);
	КонецЦикла;
	
	СтруктураРезультата = ОбработкаПечатьЭтикетокИЦенников.ПодготовитьСтруктуруДанных(СтруктураНастроек, "ОбъектыЭксплуатации");
	
	Эталон = ОбработкаПечатьЭтикетокИЦенников.ПолучитьМакет("Эталон");
	КартинкаМакета = Эталон.Рисунки.Квадрат100Пикселей; // РисунокТабличногоДокумента
	КоличествоМиллиметровВПикселе = КартинкаМакета.Высота / 100;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	НомерКолонки = 0;
	НомерРяда = 0;
	
	Область = СтруктураШаблона.МакетЭтикетки.ПолучитьОбласть(СтруктураШаблона.ИмяОбластиПечати);
	
	Для Каждого СтрокаТаблицы Из СтруктураРезультата.Таблица Цикл
		
		ЗаполнитьЗначенияСвойств(ТабличныйДокумент, СтруктураШаблона.МакетЭтикетки, , "ОбластьПечати");
		
		Для каждого ПараметрШаблона Из СтруктураШаблона.ПараметрыШаблона Цикл
			Если ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(Область.Параметры, ПараметрШаблона.Значение) Тогда
				НаименованиеКолонки = СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицы.Получить(Справочники.ШаблоныЭтикетокИЦенников.ИмяПоляВШаблоне(ПараметрШаблона.Ключ));
				Если НаименованиеКолонки <> Неопределено Тогда
					Область.Параметры[ПараметрШаблона.Значение] = СтрокаТаблицы[НаименованиеКолонки];
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Для каждого Рисунок Из Область.Рисунки Цикл
			Если СтрНайти(Рисунок.Имя, Справочники.ШаблоныЭтикетокИЦенников.ИмяПараметраШтрихкод()) = 1 Тогда
				
				ЗначениеШтрихкода = СтрокаТаблицы[СтруктураРезультата.СоответствиеПолейСКДКолонкамТаблицы.Получить(Справочники.ШаблоныЭтикетокИЦенников.ИмяПараметраШтрихкод())];
				Если ЗначениеЗаполнено(ЗначениеШтрихкода) Тогда
					
					ПараметрыШтрихкода = Новый Структура;
					ПараметрыШтрихкода.Вставить("Ширина",           Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселе));
					ПараметрыШтрихкода.Вставить("Высота",           Окр(Рисунок.Высота / КоличествоМиллиметровВПикселе));
					ПараметрыШтрихкода.Вставить("Штрихкод",         СокрЛП(ЗначениеШтрихкода));
					ПараметрыШтрихкода.Вставить("ТипВходныхДанных", 0); // Штрихкод - это строка
					ПараметрыШтрихкода.Вставить("ТипКода",          СтруктураШаблона.ТипКода);
					ПараметрыШтрихкода.Вставить("ОтображатьТекст",  СтруктураШаблона.ОтображатьТекст);
					ПараметрыШтрихкода.Вставить("РазмерШрифта",     СтруктураШаблона.РазмерШрифта);
					
					Если СтруктураШаблона.Свойство("GS1DatabarКоличествоСтрок") Тогда
						ПараметрыШтрихкода.Вставить("GS1DatabarКоличествоСтрок", СтруктураШаблона.GS1DatabarКоличествоСтрок);
					КонецЕсли;
					Если СтруктураШаблона.Свойство("ТипШрифта") Тогда
						ПараметрыШтрихкода.Вставить("ТипШрифта", СтруктураШаблона.МонохромныйШрифт);
					КонецЕсли;
					Если СтруктураШаблона.Свойство("УголПоворота") Тогда
						ПараметрыШтрихкода.Вставить("УголПоворота", СтруктураШаблона.УголПоворота);
					КонецЕсли;
					
					Рисунок.Картинка = МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		
		Для Инд = 1 По КоличествоЭкземпляров Цикл // Цикл по количеству экземпляров
			
			НомерКолонки = НомерКолонки + 1;
			
			Если НомерКолонки = 1 Тогда
				
				НомерРяда = НомерРяда + 1;
				
				ТабличныйДокумент.Вывести(Область);
				
			Иначе
				
				ТабличныйДокумент.Присоединить(Область);
				
			КонецЕсли;
			
			Если НомерКолонки = СтруктураШаблона.КоличествоПоГоризонтали
				И НомерРяда = СтруктураШаблона.КоличествоПоВертикали Тогда
				
				НомерРяда    = 0;
				НомерКолонки = 0;
				
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
				
			ИначеЕсли НомерКолонки = СтруктураШаблона.КоличествоПоГоризонтали Тогда
				
				НомерКолонки = 0;
				
			КонецЕсли;
			
		КонецЦикла; // Цикл по количеству экземпляров
		
	КонецЦикла; // Цикл по строкам таблицы
	
	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
