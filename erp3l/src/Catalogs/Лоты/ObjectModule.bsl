#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	

#Область ОбработчикиСобытийОбъекта


Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка ИЛИ Скрыт Тогда
		Возврат;
	КонецЕсли;
	ЗакупочнаяПроцедура = Владелец;
	ПроверитьУжеВведенДругойЛот(Отказ);
	ПроверитьУстановитьОрганизациюДляЗаключенияДоговора();
	ПроверитьНенулевыеСуммы(Отказ);
	ПроверитьКоличествоСуммыПоЗонтичнымЗакупкам(Отказ);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка ИЛИ Скрыт Тогда
		Возврат;
	КонецЕсли;
	Если ПометкаУдаления Тогда
		ОчиститьДвиженияРегистраЛотыПланаЗакупок();
	Иначе
		Если ЦентрализованныеЗакупкиУХ.ОбъектУтвержден(Ссылка)
            	И ПроверитьЗаполнениеХарактеристикОтменить(Отказ) Тогда
			Возврат;
		КонецЕсли;
		ЗаписатьДвиженияРегистраЛотыПланаЗакупок();
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ТипЗаполнения = ТипЗнч(ДанныеЗаполнения);
	УстановитьНовыйКод();
	Если ТипЗаполнения = Тип("СправочникСсылка.ЗакупочныеПроцедуры") Тогда
		Владелец = ДанныеЗаполнения;
	ИначеЕсли ТипЗаполнения = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения); 
		Если ДанныеЗаполнения.Свойство("СтрокаПланаЗакупок") Тогда
			СтрокаПланаЗакупок = ДанныеЗаполнения.СтрокаПланаЗакупок;
		Иначе
			// Нет данных для заполнения строки плана закупок.
		КонецЕсли;
	ИначеЕсли ТипЗаполнения = Тип("ДокументСсылка.СтрокаПланаЗакупок") Тогда
		СтрокаПланаЗакупок = ДанныеЗаполнения;
	КонецЕсли;
	ЗаполнитьИзЗакупочнойПроцедуры(Владелец);
	ЗаполнитьИзСтрокиПланаЗакупок(СтрокаПланаЗакупок);
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		СтандартнаяОбработка = Ложь;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Невозможно создать лот без указания закупочной процедуры, к которой он относится'");
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СтрокаПланаЗакупок) Тогда
		Если ТипЗнч(Владелец) = Тип("СправочникСсылка.ЗакупочныеПроцедуры") Тогда
			ПериодЗакупок = Владелец.ПериодЗакупок;
		Иначе
			СтандартнаяОбработка = Ложь;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Невозможно создать лот без указания строки плана закупок, к которой он относится'");
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		ЭтотОбъект.УстановитьНовыйКод();
		НовоеНаименование = НСтр("ru = 'Лот №%Код%'");
		НовоеНаименование = СтрЗаменить(НовоеНаименование, "%Код%", Строка(Код));
		Наименование = НовоеНаименование;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ВалютаДокумента) Тогда
		ВалютаДокумента = Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить();
	КонецЕсли;
	Если ЗначениеЗаполнено(Владелец) Тогда
		СпособВыбораПоставщика = Владелец.СпособВыбораПоставщика;
	Иначе
		СпособВыбораПоставщика = Неопределено;
	КонецЕсли;
	МетодОценкиПредложенийПоставщиков = 
		Справочники.Лоты.ПолучитьМетодОценкиПоСпособуВыбораПоставщика(СпособВыбораПоставщика);
	УстановитьСуммуЛота();			
	#Область ШаблоныЗаполнения
	// Заполнение по шаблону.
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ШаблоныЗаполнения") Тогда
		УправлениеШаблонамиЗаполненияУХ.ЗаполнитьИзШаблона(ДанныеЗаполнения, ЭтотОбъект);
	КонецЕсли;
	#КонецОбласти
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Скрыт Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;
	МассивНепроверяемыхРеквизитов = Новый Массив();	
	Если Справочники.Лоты.ЭтоФЗ223(ЭтотОбъект) Тогда
		ПроверяемыеРеквизиты.Добавить("ПорядокФормированияЦеныДоговора");
	КонецЕсли;
	ПроверитьОдинаковыеРеквизитыСЛотамиЗакупки(Отказ);
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	// Проверим совпадение товарной категории в шапке с категорией в табличной части.
	Если Константы.РазделятьНоменклатуруПоКатегорийнымМенеджерам.Получить() Тогда
		РезультатПроверки = ЦентрализованныеЗакупкиУХ.ПроверитьТоварныеКатегорииВТаблице(ТоварнаяКатегория, Номенклатура, "Номенклатура");
		Если Не РезультатПроверки Тогда
			Отказ = Истина;
		Иначе
			// Проверка пройдена успешно.  
		КонецЕсли;
	Иначе
		// Товарные категории не используются.
	КонецЕсли;
	// Проверим соответствие товарной категории лота товарной категории закупочной процедуры.
	Если ТоварнаяКатегория <> Владелец.ТоварнаяКатегория Тогда
		ТекстСообщения = НСтр("ru = 'Товарная категория ""%КатегорияЛота%"" лота не совпадает с товарной категорией ""%КатегорияЗакупки%"" закупочной процедуры. Запись отменена.'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КатегорияЛота%", Строка(ТоварнаяКатегория));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КатегорияЗакупки%", Строка(Владелец.ТоварнаяКатегория));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		Отказ = Истина;
	Иначе
		// Проверка пройдена успешно.
	КонецЕсли;
	
	//Проверка соглашения
	Если ЗначениеЗаполнено(Соглашение) Тогда
		ПроверкаСоглашения(Отказ);
	КонецЕсли;
	//Проверка соглашения
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
	УИД_ЕИС = "";
	РегистрационныйНомер = 0;
