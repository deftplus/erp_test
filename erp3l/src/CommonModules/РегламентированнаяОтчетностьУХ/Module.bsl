
#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьРегламентированныйОтчетНалогНаПрибыль(ПараметрыОтчета, Контейнер, ТаблицаРасшифровки, ИДРедакцииОтчета) Экспорт
	
	Лист09 = Неопределено;
	Если НЕ Контейнер.Свойство("Лист09", Лист09) Тогда
		Возврат; // Не передан лист 09 декларации
	КонецЕсли;
	Если ИДРедакцииОтчета = "ФормаОтчета2016Кв4" Тогда
		СтрокиЛиста = Лист09;
		ДанныеШаблонаЛиста = ?(Лист09.Количество(), Лист09[0].Данные[0].Значение, Новый Структура);
		Если Контейнер.Лист09.Количество() > 0 И Контейнер.Лист09[0].ДанныеДопСтрок.Количество() > 0 И Контейнер.Лист09[0].ДанныеДопСтрок[0].Значение.Количество() > 0 Тогда
			Шаблон_ДанныеДопСтрок = Контейнер.Лист09[0].ДанныеДопСтрок[0].Значение.Выгрузить().Колонки;
		Иначе
			Шаблон_ДанныеДопСтрок = Новый Структура;
		КонецЕсли;
	Иначе
		СтрокиЛиста = Лист09.Строки;
		ДанныеШаблонаЛиста = Лист09.Строки[0].Данные;
		Шаблон_ДанныеДопСтрок = Лист09.Строки[0].ДанныеМногострочныхЧастей.П009П1М1.Строки[0].Данные;
	КонецЕсли;
	
 	ДанныеИсточник = Новый Структура;
	Для каждого ПоказательШаблона Из ДанныеШаблонаЛиста Цикл	
		ДанныеИсточник.Вставить(ПоказательШаблона.Ключ, ?(ТипЗнч(ПоказательШаблона.Значение) = Тип("Строка"), "", 0) );
	КонецЦикла;
	
	ДанныеИсточникМЧ = Новый Структура;
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка");
	Для каждого ПоказательШаблона Из Шаблон_ДанныеДопСтрок Цикл
		Если ИДРедакцииОтчета = "ФормаОтчета2016Кв4" Тогда
			ДанныеИсточникМЧ.Вставить(ПоказательШаблона.Имя, ?(ПоказательШаблона.ТипЗначения = ОписаниеТипаСтрока, "", 0) );
		Иначе
			ДанныеИсточникМЧ.Вставить(ПоказательШаблона.Ключ, ?(ТипЗнч(ПоказательШаблона.Значение) = Тип("Строка"), "", 0));
		КонецЕсли;
	КонецЦикла;
	
	Дата1 = ПараметрыОтчета.мДатаНачалаПериодаОтчета;
	Дата2 = ПараметрыОтчета.мДатаКонцаПериодаОтчета;
	ДатаФормирования = ПараметрыОтчета.ДатаПодписи;
		
	ОрганизацияКЛ = ПараметрыОтчета.Организация;
	ИмяКонстантыСценария = "СценарийОтчетностиКИК";
	СценарийКИК = Константы[ИмяКонстантыСценария].Получить();
	ВалютаКЛ = Константы.ВалютаРегламентированногоУчета.Получить();
	Период = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(Дата1, Перечисления.Периодичность.Год, 0, Истина);
		
	ПоказателиОтчетовДекларации = ПолучитьКэшПоказателейДекларации("РегламентированныйОтчетПрибыль", ИДРедакцииОтчета);
	КэшНомераИнвестиций = ПолучитьНомераИнвестиций(ОрганизацияКЛ);
	КэшЭффективныеДоли = ПолучитьЭффективныеДоли(ОрганизацияКЛ, СценарийКИК, Дата2);
	КэшКодыДекларации = ПолучитьСоответствиеКодовДекларации(ПоказателиОтчетовДекларации, "КодЭлементаНалоговойДекларации");
	КонтактнаяИнформация = Новый Соответствие;
	
	ТабЗначенияПоказателейВал = ТаблицыПоказателейНаСервере(ПоказателиОтчетовДекларации.ВыгрузитьКолонку("ПоказательОтчета"), ОрганизацияКЛ, СценарийКИК, Период);
	ТабЗначенияПоказателейВал.Индексы.Добавить("ОсновнаяВалюта");
	
	ТабСтраницы = ТабЗначенияПоказателейВал.Скопировать(, "Организация");
	ТабСтраницы.Свернуть("Организация");
	
	ОчиститьПередЗаполнениемСписокЛистов = Истина;
	
	Для каждого СтрокаСтраница Из ТабСтраницы Цикл
	
		ДанныеПриемник = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДанныеИсточник);
		ДанныеПриемникМЧ = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДанныеИсточникМЧ);
		
		СтрокаВалюты = ТабЗначенияПоказателейВал.Найти(СтрокаСтраница.Организация, "Организация");
		
		ВалютаОрганизации = ?(СтрокаВалюты = Неопределено, ВалютаКЛ, СтрокаВалюты.ОсновнаяВалюта);
		
		РеквизитыШапки = ПолучитьРеквизитыШапкиЛист9(СтрокаСтраница.Организация, КэшНомераИнвестиций, КэшЭффективныеДоли, КонтактнаяИнформация, 
								ВалютаОрганизации, Дата2, ИДРедакцииОтчета);
		ЗаполнитьЗначенияСвойств(ДанныеПриемник, РеквизитыШапки);
		
		ЗаполнитьЛистДекларацииИзЭкземпляра(ДанныеПриемник, КэшКодыДекларации, СтрокаСтраница.Организация, 
							ТабЗначенияПоказателейВал, ТаблицаРасшифровки);
							
		ЗаполнитьЛистДекларацииИзЭкземпляра(ДанныеПриемникМЧ, КэшКодыДекларации, СтрокаСтраница.Организация, 
							ТабЗначенияПоказателейВал, ТаблицаРасшифровки);
							
		Если ИДРедакцииОтчета = "ФормаОтчета2016Кв4" Тогда 
			ДобавитьДанныеНаЛист9(ДанныеПриемник, Лист09, ОчиститьПередЗаполнениемСписокЛистов, ДанныеПриемникМЧ);
		Иначе
			Если ОчиститьПередЗаполнениемСписокЛистов Тогда
				ОчиститьДанныеЛиста(ИДРедакцииОтчета, СтрокиЛиста, ДанныеИсточник, ТаблицаРасшифровки);
				ОчиститьПередЗаполнениемСписокЛистов = Ложь;
				СтрокаЛиста = СтрокиЛиста[0];
			Иначе
				СтрокаЛиста = СтрокиЛиста.Добавить();
			КонецЕсли;
			СтрокаЛиста.Данные = ДанныеПриемник;
			СтрокаЛиста.Данные.ПризнакВключения = "V";
			СтрокаЛиста.ДанныеМногострочныхЧастей = ЗавернутьВДеревоВСтруктуру(ДанныеПриемникМЧ, "П009П1М1");
		КонецЕсли;
		
	КонецЦикла;
	
	Если (ОчиститьПередЗаполнениемСписокЛистов = Истина) И СтрокиЛиста.Количество() Тогда 
		
		//Нет ни одной страницы - удалим все кроме первой, у первой очистим показатели
		ОчиститьДанныеЛиста(ИДРедакцииОтчета, СтрокиЛиста, ДанныеИсточник, ТаблицаРасшифровки);		
		
	КонецЕсли;
	
