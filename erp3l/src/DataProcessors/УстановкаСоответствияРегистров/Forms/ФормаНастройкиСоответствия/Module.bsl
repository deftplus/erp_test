
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ШаблонТрансляции=Параметры.ШаблонТрансляции;
	ДанныеШаблона=Обработки.УстановкаСоответствияСчетов.ПолучитьДанныеШаблона(ШаблонТрансляции);

	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеШаблона);
	КоррОбъектУчетаИсточник=Параметры.КоррОбъектУчетаИсточник;
	НастройкаСоответствия=Параметры.НастройкаСоответствия;
				
	ОбъектУчетаИсточник=Параметры.ОбъектУчетаИсточник;
					
	Если ЗначениеЗаполнено(Параметры.СчетПриемник) Тогда
		
		Если ТипЗнч(Параметры.СчетПриемник)=Тип("СправочникСсылка.СчетаБД") Тогда
			
			СчетПриемник=Параметры.СчетПриемник;
			
		Иначе
			
			СчетПриемник=Справочники.СчетаБД.НайтиПоКоду(Параметры.СчетПриемник.Код,,,ПланСчетовПриемник);
			
		КонецЕсли;
		
	КонецЕсли;

	Если ЗначениеЗаполнено(ОбъектУчетаИсточник) И ЗначениеЗаполнено(СчетПриемник) Тогда
		
		ОпределитьНастройкуСоответствия();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНастройкуСоответствия()
	
	Запрос=Новый Запрос;
	
	Запрос.Текст="ВЫБРАТЬ
	|	НастройкиПравилТрансляции.СоответствиеСчетов КАК НастройкаСоответствия,
	|	НастройкиПравилТрансляции.ИспользованиеДт КАК ИспользованиеДт,
	|	НастройкиПравилТрансляции.ИспользованиеКт КАК ИспользованиеКт
	|ИЗ
	|	РегистрСведений.НастройкиПравилТрансляции КАК НастройкиПравилТрансляции
	|ГДЕ
	|	НастройкиПравилТрансляции.ШаблонТрансляции = &ШаблонТрансляции
	|	И НастройкиПравилТрансляции.СоответствиеСчетов.ОбъектУчетаИсточник = &ОбъектУчетаИсточник
	|	И НастройкиПравилТрансляции.СоответствиеСчетов.СчетПриемник = &СчетПриемник";
	
	Запрос.УстановитьПараметр("ОбъектУчетаИсточник",ОбъектУчетаИсточник);
	Запрос.УстановитьПараметр("СчетПриемник",СчетПриемник);
	
	Запрос.УстановитьПараметр("ШаблонТрансляции",ШаблонТрансляции);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,Результат);
		НастройкаСоответствияСтар=НастройкаСоответствия;
		
	КонецЕсли;
	
	ИсточникСсылка="";
	
	Если ЗначениеЗаполнено(НастройкаСоответствия) Тогда
		
		Запрос.Текст="ВЫБРАТЬ
		|	ИсточникиДанныхДляРасчетов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
		|ГДЕ
		|	ИсточникиДанныхДляРасчетов.ПотребительРасчета = &ПотребительРасчета
		|	И ИсточникиДанныхДляРасчетов.НазначениеРасчетов.Владелец = &ШаблонТрансляции
		|	И ИсточникиДанныхДляРасчетов.НазначениеРасчетов.НаправлениеТрансляции = ЗНАЧЕНИЕ(Перечисление.НаправленияТрансляцииДанных.ФинансовыеРегистрыВРегистрБухгалтерии)
		|	И НЕ ИсточникиДанныхДляРасчетов.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("ПотребительРасчета",НастройкаСоответствия);
		
		Результат=Запрос.Выполнить().Выбрать();
		
		Если Результат.Следующий() Тогда
			
			ИсточникСсылка=Результат.Ссылка;
			
					
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьПодробнуюИнформацию()	
	
КонецПроцедуры // ЗаполнитьПараметрыСоответствия() 
	
&НаСервере
Процедура ЗаполнитьПодробнуюИнформацию()
	
	Если НЕ ЗначениеЗаполнено(ИсточникСсылка) Тогда
		
		ОтборПодробно="";
		СоответствиеПодробно="";
		
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,ПолучитьПодробнуюИнформацию(ИсточникСсылка));
	
КонецПроцедуры // ЗаполнитьПодробнуюИнформацию()

&НаСервере
Функция ПолучитьПодробнуюИнформацию(ИсточникСсылка)
	
	Возврат Обработки.КорректировкиЗначенийПоказателей.ПолучитьПодробнуюИнформациюРегистры(ИсточникСсылка);	
	
КонецФункции // ПолучитьПодробнуюИнформацию()

&НаКлиенте
Процедура ОткрытьНастройки(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	
	Если НЕ ПроверитьПараметрыНастройкиСоответствия() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Модифицированность Тогда
		
		ЗаписатьТекущиеНастройкиТрансляции();
		
	КонецЕсли;
		
	Оповестить("ИзмененаНастройкаСоответствияСчетов",ШаблонТрансляции);
	Закрыть();
		
КонецПроцедуры

&НаКлиенте
Функция ПроверитьПараметрыНастройкиСоответствия()
	
	Если НЕ ЗначениеЗаполнено(ОбъектУчетаИсточник) Тогда
		
		Сообщить(НСтр("ru = 'Не указан объект учета - источник.'"), СтатусСообщения.Внимание);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СчетПриемник) Тогда
		
		Сообщить(НСтр("ru = 'Не указан счет - приемник.'"), СтатусСообщения.Внимание);
		Возврат Ложь;
		
	КонецЕсли;
	
	Если НЕ (ЗначениеЗаполнено(НастройкаСоответствия) ИЛИ СоздатьНовоеСоответствие()) Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции // ПроверитьПараметрыНастройкиСоответствия() 

&НаКлиенте
Процедура ИзменитьДополнительныеНастройки(Команда)
	
	Если НЕ ПроверитьПараметрыНастройкиСоответствия() Тогда
		
		Возврат;
		
	КонецЕсли;
		
	Если Модифицированность Тогда
		
		ЗаписатьТекущиеНастройкиТрансляции();
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИсточникСсылка) Тогда
		
		ОткрытьФорму("Справочник.ИсточникиДанныхДляРасчетов.ФормаОбъекта",Новый Структура("Ключ",ИсточникСсылка));
		
	Иначе
		
		ЗаписатьТекущиеНастройкиТрансляции();
		ИсточникСсылка=ПолучитьИсточникДляСоответствия(НастройкаСоответствия);
		
		Если ЗначениеЗаполнено(ИсточникСсылка) Тогда
			
			ОткрытьФорму("Справочник.ИсточникиДанныхДляРасчетов.ФормаОбъекта",Новый Структура("Ключ,ДляВсехИсточниковПоСчету",ИсточникСсылка,Истина));
			
		КонецЕсли;
		
	КонецЕсли;
	
	
	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьИсточникДляСоответствия(СоответствиеСчетов)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИсточникиДанныхДляРасчетов.Ссылка
	|ИЗ
	|	Справочник.ИсточникиДанныхДляРасчетов КАК ИсточникиДанныхДляРасчетов
	|ГДЕ
	|	ИсточникиДанныхДляРасчетов.НазначениеРасчетов.НаправлениеТрансляции = &НаправлениеТрансляции
	|	И ИсточникиДанныхДляРасчетов.ПотребительРасчета = &ПотребительРасчета";
	
	Запрос.УстановитьПараметр("НаправлениеТрансляции",Перечисления.НаправленияТрансляцииДанных.РегистрБухгалтерииВРегистрБухгалтерии);
	Запрос.УстановитьПараметр("ПотребительРасчета",СоответствиеСчетов);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		Возврат Результат.Ссылка;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
			
КонецФункции // ПолучитьИсточникПоСторонеПроводки()



&НаСервере
Функция ПолучитьНастройкиТрансляции()
		
	СтруктураРесурсов=Новый Структура;
	СтруктураРесурсов.Вставить("ИспользованиеДт",				ИспользованиеДт);
	СтруктураРесурсов.Вставить("ИспользованиеКт",				ИспользованиеКт);
	СтруктураРесурсов.Вставить("ТранслироватьСальдо",			Ложь);
	СтруктураРесурсов.Вставить("ТранслироватьОбороты",			Ложь);
	СтруктураРесурсов.Вставить("КоррОбъектУчетаИсточник",		КоррОбъектУчетаИсточник);
	СтруктураРесурсов.Вставить("Ссылка",						НастройкаСоответствия);
	СтруктураРесурсов.Вставить("НаправлениеТрансляции",         Перечисления.НаправленияТрансляцииДанных.ФинансовыеРегистрыВРегистрБухгалтерии);
	СтруктураРесурсов.Вставить("СокращеннаяОСВ",         		Ложь);
	
	Возврат СтруктураРесурсов;
	
КонецФункции // ПолучитьСтруктуруРесурсов()

&НаСервере
Процедура ЗаписатьТекущиеНастройкиТрансляции()
	
	Если ЗначениеЗаполнено(НастройкаСоответствияСтар) Тогда
		
		УправлениеОтчетамиУХ.ЗаписатьНастройкиПравилТрансляции(ШаблонТрансляции,НастройкаСоответствияСтар);
		
	КонецЕсли;
		
	СтруктураПараметров=ПолучитьНастройкиТрансляции();			
	УправлениеОтчетамиУХ.ЗаписатьНастройкиПравилТрансляции(ШаблонТрансляции,НастройкаСоответствия,СтруктураПараметров,Неопределено);
	
	Модифицированность=Ложь;
	
КонецПроцедуры // ЗаписатьТекущиеНастройкиСоответствия()


&НаКлиенте
Функция СоздатьНовоеСоответствие()
	
	СтруктураСоответствие=Новый Структура;
	СтруктураСоответствие.Вставить("ОбъектУчетаИсточник",			ОбъектУчетаИсточник);
	СтруктураСоответствие.Вставить("ОбъектНастройки",				);
	СтруктураСоответствие.Вставить("СчетПриемник",					СчетПриемник);
	СтруктураСоответствие.Вставить("КоррОбъектУчетаИсточник",		КоррОбъектУчетаИсточник);
	СтруктураСоответствие.Вставить("КоррОбъектНастройки",			);

	СтруктураСоответствие.Вставить("ИдентификаторСоответствия",		ТекущийИдентификатор+1);
	
	СтруктураСоответствие.Вставить("Владелец",						ШаблонТрансляции);
	СтруктураСоответствие.Вставить("Ссылка",						);
	
	СоздатьСоответствие(СтруктураСоответствие);
	
	Если ЗначениеЗаполнено(СтруктураСоответствие.Ссылка) Тогда
		
		НастройкаСоответствия=СтруктураСоответствие.Ссылка;
		ТекущийИдентификатор=ТекущийИдентификатор+1;
		Возврат Истина;
		
	Иначе
		
		Сообщить(НСтр("ru = 'Не создано соответствие.'"), СтатусСообщения.Внимание);	
		Возврат Ложь;
		
	КонецЕсли;
		
КонецФункции // СоздатьНовоеСоответствие() 

&НаСервереБезКонтекста
Процедура СоздатьСоответствие(СтруктураДанных)
	
	Справочники.СоответствияСчетовДляТрансляции.ИзменитьОбъектПоПараметрамРегистр(СтруктураДанных);
		
КонецПроцедуры // СоздатьСоответствие()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ЗаписаноПравилоНастройкиТрансляции" Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ПолучитьПодробнуюИнформацию(ИсточникСсылка));
		
	ИначеЕсли ИмяСобытия="ВыбранОбъектУчета" Тогда
		
		КоррОбъектУчетаИсточник=Параметр.ОбъектУчетаИсточник;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПриемникПриИзменении(Элемент)
	
	СброситьНастройкуСоответствия();
	
КонецПроцедуры

&НаКлиенте
Процедура КоррОбъектУчетаИсточникПриИзменении(Элемент)
	
	СброситьНастройкуСоответствия();
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкуСоответствия()
	
	НастройкаСоответствия	= "";
	ИсточникСсылка			= "";
	ОтборПодробно			= "";
	СоответствиеПодробно	= "";
		
	ИспользованиеДт=Истина;
	ИспользованиеКт=Истина;
	
КонецПроцедуры // СброситьНастройкуСоответствия()

&НаКлиенте
Процедура КоррСчетИсточникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка=Ложь;
	ОткрытьФорму("Обработка.УстановкаСоответствияРегистров.Форма.ФормаВыбораОбъектаУчета",,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
