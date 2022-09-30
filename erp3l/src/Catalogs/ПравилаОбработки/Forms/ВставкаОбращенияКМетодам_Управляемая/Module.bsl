
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МакетОпределения = Справочники.БланкиОтчетов.ПолучитьМакет("ОпределенияПроцедурИФункций_ru");
	
	ОпределенияТаблица = РеквизитФормыВЗначение("Определения");
	
	Для НомСтр = 2 По МакетОпределения.ВысотаТаблицы Цикл
		НовСтр = ОпределенияТаблица.Добавить();
		НовСтр.Метод = МакетОпределения.Область(НомСтр, 1).Текст;
		НовСтр.Описание = МакетОпределения.Область(НомСтр, 2).Текст;
		НовСтр.Код = МакетОпределения.Область(НомСтр, 3).Текст;
		НовСтр.Вид = ?(МакетОпределения.Область(НомСтр, 4).Текст = "Функция", 1, 0);
	КонецЦикла;
	
	ОпределенияТаблица.Сортировать("Метод");
	
	Если ОпределенияТаблица.Количество() = 0 Тогда
		СообщениеПользователю = Новый СообщениеПользователю;
		СообщениеПользователю.Текст = Нстр("ru = 'Определения вспомогательных процедур и функций не обнаружены!'");
		СообщениеПользователю.Сообщить();
		Отказ = Истина;
		Возврат;
	Иначе
		ЗначениеВРеквизитФормы(ОпределенияТаблица, "Определения");
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ОпределенияПриАктивизацииСтроки(Элемент)
	
	ПолеКод.Очистить();
	
	ТС = Определения.НайтиПоИдентификатору(Элементы.Определения.ТекущаяСтрока);
	
	Если ТС <> Неопределено Тогда
		ПолеКод.ДобавитьСтроку(ТС.Код);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределенияНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	ПараметрыПеретаскивания.Значение = ПолеКод.ПолучитьТекст();
	
КонецПроцедуры
