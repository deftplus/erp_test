#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Соответствие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соответствие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	Возврат ОбщегоНазначенияОПК.КлючевыеРеквизитыСправочникаКлючейПоРегиструСведений(Метаданные.РегистрыСведений.АналитикаПланированияПотребностей);
КонецФункции

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСправочника.Ссылка КАК Ссылка,
	|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
	|	Аналитика.КлючАналитики КАК КлючАналитики
	|ИЗ
	|	Справочник.КлючиАналитикиПланированияПотребностей КАК ДанныеСправочника
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаПланированияПотребностей КАК ДанныеРегистра
	|		ПО ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаПланированияПотребностей КАК Аналитика
	|		ПО ДанныеСправочника.МестоПоставки = Аналитика.МестоПоставки
	|			И ДанныеСправочника.Приоритет = Аналитика.Приоритет
	|			И ДанныеСправочника.Менеджер = Аналитика.Менеджер
	|			И ДанныеСправочника.Назначение = Аналитика.Назначение
	|ГДЕ
	|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL";
	
	// Сформируем соответствие ключей аналитики.
	СоответствиеАналитик = Новый Соответствие;
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
	
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			СоответствиеАналитик.Вставить(Выборка.Ссылка, Выборка.КлючАналитики);
			
			Если Не Выборка.ПометкаУдаления Тогда
				СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
				Попытка
					СправочникОбъект.УстановитьПометкуУдаления(Истина, Ложь);
				Исключение
					ВызватьИсключение;
				КонецПопытки;
			КонецЕсли;

		КонецЦикла;
		
		ОбщегоНазначенияОПК.ЗаменитьСсылки(СоответствиеАналитик);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

