
#Область ПрограммныйИнтерфейс
	
#КонецОбласти

#Область ЗаполнениеДокументовЦБ

Процедура ОбработатьСтрокуЦБ(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения) Экспорт

	ЗаполнитьКэшируемыеЗначения(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);
	ЗаполнитьКоличество(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);
	ЗаполнитьНКД(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);
	РассчитатьСтоимостьНоминала(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);
	РассчитатьСтоимость(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);
	РассчитатьПремию(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения);	
	
КонецПроцедуры

Процедура ЗаполнитьКэшируемыеЗначения(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)

	Если Не СтруктураДействий.Свойство("ЗаполнитьКэшируемыеЗначения") Тогда
		Возврат;    	
	КонецЕсли;
	
	ДанныеЦеннойБумаги = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаЦБ.ФинансовыйИнструмент,"Номинал,ВидФинансовогоИнструмента,ПараметрыЦеннойБумаги");
	
	Номинал 					= ?(ЗначениеЗаполнено(ДанныеЦеннойБумаги.Номинал), ДанныеЦеннойБумаги.Номинал, 0);//приводим к числу
	ДатаДокумента 				= НачалоДня(КэшируемыеЗначения.КонтекстДокумента.Дата);	
	ДатаНачалаКупонногоПериода 	= Дата(1,1,1);
	ДатаВыплатыКупона 			= Дата(3999,12,31);
	ТекущийКупон 				= 0;
		
	Если ЗначениеЗаполнено(ДанныеЦеннойБумаги) И ТипЗнч(ДанныеЦеннойБумаги) = Тип("ДокументСсылка.ВерсияГрафикаЦеннойБумаги") Тогда
		ТабличнаяЧастьГрафик = ДанныеЦеннойБумаги.График;
		
		// График должен быть отсортирован. Найдем предыдущую и следующую строки графика относительно текущей даты.
		// Предыдущая строка даст нам текущий номинал, следующая - дату и сумму выплаты следующего купона.
		Для Инд = 0 По ТабличнаяЧастьГрафик.Количество() - 1 Цикл
			
			СтрокаГрафика = ТабличнаяЧастьГрафик[Инд];
			
			Если (СтрокаГрафика.Дата <= ДатаДокумента)
				И (СтрокаГрафика.Дата > ДатаНачалаКупонногоПериода)
				И (Инд <> ТабличнаяЧастьГрафик.Количество() - 1) Тогда //последнюю строку графика не используем, тк она является возвратом ОД
				ДатаНачалаКупонногоПериода = СтрокаГрафика.Дата + 86400;
				Номинал = СтрокаГрафика.ОсновнойДолгОстаток;
			КонецЕсли;
			
			Если СтрокаГрафика.Дата >= ДатаДокумента И СтрокаГрафика.Дата < ДатаВыплатыКупона Тогда
				ДатаВыплатыКупона = СтрокаГрафика.Дата;
				ТекущийКупон = СтрокаГрафика.ПроцентыНачислено;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	КэшируемыеЗначения.Вставить("ДатаНачалаКупонногоПериода",	ДатаНачалаКупонногоПериода);
	КэшируемыеЗначения.Вставить("ДатаВыплатыКупона", 			ДатаВыплатыКупона);
	КэшируемыеЗначения.Вставить("Номинал", 						Номинал);
	КэшируемыеЗначения.Вставить("ТекущийКупон", 				ТекущийКупон);
	
КонецПроцедуры

Процедура ЗаполнитьКоличество(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)

	Если Не СтруктураДействий.Свойство("ЗаполнитьКоличество") Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЦБ.Количество = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(СтрокаЦБ.ФинансовыйИнструмент, "Количетво");

КонецПроцедуры

Процедура ЗаполнитьНКД(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)

	ЗначенияДействия = Неопределено;
	
	Если Не СтруктураДействий.Свойство("ЗаполнитьНКД", ЗначенияДействия) Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЦБ.НКД = СтрокаЦБ.Количество * ФинансоваяМатематика.ПолучитьНКД(КэшируемыеЗначения.ТекущийКупон, 
												КэшируемыеЗначения.КонтекстДокумента.Дата,
												КэшируемыеЗначения.ДатаВыплатыКупона,
												КэшируемыеЗначения.ДатаНачалаКупонногоПериода,
												Неопределено);

КонецПроцедуры

