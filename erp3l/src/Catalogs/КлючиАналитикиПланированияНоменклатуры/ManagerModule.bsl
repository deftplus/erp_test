#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	|	Справочник.КлючиАналитикиПланированияНоменклатуры КАК ДанныеСправочника
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаПланированияНоменклатуры КАК ДанныеРегистра
	|		ПО ДанныеСправочника.Ссылка = ДанныеРегистра.КлючАналитики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаПланированияНоменклатуры КАК Аналитика
	|		ПО ДанныеСправочника.Номенклатура = Аналитика.Номенклатура
	|			И ДанныеСправочника.Характеристика = Аналитика.Характеристика
	|			И ДанныеСправочника.ЕдиницаИзмерения = Аналитика.ЕдиницаИзмерения
	|			И ДанныеСправочника.Коэффициент = Аналитика.Коэффициент
	|			И ДанныеСправочника.ИсходнаяНоменклатура = Аналитика.ИсходнаяНоменклатура
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