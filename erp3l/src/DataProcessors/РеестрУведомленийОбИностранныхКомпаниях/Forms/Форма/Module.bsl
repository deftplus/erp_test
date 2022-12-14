
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Год = Год(ТекущаяДата());
	МодельНеЗаполнена = Ложь;
	РегламентированнаяОтчетностьУХ.ПроверитьЗаполненностьМодели(МодельНеЗаполнена);
	Элементы.ГруппаПредупреждение.Видимость = МодельНеЗаполнена;
	Сценарий = Константы.СценарийОтчетностиКИК.Получить();
	Инвестор = Параметры.Инвестор;
	ДатаРеестра = ТекущаяДата();
	ОбновитьНаСервере();
	УстановкаОтборов(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДатаРеестраПриИзменении(Элемент)
	ОбновитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыРеестрОсновной

&НаКлиенте
Процедура РеестрОсновнойПриАктивизацииСтроки(Элемент)
	Если Элементы.РеестрОсновной.ТекущиеДанные = Неопределено Тогда
		УстановкаОтборов(Неопределено);
	Иначе
		УстановкаОтборов(Элементы.РеестрОсновной.ТекущиеДанные.Инвестор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановкаОтборов(Инвестор)
	Если Инвестор <> Неопределено Тогда
		УведомленияОбУчастии.Параметры.УстановитьЗначениеПараметра("Инвестор", Инвестор);
	Иначе
		УведомленияОбУчастии.Параметры.УстановитьЗначениеПараметра("Инвестор", Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	УведомленияОбУчастии.Параметры.УстановитьЗначениеПараметра("Период", КонецДня(ДатаРеестра));
	УведомленияОбУчастии.Параметры.УстановитьЗначениеПараметра("Сценарий", Сценарий);
	
	Если Инвестор <> Неопределено Тогда
		УведомленияОКИК.Параметры.УстановитьЗначениеПараметра("Инвестор", Инвестор);
	Иначе
		УведомленияОКИК.Параметры.УстановитьЗначениеПараметра("Инвестор", Справочники.Организации.ПустаяСсылка());
	КонецЕсли;
	УведомленияОКИК.Параметры.УстановитьЗначениеПараметра("Год", КонецГода(Дата(Год, 1, 1)));
	УведомленияОКИК.Параметры.УстановитьЗначениеПараметра("Сценарий", Сценарий);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьРеестр(Команда)
	ОбновитьНаСервере();
	РеестрОсновнойПриАктивизацииСтроки(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьМодель(Команда)
	Элементы.ГруппаПредупреждение.Видимость = Ложь;
	ОткрытьФорму("Обработка.ГенерацияМоделиОтчетностиКИК.Форма", Новый Структура("Сценарий, ДатаРеестра", Сценарий, ДатаРеестра));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьДатуАктуальности()
	Текст = "";
	Если РасчетДолейВладения.ПоследовательностьАктуальна(ДатаРеестра, Текст) = Ложь Тогда
		Элементы.НадписьАктуальность.Заголовок = Текст;
		Элементы.ГруппаАктуальность.Видимость = Истина;
	Иначе 
		Элементы.ГруппаАктуальность.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	ПроверитьДатуАктуальности();
	РеестрОсновной.Параметры.УстановитьЗначениеПараметра("ДатаСреза", КонецДня(ДатаРеестра));
	РеестрОсновной.Параметры.УстановитьЗначениеПараметра("Сценарий", Сценарий);
	Элементы.РеестрОсновной.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУведомление(Команда)
	Если ТипЗнч(Элементы.УведомленияОбУчастии.ТекущиеДанные.Документ) <> Тип("Строка") Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьУведомлениеЗавершение", ЭтотОбъект, Элементы.УведомленияОбУчастии), НСтр("ru = 'Пометить на удаление Уведомление?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУведомлениеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		УдалитьУведомлениеНаСервере(ДополнительныеПараметры.ТекущиеДанные.Документ);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьУведомлениеНаСервере(Уведомление)
	ОбъектДокумент = Уведомление.ПолучитьОбъект();
	ОбъектДокумент.УстановитьПометкуУдаления(Истина);
	ОбновитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РеестрОсновнойВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.РеестрОсновной.ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(,Элементы.РеестрОсновной.ТекущиеДанные.Инвестор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СценарийНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ФормаКорпоративныеНалогиНастройка");
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОткрытьУведомлениеОбУчастии(Команда)
	Если Элементы.УведомленияОбУчастии.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Отсутствуют данные об иностранных инвестициях'"));
	ИначеЕсли ТипЗнч(Элементы.УведомленияОбУчастии.ТекущиеДанные.Документ) = Тип("Строка") Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Организация", Элементы.РеестрОсновной.ТекущиеДанные.Инвестор);
		ПараметрыФормы.Вставить("ВидУведомления", ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО"));
		ПараметрыФормы.Вставить("ИмяОтчета", "РегламентированноеУведомлениеУ_ИО");
		ПараметрыФормы.Вставить("Дата", КонецДня(Элементы.УведомленияОбУчастии.ТекущиеДанные.Период));
		ПараметрыФормы.Вставить("ОснованиеУведомленияОбИО", Элементы.УведомленияОбУчастии.ТекущиеДанные.ОснованиеУведомления);
		МассивИнвестиций = Новый Массив;
		Для каждого Стр Из Элементы.УведомленияОбУчастии.ВыделенныеСтроки Цикл
			Если Стр.ОснованиеУведомления = ПараметрыФормы.ОснованиеУведомленияОбИО И ТипЗнч(Стр.Документ) = Тип("Строка") Тогда 
				МассивИнвестиций.Добавить(Стр.ОбъектИнвестирования);
				Если ПараметрыФормы.Дата < Стр.Период Тогда
					ПараметрыФормы.Дата = КонецДня(Стр.Период);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		ПараметрыФормы.Вставить("Инвестиции", МассивИнвестиций);
		//ПараметрыФормы.Вставить("Инвестиция", Элементы.УведомленияОбУчастии.ТекущиеДанные.ОбъектИнвестирования);
		//ПараметрыФормы.Вставить("ЭффективнаяДоля", Элементы.УведомленияОбУчастии.ТекущиеДанные.ЭффективнаяДоля);
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.ФормаДокументаУХ", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПоказатьЗначение(Неопределено, Элементы.УведомленияОбУчастии.ТекущиеДанные.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УведомленияОбУчастииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элементы.УведомленияОбУчастии.ТекущиеДанные.Документ) = Тип("Строка") Тогда
	Иначе
		ПоказатьЗначение(Неопределено, Элементы.УведомленияОбУчастии.ТекущиеДанные.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьОткрытьУведомлениеОКИК(Команда)
	Если Элементы.УведомленияОКИК.ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Отсутствуют данные об иностранных инвестициях'"));
	ИначеЕсли ТипЗнч(Элементы.УведомленияОКИК.ТекущиеДанные.Документ) = Тип("Строка") Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Организация", Элементы.РеестрОсновной.ТекущиеДанные.Инвестор);
		ПараметрыФормы.Вставить("ВидУведомления", ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК"));
		ПараметрыФормы.Вставить("ИмяОтчета", "РегламентированноеУведомлениеКИК");
		ПараметрыФормы.Вставить("Дата", ДатаРеестра);
		ПараметрыФормы.Вставить("Инвестиция", Элементы.УведомленияОКИК.ТекущиеДанные.ОбъектИнвестирования);
		ПараметрыФормы.Вставить("ЭффективнаяДоля", Элементы.УведомленияОКИК.ТекущиеДанные.ЭффективнаяДоля);
		ПараметрыФормы.Вставить("НалоговыйПериод", Год);
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.ФормаДокументаУХ", ПараметрыФормы, ЭтаФорма);
	Иначе
		ПоказатьЗначение(Неопределено, Элементы.УведомленияОКИК.ТекущиеДанные.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГодПриИзменении(Элемент)
	Если Элементы.РеестрОсновной.ТекущиеДанные = Неопределено Тогда
		УстановкаОтборов(Неопределено);
	Иначе
		УстановкаОтборов(Элементы.РеестрОсновной.ТекущиеДанные.Инвестор);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УведомленияОКИКВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ТипЗнч(Элементы.УведомленияОКИК.ТекущиеДанные.Документ) = Тип("Строка") Тогда
	Иначе
		ПоказатьЗначение(Неопределено, Элементы.УведомленияОКИК.ТекущиеДанные.Документ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьУведомлениеКИК(Команда)
	Если ТипЗнч(Элементы.УведомленияОКИК.ТекущиеДанные.Документ) <> Тип("Строка") Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("УдалитьУведомлениеЗавершение", ЭтотОбъект, Элементы.УведомленияОКИК), НСтр("ru = 'Пометить на удаление Уведомление?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
