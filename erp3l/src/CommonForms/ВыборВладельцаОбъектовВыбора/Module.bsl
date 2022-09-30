
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Ответственный = Параметры.Ответственный;
	ТекущийТип = Параметры.ИмяТипа;
	флТолькоСПравомВыбора = Параметры.ТолькоСПравомВыбора;
	флПоказыватьТолькоНезавершенные = Параметры.ПоказыватьТолькоНезавершенные;
	
	// Определяем ответственного
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		
		Пользователь = Пользователи.ТекущийПользователь();
		
		Если Не ЗначениеЗаполнено(Пользователь) Или НЕ ЗначениеЗаполнено(Пользователь.ФизическоеЛицо) Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = Нстр("ru = 'Пользователю не назначено физическое лицо!'");
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		
		Ответственный = Пользователь.ФизическоеЛицо;
		
	КонецЕсли;
	
	ФункциональноеНаправлениеОтветственного = РегистрыСведений.ФункциональныеНаправленияФизическихЛиц.ФункциональноеНаправлениеФизЛица(Ответственный);
	
	// Устанавливаем отобры по значениям параметров
	Владельцы.Параметры.УстановитьЗначениеПараметра("Сотрудник", Ответственный);
	
	Элементы.ВладельцыПравоВыбораАльтренатив.Видимость = НЕ флТолькоСПравомВыбора;
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Владельцы, "ПравоВыбораАльтренатив", Истина, флТолькоСПравомВыбора);
	
	Элементы.ВладельцыПроцессВыбораЗавершен.Видимость = НЕ флПоказыватьТолькоНезавершенные;
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(Владельцы, "ПроцессВыбораЗавершен", Ложь, флПоказыватьТолькоНезавершенные);
	
	// Устанавливаем доступные типы объектов выбора
	флОтборПоТипу = НЕ ПустаяСтрока(ТекущийТип);
	мТипыВладельцев = ВыборОбъектовУХ.ПолучитьТипыОбъектовВыбораДоступныеПользователю(Пользователь);
	Если мТипыВладельцев.Количество() = 0
		ИЛИ (флОтборПоТипу И мТипыВладельцев.Найти(Тип(ТекущийТип))) Тогда
		
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Нстр("ru = 'Пользователю не доступны объекты для выбора!'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	
	Если флОтборПоТипу Тогда
		мТипыВладельцев = Новый Массив;
		мТипыВладельцев.Добавить(Тип(ТекущийТип));
	КонецЕсли;
	
	УстановитьОтборТипаВладельца(мТипыВладельцев);
	
	ТипыВладельцев.ЗагрузитьЗначения(мТипыВладельцев);
	
	Элементы.ОтборТипаВладельца.СписокВыбора.ЗагрузитьЗначения(мТипыВладельцев);
	Элементы.ОтборТипаВладельца.СписокВыбора.Вставить(0, Неопределено, Нстр("ru = 'Любой тип'"));
	
	УстановитьОформлениеФормы();
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборТипаВладельца(ТипыВладельцев)
	флОдноЗначение = (ТипыВладельцев.Количество() = 1);
	
	ОтборыСписковКлиентСерверУХ.ИзменитьЭлементОтбораСписка(
			Владельцы,
			"ТипВладельца",
			?(флОдноЗначение, ТипыВладельцев[0], ТипыВладельцев),
			Истина,
			?(флОдноЗначение, ВидСравненияКомпоновкиДанных.Равно, ВидСравненияКомпоновкиДанных.ВСписке));
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеФормы()
	Элементы.ОтборТипаВладельца.Видимость = (ТипыВладельцев.Количество() > 1);
КонецПроцедуры

&НаКлиенте
Процедура ВладельцыВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.Владельцы.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекДанные.ВладелецОбъектов);
КонецПроцедуры

&НаКлиенте
Процедура ОтборТипаВладельцаПриИзменении(Элемент)
	Если ОтборТипаВладельца = Неопределено Тогда
		УстановитьОтборТипаВладельца(ТипыВладельцев);
	Иначе
		мОтбор = Новый Массив;
		мОтбор.Добавить(ОтборТипаВладельца);
		УстановитьОтборТипаВладельца(мОтбор);
	КонецЕсли;
	
	Элементы.Владельцы.Обновить();
КонецПроцедуры


