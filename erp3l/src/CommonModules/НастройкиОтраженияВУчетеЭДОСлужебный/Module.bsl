
#Область СлужебныеПроцедурыИФункции

// Сохраняет настройки отражения в учете.
// 
// Параметры:
// 	Настройки - ТаблицаЗначений:
// 	  * ВидДокумента - СправочникСсылка.ВидыДокументовЭДО
// 	  * СпособОбработки - Строка 
// 	  * ПредставлениеСпособаОбработки - Строка
// 	  * НеПредлагатьСохранятьНастройки - Булево 
// 	Получатель - ОпределяемыйТип.Организация
// 	Отправитель - ОпределяемыйТип.КонтрагентБЭД
// 	ИдентификаторПолучателя - Строка
// 	ИдентификаторОтправителя - Строка
// Возвращаемое значение:
// 	Булево - Истина, если настройки удалось сохранить
Функция СохранитьНастройкиОтраженияВУчете(Настройки, Получатель, Отправитель,
	ИдентификаторПолучателя, ИдентификаторОтправителя) Экспорт
	
	НачатьТранзакцию();
	Попытка
		БлокировкаДанных = Новый БлокировкаДанных;
		ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.НастройкиПолученияЭлектронныхДокументов");
		ЭлементБлокировкиДанных.УстановитьЗначение("Получатель"              , Получатель);
		ЭлементБлокировкиДанных.УстановитьЗначение("Отправитель"             , Отправитель);
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторОтправителя", ИдентификаторОтправителя);
		ЭлементБлокировкиДанных.УстановитьЗначение("ИдентификаторПолучателя" , ИдентификаторПолучателя);
		ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Исключительный;
		БлокировкаДанных.Заблокировать();
		
		Если ЗначениеЗаполнено(ИдентификаторОтправителя) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	НастройкиПолученияЭлектронныхДокументов.СпособОбработки КАК СпособОбработки
			|ИЗ
			|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
			|ГДЕ
			|	НастройкиПолученияЭлектронныхДокументов.Получатель = &Получатель
			|	И НастройкиПолученияЭлектронныхДокументов.Отправитель = &Отправитель
			|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = """"
			|	И НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = """"";
			
			Запрос.УстановитьПараметр("Отправитель", Отправитель);
			Запрос.УстановитьПараметр("Получатель", Получатель);
			
			Если Запрос.Выполнить().Пустой() Тогда
				
				ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Нельзя создать настройку получения по идентификаторам, без общей настойки по организации
					|Сначала добавьте настройку по организации';
					|en = 'Cannot create retrieval setting by identifiers, without the general setting by the company
					|Add first the setting by the company'"));
				ОтменитьТранзакцию();
				Возврат Ложь;
				
			КонецЕсли;
		КонецЕсли;
		
		Результат = Истина;
		
		Настройки.Колонки.Добавить("Получатель");
		Настройки.ЗаполнитьЗначения(Получатель, "Получатель");
		
		Настройки.Колонки.Добавить("Отправитель");
		Настройки.ЗаполнитьЗначения(Отправитель, "Отправитель");
		
		Настройки.Колонки.Добавить("ИдентификаторПолучателя");
		Настройки.ЗаполнитьЗначения(ИдентификаторПолучателя, "ИдентификаторПолучателя");
		
		Настройки.Колонки.Добавить("ИдентификаторОтправителя");
		Настройки.ЗаполнитьЗначения(ИдентификаторОтправителя, "ИдентификаторОтправителя");
		
		Для каждого СтрокаТаблицы Из Настройки Цикл
			Если СтрокаТаблицы.СпособОбработки = "Вручную" Тогда
				СтрокаТаблицы.НеПредлагатьСохранятьНастройки = Истина;
			КонецЕсли;
		КонецЦикла; 
		
		НаборЗаписей = РегистрыСведений.НастройкиПолученияЭлектронныхДокументов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Получатель.Установить(Получатель);
		НаборЗаписей.Отбор.Отправитель.Установить(Отправитель);
		НаборЗаписей.Отбор.ИдентификаторОтправителя.Установить(ИдентификаторОтправителя);
		НаборЗаписей.Отбор.ИдентификаторПолучателя.Установить(ИдентификаторПолучателя);
		НаборЗаписей.Загрузить(Настройки);
		
		
		НаборЗаписей.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ВидОперации = НСтр("ru = 'Сохранение настроек входящих документов';
							|en = 'Save incoming document settings'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КраткийТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		ЭлектронноеВзаимодействие.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, КраткийТекстОшибки, "ОбменСКонтрагентами");
		
		Результат = Ложь;
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти