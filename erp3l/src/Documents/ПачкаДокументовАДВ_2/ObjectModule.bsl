#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Выбирает данные, необходимые для проверки.
//
// Параметры: 
//  Нет
//
// Возвращаемое значение:
//  Результат запроса к данным работников документа.
//
Функция СформироватьЗапросПоСотрудникамДляПроверки()
	
	ТаблицаСотрудники = Сотрудники.Выгрузить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ТЧСотрудники", Сотрудники);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.НомерСтроки,
	|	Сотрудники.Сотрудник КАК ФизическоеЛицо,
	|	Сотрудники.ДатаПолученияСвидетельства,
	|	Сотрудники.СтраховойНомерПФРВСвидетельстве,
	|	Сотрудники.ФамилияВСвидетельстве,
	|	Сотрудники.ИмяВСвидетельстве,
	|	Сотрудники.ОтчествоВСвидетельстве,
	|	Сотрудники.Фамилия,
	|	Сотрудники.Имя,
	|	Сотрудники.Отчество,
	|	Сотрудники.Пол,
	|	Сотрудники.ДатаРождения,
	|	Сотрудники.МестоРождения,
	|	Сотрудники.Гражданство,
	|	Сотрудники.ИНН,
	|	Сотрудники.НомерАктовойЗаписиПриРождении,
	|	Сотрудники.ПризнакОтменыОтчества,
	|	Сотрудники.ПризнакОтменыМестаРождения,
	|	Сотрудники.АдресРегистрации,
	|	Сотрудники.АдресФактический,
	|	Сотрудники.СерияДокумента,
	|	Сотрудники.ВидДокумента,
	|	Сотрудники.НомерДокумента,
	|	Сотрудники.ДатаВыдачи,
	|	Сотрудники.КемВыдан
	|ПОМЕСТИТЬ ВТФизЛицаДокумента
	|ИЗ
	|	&ТЧСотрудники КАК Сотрудники
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Сотрудники.Сотрудник";
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, Дата, Дата);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФизЛицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ФизЛицаДокумента.ФизическоеЛицо КАК Сотрудник,
	|	ФизЛицаДокумента.ФизическоеЛицо.ФИО КАК СотрудникНаименование,
	|	ФизЛицаДокумента.АдресРегистрации КАК АдресРегистрации,
	|	ФизЛицаДокумента.АдресФактический КАК АдресФактический,
	|	ФизЛицаДокумента.ДатаРождения КАК ДатаРождения,
	|	ФизЛицаДокумента.ВидДокумента КАК ВидДокумента,
	|	ФизЛицаДокумента.СерияДокумента КАК СерияДокумента,
	|	ФизЛицаДокумента.НомерДокумента КАК НомерДокумента,
	|	ФизЛицаДокумента.ДатаВыдачи КАК ДатаВыдачи,
	|	ФизЛицаДокумента.КемВыдан КАК КемВыдан,
	|	ФизЛицаДокумента.ДатаПолученияСвидетельства КАК ДатаПолученияСвидетельства,
	|	ФизЛицаДокумента.СтраховойНомерПФРВСвидетельстве КАК СтраховойНомерПФРВСвидетельстве,
	|	ФизЛицаДокумента.ФамилияВСвидетельстве КАК ФамилияВСвидетельстве,
	|	ФизЛицаДокумента.ИмяВСвидетельстве КАК ИмяВСвидетельстве,
	|	ФизЛицаДокумента.ОтчествоВСвидетельстве КАК ОтчествоВСвидетельстве,
	|	ФизЛицаДокумента.Фамилия КАК Фамилия,
	|	ФизЛицаДокумента.Имя КАК Имя,
	|	ФизЛицаДокумента.Отчество КАК Отчество,
	|	ФизЛицаДокумента.Пол КАК Пол,
	|	ФизЛицаДокумента.МестоРождения КАК МестоРождения,
	|	ФизЛицаДокумента.Гражданство КАК Гражданство,
	|	ФизЛицаДокумента.ИНН,
	|	ФизЛицаДокумента.НомерАктовойЗаписиПриРождении,
	|	ФизЛицаДокумента.ПризнакОтменыОтчества КАК ПризнакОтменыОтчества,
	|	ФизЛицаДокумента.ПризнакОтменыМестаРождения КАК ПризнакОтменыМестаРождения,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации,
	|	ДублиСтрок.НомерСтроки КАК КонфликтующаяСтрока
	|ИЗ
	|	ВТФизЛицаДокумента КАК ФизЛицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = АктуальныеСотрудники.ФизическоеЛицо
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизЛицаДокумента КАК ДублиСтрок
	|		ПО ФизЛицаДокумента.ФизическоеЛицо = ДублиСтрок.ФизическоеЛицо
	|			И ФизЛицаДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизЛицаДокумента.НомерСтроки";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ПроверяемыеРеквизитыСотрудников = Новый Массив;
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.СтраховойНомерПФРВСвидетельстве");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ВидДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.НомерДокумента");
	ПроверяемыеРеквизитыСотрудников.Добавить("Сотрудники.ДатаВыдачи");
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);	
	
	ДанныеОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, КодПоОКПО"); 
	
	ВыборкаСотрудникиДляПроверки = СформироватьЗапросПоСотрудникамДляПроверки().Выбрать();
	
	Если ВыборкаСотрудникиДляПроверки.Количество() > 200 Тогда
		ТекстОшибки = НСтр("ru = 'В документе должно быть не более 200 анкет (сотрудников).';
							|en = 'Document should contain no more than 200 questionnaires (employees).'");
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка,,,Отказ);
	КонецЕсли;
	
	Пока ВыборкаСотрудникиДляПроверки.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Сотрудник) Тогда
			
			Если Не ВыборкаСотрудникиДляПроверки.СотрудникРаботаетВОрганизации Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2 не работает в организации %3.';
																							|en = 'Employee %2 does not work for company %3.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование, ДанныеОрганизации.Наименование);     
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если ВыборкаСотрудникиДляПроверки.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %2 была введена в документе ранее.';
																							|en = 'Information on employee %2 has already been entered into the document.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Фамилия) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Имя) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Отчество)
				И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Пол) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ДатаРождения) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.МестоРождения)
				И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.АдресРегистрации) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.АдресФактический) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Гражданство)
				И Не (ВыборкаСотрудникиДляПроверки.ПризнакОтменыОтчества) И Не(ВыборкаСотрудникиДляПроверки.ПризнакОтменыМестаРождения) Тогда 
				
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: не заполнены изменившиеся сведения.';
																							|en = 'Employee %1: changed information is not filled in.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			Если Дата >= '20210123' И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.НомерАктовойЗаписиПриРождении)
				И ВыборкаСотрудникиДляПроверки.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.СвидетельствоОРождении Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %1: не указан Номер актовой записи при рождении.';
																							|en = 'Employee %1: the birth record number is not specified.'"), ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ФамилияВСвидетельстве) И Не ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.ИмяВСвидетельстве) Тогда
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Строка %1: у сотрудника должна быть заполнена фамилия в свидетельстве или имя в свидетельстве.';
					|en = 'Line %1: the employee''s full name must be filled in the certificate.'"),
				ВыборкаСотрудникиДляПроверки.НомерСтроки);
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ,
				"Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник", , Отказ);
		КонецЕсли;
		
		ФизическиеЛицаЗарплатаКадры.ПроверитьПерсональныеДанныеСотрудника(Ссылка, ВыборкаСотрудникиДляПроверки, ПроверяемыеРеквизитыСотрудников, НеПроверяемыеРеквизиты, Дата, Истина, Отказ);		
		ПерсонифицированныйУчет.ПроверитьСоответствиеИзменившихсяДанныхДаннымСвидетельства(Ссылка, ВыборкаСотрудникиДляПроверки, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат КонецДня(Дата);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли