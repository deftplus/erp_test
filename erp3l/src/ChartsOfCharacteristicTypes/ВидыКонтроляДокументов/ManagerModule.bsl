#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция РежимКонтроляВидаКонтроля(ВидКонтроля) Экспорт
	
	Если ВидКонтроля = Неопределено Тогда
		Возврат Неопределено;
	Иначе
		Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидКонтроля, "РежимКонтроля");
	КонецЕсли;
	
КонецФункции

Функция ВидКонтроляИспользуется(ВидКонтроля) Экспорт
	
	РежимКонтроля = РежимКонтроляВидаКонтроля(ВидКонтроля);
	
	Возврат (РежимКонтроля = Перечисления.РежимыКонтроляДокументов.Блокировать
			ИЛИ РежимКонтроля = Перечисления.РежимыКонтроляДокументов.Информировать);
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

//
Процедура ПервоначальноеЗаполнение() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыКонтроляДокументов.Ссылка КАК Ссылка,
	|	ВидыКонтроляДокументов.РежимКонтроля КАК РежимКонтроля,
	|	ЗНАЧЕНИЕ(Перечисление.РежимыКонтроляДокументов.Блокировать) КАК РежимКонтроляНовый
	|ИЗ
	|	ПланВидовХарактеристик.ВидыКонтроляДокументов КАК ВидыКонтроляДокументов
	|ГДЕ
	|	ВидыКонтроляДокументов.РежимКонтроля = ЗНАЧЕНИЕ(Перечисление.РежимыКонтроляДокументов.ПустаяСсылка)
	|	И ВидыКонтроляДокументов.Ссылка <> ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхЛимитов)
	|	И ВидыКонтроляДокументов.Ссылка <> ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыКонтроляДокументов.КонтрольБюджетныхРезервов)";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.РежимКонтроля = Выборка.РежимКонтроляНовый;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);		
	КонецЦикла;
	
	Константы.РегистрироватьДефицитРезерва.Установить(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 