КонецПроцедуры

Функция ЗавернутьВДеревоВСтруктуру(Данные, ИмяПоляСтруктуры)
	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("Данные");
	Дерево.Колонки.Добавить("ДанныеМногострочныхЧастей");
	НовСтр = Дерево.Строки.Добавить();
	НовСтр.Данные = Данные;
	НовСтр.ДанныеМногострочныхЧастей = Новый Структура;
	Возврат Новый Структура(ИмяПоляСтруктуры, Дерево);
КонецФункции

Процедура ОчиститьДанныеЛиста(ВидФормы, СтрокиЛиста, Шаблон, ТаблицаРасшифровки)
	Для НомерУдаляемого = 0 По (СтрокиЛиста.Количество() - 2) Цикл
		СтрокиЛиста.Удалить(СтрокиЛиста.Количество() - 1 - НомерУдаляемого);
	КонецЦикла;
	
	Если ВидФормы = "ФормаОтчета2016Кв4" Тогда
		СтрокиЛиста[0].Данные[0].Значение = Шаблон;
	Иначе
		СтрокиЛиста[0].Данные = Шаблон;
	КонецЕсли;
	
	Для каждого ПоказательОчистки Из Шаблон Цикл		
		РасшифровкиДляУдаления = ТаблицаРасшифровки.НайтиСтроки(Новый Структура("ИмяПоказателя", ПоказательОчистки.Ключ));
		Для каждого РасшифровкаУдаления Из РасшифровкиДляУдаления Цикл
			ТаблицаРасшифровки.Удалить(РасшифровкаУдаления);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ТаблицуЛистаВСтуктуру(Данные, ДанныеДопСтрок)
	Для каждого Строка Из ДанныеДопСтрок Цикл
		Для каждого Колонка Из ДанныеДопСтрок.Колонки Цикл
			Данные.Вставить(Колонка.Имя + "_" + (ДанныеДопСтрок.Индекс(Строка) + 1), Строка[Колонка.Имя]);//СтрокаЛиста.Данные[0].Значение
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура ДобавитьЛист(СтрокаЛиста, ДанныеДопСтрок, Индекс, ДанныеЗаполнения)
	ТаблицаДопСтрок = ДанныеДопСтрок.СкопироватьКолонки();
	НовСтрока = ТаблицаДопСтрок.Добавить();
	НовСтрока.П000400001031 = 1;
	ЗаполнитьЗначенияСвойств(НовСтрока, ДанныеЗаполнения);
	Данные = Новый Структура;
	ТаблицуЛистаВСтуктуру(Данные, ТаблицаДопСтрок);
	Данные.Вставить("П000400001001", 13);
	СтрокаЛиста.Представление = "Лист N " + Формат(Индекс, "ЧГ=");
	Список = Новый СписокЗначений;
	Список.Добавить(Данные);
	СтрокаЛиста.Данные = Список;
	СтрокаЛиста.ДанныеДопСтрок = ТаблицаДопСтрок;
КонецПроцедуры

