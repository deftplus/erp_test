
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
		ЗаполнитьНаОснованииОбъектаЭксплуатации(ДанныеЗаполнения);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.СписаниеОС2_4") Тогда
		ЗаполнитьНаОснованииСписания(ДанныеЗаполнения);
	КонецЕсли;
	
	СписаниеОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_СписаниеОС(
									ЭтотОбъект, ВспомогательныеРеквизиты());
									
	ОбщегоНазначенияУТ.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ);
	ПроверитьПриходуемыеМЦ(Отказ);
	
	ПараметрыПроверки = НоменклатураСервер.ПараметрыПроверкиЗаполненияХарактеристик();
	ПараметрыПроверки.ИмяТЧ = "ПриходуемыеМЦ";
	НоменклатураСервер.ПроверитьЗаполнениеХарактеристик(ЭтотОбъект, МассивНепроверяемыхРеквизитов, Отказ, ПараметрыПроверки);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	СписаниеОСЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
		ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСНеПолученыВАрендуНаБаланс(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.СписаниеОС2_4.ПараметрыНастройкиСчетовУчета());
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	СписаниеОСЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеОС Тогда
		
		ДополнительныеСвойства.Вставить("КонтролироватьСписаниеВНоль", Истина);
		
	КонецЕсли;

	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	СписаниеОСЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование = Неопределено;
	ДокументВДругомУчете = Неопределено;
	
	ИнициализироватьДокумент();
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
	СписаниеОСЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ЗаблокироватьЧитаемыеДанные();
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СписаниеОСЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	СписаниеОСЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент()
	
	Дата = НачалоДня(ТекущаяДатаСеанса());
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	
	ПараметрыВыбораСтатейИАналитик = Документы.СписаниеОС2_4.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ЗаблокироватьЧитаемыеДанные()

	// Нужно заблокировать данные, которые используются при записи движений.
	// Например, данные регистров сведений, которые используются для заполнения недостающих ресурсов.
	
	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПервоначальныеСведенияОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.МестонахождениеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Если ОтражатьВУпрУчете Тогда
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПорядокУчетаОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПараметрыАмортизацииОСУУ");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
		ЭлементБлокировки.ИсточникДанных = ОС;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
		ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
		
	КонецЕсли; 
	
	СписаниеОСЛокализация.ДополнитьБлокировкуДанныхПриПроведении(ЭтотОбъект, Блокировка);
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		
		ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание.ОсновноеСредство);
		
	Иначе
		
		СписаниеОСЛокализация.ЗаполнитьДокументПоОтбору(ЭтотОбъект, Основание);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектаЭксплуатации(Основание)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Основание, "ЭтоГруппа") Тогда
		
		ТекстСообщения = НСтр("ru = 'Списание группы ОС невозможно.
			|Выберите ОС. Для раскрытия группы используйте клавиши Ctrl и стрелку вниз.';
			|en = 'Cannot write off fixed assets group.
			|Select fixed assets. To expand the group, press Ctrl+Down.'");
		ВызватьИсключение(ТекстСообщения);
		
	КонецЕсли;
	
	ПервоначальныеСведения = ВнеоборотныеАктивыСлужебный.СообщитьЕслиОСНеПринятоКУчету(Основание, Дата);
	
	Если ПервоначальныеСведения.СостояниеБУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету
		ИЛИ ПервоначальныеСведения.СостояниеУУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету Тогда	
		ТекстСообщения = НСтр("ru = 'Основное средство ""%1"" поступило в аренду. 
                                        |Необходимо использовать документ ""Возврат ОС арендатору"".';
                                        |en = 'The ""%1"" fixed asset was leased.
                                        |Use the ""Fixed assets return to lessee"" document.'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(Основание));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли; 
	
	СтрокаТабличнойЧасти = ОС.Добавить();
	СтрокаТабличнойЧасти.ОсновноеСредство = Основание;

	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеОСЧастичное Тогда
		СтрокаТабличнойЧасти.ЛиквидационнаяСтоимость = ПервоначальныеСведения.ЛиквидационнаяСтоимость;
		СтрокаТабличнойЧасти.ЛиквидационнаяСтоимостьРегл = ПервоначальныеСведения.ЛиквидационнаяСтоимостьРегл;
	КонецЕсли;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = 
		ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ)
		ИЛИ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ);
	
	Организация = ПервоначальныеСведения.Организация;
	Подразделение = ПервоначальныеСведения.Местонахождение;
	
	СписаниеОСЛокализация.ЗаполнитьНаОснованииОбъектаЭксплуатации(ЭтотОбъект, Основание);
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииСписания(Основание, ОсновноеСредство = Неопределено)

	ОснованиеОбъект = Основание.ПолучитьОбъект();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОснованиеОбъект,, "Номер,Дата,ВерсияДанных,Ответственный,ПометкаУдаления,Проведен");
	ДокументВДругомУчете = Основание;
	
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		Для каждого СтрокаОснования Из ОснованиеОбъект.ОС Цикл
			СтрокаТабличнойЧасти = ОС.Добавить();
			СтрокаТабличнойЧасти.ОсновноеСредство = СтрокаОснования.ОсновноеСредство;
		КонецЦикла; 
		ОС.Загрузить(ОснованиеОбъект.ОС.Выгрузить());
	Иначе
		СтрокаТабличнойЧасти = ОС.Добавить();
		СтрокаТабличнойЧасти.ОсновноеСредство = ОсновноеСредство;
	КонецЕсли; 
	
	Если ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА() Тогда
		Если ОснованиеОбъект.ОтражатьВРеглУчете Тогда
			ОтражатьВРеглУчете = Ложь;
			ОтражатьВУпрУчете  = Истина;
		Иначе
			ОтражатьВРеглУчете = Истина;
			ОтражатьВУпрУчете  = Ложь;
		КонецЕсли; 
	Иначе	
		ОтражатьВРеглУчете = Истина;
		ОтражатьВУпрУчете  = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПередЗаписью()

	ОчиститьНеиспользуемыеРеквизиты();
	
	Если ОтражатьВУпрУчете И ОтражатьВРеглУчете Тогда
		ДокументВДругомУчете = Неопределено;
	КонецЕсли;
	
	Если НЕ ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА()
		И Константы.ВалютаУправленческогоУчета.Получить() = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация) Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.СуммаСписанияУУ = ДанныеСтроки.СуммаСписанияБУ;
			ДанныеСтроки.ЛиквидационнаяСтоимость = ДанныеСтроки.ЛиквидационнаяСтоимостьРегл;
		КонецЦикла; 
		
	КонецЕсли; 
	
	Если ОС.Количество() = 1 Тогда
		Для Каждого ДанныеСтроки Из ПриходуемыеМЦ Цикл
			ДанныеСтроки.ОсновноеСредство = ОС[0].ОсновноеСредство;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ВспомогательныеРеквизиты = ВспомогательныеРеквизиты();
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_СписаниеОС(ЭтотОбъект, ВспомогательныеРеквизиты);
	ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС,ПриходуемыеМЦ,Основания");
	
