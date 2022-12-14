#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Устанавливает статус для объекта документа
//
// Параметры:
// 		НовыйСтатус - Строка - Имя статуса, который будет установлен у заказов
// 		ДополнительныеПараметры - Структура - Структура дополнительных параметров установки статуса.
//
// Возвращаемое значение:
// 		Булево - Истина, в случае успешной установки нового статуса.
//
Функция УстановитьСтатус(НовыйСтатус, ДополнительныеПараметры) Экспорт
	
	Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств[НовыйСтатус];
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Автор = Пользователи.ТекущийПользователь();
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Организация") Тогда
			Организация = ДанныеЗаполнения.Организация;
		КонецЕсли;
		Если ДанныеЗаполнения.Свойство("Валюта") Тогда
			Валюта = ДанныеЗаполнения.Валюта;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	#Область УХ_Встраивание
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	#КонецОбласти 
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.НеСогласовано;
	ДатаПлатежа = Дата(1, 1, 1);
	КтоРешил = Неопределено;
	Автор = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если (Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате
		Или Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано)
		И ЗначениеЗаполнено(ДатаПлатежа)
		И ДатаПлатежа < НачалоДня(Дата) Тогда
		
		ТекстОшибки = НСтр("ru = 'Дата платежа не может быть меньше даты документа';
							|en = 'Payment date cannot be earlier than the document date'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ЭтотОбъект,
			"ДатаПлатежа",,
			Отказ);
	КонецЕсли;
	
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ОбщегоНазначенияУТКлиентСервер.ЗаполнитьМассивНепроверяемыхРеквизитов(
		МассивВсехРеквизитов,
		МассивРеквизитовОперации,
		МассивНепроверяемыхРеквизитов);
		
	ДенежныеСредстваСервер.ПроверитьКассуПолучателя(ЭтотОбъект, Отказ);
	ДенежныеСредстваСервер.ПроверитьБанковскийСчетПолучатель(ЭтотОбъект, Отказ);
	
	Если Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано Тогда
		
		ПравоСогласования = ПраваПользователяПовтИсп.СогласованиеРаспоряженийНаПеремещениеДенежныхСредств();
		Если Не ПравоСогласования Тогда
			ТекстОшибки = НСтр("ru = 'У вас нет права согласования распоряжений на перемещение денежных средств.';
								|en = 'You are not authorized to approve cash transfer orders.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,,,
				Отказ);
		КонецЕсли;
		
	ИначеЕсли Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате Тогда
		
		ПравоУтверждения = ПраваПользователяПовтИсп.УтверждениеРаспоряженийНаПеремещениеДенежныхСредств();
		Если Не ПравоУтверждения Тогда
			ТекстОшибки = НСтр("ru = 'У вас нет права утверждения к оплате распоряжений на перемещение денежных средств.';
								|en = 'You are not authorized to confirm payments upon cash transfer orders.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ЭтотОбъект,,,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	РаспоряжениеНаПеремещениеДенежныхСредствЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
	#Область УХ_Встраивание
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	#КонецОбласти
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Если Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.Согласовано Тогда
			Если КтоРешил <> Пользователи.ТекущийПользователь() Тогда
				КтоРешил = Пользователи.ТекущийПользователь();
			КонецЕсли;
		ИначеЕсли Статус = Перечисления.СтатусыРаспоряженийНаПеремещениеДенежныхСредств.КОплате Тогда
			Если Не ЗначениеЗаполнено(КтоРешил) Тогда
				КтоРешил = Пользователи.ТекущийПользователь();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	#Область УХ_Встраивание
	//СтатьяДвиженияДенежныхСредств = Справочники.СтатьиДвиженияДенежныхСредств.ПредопределеннаяСтатьяДДС(ХозяйственнаяОперация, Валюта);
	#КонецОбласти
	
	// Очистим реквизиты документа не используемые для хозяйственной операции.
	МассивВсехРеквизитов = Новый Массив;
	МассивРеквизитовОперации = Новый Массив;
	Документы.РаспоряжениеНаПеремещениеДенежныхСредств.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		ХозяйственнаяОперация,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	ДенежныеСредстваСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
	#Область УХ_Внедрение
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	#КонецОбласти
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	#Область УХ_Встраивание
	ВстраиваниеУХРаспоряжениеНаПеремещениеДенежныхСредств.ПриЗаписи(ЭтотОбъект, Отказ);
	#КонецОбласти 
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	#Область УХ_Встраивание
	МодульУправленияПроцессамиУХ.ОтправитьНаСогласованиеПриПроведенииДокумента(ЭтотОбъект, Отказ);
	Возврат;	// Документ не выполняет движений
	#КонецОбласти
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	#Область УХ_Внедрение	
	// Отмена согласования.
	ДополнительныеСвойстваОбъекта = ЭтотОбъект.ДополнительныеСвойства;
	ИзменятьСостояниеПриОтменеПроведения = НЕ ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДополнительныеСвойстваОбъекта, "НеИзменятьСостояниеПриОтменеПроведения", Ложь);
	Если ИзменятьСостояниеПриОтменеПроведения Тогда
		МодульУправленияПроцессамиУХ.ОтменитьСогласованиеПриОтменеПроведения(Ссылка);
	Иначе
		// Не требуется изменять состояние. Пропускаем.
	КонецЕсли;
	// Перевод документа в статус Черновик вручную.
	СостояниеЧерновик = Перечисления.СостоянияСогласования.Черновик;
	НовыйСтатус = УправлениеПроцессамиСогласованияУХ.ВернутьСтатусОбъекта(Ссылка, СостояниеЧерновик);
	Если НовыйСтатус <> СостояниеЧерновик Тогда
		ТекДата = ТекущаяДатаСеанса();
		ТекПользователь = Пользователи.ТекущийПользователь();
		УправлениеПроцессамиСогласованияУХ.ПеревестиЗаявкуВПроизвольноеСостояние(Ссылка, СостояниеЧерновик, ТекДата, ТекПользователь, , , Ложь);
	Иначе
		// Не изменяем состояние.
	КонецЕсли;
	#КонецОбласти
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияИЗаполнение

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Если ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") Или НЕ ДанныеЗаполнения.Свойство("Организация") Тогда
		Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Касса = Справочники.Кассы.ПолучитьКассуПоУмолчанию(Организация, Валюта);
		КассаПолучатель = Касса;
		БанковскийСчет = Справочники.БанковскиеСчетаОрганизаций.ПолучитьБанковскийСчетОрганизацииПоУмолчанию(Организация, Валюта);
		БанковскийСчетПолучатель = БанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область УХ_Внедрение

Функция Отправитель() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПриходРасход", Перечисления.ВидыДвиженийПриходРасход.Расход);
	Результат.Вставить("БанковскийСчетКасса", БанковскийСчет);
	Результат.Вставить("ФормаОплаты", Перечисления.ФормыОплаты.Безналичная);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СдачаДенежныхСредствВБанк
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк ТОГДА 
		
			Результат.БанковскийСчетКасса = Касса;
			Результат.ФормаОплаты = Перечисления.ФормыОплаты.Наличная;
			
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция Получатель() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ПриходРасход", Перечисления.ВидыДвиженийПриходРасход.Приход);
	Результат.Вставить("БанковскийСчетКасса", БанковскийСчетПолучатель);
	Результат.Вставить("ФормаОплаты", Перечисления.ФормыОплаты.Безналичная);
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств ТОГДА 
		
			Результат.БанковскийСчетКасса = КассаПолучатель;
			Результат.ФормаОплаты = Перечисления.ФормыОплаты.Наличная;
			
	КонецЕсли;

	Возврат Результат;
	
КонецФункции


#КонецОбласти

#КонецЕсли