Процедура ЗаполнитьРегламентированныйОтчет3НДФЛ(ПараметрыОтчета, Контейнер, ТаблицаРасшифровки, ИДРедакцииОтчета) Экспорт
	
	ЛистБ = Неопределено;
	Если Контейнер.Свойство("ЛистБ", ЛистБ) Тогда
		ВерсияАлгоритма = 1;
	ИначеЕсли Контейнер.Свойство("Приложение2", ЛистБ) Тогда
		ВерсияАлгоритма = 2;
	Иначе
		Возврат; // Не передан лист декларации
	КонецЕсли;
	
	Если ВерсияАлгоритма = 1 Тогда
		ДанныеДопСтрок = ЛистБ[0].ДанныеДопСтрок.СкопироватьКолонки();
	Иначе
		ДанныеДопСтрок = Новый Структура;
		ПустаяСтруктура = Новый Структура;
		Для каждого Ключ Из ЛистБ[0].Данные[0].Значение Цикл
		    ПустаяСтруктура.Вставить(Ключ.Ключ);
		КонецЦикла;
	КонецЕсли;
		
	Дата1 = ПараметрыОтчета.мДатаНачалаПериодаОтчета;
	Дата2 = ПараметрыОтчета.мДатаКонцаПериодаОтчета;
		
	ОрганизацияКЛ = ПараметрыОтчета.Организация;
	ИмяКонстантыСценария = "СценарийОтчетностиКИК";
	СценарийКИК = Константы[ИмяКонстантыСценария].Получить();
	ВалютаКЛ = Константы.ВалютаРегламентированногоУчета.Получить();
	Период = ОбщегоНазначенияУХ.глОтносительныйПериодПоДате(Дата1, Перечисления.Периодичность.Год, 0, Истина);
		
	ПоказателиОтчетовДекларации = ПолучитьКэшПоказателейДекларации("РегламентированныйОтчет3НДФЛ", ИДРедакцииОтчета);
	НомераИнвестиций = ПолучитьНомераИнвестиций(ОрганизацияКЛ);
	ЭффективныеДоли = ПолучитьЭффективныеДоли(ОрганизацияКЛ, СценарийКИК, Дата2);
	КэшКодыДекларации = ПолучитьСоответствиеКодовДекларации(ПоказателиОтчетовДекларации, "КодЭлементаНДФЛ");
	КонтактнаяИнформация = Новый Соответствие;
	
	ТабЗначенияПоказателейВал = ТаблицыПоказателейНаСервере(ПоказателиОтчетовДекларации.ВыгрузитьКолонку("ПоказательОтчета"), ОрганизацияКЛ, СценарийКИК, Период);
	ТабЗначенияПоказателейВал.Индексы.Добавить("ОсновнаяВалюта");
	
	ТабСтраницы = ТабЗначенияПоказателейВал.Скопировать(, "Организация");
	ТабСтраницы.Свернуть("Организация");
	
	Если ТабСтраницы.Количество() <> 0 Тогда
		ЛистБ.Очистить();
	КонецЕсли;
	
	ОчиститьПередЗаполнениемСписокЛистов = Истина;
	
	Индекс = 1;
	Для каждого СтрокаСтраница Из ТабСтраницы Цикл
		ДанныеЗаполнения = Новый Структура;
		Если ВерсияАлгоритма = 2 Тогда
			ДанныеЗаполнения = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ПустаяСтруктура);
		КонецЕсли;
		ДанныеЗаполнения.Вставить("П000400001020", СтрокаСтраница.Организация);
		ДанныеЗаполнения.Вставить("П000400001010", СтрокаСтраница.Организация.СтранаРегистрации.Код);
		КодОрганизации = НомераИнвестиций.Получить(СтрокаСтраница.Организация);
		Если КодОрганизации <> Неопределено Тогда
			ДанныеЗаполнения.Вставить("П000400001032", КодОрганизации);
		КонецЕсли;
		ЗначенияСтраницы = ТабЗначенияПоказателейВал.НайтиСтроки(Новый Структура("Организация", СтрокаСтраница.Организация));
		
		Для каждого ЗначениеСтраницы Из ЗначенияСтраницы Цикл
			ДанныеЗаполнения.Вставить("П000400001030", ЗначениеСтраницы.КодВалюты);
			КодДекларации = КэшКодыДекларации.Получить(ЗначениеСтраницы.ПоказательОтчета);
			Если КодДекларации = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ТекущееЗначение = ЗначениеСтраницы.Значение;
			ПреобразованиеБулевыхТипов(ТекущееЗначение, КодДекларации, "");
			//П000400001120  П000400001130
			ПреобразованиеЧисловыхТипов(ТекущееЗначение, КодДекларации);
			ДанныеЗаполнения.Вставить(КодДекларации, ТекущееЗначение);
		КонецЦикла;
		
		НовСтр = ЛистБ.Добавить();
		Если ВерсияАлгоритма = 1 Тогда
			ДобавитьЛист(НовСтр, ДанныеДопСтрок, Индекс, ДанныеЗаполнения);
		ИначеЕсли ВерсияАлгоритма = 2 Тогда
			ДанныеЗаполнения.Вставить("П000400001001", 13);
			Сп = Новый СписокЗначений;
			Сп.Добавить(ДанныеЗаполнения);
			НовСтр.Данные = Сп;
			НовСтр.ДанныеДопСтрок = ДанныеДопСтрок;
			НовСтр.Представление = "Лист N " + Формат(Индекс, "ЧГ=");
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Контейнер, ПараметрыОтчета.АдресВоВременномХранилище);
	
КонецПроцедуры

Функция ПолучитьКодИО(ЭтоИС, НомерУчастника) Экспорт
	Возврат ?(ЭтоИС, "ИС-", "ИО-") + Формат(НомерУчастника, "ЧЦ=5; ЧВН=; ЧГ=0");
КонецФункции

Функция ПроверитьЗаполненностьМодели(Отказ = Ложь) Экспорт
	
	СтруктураГотовности = Новый Структура();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СтрокиОтчетов.Ссылка
		|ИЗ
		|	Справочник.СтрокиОтчетов КАК СтрокиОтчетов
		|ГДЕ
		|	СтрокиОтчетов.ЭлементСправочникаБД ССЫЛКА Справочник.СтатьиДоходовИРасходовКИК";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		СтруктураГотовности.Вставить("НеЗаполненСписокСтатей", Истина);
		Отказ = Истина;
	Иначе
		СтруктураГотовности.Вставить("НеЗаполненСписокСтатей", Ложь);
	КонецЕсли;
	
	Возврат СтруктураГотовности;
	
КонецФункции