КонецПроцедуры

Процедура ПроверитьОсновныеСредства(МассивНепроверяемыхРеквизитов, Отказ)

	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	ПроверятьСуммуСписанияБУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СуммаСписанияБУ") = Неопределено);
	ПроверятьСуммуСписанияУУ = (МассивНепроверяемыхРеквизитов.Найти("ОС.СуммаСписанияУУ") = Неопределено);
	
	ПредставлениеРеквизитов = Документы.СписаниеОС2_4.ПредставлениеРеквизитов(Организация);
	
	ШаблонСообщения = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""';
							|en = 'The ""%1"" column in %2 line of the ""Fixed assets"" list is not filled in'");
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		НомерСтроки = Формат(ДанныеСтроки.НомерСтроки, "ЧГ=");
		
		Если ПроверятьСуммуСписанияБУ
			И ДанныеСтроки.СуммаСписанияБУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СуммаСписанияБУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СуммаСписанияБУ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
		Если ПроверятьСуммуСписанияУУ
			И ДанныеСтроки.СуммаСписанияУУ = 0 Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПредставлениеРеквизитов.Получить("ОС.СуммаСписанияУУ"), НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "СуммаСписанияУУ");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
		
	КонецЦикла; 
	
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СуммаСписанияБУ");
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СуммаСписанияУУ");
	
КонецПроцедуры

Процедура ПроверитьПриходуемыеМЦ(Отказ)
	
	Если ПриходуемыеМЦ.Количество() = 0
		ИЛИ ОС.Количество() < 2 Тогда
		Возврат;
	КонецЕсли;
	
	СписокОС = Новый Массив;
	Для Каждого ДанныеСтроки Из ОС Цикл
		Если ЗначениеЗаполнено(ДанныеСтроки.ОсновноеСредство) Тогда
			СписокОС.Добавить(ДанныеСтроки.ОсновноеСредство);
		КонецЕсли;
	КонецЦикла;
	
	ШаблонСообщения = НСтр("ru = 'Необходимо выбрать основное средство из списка в строке %1 списка ""Материалы""';
							|en = 'Select a fixed asset from the list in the %1 line of the ""Materials"" list'");
	Для Каждого ДанныеСтроки Из ПриходуемыеМЦ Цикл
		
		Если ЗначениеЗаполнено(ДанныеСтроки.ОсновноеСредство)
			И СписокОС.Найти(ДанныеСтроки.ОсновноеСредство) = Неопределено Тогда
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ДанныеСтроки.НомерСтроки);
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ПриходуемыеМЦ", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	
	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецЕсли
