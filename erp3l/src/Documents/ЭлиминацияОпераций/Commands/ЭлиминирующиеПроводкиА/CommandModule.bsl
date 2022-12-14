
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Документ = ПараметрКоманды;
	
	ПараметрыФормы = Новый Структура("Отбор,СформироватьПриОткрытии,КлючВарианта", 
										ПолучитьОтбор(Документ), 
										Истина,
										"ОтчетПоПроводкам"
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
Функция ПолучитьОтбор(Документ)

	ПериодОтчета = Новый СтандартныйПериод(Документ.ПериодОтчета.ДатаНачала, Документ.ПериодОтчета.ДатаОкончания);
	
	Результат = Новый Структура;	
	
	Результат.Вставить("Период", 		ПериодОтчета);
	Результат.Вставить("Регистратор", 	Документ);
	Результат.Вставить("Организация", 	Документ.Организация);
	Результат.Вставить("ВидОперации", 	ПредопределенноеЗначение("Справочник.ВидыОпераций.ЭлиминацияОперацийА"));
		
	Возврат Результат;

КонецФункции