КонецПроцедуры


#КонецОбласти


#Область ЭкспортныеФункцииОбъекта


Процедура ЗаполнитьИзЗакупочнойПроцедуры(ВходящаяЗакупочнаяПроцедура) Экспорт
	Если ЗначениеЗаполнено(ВходящаяЗакупочнаяПроцедура) Тогда
		// Заполнение шапки.
		Владелец			 = ВходящаяЗакупочнаяПроцедура;
		ЗакупочнаяПроцедура	 = ВходящаяЗакупочнаяПроцедура;
		ШаблонЛота			 = Справочники.Лоты.ПолучитьШаблонЛота(Владелец);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ШаблонЛота);
		// Заполение табличных частей.
		ВыгрузкаТребованияКПоставщикам = Владелец.ТребованияКПоставщикам.Выгрузить();
		ТребованияКПоставщикам.Загрузить(ВыгрузкаТребованияКПоставщикам);
		ВыгрузкаТребованияКДокументам = Владелец.ТребованияКСоставуДокументов.Выгрузить();
		ТребованияКСоставуДокументов.Загрузить(ВыгрузкаТребованияКДокументам);
		//Заполнение вида закупки
		ВидЗакупки = Перечисления.ВидЛотовойЗакупки.ЛотоваяЗакупка;
		//Заполнение соглашения    
		Если ЗначениеЗаполнено(Соглашение) Тогда 
		СоздатьСоглашениеПоЗакупочнойПроцедуре(Соглашение);   
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ЗаполнитьИзСтрокиПланаЗакупок(СтрокаПланаЗакупокЗаполнения) Экспорт
	Если ЗначениеЗаполнено(СтрокаПланаЗакупокЗаполнения) Тогда
		СтрокаПланаЗакупок = СтрокаПланаЗакупокЗаполнения;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтрокаПланаЗакупокЗаполнения);
		ВыгрузкаНоменклатуры = СтрокаПланаЗакупокЗаполнения.Номенклатура.Выгрузить();
		Номенклатура.Загрузить(ВыгрузкаНоменклатуры);
		ЗаполнитьИзЗапросаНаПроведениеЗакупки(
			Документы.ОбоснованиеТребованийКЗакупочнойПроцедуре.ПолучитьПоСтрокеПланаЗакупок(
				СтрокаПланаЗакупокЗаполнения));
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьЗаполнениеХарактеристикОтменить(Отказ) Экспорт
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(
		ЭтотОбъект,
		Новый Массив,
		Отказ,
		УправлениеЗакупкамиВстраиваниеПереопределяемыйУХ.ПараметрыПроверкиЗаполненияХарактеристик());
	Возврат Отказ;