Процедура ПолучитьСведенияОПоказателяхСтрановойОтчет(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	ПоказателиОтчета.Вставить("НаимМГ", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимМГЛат", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ЧислРабШтатР2", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020001002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020004002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020005002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020006002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020007002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020008002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020009002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("П000020010002", РасчетПоказателей);
	ПоказателиОтчета.Вставить("СтрНалРезидР2", РасчетПоказателей);
	ПоказателиОтчета.Вставить("СтатУчМГР1", РасчетПоказателей);
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхУчастиеВМеждународнойГруппеКомпаний(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	ПоказателиОтчета.Вставить("НаимМГ", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимМГЛат", РасчетПоказателей);
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхРискиОрганизацииНалоговыйМониторинг(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	//ПоказателиОтчета.Вставить("КодНО", РасчетПоказателей);
	ПоказателиОтчета.Вставить("Наименование", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ОКВЭД", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ОблРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ОписРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НапрРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КатегорРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодНалог", РасчетПоказателей);
	ПоказателиОтчета.Вставить("Статья", РасчетПоказателей);
	ПоказателиОтчета.Вставить("Пункт", РасчетПоказателей);
	ПоказателиОтчета.Вставить("Подпункт", РасчетПоказателей);
	ПоказателиОтчета.Вставить("Абзац", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ВероятРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ПоследРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("УровРискОрг", РасчетПоказателей);
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхМатрицаРисковКП(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	ПоказателиОтчета.Вставить("ГодНМ", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимКП", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("НаимРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("ОписРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("НапрРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("КатегорРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("КодНалог", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Статья", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Пункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Подпункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("ВероятРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("УровРискОрг", РасчетПоказателей);
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхКонтрольныеПроцедуры(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	ПоказателиОтчета.Вставить("НапрРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ОписКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ЧастотПров", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ВидКонтрол", РасчетПоказателей);
	ПоказателиОтчета.Вставить("УровКонтр", РасчетПоказателей);
	ПоказателиОтчета.Вставить("СпособПров", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ДокПодКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("АвтЗапВыпКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("ОтвПодр", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Пункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Подпункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("ВероятРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("УровРискОрг", РасчетПоказателей);
КонецПроцедуры

Процедура ПолучитьСведенияОПоказателяхРезультатыВыполнения(ИДРедакцииОтчета, ПоказателиОтчета, ПараметрыОтчета) Экспорт
	РасчетПоказателей = Новый Массив;
	РасчетПоказателей.Добавить(Истина);
	РасчетПоказателей.Добавить(Ложь);
	РасчетПоказателей.Добавить(Ложь);
	//ПоказателиОтчета.Вставить("ГодНМ", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("КодРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("НаимРиск", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КодКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("НаимКП", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КолКПОтч", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КолКПОшиб", РасчетПоказателей);
	ПоказателиОтчета.Вставить("КолКПНеОшиб", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("КатегорРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("КодНалог", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Статья", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Пункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("Подпункт", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("ВероятРиск", РасчетПоказателей);
	//ПоказателиОтчета.Вставить("УровРискОрг", РасчетПоказателей);
КонецПроцедуры

Процедура ЗаполнитьСтрановойОтчет(ПараметрыОтчета, Контейнер) Экспорт
	ИмяОбработкиМСО = "ПодготовкаМежстрановойОтчетности";
	Обработка = Обработки[ИмяОбработкиМСО].Создать();
	Обработка.ЗаполнитьСтрановойОтчет(ПараметрыОтчета, Контейнер);
КонецПроцедуры

Процедура ЗаполнитьУчастиеВМеждународнойГруппеКомпаний(ПараметрыОтчета, Контейнер) Экспорт
	ИмяОбработкиМСО = "ПодготовкаМежстрановойОтчетности";
	Обработка = Обработки[ИмяОбработкиМСО].Создать();
	Обработка.ЗаполнитьУчастиеВМеждународнойГруппеКомпаний(ПараметрыОтчета, Контейнер);
КонецПроцедуры

Процедура ЗаполнитьМатрицуРисковКП(ПараметрыОтчета, Контейнер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.Код КАК КодКП,
		|	НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.Наименование КАК НаимКП,
		|	НастройкиИспользованияШаблоновМероприятий.Контекст.Код КАК КодРиск,
		|	НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.Наименование КАК НаимРиск
		|ИЗ
		|	РегистрСведений.НастройкиИспользованияШаблоновМероприятий КАК НастройкиИспользованияШаблоновМероприятий
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШаблоныМероприятий КАК ШаблоныМероприятий
		|		ПО НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия = ШаблоныМероприятий.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Риски КАК Риски
		|		ПО НастройкиИспользованияШаблоновМероприятий.Контекст = Риски.Ссылка
		|ГДЕ
		|	НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.ВидМероприятия = ЗНАЧЕНИЕ(Перечисление.ВидыМероприятий.КонтрольноеМероприятие)
		|	И НастройкиИспользованияШаблоновМероприятий.Контекст.ПометкаУдаления = ЛОЖЬ
		|	И НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.ПометкаУдаления = ЛОЖЬ
		|	И НастройкиИспользованияШаблоновМероприятий.ШаблонМероприятия.УчитываетсяВНалоговомМониторинге";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтр = Контейнер.МатрицРискКП.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);
		НовСтр.УИД = Новый УникальныйИдентификатор();
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьРезультатыВыполнения(ПараметрыОтчета, Контейнер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныМероприятий.Код КАК КодКП,
		|	ШаблоныМероприятий.Наименование КАК НаимКП,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Мероприятие.Ссылка) КАК КолКПОтч,
		|	СУММА(ВЫБОР
		|			КОГДА Мероприятие.РезультатВыполнения = ЗНАЧЕНИЕ(Перечисление.СостоянияВыполненияКонтрольныхПроцедур.ВыполненоУспешно)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КолКПНеОшиб,
		|	СУММА(ВЫБОР
		|			КОГДА Мероприятие.РезультатВыполнения = ЗНАЧЕНИЕ(Перечисление.СостоянияВыполненияКонтрольныхПроцедур.ВыполненоСОшибками)
		|				ТОГДА 1
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК КолКПОшиб
		|ИЗ
		|	Документ.Мероприятие КАК Мероприятие
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШаблоныМероприятий КАК ШаблоныМероприятий
		|		ПО Мероприятие.ШаблонМероприятия = ШаблоныМероприятий.Ссылка
		|ГДЕ
		|	ШаблоныМероприятий.ВидМероприятия = ЗНАЧЕНИЕ(Перечисление.ВидыМероприятий.КонтрольноеМероприятие)
		|	И ШаблоныМероприятий.ПометкаУдаления = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	ШаблоныМероприятий.Код,
		|	ШаблоныМероприятий.Наименование";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтр = Контейнер.РезКП.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);
		НовСтр.УИД = Новый УникальныйИдентификатор();
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьРискиОрганизацииНалоговыйМониторинг(ПараметрыОтчета, Контейнер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Риски.Код КАК КодРиск,
		|	Риски.Наименование КАК НаимРиск,
		|	Риски.Описание КАК ОписРиск,
		|	Риски.НаправлениеРиска КАК НапрРиск,
		|	Риски.КодНалога КАК КодНалог,
		|	Риски.СтатьяНК КАК Статья,
		|	Риски.СтатьяНКПункт КАК Пункт,
		|	Риски.СтатьяНКПодпункт КАК Подпункт,
		|	Риски.СтатьяНКАбзац КАК Абзац,
		|	Риски.ОценкаПоследствий / 1000 КАК ПоследРиск,
		|	Риски.Категория КАК КатегорРиск,
		|	Риски.УровеньРиска КАК УровеньРиска,
		|	Риски.Ссылка КАК Ссылка,
		|	Риски.Вероятность КАК Вероятность,
		|	Риски.КодОКВЭД2 КАК ОКВЭД,
		|	Риски.ОбластьРиска КАК ОблРиск
		|ИЗ
		|	Справочник.Риски КАК Риски
		|ГДЕ
		|	Риски.УчитываетсяВНалоговомМониторинге
		|	И Риски.ПометкаУдаления = ЛОЖЬ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтр = Контейнер.РискОргНМ.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);
		Если ВыборкаДетальныеЗаписи.УровеньРиска = Справочники.УровниРиска.Низкий Тогда
			НовСтр.УровРискОрг = 1;
		ИначеЕсли ВыборкаДетальныеЗаписи.УровеньРиска = Справочники.УровниРиска.Средний Тогда
			НовСтр.УровРискОрг = 2;
		ИначеЕсли ВыборкаДетальныеЗаписи.УровеньРиска = Справочники.УровниРиска.Высокий Тогда
			НовСтр.УровРискОрг = 3;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.Вероятность = Справочники.ВероятностиРисков.ОченьНизкая Тогда
			НовСтр.ВероятРиск = "01";
		ИначеЕсли ВыборкаДетальныеЗаписи.Вероятность = Справочники.ВероятностиРисков.Низкая Тогда
			НовСтр.ВероятРиск = "02";
		ИначеЕсли ВыборкаДетальныеЗаписи.Вероятность = Справочники.ВероятностиРисков.Средняя Тогда
			НовСтр.ВероятРиск = "03";
		ИначеЕсли ВыборкаДетальныеЗаписи.Вероятность = Справочники.ВероятностиРисков.Высокая Тогда
			НовСтр.ВероятРиск = "04";
		ИначеЕсли ВыборкаДетальныеЗаписи.Вероятность = Справочники.ВероятностиРисков.ОченьВысокая Тогда
			НовСтр.ВероятРиск = "05";
		КонецЕсли;
		НовСтр.УИД = Новый УникальныйИдентификатор();
	КонецЦикла;

КонецПроцедуры

Процедура ЗаполнитьКонтрольныеПроцедуры(ПараметрыОтчета, Контейнер) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ШаблоныМероприятий.Код КАК КодКП,
		|	ШаблоныМероприятий.Наименование КАК НаимКП,
		|	ШаблоныМероприятий.ЧастотаПроведения КАК ЧастотПров,
		|	ШаблоныМероприятий.ВидКонтрольнойПроцедуры КАК ВидКонтрол,
		|	ШаблоныМероприятий.УровеньКонтроля КАК УровКонтр,
		|	ШаблоныМероприятий.СпособПроведения КАК СпособПров,
		|	ШаблоныМероприятий.НаправлениеВыявленияРисков КАК НапрРиск,
		|	0 КАК ДокПодКП,
		|	1 КАК АвтЗапВыпКП,
		|	ШаблоныМероприятий.ОтветственноеПодразделение КАК ОтвПодр,
		|	ШаблоныМероприятий.Описание КАК ОписКП,
		|	ШаблоныМероприятий.ИнформационнаяСистема.Код КАК НомерИС,
		|	ШаблоныМероприятий.ИнформационнаяСистема.Наименование КАК НаимИС,
		|	ШаблоныМероприятий.ИнформационнаяСистема.ВидИнформационнойСистемы КАК ВидИСОрг,
		|	ВЫБОР
		|		КОГДА ШаблоныМероприятий.ИнформационнаяСистема.НаличиеПерсональныхДанных
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПризНалПД,
		|	ВЫБОР
		|		КОГДА ШаблоныМероприятий.ИнформационнаяСистема.ДляНесколькихОрганизаций
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ПризНалДанДр,
		|	ВЫБОР
		|		КОГДА ШаблоныМероприятий.ИнформационнаяСистема.ДоступноНалоговомуОргану = ИСТИНА
		|			ТОГДА ""1""
		|		ИНАЧЕ ""0""
		|	КОНЕЦ КАК ПризДоступИС
		|ИЗ
		|	Справочник.ШаблоныМероприятий КАК ШаблоныМероприятий
		|ГДЕ
		|	ШаблоныМероприятий.ВидМероприятия = ЗНАЧЕНИЕ(Перечисление.ВидыМероприятий.КонтрольноеМероприятие)
		|	И ШаблоныМероприятий.ПометкаУдаления = ЛОЖЬ
		|	И ШаблоныМероприятий.УчитываетсяВНалоговомМониторинге";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НовСтр = Контейнер.КонтрПроцНМ.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, ВыборкаДетальныеЗаписи);
		НовСтр.УИД = Новый УникальныйИдентификатор();
		НовСтр2 = Контейнер.СвИнфСист.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр2, ВыборкаДетальныеЗаписи);
		НовСтр2.УИД = Новый УникальныйИдентификатор();
		НовСтр2.УИДРодителя = НовСтр.УИД;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТаблицыПоказателейНаСервере(СписокПоказателей, Организация, Сценарий, Период, Валюта = Неопределено)
	
	ОтборВерсий = Новый Структура("Аналитика1, Сценарий, ПериодОтчета", Организация, Сценарий, Период); 
	Если Валюта = Неопределено Тогда
		ОтборВерсий.Вставить("ИспользоватьОсновнуюВалюту", Истина);
	Иначе
		ОтборВерсий.Вставить("Валюта", Валюта);
	КонецЕсли;
	
	ОтборПоказателей = Новый Соответствие();
	ОтборПоказателей.Вставить("ПоказательОтчета", СписокПоказателей);
	ОтборПоказателей.Вставить("Версия.Аналитика1", Организация);
	
	ПоляВыборки = Новый Соответствие();
	ПоляВыборки.Вставить("ПоказательОтчета");
	ПоляВыборки.Вставить("Значение");
	ПоляВыборки.Вставить("Аналитика1");
	ПоляВыборки.Вставить("Организация");
	ПоляВыборки.Вставить("ОсновнаяВалюта", "Версия.Валюта");
	ПоляВыборки.Вставить("КодВалюты", "Версия.Валюта.Код");
	ПоляВыборки.Вставить("ЭкземплярОтчета", "Версия.ЭкземплярОтчета");
		
	ДопПараметры = Новый Структура("ПолучитьСинтетику,ПолучитьНечисловые", Ложь, Истина);
	
	Запрос = Справочники.ВидыОтчетов.ПолучитьЗапросТаблицыЗначенийПоказателей(ОтборВерсий, ОтборПоказателей,,ПоляВыборки, ДопПараметры);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ПолучитьРеквизитыШапкиЛист9(ОбъектИнвестиций, КэшНомераИнвестиций, КэшЭффективныеДоли, КонтактнаяИнформация, ВалютаОрганизации, ДатаОкончанияПериода, ВидФормы)
	
	Результат = Новый Структура;
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетыПоКорпоративнымНалогам");
	Если Модуль <> Неопределено Тогда
		КодИностраннойСтруктуры = Модуль.ПолучитьКодВидаИностраннойСтруктуры(ОбъектИнвестиций.ВидИностраннойСтруктуры);
	Иначе
		КодИностраннойСтруктуры = "";
	КонецЕсли;
	
	ЭффективнаяДоля = КэшЭффективныеДоли.Получить(ОбъектИнвестиций);
	Если ЭффективнаяДоля = Неопределено Тогда
		ЭффективнаяДоля = 0;
	КонецЕсли;
	
	киИнЮрАдрес = ОбъектИнвестиций.КонтактнаяИнформация.Найти(ВстраиваниеУХ.ВидыКонтактнойИнформацииИО(), "Вид");
	
	ТекущийГод = Год(ДатаОкончанияПериода);
	ГодОтсчета = Макс(ТекущийГод - 10, 2015);
	
	ПоПравилам25ГлавыНК = (ОбъектИнвестиций.ПорядокОпределенияПрибыли = Перечисления.ВидыПорядокаОпределенияПрибыли.ПоПравилам25ГлавыНК);
	
	Результат.Вставить("П0009А0000101", КэшНомераИнвестиций.Получить(ОбъектИнвестиций));// номер ИК
	Результат.Вставить("П0009А0000201", КодИностраннойСтруктуры);// организационная форма без обр ЮЛ
	
	Если ВидФормы = "ФормаОтчета2016Кв4" Тогда
		Результат.Вставить("П0009А0000301", ОбъектИнвестиций.НаименованиеПолное);// полн наим рус
		Результат.Вставить("П0009А0000302", ОбъектИнвестиций.НаименованиеИнострОрганизации);// полн наим англ
	Иначе
		Результат.Вставить("П0009А0000302", ОбъектИнвестиций.НаименованиеПолное);
		Результат.Вставить("П0009А0000301", ОбъектИнвестиций.НаименованиеИнострОрганизации);
	КонецЕсли;
	
	Результат.Вставить("П0009А0000401", ОбъектИнвестиций.УчредительныйДокумент);// док учрежд рус
	Результат.Вставить("П0009А0000402", ОбъектИнвестиций.УчредительныйДокументЛат);// док учрежд англ
	
	Результат.Вставить("П0009А0000501", ОбъектИнвестиций.СтранаРегистрации.Код);// страна регистрации
	Результат.Вставить("П0009А0000601", ОбъектИнвестиций.СтранаПостоянногоМестонахождения.Код);// страна резидентства
	
	Результат.Вставить("П0009А0000701", ОбъектИнвестиций.КодВСтранеРегистрации);// рег номер
	Результат.Вставить("П0009А0000801", ОбъектИнвестиций.КодНалогоплательщикаИностранный);// код налогоплательщика
	Результат.Вставить("П0009А0000901", ?(киИнЮрАдрес = Неопределено, "", киИнЮрАдрес.Представление));// адрес в стране регистрации
	
	Результат.Вставить("П0009А0001001", ЭффективнаяДоля);// доля участия (эффективная)
		
	Результат.Вставить("П0009А0000100", ?(ПоПравилам25ГлавыНК, "", "Х"));// прибыль определяется пп 1
	Результат.Вставить("П0009А0000200", ?(ПоПравилам25ГлавыНК, "Х", ""));// прибыль определяется пп 2
		
	Результат.Вставить("П000910000101", ВалютаОрганизации.Код);// код валюты
	Результат.Вставить("П009Б10000101", ВалютаОрганизации.Код);// код валюты
	Результат.Вставить("П009Б20000201", ВалютаОрганизации.Код);// код валюты
	
	Результат.Вставить("П000910000201", 1);// Операции, по которым производится расчет
	
	Если ТекущийГод >= ГодОтсчета Тогда
		Результат.Вставить("П000910003001", Формат(ГодОтсчета, "ЧГ="));
		ГодОтсчета = ГодОтсчета + 1;
	КонецЕсли;
	
	Если ТекущийГод >= ГодОтсчета Тогда
		Результат.Вставить("П000910004001", Формат(ГодОтсчета, "ЧГ="));
		ГодОтсчета = ГодОтсчета + 1;
	КонецЕсли;
	
	Если ТекущийГод >= ГодОтсчета Тогда
		Результат.Вставить("П000910005001", Формат(ГодОтсчета, "ЧГ="));
		ГодОтсчета = ГодОтсчета + 1;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСоответствиеКодовДекларации(Знач ПоказателиОтчетовДекларации, РеквизитКода)
	
	Перем КэшКодыДекларации, ТекущееЗаполняемоеПоле;
	
	КэшКодыДекларации = Новый Соответствие;
	Для каждого ТекущееЗаполняемоеПоле Из ПоказателиОтчетовДекларации Цикл	
		КэшКодыДекларации.Вставить(ТекущееЗаполняемоеПоле.ПоказательОтчета, СокрЛП(ТекущееЗаполняемоеПоле[РеквизитКода]));	
	КонецЦикла;
	Возврат КэшКодыДекларации;

КонецФункции

Процедура ЗаполнитьЛистДекларацииИзЭкземпляра(ДанныеПриемник, КэшПоказателиКоды, ОбъектИнвестирования, ТабЗначенияПоказателей, ТаблицаРасшифровки)
	
	ЗначенияСтраницы = ТабЗначенияПоказателей.НайтиСтроки(Новый Структура("Организация", ОбъектИнвестирования));
	
	ЭкземплярОтчета = ?(ЗначенияСтраницы.Количество(), ЗначенияСтраницы[0].ЭкземплярОтчета, Неопределено);
	
	ЗаполненныеКоды = Новый Соответствие;
	
	Для каждого ЗначениеСтраницы Из ЗначенияСтраницы Цикл
		
		КодДекларации = КэшПоказателиКоды.Получить(ЗначениеСтраницы.ПоказательОтчета);
		Если КодДекларации = Неопределено ИЛИ ДанныеПриемник.Свойство(КодДекларации) = Ложь Тогда
			Продолжить;
		КонецЕсли;
		
		ТекущееЗначение = ЗначениеСтраницы.Значение;
		ПреобразованиеБулевыхТипов(ТекущееЗначение, КодДекларации, ДанныеПриемник[КодДекларации]);
		
		ДанныеПриемник.Вставить(КодДекларации, ТекущееЗначение);
		
		ДобавитьРасшифровкуЛист9(ТаблицаРасшифровки, КодДекларации, ЗначениеСтраницы, ОбъектИнвестирования, ТекущееЗначение);
									
		ЗаполненныеКоды.Вставить(КодДекларации, Истина);							
									
	КонецЦикла;
	
	Для каждого ТекКодПоказателя Из КэшПоказателиКоды Цикл		
		
		Если ЗаполненныеКоды.Получить(ТекКодПоказателя.Значение) = Истина Тогда
			Продолжить;
		КонецЕсли;	
		
		ЗначениеСтраницы = Новый Структура("ЭкземплярОтчета, ПоказательОтчета", ЭкземплярОтчета, ТекКодПоказателя.Ключ);		
		ДобавитьРасшифровкуЛист9(ТаблицаРасшифровки, ТекКодПоказателя.Значение, ЗначениеСтраницы, ОбъектИнвестирования, 0);
				
	КонецЦикла;	

КонецПроцедуры

Процедура ДобавитьРасшифровкуЛист9(ТаблицаРасшифровки, КодДекларации, ЗначениеСтраницы, Организация, Сумма)
	
	МассивПоказателей = Новый ФиксированныйМассив(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СокрЛП(ЗначениеСтраницы.ПоказательОтчета.Код)));
	
	КонтекстЭкземпляра = Новый Структура;		
	КонтекстЭкземпляра.Вставить("ИмяОтчета", 		"Документ.НастраиваемыйОтчет.ФормаОбъекта");
	КонтекстЭкземпляра.Вставить("ПараметрыФормы",	Новый Структура("Ключ, МассивПоказателей", ЗначениеСтраницы.ЭкземплярОтчета, МассивПоказателей));
	
	// Расшифровка 
	СтрРасшифровка = ТаблицаРасшифровки.Добавить();
	
	СтрРасшифровка.ДополнительныеПараметры	= Новый Структура("Организация, Отчет", Организация, КонтекстЭкземпляра);
	СтрРасшифровка.ИмяПоказателя 			= КодДекларации;
	СтрРасшифровка.ИмяРаздела 				= "Лист09";
	СтрРасшифровка.НаименованиеПоказателя 	= ЗначениеСтраницы.ПоказательОтчета.Наименование;
	СтрРасшифровка.НаименованиеСлагаемого 	= ЗначениеСтраницы.ПоказательОтчета.Наименование;
	//СтрРасшифровка.Организация 				= Организация;
	СтрРасшифровка.Сумма 					= Сумма;
	СтрРасшифровка.ЗнакОперации 			= "";

КонецПроцедуры

Процедура ДобавитьДанныеНаЛист9(Знач ДанныеПриемник, Знач Лист09, ОчиститьПередЗаполнениемСписокЛистов, ДанныеДопСтрок)
	
	Если ДанныеПриемник.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонДопСтрок0 = Лист09[0].ДанныеДопСтрок;
	
	Если ОчиститьПередЗаполнениемСписокЛистов Тогда
		ОчиститьПередЗаполнениемСписокЛистов = Ложь;
		Лист09.Очистить();
	КонецЕсли;
	
	ДанныеСписок = Новый СписокЗначений;
	ДанныеСписок.Добавить(ДанныеПриемник);
		
	ТабДопСтрок = Новый ТаблицаЗначений;
	ТабДопСтрок.Добавить();
	
	ЛистПриемник = Лист09.Добавить();
	ЛистПриемник.АвтоматическоеПредставление = Истина;
	ЛистПриемник.АктивнаяСтраница = Ложь;		
	ЛистПриемник.Данные = ДанныеСписок;
	ЛистПриемник.ДанныеДопСтрок = ШаблонДопСтрок0;
	
	Для каждого Показатель Из ДанныеДопСтрок Цикл	
		ЛистПриемник.ДанныеДопСтрок[0].Значение[0][Показатель.Ключ] = Показатель.Значение;
	КонецЦикла;

КонецПроцедуры

Функция ПолучитьЭффективныеДоли(Инвестор, Сценарий, ДатаСреза)

	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	т.ОбъектИнвестирования,	
	|	т.ЭффективнаяДоля
	|ИЗ
	|	РегистрСведений.СтатусыОбъектовИнвестирования.СрезПоследних(
	|			&ДатаСреза,
	|			Инвестор = &Инвестор
	|				И Сценарий = &Сценарий) КАК т");
	
	Запрос.УстановитьПараметр("ДатаСреза",	Новый Граница(ДатаСреза, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Сценарий",	Сценарий);
	Запрос.УстановитьПараметр("Инвестор",	Инвестор);
	
	Выборка = Запрос.Выполнить().Выбрать();	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.ОбъектИнвестирования, Выборка.ЭффективнаяДоля);
	КонецЦикла; 
	
	Возврат Результат;

КонецФункции

Функция ПолучитьКэшПоказателейДекларации(ВидДекларации, ИДРедакцииОтчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка КАК ПоказательОтчета,
	|	СтатьиДоходовИРасходовКИККодыДляЗаполненияДеклараций.Код КАК КодЭлементаНалоговойДекларации
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.СтатьиДоходовИРасходовКИК.КодыДляЗаполненияДеклараций КАК СтатьиДоходовИРасходовКИККодыДляЗаполненияДеклараций
	|		ПО ПоказателиОтчетов.Строка.ЭлементСправочникаБД = СтатьиДоходовИРасходовКИККодыДляЗаполненияДеклараций.Ссылка
	|ГДЕ
	|	СтатьиДоходовИРасходовКИККодыДляЗаполненияДеклараций.Декларация = &Декларация";
	
	Запрос.УстановитьПараметр("Декларация", ВидДекларации + "." + ИДРедакцииОтчета);
	
	РезультатЗапроса = Запрос.Выполнить();
	ЗаполняемыеПоля = РезультатЗапроса.Выгрузить();
	
	Возврат ЗаполняемыеПоля;

КонецФункции

Функция ПолучитьНомераИнвестиций(Инвестор)

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	т.Инвестиция,
	|	т.НомерУчастника,
	|	т.Инвестиция.ИностраннаяСтруктураБезОбразованияЮрЛица КАК ИС
	|ИЗ
	|	РегистрСведений.НумерацияПоследовательностейВладения КАК т
	|ГДЕ
	|	т.Инвестор = &Инвестор");
	
	Запрос.УстановитьПараметр("Инвестор", Инвестор);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Инвестиция, ПолучитьКодИО(Выборка.ИС, Выборка.НомерУчастника));
	КонецЦикла; 
	
	Возврат Результат;

КонецФункции

Процедура ПреобразованиеБулевыхТипов(ТекущееЗначение, КодДекларации, ДанныеПриемник)
	Если ТипЗнч(ТекущееЗначение) = Тип("Булево") Тогда
		Если КодДекларации = "П009Б20000101" ИЛИ КодДекларации = "П000400001073" Тогда
			ТекущееЗначение = ?(ТекущееЗначение, "2", "1");			
		ИначеЕсли ТипЗнч(ДанныеПриемник) = Тип("Строка") Тогда
			ТекущееЗначение = ?(ТекущееЗначение, "1", "0");
		Иначе	
			ТекущееЗначение = ?(ТекущееЗначение, 1, 0);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

Процедура ПреобразованиеЧисловыхТипов(ТекущееЗначение, КодДекларации)
	Если ТипЗнч(ТекущееЗначение) = Тип("Число") Тогда
		Если КодДекларации = "П000400001120" ИЛИ КодДекларации = "П000400001130" Тогда
			ТекущееЗначение = Макс(ТекущееЗначение, -1 * ТекущееЗначение);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти