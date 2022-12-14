#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если Не ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	#Область УХ_Внедрение
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	#КонецОбласти
	
	#Область УХ_Встраивание
	// Проверяем заполнение реквизита "ВидОперацииУХ"
	ЗаявкиНаОперации.ОбработкаЗаполненияКонтрольВидаОперации(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	#КонецОбласти

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	#Область УХ_Встраивание
	//Документы.ОжидаемоеПоступлениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
	Документы.ОжидаемоеПоступлениеДенежныхСредств.ПолучитьМассивыРеквизитов(
	#КонецОбласти 
		ФормаОплаты,
	#Область УХ_Встраивание
		ВидОперацииУХ,
		ХозяйственнаяОперация,
	#КонецОбласти 
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект, МассивВсехРеквизитов, МассивРеквизитовОперации);
		
	Если ФормаОплаты = Перечисления.ФормыОплаты.Безналичная И ЗначениеЗаполнено(БанковскийСчет) Тогда
		КассаБанковскийСчет = БанковскийСчет;
	ИначеЕсли ФормаОплаты = Перечисления.ФормыОплаты.Наличная И ЗначениеЗаполнено(Касса) Тогда
		КассаБанковскийСчет = Касса;
	Иначе
		КассаБанковскийСчет = Неопределено;
	КонецЕсли;
	
	ДатаПлатежа = Дата;
	
	ПредыдущаяДата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Дата");
	Если ЗначениеЗаполнено(ПредыдущаяДата) И ПредыдущаяДата <> Дата Тогда
		ДополнительныеСвойства.Вставить("ПредыдущаяДата", НачалоДня(ПредыдущаяДата));
	КонецЕсли;
	
	#Область УХ_Внедрение
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	#КонецОбласти
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДатыРасчета = Новый Массив;
	ДатыРасчета.Добавить(НачалоДня(Дата));
	Если ДополнительныеСвойства.Свойство("ПредыдущаяДата") Тогда
		ДатыРасчета.Добавить(ДополнительныеСвойства.ПредыдущаяДата);
	КонецЕсли;
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоОжидаемымПоступлениямДенежныхСредств(ДатыРасчета);
	
	#Область УХ_Встраивание
	ЗаявкиНаОперации.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	#КонецОбласти
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ДатыРасчета = Новый Массив;
	ДатыРасчета.Добавить(НачалоДня(Дата));
	Если ДополнительныеСвойства.Свойство("ПредыдущаяДата") Тогда
		ДатыРасчета.Добавить(ДополнительныеСвойства.ПредыдущаяДата);
	КонецЕсли;
	
	НедействительныеДокументыОплаты = Новый Массив;
	НедействительныеДокументыОплаты.Добавить(Ссылка);
	
	РегистрыСведений.ГрафикПлатежей.РассчитатьГрафикПлатежейПоОжидаемымПоступлениямДенежныхСредств(
		ДатыРасчета, НедействительныеДокументыОплаты);
		
	#Область УХ_Встраивание
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	#КонецОбласти 
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	#Область УХ_Встраивание
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	#КонецОбласти 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	#Область УХ_Внедрение
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ПриЗаписи(ЭтотОбъект, Отказ);
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Организация, Валюта);
		БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, Валюта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область УХ_Встраивание

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	НепроверяемыеРеквизиты.Добавить("ОрганизацияОтправитель");
	
	ВстраиваниеУХОжидаемоеПоступлениеДенежныхСредств.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	// Удаляем
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли
