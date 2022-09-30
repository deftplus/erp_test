#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КоллекцияДеревоСравнения = ПолучитьИзВременногоХранилища(Параметры.ДеревоСравнения);
	
	НулеваяСтрока = КоллекцияДеревоСравнения[0];
	Индекс = 0;
	Пока НулеваяСтрока.Свойство("Поле" + Индекс) Цикл
		
		НоваяСтрокаДублей = НайденныеДубли.Добавить();
		НоваяСтрокаДублей.ФизическоеЛицо = НулеваяСтрока["Поле" + Индекс];
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ИзменитьРеквизитыФормы(ЭтаФорма, НайденныеДубли.Количество(), "ДеревоСравнения,ДеревоСравненияИсходное");
	
	Для Индекс = 0 По НайденныеДубли.Количество() - 1 Цикл
		
		Элемент = Элементы.Найти("ПолеПометка" + Индекс);
		Если Элемент = Неопределено Тогда
			Элемент = Элементы.Добавить("ПолеПометка" + Индекс, Тип("ПолеФормы"), Элементы.ДеревоСравнения);
			Элемент.Вид = ВидПоляФормы.ПолеФлажка;
			Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			Элемент.ПутьКДанным = "ДеревоСравнения.ПолеПометка" + Индекс;
			Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ДеревоСравненияПометкаПриИзменении");
		КонецЕсли; 
		
		Элемент = Элементы.Найти("Поле" + Индекс);
		Если Элемент = Неопределено Тогда
			Элемент = Элементы.Добавить("Поле" + Индекс, Тип("ПолеФормы"), Элементы.ДеревоСравнения);
			Элемент.Вид = ВидПоляФормы.ПолеВвода;
			Элемент.Заголовок = НайденныеДубли[Индекс].ФизическоеЛицо;
			Элемент.ТолькоПросмотр = Истина;
			Элемент.ПутьКДанным = "ДеревоСравнения.Поле" + Индекс;
		КонецЕсли; 
		
		// Установим условное оформление.
		
		ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
		ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДеревоСравнения.ДоступенДляВыбора" + Индекс);
		ЭлементОтбора.ПравоеЗначение = Ложь;
	
		ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить(); 
		ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ПолеПометка" + Индекс);
		
	КонецЦикла;
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьКоллекцию(ДеревоСравненияИсходное.ПолучитьЭлементы(), КоллекцияДеревоСравнения);
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьКоллекцию(ДеревоСравнения.ПолучитьЭлементы(), КоллекцияДеревоСравнения);
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьРезультат(ДеревоСравнения, Результат, НайденныеДубли);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоСравнения

&НаКлиенте
Процедура Подключаемый_ДеревоСравненияПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДеревоСравнения.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ИндексТекущегоФизическогоЛица = Число(Сред(Элемент.Имя, СтрДлина("ПолеПометка") + 1));
		Если НЕ ТекущиеДанные[Элемент.Имя] Тогда
			ТекущиеДанные[Элемент.Имя] = Истина;
		Иначе
			Для ИндексФизическогоЛица = 0 По НайденныеДубли.Количество() - 1 Цикл
				Если ИндексФизическогоЛица = ИндексТекущегоФизическогоЛица
					ИЛИ НЕ ТекущиеДанные["ПолеПометка" + ИндексФизическогоЛица] Тогда
					
					Если ИндексФизическогоЛица = ИндексТекущегоФизическогоЛица Тогда
						
						СтрокаРезультата = СтрокаРезультатаПоСтрокеДанных(ТекущиеДанные);
						
						Если СтрокаРезультата.ПолучитьРодителя() = Неопределено Тогда
							
							ПометитьВсеДанныеФизическогоЛица(ИндексФизическогоЛица);
							
						Иначе
							
							ЗаполнитьСтрокуРезультатаНаСервере(
								СтрокаРезультата.ПолучитьИдентификатор(),
								ТекущиеДанные.ПолучитьИдентификатор(),
								ИндексТекущегоФизическогоЛица);
							
						КонецЕсли; 
						
					КонецЕсли;
			
					Продолжить;
					
				КонецЕсли; 
				
				ТекущиеДанные["ПолеПометка" + ИндексФизическогоЛица] = Ложь;
				
			КонецЦикла;
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСравненияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ДеревоСравнения.ТекущиеДанные;
	Если ТекущиеДанные.Поле = "Ссылка" Тогда
		Попытка
			ИндексТекущегоФизическогоЛица = Число(Сред(Поле.Имя, СтрДлина("Поле") + 1));
			ПоказатьЗначение(, НайденныеДубли[ИндексТекущегоФизическогоЛица].ФизическоеЛицо);
		Исключение
			Возврат;
		КонецПопытки;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	ПринятьИзменения();
	
	ПараметрыОповещения = Новый Структура;
	
	Адрес = АдресДереваСравненияВХранилище();
	ПараметрыОповещения.Вставить("ДеревоСравнения", Адрес);
	
	Оповестить("ЗавершенПодробныйПросмотрЗадвоенныхДанныхФизическихЛиц", ПараметрыОповещения, ВладелецФормы);
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СтрокаРезультатаПоСтрокеДанных(ТекущиеДанные)
	
	МассивСтрокТекущиеДанные = Новый Массив;
	МассивСтрокТекущиеДанные.Вставить(0, ТекущиеДанные.Поле);
	
	РодительТекущиеДанные = ТекущиеДанные;
	
	Пока Истина Цикл
		
		РодительТекущиеДанные = РодительТекущиеДанные.ПолучитьРодителя();
		
		Если РодительТекущиеДанные = Неопределено Тогда
			Прервать;
		КонецЕсли; 
		
		МассивСтрокТекущиеДанные.Вставить(0, РодительТекущиеДанные.Поле);
		
	КонецЦикла;
	
	СтрокаРезультата = Результат;
	
	Для каждого ИмяПоля Из МассивСтрокТекущиеДанные Цикл
		
		КоллекцияСтрокРезультата = СтрокаРезультата.ПолучитьЭлементы();
		
		Для каждого СтрокаКоллекцияСтрокРезультата Из КоллекцияСтрокРезультата Цикл
			
			Если СтрокаКоллекцияСтрокРезультата.Поле = ИмяПоля Тогда
				
				СтрокаРезультата = СтрокаКоллекцияСтрокРезультата;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СтрокаРезультата;
	
