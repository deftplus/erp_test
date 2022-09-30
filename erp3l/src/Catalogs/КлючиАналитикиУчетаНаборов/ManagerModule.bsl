#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Соотвествие со списком реквизитов, по которым определяется уникальность ключа
// 
// Возвращаемое значение:
//   Соответствие - ключ - имя реквизита 
//
Функция КлючевыеРеквизиты() Экспорт
	
	Возврат ОбщегоНазначенияУТ.КлючевыеРеквизитыСправочникаКлючейПоРегиструСведений(Метаданные.РегистрыСведений.АналитикаУчетаНаборов);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЗаменаДублейКлючейАналитики

Процедура ЗаменитьДублиКлючейАналитики() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	ДанныеСправочника.Ссылка КАК Ссылка,
		|	ДанныеСправочника.ПометкаУдаления КАК ПометкаУдаления,
		|	Аналитика.КлючАналитики КАК КлючАналитики
		|ИЗ
		|	Справочник.КлючиАналитикиУчетаНаборов КАК ДанныеСправочника
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ
		|		РегистрСведений.АналитикаУчетаНаборов КАК ДанныеРегистра
		|	ПО
		|		ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|		РегистрСведений.АналитикаУчетаНаборов КАК Аналитика
		|	ПО
		|		ДанныеСправочника.НоменклатураНабора     = Аналитика.НоменклатураНабора
		|		И ДанныеСправочника.ХарактеристикаНабора = Аналитика.ХарактеристикаНабора
		|ГДЕ
		|	ДанныеРегистра.КлючАналитики ЕСТЬ NULL
		|");
	
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
		ОбщегоНазначенияУТ.ЗаменитьСсылки(СоответствиеАналитик);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли