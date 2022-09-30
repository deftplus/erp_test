
#Область СлужебныйПрограммныйИнтерфейс

// Процедура регистрирует факт неудачи при попытке выплаты зарплаты документом.
// При этом "сторнируются" перенос даты получения доходов.
//
// Параметры:
//		Движения 		- КоллекцияДвижений, коллекция наборов записей движений ведомости.
//		Отказ			- признак отказа выполнения операции.
//		Документ		- ссылка на документ, которым ранее была зарегистрирована выплата зарплаты.
//		ФизическиеЛица	- массив ссылок на физические лица.
//
// Обработка ошибочных ситуаций
//	выдается сообщение, признак «Отказ» выставляется в Истина.
//
Процедура ЗарегистрироватьНевыплатуДокументом(Движения, Отказ, Документ, ФизическиеЛица) Экспорт
	
	Если Отказ 
		Или Движения.Найти("СведенияОДоходахНДФЛ") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Расчеты налогоплательщиков с бюджетом.
	СведенияОДоходах = РегистрыНакопления.СведенияОДоходахНДФЛ.СоздатьНаборЗаписей();
	СведенияОДоходах.Отбор.Регистратор.Установить(Документ);
	СведенияОДоходах.Прочитать();
	
	СведенияОДоходахСторно = СведенияОДоходах.ВыгрузитьКолонки();
	Для Каждого ЗаписьВедомости Из СведенияОДоходах Цикл
		Если ФизическиеЛица.Найти(ЗаписьВедомости.ФизическоеЛицо) <> Неопределено Тогда
			СтрокаСторно = СведенияОДоходахСторно.Добавить() ;
			ЗаполнитьЗначенияСвойств(СтрокаСторно, ЗаписьВедомости);
			СтрокаСторно.СуммаДохода = - ЗаписьВедомости.СуммаДохода;
			СтрокаСторно.СуммаВычета = - ЗаписьВедомости.СуммаВычета;
		КонецЕсли;
	КонецЦикла;
	
	Движения.СведенияОДоходахНДФЛ.Загрузить(СведенияОДоходахСторно);
	Движения.СведенияОДоходахНДФЛ.Записывать= Истина;
	
КонецПроцедуры