КонецФункции

&НаКлиенте
Процедура ПометитьВсеДанныеФизическогоЛица(ИндексФизическогоЛица)
	
	СтрокаФизическогоЛица = ДеревоСравнения.ПолучитьЭлементы()[0];
	Для Индекс = 0 По НайденныеДубли.Количество() - 1 Цикл
		
		Если Индекс = ИндексФизическогоЛица Тогда
			СтрокаФизическогоЛица["ПолеПометка" + Индекс] = Истина;
		Иначе
			СтрокаФизическогоЛица["ПолеПометка" + Индекс] = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого СтрокаФизическогоЛица Из ДеревоСравнения.ПолучитьЭлементы() Цикл
		
		ПометитьДанныеКоллекции(СтрокаФизическогоЛица.ПолучитьЭлементы(), ИндексФизическогоЛица);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьДанныеКоллекции(КоллекцияСтрок, ИндексФизическогоЛица)
	
	Для каждого СтрокаКоллекции Из КоллекцияСтрок Цикл
		
		Если НЕ СтрокаКоллекции["ПолеПометка" + ИндексФизическогоЛица]
			И СтрокаКоллекции["ДоступенДляВыбора" + ИндексФизическогоЛица] Тогда
			
			Для Индекс = 0 По НайденныеДубли.Количество() - 1 Цикл
				СтрокаКоллекции["ПолеПометка" + Индекс] = (Индекс = ИндексФизическогоЛица);
			КонецЦикла;
			
			СтрокаРезультата = СтрокаРезультатаПоСтрокеДанных(СтрокаКоллекции);
			ЗаполнитьСтрокуРезультатаНаСервере(
				СтрокаРезультата.ПолучитьИдентификатор(),
				СтрокаКоллекции.ПолучитьИдентификатор(),
				ИндексФизическогоЛица);
			
		КонецЕсли;
		
		ПометитьДанныеКоллекции(СтрокаКоллекции.ПолучитьЭлементы(), ИндексФизическогоЛица);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуРезультатаНаСервере(Знач ИдентификаторСтрокиРезультата, Знач ИдентификаторСтрокиКоллекции, Знач ИндексФизическогоЛица)
	
	СтрокаРезультата = Результат.НайтиПоИдентификатору(ИдентификаторСтрокиРезультата);
	СтрокаКоллекции = ДеревоСравнения.НайтиПоИдентификатору(ИдентификаторСтрокиКоллекции);
	
	Обработки.ОбъединениеКарточекСЛичнымиДанными.ЗаполнитьСтрокуРезультата(СтрокаРезультата, СтрокаКоллекции, ИндексФизическогоЛица);
	
КонецПроцедуры

&НаСервере
Функция АдресДереваСравненияВХранилище()
	
	Возврат Обработки.ОбъединениеКарточекСЛичнымиДанными.АдресКоллекцииВХранилище(ЭтаФорма, "ДеревоСравненияИсходное");
	
КонецФункции

&НаСервере
Процедура ПринятьИзменения()
	
	ПринятьИзмененияСтрок(ДеревоСравнения.ПолучитьЭлементы(), ДеревоСравненияИсходное.ПолучитьЭлементы());
	
КонецПроцедуры

&НаСервере
Процедура ПринятьИзмененияСтрок(КоллекцияСтрокДереваСравнения, КоллекцияСтрокДереваСравненияИсходное)
	
	Для каждого СтрокаДереваСравнения Из КоллекцияСтрокДереваСравнения Цикл
		
		СтрокаДереваСравненияИсходное = СтрокаДереваСравненияИсходное(КоллекцияСтрокДереваСравненияИсходное, СтрокаДереваСравнения.Поле);
		Если СтрокаДереваСравненияИсходное <> Неопределено Тогда
			
			Для Индекс = 0 По НайденныеДубли.Количество() - 1 Цикл
				СтрокаДереваСравненияИсходное["ПолеПометка" + Индекс] = СтрокаДереваСравнения["ПолеПометка" + Индекс];
			КонецЦикла;
			
			ПринятьИзмененияСтрок(СтрокаДереваСравнения.ПолучитьЭлементы(), СтрокаДереваСравненияИсходное.ПолучитьЭлементы());
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СтрокаДереваСравненияИсходное(КоллекцияСтрокДереваСравненияИсходное, Поле)
	
	ВозвращаемаяСтрока = Неопределено;
	
	Для каждого СтрокаДереваСравнения Из КоллекцияСтрокДереваСравненияИсходное Цикл
		Если СтрокаДереваСравнения.Поле = Поле Тогда
			ВозвращаемаяСтрока = СтрокаДереваСравнения;
			Прервать;
		КонецЕсли; 
	КонецЦикла;
	
	Возврат ВозвращаемаяСтрока;
	
КонецФункции

#КонецОбласти
