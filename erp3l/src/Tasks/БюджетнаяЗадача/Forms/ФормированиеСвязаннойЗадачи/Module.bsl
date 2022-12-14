
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВыбиратьИсполнителя = Параметры.ВыбиратьИсполнителя;
	ВыбиратьЭтапПодготовкиБюджетов = Параметры.ВыбиратьЭтапПодготовкиБюджетов;
	МодельБюджетирования = Параметры.МодельБюджетирования;
	
	Если Параметры.ФормированиеНесколькихЗадач Тогда
		ЗаголовокФормы = НСтр("ru = 'Формирование связанных задач';
								|en = 'Generation of linked tasks'");
		ЗаголовокСформироватьЗадачу = НСтр("ru = 'Сформировать задачи';
											|en = 'Generate tasks'");
		ЗаголовокНеФормироватьЗадачу = НСтр("ru = 'Не формировать задачи';
											|en = 'Do not generate tasks'");
		ЗаголовокГруппаВыборШагаПроцесса = НСтр("ru = 'Создать задачи в рамках';
												|en = 'Create tasks within'")
	Иначе
		ЗаголовокФормы = НСтр("ru = 'Формирование связанной задачи';
								|en = 'Generate linked task'");
		ЗаголовокСформироватьЗадачу = НСтр("ru = 'Сформировать задачу';
											|en = 'Generate task'");
		ЗаголовокНеФормироватьЗадачу = НСтр("ru = 'Не формировать задачу';
											|en = 'Do not generate task'");
		ЗаголовокГруппаВыборШагаПроцесса = НСтр("ru = 'Создать задачу в рамках';
												|en = 'Create a task within'")
	КонецЕсли;
	
	ЭтаФорма.Заголовок = ?(Не ПустаяСтрока(Параметры.ЗаголовокФормы), Параметры.ЗаголовокФормы, ЗаголовокФормы);
	Элементы.СформироватьЗадачу.Заголовок = ЗаголовокСформироватьЗадачу;
	Элементы.НеФормироватьЗадачу.Заголовок = ЗаголовокНеФормироватьЗадачу;
	Элементы.ГруппаВыборШагаПроцесса.Заголовок = ЗаголовокГруппаВыборШагаПроцесса;
	
	Элементы.ГруппаВыборШагаПроцесса.Видимость = ВыбиратьЭтапПодготовкиБюджетов;
	Элементы.Исполнитель.Видимость = ВыбиратьИсполнителя;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(СрокИсполнения) И НачалоДня(СрокИсполнения) < НачалоДня(ТекущаяДатаСеанса()) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Срок исполнения задачи не может быть меньше текущей даты';
				|en = 'Task deadline cannot be less than the current date'"), , , "СрокИсполнения", Отказ);
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВариантВыбораЭтапПодготовкиБюджетов = 0 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ЭтапПодготовкиБюджетов");
	КонецЕсли;
	
	Если Не ВыбиратьИсполнителя Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Исполнитель");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЭтапПодготовкиБюджетовТекущийПриИзменении(Элемент)
	
	ЭтапПодготовкиБюджетов = Неопределено;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапПодготовкиБюджетовВыбранныйПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьЗадачу(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура("Наименование, СрокИсполнения, ОписаниеЗадачи");
	Если ВыбиратьИсполнителя Тогда
		Результат.Вставить("Исполнитель");
	КонецЕсли;
	Если ВариантВыбораЭтапПодготовкиБюджетов Тогда
		Результат.Вставить("ЭтапПодготовкиБюджетов");
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Результат, ЭтаФорма);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура НеФормироватьЗадачу(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеФормой()
	
	Элементы.ЭтапПодготовкиБюджетов.Доступность = (ВариантВыбораЭтапПодготовкиБюджетов = 1);
	Элементы.ЭтапПодготовкиБюджетов.АвтоОтметкаНезаполненного = (ВариантВыбораЭтапПодготовкиБюджетов = 1);
	
КонецПроцедуры


#КонецОбласти