#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ЗначенияЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представитель)
		И ТипЗнч(Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		ПредставительЮридическоеЛицо	= 1;
		ЮридическоеЛицо	= Представитель;
		
	Иначе
		
		ПредставительЮридическоеЛицо	= 0;
		ФизическоеЛицо	= Представитель;
		
	КонецЕсли;
	
	ЗакрыватьПриВыборе	= Ложь;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыполняетсяЗакрытие = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru = 'Данные были изменены.
				|Перед завершением работы рекомендуется сохранить изменения,
				|иначе измененные данные будут утеряны.';
				|en = 'Data was changed.
				|Save the changes before exiting, 
				|otherwise the changed data will be lost.'");
			
			Возврат;
			
		Иначе
			
			ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
								|en = 'The data was changed. Do you want to save the changes?'");
			Оповещение   = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ОтветПользователя = РезультатВопроса;
	
	Если ОтветПользователя = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			ЗаписатьДанные();
		КонецЕсли;
		
	ИначеЕсли ОтветПользователя = КодВозвратаДиалога.Нет Тогда
		
		ВыполняетсяЗакрытие = Истина;
		Модифицированность  = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов	= Новый Массив;
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФизическоеЛицо");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ЮридическоеЛицо");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПредставительЮридическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		Представитель	= ЮридическоеЛицо;
	Иначе
		Представитель	= ФизическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		Представитель	= ЮридическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 0 Тогда
		Представитель	= ФизическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы	= Форма.Элементы;
	
	ПредставительЮрЛицо	= Форма.ПредставительЮридическоеЛицо = 1;
	
	Элементы.ФизическоеЛицо.Доступность		= НЕ ПредставительЮрЛицо;
	Элементы.ЮридическоеЛицо.Доступность	= ПредставительЮрЛицо;
	Элементы.ГруппаУполномоченноеЛицоПредставителя.Доступность	= ПредставительЮрЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные()
	
	ЗначениеВыбора	= Новый Структура("Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначениеВыбора, ЭтаФорма);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры

#КонецОбласти