Процедура РассчитатьСтоимостьНоминала(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)

	Если Не СтруктураДействий.Свойство("РассчитатьСтоимостьНоминала") Тогда
		Возврат;
	КонецЕсли;
	
	КэшируемыеЗначения.Вставить("СтоимостьНоминала", СтрокаЦБ.Количество * КэшируемыеЗначения.Номинал);
	
КонецПроцедуры

Процедура РассчитатьПремию(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)
	
	Если Не СтруктураДействий.Свойство("РассчитатьПремию") Тогда
		Возврат;
	КонецЕсли;
		
	СтрокаЦБ.Премия = СтрокаЦБ.Стоимость - СтрокаЦБ.Количество * КэшируемыеЗначения.Номинал - СтрокаЦБ.НКД;
	
КонецПроцедуры

Процедура РассчитатьСтоимость(СтрокаЦБ, СтруктураДействий, КэшируемыеЗначения)
	
	Если Не СтруктураДействий.Свойство("РассчитатьСтоимость") Тогда
		Возврат;
	КонецЕсли;
		
	СтрокаЦБ.Стоимость = СтрокаЦБ.Премия + СтрокаЦБ.Количество * КэшируемыеЗначения.Номинал + СтрокаЦБ.НКД;
	
КонецПроцедуры

#КонецОбласти

#Область РасчетГрафика 

Функция ПолучитьГрафик(СтруктураДействий, КонтекстВерсии, ПараметрыГрафика = Неопределено) Экспорт

	Перем ТабГрафик, ОсновнойДолг, ФинансовыйИнструмент, Выданный, ДатаФактическихДанных;
			
	ЕстьПроценты = ПараметрыГрафика.ЕстьПроценты; 
	ЕстьКомиссии = ПараметрыГрафика.ЕстьКомиссии; 
	ЕстьШтрафы = ПараметрыГрафика.ЕстьШтрафы;
	
	Если Не ПараметрыГрафика.Свойство("ФинансовыйИнструмент", ФинансовыйИнструмент) Тогда
		ФинансовыйИнструмент = КонтекстВерсии.ФинансовыйИнструмент;
	КонецЕсли;
	
	ВидФИ = ФинансовыйИнструмент.ВидФинансовогоИнструмента;
	
	Если Не ПараметрыГрафика.Свойство("ТекущийГрафик", ТабГрафик) Тогда		
		ТабГрафик = СоздатьШаблонГрафика(ЕстьПроценты, ЕстьКомиссии, ЕстьШтрафы);
	КонецЕсли;	
	
	Если ДатаФактическихДанных = Неопределено Тогда
		ДатаФактическихДанных = Дата(1,1,1);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьОсновнойДолгЦБ", ОсновнойДолг) Тогда
		ДобавитьОперацииОсновногоДолгаЦБ(ТабГрафик, ОсновнойДолг, ДатаФактическихДанных);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("РассчитатьПроценты") Тогда
		
		ЭтоЦБ = Перечисления.ВидыФинансовыхИнструментов.ПолучитьВидыЦенныхБумаг().НайтиПоЗначению(ВидФИ) <> Неопределено;
		Если ЭтоЦБ Тогда
			ПараметрыРасчетаСтавки = СтруктураПараметровРасчетаПроцентовНоминалаЦБ(ФинансовыйИнструмент, КонтекстВерсии);		
		КонецЕсли;
		
		ЗаполнитьРассчитатьПроценты(КонтекстВерсии, ПараметрыРасчетаСтавки, ДатаФактическихДанных);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("ЗаполнитьПроценты") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КонтекстВерсии.Проценты, ТабГрафик);
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("СвернутьГрафик") Тогда
		СвернутьГрафик(ТабГрафик, ЕстьПроценты, ЕстьКомиссии, ЕстьШтрафы);		
	КонецЕсли;
	
	Если СтруктураДействий.Свойство("РассчитатьСальдо") Тогда
		РассчитатьСальдоГрафика(ТабГрафик, ЕстьПроценты, ЕстьКомиссии, ЕстьШтрафы);
	КонецЕсли;
	
	Возврат ТабГрафик;

КонецФункции

Функция СтруктураПараметровРасчетаПроцентовНоминалаЦБ(КонтекстФИ, КонтекстВерсииГрафика) Экспорт
		
	ТабОсновнойДолг = СоздатьШаблонГрафика(Истина, Ложь, Ложь);
	
	КонтекстОсновнойДолг = Новый Структура("ДатаВыпуска,ДатаПогашения,ОсновнойДолгПолучение,ОсновнойДолгВозврат",
											КонтекстФИ.ДатаВыпуска, 
											КонтекстФИ.СрокПогашения, 
											КонтекстФИ.Номинал,
											КонтекстФИ.Номинал
										);
										
	ДобавитьОперацииОсновногоДолгаЦБ(ТабОсновнойДолг, КонтекстОсновнойДолг);
	
	ТабОсновнойДолг.Колонки.ОсновнойДолгПолучение.Имя = "Приход";
	ТабОсновнойДолг.Колонки.ОсновнойДолгВозврат.Имя = "Расход";
	
	Результат = ФинансоваяМатематикаКлиентСервер.СтруктураПараметровРасчетаПроцентов();
	
	Результат.ДатаНачала 		= КонтекстФИ.ДатаВыпуска;
	Результат.ДатаОкончания 	= КонтекстФИ.СрокПогашения;
	
	Результат.ПравилоПереноса 				= КонтекстВерсииГрафика.ПереносДатСНерабочихДней;
	Результат.ИзменятьПроцентныйПериод 		= КонтекстВерсииГрафика.ИзменяетсяДлительностьПроцентногоПериодаПриПереносе;
	Результат.ПроизводственныйКалендарь		= КонтекстВерсииГрафика.ПроизводственныйКалендарь;
	Результат.ПериодичностьУплаты 			= КонтекстВерсииГрафика.ПериодичностьУплатыПроцентов;
	Результат.ДатаОтсчетаПроцентныхПериодов = КонтекстВерсииГрафика.ДатаОтсчетаПроцентныхПериодов;
	
	Результат.ДатаПервойВыборки = КонтекстФИ.ДатаВыпуска;
	Результат.ДатаНачалаДействия = КонтекстФИ.ДатаВыпуска;
	Результат.ДатаПервогоПогашения = КонтекстФИ.СрокПогашения;
	Результат.ТочкаОтсчетаСдвигаДатыУплаты = КонтекстВерсииГрафика.ТочкаОтсчетаСдвигаДатыУплаты;
	Результат.СдвигДатыУплаты = КонтекстВерсииГрафика.СдвигДатыУплатыПроцентов;
	Результат.ТипПроцентнойСтавки = КонтекстВерсииГрафика.ТипПроцентнойСтавки;
	Результат.ТочкаОтсчетаДатыФиксацииСтавки = КонтекстВерсииГрафика.ТочкаОтсчетаДатыФиксацииСтавки;
	Результат.СдвигДатыФиксацииСтавки = КонтекстВерсииГрафика.СдвигДатыФиксацииСтавки;
	Результат.ПроцентнаяСтавка = КонтекстВерсииГрафика.ПроцентнаяСтавка;
	Результат.ИндикативнаяСтавка = КонтекстВерсииГрафика.ИндикативнаяСтавка;
	Результат.ПлавающаяСтавкаМинимум = КонтекстВерсииГрафика.ПлавающаяСтавкаМинимум;
	Результат.ПлавающаяСтавкаМаксимум = КонтекстВерсииГрафика.ПлавающаяСтавкаМаксимум;
	Результат.РучноеУправлениеИзменениямиСтавки = КонтекстВерсииГрафика.РучноеУправлениеИзменениямиСтавки;
	Результат.ПроцентныеСтавки = КонтекстВерсииГрафика.ПроцентныеСтавки.Выгрузить();
	Результат.ВыплачиватьПроцентыПериодически = КонтекстВерсииГрафика.ВыплачиватьПроцентыПериодически;
	Результат.ВыплачиватьПроцентыВДатыПогашенияТела = КонтекстВерсииГрафика.ВыплачиватьПроцентыВДатыПогашенияТела;
	Результат.БазаДляРасчетаПроцентов = КонтекстВерсииГрафика.БазаДляРасчетаПроцентов;
	Результат.ОперацииИзмененияБазы = ТабОсновнойДолг;
	Результат.ГраницаФактическихДанных = Дата(1,1,1);
	Результат.ДатаПоследнегоНачисления = КонтекстФИ.ДатаВыпуска;
	Результат.СуммаНакопленнойЗадолженности = 0;
	
	Результат.ИмяКолонкиПриход = "ОсновнойДолгПолучение"; 
	Результат.ИмяКолонкиРасход = "ОсновнойДолгВозврат"; 
	
	Возврат Результат;
	
