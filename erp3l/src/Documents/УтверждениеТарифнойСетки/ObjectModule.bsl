#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаВступленияВСилу, "Объект.ДатаВступленияВСилу", Отказ, НСтр("ru = 'Дата вступления в силу';
																													|en = 'Commencement date'"), , , Ложь);
	
	Если ДополнительныеСвойства.Свойство("УтверждениеНовойТарифнойСетки")
		И ДополнительныеСвойства.УтверждениеНовойТарифнойСетки = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ТарифнаяСетка");	
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	РазрядыКатегорииДолжностей.СформироватьДвиженияЗначенийРазрядовТарифнойСетки(Движения, ДанныеДляПроведения.ДанныеРазрядовТарифнойСетки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.ДатаВступленияВСилу КАК ДатаСобытия,
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.ТарифнаяСетка КАК ТарифнаяСетка,
		|	УтверждениеТарифнойСеткиТарифы.РазрядКатегория,
		|	ВЫБОР
		|		КОГДА УтверждениеТарифнойСеткиТарифы.Ссылка.ТарифнаяСетка.ПрименениеТарифныхКоэффициентов
		|			ТОГДА УтверждениеТарифнойСеткиТарифы.РазрядныйКоэффициент
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК РазрядныйКоэффициент,
		|	УтверждениеТарифнойСеткиТарифы.Тариф КАК Тариф,
		|	УтверждениеТарифнойСеткиТарифы.Ссылка.БазовыйТарифГруппы КАК БазовыйТарифГруппы,
		|	НЕ УтверждениеТарифнойСеткиТарифы.Отменить КАК Используется
		|ИЗ
		|	Документ.УтверждениеТарифнойСетки.Тарифы КАК УтверждениеТарифнойСеткиТарифы
		|ГДЕ
		|	УтверждениеТарифнойСеткиТарифы.Ссылка = &Ссылка";
				   
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура;
	
	ДанныеРазрядовТарифнойСетки = РезультатыЗапроса[0].Выгрузить();
	ДанныеДляПроведения.Вставить("ДанныеРазрядовТарифнойСетки", ДанныеРазрядовТарифнойСетки);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли