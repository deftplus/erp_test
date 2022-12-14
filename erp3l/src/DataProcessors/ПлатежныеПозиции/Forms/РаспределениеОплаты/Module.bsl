
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	//
	Элементы.Переместить(Элементы.ГрафикПлатежейДатаПлатежа, Элементы.ГрафикПлатежейДатаПлатежа.Родитель, Элементы.ГрафикПлатежейБанковскийСчетКасса);
	
	// Документ планирования
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ГрафикПлатежей,	"ОбъектОплаты",	Параметры.ДокументОснование,
		ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	
	// Форма оплаты
	Если Параметры.ФормаОплаты = "Безналичная" Тогда
		ТипМестаОплаты = ОбщегоНазначенияОПК.ТипОпределяемогоТипа(Метаданные.ОпределяемыеТипы.БанковскиеСчетаОрганизаций);
	ИначеЕсли Параметры.ФормаОплаты = "Наличная" Тогда
		ТипМестаОплаты = ОбщегоНазначенияОПК.ТипОпределяемогоТипа(Метаданные.ОпределяемыеТипы.Кассы);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ГрафикПлатежей,	"ТипМестаОплаты", ТипМестаОплаты,
		ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	// Направление
	Если Параметры.Направление = "Приход" Тогда
		Направление = Перечисления.ВидыДвиженийПриходРасход.Приход;
	ИначеЕсли Параметры.Направление = "Расход" Тогда
		Направление = Перечисления.ВидыДвиженийПриходРасход.Расход;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ГрафикПлатежей, "ПриходРасход", Направление,
		ВидСравненияКомпоновкиДанных.Равно,,Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ГрафикПлатежейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ГрафикПлатежей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("БанковскийСчетКасса, Сумма, ИдентификаторПозиции");
	ЗаполнитьЗначенияСвойств(Результат, ТекущиеДанные);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

#КонецОбласти