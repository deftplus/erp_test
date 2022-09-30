
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Элементы.НастройкиПодразделение.Видимость = ИнтеграцияИС.ИспользоватьПодразделения();
	
	ХранилищеЗначения = Константы.НастройкиОбменаГосИС.Получить();
	СохраненныеНастройки = ХранилищеЗначения.Получить();
	
	Если СохраненныеНастройки <> Неопределено Тогда
		
		Настройки.Загрузить(СохраненныеНастройки);
		
		Индекс = 1;
		Для Каждого СтрокаТЧ Из Настройки Цикл
			
			Если ПарольУстановлен(СтрокаТЧ.Сертификат) Тогда
				СтрокаТЧ.Пароль = НСтр("ru = 'Установлен';
										|en = 'Установлен'");
			Иначе
				СтрокаТЧ.Пароль = НСтр("ru = 'Не установлен';
										|en = 'Не установлен'");
			КонецЕсли;
			
			Индекс = Индекс + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТолькоПросмотр = Не ПравоДоступа("Изменение", Метаданные.Константы.НастройкиОбменаГосИС);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПослеОтветаНаВопросОЗакрытииФормы", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?';
				|en = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НастройкиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПарольУстановлен(ТекущиеДанные.Сертификат) Тогда
		ТекущиеДанные.Пароль = НСтр("ru = 'Установлен';
									|en = 'Установлен'");
	Иначе
		ТекущиеДанные.Пароль = НСтр("ru = 'Не установлен';
									|en = 'Не установлен'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если (Не ЗначениеЗаполнено(ТекущиеДанные.Организация) 
		Или Не ЗначениеЗаполнено(ТекущиеДанные.Сертификат)) И Не ОтменаРедактирования Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьИЗакрытьНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Сертификат) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Сертификат", ТекущиеДанные.Сертификат);
	
	ОткрытьФорму("ОбщаяФорма.ЗаписьПароляСертификатаИС",
		ПараметрыФормы,,,,,Новый ОписаниеОповещения("ПослеУстановкиПароля", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.НастройкиПодразделение.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Настройки.Подразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<любое подразделение>';
																		|en = '<любое подразделение>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаНеТребуетВниманияГосИС);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПарольУстановлен(Сертификат)
	
	Значение = Ложь;
	
	Пароль = ИнтеграцияИС.ПарольКСертификату(Сертификат);
	Если ЗначениеЗаполнено(Пароль) Тогда
		Значение = Истина;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	СохраняемыеНастройки = Настройки.Выгрузить(, "Организация, Подразделение, Сертификат");
	
	ХранилищеЗначения = Новый ХранилищеЗначения(СохраняемыеНастройки);
	
	Константы.НастройкиОбменаГосИС.Установить(ХранилищеЗначения);
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУстановкиПароля(Результат, ДополнительныеПараметры) Экспорт
	
	ТекущиеДанные = Элементы.Настройки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПарольУстановлен(ТекущиеДанные.Сертификат) Тогда
		ТекущиеДанные.Пароль = НСтр("ru = 'Установлен';
									|en = 'Установлен'");
	Иначе
		ТекущиеДанные.Пароль = НСтр("ru = 'Не установлен';
									|en = 'Не установлен'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросОЗакрытииФормы(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
		
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		
		ЗаписатьИЗакрытьНаСервере();
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
