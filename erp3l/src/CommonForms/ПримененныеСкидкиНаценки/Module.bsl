
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НеВыводитьИнформациюОРучныхСкидках = Ложь;
	Если Параметры.Свойство("НеВыводитьИнформациюОРучныхСкидках") И Параметры.НеВыводитьИнформациюОРучныхСкидках Тогда
		НеВыводитьИнформациюОРучныхСкидках = Истина;
	КонецЕсли;
	
	ПравоПросмотраСкидки                = ПравоДоступа("Просмотр", Метаданные.Справочники.СкидкиНаценки);
	ПравоПросмотраУсловияПредоставления = ПравоДоступа("Просмотр", Метаданные.Справочники.УсловияПредоставленияСкидокНаценок);
	
	Элементы.Характеристика.Видимость = Параметры.ОтображатьИнформациюОСкидкахПоСтроке;
	Элементы.Номенклатура.Видимость   = Параметры.ОтображатьИнформациюОСкидкахПоСтроке;
	
	Элементы.СуммаРучнойСкидки.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиВПродажах") 
	                                     ИЛИ НеВыводитьИнформациюОРучныхСкидках;
	
	Если НеВыводитьИнформациюОРучныхСкидках Тогда
		Элементы.ГруппаЗеленый.Видимость = Ложь;
		Элементы.ГруппаЗеленыйЗачеркнутый.Видимость = Ложь;
	КонецЕсли;
	
	Валюта = Параметры.Объект.Валюта;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.ОтображатьИнформациюОСкидкахПоСтроке Тогда
		
		Номенклатура   = Параметры.ТекущиеДанные.Номенклатура;
		Характеристика = Параметры.ТекущиеДанные.Характеристика;
		
		// Общая сумма скидки включает в себя сумму автоматической и ручной скидки.
		СуммаСкидки       = 0;
		СуммаРучнойСкидки = Параметры.ТекущиеДанные.СуммаРучнойСкидки;
		СуммаСкидки       = СуммаСкидки + СуммаРучнойСкидки;
		
		Отбор = Новый Структура("КлючСвязи", Параметры.ТекущиеДанные.КлючСвязи);
		Для Каждого СтрокаТЗСкидкиНаценки Из Параметры.Объект.СкидкиНаценки.НайтиСтроки(Отбор) Цикл
			
			НоваяСтрока = АвтоматическиеСкидки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЗСкидкиНаценки);
			Если Параметры.ТекущиеДанные.СуммаБезСкидки <> 0 Тогда
				НоваяСтрока.Процент = 100 * СтрокаТЗСкидкиНаценки.Сумма / Параметры.ТекущиеДанные.СуммаБезСкидки;
			КонецЕсли;
			
			СуммаСкидки = СуммаСкидки + НоваяСтрока.Сумма;
			
		КонецЦикла;
		
	Иначе
		
		СуммаСкидки       = 0;
		СуммаРучнойСкидки = Параметры.Объект.Товары.Итог("СуммаРучнойСкидки");
		СуммаСкидки       = СуммаСкидки + СуммаРучнойСкидки + Параметры.Объект.Товары.Итог("СуммаАвтоматическойСкидки");
		
	КонецЕсли;
	
	// Информация может быть отображена только после непосредственного расчета скидок в документе.
	// После закрытия формы эта информация не сохраняется.
	Если ЗначениеЗаполнено(Параметры.АдресПримененныхСкидокВоВременномХранилище) Тогда
		
		ПримененныеСкидки = ПолучитьИзВременногоХранилища(Параметры.АдресПримененныхСкидокВоВременномХранилище); // см. СкидкиНаценкиСервер.Рассчитать
		
		Если Параметры.ОтображатьИнформациюОРасчетеСкидокПоСтроке Тогда
			СформироватьИнформациюОРасчетеСкидокПоСтроке(ПримененныеСкидки, Параметры.ТекущиеДанные.КлючСвязи);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазвернутьДеревоДоУсловийРекурсивно(ИнформацияОРасчетеСкидокПоСтроке, Элементы.ИнформацияОРасчетеСкидокПоСтроке);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнформацияОРасчетеСкидокПоСтроке

&НаКлиенте
Процедура ИнформацияОРасчетеСкидокПоСтрокеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОРасчетеСкидокПоСтрокеЗначениеОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ИнформацияОРасчетеСкидокПоСтрокеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИнформацияОРасчетеСкидокПоСтроке.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоУсловие Тогда
		Если Не ПравоПросмотраУсловияПредоставления Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Если Не ПравоПросмотраСкидки Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПоказатьЗначение(Неопределено, ТекущиеДанные.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоСтроке.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.Управляемая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 128, 0));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоСтроке.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.Управляемая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.НазначенаПользователем");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.Действует");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(0, 128, 0));
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Ложь, Истина, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоСтроке.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.УсловияВыполнены");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.SpecialTextColor);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Ложь, Ложь, Ложь, Истина, ));
	
	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоСтрокеЗначение.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.Значение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.Ссылка");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.ЭтоУсловие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра(
		"Текст",
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Скидка предоставляется на %1';
				|en = 'Discount is provided for %1'"),
			ПолучитьПредставлениеНоменклатурыДляУсловногоОформленияСервер()));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ИнформацияОРасчетеСкидокПоСтрокеСумма.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИнформацияОРасчетеСкидокПоСтроке.ЭтоУсловие");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

&НаСервере
Функция ПолучитьПредставлениеНоменклатурыДляУсловногоОформленияСервер()
	
	Представление = "";
	
	Если ТипЗнч(Параметры.ТекущиеДанные) = Тип("Структура") Тогда
		НоменклатураСсылка   = Неопределено;
		ХарактеристикаСсылка = Неопределено;
		
		Если Параметры.ТекущиеДанные.Свойство("Номенклатура", НоменклатураСсылка) = Неопределено Тогда
			Возврат Представление;
		КонецЕсли;
		
		Параметры.ТекущиеДанные.Свойство("Характеристика", ХарактеристикаСсылка);
		
		Представление = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(НоменклатураСсылка, ХарактеристикаСсылка);
		
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#Область Прочее

&НаКлиенте
Процедура РазвернутьДеревоДоУсловийРекурсивно(СтрокаДерева, ЭлементФормы)
	
	КоллекцияЭлементов = СтрокаДерева.ПолучитьЭлементы();
	Для каждого Элемент Из КоллекцияЭлементов Цикл
	
		Если Элемент.Разворачивать Тогда
			ЭлементФормы.Развернуть(Элемент.ПолучитьИдентификатор());
			РазвернутьДеревоДоУсловийРекурсивно(Элемент, ЭлементФормы);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура РазложитьПоКолонкам(СтрокаДерева, НайденнаяСтрока)
	
	Для каждого СтрокаРасшифровки Из НайденнаяСтрока.Расшифровка Цикл
		СтрокаДерева.СуммаАвтоматическойСкидки = СтрокаДерева.СуммаАвтоматическойСкидки + СтрокаРасшифровки.Сумма;
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
// 	ДеревоСкидок - ДеревоЗначений - см. СкидкиНаценкиСервер.СформироватьДеревоСкидок, содержит в том числе:
// 		* Ссылка - СправочникСсылка.СкидкиНаценки
&НаСервере
Процедура РассчитатьИнформациюОРасчетеСкидокПоСтроке(ВходящееДеревоСкидок, ДеревоСкидок, КлючСвязи)
	
	Для Каждого СтрокаДерева Из ДеревоСкидок.Строки Цикл
		
		Если СтрокаДерева.ЭтоГруппа Тогда
			
			РассчитатьИнформациюОРасчетеСкидокПоСтроке(ВходящееДеревоСкидок, СтрокаДерева, КлючСвязи);
			
			СтрокаДерева.ИндексКартинки = СкидкиНаценкиСервер.ПолучитьИндексКартинкиДляГруппы(СтрокаДерева);
			СтрокаДерева.Значение = СтрокаДерева.Ссылка;
			СтрокаДерева.Представление = Строка(СтрокаДерева.Значение);
			СтрокаДерева.Разворачивать = Истина;
			
			Для каждого Стр Из СтрокаДерева.Строки Цикл
				Если Стр.Действует Тогда
					СтрокаДерева.Действует        = Истина;
					СтрокаДерева.УсловияВыполнены = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			НайденныеСтроки = СтрокаДерева.РезультатРасчета.НайтиСтроки(Новый Структура("Действует, КлючСвязи", Истина, КлючСвязи));
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				РазложитьПоКолонкам(СтрокаДерева, НайденнаяСтрока);
			КонецЦикла;
			
		Иначе
			
			СтрокаДерева.ИндексКартинки = СкидкиНаценкиСервер.ПолучитьИндексКартинкиДляСкидки(СтрокаДерева);
			СтрокаДерева.Значение = СтрокаДерева.Ссылка;
			СтрокаДерева.Представление = Строка(СтрокаДерева.Значение);
			
			ВсеУсловияВыполнены = Истина;
			Для каждого СтрокаУсловие Из СтрокаДерева.ПараметрыУсловий.ТаблицаУсловий Цикл
				
				НоваяСтрокаУсловие = СтрокаДерева.Строки.Добавить();
				НоваяСтрокаУсловие.Значение = СтрокаУсловие.УсловиеПредоставления;
				Если СтрокаУсловие.ЗначениеПоказателя <> Неопределено Тогда
					НоваяСтрокаУсловие.Представление = СтрШаблон(НСтр("ru = '%1 (Текущее значение: %2)';
																		|en = '%1 (Current value: %2)'"), Строка(СтрокаУсловие.УсловиеПредоставления), Формат(СтрокаУсловие.ЗначениеПоказателя, "ЧН=0"));
				Иначе
					НоваяСтрокаУсловие.Представление = Строка(СтрокаУсловие.УсловиеПредоставления);
				КонецЕсли;
				НоваяСтрокаУсловие.Ссылка     = СтрокаДерева.Ссылка;
				НоваяСтрокаУсловие.ЭтоУсловие = Истина;
				
				Если СтрокаУсловие.ОбластьОграничения = Перечисления.ВариантыОбластейОграниченияСкидокНаценок.ВСтроке Тогда
					НайденныеСтрокиТаблицыПроверкиУсловий = СтрокаДерева.ПараметрыУсловий.УсловияПоСтроке.ТаблицаПроверкиУсловий.Найти(КлючСвязи, "КлючСвязи");
					Если НайденныеСтрокиТаблицыПроверкиУсловий <> Неопределено Тогда
						НазваниеКолонки = СтрокаДерева.ПараметрыУсловий.УсловияПоСтроке.СоответствиеУсловийКолонкамТаблицыПроверкиУсловий.Получить(СтрокаУсловие.УсловиеПредоставления);
						Если НазваниеКолонки <> Неопределено Тогда
							НоваяСтрокаУсловие.Действует = НайденныеСтрокиТаблицыПроверкиУсловий[НазваниеКолонки];
						КонецЕсли;
					КонецЕсли;
				Иначе
					НоваяСтрокаУсловие.Действует = СтрокаУсловие.Выполнено;
				КонецЕсли;
				
				НоваяСтрокаУсловие.ИндексКартинки = -1;
				
				НоваяСтрокаУсловие.УсловияВыполнены = НоваяСтрокаУсловие.Действует;
				Если НЕ НоваяСтрокаУсловие.Действует Тогда
					ВсеУсловияВыполнены = Ложь;
				КонецЕсли;
				
			КонецЦикла;
			
			Если ВсеУсловияВыполнены Тогда
				Если СтрокаДерева.Управляемая Тогда
					СтрокаДерева.Действует = СтрокаДерева.НазначенаПользователем;
				Иначе
					СтрокаДерева.Действует = Истина;
				КонецЕсли;
				СтрокаДерева.УсловияВыполнены = Истина;
				
				Если Не (СтрокаДерева.Управляемая И НЕ СтрокаДерева.НазначенаПользователем) Тогда
					Если ВходящееДеревоСкидок.ТаблицаСкидкиНаценки.НайтиСтроки(Новый Структура("КлючСвязи, СкидкаНаценка", КлючСвязи, СтрокаДерева.Ссылка)).Количество() = 0 Тогда
						СтрокаДерева.НеПримениласьПоУсловиямСовместногоПрименения = Истина;
					КонецЕсли;
				КонецЕсли;
				
			Иначе
				СтрокаДерева.УсловияВыполнены = Ложь;
			КонецЕсли;
			
			НайденныеСтроки = СтрокаДерева.РезультатРасчета.НайтиСтроки(Новый Структура("КлючСвязи", КлючСвязи));
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				РазложитьПоКолонкам(СтрокаДерева, НайденнаяСтрока);
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформациюОРасчетеСкидокПоСтроке(ВходящееДеревоСкидок, КлючСвязи)
	
	ДеревоСкидок = ВходящееДеревоСкидок.ДеревоСкидок.Скопировать(); // ДеревоЗначений
	ДеревоСкидок.Колонки.Добавить("ИндексКартинки",   Новый ОписаниеТипов("Число"));
	ДеревоСкидок.Колонки.Добавить("Действует",        Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("УсловияВыполнены", Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("НеПримениласьПоУсловиямСовместногоПрименения", Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("Разворачивать",  Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("ЭтоУсловие",     Новый ОписаниеТипов("Булево"));
	ДеревоСкидок.Колонки.Добавить("Значение",       Новый ОписаниеТипов("СправочникСсылка.СкидкиНаценки, СправочникСсылка.УсловияПредоставленияСкидокНаценок"));
	ДеревоСкидок.Колонки.Добавить("Представление",  Новый ОписаниеТипов("Строка"));
	ДеревоСкидок.Колонки.Добавить("СуммаАвтоматическойСкидки", Новый ОписаниеТипов("Число"));
	
	РассчитатьИнформациюОРасчетеСкидокПоСтроке(ВходящееДеревоСкидок, ДеревоСкидок, КлючСвязи);
	
	ЗначениеВРеквизитФормы(ДеревоСкидок, "ИнформацияОРасчетеСкидокПоСтроке");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
