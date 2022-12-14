
#Область ПрограммныйИнтерфейс

Функция ЭтоРасчетыСКонтрагентом(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоРасчетыСКонтрагентом") = Истина;
КонецФункции

Функция ЭтоРасчетыСФизическимЛицом(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоРасчетыСФизическимЛицом")  = Истина;
КонецФункции

Функция ИспользоватьСуммуСтавкуНДС(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ИспользоватьСуммуСтавкуНДС") = Истина;
КонецФункции

Функция ЭтоРасчетыПоЦеннымБумагам(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоРасчетыПоЦеннымБумагам") = Истина;
КонецФункции

Функция ЭтоКонвертацияВалюты(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоКонвертацияВалюты") = Истина;
КонецФункции

Функция ЭтоПеремещениеСобственныхСредств(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоПеремещениеСобственныхСредств") = Истина;
КонецФункции

Функция ЭтоРасчетыПоНалогамИСборам(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоРасчетыПоНалогамИСборам") = Истина;
КонецФункции

Функция ДоступныеФормыОплаты(ВидОперацииУХ) Экспорт
	Результат = НовыйОписаниеДоступныхВидовОплаты();
	
	Если НЕ ЗначениеЗаполнено(ВидОперацииУХ) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВидыОперацийУХ.ДопустимБезналичныйРасчет КАК ДопустимБезналичныйРасчет,
	|	ВидыОперацийУХ.ДопустимНаличныйРасчет КАК ДопустимНаличныйРасчет,
	|	ЕСТЬNULL(ВидыОперацийУХ.ВстречныйВидОперацииПереводСобственныхСредств.ДопустимБезналичныйРасчет, ЛОЖЬ) КАК ДопустимБезналичныйРасчетВстречнойОперации,
	|	ЕСТЬNULL(ВидыОперацийУХ.ВстречныйВидОперацииПереводСобственныхСредств.ДопустимНаличныйРасчет, ЛОЖЬ) КАК ДопустимНаличныйРасчетВстречнойОперации
	|ИЗ
	|	Справочник.ВидыОперацийУХ КАК ВидыОперацийУХ
	|ГДЕ ВидыОперацийУХ.Ссылка = &ВидОперацииУХ";
	
	Запрос.УстановитьПараметр("ВидОперацииУХ", ВидОперацииУХ);
	
	ПараметрыВидаОперации = Запрос.Выполнить().Выгрузить();
	Если ПараметрыВидаОперации.Количество() Тогда
		
		Результат = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ПараметрыВидаОперации[0]);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ОсновнаяФормаОплаты(ВидОперацииУХ) Экспорт
	РезультатФункции = Неопределено;
	Если ЗначениеЗаполнено(ВидОперацииУХ) Тогда
		Если ВидОперацииУХ.ДопустимБезналичныйРасчет Тогда
			РезультатФункции = Перечисления.ФормыОплаты.Безналичная;
		ИначеЕсли ВидОперацииУХ.ДопустимНаличныйРасчет Тогда
			РезультатФункции = Перечисления.ФормыОплаты.Наличная;
		Иначе
			РезультатФункции = Неопределено;
		КонецЕсли;
	Иначе
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;	
КонецФункции

Функция ВстречныйВидОперацииУХ(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ВстречныйВидОперацииПереводСобственныхСредств");
КонецФункции

Функция ЭтоРасчетыБезДоговора(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ЭтоРасчетыБезДоговора");
КонецФункции

// Возвращает массив видов договоров, разрешенных для ВидаОперацииУХ
Функция ВидыДоговоров(ВидОперацииУХ) Экспорт
	ДопустимыеВидыДоговоров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		ВидОперацииУХ, "ДопустимыеВидыДоговоров");
	Если ДопустимыеВидыДоговоров = неопределено Тогда
		Возврат Новый Массив;
	Иначе
		Возврат ДопустимыеВидыДоговоров.Выгрузить().ВыгрузитьКолонку("ВидДоговора");
	КонецЕсли;
КонецФункции

// Возвращает основную статью бюджета по виду операции УХ
Функция ОсновнаяСтатьяБюджетаПоВидуОперации(ВидОперацииУХ) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидОперацииУХ", ВидОперацииУХ);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОсновныеСтатьиВидовОперацийУХ.СтатьяБюджета КАК СтатьяБюджета
	|ИЗ
	|	РегистрСведений.ОсновныеСтатьиВидовОперацийУХ КАК ОсновныеСтатьиВидовОперацийУХ
	|ГДЕ
	|	ОсновныеСтатьиВидовОперацийУХ.ВидОперацииУХ = &ВидОперацииУХ";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.СтатьяБюджета;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

// Возвращает истина если это операция продажи валюты
Функция ЭтоПродажаВалюты(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ПродажаВалюты");
КонецФункции

// Возвращает истина если это операция перемещения внутри организаци
Функция ЭтоПеремещениеВнутриОрганизации(ВидОперацииУХ) Экспорт
	Возврат ВидыОперацийУХКлиентСерверПовтИсп.ЭтоКонвертацияВалюты(ВидОперацииУХ) 
		ИЛИ ВидыОперацийУХКлиентСерверПовтИсп.ЭтоПеремещениеСобственныхСредств(ВидОперацииУХ);
КонецФункции

Функция ВидОперацииДДСБезналичныйРасчет(ВидОперацииУХ) Экспорт
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидОперацииУХ, "ВидОперацииДДСБезналичныйРасчет");
КонецФункции

Функция ЭтоУплатаНалога(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.УплатаНалога");
КонецФункции

Функция ЭтоУплатаНалогаЗаТретьихЛиц(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.УплатаНалогаЗаТретьихЛиц");
КонецФункции

Функция ЭтоПеречислениеДивидендов(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ПеречислениеДивидендов");
КонецФункции

Функция ЭтоЛичныеСредстваПредпринимателя(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ЛичныеСредстваПредпринимателя");
КонецФункции

Функция ВозможноПеречислениеПособияНаКартуМир(ВидОперацииУХ) Экспорт
	Возврат ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ПеречислениеЗаработнойПлатыПоВедомостям")
		Или ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ПеречислениеЗаработнойПлатыРаботнику")
		Или ВидОперацииУХ = ПредопределенноеЗначение("Справочник.ВидыОперацийУХ.ПрочееСписание");
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйОписаниеДоступныхВидовОплаты()
	Результат = Новый Структура;
	Результат.Вставить("ДопустимБезналичныйРасчет",                  Ложь);
	Результат.Вставить("ДопустимНаличныйРасчет",                     Ложь);
	Результат.Вставить("ДопустимБезналичныйРасчетВстречнойОперации", Ложь);
	Результат.Вставить("ДопустимНаличныйРасчетВстречнойОперации",    Ложь);
	Возврат Результат;
КонецФункции

#КонецОбласти