КонецФункции

Функция СоздатьШаблонГрафика(ЕстьПроценты, ЕстьКомиссии, ЕстьШтрафы)
	
	ТабГрафик = Новый ТаблицаЗначений;		
	
	отДата = ОбщегоНазначенияУХ.ПолучитьОписаниеТиповДаты(ЧастиДаты.ДатаВремя);
	отЧисло = ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(18,2);
	
	ТабГрафик.Колонки.Добавить("Дата", отДата);
	ТабГрафик.Колонки.Добавить("ОсновнойДолгПолучение", отЧисло);
	ТабГрафик.Колонки.Добавить("ОсновнойДолгВозврат", отЧисло);
	
	Если ЕстьПроценты Тогда
		ТабГрафик.Колонки.Добавить("ПроцентыНачислено", отЧисло);
		ТабГрафик.Колонки.Добавить("ПроцентыУплачено", отЧисло);
	КонецЕсли;
	
	Если ЕстьКомиссии Тогда
		ТабГрафик.Колонки.Добавить("КомиссииНачислено", отЧисло);
		ТабГрафик.Колонки.Добавить("КомиссииУплачено", отЧисло);
	КонецЕсли;
	
	Если ЕстьШтрафы Тогда
		ТабГрафик.Колонки.Добавить("КомиссииНачислено", отЧисло);
		ТабГрафик.Колонки.Добавить("КомиссииУплачено", отЧисло);
	КонецЕсли;
	
	Возврат ТабГрафик;

КонецФункции

#Область ОперацииРасчетаГрафика 

Функция ЗаполнитьРассчитатьПроценты(КонтекстВерсии, ПараметрыРасчета, ДатаФактическихДанных = Неопределено) Экспорт

	Если ДатаФактическихДанных = Неопределено Тогда
		ДатаФактическихДанных = Дата(1,1,1);
	КонецЕсли;
	
	Объект = КонтекстВерсии;
		
	ТаблицаПроцентов = ФинансоваяМатематика.ПолучитьТаблицуПроцентов(ПараметрыРасчета);
	// Перенесем таблицу процентов в таблицу графика.
	ТаблицаПроцентов.Колонки.База.Имя = "СуммаЗадолженности";
	Объект.Проценты.Очистить();
	
	Для Каждого ТекСтрокаТаблицыПроцентов Из ТаблицаПроцентов Цикл
		
		Если ДатаФактическихДанных >= ТекСтрокаТаблицыПроцентов.ДатаПлатежа Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Объект.Проценты.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаТаблицыПроцентов);
		НоваяСтрока.Дата = ТекСтрокаТаблицыПроцентов.ДатаНачисления;
		НоваяСтрока.ПроцентыНачислено = ТекСтрокаТаблицыПроцентов.Сумма;
		
		Если ТекСтрокаТаблицыПроцентов.ДатаНачисления = ТекСтрокаТаблицыПроцентов.ДатаПлатежа Тогда
			
			НоваяСтрока.ПроцентыУплачено = ТекСтрокаТаблицыПроцентов.Сумма;
			
		Иначе
			
			НоваяСтрока = Объект.Проценты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрокаТаблицыПроцентов);
			НоваяСтрока.Дата = ТекСтрокаТаблицыПроцентов.ДатаПлатежа;
			НоваяСтрока.ПроцентыУплачено = ТекСтрокаТаблицыПроцентов.Сумма;
			
		КонецЕсли;
		
	КонецЦикла;

КонецФункции

Функция ДобавитьОперацииОсновногоДолгаЦБ(График, ОсновнойДолг, ДатаФактическихДанных = Неопределено) Экспорт

	Если ДатаФактическихДанных = Неопределено Тогда
		ДатаФактическихДанных = Дата(1,1,1);
	КонецЕсли;
	
	Если ДатаФактическихДанных < ОсновнойДолг.ДатаВыпуска Тогда
	
		СтрокаТаб = График.Добавить();
		СтрокаТаб.Дата = ОсновнойДолг.ДатаВыпуска;
		СтрокаТаб.ОсновнойДолгПолучение = ОсновнойДолг.ОсновнойДолгПолучение;
		
	КонецЕсли;
	
	Если ДатаФактическихДанных < ОсновнойДолг.ДатаПогашения Тогда
		
		СтрокаТаб = График.Добавить();
		СтрокаТаб.Дата = ОсновнойДолг.ДатаПогашения;
		СтрокаТаб.ОсновнойДолгВозврат = ОсновнойДолг.ОсновнойДолгВозврат;
		
	КонецЕсли;
	
КонецФункции

Процедура СвернутьГрафик(График, ЕстьПроценты = Истина, ЕстьКомиссии = Истина, ЕстьШтрафы = Истина)
	
	КолонкиСумм = "ОсновнойДолгПолучение,ОсновнойДолгВозврат" 
					+ ?(ЕстьПроценты, 	",ПроцентыНачислено,ПроцентыУплачено", 	"")
					+ ?(ЕстьКомиссии,	",КомиссииНачислено,КомиссииУплачено",	"")
					+ ?(ЕстьШтрафы, 	",ШтрафыНачислено,ШтрафыУплачено", 		"");
	
	График.Свернуть("Дата", КолонкиСумм);						
	График.Сортировать("Дата");
	
	отЧисло = ОбщегоНазначенияУХ.ПолучитьОписаниеТиповЧисла(18, 2);
	
	График.Колонки.Добавить("ОсновнойДолгОстаток", отЧисло);
	
	Если ЕстьПроценты Тогда
		График.Колонки.Добавить("ПроцентыОстаток", отЧисло);
	КонецЕсли;
	
	Если ЕстьКомиссии Тогда
		График.Колонки.Добавить("КомиссииОстаток", отЧисло);
	КонецЕсли;
	
	Если ЕстьШтрафы Тогда
		График.Колонки.Добавить("ШтрафыОстаток", отЧисло);	
	КонецЕсли;	
	
КонецПроцедуры

Процедура РассчитатьСальдоГрафика(КонтекстГрафика, ЕстьПроценты = Истина, ЕстьКомиссии = Истина, ЕстьШтрафы = Истина) Экспорт
	
	СальдоОсновнойДолг	= 0;
	СальдоПроценты		= 0;
	СальдоКомиссии		= 0;
	СальдоШтрафы = 0;
	
	Для Каждого ТекСтрокаГрафика Из КонтекстГрафика Цикл
		
		СальдоОсновнойДолг = СальдоОсновнойДолг + ТекСтрокаГрафика.ОсновнойДолгПолучение - ТекСтрокаГрафика.ОсновнойДолгВозврат;
		ТекСтрокаГрафика.ОсновнойДолгОстаток = СальдоОсновнойДолг;
		
		Если ЕстьПроценты Тогда
		
			СальдоПроценты = СальдоПроценты + ТекСтрокаГрафика.ПроцентыНачислено - ТекСтрокаГрафика.ПроцентыУплачено;	
			ТекСтрокаГрафика.ПроцентыОстаток = СальдоПроценты;
			
		КонецЕсли;
		
		Если ЕстьКомиссии Тогда
		
			СальдоКомиссии = СальдоКомиссии + ТекСтрокаГрафика.КомиссииНачислено - ТекСтрокаГрафика.КомиссииУплачено;	
			ТекСтрокаГрафика.КомиссииОстаток = СальдоКомиссии;
			
		КонецЕсли;
		
		Если ЕстьШтрафы Тогда
			
			СальдоШтрафы = СальдоШтрафы + ТекСтрокаГрафика.ШтрафыНачислено - ТекСтрокаГрафика.ШтрафыУплачено;
			ТекСтрокаГрафика.ШтрафыОстаток = СальдоШтрафы;
		
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

Процедура ПриИзмененииГрафикаНаФорме(Форма, ВерсияФИ, СвернутьГрафик = Истина, РассчитатьСальдо = Истина, ОбновитьИтоги = Истина) Экспорт

	СтрукутураДействий = Новый Структура;
	Если СвернутьГрафик Тогда
		СтрукутураДействий.Вставить("СвернутьГрафик");		
	КонецЕсли;
	
	Если РассчитатьСальдо Тогда
		СтрукутураДействий.Вставить("РассчитатьСальдо");		
	КонецЕсли;
	
	ПараметрыГрафика = Форма.КэшируемыеЗначения.ПараметрыГрафика;	
	ПараметрыГрафика.Вставить("ТекущийГрафик", ВерсияФИ.График.Выгрузить());		
	ВерсияФИ.График.Загрузить(ПолучитьГрафик(СтрукутураДействий, ВерсияФИ, ПараметрыГрафика));
		
	Форма.КэшируемыеЗначения.ПараметрыГрафика.Удалить("ТекущийГрафик");
	
	Если ОбновитьИтоги Тогда	
		ФинансовыеИнструментыФормыКлиентСервер.ОбновитьИтогиФормаЦБ(Форма, ВерсияФИ.График);	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ЗагрузкаГрафика

#КонецОбласти

#Область СчетаУчета

Функция ПолучитьСчетаПоВидуФИ(ВидФИ, Актив = Ложь) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	т.Ссылка.ИмяПредопределенныхДанных КАК ИмяСчета,
	|	т.Ссылка КАК ВидСчета,
	|	т.Счет КАК Счет
	|ИЗ
	|	Справочник.ВидыСчетовФИ.ВидыФИ КАК т
	|ГДЕ
	|	т.ВидФИ = &ВидФИ
	|	И т.Актив = &Актив
	|
	|УПОРЯДОЧИТЬ ПО
	|	т.Ссылка.Код");
	
	Запрос.УстановитьПараметр("ВидФИ", ВидФИ);
	Запрос.УстановитьПараметр("Актив", Актив);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Результат = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.ВидСчета, Новый Структура("Счет,Субконто1,Субконто2,Субконто3", Выборка.Счет));
	КонецЦикла;
		
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСчетаФИ(ФИ, ИмяДокумента = Неопределено, ЭтоАктив = Истина) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.Ссылка КАК Ссылка,
	|	3 КАК Приоритет
	|ПОМЕСТИТЬ втВозможныеПараметры
	|ИЗ
	|	Справочник.ПараметрыУчетаФИРСБУ КАК т
	|ГДЕ
	|	т.ФИ = &ФИ
	|	И т.Актив = &Актив
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.Ссылка,
	|	2
	|ИЗ
	|	Справочник.ПараметрыУчетаФИРСБУ КАК т
	|ГДЕ
	|	т.ФИ = &РодительФИ
	|	И т.Актив = &Актив
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.Ссылка,
	|	1
	|ИЗ
	|	Справочник.ПараметрыУчетаФИРСБУ КАК т
	|ГДЕ
	|	т.ВидФИ = &ВидФИ
	|	И т.Актив = &Актив
	|	И т.ФИ = НЕОПРЕДЕЛЕНО
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыФИ.Ссылка КАК ВидСчетаФИ,
	|	ПараметрыУчетаФИРСБУСчетаУчета.Счет КАК Счет,
	|	ПараметрыУчетаФИРСБУСчетаУчета.Субконто1 КАК Субконто1,
	|	ПараметрыУчетаФИРСБУСчетаУчета.Субконто2 КАК Субконто2,
	|	ПараметрыУчетаФИРСБУСчетаУчета.Субконто3 КАК Субконто3
	|ИЗ
	|	Справочник.ВидыСчетовФИ.ВидыФИ КАК ВидыФИ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПараметрыУчетаФИРСБУ.СчетаУчета КАК ПараметрыУчетаФИРСБУСчетаУчета
	|		ПО ВидыФИ.Ссылка = ПараметрыУчетаФИРСБУСчетаУчета.ВидСчетаФИ
	|			И (ПараметрыУчетаФИРСБУСчетаУчета.Ссылка В
	|				(ВЫБРАТЬ
	|					т.Ссылка
	|				ИЗ
	|					втВозможныеПараметры КАК т))
	|ГДЕ
	|	ВидыФИ.ВидФИ = &ВидФИ
	|	И ВидыФИ.ВидимостьВДокументах ПОДОБНО &ИмяДокумента";
	
	ЗаполнитьПоВидуДоговора = ТипЗнч(ФИ) = Тип("Структура");
	
	Если ЗаполнитьПоВидуДоговора Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ВидФИ", "ВЫРАЗИТЬ(&ВидФИ КАК Справочник.ВидыДоговоровКонтрагентовУХ).ВидФинансовогоИнструмента"); 
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Запрос.УстановитьПараметр("ВидФИ",			ФИ.ВидФинансовогоИнструмента);	
	Запрос.УстановитьПараметр("ФИ", 			?(ЗаполнитьПоВидуДоговора, Null, ФИ));
	Запрос.УстановитьПараметр("РодительФИ", 	ФИ.Родитель);
	Запрос.УстановитьПараметр("Актив", 			ЭтоАктив);
	Запрос.УстановитьПараметр("ИмяДокумента", 	"%" + ИмяДокумента + "%");
	
	Результат = Новый Соответствие;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.ВидСчетаФИ, Новый Структура("Счет,Субконто1,Субконто2,Субконто3", Выборка.Счет, Выборка.Субконто1, Выборка.Субконто2, Выборка.Субконто3));	
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСчетУчетаФИ(Организация, ДатаСреза, ФИ) Экспорт

	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	т.Счет КАК Счет
	|ИЗ
	|	Документ.ПоступлениеВекселя.СчетаУчета КАК т
	|ГДЕ
	|	т.Ссылка В
	|			(ВЫБРАТЬ ПЕРВЫЕ 1
	|				ВерсииРасчетовСрезПоследних.ВерсияГрафика КАК ВерсияГрафика
	|			ИЗ
	|				РегистрСведений.ВерсииРасчетов.СрезПоследних(&ДатаСреза, Организация = &Организация
	|					И ПредметГрафика = &ФИ
	|					И ВерсияГрафика ССЫЛКА Документ.ПоступлениеВекселя) КАК ВерсииРасчетовСрезПоследних)
	|	И т.ВидСчетаФИ = ЗНАЧЕНИЕ(Справочник.ВидыСчетовФИ.СчетУчетаФИ)");
		
	Запрос.УстановитьПараметр("Организация",	Организация);
	Запрос.УстановитьПараметр("ДатаСреза",		ДатаСреза);
	Запрос.УстановитьПараметр("ФИ", 			ФИ);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Справочники.ВидыСчетовФИ.ПустаяСсылка();
	Иначе 
		Возврат РезультатЗапроса.Выгрузить()[0].Счет;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПодключаемыеКоманды

Функция ПолучитьПараметрыКарточкаСубконто(ДокументСсылка, ИмяРеквизитСубконто = Неопределено) Экспорт
	
	ЗначениеСубконто = Неопределено;
	Организация = Неопределено;
	Если ИмяРеквизитСубконто = Неопределено Тогда
		Если ТипЗнч(ДокументСсылка) = Тип("СправочникСсылка.ЦенныеБумаги") Тогда
			ЗначениеСубконто = ДокументСсылка;	
		ИначеЕсли ТипЗнч(ДокументСсылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ЗначениеСубконто = ДокументСсылка;
			Организация = ДокументСсылка.Организация;
		ИначеЕсли (ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ПоступлениеИнвестиций")) 
			Или (ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.ВыбытиеИнвестиций")) Тогда
			ЗначениеСубконто = ДокументСсылка.ОбъектИнвестирования;
			Организация = ДокументСсылка.Организация;
		Иначе 
			ЗначениеСубконто = ДокументСсылка.ФинансовыйИнструмент;
			Организация = ДокументСсылка.Организация;
		КонецЕсли;;
	Иначе 
		ЗначениеСубконто = ДокументСсылка[ИмяРеквизитСубконто];
		Организация = ДокументСсылка.Организация;
	КонецЕсли;
	
	Если ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.Организации") Тогда
		Контрагенты = ИнтеграцияВИБПереопределяемыйУХ.ПолучитьКонтрагентовПоОрганизации(ДокументСсылка.ОбъектИнвестирования);
		Если Контрагенты.Количество() Тогда
			ЗначениеСубконто = Контрагенты[0];
		КонецЕсли;
	КонецЕсли;
	
	СписокВидовСубконто = Новый СписокЗначений;
	Если ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.ЦенныеБумаги") Тогда
		СписокВидовСубконто.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.ЦенныеБумаги"));
	ИначеЕсли ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.Контрагенты") Тогда
		СписокВидовСубконто.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Контрагенты"));
	ИначеЕсли ТипЗнч(ЗначениеСубконто) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда	
		СписокВидовСубконто.Добавить(ПредопределенноеЗначение("ПланВидовХарактеристик.ВидыСубконтоХозрасчетные.Договоры"));
	КонецЕсли;
	
	ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("НачалоПериода", Дата(1,1,1));
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КонецПериода", Дата(1,1,1));
	ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("СписокВидовСубконто", СписокВидовСубконто);
	Если Организация <> Неопределено Тогда
		ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Организация", ДокументСсылка.Организация);
	КонецЕсли;
	
	Отбор = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	Отбор.ИдентификаторПользовательскойНастройки = "Отбор";
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(Отбор, "Субконто1", ВидСравненияКомпоновкиДанных.Равно, ЗначениеСубконто, , Истина);
	
	Возврат Новый Структура("ПользовательскиеНастройки,СформироватьПриОткрытии,ВидРасшифровки,РежимРасшифровки", 
								ПользовательскиеНастройки, Истина, 2, Истина);
	
КонецФункции

Функция ПолучитьПараметрыОткрытияФИ(Ссылка, ИдентификаторКоманды) Экспорт
	
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ЦенныеБумаги") Тогда
		ФИ = Ссылка;
		ЗначенияЗаполнения = Новый Структура("ФинансовыйИнструмент", ФИ);
	Иначе
		ФИ = Ссылка.ФинансовыйИнструмент;
		ЗначенияЗаполнения = Новый Структура("ФинансовыйИнструмент,ДокументОснование", ФИ, Ссылка);		
	КонецЕсли;
	ВидФИ = ФИ.ВидФинансовогоИнструмента;
		
	Если ИдентификаторКоманды = "ВыпускЦеннойБаги" Тогда
		
		ИмяФормы = "Документ.ВыпускЦеннойБумаги.ФормаОбъекта";
		Если ВидФИ = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхИнструментов.Вексель") Тогда
			ИмяФормы = "Документ.ПоступлениеВекселя.ФормаОбъекта";
			Если ФИ.ПараметрыЦеннойБумаги.ФормаВекселя = ПредопределенноеЗначение("Перечисление.ФормаВекселя.Переводной") Тогда
				ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеВекселя.ВыпускПереводныхВекселей"));
			Иначе	
				ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеВекселя.ВыпускПростыхВекселей"));
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ИдентификаторКоманды = "ВыкупЦеннойБаги" Тогда	
		
		ИмяФормы = "Документ.ВыкупЦеннойБумаги.ФормаОбъекта";
		Если ВидФИ = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхИнструментов.Вексель") Тогда
			ИмяФормы = "Документ.ВыбытиеВекселей.ФормаОбъекта";
			ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийВыбытиеВекселя.ПогашениеВекселя"));			
		КонецЕсли;
		
	ИначеЕсли ИдентификаторКоманды = "ПриобретениеЦеннойБумаги" Тогда	
		
		ИмяФормы = "Документ.ПриобретениеЦеннойБумаги.ФормаОбъекта";
		Если ВидФИ = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхИнструментов.Вексель") Тогда
			ИмяФормы = "Документ.ПоступлениеВекселя.ФормаОбъекта";
			ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступлениеВекселя.ПриобретениеВекселей"));			
		КонецЕсли;
				
	ИначеЕсли ИдентификаторКоманды = "ПродажаЦеннойБумаги" Тогда
		
		ИмяФормы = "Документ.ПродажаЦеннойБумаги.ФормаОбъекта";
		Если ВидФИ = ПредопределенноеЗначение("Перечисление.ВидыФинансовыхИнструментов.Вексель") Тогда
			ИмяФормы = "Документ.ВыбытиеВекселей.ФормаОбъекта";
			ЗначенияЗаполнения.Вставить("ВидОперации", ПредопределенноеЗначение("Перечисление.ВидыОперацийВыбытиеВекселя.ПродажаВекселя"));			
		КонецЕсли;
		
	ИначеЕсли ИдентификаторКоманды = "ОплатаЦеннойБумаги" Тогда	
		
		ИмяФормы = ВстраиваниеУХФинансовыеИнструменты.ИмяФормыОплатаЦБ();
		ЗначенияЗаполнения.Вставить("ИдентификаторКоманды", "ОплатаЦеннойБумаги");
		
	КонецЕсли;

	Возврат Новый Структура("ИмяФормы,ЗначенияЗаполнения", ИмяФормы, ЗначенияЗаполнения);
	
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыФормы

Процедура ДобавитьУсловноеОформлениеФакта(Форма, ДатаФакта = Неопределено) Экспорт

КонецПроцедуры

#КонецОбласти