КонецФункции


#КонецОбласти


#Область СлужебныеФункцииОбъекта


Процедура СоздатьСоглашениеПоЗакупочнойПроцедуре(Соглашение)
	
	Попытка
		НовоеСоглашение = Соглашение.Скопировать();
		НовоеСоглашение.ЦенаВключаетНДС = Истина;
		НовоеСоглашение.Наименование = "Условие оплаты по Лоту " + СокрЛП(Код);
		НовоеСоглашение.КонтролироватьЦеныЗакупки = ЗапретПревышенияНМЦ;
		НовоеСоглашение.РегистрироватьЦеныПоставщика = Истина;
		Новоесоглашение.Записать();
		УсловияОплаты = ОпределитьУсловиеОплатыПоСоглашению(Новоесоглашение);
		Соглашение = ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка");
		Соглашение = НовоеСоглашение.Ссылка;
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Ошибка = ОписаниеОшибки();
		ТекстСообщения = НСтр("ru = 'Невозможно создать новое соглашение по лоту по причине ""%Ошибка%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ошибка%", Строка(Ошибка));
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
	КонецПопытки;	
	
КонецПроцедуры	

Функция ОпределитьУсловиеОплатыПоСоглашению(Соглашение) Экспорт
	
	
	ФормаОплаты            = Соглашение.ФормаОплаты;
	ЭтапыГрафикаОплаты     = Соглашение.ЭтапыГрафикаОплаты;
	КоличествоЭтаповОплаты = ЭтапыГрафикаОплаты.Количество();
	
	МассивСтрок = Новый Массив;
	МассивСтрок.Добавить(ПредставлениеФормыОплатыДляСоглашений(ФормаОплаты));
	
	ТекстЭтаповОплаты = "";
	Если КоличествоЭтаповОплаты = 0 Тогда
		
		МассивСтрок.Добавить(", ");
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'этапы не указаны';
																|en = 'steps are not set'"), , ));
		
	ИначеЕсли КоличествоЭтаповОплаты <= 2 Тогда
		
		МассивСтрок.Добавить(" ");
		Для Сч=1 По КоличествоЭтаповОплаты Цикл
			СтрокаОплаты = ЭтапыГрафикаОплаты[Сч-1];
			ТекстЭтаповОплаты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 %2% %3 дн';
					|en = '%1 %2% (%3 days)'"),
				ПредставлениеВариантаОплаты(СтрокаОплаты.ВариантОплаты),
				СтрокаОплаты.ПроцентПлатежа, СтрокаОплаты.Сдвиг);
			МассивСтрок.Добавить(ТекстЭтаповОплаты);
			МассивСтрок.Добавить(", ");
		КонецЦикла;
		МассивСтрок.Удалить(МассивСтрок.Количество()-1);
		
	Иначе
		
		ТекстЭтапа = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
			КоличествоЭтаповОплаты,
			НСтр("ru = 'этапы';
				|en = 'stages'"), НСтр("ru = 'этапа';
									|en = 'stage'"), НСтр("ru = 'этапов';
														|en = 'steps'"), НСтр("ru = 'м';
																				|en = 'm'"));
			
		МассивСтрок.Добавить(" ");
		МассивСтрок.Добавить(НСтр("ru = 'в';
									|en = 'in'") +" " + Формат(КоличествоЭтаповОплаты, "ЧН=0") +" " + ТекстЭтапа);
		
	КонецЕсли;
	
	ТекстНадписи = Новый ФорматированнаяСтрока(МассивСтрок);
	Возврат ТекстНадписи;
	
КонецФункции

Функция ПредставлениеВариантаОплаты(ВариантОплаты)
	
	Представление = "";
	
	Если ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.ПредоплатаДоОтгрузки")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.ПредоплатаДоПоступления") Тогда
		Представление = НСтр("ru = 'Предоплата';
							|en = 'Prepayment'");
	ИначеЕсли ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.КредитПослеОтгрузки")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.КредитПослеПоступления") Тогда
		Представление = НСтр("ru = 'Кредит';
							|en = 'Credit'");
	ИначеЕсли ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.АвансДоОбеспечения")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.АвансДоПодтверждения") Тогда
		Представление = НСтр("ru = 'Аванс';
							|en = 'Advance'");
	ИначеЕсли ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыКлиентом.КредитСдвиг")
		Или ВариантОплаты = ПредопределенноеЗначение("Перечисление.ВариантыОплатыПоставщику.КредитСдвиг") Тогда
		Представление = НСтр("ru = 'Кредит';
							|en = 'Credit'");
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ПредставлениеФормыОплатыДляСоглашений(ФормаОплаты)
	
	Представление = "";
	
	Если Не ЗначениеЗаполнено(ФормаОплаты) Тогда
		Представление = НСтр("ru = 'Оплата: Любая';
							|en = 'Payment: Any'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.ПлатежнаяКарта") Тогда
		Представление = НСтр("ru = 'Оплата платежной картой';
							|en = 'Payment by payment card'");
	ИначеЕсли ФормаОплаты = ПредопределенноеЗначение("Перечисление.ФормыОплаты.Взаимозачет") Тогда
		Представление = НСтр("ru = 'Взаимозачет';
							|en = 'Offsetting'");
	Иначе
		Представление = НСтр("ru = '%ФормаОплаты% оплата';
							|en = '%ФормаОплаты% payment'");
		Представление = СтрЗаменить(Представление, "%ФормаОплаты%", ФормаОплаты);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

Функция ПолучитьДругойЛотЗакупки()
	Если ЗначениеЗаполнено(Владелец) Тогда
		мЛоты = Справочники.ЗакупочныеПроцедуры.ПолучитьЛотыЗакупочнойПроцедуры(
			Владелец, Истина);
		флПроверитьСсылку = ЗначениеЗаполнено(Ссылка);
		Для Каждого Лот Из мЛоты Цикл
			Если НЕ флПроверитьСсылку ИЛИ Лот <> Ссылка Тогда
				Возврат Лот;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Справочники.Лоты.ПустаяСсылка();
КонецФункции

// Осуществляет заполнение лота данными из документа Запрос на проведение 
// закупки ЗапросВход.
Процедура ЗаполнитьИзЗапросаНаПроведениеЗакупки(ЗапросВход)
	Если ЗначениеЗаполнено(ЗапросВход) Тогда
		// Условия оплаты.
		УсловиеОплаты				 = ЗапросВход.УсловиеОплаты;
		УсловияОплаты				 = ЗапросВход.УсловияОплаты;
		УсловияПоставкиИнкотермс	 = ЗапросВход.УсловияПоставкиИнкотермс;
		// Условия обеспечения заявки.
		ОбеспечениеЗаявки					 = ЗапросВход.ОбеспечениеЗаявки;
		ФормаОбеспеченияЗаявки				 = ЗапросВход.ФормаОбеспеченияЗаявки;
		ПроцентОтСуммыЛотаОбеспеченияЗаявки	 = ЗапросВход.ПроцентОтСуммыЛотаОбеспеченияЗаявки;
		// Условия обеспечения договора.
		ОбеспечениеДоговора						 = ЗапросВход.ОбеспечениеДоговора;
		ФормаОбеспеченияДоговора				 = ЗапросВход.ФормаОбеспеченияДоговора;
		ПроцентОтСуммыЗаявкиОбеспеченияДоговора	 = ЗапросВход.ПроцентОтСуммыЗаявкиОбеспеченияДоговора;
		ВеличинаОбеспеченияДоговора				 = ЗапросВход.ВеличинаОбеспеченияДоговора;
		// Условия возврата аванса.
		ОбеспечениеВозвратаАванса	 = ЗапросВход.ОбеспечениеВозвратаАванса;
		ФормаВозвратаАванса			 = ЗапросВход.ФормаВозвратаАванса;
		ВеличинаВозвратаАванса		 = ЗапросВход.ВеличинаВозвратаАванса;
		// Преференции участникам.
		ПреференцииДляКонтрагентов			 = ЗапросВход.ПреференцииДляКонтрагентов;
		ВеличинаПреференцийДляКонтрагентов	 = ЗапросВход.ВеличинаПреференцийДляКонтрагентов;
	Иначе
		// Запрос на проведение закупки не указан. Не заполняем данные из запроса на проведение закупки.
	КонецЕсли;
КонецПроцедуры		// ЗаполнитьИзЗапросаНаПроведениеЗакупки()

Процедура ЗаполнитьИзЛотовЗакупочнойПроцедуры()
	Лот = ПолучитьДругойЛотЗакупки();
	Если ЗначениеЗаполнено(Лот) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Лот);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьСуммуЛота() Экспорт
	НМЦИзОбоснования = Неопределено;
	Если ЗначениеЗаполнено(СтрокаПланаЗакупок) Тогда
		НМЦИзОбоснования = 
			РегистрыСведений.НМЦСтрокиПланаЗакупок.ПолучитьНМЦПоВерсииСтрокиПлана(
				СтрокаПланаЗакупок);
	КонецЕсли;
	Если ЗначениеЗаполнено(НМЦИзОбоснования) Тогда
		СуммаЛота = НМЦИзОбоснования;
	Иначе
		СуммаЛота = Номенклатура.Итог("Сумма");
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьУжеВведенДругойЛот(Отказ)
	Если Скрыт Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(СтрокаПланаЗакупок) Тогда
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("СтрокаПланаЗакупок", СтрокаПланаЗакупок);
		СтруктураОтбора.Вставить("ПометкаУдаления", Ложь);
		мСсылок = ЦентрализованныеЗакупкиУХ.ПолучитьСправочникПоОтбору("Лоты", СтруктураОтбора, Ссылка);
		Если мСсылок.Количество() > 0 Тогда
			ТекстСообщения = НСтр("ru = 'По строке плана закупок %СтрокаПланаЗакупок% уже введен лот %Лот%. Операция отменена'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СтрокаПланаЗакупок%", Строка(СтрокаПланаЗакупок));
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Лот%", Строка(мСсылок[0]));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения,	Отказ, , СтатусСообщения.Важное);
		КонецЕсли;
	Иначе
		// Строка плана закупок не указана. Проверка не требуется.
	КонецЕсли;
КонецПроцедуры

Процедура ЗаписатьДвиженияРегистраЛотыПланаЗакупок()
	Если ЗначениеЗаполнено(
			СтрокаПланаЗакупок.ИдентификаторСтрокиПланаЗакупок) Тогда
		ОписаниеКоэффициента = 
			ЦентрализованныеЗакупкиУХ.ПолучитьКоэффициентПересчетаВалют(
			    ВалютаДокумента,
				Константы.ВалютаУчетаЦентрализованныхЗакупок.Получить(), 
				СтрокаПланаЗакупок.Дата);
			
		НаборЗаписей = РегистрыСведений.ЛотыПланаЗакупок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторСтрокиПланаЗакупок.Установить(
			СтрокаПланаЗакупок.ИдентификаторСтрокиПланаЗакупок);
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = СтрокаПланаЗакупок.Дата;
		НоваяЗапись.ИдентификаторСтрокиПланаЗакупок = 
			СтрокаПланаЗакупок.ИдентификаторСтрокиПланаЗакупок;
		НоваяЗапись.Лот = Ссылка;
		НоваяЗапись.ВерсияСтрокиПланаЗакупок = СтрокаПланаЗакупок;
		НоваяЗапись.Сумма = СуммаЛота 
			* ОписаниеКоэффициента.Коэффициент / ОписаниеКоэффициента.Кратность;
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ОчиститьДвиженияРегистраЛотыПланаЗакупок()
	Если ЗначениеЗаполнено(
			СтрокаПланаЗакупок.ИдентификаторСтрокиПланаЗакупок) Тогда
		НаборЗаписей = РегистрыСведений.ЛотыПланаЗакупок.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИдентификаторСтрокиПланаЗакупок.Установить(
			СтрокаПланаЗакупок.ИдентификаторСтрокиПланаЗакупок);
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьУстановитьОрганизациюДляЗаключенияДоговора()
	Если НЕ ЗначениеЗаполнено(ОрганизацияДляЗаключенияДоговора) 
			И ЗначениеЗаполнено(СтрокаПланаЗакупок) Тогда
		ОрганизацияДляЗаключенияДоговора =
			СтрокаПланаЗакупок.ОрганизацияДляЗаключенияДоговора;
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьОдинаковыеРеквизитыСЛотамиЗакупки(Отказ)
	Лот = ПолучитьДругойЛотЗакупки();
	Ошибки = Неопределено;
	Если ЗначениеЗаполнено(Лот) Тогда
		Если Лот.МетодОценкиПредложенийПоставщиков
					<> МетодОценкиПредложенийПоставщиков Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки,
				"МетодОценкиПредложенийПоставщиков",
				НСтр("ru='Значение реквизита ""Метод оценки предложений поставщиков"""
					+ " не может отличаться от значения в других лотах закупки!'"),
				Неопределено);
		КонецЕсли;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
КонецПроцедуры

// Проверяет, что во всех строках с номенклатурой указана ненулевая сумма.
Процедура ПроверитьНенулевыеСуммы(Отказ)
	Выгрузка = Номенклатура.Выгрузить();
	Выгрузка.Свернуть("Номенклатура, Характеристика", "Сумма");		// Свернём, т.к. в некоторых периодах закупок может не быть.
	Для Каждого ТекВыгрузка Из Выгрузка Цикл
		Если ТекВыгрузка.Сумма = 0 Тогда
			Отказ = Истина;
			ТекстСообщения = НСтр("ru = 'Для номенклатуры ""%Номенклатура%"" указана нулевая сумма. Запись отменена.'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", Строка(ТекВыгрузка.Номенклатура));
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		Иначе
			// Проверка пройдена успешно.
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры		// ПроверитьНенулевыеСуммы()

Процедура	ПроверитьКоличествоСуммыПоЗонтичнымЗакупкам(Отказ);
	Если Не ВидЗакупки = Перечисления.ВидЛотовойЗакупки.Зонтичная Тогда
		Возврат;
	КонецЕсли;	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ЗонтичнаяНоменклатура", УсловияРаспределенияЗонтичнойЗакупки.Выгрузить()); 
	Запрос.УстановитьПараметр("ЛотыНоменклатура",Номенклатура.Выгрузить());
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЛотыНоменклатура.ДоговорСПокупателем КАК ДоговорСПокупателем,
	               |	ЛотыНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ЛотыНоменклатура.Количество КАК Количество,
	               |	ЛотыНоменклатура.Коэффициент КАК Коэффициент,
	               |	ЛотыНоменклатура.Менеджер КАК Менеджер,
	               |	ЛотыНоменклатура.МестоПоставки КАК МестоПоставки,
	               |	ЛотыНоменклатура.Номенклатура КАК Номенклатура,
	               |	ЛотыНоменклатура.Характеристика КАК Характеристика,
	               |	ЛотыНоменклатура.Организация КАК Организация,
	               |	ЛотыНоменклатура.ПериодПотребности КАК ПериодПотребности,
	               |	ЛотыНоменклатура.Приоритет КАК Приоритет,
	               |	ЛотыНоменклатура.Проект КАК Проект,
	               |	ЛотыНоменклатура.СтавкаНДС КАК СтавкаНДС,
	               |	ЛотыНоменклатура.Сумма КАК Сумма,
	               |	ЛотыНоменклатура.СуммаНДС КАК СуммаНДС,
	               |	ЛотыНоменклатура.Цена КАК Цена
	               |ПОМЕСТИТЬ НоменклатураПоставки
	               |ИЗ
	               |	&ЛотыНоменклатура КАК ЛотыНоменклатура
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Количество КАК Количество,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Коэффициент КАК Коэффициент,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Менеджер КАК Менеджер,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Номенклатура КАК Номенклатура,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Характеристика КАК Характеристика,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Организация КАК Организация,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.ПериодПотребности КАК ПериодПотребности,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Приоритет КАК Приоритет,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Проект КАК Проект,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.СтавкаНДС КАК СтавкаНДС,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Сумма КАК Сумма,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.СуммаНДС КАК СуммаНДС,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Цена КАК Цена,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.ДоговорСПокупателем КАК ДоговорСПокупателем,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.МестоПоставки КАК МестоПоставки,
	               |	ЛотыУсловияРаспределенияЗонтичнойЗакупки.Процент КАК Процент
	               |ПОМЕСТИТЬ ТЧЗонтичнаяНоменклатура
	               |ИЗ
	               |	&ЗонтичнаяНоменклатура КАК ЛотыУсловияРаспределенияЗонтичнойЗакупки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТЧЗонтичнаяНоменклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	               |	СУММА(ТЧЗонтичнаяНоменклатура.Количество) КАК Количество,
	               |	ТЧЗонтичнаяНоменклатура.Коэффициент КАК Коэффициент,
	               |	ТЧЗонтичнаяНоменклатура.Менеджер КАК Менеджер,
	               |	ТЧЗонтичнаяНоменклатура.Номенклатура КАК Номенклатура,
	               |	ТЧЗонтичнаяНоменклатура.Характеристика КАК Характеристика,
	               |	ТЧЗонтичнаяНоменклатура.Организация КАК Организация,
	               |	ТЧЗонтичнаяНоменклатура.ПериодПотребности КАК ПериодПотребности,
	               |	ТЧЗонтичнаяНоменклатура.Приоритет КАК Приоритет,
	               |	ТЧЗонтичнаяНоменклатура.Проект КАК Проект,
	               |	ТЧЗонтичнаяНоменклатура.СтавкаНДС КАК СтавкаНДС,
	               |	СУММА(ТЧЗонтичнаяНоменклатура.Сумма) КАК Сумма,
	               |	СУММА(ТЧЗонтичнаяНоменклатура.СуммаНДС) КАК СуммаНДС,
	               |	ТЧЗонтичнаяНоменклатура.Цена КАК Цена,
	               |	ТЧЗонтичнаяНоменклатура.ДоговорСПокупателем КАК ДоговорСПокупателем,
	               |	ТЧЗонтичнаяНоменклатура.МестоПоставки КАК МестоПоставки,
	               |	СУММА(ТЧЗонтичнаяНоменклатура.Процент) КАК Процент
	               |ПОМЕСТИТЬ ЗонтичнаяНоменклатура
	               |ИЗ
	               |	ТЧЗонтичнаяНоменклатура КАК ТЧЗонтичнаяНоменклатура
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТЧЗонтичнаяНоменклатура.ЕдиницаИзмерения,
	               |	ТЧЗонтичнаяНоменклатура.Коэффициент,
	               |	ТЧЗонтичнаяНоменклатура.Организация,
	               |	ТЧЗонтичнаяНоменклатура.Менеджер,
	               |	ТЧЗонтичнаяНоменклатура.Номенклатура,
	               |	ТЧЗонтичнаяНоменклатура.Характеристика,
	               |	ТЧЗонтичнаяНоменклатура.ПериодПотребности,
	               |	ТЧЗонтичнаяНоменклатура.Приоритет,
	               |	ТЧЗонтичнаяНоменклатура.Проект,
	               |	ТЧЗонтичнаяНоменклатура.СтавкаНДС,
	               |	ТЧЗонтичнаяНоменклатура.Цена,
	               |	ТЧЗонтичнаяНоменклатура.ДоговорСПокупателем,
	               |	ТЧЗонтичнаяНоменклатура.МестоПоставки
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	НоменклатураПоставки.Номенклатура КАК Номенклатура,
	               |	НоменклатураПоставки.ПериодПотребности КАК ПериодПотребности
	               |ИЗ
	               |	НоменклатураПоставки КАК НоменклатураПоставки
	               |		ЛЕВОЕ СОЕДИНЕНИЕ ЗонтичнаяНоменклатура КАК ЗонтичнаяНоменклатура
	               |		ПО НоменклатураПоставки.ДоговорСПокупателем = ЗонтичнаяНоменклатура.ДоговорСПокупателем
	               |			И НоменклатураПоставки.ЕдиницаИзмерения = ЗонтичнаяНоменклатура.ЕдиницаИзмерения
	               |			И НоменклатураПоставки.Количество = ЗонтичнаяНоменклатура.Количество
	               |			И НоменклатураПоставки.Коэффициент = ЗонтичнаяНоменклатура.Коэффициент
	               |			И НоменклатураПоставки.Менеджер = ЗонтичнаяНоменклатура.Менеджер
	               |			И НоменклатураПоставки.МестоПоставки = ЗонтичнаяНоменклатура.МестоПоставки
	               |			И НоменклатураПоставки.Номенклатура = ЗонтичнаяНоменклатура.Номенклатура
	               |			И НоменклатураПоставки.Характеристика = ЗонтичнаяНоменклатура.Характеристика
	               |			И НоменклатураПоставки.Организация = ЗонтичнаяНоменклатура.Организация
	               |			И НоменклатураПоставки.ПериодПотребности = ЗонтичнаяНоменклатура.ПериодПотребности
	               |			И НоменклатураПоставки.Приоритет = ЗонтичнаяНоменклатура.Приоритет
	               |			И НоменклатураПоставки.Проект = ЗонтичнаяНоменклатура.Проект
	               |			И НоменклатураПоставки.СтавкаНДС = ЗонтичнаяНоменклатура.СтавкаНДС
	               |			И НоменклатураПоставки.Цена = ЗонтичнаяНоменклатура.Цена
	               |ГДЕ
	               |	ЗонтичнаяНоменклатура.Номенклатура ЕСТЬ NULL
	               |			ИЛИ (ВЫБОР
	               |					КОГДА ТИПЗНАЧЕНИЯ(ЗонтичнаяНоменклатура.Номенклатура) = ТИП(Справочник.ТоварныеКатегории)
	               |							И ЗонтичнаяНоменклатура.Процент <> 100
	               |						ТОГДА ИСТИНА
	               |				КОНЕЦ
	               |				И НоменклатураПоставки.Сумма > 0)" ;
	Выборка = Запрос.Выполнить();
	Если Выборка.Пустой() Тогда
		Возврат;
	КонецЕсли;
	Выборка = Выборка.Выбрать();
	Пока Выборка.Следующий() Цикл
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Некорректно распределена номенклатура ""%Номенклатура%"" по зонтичной закупке за ""%ПериодПотребности%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номенклатура%", Строка(Выборка.Номенклатура));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПериодПотребности%", Строка(Выборка.ПериодПотребности));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЦикла;	
КонецПроцедуры

Процедура ПроверкаСоглашения(Отказ)
	

	Если Соглашение.ЭтапыГрафикаОплаты.Количество() = 0 Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не заполнены этапы графика оплаты соглашения'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Не Соглашение.ИспользуютсяДоговорыКонтрагентов Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Не установлено требования указания договора в соглашении'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Соглашение.Валюта <> ВалютаДокумента Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Различается валюта лота и валюта соглашения'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Соглашение.ЦенаВключаетНДС <> ЦенаВключаетНДС Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Различается свойство ""Цена включает НДС"" лота и соглашения'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если Соглашение.КонтролироватьЦеныЗакупки <> ЗапретПревышенияНМЦ Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='Свойство ""Запретить закупки по ценам выше указанных в соглашении""  соглашения с поставщиком отличается от свойства ""Запрет превышения НМЦ"" лота'");
		Сообщение.ПутьКДанным = "Объект.Соглашение";
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

	
#Область УХ_Напоминания


// Определяет, разрешено ли отправлять напоминания пользователям по данному лоту.
Функция МожноСоздаватьНапоминания()
	Возврат Истина;
КонецФункции


#КонецОбласти


#КонецЕсли
