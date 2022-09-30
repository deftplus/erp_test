
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ИнициализироватьФормуНаСервере();
	КонецЕсли;

	ЗаполнитьДокументНаСервере(Новый Структура);//только расчетные показатели
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализироватьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)	
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйИнструментПриИзменении(Элемент)
	
	ФинансовыйИнструментПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СтоимостьПриИзменении(Элемент)
	ЗаполнитьДокумент(Новый Структура("РассчитатьПремию"));
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ЗаполнитьДокумент();
КонецПроцедуры

&НаКлиенте
Процедура СчетаУчета(Команда)
	ФинансовыеИнструментыФормыКлиент.ОткрытьФормуВыбораСчетов(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область ВспомогательныеПроцедурыФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;
	
	Элементы.ФинансовыйИнструментЦенаВыпуска.Видимость = Форма.ДисконтнаяЦБ;
			
	Элементы.Контрагент.Заголовок = ?(Форма.ЭтоБиржевойРынок, НСтр("ru = 'Андеррайтер'"), НСтр("ru = 'Контрагент'"));
	Элементы.Договор.Заголовок = ?(Форма.ЭтоБиржевойРынок, НСтр("ru = 'Договор с андеррайтером'"), НСтр("ru = 'Договор контрагента'"));
	
	ФинансовыеИнструментыФормыКлиентСервер.УправлениеФормой_СчетаУчета(Форма);
	ФинансовыеИнструментыФормыКлиентСервер.УправлениеФормойБюджетирование(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьДокумент(СтруктураДействий = Неопределено)
	
	Если Объект.ФинансовыйИнструмент.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьДокументНаСервере(СтруктураДействий)
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьДокументНаСервере(СтруктураДействий = Неопределено)
	
	Если ЗначениеЗаполнено(Объект.ФинансовыйИнструмент) Тогда
		РеквизитыФИ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ФинансовыйИнструмент, 
									"Эмитент,ПервыйПолучатель,ДисконтнаяЦБ,
									|ВидФинансовогоИнструмента,Должник,
									|ДатаВыпуска,ЦенаВыпуска,Количество,Номинал");
									
		
		Если СтруктураДействий = Неопределено Тогда
			СтруктураДействий = Новый Структура("ЗаполнитьКэшируемыеЗначения,ЗаполнитьНКД,РассчитатьСтоимостьНоминала,РассчитатьПремию,РассчитатьСтоимость");	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РеквизитыФИ.ПервыйПолучатель) Тогда
			Объект.Контрагент = РеквизитыФИ.ПервыйПолучатель;		
		КонецЕсли;
		
		Если ЗначениеЗаполнено(РеквизитыФИ.Эмитент) Тогда
			Объект.Организация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыФИ.Эмитент, "ОрганизационнаяЕдиница");
		КонецЕсли;
		
		Если РеквизитыФИ.Количество <> Неопределено И РеквизитыФИ.Количество > 0 Тогда
			Объект.Количество = РеквизитыФИ.Количество;
		КонецЕсли;
		
		Если СтруктураДействий.Свойство("РассчитатьСтоимость") Тогда
			Объект.Стоимость = ?(РеквизитыФИ.ДисконтнаяЦБ, РеквизитыФИ.ЦенаВыпуска, РеквизитыФИ.Номинал) * Объект.Количество;
		КонецЕсли;
		
		ЭтотОбъект.СтоимостьНоминала = ?(РеквизитыФИ.ДисконтнаяЦБ, РеквизитыФИ.ЦенаВыпуска, РеквизитыФИ.Номинал) * Объект.Количество;
		Премия = Объект.Стоимость - ?(РеквизитыФИ.ДисконтнаяЦБ, РеквизитыФИ.ЦенаВыпуска, РеквизитыФИ.Номинал) * Объект.Количество;
		ОбщегоНазначенияУХ.УстановитьНовоеЗначение(Объект.Премия, Премия); 
		
		Если Объект.Дата > КонецДня(РеквизитыФИ.ДатаВыпуска) Тогда
			Объект.Дата = РеквизитыФИ.ДатаВыпуска;	
		КонецЕсли;
	КонецЕсли;

	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	ФинансовыеИнструментыФормыКлиентСервер.ЗаполнитьСчетВзаиморасчетов(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ФинансовыйИнструментПриИзмененииНаСервере()

	ОперацииСЦеннымиБумагамиФормы.УстановитьПараметрыЦеннойБумаги(ЭтотОбъект);
	
	ЗаполнитьДокументНаСервере();

КонецПроцедуры

&НаСервере
Процедура ИнициализироватьФормуНаСервере()
	
	ФинансовыеИнструментыФормы.ПриСозданииНаСервере_СчетаУчета(ЭтотОбъект);
	
	ОперацииСЦеннымиБумагамиФормы.УстановитьПараметрыЦеннойБумаги(ЭтотОбъект);
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ПараметрыОперацийГрафика
&НаКлиенте
Процедура НастроитьПараметрыОпераций(Команда)
	
	ПараметрыКоманды = ДанныеОткрытияПараметровОперацийГрафика();			
	ДоговорыКонтрагентовФормыУХКлиент.ОткрытьПараметрыОперацийГрафика(ЭтотОбъект, ПараметрыКоманды);	
	
КонецПроцедуры

&НаСервере
Функция ДанныеОткрытияПараметровОперацийГрафика()	
	
	НастройкиОпераций = Объект.ПараметрыОпераций.Выгрузить();
	АдресНастроек = ПоместитьВоВременноеХранилище(НастройкиОпераций, ЭтотОбъект.УникальныйИдентификатор);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("АдресНастроек", АдресНастроек);
	ПараметрыОткрытия.Вставить("ГруппаОперацийГрафика", ГруппаОперацийГрафика());
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Ложь);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

&НаСервере
Функция ГруппаОперацийГрафика()
	
	Возврат Справочники.ОперацииГрафиковДоговоров.ОблигацияВыпущенная;

КонецФункции	

&НаКлиенте
Процедура ЗавершитьНастройкуОпераций(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
		ЗагрузитьНастройкиОпераций(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОпераций(Адрес)	
	
	ТаблицаНастроек = ПолучитьИзВременногоХранилища(Адрес);
	Объект.ПараметрыОпераций.Загрузить(ТаблицаНастроек);
	ЭтотОбъект.Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти