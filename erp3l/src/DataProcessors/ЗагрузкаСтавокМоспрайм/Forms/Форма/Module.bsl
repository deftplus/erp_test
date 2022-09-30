
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ОкончаниеПериодаЗагрузки = НачалоДня(ТекущаяДатаСеанса());
	Объект.НачалоПериодаЗагрузки = Объект.ОкончаниеПериодаЗагрузки;
	
	ЗаполнитьТекущиеСтавки();
	
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокИндикаторовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекДанные = Элементы.СписокИндикаторов.ТекущиеДанные;
	ТекДанные.Загружать = Не ТекДанные.Загружать;
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	УстановитьПризнакЗагрузки(Истина);
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыбор(Команда)
	УстановитьПризнакЗагрузки(Ложь);
	УправлениеФормой(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИЗакрыть(Команда)
	ЗагрузитьИЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТекущиеСтавки()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ИСТИНА КАК Загружать,
	|	ВидыКотировокФинансовыхИнструментов.Ссылка КАК ВидСтавки,
	|	ВидыКотировокФинансовыхИнструментов.ИдентификаторДляЗагрузки КАК КодСтавки,
	|	НАЧАЛОПЕРИОДА(ЗначенияКотировокФИСрезПоследних.Период, ДЕНЬ) КАК ДатаСтавки,
	|	ЗначенияКотировокФИСрезПоследних.Значение КАК ЗначениеСтавки
	|ИЗ
	|	Справочник.ВидыКотировокФинансовыхИнструментов КАК ВидыКотировокФинансовыхИнструментов
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияКотировокФИ.СрезПоследних КАК ЗначенияКотировокФИСрезПоследних
	|		ПО ВидыКотировокФинансовыхИнструментов.Ссылка = ЗначенияКотировокФИСрезПоследних.ВидКотировки
	|ГДЕ
	|	ВидыКотировокФинансовыхИнструментов.Ссылка В (&СписокВидовКотировок)";
	
	Запрос.УстановитьПараметр("СписокВидовКотировок", Обработки.ЗагрузкаСтавокМоспрайм.ПереченьСтавокМосПрайм());
	
	Объект.СписокИндикаторов.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПризнакЗагрузки(ЗначениеПризнака)
	
	Для каждого ТекСтрока Из Объект.СписокИндикаторов Цикл
		
		ТекСтрока.Загружать = ЗначениеПризнака;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьИЗакрытьНаСервере()
	
	НужныеСтавки = Объект.СписокИндикаторов.Выгрузить(Новый Структура("Загружать", Истина), "ВидСтавки,КодСтавки");
	
	Обработки.ЗагрузкаСтавокМоспрайм.ЗагрузитьСтавкиМосПрайм(Объект.НачалоПериодаЗагрузки, Объект.ОкончаниеПериодаЗагрузки, НужныеСтавки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	ЕстьВыбранныеСтавки = (Объект.СписокИндикаторов.НайтиСтроки(Новый Структура("Загружать", Истина)).Количество());
	
	Элементы.ЗагрузитьИЗакрыть.Доступность = ЕстьВыбранныеСтавки;
	
КонецПроцедуры

#КонецОбласти
