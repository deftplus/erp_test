#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ИнициализироватьДокумент();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Для Каждого Строка Из ОС Цикл
		
		Если Не Строка.ОбщаяСобственность Тогда
			Строка.ДоляВПравеОбщейСобственностиЧислитель = 0;
			Строка.ДоляВПравеОбщейСобственностиЗнаменатель = 0;
		КонецЕсли;
		
	КонецЦикла;
	
	УказаныСпособыОтражениеРасходов = (ОтражениеРасходов.Количество() <> 0);
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ПроверитьДатуРегистрации(Отказ);
	КонецЕсли; 
	
	ПараметрыВыбораСтатейИАналитик = Документы.РегистрацияТранспортныхСредств.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ПостановкаНаУчетВНалоговомОргане <> Перечисления.ПостановкаНаУчетВНалоговомОргане.ВДругомНалоговомОргане Тогда
		НепроверяемыеРеквизиты.Добавить("НалоговыйОрган");
		НепроверяемыеРеквизиты.Добавить("КодПоОКТМО");
		НепроверяемыеРеквизиты.Добавить("КодПоОКАТО");
	КонецЕсли;
	
	ДатаРегистрации = ВнеоборотныеАктивыКлиентСервер.МинимальнаяДатаРегистрации(ЭтотОбъект);
	
	Если ДатаРегистрации = '000101010000' Или Год(ДатаРегистрации) >= 2014 Тогда
		НепроверяемыеРеквизиты.Добавить("КодПоОКАТО");
	КонецЕсли;
	
	Если НалоговаяЛьгота = Перечисления.ВидыНалоговыхЛьготПоТранспортномуНалогу.УменьшениеСуммыНалогаНаСумму
		И ДатаРегистрации <> '000101010000' 
		И Год(ДатаРегистрации) >= 2012 Тогда
		ТекстСообщения = НСтр("ru = 'Уменьшение суммы налога на сумму можно использовать только при регистрации транспортных средств до 2012 года';
								|en = 'You can use tax amount reduction for amount only if vehicles are registered before 2012'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "НалоговаяЛьгота",, Отказ); 
	КонецЕсли; 
	
	ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты);
	
	ПараметрыВыбораСтатейИАналитик = Документы.РегистрацияТранспортныхСредств.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.РегистрацияТранспортныхСредств.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(
		НСтр("ru = 'Отмена регистрации земельных участков';
			|en = 'Cancel land lot registration'"));
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокумент()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ПараметрыВыбораСтатейИАналитик = Документы.РегистрацияТранспортныхСредств.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ОбработкаПроверкиЗаполненияОС(Отказ, НепроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляВПравеОбщейСобственностиЧислитель");
	НепроверяемыеРеквизиты.Добавить("ОС.ДоляВПравеОбщейСобственностиЗнаменатель");
	
	ТекстОшибки = НСтр("ru = 'Не заполнена колонка ""%1"" в строке %2 списка ""Основные средства""';
						|en = 'Column ""%1"" in line %2 of the ""Fixed assets"" list is not filled in'");
	
	Для Каждого Строка Из ОС Цикл
		
		Если Строка.ОбщаяСобственность Тогда
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЧислитель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru = 'Числитель доли в праве общей собственности';
												|en = 'Numerator of share in ownership rights'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЧислитель"),
					,
					Отказ);
			КонецЕсли;
			
			Если Не ЗначениеЗаполнено(Строка.ДоляВПравеОбщейСобственностиЗнаменатель) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтрШаблон(ТекстОшибки, НСтр("ru = 'Знаменатель доли в праве общей собственности';
												|en = 'Denominator of share in ownership rights'"), Строка.НомерСтроки),
					ЭтотОбъект,
					ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", Строка.НомерСтроки, "ДоляВПравеОбщейСобственностиЗнаменатель"),
					,
					Отказ);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьДатуРегистрации(Отказ)

	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РегистрацияТранспортныхСредств");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	Блокировка.Заблокировать(); 
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СписокОС.НомерСтроки КАК НомерСтроки,
	|	СписокОС.ОсновноеСредство КАК ОсновноеСредство,
	|	ВЫБОР
	|		КОГДА СписокОС.ДатаРегистрации <> ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА СписокОС.ДатаРегистрации
	|		ИНАЧЕ &Дата
	|	КОНЕЦ КАК ДатаРегистрации
	|ПОМЕСТИТЬ ВТ_Регистрация
	|ИЗ
	|	&СписокОС КАК СписокОС
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДатаРегистрации,
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	РегистрацияТранспортныхСредств.ОсновноеСредство КАК ОсновноеСредство,
	|	РегистрацияТранспортныхСредств.ОсновноеСредство.Представление КАК ОсновноеСредствоПредставление
	|ИЗ
	|	ВТ_Регистрация КАК ВТ_Регистрация
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.РегистрацияТранспортныхСредств КАК РегистрацияТранспортныхСредств
	|		ПО (РегистрацияТранспортныхСредств.Организация = &Организация)
	|			И (РегистрацияТранспортныхСредств.ОсновноеСредство = ВТ_Регистрация.ОсновноеСредство)
	|			И (РегистрацияТранспортныхСредств.Период = ВТ_Регистрация.ДатаРегистрации)
	|ГДЕ
	|	РегистрацияТранспортныхСредств.Организация = &Организация
	|	И РегистрацияТранспортныхСредств.Регистратор <> &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_Регистрация.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Дата", НачалоДня(Дата));
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("СписокОС", ОС.Выгрузить(,"ОсновноеСредство,ДатаРегистрации,НомерСтроки"));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ШаблонСообщения = НСтр("ru = 'Транспортное средство ""%1"" уже зарегистрировано.
                            |Для изменения сведений о регистрации в поле ""Дата регистрации или дата изменений"" необходимо указать дату, с которой действуют изменения.';
                            |en = 'Vehicle ""%1"" is already registered. 
                            |To change the registration information, specify the date from which the changes apply in the field ""Date of registration or date of changes"".'");
	
	Пока Выборка.Следующий() Цикл
		
		ДанныеСтроки = ОС.Найти(Выборка.ОсновноеСредство, "ОсновноеСредство");
		
		Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ДатаРегистрации");
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Выборка.ОсновноеСредствоПредставление);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле,, Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
