
Процедура ПроверитьНаличиеОписанийРегистров(ТипБД=Неопределено,ПланСчетов=Неопределено,РегистрБухгалтерии=Неопределено) Экспорт
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	РегистрыБухгалтерииБД.Ссылка,
	             |	РегистрыБухгалтерииБД.ПланСчетов
	             |ИЗ
	             |	Справочник.РегистрыБухгалтерииБД КАК РегистрыБухгалтерииБД
	             |ГДЕ
	             |	РегистрыБухгалтерииБД.Владелец = &Владелец";
				 
	Запрос.УстановитьПараметр("Владелец",?(ТипБД=Неопределено,Справочники.ТипыБазДанных.ТекущаяИБ,ТипБД));
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ПланСчетов=Результат.ПланСчетов;
		РегистрБухгалтерии=Результат.Ссылка;
		
	Иначе
		
		РаботаСОбъектамиМетаданныхУХ.ЗаполнитьСписокРегистровБД(ТипБД, Неопределено, 
										Истина, 
										Ложь,
										Ложь,
										Истина);
										
		НовыйРезультат=Запрос.Выполнить().Выбрать();
		
		Если НовыйРезультат.Следующий() Тогда
			
			ПланСчетов=НовыйРезультат.ПланСчетов;
			РегистрБухгалтерии=НовыйРезультат.Ссылка;
			
		КонецЕсли;	
										
	КонецЕсли;
		
КонецПроцедуры // ПроверитьНаличиеОписанийРегистров()

#Если НаСервере Тогда
	
Функция ПолучитьПоПлануСчетовБД(ПланСчетовБД) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПланСчетовБД) Тогда
		Возврат Справочники.РегистрыБухгалтерииБД.ПустаяСсылка();
	КонецЕсли; 
	
	МассивРегистров=УправлениеОтчетамиУХ.ПолучитьМассивРегистровБухгалтерии(ПланСчетовБД);
	
	Если МассивРегистров.Количество()>0 Тогда
		
		Возврат МассивРегистров[0];
		
	Иначе
		
		Возврат Справочники.РегистрыБухгалтерииБД.ПустаяСсылка();

	КонецЕсли;	

КонецФункции   


#КонецЕсли
