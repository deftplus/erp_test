#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеЗаполнения);
	
	ДатаУчетнойПолитики = Дата + 86400;
	
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрОрганизацияФункциональныхОпцийФормы(
		ЭтаФорма,
		Организация,
		ДатаУчетнойПолитики);
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаУчетнойПолитики);
	ВедетсяУчетПостоянныхИВременныхРазниц = УчетнаяПолитика.ВедетсяУчетПостоянныхИВременныхРазниц(Организация, ДатаУчетнойПолитики);
	
	Элементы.ДекорацияЗаголовокНУ.Видимость = ПлательщикНалогаНаПрибыль;
	Элементы.ДекорацияЗаголовокПР.Видимость = ПлательщикНалогаНаПрибыль И ВедетсяУчетПостоянныхИВременныхРазниц;
	Элементы.ДекорацияЗаголовокВР.Видимость = ПлательщикНалогаНаПрибыль И ВедетсяУчетПостоянныхИВременныхРазниц;
	
	// Установка значений по умолчанию.
	Если Параметры.ЭтоНовый И НЕ Параметры.Копирование Тогда
		
		СчетУчета = ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации;
		СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный;
		МетодНачисленияАмортизацииНУ = Перечисления.МетодыНачисленияАмортизации.Линейный;
		НачислятьАмортизациюБУ = Истина;
		НачислятьАмортизациюНУ = Истина;
		СпециальныйКоэффициентНУ = 1;
		ПорядокСписанияНИОКРНаРасходыНУ = ?(ДатаПринятияКУчетуРегл < '20120101', Перечисления.ПорядокСписанияНИОКРНУ.Равномерно, Перечисления.ПорядокСписанияНИОКРНУ.ПриПринятииКУчету);
		
	КонецЕсли;
	
	ЗаголовокНакопленнаяАмортизация = НСтр("ru = 'Собственные средства, остаток на счете %1:';
											|en = 'Own funds, account balance %1:'");
	ЗаголовокНакопленнаяАмортизацияЦФ = НСтр("ru = 'Целевое финансирование, остаток на счете %1:';
											|en = 'Special-purpose funding, balance of account %1:'");
	ЗаголовокТекущаяСтоимость = НСтр("ru = 'Собственные средства, остаток на счете %1:';
									|en = 'Own funds, account balance %1:'");
	ЗаголовокТекущаяСтоимостьЦФ = НСтр("ru = 'Целевое финансирование, остаток на счете %1:';
										|en = 'Special-purpose funding, balance of account %1:'");
	
	Заголовок = НСтр("ru = 'Нематериальные активы: %1';
					|en = 'Intangible assets: %1'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, ?(Параметры.ЭтоНовый, Нстр("ru = 'Новая строка';
																												|en = 'New line'"), НематериальныйАктив));
	
	ТекущаяСтоимостьВР = ТекущаяСтоимостьБУ - ТекущаяСтоимостьНУ - ТекущаяСтоимостьПР;
	ТекущаяСтоимостьВРЦФ = ТекущаяСтоимостьБУЦФ - ТекущаяСтоимостьНУЦФ - ТекущаяСтоимостьПРЦФ;
	НакопленнаяАмортизацияВР = НакопленнаяАмортизацияБУ - НакопленнаяАмортизацияНУ - НакопленнаяАмортизацияПР;
	НакопленнаяАмортизацияВРЦФ = НакопленнаяАмортизацияБУЦФ - НакопленнаяАмортизацияНУЦФ - НакопленнаяАмортизацияПРЦФ;
	
	Если Не(ТекущаяСтоимостьНУЦФ = 0 И ТекущаяСтоимостьВРЦФ = 0) Тогда
		ТекущаяСтоимостьПРЦФ = ТекущаяСтоимостьБУЦФ;
		ТекущаяСтоимостьНУЦФ = 0;
		ТекущаяСтоимостьВРЦФ = 0;
	КонецЕсли;
	
	Если Не(НакопленнаяАмортизацияНУЦФ = 0 И НакопленнаяАмортизацияВРЦФ = 0) Тогда
		НакопленнаяАмортизацияПРЦФ = НакопленнаяАмортизацияБУЦФ;
		НакопленнаяАмортизацияНУЦФ = 0;
		НакопленнаяАмортизацияВРЦФ = 0;
	КонецЕсли;
	
	ОстаточнаяСтоимостьБУ = ТекущаяСтоимостьБУ - НакопленнаяАмортизацияБУ;
	ОстаточнаяСтоимостьНУ = ТекущаяСтоимостьНУ - НакопленнаяАмортизацияНУ;
	ОстаточнаяСтоимостьПР = ТекущаяСтоимостьПР - НакопленнаяАмортизацияПР;
	ОстаточнаяСтоимостьВР = ТекущаяСтоимостьВР - НакопленнаяАмортизацияВР;
	
	ОстаточнаяСтоимостьБУЦФ = ТекущаяСтоимостьБУЦФ - НакопленнаяАмортизацияБУЦФ;
	ОстаточнаяСтоимостьНУЦФ = ТекущаяСтоимостьНУЦФ - НакопленнаяАмортизацияНУЦФ;
	ОстаточнаяСтоимостьПРЦФ = ТекущаяСтоимостьПРЦФ - НакопленнаяАмортизацияПРЦФ;
	ОстаточнаяСтоимостьВРЦФ = ТекущаяСтоимостьВРЦФ - НакопленнаяАмортизацияВРЦФ;
	
	Элементы.ГруппаАмортизацияНУ.Видимость = ПлательщикНалогаНаПрибыль;
	
	ЕстьСвязанныеОрганизации = Справочники.Организации.ОрганизацияВзаимосвязанаСДругимиОрганизациями(Организация);
	Элементы.ПередаватьРасходыВДругуюОрганизацию.Видимость = ЕстьСвязанныеОрганизации;
	Элементы.ОрганизацияПолучательРасходов.Видимость = ЕстьСвязанныеОрганизации;
	Элементы.СчетПередачиРасходов.Видимость = ЕстьСвязанныеОрганизации;
	
	РезервПереоценкиСтоимостиСумма = ?(РезервПереоценкиСтоимости<0, -РезервПереоценкиСтоимости, РезервПереоценкиСтоимости);
	РезервПереоценкиАмортизацииСумма = ?(РезервПереоценкиАмортизации<0, -РезервПереоценкиАмортизации, РезервПереоценкиАмортизации);
	РезервПереоценкиЗнак = (РезервПереоценкиСтоимости > 0);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияБУ);
	СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияНУ);
	ФактическийСрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(ФактическийСрокИспользованияДо2009);
	
	ОбновитьСвойстваЭлементовФормы();
	
	ПараметрыВыбораСтатейИАналитик = ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ЗавершениеРаботы И Модифицированность Тогда
		
		Отказ = Истина;
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?';
							|en = 'The data was changed. Do you want to save the changes?'");
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтаФорма),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат=Неопределено, ДополнительныеПараметры=Неопределено) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		Если ПроверитьЗаполнение() Тогда
			Модифицированность = Ложь;
			Закрыть(РеквизитыРедактируемыеВОтдельнойФорме());
		КонецЕсли;
		
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ДатаУчетнойПолитики = Дата + 86400;
	
	ПлательщикНалогаНаПрибыль = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Организация, ДатаУчетнойПолитики);
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	МассивНепроверяемыхРеквизитов.Добавить("АналитикаРасходовАмортизации");
	
	Если НЕ НачислятьАмортизациюБУ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияБУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпособНачисленияАмортизацииБУ");
		МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
		МассивНепроверяемыхРеквизитов.Добавить("ОбъемПродукцииРаботДляВычисленияАмортизации");
	Иначе
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("КоэффициентБУ");
			
		КонецЕсли;
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный
			ИЛИ СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
			
			МассивНепроверяемыхРеквизитов.Добавить("ОбъемПродукцииРаботДляВычисленияАмортизации");
			
		КонецЕсли;
	КонецЕсли;
	
	Если ПлательщикНалогаНаПрибыль Тогда
		
		Если НЕ НачислятьАмортизациюНУ Тогда
			МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияНУ");
			МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
			МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
			МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
			МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
		Иначе
			МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
			МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
			МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
			МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
		КонецЕсли;
		
	Иначе
		
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СрокПолезногоИспользованияНУ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
		МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
		МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
		
	КонецЕсли;
	
	Если НЕ НачислятьАмортизациюБУ И (ПлательщикНалогаНаПрибыль И НЕ НачислятьАмортизациюНУ) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяРасходовАмортизации");
	КонецЕсли;
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизации");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СпециальныйКоэффициентНУ");
		МассивНепроверяемыхРеквизитов.Добавить("МетодНачисленияАмортизацииНУ");
		МассивНепроверяемыхРеквизитов.Добавить("АмортизацияДо2009");
		МассивНепроверяемыхРеквизитов.Добавить("ФактическийСрокИспользованияДо2009");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПорядокСписанияНИОКРНаРасходыНУ");
	КонецЕсли;
	
	Если Не ПередаватьРасходыВДругуюОрганизацию Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучательРасходов");
		МассивНепроверяемыхРеквизитов.Добавить("СчетПередачиРасходов");
	КонецЕсли;
	
	Если Не ПрименениеЦелевогоФинансирования Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("СчетУчетаЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СчетАмортизацииЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("СтатьяДоходов");
		МассивНепроверяемыхРеквизитов.Добавить("АналитикаДоходов");
		
		МассивНепроверяемыхРеквизитов.Добавить("ТекущаяСтоимостьБУЦФ");
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
		
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НематериальныйАктивПриИзменении(Элемент)
	
	НематериальныйАктивПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура НематериальныйАктивПриИзмененииСервер()
	
	ВидОбъектаУчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НематериальныйАктив, "ВидОбъектаУчета");
	Если Не ЗначениеЗаполнено(ВидОбъектаУчета) Тогда
		ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив;
	КонецЕсли;
	
	Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив Тогда
		
		СчетАмортизации = ПланыСчетов.Хозрасчетный.АмортизацияНематериальныхАктивов;
		СчетУчета = ПланыСчетов.Хозрасчетный.НематериальныеАктивыОрганизации;
		
	Иначе
		
		СчетАмортизации = Неопределено;
		НакопленнаяАмортизацияБУ = 0;
		НакопленнаяАмортизацияНУ = 0;
		НакопленнаяАмортизацияПР = 0;
		НакопленнаяАмортизацияВР = 0;
		СчетУчета = ПланыСчетов.Хозрасчетный.РасходыНаНИОКР;
		Если СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка Тогда
			СпособНачисленияАмортизацииБУ = Перечисления.СпособыНачисленияАмортизацииНМА.Линейный;
			КоэффициентБУ = 0;
		КонецЕсли;
		
	КонецЕсли;
	
	ОбновитьСвойстваЭлементовФормы("ВидОбъектаУчета");
	
КонецПроцедуры

#Область ОбработчикиСобытийСтраницыУчет

&НаКлиенте
Процедура ПрименениеЦелевогоФинансированияПриИзменении(Элемент)
	
	ОбновитьСвойстваЭлементовФормы("ПрименениеЦелевогоФинансирования");
	
	ПересчитатьПервоначальнуюСтоимость();
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаОсновнойПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетУчета");
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииОсновнойПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетУчета");
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаЦФПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетУчетаЦФ");
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетАмортизации");
КонецПроцедуры

&НаКлиенте
Процедура СчетАмортизацииЦФПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("СчетАмортизацииЦФ");
КонецПроцедуры

&НаКлиенте
Процедура ЕстьРезервПереоценкиПриИзменении(Элемент)
	ОбновитьСвойстваЭлементовФормы("ЕстьРезервПереоценки");
КонецПроцедуры

&НаКлиенте
Процедура РезервПереоценкиСтоимостиСуммаПриИзменении(Элемент)
	
	Если ТекущаяСтоимостьБУ <> 0 И РезервПереоценкиСтоимостиСумма <> 0 Тогда
		МножительЦФ = ?(ПрименениеЦелевогоФинансирования, 1, 0);
		РезервПереоценкиАмортизацииСумма = 
			(НакопленнаяАмортизацияБУ + МножительЦФ*НакопленнаяАмортизацияБУЦФ)
			* (РезервПереоценкиСтоимостиСумма / (ТекущаяСтоимостьБУ + МножительЦФ*ТекущаяСтоимостьБУ));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДоходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСтраницыСтоимость

&НаКлиенте
Процедура ПервоначальнаяСтоимостьОтличаетсяПриИзменении(Элемент)
	
	Если Не ПервоначальнаяСтоимостьОтличается Тогда
		
		ПервоначальнаяСтоимостьБУ = ТекущаяСтоимостьБУ;
		ПервоначальнаяСтоимостьНУ = ТекущаяСтоимостьНУ;
		
	КонецЕсли;
	
	ОбновитьСвойстваЭлементовФормы("ПервоначальнаяСтоимостьОтличается");
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьПервоначальнуюСтоимость()
	
	Если Не ПервоначальнаяСтоимостьОтличается Тогда
		
		МножительЦФ = ?(ПрименениеЦелевогоФинансирования, 1, 0);
		
		ПервоначальнаяСтоимостьБУ = ТекущаяСтоимостьБУ + ТекущаяСтоимостьБУЦФ * МножительЦФ;
		ПервоначальнаяСтоимостьНУ = ТекущаяСтоимостьНУ + ТекущаяСтоимостьНУЦФ * МножительЦФ;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЗависимыеСуммы()
	
	ПересчитатьПервоначальнуюСтоимость();
	
	ОстаточнаяСтоимостьБУ = ТекущаяСтоимостьБУ - НакопленнаяАмортизацияБУ;
	ОстаточнаяСтоимостьНУ = ТекущаяСтоимостьНУ - НакопленнаяАмортизацияНУ;
	ОстаточнаяСтоимостьПР = ТекущаяСтоимостьПР - НакопленнаяАмортизацияПР;
	ОстаточнаяСтоимостьВР = ТекущаяСтоимостьВР - НакопленнаяАмортизацияВР;
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьЗависимыеСуммыЦФ()
	
	ПересчитатьПервоначальнуюСтоимость();
	
	ОстаточнаяСтоимостьБУЦФ = ТекущаяСтоимостьБУЦФ - НакопленнаяАмортизацияБУЦФ;
	ОстаточнаяСтоимостьНУЦФ = ТекущаяСтоимостьНУЦФ - НакопленнаяАмортизацияНУЦФ;
	ОстаточнаяСтоимостьПРЦФ = ТекущаяСтоимостьПРЦФ - НакопленнаяАмортизацияПРЦФ;
	ОстаточнаяСтоимостьВРЦФ = ТекущаяСтоимостьВРЦФ - НакопленнаяАмортизацияВРЦФ;
	
КонецПроцедуры

&НаКлиенте
Процедура ПервоначальнаяСтоимостьБУПриИзменении(Элемент)
	
	Если ПервоначальнаяСтоимостьНУ = 0 Тогда
		ПервоначальнаяСтоимостьНУ = ПервоначальнаяСтоимостьБУ;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьБУПриИзменении(Элемент)
	
	СуммаНУ = ТекущаяСтоимостьБУ - ТекущаяСтоимостьПР - ТекущаяСтоимостьВР;
	Если СуммаНУ < 0 Тогда
		ТекущаяСтоимостьНУ = 0;
		ТекущаяСтоимостьВР = ТекущаяСтоимостьБУ - ТекущаяСтоимостьНУ - ТекущаяСтоимостьПР;
	Иначе
		ТекущаяСтоимостьНУ = СуммаНУ;
	КонецЕсли;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьНУПриИзменении(Элемент)
	
	ТекущаяСтоимостьВР = ТекущаяСтоимостьБУ - ТекущаяСтоимостьНУ - ТекущаяСтоимостьПР;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьПРПриИзменении(Элемент)
	
	ТекущаяСтоимостьВР = ТекущаяСтоимостьБУ - ТекущаяСтоимостьНУ - ТекущаяСтоимостьПР;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущаяСтоимостьБУЦФПриИзменении(Элемент)
	
	ТекущаяСтоимостьПРЦФ = ТекущаяСтоимостьБУЦФ;
	ПересчитатьЗависимыеСуммыЦФ();
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияБУПриИзменении(Элемент)
	
	СуммаНУ = НакопленнаяАмортизацияБУ - НакопленнаяАмортизацияПР - НакопленнаяАмортизацияВР;
	Если СуммаНУ < 0 Тогда
		НакопленнаяАмортизацияНУ = 0;
		НакопленнаяАмортизацияВР = НакопленнаяАмортизацияБУ - НакопленнаяАмортизацияНУ - НакопленнаяАмортизацияПР;
	Иначе
		НакопленнаяАмортизацияНУ = СуммаНУ;
	КонецЕсли;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияНУПриИзменении(Элемент)
	
	НакопленнаяАмортизацияВР = НакопленнаяАмортизацияБУ - НакопленнаяАмортизацияНУ - НакопленнаяАмортизацияПР;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияПРПриИзменении(Элемент)
	
	НакопленнаяАмортизацияВР = НакопленнаяАмортизацияБУ - НакопленнаяАмортизацияНУ - НакопленнаяАмортизацияПР;
	
	ПересчитатьЗависимыеСуммы();
	
КонецПроцедуры

&НаКлиенте
Процедура НакопленнаяАмортизацияБУЦФПриИзменении(Элемент)
	
	НакопленнаяАмортизацияПРЦФ = НакопленнаяАмортизацияБУЦФ;
	ПересчитатьЗависимыеСуммыЦФ();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСтраницыАмортизация

&НаКлиенте
Процедура НачислятьАмортизациюБУПриИзменении(Элемент)
	
	ОбновитьСвойстваЭлементовФормы("НачислятьАмортизациюБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СрокПолезногоИспользованияБУПриИзменении(Элемент)
	
	Если ПлательщикНалогаНаПрибыль И СрокПолезногоИспользованияНУ = 0 Тогда
		
		СрокПолезногоИспользованияНУ = СрокПолезногоИспользованияБУ;
		СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияНУ);
		
	КонецЕсли;
	
	СрокИспользованияБУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияБУ);
	
КонецПроцедуры

&НаКлиенте
Процедура СрокИспользованияНУПриИзменении(Элемент)
	
	СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияНУ);
	
КонецПроцедуры

&НаКлиенте
Процедура ФактическийСрокИспользованияДо2009ПриИзменении(Элемент)
	
	ФактическийСрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(ФактическийСрокИспользованияДо2009);
	
КонецПроцедуры

&НаКлиенте
Процедура НачислятьАмортизациюНУ_НМАПриИзменении(Элемент)
	
	ОбновитьСвойстваЭлементовФормы("НачислятьАмортизациюНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СпособНачисленияАмортизацииБУПриИзменении(Элемент)
	
	ОбновитьСвойстваЭлементовФормы("СпособНачисленияАмортизацииБУ");
	
КонецПроцедуры

&НаКлиенте
Процедура МетодНачисленияАмортизацииНУПриИзменении(Элемент)
	
	ОбновитьСвойстваЭлементовФормы("МетодНачисленияАмортизацииНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокСписанияНИОКРНаРасходыНУПриИзменении(Элемент)
	
	Равномерно = (ПорядокСписанияНИОКРНаРасходыНУ = ПредопределенноеЗначение("Перечисление.ПорядокСписанияНИОКРНУ.Равномерно"));
	НачислятьАмортизациюНУ = Равномерно;
	СрокПолезногоИспользованияНУ = ?(Равномерно, ?(СрокПолезногоИспользованияНУ = 0, СрокПолезногоИспользованияБУ, СрокПолезногоИспользованияНУ), 0);
	СрокИспользованияНУРасшифровка = ВнеоборотныеАктивыКлиентСервер.ПредставлениеКоличестваМесяцевСтрокой(СрокПолезногоИспользованияНУ);
	
	ОбновитьСвойстваЭлементовФормы("ПорядокСписанияНИОКРНаРасходыНУ");
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовАмортизацииПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура СтатьяРасходовАмортизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАмортизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАмортизацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикаРасходовАмортизацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередаватьРасходыВДругуюОрганизациюПриИзменении(Элемент)
	
	Если Не ПередаватьРасходыВДругуюОрганизацию Тогда
		
		ОрганизацияПолучательРасходов = Неопределено;
		СчетПередачиРасходов = Неопределено;
		
	КонецЕсли;
	
	ОбновитьСвойстваЭлементовФормы("ПередаватьРасходыВДругуюОрганизацию");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Модифицированность = Ложь;
		Закрыть(РеквизитыРедактируемыеВОтдельнойФорме());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция СчетУчетаПредставление(Счет)
	Возврат ?(ЗначениеЗаполнено(Счет), Счет, НСтр("ru = 'актива';
													|en = 'asset'"));
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СчетАмортизацииПредставление(Счет)
	Возврат ?(ЗначениеЗаполнено(Счет), Счет, НСтр("ru = 'амортизации';
													|en = 'depreciation'"));
КонецФункции

&НаСервере
Процедура ОбновитьСвойстваЭлементовФормы(ИзмененныеРеквизиты=Неопределено)
	
	ОбновитьВсе = (ИзмененныеРеквизиты = Неопределено);
	Реквизиты = Новый Структура(ИзмененныеРеквизиты);
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ВидОбъектаУчета") Тогда
		
		СписокСпособовНачисленияАмортизацииБУ = Элементы.СпособНачисленияАмортизацииБУ.СписокВыбора;
		СписокСпособовНачисленияАмортизацииБУ.Очистить();
		
		Элементы.ГруппаСчетаУчетаАмортизации.Видимость = (ПрименениеЦелевогоФинансирования И ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив);
		
		Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
			
			Элементы.ГруппаНакопленнаяАмортизация.Видимость = Ложь;
			Элементы.ГруппаОстаточнаяСтоимость.Видимость = Ложь;
			
			Элементы.СчетУчетаОсновной.Заголовок = НСтр("ru = 'Расходов на НИОКР';
														|en = 'R&D expenses'");
			Элементы.СчетАмортизацииОсновной.Доступность = Ложь;
			
			Элементы.ГруппаПереоценка.Видимость = Ложь;
			
			Элементы.ГруппаОтражениеАмортизации.Заголовок = НСтр("ru = 'Отражение списания стоимости';
																|en = 'Record cost derecognition'");
			Элементы.НачислятьАмортизациюБУ.Заголовок = НСтр("ru = 'Списание расходов';
															|en = 'Expense write-off'");
			Элементы.НачислятьАмортизациюНУ.Заголовок = НСтр("ru = 'Списание расходов';
															|en = 'Expense write-off'");
			Элементы.СпособНачисленияАмортизацииБУ.Заголовок = НСтр("ru = 'Способ списания расходов';
																	|en = 'Expenses write-off method'");
			Элементы.СрокИспользованияБУ.Заголовок = НСтр("ru = 'Срок списания, мес';
															|en = 'Write-off period, months'");
			Элементы.СпособПоступленияНМА.Видимость = Ложь;
			Элементы.ПорядокСписанияНИОКР.Видимость = Истина;
			
			Элементы.НачислятьАмортизациюБУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не списывать''; БИ=Действует';
																		|en = 'BF=''Do not write off''; BT=Valid'");
			Элементы.НачислятьАмортизациюНУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не списывать''; БИ=Действует';
																		|en = 'BF=''Do not write off''; BT=Valid'");
			
			СписокСпособовНачисленияАмортизацииБУ.Добавить(ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Линейный"));
			СписокСпособовНачисленияАмортизацииБУ.Добавить(ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции"));
			
			Реквизиты.Вставить("ПорядокСписанияНИОКРНаРасходыНУ");
			
			Реквизиты.Вставить("СчетУчетаЦФ");
			Реквизиты.Вставить("СчетАмортизацииЦФ");
			
		Иначе
			
			Элементы.СчетУчетаОсновной.Заголовок = НСтр("ru = 'Нематериального актива';
														|en = 'Intangible asset'");
			Элементы.СчетАмортизацииОсновной.Доступность = Истина;
			
			Элементы.ГруппаПереоценка.Видимость = Истина;
			
			Элементы.ГруппаНакопленнаяАмортизация.Видимость = Истина;
			Элементы.ГруппаОстаточнаяСтоимость.Видимость = Истина;
			
			Элементы.ГруппаОтражениеАмортизации.Заголовок = НСтр("ru = 'Отражение амортизационных расходов';
																|en = 'Depreciation expense record'");
			Элементы.НачислятьАмортизациюБУ.Заголовок = НСтр("ru = 'Начислять амортизацию';
															|en = 'Accrue depreciation '");
			Элементы.НачислятьАмортизациюНУ.Заголовок = НСтр("ru = 'Начислять амортизацию';
															|en = 'Accrue depreciation '");
			Элементы.СпособНачисленияАмортизацииБУ.Заголовок = НСтр("ru = 'Способ начисления амортизации';
																	|en = 'Depreciation accrual method'");
			Элементы.СрокИспользованияБУ.Заголовок = НСтр("ru = 'Срок использования, мес';
															|en = 'Useful life, months'");
			Элементы.СпособПоступленияНМА.Видимость = Истина;
			Элементы.ПорядокСписанияНИОКР.Видимость = Ложь;
			
			Элементы.НачислятьАмортизациюБУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не начислять''; БИ=Действует';
																		|en = 'BF=''Do not accrue''; BT=Valid'");
			Элементы.НачислятьАмортизациюНУ.ФорматРедактирования = НСтр("ru = 'БЛ=''Не начислять''; БИ=Действует';
																		|en = 'BF=''Do not accrue''; BT=Valid'");
			
			СписокСпособовНачисленияАмортизацииБУ.Добавить(ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.Линейный"));
			СписокСпособовНачисленияАмортизацииБУ.Добавить(ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка"));
			СписокСпособовНачисленияАмортизацииБУ.Добавить(ПредопределенноеЗначение("Перечисление.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции"));
			
			Элементы.СрокИспользованияНУ.Доступность = Истина;
			
		КонецЕсли;
		
		Реквизиты.Вставить("СчетУчета");
		Реквизиты.Вставить("СчетАмортизации");
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПрименениеЦелевогоФинансирования") Тогда
		
		Элементы.ГруппаСчетаУчетаАмортизации.Видимость = (ПрименениеЦелевогоФинансирования И ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.НематериальныйАктив);
		
		Если ПрименениеЦелевогоФинансирования Тогда
			ЗаголовокТекущаяСтоимость = НСтр("ru = 'Собственные средства, остаток на счете %1:';
											|en = 'Own funds, account balance %1:'");
			ЗаголовокНакопленнаяАмортизация = НСтр("ru = 'Собственные средства, остаток на счете %1:';
													|en = 'Own funds, account balance %1:'");
			Элементы.ГруппаОстаточнаяСтоимостьЗаголовок.Заголовок = НСтр("ru = 'Собственные средства:';
																		|en = 'Own funds:'");
			
			Элементы.ГруппаСчетаУчета.Видимость = Ложь;
			Элементы.ГруппаСчетаУчетаЦФ.Видимость = Истина;
			
			Элементы.ГруппаТекущаяСтоимостьЗаголовокЦФ.Видимость = Истина;
			Элементы.ГруппаНакопленнаяАмортизацияЗаголовокЦФ.Видимость = Истина;
			Элементы.ГруппаОстаточнаяСтоимостьЗаголовокЦФ.Видимость = Истина;
			
			Элементы.ГруппаТекущаяСтоимостьСуммыЦФ.Видимость = Истина;
			Элементы.ГруппаНакопленнаяАмортизацияСуммыЦФ.Видимость = Истина;
			Элементы.ГруппаОстаточнаяСтоимостьСуммыЦФ.Видимость = Истина;
			
			Элементы.ГруппаОтражениеДоходовЦелевогоФинансирования.Видимость = Истина;
		Иначе
			ЗаголовокТекущаяСтоимость = НСтр("ru = 'Остаток на счете %1:';
											|en = 'Account balance %1:'");
			ЗаголовокНакопленнаяАмортизация = НСтр("ru = 'Остаток на счете %1:';
													|en = 'Account balance %1:'");
			Элементы.ГруппаОстаточнаяСтоимостьЗаголовок.Заголовок = НСтр("ru = 'Сумма:';
																		|en = 'Amount:'");
			
			Элементы.ГруппаСчетаУчета.Видимость = Истина;
			Элементы.ГруппаСчетаУчетаЦФ.Видимость = Ложь;
			
			Элементы.ГруппаТекущаяСтоимостьЗаголовокЦФ.Видимость = Ложь;
			Элементы.ГруппаНакопленнаяАмортизацияЗаголовокЦФ.Видимость = Ложь;
			Элементы.ГруппаОстаточнаяСтоимостьЗаголовокЦФ.Видимость = Ложь;
			
			Элементы.ГруппаТекущаяСтоимостьСуммыЦФ.Видимость = Ложь;
			Элементы.ГруппаНакопленнаяАмортизацияСуммыЦФ.Видимость = Ложь;
			Элементы.ГруппаОстаточнаяСтоимостьСуммыЦФ.Видимость = Ложь;
			
			Элементы.ГруппаОтражениеДоходовЦелевогоФинансирования.Видимость = Ложь;
			
		КонецЕсли;
		
		Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = ПрименениеЦелевогоФинансирования;
		Элементы.НаправлениеДеятельности.ОтметкаНезаполненного = ПрименениеЦелевогоФинансирования И Не ЗначениеЗаполнено(НаправлениеДеятельности);
		
		Элементы.ГруппаТекущаяСтоимостьЗаголовок.Заголовок = СтрШаблон(ЗаголовокТекущаяСтоимость, СчетУчетаПредставление(СчетУчета));
		Элементы.ГруппаНакопленнаяАмортизацияЗаголовок.Заголовок = СтрШаблон(ЗаголовокНакопленнаяАмортизация, СчетАмортизацииПредставление(СчетУчета));
		
		Элементы.НаправлениеДеятельности.АвтоОтметкаНезаполненного = ПрименениеЦелевогоФинансирования;
		Элементы.НаправлениеДеятельности.ОтметкаНезаполненного = 
			НЕ ЗначениеЗаполнено(НаправлениеДеятельности) 
			И ПрименениеЦелевогоФинансирования;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетУчета") Тогда
		Элементы.ГруппаТекущаяСтоимостьЗаголовок.Заголовок = СтрШаблон(ЗаголовокТекущаяСтоимость, СчетУчетаПредставление(СчетУчета));
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетАмортизации") Тогда
		Элементы.ГруппаНакопленнаяАмортизацияЗаголовок.Заголовок = СтрШаблон(ЗаголовокНакопленнаяАмортизация, СчетАмортизацииПредставление(СчетАмортизации));
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетУчетаЦФ") Тогда
		Элементы.ГруппаТекущаяСтоимостьЗаголовокЦФ.Заголовок = СтрШаблон(ЗаголовокТекущаяСтоимостьЦФ, СчетУчетаПредставление(СчетУчетаЦФ));
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СчетАмортизацииЦФ") Тогда
		Элементы.ГруппаНакопленнаяАмортизацияЗаголовокЦФ.Заголовок = СтрШаблон(ЗаголовокНакопленнаяАмортизацияЦФ, СчетАмортизацииПредставление(СчетАмортизацииЦФ));
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ЕстьРезервПереоценки") Тогда
		Элементы.РезервПереоценкиЗнак.ТолькоПросмотр = Не ЕстьРезервПереоценки;
		Элементы.РезервПереоценкиСтоимостиСумма.ТолькоПросмотр = Не ЕстьРезервПереоценки;
		Элементы.РезервПереоценкиАмортизацииСумма.ТолькоПросмотр = Не ЕстьРезервПереоценки;
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПервоначальнаяСтоимостьОтличается") Тогда
		
		Элементы.ПервоначальнаяСтоимостьБУ.ТолькоПросмотр = Не ПервоначальнаяСтоимостьОтличается;
		Элементы.ПервоначальнаяСтоимостьНУ.ТолькоПросмотр = Не ПервоначальнаяСтоимостьОтличается;
		
		Элементы.ПервоначальнаяСтоимостьБУ.АвтоОтметкаНезаполненного = ПервоначальнаяСтоимостьОтличается;
		Элементы.ПервоначальнаяСтоимостьБУ.ОтметкаНезаполненного = ПервоначальнаяСтоимостьОтличается И Не ЗначениеЗаполнено(ПервоначальнаяСтоимостьБУ);
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НачислятьАмортизациюБУ") Тогда
		
		Элементы.СпособНачисленияАмортизацииБУ.Доступность = НачислятьАмортизациюБУ;
		Элементы.ГруппаСрокИспользованияБУ.Доступность = НачислятьАмортизациюБУ;
		Элементы.КоэффициентБУ.Доступность = НачислятьАмортизациюБУ;
		Элементы.ОбъемВыработки.Доступность = НачислятьАмортизациюБУ;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("НачислятьАмортизациюНУ") Тогда
		
		Элементы.ПорядокСписанияНИОКР.Доступность = НачислятьАмортизациюНУ;
		Элементы.ГруппаСрокИспользованияНУ.Доступность = НачислятьАмортизациюНУ;
		Элементы.СпециальныйКоэффициентНУ.Доступность = НачислятьАмортизациюНУ;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПорядокСписанияНИОКРНаРасходыНУ") Тогда
		
		Если ВидОбъектаУчета = Перечисления.ВидыОбъектовУчетаНМА.РасходыНаНИОКР Тогда
			
			Равномерно = (ПорядокСписанияНИОКРНаРасходыНУ = Перечисления.ПорядокСписанияНИОКРНУ.Равномерно);
			Элементы.СрокИспользованияНУ.Доступность = Равномерно;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("СпособНачисленияАмортизацииБУ") Тогда
		
		УменьшаемогоОстатка = (СпособНачисленияАмортизацииБУ=Перечисления.СпособыНачисленияАмортизацииНМА.УменьшаемогоОстатка);
		Элементы.КоэффициентБУ.Видимость = УменьшаемогоОстатка;
		
		ПропорциональноОбъемуПродукции = (СпособНачисленияАмортизацииБУ=Перечисления.СпособыНачисленияАмортизацииНМА.ПропорциональноОбъемуПродукции);
		Элементы.ОбъемВыработки.Видимость = ПропорциональноОбъемуПродукции;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("МетодНачисленияАмортизацииНУ") Тогда
		ДоступностьАмортизацииДо2009Года = (МетодНачисленияАмортизацииНУ = Перечисления.МетодыНачисленияАмортизации.Нелинейный);
		Элементы.АмортизацияДо2009.Доступность = ДоступностьАмортизацииДо2009Года;
		Элементы.ФактическийСрокИспользованияДо2009.Доступность = ДоступностьАмортизацииДо2009Года;
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ПередаватьРасходыВДругуюОрганизацию") Тогда
		
		Элементы.ОрганизацияПолучательРасходов.Доступность = ПередаватьРасходыВДругуюОрганизацию;
		Элементы.СчетПередачиРасходов.Доступность = ПередаватьРасходыВДругуюОрганизацию;
		
	КонецЕсли;
	
	Если ОбновитьВсе Или Реквизиты.Свойство("ЕстьРезервПереоценки") Тогда
		Элементы.РезервПереоценкиЗнак.ТолькоПросмотр = Не ЕстьРезервПереоценки;
		Элементы.РезервПереоценкиСтоимостиСумма.ТолькоПросмотр = Не ЕстьРезервПереоценки;
		Элементы.РезервПереоценкиАмортизацииСумма.ТолькоПросмотр = Не ЕстьРезервПереоценки;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РеквизитыРедактируемыеВОтдельнойФорме()
	
	СтруктураДанных = Новый Структура(
	"НематериальныйАктив,
	|СчетУчета,
	|СчетАмортизации,
	|ПервоначальнаяСтоимостьБУ,
	|ПервоначальнаяСтоимостьНУ,
	|НакопленнаяАмортизацияБУ,
	|НакопленнаяАмортизацияНУ,
	|НакопленнаяАмортизацияПР,
	|ДатаПринятияКУчетуРегл,
	|ДатаПриобретения,
	|ВидОбъектаУчета,
	|НачислятьАмортизациюБУ,
	|НачислятьАмортизациюНУ,
	|ТекущаяСтоимостьБУ,
	|ТекущаяСтоимостьНУ,
	|ТекущаяСтоимостьПР,
	|КоэффициентБУ,
	|АмортизацияДо2009,
	|ФактическийСрокИспользованияДо2009,
	|ОбъемПродукцииРаботДляВычисленияАмортизации,
	|РеквизитыДокументаОплаты,
	|СпециальныйКоэффициентНУ,
	|СпособНачисленияАмортизацииБУ,
	|МетодНачисленияАмортизацииНУ,
	|СпособПоступления,
	|СрокПолезногоИспользованияБУ,
	|СрокПолезногоИспользованияНУ,
	|СтатьяРасходовАмортизации,
	|АналитикаРасходовАмортизации,
	|ПорядокСписанияНИОКРНаРасходыНУ,
	|ПередаватьРасходыВДругуюОрганизацию,
	|ОрганизацияПолучательРасходов,
	|СчетПередачиРасходов,
	|ПервоначальнаяСтоимостьОтличается,
	|ПрименениеЦелевогоФинансирования,
	|СчетУчетаЦФ,
	|СчетАмортизацииЦФ,
	|СтатьяДоходов,
	|АналитикаДоходов,
	|ТекущаяСтоимостьБУЦФ,
	|ТекущаяСтоимостьНУЦФ,
	|ТекущаяСтоимостьПРЦФ,
	|НакопленнаяАмортизацияБУЦФ,
	|НакопленнаяАмортизацияНУЦФ,
	|НакопленнаяАмортизацияПРЦФ,
	|ЕстьРезервПереоценки,
	|РезервПереоценкиСтоимости,
	|РезервПереоценкиАмортизации,
	|НаправлениеДеятельности");
	
	ЗаполнитьЗначенияСвойств(СтруктураДанных, ЭтаФорма);
	
	МножительРезерваПереоценки = ?(СтруктураДанных.ЕстьРезервПереоценки, ?(РезервПереоценкиЗнак, 1, -1), 0);
	СтруктураДанных.РезервПереоценкиСтоимости = МножительРезерваПереоценки * РезервПереоценкиСтоимостиСумма;
	СтруктураДанных.РезервПереоценкиАмортизации = МножительРезерваПереоценки * РезервПереоценкиАмортизацииСумма;
	
	Возврат СтруктураДанных;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПараметрыВыбораСтатейИАналитик()
	
	ПараметрыВыбораСтатейИАналитик = Новый Массив;
	
	// СтатьяРасходовАмортизации
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "";
	ПараметрыВыбора.Статья = "СтатьяРасходовАмортизации";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиРасходов = Истина;
	ПараметрыВыбора.АналитикаРасходов = "АналитикаРасходовАмортизации";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяРасходовАмортизации");
	ПараметрыВыбора.ЭлементыФормы.АналитикаРасходов.Добавить("АналитикаРасходовАмортизации");
	
	ПараметрыВыбораСтатейИАналитик.Добавить(ПараметрыВыбора);
	
	// СтатьяДоходов
	ПараметрыВыбора = ДоходыИРасходыСервер.ПараметрыВыбораСтатьиИАналитики();
	ПараметрыВыбора.ПутьКДанным = "";
	ПараметрыВыбора.Статья = "СтатьяДоходов";
	ПараметрыВыбора.ДоступностьПоОперации = Неопределено;
	
	ПараметрыВыбора.ВыборСтатьиДоходов = Истина;
	ПараметрыВыбора.АналитикаДоходов = "АналитикаДоходов";
	
	ПараметрыВыбора.ЭлементыФормы.Статья.Добавить("СтатьяДоходов");
	ПараметрыВыбора.ЭлементыФормы.АналитикаДоходов.Добавить("АналитикаДоходов");
	
	ПараметрыВыбораСтатейИАналитик.Добавить(ПараметрыВыбора);
	
	Возврат ПараметрыВыбораСтатейИАналитик;
	
КонецФункции

#КонецОбласти
