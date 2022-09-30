#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	РасчетСебестоимостиПрикладныеАлгоритмы.СохранитьДвиженияСформированныеРасчетомПартийИСебестоимости(ЭтотОбъект, Замещение);
	
	Если Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	*
	|ПОМЕСТИТЬ ДетализацияПартийТоваровДляНДСиУСНПередЗаписью
	|ИЗ
	|	РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН КАК ДетализацияПартийТоваровДляНДСиУСН
	|ГДЕ
	|	ДетализацияПартийТоваровДляНДСиУСН.Регистратор = &Регистратор";
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Или Не ПроведениеДокументов.КонтролироватьИзменения(ДополнительныеСвойства)
		Или ПланыОбмена.ГлавныйУзел() <> Неопределено
		Или РасчетСебестоимостиПрикладныеАлгоритмы.ДвиженияЗаписываютсяРасчетомПартийИСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РасчетСебестоимостиПрикладныеАлгоритмы.ФормироватьДвиженияРегистровУчетаСебестоимости(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	Таблица.Регистратор КАК Регистратор,
	|	Таблица.Организация КАК Организация,
	|	Таблица.РазделУчета КАК РазделУчета,
	|	Таблица.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|	Таблица.ВидЗапасов КАК ВидЗапасов,
	|	Таблица.Партия КАК Партия,
	|	Таблица.АналитикаФинансовогоУчета КАК АналитикаФинансовогоУчета,
	|	Таблица.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|	Таблица.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|	Таблица.ДокументПоступления КАК ДокументПоступления,
	|	Таблица.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	Таблица.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов КАК КорВидЗапасов,
	|	Таблица.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|	Таблица.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|	Таблица.АналитикаРасходов КАК АналитикаРасходов,
	|	Таблица.АналитикаАктивов КАК АналитикаАктивов,
	|	Таблица.РасчетПартий КАК РасчетПартий,
	|	Таблица.ТипЗаписи КАК ТипЗаписи,
	|	Таблица.ДокументИсточник КАК ДокументИсточник,
	|	Таблица.Знаменатель КАК Знаменатель,
	|	Таблица.КорАналитикаФинансовогоУчета КАК КорАналитикаФинансовогоУчета,
	|	Таблица.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|	Таблица.АналитикаСписанияНДС КАК АналитикаСписанияНДС,
	|	СУММА(Таблица.Количество) КАК КоличествоИзменение,
	|	СУММА(Таблица.СтоимостьБезНДС) КАК СтоимостьБезНДСИзменение,
	|	СУММА(Таблица.НДС) КАК НДСИзменение,
	|	СУММА(Таблица.НДСУпр) КАК НДСУпрИзменение
	|ПОМЕСТИТЬ ТаблицаИзмененийДетализацияПартийТоваровДляНДСиУСН
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДетализацияПартий.Период КАК Период,
	|		ДетализацияПартий.Регистратор КАК Регистратор,
	|		ДетализацияПартий.Организация КАК Организация,
	|		ДетализацияПартий.РазделУчета КАК РазделУчета,
	|		ДетализацияПартий.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.ВидЗапасов КАК ВидЗапасов,
	|		ДетализацияПартий.Партия КАК Партия,
	|		ДетализацияПартий.АналитикаФинансовогоУчета КАК АналитикаФинансовогоУчета,
	|		ДетализацияПартий.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ДокументПоступления КАК ДокументПоступления,
	|		ДетализацияПартий.Количество КАК Количество,
	|		ДетализацияПартий.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		ДетализацияПартий.НДС КАК НДС,
	|		ДетализацияПартий.НДСУпр КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов КАК КорВидЗапасов,
	|		ДетализацияПартий.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов КАК АналитикаАктивов,
	|		ДетализацияПартий.РасчетПартий КАК РасчетПартий,
	|		ДетализацияПартий.ТипЗаписи КАК ТипЗаписи,
	|		ДетализацияПартий.ДокументИсточник КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель КАК Знаменатель,
	|		ДетализацияПартий.КорАналитикаФинансовогоУчета КАК КорАналитикаФинансовогоУчета,
	|		ДетализацияПартий.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС КАК АналитикаСписанияНДС
	|	ИЗ
	|		ДетализацияПартийТоваровДляНДСиУСНПередЗаписью КАК ДетализацияПартий
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		ДетализацияПартий.Период КАК Период,
	|		ДетализацияПартий.Регистратор КАК Регистратор,
	|		ДетализацияПартий.Организация КАК Организация,
	|		ДетализацияПартий.РазделУчета КАК РазделУчета,
	|		ДетализацияПартий.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.ВидЗапасов КАК ВидЗапасов,
	|		ДетализацияПартий.Партия КАК Партия,
	|		ДетализацияПартий.АналитикаФинансовогоУчета КАК АналитикаФинансовогоУчета,
	|		ДетализацияПартий.ВидДеятельностиНДС КАК ВидДеятельностиНДС,
	|		ДетализацияПартий.АналитикаУчетаПартий КАК АналитикаУчетаПартий,
	|		ДетализацияПартий.ДокументПоступления КАК ДокументПоступления,
	|		-ДетализацияПартий.Количество КАК Количество,
	|		-ДетализацияПартий.СтоимостьБезНДС КАК СтоимостьБезНДС,
	|		-ДетализацияПартий.НДС КАК НДС,
	|		-ДетализацияПартий.НДСУпр КАК НДСУпр,
	|		ДетализацияПартий.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|		ДетализацияПартий.КорАналитикаУчетаНоменклатуры КАК КорАналитикаУчетаНоменклатуры,
	|		ДетализацияПартий.КорВидЗапасов КАК КорВидЗапасов,
	|		ДетализацияПартий.КорВидДеятельностиНДС КАК КорВидДеятельностиНДС,
	|		ДетализацияПартий.СтатьяРасходовАктивов КАК СтатьяРасходовАктивов,
	|		ДетализацияПартий.АналитикаРасходов КАК АналитикаРасходов,
	|		ДетализацияПартий.АналитикаАктивов КАК АналитикаАктивов,
	|		ДетализацияПартий.РасчетПартий КАК РасчетПартий,
	|		ДетализацияПартий.ТипЗаписи КАК ТипЗаписи,
	|		ДетализацияПартий.ДокументИсточник КАК ДокументИсточник,
	|		ДетализацияПартий.Знаменатель КАК Знаменатель,
	|		ДетализацияПартий.КорАналитикаФинансовогоУчета КАК КорАналитикаФинансовогоУчета,
	|		ДетализацияПартий.СтатьяСписанияНДС КАК СтатьяСписанияНДС,
	|		ДетализацияПартий.АналитикаСписанияНДС КАК АналитикаСписанияНДС
	|	ИЗ
	|		РегистрНакопления.ДетализацияПартийТоваровДляНДСиУСН КАК ДетализацияПартий
	|	ГДЕ
	|		ДетализацияПартий.Регистратор = &Регистратор) КАК Таблица
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Период,
	|	Таблица.Регистратор,
	|	Таблица.Организация,
	|	Таблица.РазделУчета,
	|	Таблица.АналитикаУчетаНоменклатуры,
	|	Таблица.ВидЗапасов,
	|	Таблица.Партия,
	|	Таблица.АналитикаФинансовогоУчета,
	|	Таблица.ВидДеятельностиНДС,
	|	Таблица.АналитикаУчетаПартий,
	|	Таблица.ДокументПоступления,
	|	Таблица.ХозяйственнаяОперация,
	|	Таблица.КорАналитикаУчетаНоменклатуры,
	|	Таблица.КорВидЗапасов,
	|	Таблица.КорВидДеятельностиНДС,
	|	Таблица.СтатьяРасходовАктивов,
	|	Таблица.АналитикаРасходов,
	|	Таблица.АналитикаАктивов,
	|	Таблица.РасчетПартий,
	|	Таблица.ТипЗаписи,
	|	Таблица.ДокументИсточник,
	|	Таблица.Знаменатель,
	|	Таблица.КорАналитикаФинансовогоУчета,
	|	Таблица.СтатьяСписанияНДС,
	|	Таблица.АналитикаСписанияНДС
	|ИМЕЮЩИЕ
	|	СУММА(Таблица.Количество) <> 0
	|	И СУММА(Таблица.СтоимостьБезНДС) <> 0
	|	И СУММА(Таблица.НДС) <> 0
	|	И СУММА(Таблица.НДСУпр) <> 0
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДетализацияПартийТоваровДляНДСиУСНПередЗаписью");
	
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();

КонецПроцедуры

#КонецОбласти

#КонецЕсли
