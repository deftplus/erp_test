#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	(Объект <> Неопределено
	|		И ЗначениеРазрешено(Объект)
	|	ИЛИ Объект = Неопределено
	|		И ЗначениеРазрешено(Организация)
	|		И ЗначениеРазрешено(Партнер)
	|	)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	(Объект <> Неопределено
	|		И ЗначениеРазрешено(Объект)
	|	ИЛИ Объект = Неопределено
	|		И ЗначениеРазрешено(Организация)
	|		И ЗначениеРазрешено(Партнер)
	|	)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Ссылка");
	Поля.Добавить("Объект");
	Поля.Добавить("Наименование");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Данные.Объект) Тогда
		Представление = НСтр("ru = '<Пустой>';
							|en = '<Empty>'");
	Иначе
		Представление = Данные.Наименование;
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Если НЕ МультиязычностьПовтИсп.КонфигурацияИспользуетТолькоОдинЯзык(Ложь) Тогда
			Представление = Строка(Данные.Объект);
		КонецЕсли;
		#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
			РежимОтлажки = ОбщегоНазначения.РежимОтладки();
		#Иначе
			РежимОтлажки = ОбщегоНазначенияКлиент.РежимОтладки();
		#КонецЕсли
		
		Если НЕ РежимОтлажки Тогда
			Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
				Результат= ВзаиморасчетыВызовСервера.ФормаОбъектаРасчетов(Параметры.Ключ);
				Если Результат.Форма <> "" Тогда
					СтандартнаяОбработка = Ложь;
					ВыбраннаяФорма = Результат.Форма;
					Параметры.Ключ = Результат.Ключ;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
