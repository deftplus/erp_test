#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Товары") Тогда
		
		Если ДанныеЗаполнения.Свойство("РеквизитыШапки") Тогда
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения.РеквизитыШапки);
		КонецЕсли;
		
		Для Каждого ЭлементКоллекции Из ДанныеЗаполнения.Товары Цикл
			ДанныеСтроки = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, ЭлементКоллекции);
		КонецЦикла;
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеИзЭксплуатации.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	ОчиститьНеИспользуемыеРеквизиты();

	НоменклатураСервер.ОчиститьНеиспользуемыеСерии(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеИзЭксплуатации));

	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеИзЭксплуатации.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Товары");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("Товары.СтатьяРасходов");
	
	ПроверкаЗаполненияДокумента(НепроверяемыеРеквизиты, Отказ);
	ПроверкаЗаполненияПрочихПодсистем(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Подразделение = ЗначениеНастроекПовтИсп.ПодразделениеПользователя(Ответственный, Подразделение);
	
КонецПроцедуры

Процедура ОчиститьНеИспользуемыеРеквизиты()
	
	Если Товары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачалоПримененияФСБУ5 = РеглУчетКлиентСервер.НачалоПримененияФСБУ5_2019();

	ДатыПартийТМЦ = ДатыПартийТМЦ();
	Для Каждого Выборка Из ДатыПартийТМЦ Цикл
		
		Если Выборка.Дата < НачалоПримененияФСБУ5 Тогда
			Продолжить
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Партия", Выборка.Ссылка);
		СписокСтрок = Товары.НайтиСтроки(СтруктураПоиска);
		Для Каждого ДанныеСтроки Из СписокСтрок Цикл
			ДанныеСтроки.СтатьяРасходов = Неопределено;
			ДанныеСтроки.АналитикаРасходов = Неопределено;
		КонецЦикла;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСтатьиРасходов(Отказ)
	
	Если Товары.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""Статья расходов"" в строке %1 списка ""Товары""';
							|en = 'The ""Expense item"" column in line %1 of the ""Goods"" list is not filled in'");
	
	НачалоПримененияФСБУ5 = РеглУчетКлиентСервер.НачалоПримененияФСБУ5_2019();

	ДатыПартийТМЦ = ДатыПартийТМЦ();
	Для Каждого Выборка Из ДатыПартийТМЦ Цикл
		
		Если Выборка.Дата >= НачалоПримененияФСБУ5 Тогда
			Продолжить
		КонецЕсли;
		
		СтруктураПоиска = Новый Структура("Партия", Выборка.Ссылка);
		СписокСтрок = Товары.НайтиСтроки(СтруктураПоиска);
		Для Каждого ДанныеСтроки Из СписокСтрок Цикл
			Если НЕ ЗначениеЗаполнено(ДанныеСтроки.СтатьяРасходов) Тогда
				ТекстСообщения = СтрШаблон(ШаблонСообщения, Формат(ДанныеСтроки.НомерСтроки, "ЧГ=;"));
				Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", ДанныеСтроки.НомерСтроки, "СтатьяРасходов");
				ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДатыПартийТМЦ()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПартииТМЦ.Ссылка КАК Ссылка,
	|	ПартииТМЦ.ДатаНачалаЭксплуатации КАК Дата
	|ИЗ
	|	Справочник.ПартииТМЦВЭксплуатации КАК ПартииТМЦ
	|ГДЕ
	|	ПартииТМЦ.Ссылка В (&СписокПартий)";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокПартий", Товары.Выгрузить().ВыгрузитьКолонку("Партия"));
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

Процедура ПроверкаЗаполненияДокумента(НепроверяемыеРеквизиты, Отказ)
	
	ТМЦВЭксплуатацииСервер.ПроверитьИнвентарныйУчет(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	ТМЦВЭксплуатацииСервер.ПроверитьУчетПоФизЛицам(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	
	ПроверитьСтатьиРасходов(Отказ);
	
КонецПроцедуры

Процедура ПроверкаЗаполненияПрочихПодсистем(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты, Отказ)
	
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, НепроверяемыеРеквизиты, Отказ);
	
	НоменклатураСервер.ПроверитьЗаполнениеСерий(
		ЭтотОбъект,
		НоменклатураСервер.ПараметрыУказанияСерий(ЭтотОбъект, Документы.СписаниеИзЭксплуатации),
		Отказ,
		НепроверяемыеРеквизиты);
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеИзЭксплуатации.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли