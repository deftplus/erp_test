
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	ФинансовыеИнструментыУХ.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ЭтотОбъект.ДатаНачала = НачалоМесяца(ЭтотОбъект.Дата);
		ЭтотОбъект.Дата = КонецМесяца(ЭтотОбъект.Дата);
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ФинансовыеИнструментыУХ.ОбработкаЗаполнения(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(ДатаНачала) Тогда
		ЭтотОбъект.ДатаНачала = НачалоМесяца(ЭтотОбъект.Дата);
		ЭтотОбъект.Дата = КонецМесяца(ЭтотОбъект.Дата);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
			
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтотОбъект.Дата <> НачалоЧаса(КонецДня(ЭтотОбъект.Дата)) Тогда
		ЭтотОбъект.Дата  = НачалоЧаса(КонецДня(ЭтотОбъект.Дата));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ЭтотОбъект.ДатаНачала) Тогда
		ЭтотОбъект.ДатаНачала = НачалоМесяца(ЭтотОбъект.Дата);
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ВстраиваниеУХФинансовыеИнструменты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВстраиваниеУХФинансовыеИнструменты.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСерверУХ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);	
	ПроведениеСерверУХ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);	
	//СформироватьСписокРегистровДляКонтроля();	
	ПроведениеСерверУХ.ЗаписатьНаборыЗаписей(ЭтотОбъект);	
	//ПроведениеСерверУХ.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект, Отказ);	
	ПроведениеСерверУХ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СформироватьСписокРегистровДляКонтроля()
	
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", Новый Массив);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
