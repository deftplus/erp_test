//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОперативныйУчетПроизводства.ЗаполнитьВыборВремени(Элементы.НачалоВремя.СписокВыбора);
	ОперативныйУчетПроизводства.ЗаполнитьВыборВремени(Элементы.ОкончаниеВремя.СписокВыбора,,, Истина);
	
	ИнтервалПланирования = Параметры.ИнтервалПланирования;
	ЗанятостьВИнтервалах.ЗагрузитьЗначения(Параметры.ЗанятостьВИнтервалах.ВыгрузитьЗначения());
	ВремяРаботы = Параметры.ВремяРаботы;
	ВремяРаботыВРабочееВремя = Параметры.ВремяРаботыВРабочееВремя;
	ОбъемРабот = Параметры.ОбъемРабот;
	Непрерывный = Параметры.Непрерывный;
	
	ВремяРаботыИзмененоПользователем = Параметры.ВремяРаботыИзмененоПользователем;
	
	Если Параметры.Свойство("РабочийЦентр") Тогда
		РабочийЦентр = Параметры.РабочийЦентр;
	КонецЕсли;
	
	Если Параметры.Свойство("ОпределитьОкончание") Тогда
		Начало      = Параметры.Начало;
		НачалоВремя = Параметры.Начало;
		ОпределитьОкончание();
		
	ИначеЕсли Параметры.Свойство("ОпределитьНачало") Тогда
		Окончание      = Параметры.Окончание;
		ОкончаниеВремя = Параметры.Окончание;
		ОпределитьНачало();
		
	Иначе
		Начало      = Параметры.Начало;
		НачалоВремя = Параметры.Начало;
		Окончание      = Параметры.Окончание;
		ОкончаниеВремя = Параметры.Окончание;
	КонецЕсли; 
	
	НачалоПериода = Параметры.НачалоПериода;
	ОкончаниеПериода = Параметры.ОкончаниеПериода;
	
	Элементы.ПояснениеГраницыПериода.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														НСтр("ru = 'Начало периода не может быть позже %1, а окончание раньше %2';
															|en = 'Period start cannot be later than %1, and period end cannot be earlier than %2'"),
														Формат(ОкончаниеПериода, "ДФ='dd.MM.yyyy ЧЧ:59'"),
														Формат(НачалоПериода, "ДФ='dd.MM.yyyy ЧЧ:00'"));
														
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("РасписаниеРабочихЦентров", Параметры.РасписаниеРабочихЦентров);
	ДополнительныеПараметры.Вставить("ВариантНаладки", Параметры.ВариантНаладки);
	АдресДополнительныхПараметров = ПоместитьВоВременноеХранилище(ДополнительныеПараметры, УникальныйИдентификатор);
	
	УправлениеИнформациейПоВведенномуПериоду(ЭтаФорма);
	УправлениеИнформациейПоОбъемуРабот(ЭтаФорма);
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Период выполнения маршрутного листа %1';
						|en = 'Route sheet %1 completion period'"),
					Параметры.МаршрутныйЛистСтрока);
	
	ПоказатьПояснениеРаботаВНерабочееВремя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОповещениеЗакрытия = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
							|en = 'The data was changed. Do you want to save the changes?'");
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОповещениеЗакрытия, Отказ, ЗавершениеРаботы, ТекстВопроса,
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НачалоДатаИВремя    = НачалоДатаИВремя(ЭтаФорма);
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(ЭтаФорма);
	
	ПериодКорректный = (Начало <> '000101010000' И Окончание <> '000101010000');
	
	Если Начало <> '000101010000'
			И НачалоДатаИВремя > ОкончаниеПериода
		ИЛИ Окончание <> '000101010000'
			И ОкончаниеДатаИВремя < НачалоПериода Тогда
			
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
														НСтр("ru = 'Начало периода не может быть позже %1, а окончание раньше %2';
															|en = 'Period start cannot be later than %1, and period end cannot be earlier than %2'"),
														Формат(ОкончаниеПериода, "ДФ='dd.MM.yyyy ЧЧ:59'"),
														Формат(НачалоПериода, "ДФ='dd.MM.yyyy ЧЧ:00'"));
															
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
		ПериодКорректный = Ложь;
	КонецЕсли;
	
	Если ПериодКорректный Тогда
		ДополнительныеПараметры = ПолучитьИзВременногоХранилища(АдресДополнительныхПараметров);
		ОперативныйУчетПроизводстваКлиентСервер.ПроверитьПериодВыполнения(
					НачалоДатаИВремя, 
					ОкончаниеДатаИВремя,
					ДополнительныеПараметры.ВариантНаладки,
					ДополнительныеПараметры.РасписаниеРабочихЦентров,,
					Отказ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НачалоПриИзменении(Элемент)
	
	ОпределитьОкончание();
		
	УправлениеИнформациейПоВведенномуПериоду(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВремяПриИзменении(Элемент)
	
	ОпределитьОкончание();
	
	УправлениеИнформациейПоВведенномуПериоду(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеПриИзменении(Элемент)
	
	ПриИзмененииДатыОкончания(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеВремяПриИзменении(Элемент)
	
	ПриИзмененииДатыОкончания(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъемРаботПриИзменении(Элемент)
	
	ВремяРаботыИзмененоПользователем = Истина;
	
	ОпределитьОкончание();
	
	ВремяРаботыИзмененоПользователем = (ОбъемРабот * 3600 <> ВремяРаботы);
	
	УправлениеИнформациейПоВведенномуПериоду(ЭтаФорма);
	УправлениеИнформациейПоОбъемуРабот(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗавершитьВводПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаИспользоватьНормативныйОбъемРабот(Команда)
	
	ОбъемРабот = ВремяРаботы / 3600;
	ВремяРаботыИзмененоПользователем = Ложь;
	
	ОпределитьОкончание();
	
	УправлениеИнформациейПоОбъемуРабот(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОпределитьОкончание()

	Если Начало = '000101010000' Тогда
		Возврат;
	КонецЕсли;
	
	НачалоДатаИВремя = НачалоДатаИВремя(ЭтаФорма);
	
	Если НЕ ВремяРаботыИзмененоПользователем Тогда
		ИсходноеВремяРаботы = ВремяРаботы;
	Иначе
		ИсходноеВремяРаботы = ОбъемРабот * 3600;
	КонецЕсли; 
	
	ПериодыВыполнения = Новый Массив;
	
	Результат = ОперативныйУчетПроизводства.ОпределитьДатуОкончанияСУчетомГрафикаРаботы(
						НачалоДатаИВремя, 
						ИсходноеВремяРаботы, 
						РабочийЦентр,
						ВремяРаботыВРабочееВремя,
						ПериодыВыполнения);

	ОпределитьЗанятостьВИнтервалах(ПериодыВыполнения);
	
	Окончание      = Результат;
	ОкончаниеВремя = Результат;
	
	ПоказатьПояснениеРаботаВНерабочееВремя();
	ОкончаниеВремя = Результат;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНачало()

	Если Окончание = '000101010000' Тогда
		Возврат;
	КонецЕсли;
	
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(ЭтаФорма);
	
	Если НЕ ВремяРаботыИзмененоПользователем Тогда
		ИсходноеВремяРаботы = ВремяРаботы;
	Иначе
		ИсходноеВремяРаботы = ОбъемРабот * 3600;
	КонецЕсли; 
	
	Результат = ОперативныйУчетПроизводства.ОпределитьДатуНачалаСУчетомГрафикаРаботы(
						ОкончаниеДатаИВремя, 
						ИсходноеВремяРаботы, 
						РабочийЦентр,
						НачалоПериода,
						ВремяРаботыВРабочееВремя);

	Начало      = Результат;
	НачалоВремя = Результат;

	ПоказатьПояснениеРаботаВНерабочееВремя();

КонецПроцедуры

&НаСервере
Процедура ОпределитьОбъемРабот()

	Если Начало = '000101010000' ИЛИ Окончание = '000101010000' Тогда
		Возврат;
	КонецЕсли;
	
	НачалоДатаИВремя = НачалоДатаИВремя(ЭтаФорма);
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(ЭтаФорма);
	
	ГрафикРаботы = ОперативныйУчетПроизводства.ДобавитьДанныеГрафика(РабочийЦентр, Неопределено, НачалоДатаИВремя, ОкончаниеДатаИВремя);
		
	ПериодыВыполнения = Новый Массив;
	
	ОбъемРаботСекунд = ОперативныйУчетПроизводстваКлиентСервер.ДлительностьПериодаСУчетомГрафикаРаботы(
														НачалоДатаИВремя, 
														ОкончаниеДатаИВремя, 
														ГрафикРаботы,,,
														ВремяРаботыВРабочееВремя,
														ПериодыВыполнения);
														
	ОпределитьЗанятостьВИнтервалах(ПериодыВыполнения);
	
	ВремяРаботыИзмененоПользователем = (ОбъемРаботСекунд <> ВремяРаботы);
	
	ОбъемРабот = ОбъемРаботСекунд / 3600;
														
	УправлениеИнформациейПоОбъемуРабот(ЭтаФорма);

	ПоказатьПояснениеРаботаВНерабочееВремя();

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеИнформациейПоВведенномуПериоду(Форма)

	НачалоДатаИВремя    = НачалоДатаИВремя(Форма);
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(Форма);
	
	Если Форма.Начало <> '000101010000'
			И НачалоДатаИВремя > Форма.ОкончаниеПериода
		ИЛИ Форма.Окончание <> '000101010000'
			И ОкончаниеДатаИВремя < Форма.НачалоПериода Тогда
			
		Форма.Элементы.СтраницыИнформацияПоВведенномуПериоду.ТекущаяСтраница = Форма.Элементы.СтраницаИнформацияПоВведенномуПериодуПериодЗаПределамиИнтервала;
		
	Иначе
		Форма.Элементы.СтраницыИнформацияПоВведенномуПериоду.ТекущаяСтраница = Форма.Элементы.СтраницаИнформацияПоВведенномуПериодуПустая;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеИнформациейПоОбъемуРабот(Форма)

	Если Форма.ВремяРаботыИзмененоПользователем Тогда
		Форма.Элементы.СтраницыНормативныйОбъемРабот.ТекущаяСтраница = Форма.Элементы.СтраницаОбъемРаботНеСоответствуетНормативному;
	Иначе
		Форма.Элементы.СтраницыНормативныйОбъемРабот.ТекущаяСтраница = Форма.Элементы.СтраницаУстановленНормативныйОбъемРабот;
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииДатыОкончания(ЭтоИзменениеДаты)

	НачалоДатаИВремя = НачалоДатаИВремя(ЭтаФорма);
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(ЭтаФорма);
	Если ОкончаниеДатаИВремя <> '000101010000' И ОкончаниеДатаИВремя < НачалоДатаИВремя Тогда
		Если ЭтоИзменениеДаты И Начало = Окончание Тогда
			ОкончаниеВремя = НачалоВремя;
		Иначе
			Начало = ОкончаниеДатаИВремя;
			НачалоВремя = ОкончаниеДатаИВремя;
		КонецЕсли; 
	КонецЕсли;

	ОпределитьОбъемРабот();
	
	УправлениеИнформациейПоВведенномуПериоду(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НачалоДатаИВремя(Форма)

	Возврат Форма.Начало + Час(Форма.НачалоВремя) * 3600 + Минута(Форма.НачалоВремя) * 60;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОкончаниеДатаИВремя(Форма)

	Возврат Форма.Окончание + Час(Форма.ОкончаниеВремя) * 3600 + Минута(Форма.ОкончаниеВремя) * 60 + 59;

КонецФункции

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьВводПериода();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьВводПериода()

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	НачалоДатаИВремя    = НачалоДатаИВремя(ЭтаФорма);
	ОкончаниеДатаИВремя = ОкончаниеДатаИВремя(ЭтаФорма);
	
	РезультатФормы = Новый Структура;
	РезультатФормы.Вставить("Начало", НачалоДатаИВремя);
	РезультатФормы.Вставить("Окончание", ОкончаниеДатаИВремя);
	РезультатФормы.Вставить("ОбъемРабот", ОбъемРабот);
	РезультатФормы.Вставить("ВремяРаботыИзмененоПользователем", ВремяРаботыИзмененоПользователем);
	РезультатФормы.Вставить("ВремяРаботыВРабочееВремя", ВремяРаботыВРабочееВремя);
	РезультатФормы.Вставить("ЗанятостьВИнтервалах", ЗанятостьВИнтервалах.ВыгрузитьЗначения());
	
	Модифицированность = Ложь;
	
	Закрыть(РезультатФормы);
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьПояснениеРаботаВНерабочееВремя()

	Если НЕ ВремяРаботыИзмененоПользователем Тогда
		ИсходноеВремяРаботы = ВремяРаботы;
	Иначе
		ИсходноеВремяРаботы = ОбъемРабот * 3600;
	КонецЕсли; 
	
	Если ИсходноеВремяРаботы <> ВремяРаботыВРабочееВремя Тогда
		Элементы.ПояснениеРаботаВНерабочееВремя.Видимость = Истина;
		ВремяРаботыВНерабочееВремя = Окр((ИсходноеВремяРаботы - ВремяРаботыВРабочееВремя) / 3600, 2);
		Элементы.ПояснениеРаботаВНерабочееВремя.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																НСтр("ru = '(в т.ч. %1ч в нерабочее время)';
																	|en = '(incl. %1 h. out-of-hours)'"),
																ВремяРаботыВНерабочееВремя);
	Иначе
		Элементы.ПояснениеРаботаВНерабочееВремя.Видимость = Ложь;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ОпределитьЗанятостьВИнтервалах(ПериодыВыполнения)
	
	ЗанятостьВИнтервалах.ЗагрузитьЗначения(ОперативныйУчетПроизводства.ОпределитьЗанятостьВИнтервалах(ПериодыВыполнения, ИнтервалПланирования));

КонецПроцедуры

#КонецОбласти
//-- Устарело_Производство21