#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") Тогда
			Если ДанныеЗаполнения.Действие = "Заполнить" Тогда
				ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ИсходнаяДатаНачала, "Объект.ИсходнаяДатаНачала", Отказ, НСтр("ru = 'Дата начала отпуска';
																												|en = 'Leave start date '"), , , Ложь);
	
	Документы.ПереносОтпуска.ПроверитьРаботающих(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(ИсходнаяДатаНачала) И ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник,
		|	ПлановыеЕжегодныеОтпуска.ДатаНачала,
		|	ПлановыеЕжегодныеОтпуска.Перенесен
		|ИЗ
		|	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
		|ГДЕ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник = &Сотрудник
		|	И ПлановыеЕжегодныеОтпуска.ДатаНачала = &ДатаНачала";
		Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
		Запрос.УстановитьПараметр("ДатаНачала", ИсходнаяДатаНачала);
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Результат.Пустой() Тогда
			ТекстСообщения = НСтр("ru = 'Отпуск с %1 не был запланирован в графике отпусков.';
									|en = 'Leave from %1 was not scheduled in the leave schedule.'"); 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ИсходнаяДатаНачала,"ДЛФ=D"));
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Объект.ИсходнаяДатаНачала",, Отказ);
		Иначе
			
		КонецЕсли;
	КонецЕсли;
	
	ПериодыОтпусков = Новый ТаблицаЗначений;
	ПериодыОтпусков.Колонки.Добавить("НомерСтроки");
	ПериодыОтпусков.Колонки.Добавить("ДатаНачала");
	ПериодыОтпусков.Колонки.Добавить("ДатаОкончания");
	
	Для Каждого Перенос Из Переносы Цикл 
		Для Каждого ПериодОтпуска Из ПериодыОтпусков Цикл 
			Если ПериодОтпуска.ДатаНачала <= Перенос.ДатаОкончания И ПериодОтпуска.ДатаОкончания >= Перенос.ДатаНачала Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Период отпуска в строке %1 пересекается с периодом в строке %2';
						|en = 'The leave period in line %1 overlaps the period in line %2'"), Перенос.НомерСтроки, ПериодОтпуска.НомерСтроки);
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ,
					"Объект.Переносы[" + Формат(Перенос.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].ДатаНачала" , , Отказ);
			КонецЕсли;
		КонецЦикла;
		ЗаполнитьЗначенияСвойств(ПериодыОтпусков.Добавить(), Перенос);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ЗарегистрироватьПеренос();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ЗарегистрироватьПеренос(Ссылка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	Если ЭтоНовый() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Дата = ТекущаяДатаСеанса();
		
		ДанныеЗаполнения.Свойство("Руководитель", Руководитель);
		ДанныеЗаполнения.Свойство("ДолжностьРуководителя", ДолжностьРуководителя);
		
		ЗапрашиваемыеЗначения = Новый Структура;
		ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
		ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
		
		Если ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(Руководитель) Тогда
			ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
			ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
		КонецЕсли;
			
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьПеренос(ИсключаемыйДокумент = Неопределено)
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ИсключаемыйДокумент", ИсключаемыйДокумент);
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ПлановыеЕжегодныеОтпуска.Организация КАК Организация,
	               |	ПлановыеЕжегодныеОтпуска.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ПлановыеЕжегодныеОтпуска.Сотрудник КАК Сотрудник,
	               |	ПлановыеЕжегодныеОтпуска.ДатаНачала КАК ДатаНачала,
	               |	ПлановыеЕжегодныеОтпуска.Запланирован КАК Запланирован,
	               |	ПлановыеЕжегодныеОтпуска.ДокументПланирования КАК ДокументПланирования,
	               |	ПлановыеЕжегодныеОтпуска.КоличествоДней КАК КоличествоДней,
	               |	ПлановыеЕжегодныеОтпуска.ВидОтпуска КАК ВидОтпуска,
	               |	ПлановыеЕжегодныеОтпуска.ДатаОкончания КАК ДатаОкончания,
	               |	ПлановыеЕжегодныеОтпуска.Примечание КАК Примечание
	               |ПОМЕСТИТЬ ВТИсходныеДанные
	               |ИЗ
	               |	Документ.ПереносОтпуска КАК ПереносОтпуска
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
	               |		ПО ПереносОтпуска.Сотрудник = ПлановыеЕжегодныеОтпуска.Сотрудник
	               |			И ПереносОтпуска.ИсходнаяДатаНачала = ПлановыеЕжегодныеОтпуска.ДатаНачала
	               |			И (ПереносОтпуска.Ссылка = &Ссылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ПереносОтпуска.Дата) КАК Дата,
	               |	ИсходныеДанные.Организация КАК Организация,
	               |	ИсходныеДанные.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ИсходныеДанные.Сотрудник КАК Сотрудник,
	               |	ИсходныеДанные.ДатаНачала КАК ДатаНачала,
	               |	ИсходныеДанные.Запланирован КАК Запланирован,
	               |	ИсходныеДанные.ДокументПланирования КАК ДокументПланирования,
	               |	ИсходныеДанные.КоличествоДней КАК КоличествоДней,
	               |	ИсходныеДанные.ВидОтпуска КАК ВидОтпуска,
	               |	ИсходныеДанные.ДатаОкончания КАК ДатаОкончания,
	               |	ИсходныеДанные.Примечание КАК Примечание
	               |ПОМЕСТИТЬ ВТДатыДокументовПереноса
	               |ИЗ
	               |	ВТИсходныеДанные КАК ИсходныеДанные
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска КАК ПереносОтпуска
	               |		ПО ИсходныеДанные.Сотрудник = ПереносОтпуска.Сотрудник
	               |			И ИсходныеДанные.ВидОтпуска = ПереносОтпуска.ВидОтпуска
	               |			И ИсходныеДанные.ДатаНачала = ПереносОтпуска.ИсходнаяДатаНачала
	               |			И (ПереносОтпуска.Ссылка <> &ИсключаемыйДокумент)
	               |			И (ПереносОтпуска.Проведен)
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ИсходныеДанные.ФизическоеЛицо,
	               |	ИсходныеДанные.Организация,
	               |	ИсходныеДанные.Сотрудник,
	               |	ИсходныеДанные.ДатаНачала,
	               |	ИсходныеДанные.Запланирован,
	               |	ИсходныеДанные.ВидОтпуска,
	               |	ИсходныеДанные.ДокументПланирования,
	               |	ИсходныеДанные.ДатаОкончания,
	               |	ИсходныеДанные.Примечание,
	               |	ИсходныеДанные.КоличествоДней
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ДатыДокументовПереноса.Организация КАК Организация,
	               |	ДатыДокументовПереноса.ФизическоеЛицо КАК ФизическоеЛицо,
	               |	ДатыДокументовПереноса.Сотрудник КАК Сотрудник,
	               |	ДатыДокументовПереноса.ДатаНачала КАК ДатаНачала,
	               |	ПереносОтпускаПереносы.ДатаНачала КАК ПеренесеннаяДатаНачала,
	               |	ДатыДокументовПереноса.Запланирован КАК Запланирован,
	               |	ИСТИНА КАК Перенесен,
	               |	ДатыДокументовПереноса.ДокументПланирования КАК ДокументПланирования,
	               |	ДатыДокументовПереноса.КоличествоДней КАК КоличествоДней,
	               |	ДатыДокументовПереноса.ВидОтпуска КАК ВидОтпуска,
	               |	ДатыДокументовПереноса.ДатаОкончания КАК ДатаОкончания,
	               |	ПереносОтпускаПереносы.Ссылка КАК ДокументПереноса,
	               |	ПереносОтпускаПереносы.ДатаОкончания КАК ПеренесеннаяДатаОкончания,
	               |	ПереносОтпускаПереносы.КоличествоДней КАК ПеренесенноеКоличествоДней,
	               |	ДатыДокументовПереноса.Примечание КАК Примечание
	               |ИЗ
	               |	Документ.ПереносОтпуска КАК ПереносОтпуска
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДатыДокументовПереноса КАК ДатыДокументовПереноса
	               |		ПО ПереносОтпуска.Дата = ДатыДокументовПереноса.Дата
	               |			И ПереносОтпуска.Сотрудник = ДатыДокументовПереноса.Сотрудник
	               |			И ПереносОтпуска.ВидОтпуска = ДатыДокументовПереноса.ВидОтпуска
	               |			И ПереносОтпуска.ИсходнаяДатаНачала = ДатыДокументовПереноса.ДатаНачала
	               |			И (ПереносОтпуска.Проведен)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПереносОтпуска.Переносы КАК ПереносОтпускаПереносы
	               |		ПО ПереносОтпуска.Ссылка = ПереносОтпускаПереносы.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	НаборЗаписей.Отбор.ДатаНачала.Установить(ИсходнаяДатаНачала);
	
	Пока Выборка.Следующий() Цикл 
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
	КонецЦикла;
	
	Если НаборЗаписей.Количество() = 0 Тогда 
		Запрос.Текст = "ВЫБРАТЬ * ИЗ ВТИсходныеДанные";
	    Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			НоваяЗапись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
		КонецЕсли;
	КонецЕсли;
	
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли