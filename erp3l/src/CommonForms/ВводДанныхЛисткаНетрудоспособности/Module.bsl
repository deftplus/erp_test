#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДатаНачалаСобытия", ДатаНачалаСобытия);
	Параметры.Свойство("НомерЛисткаНетрудоспособности", НомерЛисткаНетрудоспособности);
	Параметры.Свойство("СтрокаВозвращаемыхРеквизитов", СтрокаВозвращаемыхРеквизитов);
	Параметры.Свойство("ГоловнаяОрганизация", ГоловнаяОрганизация);
	Параметры.Свойство("ФизическоеЛицо", ФизическоеЛицо);
	Параметры.Свойство("Номер", Номер);
	Параметры.Свойство("Дата", Дата);
	
	Для Каждого Структура Из Параметры.ПериодыУходаЗаРодственниками Цикл
		ПериодУхода = ПериодыУходаЗаРодственниками.Добавить();
		ЗаполнитьЗначенияСвойств(ПериодУхода, Структура);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ПоУходуИспользованоДней1) Или ЗначениеЗаполнено(ПоУходуИспользованоДней2) Тогда
		ПоУходуИспользованоДнейВидимость = Истина;
	Иначе
		ПоУходуИспользованоДнейВидимость = ПрямыеВыплатыПособийСоциальногоСтрахования.ВидимостьИспользованныхДнейПоУходу(
			Параметры.Организация,
			ДатаНачалаСобытия);
	КонецЕсли;
	Элементы.ДекорацияПоУходуИспользованоДней.Видимость = ПоУходуИспользованоДнейВидимость;
	Элементы.ПоУходуИспользованоДней1.Видимость         = ПоУходуИспользованоДнейВидимость;
	Элементы.ПоУходуИспользованоДней2.Видимость         = ПоУходуИспользованоДнейВидимость;
	
	Параметры.Свойство("СтрокаВозвращаемыхРеквизитов", СтрокаВозвращаемыхРеквизитов);
	Параметры.Свойство("ТолькоПросмотр", ТолькоПросмотр);
	
	Если ТолькоПросмотр Тогда
		Элементы.ФормаОК.Видимость = Ложь;
		Элементы.ФормаОтмена.Заголовок = НСтр("ru = 'Закрыть';
												|en = 'Close'");
		Элементы.ФормаОтмена.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаВозвращаемыхРеквизитов) Тогда
		ДанныеОбъекта = Новый Структура(СтрокаВозвращаемыхРеквизитов);
		ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Параметры);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеОбъекта);
		
		Если ДанныеОбъекта.ОсновноеМестоРаботы Тогда
			ОсновноеМестоРаботы = 0;
		Иначе
			ОсновноеМестоРаботы = 1;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерЛисткаНетрудоспособности) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = СтрШаблон(НСтр("ru = 'Листок нетрудоспособности %1';
									|en = 'Sick leave record %1'"), НомерЛисткаНетрудоспособности);
	КонецЕсли;
	СведенияОбЭЛН = РегистрыСведений.СведенияОбЭЛН.ЗначенияРесурсов(НомерЛисткаНетрудоспособности, ГоловнаяОрганизация);
	Если СведенияОбЭЛН <> Неопределено Тогда
		ДоступенИсходныйXML = СведенияОбЭЛН.ДоступенИсходныйXML;
		ЭтоЭЛН = ДоступенИсходныйXML Или ЗначениеЗаполнено(СведенияОбЭЛН.Хеш);
	Иначе
		ДоступенИсходныйXML = Ложь;
		ЭтоЭЛН = Ложь;
	КонецЕсли;
	Если ЭтоЭЛН Тогда
		Элементы.ПериодыЛеченияРодственниковЭЛН.Видимость = (ПериодыУходаЗаРодственниками.Количество() > 0);
		ДобавитьПредпреждениеПриРедактированииЭлементовЭЛН();
	Иначе
		Элементы.ПериодыЛеченияРодственниковЭЛН.Видимость = Ложь;
	КонецЕсли;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы")
			И Элемент.Вид = ВидПоляФормы.ПолеВвода
			И Не ЗначениеЗаполнено(Элемент.ПолучитьДействие("ПриИзменении")) Тогда
			Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзменении");
		КонецЕсли;
	КонецЦикла;
	
	ДоступныРанниеСроки = УчетПособийСоциальногоСтрахования.ДоступноПособиеВставшимНаУчетВРанниеСроки(ДатаНачалаСобытия);
	Элементы.ПоясняющаяНадписьОбОтменеЕдиновременногоПособияВставшимНаУчетВРанниеСроки.Видимость = (
		ДатаНачалаСобытия >= УчетПособийСоциальногоСтрахованияКлиентСервер.ДатаОтменыЕдиновременногоПособияВставшимНаУчетВРанниеСроки());
	Элементы.ПоставленаНаУчетВРанниеСрокиБеременности.Доступность = (
		ПоставленаНаУчетВРанниеСрокиБеременности = Перечисления.ПостановкаНаУчетВРанниеСрокиБеременности.Поставлена
		Или ДоступныРанниеСроки);
	КлючСохраненияПоложенияОкна = Формат(Элементы.ПоясняющаяНадписьОбОтменеЕдиновременногоПособияВставшимНаУчетВРанниеСроки.Видимость, "БЛ=0; БИ=1");
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодПричиныНетрудоспособности(Элементы.КодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодПричиныНетрудоспособности(Элементы.ВторойКодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораДополнительныйКодПричиныНетрудоспособности(Элементы.ДополнительныйКодПричиныНетрудоспособности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодНарушенияРежима(Элементы.КодНарушенияРежима);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораГруппаИнвалидности(Элементы.ГруппаИнвалидности);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораИное(Элементы.НовыйСтатусНетрудоспособного);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод1);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод2);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораКодУсловийИсчисления(Элементы.УсловияИсчисленияКод3);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораТипРодственнойСвязи(Элементы.ПоУходуРодственнаяСвязь1);
	ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ЗаполнитьСписокВыбораТипРодственнойСвязи(Элементы.ПоУходуРодственнаяСвязь2);
	
	ЕстьСсылкиРодственников = Параметры.Свойство("РодственникЗаКоторымОсуществляетсяУход1");
	Элементы.ДекорацияПоУходуСсылка.Видимость                  = ЕстьСсылкиРодственников;
	Элементы.РодственникЗаКоторымОсуществляетсяУход1.Видимость = ЕстьСсылкиРодственников;
	Элементы.РодственникЗаКоторымОсуществляетсяУход2.Видимость = ЕстьСсылкиРодственников;
	Если Не ЕстьСсылкиРодственников Тогда
		Элементы.ДекорацияПоУходуФИО.Заголовок = НСтр("ru = 'ФИО члена семьи, за которым осуществляется уход:';
														|en = 'Full name of the relative for whom care is provided:'");
		Элементы.ПоУходуФИО1.Ширина = 0;
		Элементы.ПоУходуФИО2.Ширина = 0;
	КонецЕсли;
	
	Элементы.НомерЛисткаПоОсновномуМестуРаботы.Видимость = (ОсновноеМестоРаботы <> 0);
	ОбновитьФорму();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МедицинскаяОрганизацияПриИзменении(Элемент)
	Модифицированность = Истина;
	ОбновитьРеквизитыМедицинскойОрганизацииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ОсвобождениеДатаНачала1ПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия)
		Или ДатаНачалаСобытия > ОсвобождениеДатаНачала1 Тогда
		ДатаНачалаСобытия = ОсвобождениеДатаНачала1;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсвобождениеДатаНачала2ПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия)
		Или ДатаНачалаСобытия > ОсвобождениеДатаНачала2 Тогда
		ДатаНачалаСобытия = ОсвобождениеДатаНачала2;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсвобождениеДатаНачала3ПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(ДатаНачалаСобытия)
		Или ДатаНачалаСобытия > ОсвобождениеДатаНачала3 Тогда
		ДатаНачалаСобытия = ОсвобождениеДатаНачала3;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НовыйСтатусНетрудоспособногоПриИзменении(Элемент)
	Модифицированность = Истина;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура НомерЛисткаПродолженияПриИзменении(Элемент)
	Модифицированность = Истина;
	ОбновитьФорму();
КонецПроцедуры

&НаКлиенте
Процедура РодственникЗаКоторымОсуществляетсяУход1ПриИзменении(Элемент)
	Модифицированность = Истина;
	РодственникЗаКоторымОсуществляетсяУход1ПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура РодственникЗаКоторымОсуществляетсяУход2ПриИзменении(Элемент)
	Модифицированность = Истина;
	РодственникЗаКоторымОсуществляетсяУход2ПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзменении(Элемент)
	Модифицированность = Истина;
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуВозрастЛет1ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуВозрастЛет2ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуВозрастМесяцев1ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуВозрастМесяцев2ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуРодственнаяСвязь1ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуРодственнаяСвязь2ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуФИО1ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоУходуФИО2ПриИзменении(Элемент)
	РеквизитыРодственниковПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьБольничный(Команда)
	ОповеститьОВыборе(РезультатВыбора(Истина));
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ОповеститьОВыборе(РезультатВыбора(Ложь));
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРеквизитыМедицинскойОрганизации(Команда)
	ОбновитьРеквизитыМедицинскойОрганизацииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПериодыЛеченияРодственниковЭЛН(Команда)
	Форма = ПечатнаяФормаПериодовЛеченияРодственников();
	Форма.ТабличныйДокумент.Показать(Форма.ЗаголовокДокумента);
КонецПроцедуры

&НаСервере
Функция ПечатнаяФормаПериодовЛеченияРодственников()
	ДанныеЭЛН = Новый Структура;
	ПериодыЛечения = ОбменЛисткамиНетрудоспособностиФСС.СоздатьТаблицуПериодовЛеченияРодственников(ДанныеЭЛН);
	ПериодыЛечения.Колонки.Вставить(ПериодыЛечения.Колонки.Индекс(ПериодыЛечения.Колонки.ВозрастЛет), "Возраст");
	Для Каждого ПериодУхода Из ПериодыУходаЗаРодственниками Цикл
		СтрокаТаблицы = ПериодыЛечения.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ПериодУхода);
		СтрокаТаблицы.ФИО = СокрП(СтрокаТаблицы.Фамилия + " " + СтрокаТаблицы.Имя + " " + СтрокаТаблицы.Отчество);
		СтрокаТаблицы.КодСвязи = ПрямыеВыплатыПособийСоциальногоСтрахованияФормы.ПредставлениеРодственнойСвязи(
			СтрокаТаблицы.КодСвязи);
		СтрокаТаблицы.ТипЛечения = Перечисления.РежимыЛечения.Код(СтрокаТаблицы.РежимЛечения)
			+ " - "
			+ Строка(СтрокаТаблицы.РежимЛечения);
		СтрокаТаблицы.Возраст = ЗарплатаКадрыКлиентСервер.ПредставлениеВозраста(
			СтрокаТаблицы.ВозрастЛет,
			СтрокаТаблицы.ВозрастМесяцев);
	КонецЦикла;
	ПериодыЛечения.Колонки.Удалить("Фамилия");
	ПериодыЛечения.Колонки.Удалить("Имя");
	ПериодыЛечения.Колонки.Удалить("Отчество");
	ПериодыЛечения.Колонки.Удалить("РежимЛечения");
	ПериодыЛечения.Колонки.Удалить("ВозрастЛет");
	ПериодыЛечения.Колонки.Удалить("ВозрастМесяцев");
	ПериодыЛечения.Колонки.Удалить("РодственникСсылка");
	
	ТабличныйДокумент1 = Новый ТабличныйДокумент;
	
	ПостроительОтчета = Новый ПостроительОтчета;
	ПостроительОтчета.ИсточникДанных = Новый ОписаниеИсточникаДанных(ПериодыЛечения);
	ПостроительОтчета.ЗаполнитьНастройки();
	ПостроительОтчета.ВыводитьЗаголовокОтчета = Ложь;
	ПостроительОтчета.ВыводитьПодвалОтчета = Ложь;
	ПостроительОтчета.ВыводитьПодвалТаблицы = Ложь;
	ПостроительОтчета.ВыводитьОбщиеИтоги = Ложь;
	
	// Получение автоматически сгенерированного макета
	ПостроительОтчета.Макет = Неопределено;
	Макет = ПостроительОтчета.Макет;
	ИскатьПоСтрокам = Истина;
	ЯчейкаЦеликом   = Истина;
	
	ОбластьПараметров = Макет.Области.Детали;
	Область = Макет.НайтиТекст("ДатаРождения", , ОбластьПараметров, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Формат = "ДЛФ=D";
	Область = Макет.НайтиТекст("ДатаНачала", , ОбластьПараметров, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Формат = "ДЛФ=D";
	Область = Макет.НайтиТекст("ДатаОкончания", , ОбластьПараметров, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Формат = "ДЛФ=D";
	
	ОбластьЗаголовков = Макет.Области.ШапкаТаблицы;
	Область = Макет.НайтиТекст("ФИО", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.ШиринаКолонки = 30;
	Область = Макет.НайтиТекст("КодСвязи", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'Код связи';
						|en = 'Relationship code'");
	Область.ШиринаКолонки = 13;
	Область = Макет.НайтиТекст("ДатаРождения", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'Дата рождения';
						|en = 'Date of birth'");
	Область.ШиринаКолонки = 13;
	Область = Макет.НайтиТекст("Возраст", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'Возраст';
						|en = 'Age'");
	Область.ШиринаКолонки = 15;
	Область = Макет.НайтиТекст("СНИЛС", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.ШиринаКолонки = 12;
	Область = Макет.НайтиТекст("КодПричины", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'Код причины';
						|en = 'Reason code'");
	Область.ШиринаКолонки = 12;
	Область = Макет.НайтиТекст("ТипЛечения", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'Тип лечения';
						|en = 'Treatment type'");
	Область.ШиринаКолонки = 18;
	Область = Макет.НайтиТекст("ДатаНачала", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'С';
						|en = 'From'");
	Область.ШиринаКолонки = 9;
	Область = Макет.НайтиТекст("ДатаОкончания", , ОбластьЗаголовков, ИскатьПоСтрокам, ЯчейкаЦеликом);
	Область.Текст = НСтр("ru = 'По';
						|en = 'To'");
	Область.ШиринаКолонки = 9;
	
	ПостроительОтчета.Макет = Макет;
	ПостроительОтчета.Вывести(ТабличныйДокумент1);
	
	// Второй табличный документ нужен для того, чтобы:
	// - избавиться от пустой первой строки,
	// - восстановить форматирование ширины колонок.
	ТабличныйДокумент2 = Новый ТабличныйДокумент;
	ТабличныйДокумент2.Вывести(ТабличныйДокумент1.ПолучитьОбласть(1, 2, ТабличныйДокумент1.ВысотаТаблицы, ТабличныйДокумент1.ШиринаТаблицы));
	Область = ТабличныйДокумент2.Область();
	Область.СоздатьФорматСтрок();
	Область.Защита = Истина;
	
	// Настройки отображения документа.
	ТабличныйДокумент2.ОтображатьСетку      = Ложь;
	ТабличныйДокумент2.ОтображатьЗаголовки  = Ложь;
	ТабличныйДокумент2.ТолькоПросмотр       = Истина;
	ТабличныйДокумент2.ОриентацияСтраницы   = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент2.КлючПараметровПечати = "ПараметрыПечати_ПериодыЛеченияРодственников";
	УправлениеПечатьюБЗК.УстановитьОтступ(ТабличныйДокумент2, 0, 0, 0, 0);
	
	Если ЗначениеЗаполнено(Номер) И ЗначениеЗаполнено(Дата) Тогда
		Где = СтрШаблон(НСтр("ru = 'в больничном %1 от %2';
							|en = 'on sick leave %1 from %2'"), Номер, Формат(Дата, "ДЛФ=D"));
	Иначе
		Где = СтрШаблон(НСтр("ru = 'в ЭЛН %1';
							|en = 'in ESLR %1'"), НомерЛисткаНетрудоспособности);
	КонецЕсли;
	ЗаголовокДокумента = СтрШаблон(НСтр("ru = 'Периоды лечения родственников %1';
										|en = 'Relative care periods %1'"), Где);
	
	Возврат Новый Структура("ТабличныйДокумент, ЗаголовокДокумента", ТабличныйДокумент2, ЗаголовокДокумента);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьРеквизитыМедицинскойОрганизацииНаСервере()
	РеквизитыЛПУ = РеквизитыЛПУ(МедицинскаяОрганизация);
	НаименованиеМедицинскойОрганизации = РеквизитыЛПУ.Наименование;
	ОГРНМедицинскойОрганизации         = РеквизитыЛПУ.ОГРН;
	АдресМедицинскойОрганизации        = РеквизитыЛПУ.Адрес;
	ОбновитьФорму(РеквизитыЛПУ);
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму(РеквизитыЛПУ = Неопределено)
	ОбновитьРеквизитыЛПУ(РеквизитыЛПУ);
	ОбновитьРеквизитыРодственников();
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизитыЛПУ(РеквизитыЛПУ = Неопределено)
	Если ЗначениеЗаполнено(МедицинскаяОрганизация) Тогда
		МедицинскаяОрганизацияДопИнформация = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'ОГРН: %1, Адрес: %2.';
				|en = 'Registration number: %1, Address: %2.'"),
			ОГРНМедицинскойОрганизации,
			АдресМедицинскойОрганизации);
	Иначе
		МедицинскаяОрганизацияДопИнформация = "";
	КонецЕсли;
	Если РеквизитыЛПУ = Неопределено Тогда
		РеквизитыЛПУ = РеквизитыЛПУ(МедицинскаяОрганизация);
	КонецЕсли;
	Элементы.ОбновитьРеквизитыМедицинскойОрганизации.Видимость = (
		НаименованиеМедицинскойОрганизации <> РеквизитыЛПУ.Наименование
		Или ОГРНМедицинскойОрганизации     <> РеквизитыЛПУ.ОГРН
		Или АдресМедицинскойОрганизации    <> РеквизитыЛПУ.Адрес);
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьДоступность()
	
	Обязательность = (НовыйСтатусНетрудоспособного = "31");
	ОбщегоНазначенияБЗККлиентСервер.УстановитьОбязательностьПоляВводаФормы(
		ЭтотОбъект,
		Элементы.НомерЛисткаПродолжения.Имя,
		Обязательность);
	Если Обязательность Или ЗначениеЗаполнено(НомерЛисткаПродолжения) Тогда
		ТекстОшибки = УчетПособийСоциальногоСтрахования.ПроверитьНомерЛН(НомерЛисткаПродолжения);
	Иначе
		ТекстОшибки = "";
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		Элементы.НомерЛисткаПродолжения.Подсказка = ТекстОшибки;
		Элементы.НомерЛисткаПродолжения.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		Элементы.НомерЛисткаПродолжения.ЦветТекстаЗаголовка = ЦветаСтиля.ПоясняющийОшибкуТекст;
	Иначе
		Элементы.НомерЛисткаПродолжения.Подсказка = "";
		Элементы.НомерЛисткаПродолжения.ОтображениеПодсказки = ОтображениеПодсказки.Авто;
		Элементы.НомерЛисткаПродолжения.ЦветТекстаЗаголовка = Новый Цвет;
	КонецЕсли;
	
	Если Не ТолькоПросмотр Тогда
		Если Модифицированность И Не ЭтоЭЛН Тогда
			Элементы.ЗаполнитьБольничный.КнопкаПоУмолчанию = Истина;
		Иначе
			Элементы.ФормаОК.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РеквизитыЛПУ(МедицинскаяОрганизация)
	Если ЗначениеЗаполнено(МедицинскаяОрганизация) Тогда
		Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МедицинскаяОрганизация, "Наименование, ОГРН, Адрес");
	Иначе
		Возврат Новый Структура("Наименование, ОГРН, Адрес", "", "", "");
	КонецЕсли;
КонецФункции

&НаКлиенте
Функция РезультатВыбора(ЗаполнитьБольничный)
	ВведенныеДанные = Новый Структура(СтрокаВозвращаемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(ВведенныеДанные, ЭтотОбъект);
	Если ОсновноеМестоРаботы = 0 Тогда
		ВведенныеДанные.Вставить("ОсновноеМестоРаботы", Истина);
	Иначе
		ВведенныеДанные.Вставить("ОсновноеМестоРаботы", Ложь);
	КонецЕсли;
	ВведенныеДанные.Вставить("ЗаполнитьБольничный", ЗаполнитьБольничный);
	Возврат ВведенныеДанные;
КонецФункции

&НаСервере
Процедура ДобавитьПредпреждениеПриРедактированииЭлементовЭЛН()
	Элементы.ОсвобождениеДатаНачала1.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ОсвобождениеДатаОкончания1.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ОсвобождениеДолжностьВрача1.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ОсвобождениеФИОВрача1.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ПриступитьКРаботеС.АвтоОтметкаНезаполненного = Ложь;
	Элементы.ЗаполнитьБольничный.Видимость = Ложь;
	
	Предупреждение = НСтр("ru = 'Если электронный листок нетрудоспособности содержит ошибки, то необходимо сообщить в медицинскую организацию. ЭЛН может быть аннулирован и выдан исправленный дубликат';
							|en = 'If an electronic sick leave record contains errors, inform your healthcare provider. The ESLR can be canceled and replaced with a corrected duplicate'");
	СвойстваПоляФормы = Новый Структура;
	СвойстваПоляФормы.Вставить("ОтображениеПредупрежденияПриРедактировании", ОтображениеПредупрежденияПриРедактировании.Отображать);
	СвойстваПоляФормы.Вставить("ПредупреждениеПриРедактировании", Предупреждение);
	СвойстваПоляФормы.Вставить("ЦветТекстаЗаголовка", ЦветаСтиля.ЗаголовокПоляЗаполняемогоАвтоматическиЦветБЗК);
	
	Исключения = ВсеЭлементыГруппы(Элементы.ГруппаЗаполняетсяРаботодателем);
	Исключения.Добавить(Элементы.ПоставленаНаУчетВРанниеСрокиБеременности);
	
	Для Каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") И Исключения.Найти(Элемент) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Элемент, СвойстваПоляФормы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВсеЭлементыГруппы(ГруппаФормы, Исключения = Неопределено, Результат = Неопределено)
	Если Результат = Неопределено Тогда
		Результат = Новый Массив;
	КонецЕсли;
	
	Для Каждого Элемент Из ГруппаФормы.ПодчиненныеЭлементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			ВсеЭлементыГруппы(Элемент, Исключения, Результат);
		ИначеЕсли Исключения = Неопределено Или Исключения.Найти(Элемент) = Неопределено Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура РодственникЗаКоторымОсуществляетсяУход1ПриИзмененииНаСервере()
	ОбновитьРеквизитыРодственников(Истина, Ложь);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура РодственникЗаКоторымОсуществляетсяУход2ПриИзмененииНаСервере()
	ОбновитьРеквизитыРодственников(Ложь, Истина);
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура РеквизитыРодственниковПриИзмененииНаСервере()
	Модифицированность = Истина;
	ОбновитьРеквизитыРодственников();
	ОбновитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизитыРодственников(Знач ЗаменитьРодственника1 = Ложь, Знач ЗаменитьРодственника2 = Ложь)
	
	Родственники = Новый Массив;
	Если ЗначениеЗаполнено(РодственникЗаКоторымОсуществляетсяУход1) Тогда
		Родственники.Добавить(РодственникЗаКоторымОсуществляетсяУход1);
	КонецЕсли;
	Если ЗначениеЗаполнено(РодственникЗаКоторымОсуществляетсяУход2) Тогда
		ОбщегоНазначенияБЗК.ДобавитьЗначениеВМассив(Родственники, РодственникЗаКоторымОсуществляетсяУход2);
	КонецЕсли;
	
	ИменаПолей = "Наименование, ДатаРождения, КодСвязи";
	РеквизитыРодственника1 = Новый Структура(ИменаПолей + ", ВозрастЛет, ВозрастМесяцев");
	РеквизитыРодственника2 = Новый Структура(ИменаПолей + ", ВозрастЛет, ВозрастМесяцев");
	Если Родственники.Количество() > 0 Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(Родственники, ИменаПолей);
		Для Каждого КлючИЗначение Из ЗначенияРеквизитов Цикл
			Реквизиты = КлючИЗначение.Значение;
			Если ЗначениеЗаполнено(Реквизиты.ДатаРождения) И ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
				РазмерПериода = ОбщегоНазначенияБЗК.РазмерПериода(Реквизиты.ДатаРождения, ДатаНачалаСобытия);
				Реквизиты.Вставить("ВозрастЛет",     РазмерПериода.Лет);
				Реквизиты.Вставить("ВозрастМесяцев", РазмерПериода.Месяцев);
			Иначе
				Реквизиты.Вставить("ВозрастЛет",     0);
				Реквизиты.Вставить("ВозрастМесяцев", 0);
			КонецЕсли;
			Если КлючИЗначение.Ключ = РодственникЗаКоторымОсуществляетсяУход1 Тогда
				ЗаполнитьЗначенияСвойств(РеквизитыРодственника1, КлючИЗначение.Значение);
			КонецЕсли;
			Если КлючИЗначение.Ключ = РодственникЗаКоторымОсуществляетсяУход2 Тогда
				ЗаполнитьЗначенияСвойств(РеквизитыРодственника2, КлючИЗначение.Значение);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьРеквизитыРодственника("1", РеквизитыРодственника1, ЗаменитьРодственника1);
	ОбновитьРеквизитыРодственника("2", РеквизитыРодственника2, ЗаменитьРодственника2);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРеквизитыРодственника(Номер, РеквизитыРодственника, ЗаменитьРодственника)
	
	Если ЗаменитьРодственника Тогда
		
		ЭтотОбъект["ПоУходуФИО"              + Номер] = РеквизитыРодственника.Наименование;
		ЭтотОбъект["ПоУходуРодственнаяСвязь" + Номер] = РеквизитыРодственника.КодСвязи;
		ЭтотОбъект["ПоУходуВозрастЛет"       + Номер] = РеквизитыРодственника.ВозрастЛет;
		ЭтотОбъект["ПоУходуВозрастМесяцев"   + Номер] = РеквизитыРодственника.ВозрастМесяцев;
		
	КонецЕсли;
	
	РодственникЗаполнен = ЗначениеЗаполнено(ЭтотОбъект["РодственникЗаКоторымОсуществляетсяУход" + Номер]);
	
	НаименованиеИзменено = РодственникЗаполнен
		И ЗначениеЗаполнено(РеквизитыРодственника.Наименование)
		И ЭтотОбъект["ПоУходуФИО" + Номер] <> РеквизитыРодственника.Наименование;
	РодственнаяСвязьИзменена = РодственникЗаполнен
		И ЗначениеЗаполнено(РеквизитыРодственника.КодСвязи)
		И ЭтотОбъект["ПоУходуРодственнаяСвязь" + Номер] <> РеквизитыРодственника.КодСвязи;
	ВозрастИзменен = РодственникЗаполнен
		И ЗначениеЗаполнено(РеквизитыРодственника.ДатаРождения)
		И ЗначениеЗаполнено(ДатаНачалаСобытия)
		И Не (ЭтотОбъект["ПоУходуВозрастЛет"     + Номер] = РеквизитыРодственника.ВозрастЛет
			И ЭтотОбъект["ПоУходуВозрастМесяцев" + Номер] = РеквизитыРодственника.ВозрастМесяцев);
	
	НастроитьПолеРодственника(Элементы["ПоУходуФИО"              + Номер], НаименованиеИзменено,     РодственникЗаполнен);
	НастроитьПолеРодственника(Элементы["ПоУходуРодственнаяСвязь" + Номер], РодственнаяСвязьИзменена, РодственникЗаполнен);
	НастроитьПолеРодственника(Элементы["ПоУходуВозрастЛет"       + Номер], ВозрастИзменен,           РодственникЗаполнен);
	НастроитьПолеРодственника(Элементы["ПоУходуВозрастМесяцев"   + Номер], ВозрастИзменен,           РодственникЗаполнен);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПолеРодственника(Поле, ЗначениеИзменено, РодственникЗаполнен)
	Если ЗначениеИзменено Тогда
		Поле.Шрифт = ШрифтыСтиля.ИзмененныйРеквизитШрифт;
	Иначе
		Поле.Шрифт = ШрифтыСтиля.ОбычныйШрифтТекста;
	КонецЕсли;
	Если ЗначениеИзменено Или ЭтоЭЛН Или Не РодственникЗаполнен Тогда
		Поле.ЦветТекста          = Новый Цвет;
		Поле.ЦветТекстаЗаголовка = Новый Цвет;
		Поле.ЦветРамки           = Новый Цвет;
	Иначе
		Поле.ЦветТекста          = ЦветаСтиля.ЗакрытыйДокумент;
		Поле.ЦветТекстаЗаголовка = ЦветаСтиля.ЗакрытыйДокумент;
		Поле.ЦветРамки           = ЦветаСтиля.НедоступныеДанныеЦвет;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
