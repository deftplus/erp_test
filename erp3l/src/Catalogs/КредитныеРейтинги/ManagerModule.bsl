#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СправочникТаблица.Ссылка КАК Ссылка,
	|	СправочникТаблица.ПометкаУдаления КАК ПометкаУдаления,
	|	СправочникТаблица.РеквизитДопУпорядочивания КАК РеквизитДопУпорядочивания,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СправочникТаблица.Ссылка) КАК Представление
	|ИЗ
	|	Справочник.КредитныеРейтинги КАК СправочникТаблица
	|ГДЕ
	|	НЕ СправочникТаблица.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	РеквизитДопУпорядочивания");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
	
		Пока Выборка.Следующий() Цикл
		
			ДанныеВыбора.Добавить(Выборка.Ссылка, Выборка.Представление);
		
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления
Процедура ЗаполнитьШкалыРейтингов() Экспорт
	
	// 1. Получим существующие элементы.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КредитныеРейтинги.Ссылка КАК Ссылка,
	|	КредитныеРейтинги.Владелец КАК Владелец,
	|	КредитныеРейтинги.Наименование КАК Наименование
	|ИЗ
	|	Справочник.КредитныеРейтинги КАК КредитныеРейтинги";
	
	КэшСуществующихЭлементов = Запрос.Выполнить().Выгрузить();
	
	ТабДок = ПолучитьМакет("ПоставляемыеКредитныеРейтинги");
	
	Для НомерСтроки = 2 По ТабДок.ВысотаТаблицы Цикл
		
		ИмяВладельцаЭлемента = СокрЛП(ТабДок.Область(НомерСтроки, 2).Текст);
		НаименованиеЭлемента = СокрЛП(ТабДок.Область(НомерСтроки, 3).Текст);
		РеквизитДопУпорядочивания = Число(ТабДок.Область(НомерСтроки, 4).Текст);
		
		Если Не ЗначениеЗаполнено(ИмяВладельцаЭлемента) ИЛИ Не ЗначениеЗаполнено(НаименованиеЭлемента) Тогда
			// Некорректные данные в макете
			Продолжить;
	
		КонецЕсли;
		
		Владелец = Справочники.ШкалыКредитногоРейтинга[ИмяВладельцаЭлемента];
		
		СтруктураПоиска = Новый Структура("Владелец,Наименование", Владелец, НаименованиеЭлемента);
		
		НайденныеЭлементы = КэшСуществующихЭлементов.НайтиСтроки(СтруктураПоиска);
		Если НайденныеЭлементы.Количество() Тогда
			// Такой элемент уже есть, обновим порядок.
			Объект = НайденныеЭлементы[0].Ссылка.ПолучитьОбъект();
			Объект.РеквизитДопУпорядочивания = РеквизитДопУпорядочивания;
		Иначе
			Объект = Справочники.КредитныеРейтинги.СоздатьЭлемент();
			Объект.Владелец = Владелец;
			Объект.Наименование = НаименованиеЭлемента;
			Объект.РеквизитДопУпорядочивания = РеквизитДопУпорядочивания;
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект);
	
	КонецЦикла;
	
	
КонецПроцедуры
	
#КонецОбласти
#КонецЕсли
