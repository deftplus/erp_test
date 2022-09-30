
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	РегистрацияВНалоговомОргане = Параметры.РегистрацияВНалоговомОргане;
	ГоловнаяОрганизация = Параметры.ГоловнаяОрганизация;
	
	Список.ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	ВложенныйЗапрос.ОсновнаяРегистрация КАК ОсновнаяРегистрация,
	|	МАКСИМУМ(ВложенныйЗапрос.ВыбранаОсновной) КАК ВыбранаОсновной,
	|	МАКСИМУМ(ВложенныйЗапрос.ВыбранаДляУпрПодразделений) КАК ВыбранаДляУпрПодразделений,
	|	МАКСИМУМ(ВложенныйЗапрос.ВыбранаДляРеглПодразделений) КАК ВыбранаДляРеглПодразделений
	|ИЗ
	|	(ВЫБРАТЬ
	|		Организации.Ссылка КАК Организация,
	|		Организации.РегистрацияВНалоговомОргане КАК ОсновнаяРегистрация,
	|		ВЫБОР КОГДА Организации.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ КАК ВыбранаОсновной,
	|		ЛОЖЬ КАК ВыбранаДляУпрПодразделений,
	|		ЛОЖЬ КАК ВыбранаДляРеглПодразделений
	|	ИЗ
	|		Справочник.Организации КАК Организации
	|	ГДЕ
	|		Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация
	|		И Организации.ОбособленноеПодразделение
	|		
	|	ОБЪЕДИНИТЬ 
	|
	|	ВЫБРАТЬ
	|		Организации.Ссылка КАК Организация,
	|		Организации.РегистрацияВНалоговомОргане КАК ОсновнаяРегистрация,
	|		ЛОЖЬ КАК ВыбранаОсновной,
	|		ИСТИНА КАК ВыбранаДляУпрПодразделений,
	|		ЛОЖЬ КАК ВыбранаДляРеглПодразделений
	|	ИЗ
	|		РегистрСведений.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Справочник.Организации КАК Организации
	|		ПО
	|			РегистрацииВНалоговомОргане.Организация = Организации.Ссылка
	|			И Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация
	|			И Организации.ОбособленноеПодразделение
	|			И РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане <> Организации.РегистрацияВНалоговомОргане
	|	ГДЕ
	|		РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
	|		
	//++ НЕ УТ
	|	ОБЪЕДИНИТЬ 
	|
	|	ВЫБРАТЬ
	|		Организации.Ссылка КАК Организация,
	|		Организации.РегистрацияВНалоговомОргане КАК ОсновнаяРегистрация,
	|		ЛОЖЬ КАК ВыбранаОсновной,
	|		ЛОЖЬ КАК ВыбранаДляУпрПодразделений,
	|		ИСТИНА КАК ВыбранаДляРеглПодразделений
	|	ИЗ
	|		РегистрСведений.ИсторияРегистрацийВНалоговомОргане.СрезПоследних() КАК РегистрацииВНалоговомОргане
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ПО
	|			РегистрацииВНалоговомОргане.СтруктурнаяЕдиница = ПодразделенияОрганизаций.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|			Справочник.Организации КАК Организации
	|		ПО
	|			ПодразделенияОрганизаций.Владелец = Организации.Ссылка
	|			И Организации.ГоловнаяОрганизация = &ГоловнаяОрганизация
	|			И Организации.ОбособленноеПодразделение
	|			И РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане <> Организации.РегистрацияВНалоговомОргане 
	|	ГДЕ
	|		РегистрацииВНалоговомОргане.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
	//-- НЕ УТ
	|	) КАК ВложенныйЗапрос
	|СГРУППИРОВАТЬ ПО
	|	Организация,
	|	ОсновнаяРегистрация";
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "РегистрацияВНалоговомОргане", РегистрацияВНалоговомОргане);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ГоловнаяОрганизация", ГоловнаяОрганизация);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если Поле.Имя = "СписокОрганизация" Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Организация);
	Иначе
		НастройкаРегистраций(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоамндФормы

&НаКлиенте
Процедура НастройкаРегистраций(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Элементы.Список.ДанныеСтроки(ТекущаяСтрока);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", ДанныеСтроки.Организация);
	ПараметрыФормы.Вставить("ОсновнаяРегистрация", ДанныеСтроки.ОсновнаяРегистрация);
	ПараметрыФормы.Вставить("ОткрытиеИзОрганизации", Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ФормаНастройкиРегистрацийЗакрытие", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.РегистрацииВНалоговомОргане.Форма.ФормаНастройкиРегистраций", 
		ПараметрыФормы, ЭтаФорма, , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ФормаНастройкиРегистрацийЗакрытие(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить(); 
	
КонецПроцедуры

#КонецОбласти

