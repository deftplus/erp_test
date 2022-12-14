
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СохраняемыеРеквизиты = Параметры.СохраняемыеРеквизиты;
	ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
	Организация = Параметры.Организация;
	Местонахождение = Параметры.Местонахождение;
	ОтражатьВУпрУчете = Параметры.ОтражатьВУпрУчете;
	ОтражатьВРеглУчете = Параметры.ОтражатьВРеглУчете;
	ОтражатьВБУ = Параметры.ОтражатьВРеглУчете;
	ОтражатьВНУ = Параметры.ОтражатьВРеглУчете;
	ОтражатьВБУиНУ = Параметры.ОтражатьВБУиНУ;
	ОтражатьВОперативномУчете = Параметры.ОтражатьВОперативномУчете;
	ОтражатьВУУ = Параметры.ОтражатьВУУ;
	Дата = Параметры.Дата;
	Ссылка = Параметры.Ссылка;
	
	Если Параметры.Свойство("ЗначенияРеквизитов") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ЗначенияРеквизитов);
		
		РезервПереоценкиСтоимостиРеглСумма = ?(РезервПереоценкиСтоимостиРегл < 0, -РезервПереоценкиСтоимостиРегл, РезервПереоценкиСтоимостиРегл);
		РезервПереоценкиАмортизацииРеглСумма = ?(РезервПереоценкиАмортизацииРегл < 0, -РезервПереоценкиАмортизацииРегл, РезервПереоценкиАмортизацииРегл);
		РезервПереоценкиРеглЗнак = (РезервПереоценкиСтоимостиРегл > 0);
		
		РезервПереоценкиСтоимостиСумма = ?(РезервПереоценкиСтоимости < 0, -РезервПереоценкиСтоимости, РезервПереоценкиСтоимости);
		РезервПереоценкиАмортизацииСумма = ?(РезервПереоценкиАмортизации < 0, -РезервПереоценкиАмортизации, РезервПереоценкиАмортизации);
		РезервПереоценкиЗнак = (РезервПереоценкиСтоимости > 0);
		
	КонецЕсли;
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?';
				|en = 'The data has changed. Do you want to save the changes?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(ЭтотОбъект, Истина);
										
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	ОбщегоНазначенияУТ.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьЗаполнениеАналитик(ПараметрыРеквизитовОбъекта, ПроверяемыеРеквизиты, Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НематериальныеАктивы" И Источник = НематериальныйАктив Тогда
		ЗаполнитьСведенияНМА();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область СтраницаУчет

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	НематериальныйАктивПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУчетаУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент);
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаФинансовогоУчетаПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СтраницаСтоимость

&НаКлиенте
Процедура ТекущаяСтоимостьБУПриИзменении(Элемент)
	
	Если Элементы.ТекущаяСтоимостьУУ.Видимость 
		И ВалютаУпр = ВалютаРегл
		И ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьБУ = ЗначенияРеквизитовДоИзменения.ТекущаяСтоимостьУУ Тогда
		ТекущаяСтоимостьУУ = ТекущаяСтоимостьБУ;
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ТекущаяСтоимостьБУПриИзменении(ЭтотОбъект);
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьУУПриИзменении(Элемент)
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияБУПриИзменении(Элемент)
	
	Если Элементы.НакопленнаяАмортизацияУУ.Видимость 
		И ВалютаУпр = ВалютаРегл
		И ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияБУ = ЗначенияРеквизитовДоИзменения.НакопленнаяАмортизацияУУ Тогда
		НакопленнаяАмортизацияУУ = НакопленнаяАмортизацияБУ;
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_НакопленнаяАмортизацияБУПриИзменении(ЭтотОбъект);
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияУУПриИзменении(Элемент)
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьБУПриИзменении(Элемент)
	
	Если Элементы.ПервоначальнаяСтоимостьУУ.Видимость 
		И ВалютаУпр = ВалютаРегл
		И ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьБУ = ЗначенияРеквизитовДоИзменения.ПервоначальнаяСтоимостьУУ Тогда
		ПервоначальнаяСтоимостьУУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ПервоначальнаяСтоимостьБУПриИзменении(ЭтотОбъект);
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьУУПриИзменении(Элемент)
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьОтличаетсяПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СтраницаСобытия

