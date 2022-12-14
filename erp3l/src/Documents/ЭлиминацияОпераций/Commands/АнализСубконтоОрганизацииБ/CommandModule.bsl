
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Документ = ПараметрКоманды;
	
	ПараметрыФормы = Новый Структура("Отбор,СформироватьПриОткрытии,КлючВарианта", 
										ПолучитьОтбор(Документ), 
										Истина,
										"АнализСубконто"
									);
									
	ОткрытьФорму("Отчет.ОСВМСФО.Форма", 
						ПараметрыФормы, 
						ПараметрыВыполненияКоманды.Источник, 
						ПараметрыВыполненияКоманды.Уникальность, 
						ПараметрыВыполненияКоманды.Окно, 
						ПараметрыВыполненияКоманды.НавигационнаяСсылка
				);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтбор(Знач Документ)

	ПериодОтчета = Новый СтандартныйПериод(Документ.ПериодОтчета.ДатаНачала, Документ.ПериодОтчета.ДатаОкончания);
	Контрагенты = ОрганизацииВызовСервераУХ.ПолучитьКонтрагентовПоОрганизации(Документ.ОрганизацияА);
	
	Результат = Новый Структура;	
	Результат.Вставить("Организация", 	Документ.ОрганизацияБ);
	Результат.Вставить("Сценарий", 		Документ.Сценарий);
	Результат.Вставить("Период", 		ПериодОтчета);
	
	Если Контрагенты.Количество() Тогда
		Результат.Вставить("Субконто1", 	 Контрагенты[0]);
	КонецЕсли;
		
	Возврат Результат;

КонецФункции
