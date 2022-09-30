////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ВидОтчета.Пустая() Тогда
		Отказ = Истина;
	Иначе
		Параметры.Свойство("ВидОтчета", ВидОтчета);
	КонецЕсли;
	
	БланкОтчета = УправлениеОтчетамиУХ.НайтиПараметрОтчета(Перечисления.ЭлементыНастройкиОтчета.БланкДляОтображения
	, ВидОтчета
	, Неопределено
	, Неопределено
	, Неопределено);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПоказателиОтчетов.Ссылка КАК Показатель,
	|	ПоказателиОтчетов.Код
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|ГДЕ
	|	ПоказателиОтчетов.Владелец = &Владелец
	|	И ПоказателиОтчетов.ПометкаУдаления = ЛОЖЬ";
	Запрос.УстановитьПараметр("Владелец", ВидОтчета);
	
	ТаблицаПоказателей.Очистить();
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = ТаблицаПоказателей.Добавить();
		НоваяСтрока.Код = СокрЛП(Выборка.Код);
		НоваяСтрока.Показатель = Выборка.Показатель;
		
	КонецЦикла;
	
	ВывестиБланкОтчетаВМакет();
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.
//
&НаКлиенте
Процедура БланкОтчетаПриИзменении(Элемент)
	
	ВывестиБланкОтчетаВМакет();
	
КонецПроцедуры

&НаКлиенте
Процедура Сопоставить(Команда)
	
	Область = Элементы.МакетБланкаОтчета.ТекущаяОбласть;
	
	НайденныеСтроки = ТаблицаПоказателей.НайтиСтроки(Новый Структура("Код", МакетБланкаОтчета.Область(ОБласть.Верх, Область.Лево).Имя));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		ОповеститьОВыборе(Новый Структура("ПоказательОтчета, ПереходитьНаСледующуюСтрочку", НайденныеСтроки[0].Показатель, ПереходитьНаСледующуюСтрочку));
		
	КонецЕсли;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ВывестиБланкОтчетаВМакет()
	
	МакетБланкаОтчета.Очистить();
	
	Если НЕ БланкОтчета.Пустая() Тогда
		
		МакетБланкаОтчета.Вывести(БланкОтчета.Макет.Получить());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура МакетБланкаОтчетаПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Область)
	
	СтандартнаяОбработка = Ложь;
	НайденныеСтроки = ТаблицаПоказателей.НайтиСтроки(Новый Структура("Код", МакетБланкаОтчета.Область(ОБласть.Верх, Область.Лево).Имя));
	Если НайденныеСтроки.Количество() > 0 Тогда
		Попытка
			Если ПараметрыПеретаскивания.Значение[0].ЯвляетсяАтрибутом Тогда
				ПараметрыПеретаскивания.Значение[0].ПоказательОтчета = НайденныеСтроки[0].Показатель;
			КонецЕсли;
		Исключение
			СообщениеПользователю = Новый СообщениеПользователю;
			СообщениеПользователю.Текст = "Не удалось сопоставить область бланка и реквизит файла формата ФНС
			|" + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры




