#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьПараметры();
	
	Заголовок = Строка(Сотрудник);
	
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Начисления, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И Не Копирование Тогда
		ЗаполнитьЗначенияСвойств(Элемент.ТекущиеДанные, ЭтаФорма);
		Элемент.ТекущиеДанные.ПериодВзаиморасчетов = ПериодВзаиморасчетов;
		ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДатеВТабличнойЧасти(Начисления, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПериодВзаиморасчетовПриИзменении(Элемент)
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(Элементы.Начисления.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой", Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПериодВзаиморасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, Элементы.Начисления.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПериодВзаиморасчетовРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(Элементы.Начисления.ТекущиеДанные, "ПериодВзаиморасчетов", "ПериодВзаиморасчетовСтрокой", Направление, Модифицированность);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПериодВзаиморасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПериодВзаиморасчетовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСуммаКВыплатеПриИзменении(Элемент)
	ПриИзмененииПоказателяРасчетаКомпенсации()
КонецПроцедуры

&НаКлиенте
Процедура НачисленияСтавкаПриИзменении(Элемент)
	ПриИзмененииПоказателяРасчетаКомпенсации()
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаСПриИзменении(Элемент)
	ПриИзмененииПоказателяРасчетаКомпенсации()
КонецПроцедуры

&НаКлиенте
Процедура НачисленияДатаПоПриИзменении(Элемент)
	ПриИзмененииПоказателяРасчетаКомпенсации()
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подробно(Команда)
	
	ПоказыватьПодробности = ОбщегоНазначенияКлиентСервер.ЗначениеСвойстваЭлементаФормы(Элементы, "Подробно", "Пометка");
	Если ПоказыватьПодробности = Неопределено Тогда
		ПоказыватьПодробности = Ложь;
	Иначе	
		ПоказыватьПодробности = Не ПоказыватьПодробности;
	КонецЕсли;	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Подробно", "Пометка", ПоказыватьПодробности);	
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "НачисленияПодробноГруппа",	"Видимость", ПоказыватьПодробности);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПолучитьПараметры()
	
	Начисления.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВХранилищеНачисленийСотрудника));
	
	Параметры.Свойство("Сотрудник",				Сотрудник);
	
	Параметры.Свойство("Организация",			Организация);
	Параметры.Свойство("ПериодВзаиморасчетов",	ПериодВзаиморасчетов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПоказателяРасчетаКомпенсации()
	ДлинаСуток = 86400;
	Строка = Элементы.Начисления.ТекущиеДанные;
	Строка.СуммаКомпенсации = Строка.СуммаКВыплате * ((Строка.ДатаПо - Строка.ДатаС) / ДлинаСуток + 1) * Строка.Ставка / 100
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ПроверитьЗаполнение() Тогда
		
		РезультатыРедактирования = Новый Структура;
		РезультатыРедактирования.Вставить("Модифицированность",	Модифицированность);
		РезультатыРедактирования.Вставить("Сотрудник",			Сотрудник);
		РезультатыРедактирования.Вставить("АдресВХранилищеНачисленийСотрудника", АдресВХранилищеНачисленийСотрудника());
		
		Модифицированность = Ложь;
		Закрыть(РезультатыРедактирования)
		
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция АдресВХранилищеНачисленийСотрудника()
	Возврат ПоместитьВоВременноеХранилище(Начисления.Выгрузить(), УникальныйИдентификатор);
КонецФункции	

#КонецОбласти
