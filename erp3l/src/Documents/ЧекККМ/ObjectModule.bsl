#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		Если Не ДанныеЗаполнения.Свойство("ЧтениеКомандФормы") Тогда
			ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
		КонецЕсли;
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ЧекККМ") Тогда
		
		ЗаполнитьДокументПоЧекуККМ(ДанныеЗаполнения);
		
	Иначе
		
		КассаККМ = Справочники.КассыККМ.КассаККМФискальныйРегистраторДляРМК();
		Если ЗначениеЗаполнено(КассаККМ) Тогда
			ЗаполнитьДокументПоКассеККМ(КассаККМ);
		Иначе
			ВызватьИсключение НСтр("ru = 'Для текущего рабочего места не настроено подключаемое оборудование: Фискальный регистратор';
									|en = 'Peripherals are not configured for the current workplace: Fiscal cash register'");
		КонецЕсли;
		
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ЧекККМЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не ЗначениеЗаполнено(Статус) Тогда
		Статус = Перечисления.СтатусыЧековККМ.Отложен;
	КонецЕсли;
	
	Если Статус = Перечисления.СтатусыЧековККМ.Пробит И РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Отказ = Истина;
		
		ТекстОшибки = НСтр("ru = 'Чек ККМ пробит. Отмена проведения невозможна';
							|en = 'Receipt is issued. Posting cancellation is unavailable'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, ЭтотОбъект);
		Возврат;
		
	КонецЕсли;
	
	НоменклатураСервер.ОкруглитьКоличествоШтучныхТоваров(ЭтотОбъект, РежимЗаписи);
	
	ПодарочныеСертификатыСервер.ЗаполнитьСуммуВВалютеСертификатаВТабличнойЧасти(ПодарочныеСертификаты, Организация, Дата, Валюта);
	СуммаДокумента = ЦенообразованиеКлиентСервер.ПолучитьСуммуДокумента(Товары, ЦенаВключаетНДС);
	
	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(ЭтотОбъект, НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ));
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары,ПодарочныеСертификаты,ОплатаПлатежнымиКартами");
	
	ЧекККМЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Архивный = Ложь;
	Статус = Неопределено;
	
	ПолученоНаличными = 0;
	ОплатаПлатежнымиКартами.Очистить();
	Серии.Очистить();
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены);
	
	СкидкиРассчитаны = Ложь;
	СкидкиНаценкиЗаполнениеСервер.ОтменитьСкидки(ЭтотОбъект, "Товары", Ложь);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		СтрокаТЧ.СуммаБонусныхБалловКСписанию = 0;
		СтрокаТЧ.СуммаБонусныхБалловКСписаниюВВалюте = 0;
	КонецЦикла;
	
	ИнициализироватьДокумент();
	
	УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Товары);
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "Товары,ПодарочныеСертификаты,ОплатаПлатежнымиКартами");
	
	ЧекККМЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	НоменклатураСервер.ПроверитьЗаполнениеКоличества(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
	
	Если Не СкладыСервер.ИспользоватьСкладскиеПомещения(Склад,Дата) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.Помещение");
	КонецЕсли;
	
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект,МассивНепроверяемыхРеквизитов,Отказ);
	НоменклатураСервер.ПроверитьЗаполнениеСерий(ЭтотОбъект,
												НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.ЧекККМ),
												Отказ,
												МассивНепроверяемыхРеквизитов);
	ПодарочныеСертификатыСервер.ПроверитьЗаполнениеПодарочныхСертификатов(ЭтотОбъект, Отказ);
	ПродажиСервер.ПроверитьКорректностьЗаполненияДокументаПродажи(ЭтотОбъект, Отказ);
	
	ЧекККМЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Кассир = Пользователи.ТекущийПользователь();
	
	ПараметрыЗаполнения = УчетНДСУПКлиентСервер.ПараметрыЗаполненияНалогообложенияНДСПродажи();
	ПараметрыЗаполнения.Организация = Организация;
	ПараметрыЗаполнения.Дата = Дата;
	ПараметрыЗаполнения.Склад = Склад;
	ПараметрыЗаполнения.РозничнаяПродажа = Истина;
	УчетНДСУП.ЗаполнитьНалогообложениеНДСПродажи(НалогообложениеНДС, ПараметрыЗаполнения);
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоКассеККМ(КассаККМ)
	
	СостояниеКассовойСмены = РозничныеПродажи.ПолучитьСостояниеКассовойСмены(КассаККМ);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СостояниеКассовойСмены,,"Кассир");
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("КассаККМ") Тогда
		ЗаполнитьДокументПоКассеККМ(ДанныеЗаполнения.КассаККМ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоЧекуККМ(ЧекККМСсылка)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЧекККМ.КассаККМ КАК КассаККМ,
	|	ЧекККМ.Товары   КАК Товары
	|ИЗ
	|	Документ.ЧекККМ КАК ЧекККМ
	|ГДЕ
	|	ЧекККМ.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", ЧекККМСсылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		ЗаполнитьДокументПоКассеККМ(Выборка.КассаККМ);
		Товары.Загрузить(Выборка.Товары.Выгрузить());
		УчетНДСУП.СкорректироватьСтавкуНДСВТЧДокумента(ЭтотОбъект, Товары);
	КонецЕсли;
	
	ПриКопировании(ЧекККМСсылка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