&НаКлиенте
Процедура ЕстьРезервПереоценкиПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура РезервПереоценкиСтоимостиСуммаПриИзменении(Элемент)
	
	Если ТекущаяСтоимостьУУ <> 0 И РезервПереоценкиСтоимостиСумма <> 0 Тогда
		РезервПереоценкиАмортизацииСумма = 
			НакопленнаяАмортизацияУУ
			* (РезервПереоценкиСтоимостиСумма / ТекущаяСтоимостьУУ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СтраницаАмортизация

&НаКлиенте
Процедура СрокИспользованияУУПриИзменении(Элемент)
	
	ПриИзмененииСрокаИспользования("СрокИспользованияУУ", Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииУУПриИзменении(Элемент)
	
	НастроитьЗависимыеЭлементыФормы(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область СтраницаОтражениеРасходов

&НаКлиенте
Процедура СтатьяРасходовУУПриИзменении(Элемент)
	
	СтатьяРасходовУУПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовУУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовУУНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовУУАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовУУОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область Локализация

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент)

	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ПриИзмененииРеквизита(
		Элемент, ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_НачалоВыбора(
		Элемент, ДанныеВыбора, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_АвтоПодбор(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ОкончаниеВводаТекста(
		Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, ПараметрыОповещения) Экспорт

	Перем ПараметрыДействия;
	
	Если ПараметрыОповещения.ТребуетсяВызовСервера Тогда
		ПриИзмененииРеквизитаЗавершениеНаСервере(ИмяЭлемента, ПараметрыОповещения.ПараметрыОбработки);
	КонецЕсли;
	
	Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормы(ПараметрыДействия);
	КонецЕсли;
	Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_ПересчитатьЗависимыеСуммы") Тогда
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	КонецЕсли;
	Если ПараметрыОповещения.ПараметрыОбработки.Свойство("Выполнить_ПриИзмененииСрокаИспользования", ПараметрыДействия) Тогда
		ПриИзмененииСрокаИспользования(ПараметрыДействия.ИмяРеквизита, ПараметрыДействия.ОбновитьЕслиСовпадают);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаЗавершениеНаСервере(Знач ИмяЭлемента, Знач ДополнительныеПараметры)

	Перем ПараметрыДействия;
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_ПриИзмененииРеквизита(
		ИмяЭлемента, ЭтотОбъект, ДополнительныеПараметры);

	Если ДополнительныеПараметры.Свойство("Выполнить_НастроитьЗависимыеЭлементыФормы", ПараметрыДействия) Тогда
		НастроитьЗависимыеЭлементыФормыНаСервере(ПараметрыДействия);
	КонецЕсли;
	Если ДополнительныеПараметры.Свойство("Выполнить_ПересчитатьЗависимыеСуммы") Тогда
		ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьЗависимыеЭлементыФормы(Знач ИзмененныеРеквизитыИлиЭлемент = "")

	Если ТипЗнч(ИзмененныеРеквизитыИлиЭлемент) = Тип("Строка") Тогда
		ИзмененныеРеквизиты = ИзмененныеРеквизитыИлиЭлемент;
	Иначе
		ИзмененныеРеквизиты = ИзмененныеРеквизитыИлиЭлемент.Имя;
	КонецЕсли;
	
	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	Если ТребуетсяВызовСервераДляНастройкиЭлементовФормы(СтруктураИзмененныхРеквизитов) Тогда
		НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты)
	Иначе
		НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(Форма, ИзмененныеРеквизиты)

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
									Форма, Форма.ВспомогательныеРеквизиты, ИзмененныеРеквизиты);
	
	ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
	Если НЕ ОбновитьВсе Тогда
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(Форма, ПараметрыРеквизитовОбъекта);
		ИзмененныеРеквизиты = ВнеоборотныеАктивыКлиентСервер.ЗаполнитьРеквизитыВзависимостиОтСвойств_ВводОстатков(
				Форма, ПараметрыРеквизитовОбъекта);
	КонецЕсли;
	
	Элементы = Форма.Элементы;
	
	ПараметрыВводаОстатковНМА = ВнеоборотныеАктивыКлиентСервер.ПараметрыВводаОстатковНМА(Форма, Форма.ВспомогательныеРеквизиты);
									
	#Область СтраницаПараметрыУчета
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ ОбновитьВсе Тогда
		
		Если Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР") Тогда
			Элементы.ПорядокУчетаУУ.СписокВыбора[0].Представление = НСтр("ru = 'Списание расходов';
																		|en = 'Amortization charges'");
		Иначе
			Элементы.ПорядокУчетаУУ.СписокВыбора[0].Представление = НСтр("ru = 'Начислять амортизацию';
																		|en = 'Accrue depreciation '");
		КонецЕсли; 
		
	КонецЕсли;	
	
	Если ОбновитьВсе Тогда
		Элементы.ДатаПринятияКУчетуУУ.Заголовок = НСтр("ru = 'Принят к учету';
														|en = 'Recognized'");
		Элементы.ЛиквидационнаяСтоимостьРеглВалюта.Видимость = Элементы.ЛиквидационнаяСтоимостьРегл.Видимость;
		Элементы.ЛиквидационнаяСтоимостьВалюта.Видимость = Элементы.ЛиквидационнаяСтоимость.Видимость;
	КонецЕсли;	
	
	#КонецОбласти
	
	#Область СтраницаСтоимость
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ПорядокУчетаУУ")
		ИЛИ ОбновитьВсе Тогда
		Элементы.ОстаточнаяСтоимостьУУ.Видимость = Элементы.НакопленнаяАмортизацияУУ.Видимость;
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ТекущаяСтоимостьУУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("НакопленнаяАмортизацияУУ")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ПервоначальнаяСтоимостьОтличается")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ПрименениеЦелевогоФинансирования")
		ИЛИ ВводОстатковВнеоборотныхАктивовКлиентСерверЛокализация.ФормаРедактированияСтрокиНМА_ТребуетсяПересчитатьЗависимыеСуммы(СтруктураИзмененныхРеквизитов)
		ИЛИ ОбновитьВсе Тогда
		
		ПересчитатьЗависимыеСуммы(Форма);
	КонецЕсли; 
	
	Элементы.ГруппаНакопленнаяАмортизацияЗаголовок.Видимость = 
		Элементы.НакопленнаяАмортизацияБУ.Видимость
		ИЛИ Элементы.НакопленнаяАмортизацияУУ.Видимость;
	
	Элементы.ГруппаОстаточнаяСтоимостьЗаголовок.Видимость = 
		Элементы.ОстаточнаяСтоимостьБУ.Видимость
		ИЛИ Элементы.ОстаточнаяСтоимостьУУ.Видимость;
		
	Элементы.ДекорацияЗаголовокУУ.Видимость = Элементы.ТекущаяСтоимостьУУ.Видимость;
	
	
	Элементы.ОбесценениеВР.Видимость = Элементы.ДекорацияЗаголовокВР.Видимость;
	Элементы.ОбесценениеПР.Видимость = Элементы.ДекорацияЗаголовокПР.Видимость;
	
	#КонецОбласти
	
	#Область СтраницаСобытия
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВРеглУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ ОбновитьВсе Тогда
		
		ЗначениеСвойства = 
			Форма.ОтражатьВРеглУчете 
			И Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР")
			И Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА;
		
		Элементы.РезервПереоценкиРеглЗнак.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиСтоимостиРеглСумма.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииРеглСумма.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиСтоимостиРеглСуммаВалютаРегл.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииРеглСуммаВалютаРегл.Видимость = ЗначениеСвойства;
		
		//
		ЗначениеСвойства = 
			Форма.ОтражатьВРеглУчете
			И Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР")
			И НЕ Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА;
			
		Элементы.РезервПереоценкиАмортизацииРеглСумма1.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииРеглСуммаВалютаРегл1.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиСтоимостиРеглСумма1.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиСтоимостиРеглСуммаВалютаРегл1.Видимость = ЗначениеСвойства;
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ЕстьРезервПереоценки")
		ИЛИ ОбновитьВсе Тогда
		
		ЗначениеСвойства = Не Форма.ЕстьРезервПереоценки;
		Элементы.РезервПереоценкиЗнак.ТолькоПросмотр = ЗначениеСвойства; 
		Элементы.РезервПереоценкиСтоимостиСумма.ТолькоПросмотр = ЗначениеСвойства; 
		Элементы.РезервПереоценкиАмортизацииСумма.ТолькоПросмотр = ЗначениеСвойства; 
		Элементы.РезервПереоценкиСтоимостиРеглСумма1.ТолькоПросмотр = ЗначениеСвойства; 
		Элементы.РезервПереоценкиАмортизацииРеглСумма1.ТолькоПросмотр = ЗначениеСвойства; 
			
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ОтражатьВУпрУчете")
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ ОбновитьВсе Тогда
		
		ЗначениеСвойства = Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР")
							И Форма.ВспомогательныеРеквизиты.ОтражатьВУпрУчете;
		
		Элементы.РезервПереоценкиЗнак.Видимость = ЗначениеСвойства;
			
		//
		ЗначениеСвойства = Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР")
							И Форма.ВспомогательныеРеквизиты.ОтражатьВУпрУчете
							И (Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА
								ИЛИ НЕ Форма.ВспомогательныеРеквизиты.ВалютыСовпадают);
		
		Элементы.РезервПереоценкиСтоимостиСумма.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиСтоимостиСуммаВалютаУпр1.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииСумма.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииСуммаВалютаУпр.Видимость = ЗначениеСвойства;
			
		//
		ЗначениеСвойства = Форма.ВидОбъектаУчета <> ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР")
							И Форма.ВспомогательныеРеквизиты.ОтражатьВУпрУчете
							И НЕ Форма.ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА;
		
		Элементы.РезервПереоценкиСтоимостиРеглСумма1.Видимость = ЗначениеСвойства;
		Элементы.РезервПереоценкиАмортизацииРеглСумма1.Видимость = ЗначениеСвойства;
			
	КонецЕсли;
	
	#КонецОбласти
	
	#Область СтраницаАмортизация
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ ОбновитьВсе Тогда
		
		Если Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.РасходыНаНИОКР") Тогда
			
			Элементы.СтраницаАмортизация.Заголовок = НСтр("ru = 'Списание расходов';
															|en = 'Amortization charges'");
			
			Элементы.МетодНачисленияАмортизацииУУ.Заголовок = НСтр("ru = 'Способ списания';
																	|en = 'Amortization method'");
			Элементы.СрокИспользованияУУ.Заголовок = НСтр("ru = 'Срок списания';
															|en = 'Amortization period'");

		Иначе
			
			Элементы.СтраницаАмортизация.Заголовок = НСтр("ru = 'Амортизация';
															|en = 'Depreciation'");
			
			Элементы.МетодНачисленияАмортизацииУУ.Заголовок = НСтр("ru = 'Метод начисления';
																	|en = 'Depreciation method'");
			Элементы.СрокИспользованияУУ.Заголовок = НСтр("ru = 'Срок использования';
															|en = 'Useful life'");

		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("СрокИспользованияУУ")
		ИЛИ ОбновитьВсе Тогда
		
		Форма.СрокИспользованияУУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(
			Форма.СрокИспользованияУУ);
			
	КонецЕсли;
	
	Элементы.СрокИспользованияУУРасшифровка.Видимость = Элементы.СрокИспользованияУУ.Видимость;
	
	#КонецОбласти
	
	#Область СтраницаОтражениеРасходов
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета") 
		ИЛИ ОбновитьВсе Тогда
		
		Если Форма.ВидОбъектаУчета = ПредопределенноеЗначение("Перечисление.ВидыОбъектовУчетаНМА.НематериальныйАктив") Тогда
			Элементы.ГруппаРасходыУУ.Заголовок = НСтр("ru = 'Амортизация';
														|en = 'Depreciation'");
		Иначе
			Элементы.ГруппаРасходыУУ.Заголовок = НСтр("ru = 'Списание расходов';
														|en = 'Amortization charges'");
		КонецЕсли;
		
	КонецЕсли;
	
	#КонецОбласти
	
	ВводОстатковВнеоборотныхАктивовКлиентСерверЛокализация.ФормаРедактированияСтрокиНМА_НастроитьЗависимыеЭлементыФормы(
		Форма, 
		СтруктураИзмененныхРеквизитов, 
		ПараметрыВводаОстатковНМА,
		ПараметрыРеквизитовОбъекта);
	
	ЗаполнитьЗначенияРеквизитовДоИзменения(Форма);

КонецПроцедуры

&НаСервере
Процедура НастроитьЗависимыеЭлементыФормыНаСервере(Знач ИзмененныеРеквизиты = "")

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;
	
	Если ОбновитьВсе Тогда
		
		ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(ЭтотОбъект, Истина);
		
		Если ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
			Элементы.ДекорацияЗаголовокУУ.Заголовок = СтрШаблон(НСтр("ru = 'УУ (%1):';
																	|en = 'MA (%1):'"), Строка(ВалютаУпр));
			Элементы.ДекорацияЗаголовокБУ.Заголовок = СтрШаблон(НСтр("ru = 'БУ (%1):';
																	|en = 'AC (%1):'"), Строка(ВалютаРегл));
		Иначе
			Элементы.ДекорацияЗаголовокУУ.Заголовок = СтрШаблон(НСтр("ru = 'Упр. (%1):';
																	|en = 'Man. (%1):'"), Строка(ВалютаУпр));
			Элементы.ДекорацияЗаголовокБУ.Заголовок = СтрШаблон(НСтр("ru = 'Регл. (%1):';
																	|en = 'Reg. (%1):'"), Строка(ВалютаРегл));
		КонецЕсли; 
		
		Элементы.ПорядокУчетаУУ.Заголовок = НСтр("ru = 'Порядок учета';
												|en = 'Accounting procedure'");
		Элементы.ГруппаПереоценкаУпр.Заголовок = НСтр("ru = 'Переоценка';
														|en = 'Revaluation'");
		Элементы.ГруппаАмортизацияУУ.ОтображатьЗаголовок = Ложь;
		
		ВнеоборотныеАктивы.УстановитьПараметрыФункциональныхОпцийФормыОбъекта(
			ЭтотОбъект, Организация, КонецМесяца(Дата) + 1);
			
		
		ПараметрыВыбораНМА = Новый Массив;
		
		ОтборСостояние = Новый Массив;
		Если ОтражатьВОперативномУчете Тогда
			ОтборСостояние.Добавить(Перечисления.СостоянияНМА.НеПринятКУчету);
		Иначе
			ОтборСостояние.Добавить(Перечисления.СостоянияНМА.ПринятКУчету);
		КонецЕсли; 
		ПараметрыВыбораНМА.Добавить(Новый ПараметрВыбора("Отбор.Состояние", ОтборСостояние));
		ПараметрыВыбораНМА.Добавить(Новый ПараметрВыбора("Контекст", "БУ,УУ"));
		
		Элементы.НематериальныйАктив.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораНМА);
			
		// Скрыть локализуемые элементы
		Элементы.ДекорацияЗаголовокВР.Видимость = Ложь;
		Элементы.ДекорацияЗаголовокПР.Видимость = Ложь;
		Элементы.ДекорацияЗаголовокНУ.Видимость = Ложь;
		Элементы.ГруппаОстаточнаяСтоимостьЗаголовокЦФ.Видимость = Ложь;
		Элементы.ГруппаНакопленнаяАмортизацияЗаголовокЦФ.Видимость = Ложь;
		Элементы.ГруппаТекущаяСтоимостьЗаголовокЦФ.Видимость = Ложь;
		Элементы.ДекорацияПервоначальнаяСтоимостьПР.Видимость = Ложь;
		Элементы.ДекорацияПервоначальнаяСтоимостьВР.Видимость = Ложь;
		
	КонецЕсли;
	
	Если СтруктураИзмененныхРеквизитов.Свойство("ВидОбъектаУчета")
		ИЛИ ОбновитьВсе Тогда
		
		НастроитьПараметрыВыбораГФУ();
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_НастроитьЗависимыеЭлементыФормы(
		ЭтотОбъект, СтруктураИзмененныхРеквизитов);
	
	Элементы.ГруппаОбесценение.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьОбесценениеВНА");
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, ИзмененныеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Функция ТребуетсяВызовСервераДляНастройкиЭлементовФормы(СтруктураИзмененныхРеквизитов)

	Если СтруктураИзмененныхРеквизитов.Количество() = 0
		ИЛИ СтруктураИзмененныхРеквизитов.Свойство("ГруппаФинансовогоУчета") Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Возврат Ложь;

КонецФункции

&НаКлиенте
Процедура ПриИзмененииСрокаИспользования(ИмяРеквизита, ОбновитьЕслиСовпадают)

	СписокРеквизитов = ИмяРеквизита;
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ПриИзмененииСрокаИспользования(
		ЭтотОбъект, ИмяРеквизита, ОбновитьЕслиСовпадают, СписокРеквизитов);
	
	НастроитьЗависимыеЭлементыФормы(СписокРеквизитов);		

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьЗначенияРеквизитовДоИзменения(Форма)

	СписокРеквизитов = "ДатаПринятияКУчетуУУ,СрокИспользованияУУ,
						|ТекущаяСтоимостьУУ,НакопленнаяАмортизацияУУ,ПервоначальнаяСтоимостьУУ,
						|ТекущаяСтоимостьБУ,НакопленнаяАмортизацияБУ,ПервоначальнаяСтоимостьБУ,
						|ВидОбъектаУчета";
	
	ЗначенияРеквизитовДоИзменения = Новый Структура(СписокРеквизитов);
	ЗаполнитьЗначенияСвойств(ЗначенияРеквизитовДоИзменения, Форма);
	
	ВводОстатковВнеоборотныхАктивовКлиентСерверЛокализация.ФормаРедактированияСтрокиНМА_ДополнитьЗначенияРеквизитовДоИзменения(
		Форма, ЗначенияРеквизитовДоИзменения);
	
	Форма.ЗначенияРеквизитовДоИзменения = Новый ФиксированнаяСтруктура(ЗначенияРеквизитовДоИзменения);

КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииНаСервере()

	ЗаполнитьСведенияНМА();
	
	ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ЗначениеПоУмолчанию(ВидАктива);
	ИзмененныеРеквизиты = "ГруппаФинансовогоУчета";
	
	Если ЗначенияРеквизитовДоИзменения.ВидОбъектаУчета <> ВидОбъектаУчета Тогда
		ИзмененныеРеквизиты = ИзмененныеРеквизиты + ",ВидОбъектаУчета";
	КонецЕсли; 
	
	ПриИзмененииРеквизитаЗавершениеНаСервере("НематериальныйАктив", Новый Структура);
	
	НастроитьЗависимыеЭлементыФормыНаСервере(ИзмененныеРеквизиты);
	
	ПересчитатьЗависимыеСуммы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьЗависимыеСуммы(Форма)
	
	Если Не Форма.ПервоначальнаяСтоимостьОтличается Тогда
		
		Форма.ПервоначальнаяСтоимостьУУ = Форма.ТекущаяСтоимостьУУ;
		
	КонецЕсли;
	
	// Остаточная стоимость не редактируется
	Форма.ОстаточнаяСтоимостьУУ = Форма.ТекущаяСтоимостьУУ - Форма.НакопленнаяАмортизацияУУ;
	Форма.ОстаточнаяСтоимостьБУ = Форма.ТекущаяСтоимостьБУ - Форма.НакопленнаяАмортизацияБУ;
	
	ВводОстатковВнеоборотныхАктивовКлиентСерверЛокализация.ФормаРедактированияСтрокиНМА_ПересчитатьЗависимыеСуммы(Форма);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораГФУ()
	
	МассивПараметров = Новый Массив;
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидАктива", Перечисления.ВидыВнеоборотныхАктивов.НМА));
	Иначе
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВидАктива", Перечисления.ВидыВнеоборотныхАктивов.НИОКР));
	КонецЕсли;
	
	Элементы.ГруппаФинансовогоУчета.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовУУПриИзмененииНаСервере()

	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элементы.СтатьяРасходовУУ);
	
	НастроитьЗависимыеЭлементыФормыНаСервере("СтатьяРасходовУУ");
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()

	Если Параметры.НоваяСтрока И НЕ Параметры.Копирование Тогда
		ЗаполнитьЗначенияПоУмолчанию();
	КонецЕсли;
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	Элементы.ЛиквидационнаяСтоимостьВалюта.Заголовок = ВалютаУпр;
	Элементы.ЛиквидационнаяСтоимостьРеглВалюта.Заголовок = ВалютаРегл;
	
	ДатаНачалаУчета = '000101010000';
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_ПриЧтенииСозданииНаСервере(ЭтотОбъект);
	
	ЗаполнитьСведенияНМА();
	
	ПараметрыВыбораСтатейИАналитик = ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	НастроитьЗависимыеЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияНМА()

	Если НЕ ЗначениеЗаполнено(НематериальныйАктив)
		ИЛИ НЕ ОтражатьВОперативномУчете Тогда
		ВидАктива = Перечисления.ВидыВнеоборотныхАктивов.НМА;
		ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив;
		Элементы.НематериальныйАктив.Заголовок = НСтр("ru = 'Нематериальный актив';
														|en = 'Intangible asset'");
		Элементы.ВидНМА.Видимость = Ложь;
		ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_ЗаполнитьСведенияНМА(ЭтотОбъект);
		Возврат;
	КонецЕсли; 
	
	РеквизитыНМА = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НематериальныйАктив, "АмортизационнаяГруппа,ВидОбъектаУчета,ВидНМА");
	
	ВидОбъектаУчета = РеквизитыНМА.ВидОбъектаУчета; 
	
	ВидАктива = ?(РеквизитыНМА.ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив, 
						Перечисления.ВидыВнеоборотныхАктивов.НМА, 
						Перечисления.ВидыВнеоборотныхАктивов.НИОКР);
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
		
		Заголовок = НСтр("ru = 'Сведения о расходах на НИОКР';
						|en = 'R&D expense information'");
		Элементы.НематериальныйАктив.Заголовок = НСтр("ru = 'Расходы на НИОКР';
														|en = 'R&D expenses'");
		Элементы.ВидНМА.Видимость = Ложь;
		
	Иначе
		
		Заголовок = НСтр("ru = 'Сведения о нематериальном активе';
						|en = 'Intangible asset information'");
		Элементы.НематериальныйАктив.Заголовок = НСтр("ru = 'Нематериальный актив';
														|en = 'Intangible asset'");
		Элементы.ВидНМА.Видимость = Истина;

		Если ЗначениеЗаполнено(РеквизитыНМА.ВидНМА) Тогда
			ВидНМА = Новый ФорматированнаяСтрока(Строка(РеквизитыНМА.ВидНМА));
		Иначе
			ВидНМА = Новый ФорматированнаяСтрока(НСтр("ru = 'не заполнен';
														|en = 'not filled in'"),, ЦветаСтиля.ЦветНедоступногоТекста);
		КонецЕсли; 
		
	КонецЕсли; 
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_ЗаполнитьСведенияНМА(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнениеАналитик(ПараметрыРеквизитовОбъекта, ПроверяемыеРеквизиты, Отказ)

	ПараметрыВыбораСтатейИАналитик = ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияПоУмолчанию()

	ГруппаФинансовогоУчета = Справочники.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ЗначениеПоУмолчанию(ВидАктива);
	
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаРедактированияСтрокиНМА_ЗаполнитьЗначенияПоУмолчанию(ЭтотОбъект);
	
	ВспомогательныеРеквизиты = Документы.ВводОстатковВнеоборотныхАктивов2_4.ВспомогательныеРеквизиты(ЭтотОбъект, Истина);
									
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатков(
									ЭтотОбъект, ВспомогательныеРеквизиты, "");
									
	Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьРеквизитыВзависимостиОтСвойств(
			ЭтотОбъект, ВспомогательныеРеквизиты, ПараметрыРеквизитовОбъекта);

	Документы.ВводОстатковВнеоборотныхАктивов2_4.ЗаполнитьЗначенияПоУмолчанию(ЭтотОбъект, ЭтотОбъект);
			
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()

	ОчиститьСообщения();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		ТекстВопроса = НСтр("ru = 'Не заполнены обязательные поля.
                             |Можно завершить редактирование или продолжить редактирование.';
                             |en = 'Some of the required fields are not filled in.
                             |You can choose to finish editing or continue.'");
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Завершить редактирование';
															|en = 'Finish editing'"));
		СписокКнопок.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Продолжить редактирование';
															|en = 'Continue editing'"));
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьРедактированиеЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, СписокКнопок,, КодВозвратаДиалога.Да);
	Иначе
		ЗавершитьРедактированиеЗавершение(КодВозвратаДиалога.Да, Неопределено);
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРедактирования = Новый Структура(СохраняемыеРеквизиты);
	ЗаполнитьЗначенияСвойств(РезультатРедактирования, ЭтотОбъект);
	
	МножительРезерваПереоценки = ?(ЕстьРезервПереоценки, ?(РезервПереоценкиЗнак, 1, -1), 0);
	РезультатРедактирования.Вставить("РезервПереоценкиСтоимости", МножительРезерваПереоценки * РезервПереоценкиСтоимостиСумма);
	РезультатРедактирования.Вставить("РезервПереоценкиАмортизации", МножительРезерваПереоценки * РезервПереоценкиАмортизацииСумма);
	
	Если ВспомогательныеРеквизиты.ОтражатьВУпрУчете
		И НЕ ВспомогательныеРеквизиты.ВедетсяРегламентированныйУчетВНА Тогда
		
		РезультатРедактирования.Вставить("РезервПереоценкиСтоимостиРегл", МножительРезерваПереоценки * РезервПереоценкиСтоимостиРеглСумма);
		РезультатРедактирования.Вставить("РезервПереоценкиАмортизацииРегл", МножительРезерваПереоценки * РезервПереоценкиАмортизацииРеглСумма);
		
	КонецЕсли;
	
	ВводОстатковВнеоборотныхАктивовКлиентЛокализация.ФормаРедактированияСтрокиНМА_ЗавершитьРедактированиеЗавершение(
		ЭтотОбъект, РезультатРедактирования);
	
	Модифицированность = Ложь;
	
	Закрыть(РезультатРедактирования);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыВыбораСтатейИАналитик()
	
	ПараметрыВыбораСтатейИАналитик = Новый Массив;
	
	// СтатьяРасходовУУ
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "";
	ПараметрыВыбора.Статья = "СтатьяРасходовУУ";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходовУУ";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходовУУ");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходовУУ");
	
	ПараметрыВыбораСтатейИАналитик.Добавить(ПараметрыВыбора);
	
	//
	ВводОстатковВнеоборотныхАктивовЛокализация.ФормаНематериальныеАктивы_ДополнитьПараметрыВыбораСтатейИАналитик(ПараметрыВыбораСтатейИАналитик);
	
	Возврат ПараметрыВыбораСтатейИАналитик;
	
КонецФункции

#КонецОбласти

#КонецОбласти