// Регистрирует полученный доход "Начислятелей" на новую дату получения дохода
// Параметры:
//		Регистратор - ДокументСсылка - документ выплаты
//		МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - должен содержать временные таблицы 
//      	ВТСписокСотрудников, с данными о выплатах вида:
//				ФизическоеЛицо: должно быть непустым
//          	СуммаВыплаты.
//          	ДокументОснование, необязательная
//          	СтатьяФинансирования, необязательная
//          	СтатьяРасходов, необязательная
//          	СуммаНачисленная, необязательная
//          	СуммаВыплаченная, необязательная, 
//			Если колонки СуммаНачисленная, СуммаВыплаченная отсутствуют, возможная частичная выплата не будет учтена.
//		Движения - коллекция движений регистратора.
//		ДатаВыплаты - Дата - новая дата получения дохода.
//		ДатаОперации - Дата - дата, которой будет зарегистрировано движение.
//		Отказ - Булево - признак отказа от заполнения движений.
//		Записывать - Булево - признак того, надо ли записывать движения сразу, или они будут записаны позже.
//
Процедура ЗарегистрироватьНовуюДатуПолученияДохода(Ведомость, Движения, МенеджерВременныхТаблиц, ДатаВыплаты, ДатаОперации, Отказ, Записывать = Ложь) Экспорт
	
	УчетФактическиПолученныхДоходовБазовый.ЗарегистрироватьНовуюДатуПолученияДохода(Ведомость, Движения, МенеджерВременныхТаблиц, ДатаВыплаты, ДатаОперации, Отказ, Записывать);
	
	Если Отказ 
		Или ДатаВыплаты < УчетФактическиПолученныхДоходов.ДатаНачалаИспользованияПодсистемы() 
		Или Не ПроведениеСервер.ЕстьНаборЗаписей(Движения, "БухучетНачисленияУдержанияПоСотрудникам") Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицыКУдалению = Новый Массив;
	
	// Бухучет начисления удержания по сотрудникам
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ОсобыеНачисленияУдержанияНДФЛ", ОтражениеЗарплатыВУчете.ВидыОсобыхНачисленийИУдержанийНДФЛ(Истина));
	Запрос.УстановитьПараметр("КатегорииДоходаОплатыТруда", Перечисления.КатегорииДоходовНДФЛ.СФиксированнойДатойПолученияДохода());
	Запрос.УстановитьПараметр("ДоляПолнойВыплаты", УчетНДФЛ.ДоляПолнойВыплаты());
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	ВТСписокСотрудников КАК ДанныеВедомости
	|ГДЕ
	|	ДанныеВедомости.СуммаВыплаты < 0";
	Если Запрос.Выполнить().Пустой() Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ИтогиПоВедомости.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИтогиПоВедомости.ДокументОснование КАК ДокументОснование,
		|	ИтогиПоВедомости.СтатьяФинансирования КАК СтатьяФинансирования,
		|	ИтогиПоВедомости.СтатьяРасходов КАК СтатьяРасходов,
		|	ИтогиПоВедомости.СуммаВыплаты КАК СуммаВыплаты,
		|	ИтогиПоВедомости.СуммаНачисленная КАК СуммаНачисленная,
		|	ИтогиПоВедомости.СуммаВыплаченная КАК СуммаВыплаченная,
		|	ВЫБОР
		|		КОГДА ИтогиПоВедомости.СуммаНачисленная = 0
		|			ТОГДА 1
		|		КОГДА ИтогиПоВедомости.СуммаНачисленная < 0
		|				И ИтогиПоВедомости.СуммаВыплаты = ИтогиПоВедомости.СуммаНачисленная
		|			ТОГДА 1
		|		КОГДА ИтогиПоВедомости.СуммаВыплаченная + ИтогиПоВедомости.СуммаВыплаты > ИтогиПоВедомости.СуммаНачисленная * &ДоляПолнойВыплаты
		|			ТОГДА 1
		|		ИНАЧЕ ИтогиПоВедомости.СуммаВыплаты / ИтогиПоВедомости.СуммаНачисленная
		|	КОНЕЦ КАК ДоляВыплаты
		|ПОМЕСТИТЬ ВТДанныеДляОтбора
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеВедомости.ФизическоеЛицо КАК ФизическоеЛицо,
		|		ДанныеВедомости.ДокументОснование КАК ДокументОснование,
		|		ДанныеВедомости.СтатьяФинансирования КАК СтатьяФинансирования,
		|		ДанныеВедомости.СтатьяРасходов КАК СтатьяРасходов,
		|		СУММА(ДанныеВедомости.СуммаВыплаты) КАК СуммаВыплаты,
		|		СУММА(ДанныеВедомости.СуммаНачисленная) КАК СуммаНачисленная,
		|		СУММА(ДанныеВедомости.СуммаВыплаченная) КАК СуммаВыплаченная
		|	ИЗ
		|		ВТСписокСотрудников КАК ДанныеВедомости
		|	ГДЕ
		|		ДанныеВедомости.ДокументОснование <> НЕОПРЕДЕЛЕНО
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеВедомости.ФизическоеЛицо,
		|		ДанныеВедомости.ДокументОснование,
		|		ДанныеВедомости.СтатьяФинансирования,
		|		ДанныеВедомости.СтатьяРасходов) КАК ИтогиПоВедомости
		|ГДЕ
		|	ИтогиПоВедомости.СуммаВыплаты > 0";
		КолонкиРезультата = МенеджерВременныхТаблиц.Таблицы["ВТСписокСотрудников"].Колонки;
		Если КолонкиРезультата.Найти("ДокументОснование") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.ДокументОснование", "НЕОПРЕДЕЛЕНО") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СуммаНачисленная") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СуммаНачисленная", "0") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СуммаВыплаченная") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СуммаВыплаченная", "0") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СтатьяФинансирования") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СтатьяФинансирования", "НЕОПРЕДЕЛЕНО");
		КонецЕсли;
		Если КолонкиРезультата.Найти("СтатьяРасходов") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СтатьяРасходов", "НЕОПРЕДЕЛЕНО") 
		КонецЕсли;
		Запрос.Текст = ТекстЗапроса;
	Иначе
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ДанныеВедомости.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ДанныеВедомости.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТПоложительныеДоходы
		|ИЗ
		|	ВТСписокСотрудников КАК ДанныеВедомости
		|ГДЕ
		|	ДанныеВедомости.ДокументОснование <> НЕОПРЕДЕЛЕНО
		|
		|СГРУППИРОВАТЬ ПО
		|	ДанныеВедомости.ФизическоеЛицо,
		|	ДанныеВедомости.ДокументОснование
		|
		|ИМЕЮЩИЕ
		|	СУММА(ДанныеВедомости.СуммаВыплаты) > 0";
		КолонкиРезультата = МенеджерВременныхТаблиц.Таблицы["ВТСписокСотрудников"].Колонки;
		Если КолонкиРезультата.Найти("ДокументОснование") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.ДокументОснование", "НЕОПРЕДЕЛЕНО") 
		КонецЕсли;
		Запрос.Текст = ТекстЗапроса;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ИтогиПоВедомости.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИтогиПоВедомости.ДокументОснование КАК ДокументОснование,
		|	ИтогиПоВедомости.СтатьяФинансирования КАК СтатьяФинансирования,
		|	ИтогиПоВедомости.СтатьяРасходов КАК СтатьяРасходов,
		|	ИтогиПоВедомости.СуммаВыплаты КАК СуммаВыплаты,
		|	ИтогиПоВедомости.СуммаНачисленная КАК СуммаНачисленная,
		|	ИтогиПоВедомости.СуммаВыплаченная КАК СуммаВыплаченная,
		|	ВЫБОР
		|		КОГДА ИтогиПоВедомости.СуммаНачисленная = 0
		|			ТОГДА 1
		|		КОГДА ИтогиПоВедомости.СуммаНачисленная < 0
		|				И ИтогиПоВедомости.СуммаВыплаты = ИтогиПоВедомости.СуммаНачисленная
		|			ТОГДА 1
		|		КОГДА ИтогиПоВедомости.СуммаВыплаченная + ИтогиПоВедомости.СуммаВыплаты > ИтогиПоВедомости.СуммаНачисленная * &ДоляПолнойВыплаты
		|			ТОГДА 1
		|		ИНАЧЕ ИтогиПоВедомости.СуммаВыплаты / ИтогиПоВедомости.СуммаНачисленная
		|	КОНЕЦ КАК ДоляВыплаты
		|ПОМЕСТИТЬ ВТДанныеДляОтбора
		|ИЗ
		|	(ВЫБРАТЬ
		|		ДанныеВедомости.ФизическоеЛицо КАК ФизическоеЛицо,
		|		ДанныеВедомости.ДокументОснование КАК ДокументОснование,
		|		ДанныеВедомости.СтатьяФинансирования КАК СтатьяФинансирования,
		|		ДанныеВедомости.СтатьяРасходов КАК СтатьяРасходов,
		|		СУММА(ДанныеВедомости.СуммаВыплаты) КАК СуммаВыплаты,
		|		СУММА(ДанныеВедомости.СуммаНачисленная) КАК СуммаНачисленная,
		|		СУММА(ДанныеВедомости.СуммаВыплаченная) КАК СуммаВыплаченная
		|	ИЗ
		|		ВТСписокСотрудников КАК ДанныеВедомости
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПоложительныеДоходы КАК ПоложительныеДоходы
		|		ПО ДанныеВедомости.ФизическоеЛицо = ПоложительныеДоходы.ФизическоеЛицо
		|			И ДанныеВедомости.ДокументОснование = ПоложительныеДоходы.ДокументОснование
		|	ГДЕ
		|		ДанныеВедомости.ДокументОснование <> НЕОПРЕДЕЛЕНО
		|		И ПоложительныеДоходы.ФизическоеЛицо ЕСТЬ НЕ NULL 
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ДанныеВедомости.ФизическоеЛицо,
		|		ДанныеВедомости.ДокументОснование,
		|		ДанныеВедомости.СтатьяФинансирования,
		|		ДанныеВедомости.СтатьяРасходов) КАК ИтогиПоВедомости
		|ГДЕ
		|	ИтогиПоВедомости.СуммаВыплаты > 0";
		КолонкиРезультата = МенеджерВременныхТаблиц.Таблицы["ВТСписокСотрудников"].Колонки;
		Если КолонкиРезультата.Найти("ДокументОснование") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.ДокументОснование", "НЕОПРЕДЕЛЕНО") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СуммаНачисленная") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СуммаНачисленная", "0") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СуммаВыплаченная") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СуммаВыплаченная", "0") 
		КонецЕсли;
		Если КолонкиРезультата.Найти("СтатьяФинансирования") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СтатьяФинансирования", "НЕОПРЕДЕЛЕНО");
		КонецЕсли;
		Если КолонкиРезультата.Найти("СтатьяРасходов") = Неопределено Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеВедомости.СтатьяРасходов", "НЕОПРЕДЕЛЕНО") 
		КонецЕсли;
		Запрос.Текст = Запрос.Текст + ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов() + ТекстЗапроса;
		ТаблицыКУдалению.Добавить("ВТПоложительныеДоходы");
	КонецЕсли;
	Запрос.Выполнить();
	ТаблицыКУдалению.Добавить("ВТДанныеДляОтбора");
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БухучетНачисленияУдержанияПоСотрудникам.*,
	|	ВТДанныеДляОтбора.ДоляВыплаты КАК ДоляВыплаты
	|ИЗ
	|	РегистрНакопления.БухучетНачисленияУдержанияПоСотрудникам КАК БухучетНачисленияУдержанияПоСотрудникам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДанныеДляОтбора КАК ВТДанныеДляОтбора
	|		ПО БухучетНачисленияУдержанияПоСотрудникам.Регистратор = ВТДанныеДляОтбора.ДокументОснование
	|			И БухучетНачисленияУдержанияПоСотрудникам.ФизическоеЛицо = ВТДанныеДляОтбора.ФизическоеЛицо
	|			И БухучетНачисленияУдержанияПоСотрудникам.СтатьяФинансирования = ВТДанныеДляОтбора.СтатьяФинансирования
	|			И БухучетНачисленияУдержанияПоСотрудникам.СтатьяРасходов = ВТДанныеДляОтбора.СтатьяРасходов
	|ГДЕ
	|	БухучетНачисленияУдержанияПоСотрудникам.НачислениеУдержание В(&ОсобыеНачисленияУдержанияНДФЛ)
	|	И НЕ БухучетНачисленияУдержанияПоСотрудникам.Сторно
	|	И НЕ (БухучетНачисленияУдержанияПоСотрудникам.ДатаПолученияДоходаФиксирована
	|				ИЛИ БухучетНачисленияУдержанияПоСотрудникам.КатегорияДохода В (&КатегорииДоходаОплатыТруда))";
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НовоеДвижение = Движения.БухучетНачисленияУдержанияПоСотрудникам.Добавить();
		
		Сумма = 0;
		Если Выборка.Сумма * Выборка.Сумма > (Выборка.Сумма * Выборка.ДоляВыплаты) * (Выборка.Сумма * Выборка.ДоляВыплаты) Тогда
			Сумма = (Выборка.Сумма * Выборка.ДоляВыплаты);
		Иначе
			Сумма = Выборка.Сумма;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка);
		НовоеДвижение.Сумма = - Сумма;
		НовоеДвижение.Период = ДатаОперации;
		НовоеДвижение.ПервичныйРегистратор = ?(ЗначениеЗаполнено(Выборка.ПервичныйРегистратор), Выборка.ПервичныйРегистратор, Выборка.Регистратор);
		
		НовоеДвижение = Движения.БухучетНачисленияУдержанияПоСотрудникам.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка);
		НовоеДвижение.Сумма = Сумма;
		НовоеДвижение.УстаревшаяДатаПолученияДохода = Выборка.ДатаПолученияДохода;
		НовоеДвижение.ДатаПолученияДохода = ДатаВыплаты;
		НовоеДвижение.Период = ДатаОперации;
		НовоеДвижение.ПервичныйРегистратор = ?(ЗначениеЗаполнено(Выборка.ПервичныйРегистратор), Выборка.ПервичныйРегистратор, Выборка.Регистратор);
		
	КонецЦикла;
	
	Если Записывать Тогда
		Движения.БухучетНачисленияУдержанияПоСотрудникам.Записать();
		Движения.БухучетНачисленияУдержанияПоСотрудникам.Записывать = Ложь;
	Иначе
		Движения.БухучетНачисленияУдержанияПоСотрудникам.Записывать = Истина;
	КонецЕсли;
	
	ЗарплатаКадры.УничтожитьВТ(Запрос.МенеджерВременныхТаблиц, ТаблицыКУдалению);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает Таблицу соответствия КодовДоходаНДФЛ, Категории начисления (для кода дохода 4800) и Категории дохода
// Если заполнен параметр КодДоходаНДФЛ тип СправочникСсылка.ВидыДоходовНДФЛ, то соответствие будет возвращено только
// для этого кода.
//
Функция СопоставлениеКодовИКатегорийДоходовНДФЛ(КодДоходаНДФЛ = Неопределено) Экспорт
	
	СоответствиеКодов = УчетФактическиПолученныхДоходовБазовый.СопоставлениеКодовИКатегорийДоходовНДФЛ(КодДоходаНДФЛ);
	
	КодДохода4800 = ПредопределенноеЗначение("Справочник.ВидыДоходовНДФЛ.Код4800");
	Если КодДоходаНДФЛ = Неопределено Или КодДоходаНДФЛ = КодДохода4800 Тогда
		КатегорияДохода = УчетНДФЛПовтИсп.КатегорияДоходаПоЕгоКоду(КодДохода4800);
		Если Не (КатегорияДохода = Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда 
			Или КатегорияДохода = Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы) Тогда
			
			СтрокиОписанияПремии = СоответствиеКодов.НайтиСтроки(Новый Структура("КодДохода", КодДохода4800));
			Для Каждого СтрокаОписания Из СтрокиОписанияПремии Цикл
				СоответствиеКодов.Удалить(СтрокаОписания)
			КонецЦикла;
			
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов,КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы);
											
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы, 
											Перечисления.КатегорииДоходовНДФЛ.ДоходВНатуральнойФормеОтТрудовойДеятельности,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсационныеВыплаты);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы, 
											,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КомпенсацияМоральногоВреда);
			// Льготы.
			ДополнительныеКатегорииЛьгот = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.КатегорииДоходовНДФЛ.ДоходВНатуральнойФормеОтТрудовойДеятельности);
			ДополнительныеКатегорииЛьгот.Добавить(Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы);
			
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы, 
											ДополнительныеКатегорииЛьгот,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Льгота);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодДохода4800, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы, 
											ДополнительныеКатегорииЛьгот,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ВыбираемаяСотрудникомЛьгота);
		КонецЕсли;
	КонецЕсли;
	
	КодПремии = Справочники.ВидыДоходовНДФЛ.Код2002;
	СтрокиОписанияПремии = СоответствиеКодов.НайтиСтроки(Новый Структура("КодДохода", КодПремии));
	Если СтрокиОписанияПремии.Количество() > 0 Тогда
		ПремияОписанаКакОплатаТруда = СоответствиеКодов.НайтиСтроки(Новый Структура("КодДохода, КатегорияДохода", КодПремии, Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда)).Количество() > 0;
		Для Каждого СтрокаОписания Из СтрокиОписанияПремии Цикл
			СоответствиеКодов.Удалить(СтрокаОписания)
		КонецЦикла;
		Если ПремияОписанаКакОплатаТруда Тогда
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда); 
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Премия);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.КвартальнаяПремия);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ОплатаТруда, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.Прочее);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ДоходВНатуральнойФормеОтТрудовойДеятельности, 
											,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме);
		Иначе
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
								Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходыВДенежнойФормеОтТрудовойДеятельности, 
								Перечисления.КатегорииДоходовНДФЛ.ПрочиеДоходы);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, КодПремии, 
											Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы, 
											,
											Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме);
		КонецЕсли;
	КонецЕсли;
	
	//	Для категории начисления "ДоходВНатуральнойФорме" проставим Категорию дохода "ПрочиеНатуральныеДоходы"
	// в сопоставлении для кодов дохода НДФЛ 2003, 20010, 2760, 2201-2209
	ВидыДоходов = Новый Массив;
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2003);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2010);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2760);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2201);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2202);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2203);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2204);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2205);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2206);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2207);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2208);
	ВидыДоходов.Добавить(Справочники.ВидыДоходовНДФЛ.Код2209);
	Если ЗначениеЗаполнено(КодДоходаНДФЛ) Тогда
		Если ВидыДоходов.Найти(КодДоходаНДФЛ) <> Неопределено Тогда
			ВидыДоходов.Очистить();
			ВидыДоходов.Добавить(КодДоходаНДФЛ);
		Иначе
			ВидыДоходов.Очистить();
		КонецЕсли;
	КонецЕсли;
	Для Каждого ВидДохода Из ВидыДоходов Цикл
		УстановитьКатегориюДоходаДляКатегорииНачисления(
			СоответствиеКодов, 
			ВидДохода,
			Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоходВНатуральнойФорме,
			Перечисления.КатегорииДоходовНДФЛ.ПрочиеНатуральныеДоходы);
	КонецЦикла;
	
	Возврат СоответствиеКодов;
	
КонецФункции

Процедура УстановитьКатегориюДоходаДляКатегорииНачисления(СоответствиеКодов, ВидДохода, КатегорияНачисления, КатегорияДохода)
	
	СтрокиОписания = СоответствиеКодов.НайтиСтроки(Новый Структура("КодДохода", ВидДохода));
	Если СтрокиОписания.Количество() > 0 Тогда
		КатегорииДоходов = Новый Массив;
		Для Каждого СтрокаОписания Из СтрокиОписания Цикл
			Если СтрокаОписания.КатегорияДохода <> КатегорияДохода Тогда
				КатегорииДоходов.Добавить(СтрокаОписания.КатегорияДохода);
			КонецЕсли;
			СоответствиеКодов.Удалить(СтрокаОписания)
		КонецЦикла;
		Если КатегорииДоходов.Количество() > 0 Тогда
			ОсновнаяКатегория = КатегорииДоходов[0];
			КатегорииДоходов.Удалить(0);
			УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, ВидДохода, 
											ОсновнаяКатегория,
											КатегорииДоходов);
		КонецЕсли;
		УчетФактическиПолученныхДоходов.НовоеСоответствиеКодуДохода(СоответствиеКодов, ВидДохода, 
										КатегорияДохода,
										,
										КатегорияНачисления);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПеренестиВыплаченныйДоходНаДату(Движения, Ведомость, ДатаВыплаты, ДатаОперации, Отказ, Регистратор = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Ведомость);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СведенияОДоходахНДФЛ.*
	|ИЗ
	|	РегистрНакопления.СведенияОДоходахНДФЛ КАК СведенияОДоходахНДФЛ
	|ГДЕ
	|	СведенияОДоходахНДФЛ.Регистратор = &Регистратор
	|	И СведенияОДоходахНДФЛ.УстаревшаяДатаПолученияДохода <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.*
	|ИЗ
	|	РегистрНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ КАК РасчетыНалогоплательщиковСБюджетомПоНДФЛ
	|ГДЕ
	|	РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Регистратор = &Регистратор
	|	И (РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				И РасчетыНалогоплательщиковСБюджетомПоНДФЛ.УстаревшаяДатаПолученияДохода <> ДАТАВРЕМЯ(1, 1, 1)
	|			ИЛИ РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БухучетНачисленияУдержанияПоСотрудникам.*
	|ИЗ
	|	РегистрНакопления.БухучетНачисленияУдержанияПоСотрудникам КАК БухучетНачисленияУдержанияПоСотрудникам
	|ГДЕ
	|	БухучетНачисленияУдержанияПоСотрудникам.Регистратор = &Регистратор
	|	И БухучетНачисленияУдержанияПоСотрудникам.УстаревшаяДатаПолученияДохода <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НДФЛКПеречислению.*
	|ИЗ
	|	РегистрНакопления.НДФЛКПеречислению КАК НДФЛКПеречислению
	|ГДЕ
	|	НДФЛКПеречислению.Регистратор = &Регистратор";
	Результат = Запрос.ВыполнитьПакет();
	
	// Учет доходов для исчисления НДФЛ
	Если Не Результат[0].Пустой() Тогда
		Выборка = Результат[0].Выбрать();
		Пока Выборка.Следующий() Цикл
			НовоеДвижение = Движения.СведенияОДоходахНДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			НовоеДвижение.СуммаДохода = - НовоеДвижение.СуммаДохода;
			НовоеДвижение.СуммаВычета = - НовоеДвижение.СуммаВычета;
			
			НовоеДвижение = Движения.СведенияОДоходахНДФЛ.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			НовоеДвижение.ДатаПолученияДохода = ДатаВыплаты;
			НовоеДвижение.МесяцНалоговогоПериода = НачалоМесяца(ДатаВыплаты);
			НовоеДвижение.Период = ДатаОперации;
		КонецЦикла;
		Движения.СведенияОДоходахНДФЛ.Записывать = Истина;
	КонецЕсли;
	
	НепереносимыеКатегорииДохода = Перечисления.КатегорииДоходовНДФЛ.СФиксированнойДатойПолученияДохода();
	
	// Расчеты налогоплательщиков с бюджетом по НДФЛ
	Если Не Результат[1].Пустой() Тогда
		ФизическиеЛица = Новый Массив;
		Организация = Неопределено;
		Выборка = Результат[1].Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Выборка.ВидДвижения = ВидДвиженияНакопления.Приход Тогда
				
				ФизическиеЛица.Добавить(Выборка.ФизическоеЛицо);
				Если Не ЗначениеЗаполнено(Организация) Тогда
					Организация = Выборка.Организация
				КонецЕсли;
				
				НовоеДвижение = Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДобавитьПриход();
				ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
				НовоеДвижение.Сумма = - НовоеДвижение.Сумма;
				НовоеДвижение.СуммаСПревышения = - НовоеДвижение.СуммаСПревышения;
				НовоеДвижение.СуммаВыплаченногоДохода = - НовоеДвижение.СуммаВыплаченногоДохода;
				
				НовоеДвижение = Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДобавитьПриход();
				ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
				НовоеДвижение.МесяцНалоговогоПериода = ДатаВыплаты;
				НовоеДвижение.Период = ДатаОперации;
			Иначе
				НовоеДвижение = Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДобавитьРасход();
				ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
				НовоеДвижение.Сумма = - НовоеДвижение.Сумма;
				НовоеДвижение.СуммаСПревышения = - НовоеДвижение.СуммаСПревышения;
				НовоеДвижение.СуммаВыплаченногоДохода = - НовоеДвижение.СуммаВыплаченногоДохода;
				
				НовоеДвижение = Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.ДобавитьРасход();
				ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
				НовоеДвижение.УстаревшаяДатаПолученияДохода = Выборка.МесяцНалоговогоПериода;
				НовоеДвижение.МесяцНалоговогоПериода = ДатаВыплаты;
				НовоеДвижение.Период = ДатаОперации;
				НовоеДвижение.КрайнийСрокУплаты = Неопределено;
				Если Выборка.ДатаПолученияДоходаФиксирована 
					Или НепереносимыеКатегорииДохода.Найти(Выборка.КатегорияДохода) <> Неопределено Тогда
					НовоеДвижение.МесяцНалоговогоПериода = Выборка.МесяцНалоговогоПериода;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Движения.РасчетыНалогоплательщиковСБюджетомПоНДФЛ.Записывать = Истина;
		Если ФизическиеЛица.Количество() > 0 И ЗначениеЗаполнено(Регистратор) И Движения.Найти("ДокументыУчтенныеПриРасчетеНДФЛ") <> Неопределено Тогда
			УчетНДФЛ.СформироватьДокументыУчтенныеПриРасчетеДляМежрасчетногоДокумента(Движения, Отказ, Организация, ФизическиеЛица, Регистратор); 	
		КонецЕсли;
	КонецЕсли;
	
	// Бухучет начисления удержания по сотрудникам
	Если Не Результат[2].Пустой() Тогда
		Выборка = Результат[2].Выбрать();
		Пока Выборка.Следующий() Цикл
			НовоеДвижение = Движения.БухучетНачисленияУдержанияПоСотрудникам.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			НовоеДвижение.Сумма = - НовоеДвижение.Сумма;
			
			НовоеДвижение = Движения.БухучетНачисленияУдержанияПоСотрудникам.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			НовоеДвижение.ДатаПолученияДохода = ДатаВыплаты;
		КонецЦикла;
		Движения.БухучетНачисленияУдержанияПоСотрудникам.Записывать = Истина;
	КонецЕсли;
	
	// НДФЛ к перечислению
	Если Не Результат[3].Пустой() Тогда
		Выборка = Результат[3].Выбрать();
		Организация = Неопределено;
		Пока Выборка.Следующий() Цикл
			НовоеДвижение = Движения.НДФЛКПеречислению.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			НовоеДвижение.Сумма = - НовоеДвижение.Сумма;
			НовоеДвижение.СуммаСПревышения = - НовоеДвижение.СуммаСПревышения;
			Если Не ЗначениеЗаполнено(Организация) Тогда
				Организация = Выборка.Организация
			КонецЕсли;
			НовоеДвижение = Движения.НДФЛКПеречислению.Добавить();
			ЗаполнитьЗначенияСвойств(НовоеДвижение, Выборка, , "Регистратор");
			Если НепереносимыеКатегорииДохода.Найти(Выборка.КатегорияДохода) <> Неопределено Тогда
				НовоеДвижение.МесяцНалоговогоПериода = Выборка.МесяцНалоговогоПериода;
			Иначе
				НовоеДвижение.МесяцНалоговогоПериода = ДатаВыплаты;
			КонецЕсли;
			НовоеДвижение.Период = ДатаОперации;
			НовоеДвижение.КрайнийСрокУплаты = Неопределено;
		КонецЦикла;
		ТаблицаДвижений = Движения.НДФЛКПеречислению.Выгрузить();
		ТаблицаДвижений.Колонки.Добавить("СуммаВыплаченногоДохода", ОбщегоНазначения.ОписаниеТипаЧисло(15,2)); 
		УчетНДФЛ.ПроставитьКрайнийСрокУплаты(ТаблицаДвижений, Организация);
		Движения.НДФЛКПеречислению.Очистить();
		Движения.НДФЛКПеречислению.Загрузить(ТаблицаДвижений);
		Движения.НДФЛКПеречислению.Записывать = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.РасчетыСБюджетомПоНДФЛ") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетыСБюджетомПоНДФЛ");
		Модуль.ПеренестиВыплаченныйДоходНаДату(Движения, Ведомость, ДатаОперации, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

