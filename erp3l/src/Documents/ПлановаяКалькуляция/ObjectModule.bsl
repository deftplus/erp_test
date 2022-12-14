#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Перем ТипОснования;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	ТипЗначенияЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипЗначенияЗаполнения = Тип("Структура") Тогда
		
		ДанныеЗаполнения.Свойство("ТипОснования", ТипОснования);
		
		Если ТипОснования = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
			ЗаполнитьНаОснованииСпискаСпецификаций(ДанныеЗаполнения.МассивОбъектов);
		ИначеЕсли ТипОснования = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			ЗаполнитьНаОснованииСпискаПозицийЗаказов(ДанныеЗаполнения.МассивОбъектов);
		ИначеЕсли ТипОснования = Тип("СправочникСсылка.Номенклатура") Тогда
			ЗаполнитьНаОснованииСпискаНоменклатуры(ДанныеЗаполнения.МассивОбъектов);
		КонецЕсли;
		
	ИначеЕсли ТипЗначенияЗаполнения = Тип("Массив") Тогда
		
		Если ДанныеЗаполнения.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
			ЗаполнитьНаОснованииСпискаСпецификаций(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения[0]) = Тип("ДокументСсылка.ЗаказНаПроизводство") Тогда
			ЗаполнитьНаОснованииСпискаПозицийЗаказов(ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.Номенклатура") Тогда
			ЗаполнитьНаОснованииСпискаНоменклатуры(ДанныеЗаполнения);
		КонецЕсли;
		
	ИначеЕсли ТипЗначенияЗаполнения = Тип("СправочникСсылка.РесурсныеСпецификации") Тогда
		ЗаполнитьНаОснованииСпецификации(ДанныеЗаполнения);		
	КонецЕсли;
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ИспользоватьОрганизацию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Организация");
	КонецЕсли;
	
	// Дата окончания действия соглашения должна быть не меньше, чем дата начала действия.
	Если ЗначениеЗаполнено(ДатаНачалаДействия) И ЗначениеЗаполнено(ДатаОкончанияДействия) Тогда
		Если ДатаНачалаДействия > ДатаОкончанияДействия Тогда
			
			ТекстОшибки = НСтр("ru = 'Дата окончания действия калькуляции должна быть не меньше даты начала';
								|en = 'Costing validity expiration date must be greater than the start date'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"ДатаОкончанияДействия",
				,
				Отказ);
			
		КонецЕсли;
	КонецЕсли;
	
	Если СтатьиКалькуляции.Итог("Сумма") < 0 Тогда
			ТекстОшибки = НСтр("ru = 'Итоговая сумма не может быть отрицательной.';
								|en = 'Total amount cannot be negative.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект, 
				"СтатьиКалькуляции",
				,
				Отказ);
	КонецЕсли;
	
	Если ОбъектКалькуляции <> Перечисления.ОбъектыКалькуляции.Изделие Тогда
		МассивНепроверяемыхРеквизитов.Добавить("КалькуляционнаяЕдиница");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОбъектКалькуляции) Тогда
		ПроверитьОбластьДействия(Отказ);
	КонецЕсли;
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияКоличества();
	ПараметрыПроверки.ИмяТЧ = "ВозвратныеОтходы";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	ПараметрыПроверки.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, ПараметрыПроверки);
	
	МассивНепроверяемыхРеквизитов.Добавить("СтатьиКалькуляции.Формула");
	МассивНепроверяемыхРеквизитов.Добавить("СтатьиРасходов.Формула");
	
	// Удалим не проверяемые реквизиты
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	СуммаПоДокументу = СтатьиКалькуляции.Итог("Сумма");
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ПараметрыОкругления = НоменклатураСервер.ПараметрыОкругленияКоличестваШтучныхТоваров();
	ПараметрыОкругления.ИмяТЧ = "ВозвратныеОтходы";
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	ПараметрыОкругления.ИмяТЧ = "МатериалыИУслуги";
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи, ПараметрыОкругления);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьОбластьДействия(Отказ)
	
	Сообщения = Новый Соответствие;
	Сообщения.Вставить(Перечисления.ОбъектыКалькуляции.Изделие, НСтр("ru = 'Не указано изделие, для которого действует калькуляция.';
																	|en = 'Product for which costing is valid is not specified.'"));
	Сообщения.Вставить(Перечисления.ОбъектыКалькуляции.РесурснаяСпецификация, НСтр("ru = 'Не указана спецификация, для которой действует калькуляция.';
																					|en = 'Bill of materials for which costing is valid is not specified.'"));
	Сообщения.Вставить(Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство, НСтр("ru = 'Не указана позиция заказа, для которой действует калькуляция.';
																				|en = 'Order item for which costing is valid is not specified.'"));
	Сообщения.Вставить("ОшибкаПозицииЗаказа", НСтр("ru = 'Позиция заказа на производство указана не корректно.';
													|en = 'Incorrect production order item.  '"));
	Сообщения.Вставить("ОшибкаХарактеристики", НСтр("ru = 'Не заполнено поле ""Характеристика"" для изделия.';
													|en = 'Characteristic for the product is not filled in.'"));
	Сообщения.Вставить("ОшибкаЕдиницыИзмерения", НСтр("ru = 'Изделия, для которых действует калькуляция, имеют разные единицы измерения.
		|Плановая калькуляция может применяться для однородных изделий.';
		|en = 'Products for which the costing is valid have different units of measure.
		|Standard cost estimate can only be applied for similar products. '"));
	
	Если ДействиеКалькуляции.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщения[ОбъектКалькуляции], ЭтотОбъект, ,, Отказ);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ДействиеКалькуляции.Объект КАК Объект,
	|	ДействиеКалькуляции.КодСтрокиЗаказаНаПроизводство КАК КодСтрокиЗаказаНаПроизводство,
	|	ДействиеКалькуляции.ИспользоватьХарактеристику КАК ИспользоватьХарактеристику,
	|	ДействиеКалькуляции.Характеристика КАК Характеристика
	|ПОМЕСТИТЬ ВТДействиеКалькуляции
	|ИЗ
	|	&ДействиеКалькуляции КАК ДействиеКалькуляции
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВТДействиеКалькуляции.Объект ССЫЛКА Документ.ЗаказНаПроизводство
	|					И ВТДействиеКалькуляции.КодСтрокиЗаказаНаПроизводство = 0
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ОшибкаПозицииЗаказа,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВТДействиеКалькуляции.ИспользоватьХарактеристику
	|					И ВТДействиеКалькуляции.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ОшибкаХарактеристики,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ВТДействиеКалькуляции.Объект ССЫЛКА Справочник.Номенклатура
	|				ТОГДА ВТДействиеКалькуляции.Объект.ЕдиницаИзмерения
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК МинЕдиницаИзмерения,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА ВТДействиеКалькуляции.Объект ССЫЛКА Справочник.Номенклатура
	|				ТОГДА ВТДействиеКалькуляции.Объект.ЕдиницаИзмерения
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК МаксЕдиницаИзмерения
	|ИЗ
	|	ВТДействиеКалькуляции КАК ВТДействиеКалькуляции");
	
	Запрос.УстановитьПараметр("ДействиеКалькуляции", ДействиеКалькуляции.Выгрузить());
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОшибкаОбластиДействия = Ложь;
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ОшибкаПозицииЗаказа Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщения["ОшибкаПозицииЗаказа"], ЭтотОбъект, ,, Отказ);
		КонецЕсли;
		
		Если Выборка.ОшибкаХарактеристики Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщения["ОшибкаХарактеристики"], ЭтотОбъект, ,, Отказ);
		КонецЕсли;
		
		Если Выборка.МинЕдиницаИзмерения <> Выборка.МаксЕдиницаИзмерения Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщения["ОшибкаЕдиницыИзмерения"], ЭтотОбъект, ,, Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Автор					= Пользователи.ТекущийПользователь();
	ДатаНачалаДействия		= НачалоДня(ТекущаяДатаСеанса());
	Статус					= Перечисления.СтатусыПлановыхКалькуляций.ВРазработке;
	Валюта					= Константы.ВалютаПлановойСебестоимостиПродукции.Получить();
	ВидЦены					= Справочники.ВидыЦен.ВидЦеныПлановойСтоимостиТМЦ();
	
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Константы.ВалютаПлановойСебестоимостиПродукции.СоздатьМенеджерЗначения().СообщитьКонстантаНеЗаполненаИВызватьИсключение();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСпискаНоменклатуры(МассивОбъектов)
	
	ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.Изделие;
	ДетализироватьСтатьиКалькуляции = Истина;
	
	Для Каждого Строка Из МассивОбъектов Цикл
		НоваяСтрока = ДействиеКалькуляции.Добавить();
		НоваяСтрока.Объект = Строка;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСпискаСпецификаций(МассивОбъектов)
	
	ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.РесурснаяСпецификация;
	ДетализироватьСтатьиКалькуляции = Истина;
	
	Для Каждого Строка Из МассивОбъектов Цикл
		НоваяСтрока = ДействиеКалькуляции.Добавить();
		НоваяСтрока.Объект = Строка;
	КонецЦикла;
	
	Если ДействиеКалькуляции.Количество() = 1 Тогда
		Документы.ПлановаяКалькуляция.ЗаполнитьПоСпецификации(ЭтотОбъект, ДействиеКалькуляции[0].Объект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСпискаПозицийЗаказов(МассивОбъектов)
	
	ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.ЗаказНаПроизводство;
	ДетализироватьСтатьиКалькуляции = Истина;
	
	Для Каждого Строка Из МассивОбъектов Цикл
		НоваяСтрока = ДействиеКалькуляции.Добавить();
		НоваяСтрока.Объект = Строка.ЗаказНапроизводство;
		НоваяСтрока.КодСтрокиЗаказаНаПроизводство = Строка.КодСтрокиЗаказаНаПроизводство;
	КонецЦикла;
	
	Если ДействиеКалькуляции.Количество() = 1 Тогда
		Документы.ПлановаяКалькуляция.ЗаполнитьПоСпецификацииЗаказа(ЭтотОбъект,
			ДействиеКалькуляции[0].Объект, ДействиеКалькуляции[0].КодСтрокиЗаказаНаПроизводство);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСпецификации(Спецификация)
	
	ОбъектКалькуляции = Перечисления.ОбъектыКалькуляции.РесурснаяСпецификация;
	ДетализироватьСтатьиКалькуляции = Истина;
	
	НоваяСтрока = ДействиеКалькуляции.Добавить();
	НоваяСтрока.Объект = Спецификация;
	
	Документы.ПлановаяКалькуляция.ЗаполнитьПоСпецификации(ЭтотОбъект, Спецификация);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
