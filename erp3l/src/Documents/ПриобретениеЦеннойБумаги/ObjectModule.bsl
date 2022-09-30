
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ФинансовыеИнструментыУХ.ПроверитьДатуЦБ(ЭтотОбъект, Отказ, Ложь, Ложь);

	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ВстраиваниеУХФинансовыеИнструменты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВстраиваниеУХФинансовыеИнструменты.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
			
	ВстраиваниеУХ.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ФинансовыеИнструментыУХ.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	ЗаполнитьПараметрыОперацийПоУмолчанию();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ФинансовыеИнструментыУХ.ОбработкаПроверкиЗаполнения_СчетаУчета(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
Процедура ЗаполнитьПараметрыОперацийПоУмолчанию() Экспорт
	
	ТаблицаНастроек = РаботаСДоговорамиКонтрагентовУХ.ПараметрыОперацийГрафикаПоУмолчанию(ГруппаОперацийГрафика());
	ЭтотОбъект.ПараметрыОпераций.Загрузить(ТаблицаНастроек);
	
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ГруппаОперацийГрафика()
	
	Возврат Справочники.ОперацииГрафиковДоговоров.ОблигацияКупленная;

КонецФункции
#КонецОбласти

#КонецЕсли
