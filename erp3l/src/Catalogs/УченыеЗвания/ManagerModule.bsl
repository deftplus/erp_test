#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

// Возвращает реквизиты справочника, которые образуют естественный ключ для элементов справочника.
//
// Возвращаемое значение:
//  Массив из Строка - имена реквизитов, образующих естественный ключ.
//
Функция ПоляЕстественногоКлюча() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("Код");
	
	Возврат Результат;
	
КонецФункции

// Конец ТехнологияСервиса.ВыгрузкаЗагрузкаДанных

#КонецОбласти

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции
	
// Процедура выполняет первоначальное заполнение классификатора.
Процедура НачальноеЗаполнение() Экспорт
	
	КлассификаторТаблица = Новый ТаблицаЗначений;
	КлассификаторТаблица.Колонки.Добавить("Код");
	КлассификаторТаблица.Колонки.Добавить("Наименование");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "01";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Академик Российской академии наук';
													|en = 'Member of the Russian Academy of Sciences'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "02";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Академик международной академии наук';
													|en = 'Member of the International Academy of Sciences'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "03";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Академик отраслевой академии наук';
													|en = 'Member of Discipline-Specific Academy of Sciences'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "04";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Член-корреспондент Российской академии наук';
													|en = 'Corresponding Member of the Russian Academy of Sciences'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "05";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Член-корреспондент международной академии наук';
													|en = 'Corresponding member of the International Academy of Science'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "06";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Член-корреспондент отраслевой академии наук';
													|en = 'Corresponding member of a Discipline-Specific Academy of Sciences'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "07";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Профессор';
													|en = 'Professor'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "08";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Доцент';
													|en = 'Associate Professor'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "09";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Старший научный сотрудник';
													|en = 'Senior research assistant'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "10";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Младший научный сотрудник';
													|en = 'Junior research assistant'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "11";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Ассистент';
													|en = 'Assistant'");
	
	НоваяСтрокаКлассификатора = КлассификаторТаблица.Добавить();
	НоваяСтрокаКлассификатора.Код = "12";
	НоваяСтрокаКлассификатора.Наименование = НСтр("ru = 'Член зарубежной академии наук';
													|en = 'Member of the International Academy of Science'");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УченыеЗвания.Наименование
	               |ИЗ
	               |	Справочник.УченыеЗвания КАК УченыеЗвания";
	
	ТаблицаСуществующих = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаКлассификатора Из КлассификаторТаблица Цикл
		Если ТаблицаСуществующих.Найти(СтрокаКлассификатора.Наименование,"Наименование")  = Неопределено Тогда
			СправочникОбъект = Справочники.УченыеЗвания.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаКлассификатора);
			СправочникОбъект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
			СправочникОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли