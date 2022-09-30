
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбработатьПараметры(Параметры);
	ИнициализироватьДанные();
	ИзменитьОформлениеФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПередЗакрытием_Завершение", 
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОписаниеОповещения, 
		Отказ, 
		ЗавершениеРаботы);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УмершийКормилецПолучаетПенсиюПоФЗ4468_1ПриИзменении(Элемент)
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюПоФЗ4468_1(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УмершийКормилецПолучаетПенсиюПоФЗ4468_1Очистка(Элемент, СтандартнаяОбработка)
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюПоФЗ4468_1(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗаявлениеОНазначенииНажатие(Элемент)
	
	ВоеннаяСлужбаПоПризывуНачало    = Неопределено;
	ВоеннаяСлужбаПоПризывуОкончание = Неопределено;
	ИзменитьОформлениеВоеннаяСлужбаПоПризыву(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВоеннаяСлужбаПоПризывуПредставлениеНажатие(Элемент)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	
	Диалог.Период.ДатаНачала    = ВоеннаяСлужбаПоПризывуНачало;
	Диалог.Период.ДатаОкончания = ВоеннаяСлужбаПоПризывуОкончание;
	
	ДополнительныеПараметры = Новый Структура("Диалог", Диалог);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ВоеннаяСлужбаПоПризывуПредставлениеНажатие_Завершение", 
		ЭтотОбъект, 
		ДополнительныеПараметры);
		
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДопФормуНажатие(Элемент)
	
	ИмяТаблицы = СтрЗаменить(Элемент.Имя, "Представление", "");
	
	ДополнительныеПараметры = ПараметрыОткрытияДопФормы(ИмяТаблицы);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		ИмяТаблицы + "ПредставлениеНажатие_Завершение", 
		ЭтотОбъект);
		
	ОткрытьФорму("Справочник.ЗаявлениеОНазначенииПенсии.Форма." + ИмяТаблицы, ДополнительныеПараметры,,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучаетПенсиюДругогоГосударстваПриИзменении(Элемент)
	ИзменитьОформлениеПолучаетПенсиюДругогоГосударства(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолучаетПенсиюДругогоГосударстваОчистка(Элемент, СтандартнаяОбработка)
	ИзменитьОформлениеПолучаетПенсиюДругогоГосударства(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолучаетПенсиюПоФЗ4468_1ПриИзменении(Элемент)
	ИзменитьОформлениеПолучаетПенсиюПоФЗ4468_1(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолучаетПенсиюПоФЗ4468_1Очистка(Элемент, СтандартнаяОбработка)
	ИзменитьОформлениеПолучаетПенсиюПоФЗ4468_1(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УмершийКормилецПолучалПенсиюДругогоГосударстваПриИзменении(Элемент)
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюДругогоГосударства(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура УмершийКормилецПолучалПенсиюДругогоГосударстваОчистка(Элемент, СтандартнаяОбработка)
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюДругогоГосударства(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Функция ПараметрыОткрытияДопФормы(ИмяТаблицы)

	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	АдресТаблицы = ПоместитьВоВременноеХранилище(ЭтотОбъект[ИмяТаблицы].Выгрузить(), Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("АдресТаблицы" + ИмяТаблицы, АдресТаблицы);
	ДополнительныеПараметры.Вставить("ВидПенсииОсновной", ВидПенсииОсновной);
	ДополнительныеПараметры.Вставить("ВидПенсииВторой",   ВидПенсииВторой);
	ДополнительныеПараметры.Вставить("НовыйВидПенсии",    НовыйВидПенсии);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаКлиенте
Процедура Сохранить(Команда = Неопределено)
	
	ДанныеКорректны = Истина;
	
	ДопСведенияУказаныКорректно(ЭтотОбъект, ДанныеКорректны);
	
	Если ДанныеКорректны Тогда
		
		ДополнительныеПараметры = ПараметрыСохраненияНаСервере();
		Модифицированность = Ложь;
		Закрыть(ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВоеннаяСлужбаПоПризывуПредставлениеНажатие_Завершение(Период, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если Период <> Неопределено Тогда
		
		Модифицированность = Истина;
		
		ВоеннаяСлужбаПоПризывуНачало    = Диалог.Период.ДатаНачала;
		ВоеннаяСлужбаПоПризывуОкончание = Диалог.Период.ДатаОкончания;
	
		ИзменитьОформлениеВоеннаяСлужбаПоПризыву(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеВоеннаяСлужбаПоПризыву(Форма)
	
	Элементы  = Форма.Элементы;
	// Только для мужчин
	Видимость = Форма.Пол = ПредопределенноеЗначение("Перечисление.ПолФизическогоЛица.Мужской")
		И ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиИнвалидностиНакопительная(Форма);
	
	Элементы.ВоеннаяСлужбаПоПризывуЗаголовок.Видимость = Видимость;
	Элементы.ВоеннаяСлужбаПоПризывуЗаголовокДанные.Видимость = Видимость;
	
	// Текст
	Представление = ПредставлениеПериода(Форма.ВоеннаяСлужбаПоПризывуНачало, КонецДня(Форма.ВоеннаяСлужбаПоПризывуОкончание));
	
	Если ЗначениеЗаполнено(Форма.ВоеннаяСлужбаПоПризывуНачало) ИЛИ ЗначениеЗаполнено(Форма.ВоеннаяСлужбаПоПризывуОкончание) Тогда
		
		Элементы.ВоеннаяСлужбаПоПризывуПредставление.Заголовок = Представление;
		Элементы.ОчиститьЗаявлениеОНазначении.Видимость        = НЕ Форма.ЗапретитьИзменение;
	Иначе
		Элементы.ВоеннаяСлужбаПоПризывуПредставление.Заголовок = НСтр("ru = 'Заполнить';
																		|en = 'Заполнить'");
		Элементы.ОчиститьЗаявлениеОНазначении.Видимость        = Ложь;
	КонецЕсли;
	
	// Цвет
	МастерДалее = Истина;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВоеннаяСлужбаПоПризывуУказанаКорректно(Форма, МастерДалее, Ложь);
	Если МастерДалее Тогда
		Элементы.ВоеннаяСлужбаПоПризывуПредставление.ЦветТекста = Новый Цвет();
	Иначе
		Элементы.ВоеннаяСлужбаПоПризывуПредставление.ЦветТекста = Форма.КрасныйЦвет;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПараметрыСохраненияНаСервере()
	
	ДополнительныеПараметры = Новый Структура(ПараметрыФормы);
	ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, ЭтотОбъект, ПараметрыФормы); 
	ДополнительныеПараметры.Вставить("ПараметрыФормы", ПараметрыФормы);
	
	АдресТаблицыДети = ПоместитьВоВременноеХранилище(Дети.Выгрузить(), Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("АдресТаблицыДети", АдресТаблицыДети);
	
	АдресТаблицыИнвалидыПожилые = ПоместитьВоВременноеХранилище(ИнвалидыПожилые.Выгрузить(), Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("АдресТаблицыИнвалидыПожилые", АдресТаблицыИнвалидыПожилые);
	
	АдресТаблицыВоеннаяСлужба = ПоместитьВоВременноеХранилище(ВоеннаяСлужба.Выгрузить(), Новый УникальныйИдентификатор);
	ДополнительныеПараметры.Вставить("АдресТаблицыВоеннаяСлужба", АдресТаблицыВоеннаяСлужба);
	
	ДополнительныеПараметры.Вставить("Модифицированность", Модифицированность);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

&НаКлиенте
Процедура ДетиПредставлениеНажатие_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Модифицированность Тогда
		Модифицированность = Истина;
		ВывестиРезультатЗаполненияДетейНаСервере(Результат);
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультатЗаполненияДетейНаСервере(Результат)
	
	Таблица = ПолучитьИзВременногоХранилища(Результат.АдресТаблицыДети);
	ЗначениеВРеквизитФормы(Таблица, "Дети");

	ИзменитьОформлениеДетей(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВоеннаяСлужбаПредставлениеНажатие_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Модифицированность Тогда
		Модифицированность = Истина;
		ВывестиРезультатЗаполненияВоеннаяСлужбаНаСервере(Результат);
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультатЗаполненияВоеннаяСлужбаНаСервере(Результат)
	
	Таблица = ПолучитьИзВременногоХранилища(Результат.АдресТаблицыВоеннаяСлужба);
	ЗначениеВРеквизитФормы(Таблица, "ВоеннаяСлужба");

	ИзменитьОформлениеВоеннаяСлужба(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеВоеннаяСлужба(Форма)
	
	Элементы = Форма.Элементы;
	
	// указывается в случае обращения за
	// страховой пенсией по старости, страховой пенсией по инвалидности, накопительной
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиИнвалидностиНакопительная(Форма);
	
	Элементы.ВоеннаяСлужбаПредставление.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПредставлениеВоеннаяСлужба(Форма.ВоеннаяСлужба);
	Элементы.ВоеннаяСлужбаПредставление.Видимость = Видимость;
	Элементы.ВоеннаяСлужбаЗаголовок.Видимость     = Видимость;

	// Текст
	Если Форма.ВоеннаяСлужба.Количество() > 0 Тогда
		
		Представление = Новый Массив;
		Для каждого СтрокаВоеннаяСлужба Из Форма.ВоеннаяСлужба Цикл
			СтрокаПредставления = ПредставлениеПериода(СтрокаВоеннаяСлужба.ДатаНачала,
				КонецДня(СтрокаВоеннаяСлужба.ДатаОкончания));
			СтрокаПредставления = СокрЛП(СтрокаПредставления);
			Представление.Добавить(СтрокаПредставления);
		КонецЦикла;
		
		Представление = СтрСоединить(Представление, ", ");
		Элементы.ВоеннаяСлужбаПредставление.Заголовок = Представление;
		
	Иначе
		Элементы.ВоеннаяСлужбаПредставление.Заголовок = НСтр("ru = 'Заполнить';
															|en = 'Заполнить'");
	КонецЕсли;
	
	// Цвет
	МастерДалее = Истина;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВоеннаяСлужбаУказаныКорректно(Форма, МастерДалее, Ложь);
	Если МастерДалее Тогда
		Элементы.ВоеннаяСлужбаПредставление.ЦветТекста = Новый Цвет();
	Иначе
		Элементы.ВоеннаяСлужбаПредставление.ЦветТекста = Форма.КрасныйЦвет;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ИнвалидыПожилыеПредставлениеНажатие_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Модифицированность Тогда
		Модифицированность = Истина;
		ВывестиРезультатЗаполненияИнвалидыПожилыеНаСервере(Результат);
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиРезультатЗаполненияИнвалидыПожилыеНаСервере(Результат)
	
	Таблица = ПолучитьИзВременногоХранилища(Результат.АдресТаблицыИнвалидыПожилые);
	ЗначениеВРеквизитФормы(Таблица, "ИнвалидыПожилые");

	ИзменитьОформлениеИнвалидов(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПараметры(Параметры)
	
	ПараметрыФормы = Параметры.ПараметрыФормы;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, ПараметрыФормы);
	
	ЗапретитьИзменение = Параметры.ЗапретитьИзменение;
	
	Таблица = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыДети);
	ЗначениеВРеквизитФормы(Таблица, "Дети");
	
	Таблица = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыИнвалидыПожилые);
	ЗначениеВРеквизитФормы(Таблица, "ИнвалидыПожилые");
	
	Таблица = ПолучитьИзВременногоХранилища(Параметры.АдресТаблицыВоеннаяСлужба);
	ЗначениеВРеквизитФормы(Таблица, "ВоеннаяСлужба");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ВходящийКонтекст) Экспорт
	
	Сохранить();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДопСведенияУказаныКорректно(Форма, МастерДалее = Истина)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ДопСведенияУказаныКорректно(Форма, МастерДалее, Истина);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеДетей(Форма)
	
	Элементы = Форма.Элементы;
	
	// указывается в случае обращения за
	// страховой пенсией по старости, страховой пенсией по инвалидности, накопительной
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиИнвалидностиНакопительная(Форма);
	
	Элементы.ДетиПредставление.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПредставлениеДетиИнвалиды(Форма.Дети);
	Элементы.ДетиПредставление.Видимость = Видимость;
	Элементы.ДетиЗаголовок.Видимость     = Видимость;
	
	// Цвет
	МастерДалее = Истина;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ДетиУказаныКорректно(Форма, МастерДалее, Ложь);
	Если МастерДалее Тогда
		Элементы.ДетиПредставление.ЦветТекста = Новый Цвет();
	Иначе
		Элементы.ДетиПредставление.ЦветТекста = Форма.КрасныйЦвет;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеИнвалидов(Форма)
	
	Элементы = Форма.Элементы;
	
	// указывается в случае обращения за
	// страховой пенсией по старости, страховой пенсией по инвалидности, накопительной
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиИнвалидностиНакопительная(Форма);
	
	Элементы.ИнвалидыПожилыеПредставление.Заголовок = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПредставлениеДетиИнвалиды(Форма.ИнвалидыПожилые);
	Элементы.ИнвалидыПожилыеПредставление.Видимость = Видимость;
	Элементы.ИнвалидыПожилыеЗаголовок.Видимость     = Видимость;

	// Цвет
	МастерДалее = Истина;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ИнвалидыПожилыеУказаныКорректно(Форма, МастерДалее, Ложь);
	Если МастерДалее Тогда
		Элементы.ИнвалидыПожилыеПредставление.ЦветТекста = Новый Цвет();
	Иначе
		Элементы.ИнвалидыПожилыеПредставление.ЦветТекста = Форма.КрасныйЦвет;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьОформлениеФормы(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Форма.ЗапретитьИзменение Тогда
		Элементы.НетрудоспособныхЧленов.ТолькоПросмотр           = Истина;
		Элементы.СведенияВлияющиеНаРазмерПенсии.ТолькоПросмотр  = Истина;
		Элементы.СведенияОбУмершемКормильце.ТолькоПросмотр       = Истина;
		Элементы.ГруппаНачислениеПенсии.ТолькоПросмотр           = Истина;
		Элементы.ДетиПредставление.Гиперссылка                   = Ложь;
		Элементы.ИнвалидыПожилыеПредставление.Гиперссылка        = Ложь;
		Элементы.ВоеннаяСлужбаПоПризывуПредставление.Гиперссылка = Ложь;
		Элементы.ВоеннаяСлужбаПредставление.Гиперссылка          = Ложь;
	КонецЕсли;
	
	Элементы.СведенияВлияющиеНаРазмерПенсии.Видимость  = Форма.ЭтоЗаявлениеОНазначенииПенсии;
	Элементы.ГруппаВоеннаяСлужба.Видимость             = Форма.ЭтоЗаявлениеОНазначенииПенсии;
	Элементы.ДетиИнвалидыВоеннаяСлужба.Видимость       = Форма.ЭтоЗаявлениеОНазначенииПенсии;
	
	ИзменитьОформлениеДетей(Форма);
	ИзменитьОформлениеИнвалидов(Форма);
	ИзменитьОформлениеЗамещаетГосударственнуюДолжность(Форма);
	ИзменитьОформлениеВоеннаяСлужбаПоПризыву(Форма);
	ИзменитьОформлениеВоеннаяСлужба(Форма);
	ИзменитьОформлениеПолучаетПенсиюДругогоГосударства(Форма);
	ИзменитьОформлениеПолучаетПенсиюПоФЗ4468_1(Форма);
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюДругогоГосударства(Форма);
	ИзменитьОформлениеУмершийКормилецПолучаетПенсиюПоФЗ4468_1(Форма);
	ИзменитьОформлениеПрописанВДругомГосударстве(Форма);
	ИзменитьОформлениеСогласенНеУчитыватьСтажИЗаработок(Форма);
	
	// В этом случае скрываются все гиперссылки в этой группе, кроме нетрудоспособных членов
	Если НЕ ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиИнвалидностиНакопительная(Форма) Тогда
		 Элементы.ДетиИнвалидыВоеннаяСлужба.Заголовок = НСтр("ru = 'Нетрудоспособные члены семьи';
															|en = 'Нетрудоспособные члены семьи'");
	КонецЕсли;
	
	ВидимостьБлокаОбУмершемКормильце = Форма.ЭтоЗаявлениеОНазначенииПенсии
		И ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоПотереКормильца(Форма);
		
	Элементы.СведенияОбУмершемКормильце.Видимость = ВидимостьБлокаОбУмершемКормильце;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанные()
	
	КрасныйЦвет = ЦветаСтиля.ЦветОшибкиПроверкиБРО;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеПолучаетПенсиюДругогоГосударства(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.СтранаВыплачивающаяПенсию.Видимость = Форма.ПолучаетПенсиюДругогоГосударства = ПредопределенноеЗначение("Перечисление.ОтветыНаВопросыОПенсии.Да");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеПолучаетПенсиюПоФЗ4468_1(Форма)
	
	Элементы = Форма.Элементы;
	
	Элементы.ВидПенсииПоФЗ4468_1.Видимость = Форма.ПолучаетПенсиюПоФЗ4468_1 = ПредопределенноеЗначение("Перечисление.ОтветыНаВопросыОПенсии.Да");
	Элементы.ОрганВыплачивающийПенсию.Видимость = Форма.ПолучаетПенсиюПоФЗ4468_1 = ПредопределенноеЗначение("Перечисление.ОтветыНаВопросыОПенсии.ДаВПрошлом");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеЗамещаетГосударственнуюДолжность(Форма)
	
	Элементы = Форма.Элементы;
	
	// делается отметка в случае обращения за страховой пенсией по старости,
	// накопительной пенсией
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиНакопительная(Форма);
	Элементы.ЗамещаетГосударственнуюДолжность.Видимость = Видимость;
	Элементы.УмершийКормилецЗамещалГосударственнуюДолжность.Видимость = Видимость;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеУмершийКормилецПолучаетПенсиюДругогоГосударства(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.СтранаВыплачивающаяПенсиюУмершемуКормильцу.Видимость = Форма.УмершийКормилецПолучалПенсиюДругогоГосударства = ПредопределенноеЗначение("Перечисление.ОтветыНаВопросыОПенсии.Да");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеУмершийКормилецПолучаетПенсиюПоФЗ4468_1(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ОрганВыплачивающийПенсиюУмершемуКормильцу.Видимость = Форма.УмершийКормилецПолучаетПенсиюПоФЗ4468_1 = ПредопределенноеЗначение("Перечисление.ОтветыНаВопросыОПенсии.Да");
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеПрописанВДругомГосударстве(Форма)
	
	Элементы = Форма.Элементы;
	
	// делается отметка в случае обращения за социальной пенсией
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСоциальнаяПенсия(Форма);
	Элементы.ПрописанВДругомГосударстве.Видимость = Видимость;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИзменитьОформлениеСогласенНеУчитыватьСтажИЗаработок(Форма)
	
	Элементы = Форма.Элементы;
	
	// делается отметка в случае
	// обращения за страховой пенсией, накопительной пенсией
	
	Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ЭтоСтраховаяПенсияПоСтаростиНакопительная(Форма);
	Элементы.ПрописанВДругомГосударстве.Видимость = Видимость;
	
КонецФункции

#КонецОбласти


