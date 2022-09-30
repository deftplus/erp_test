
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СКД = Обработки.ЗапасыДляРеклассаВНА.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	АдресСКД = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	Компоновщик.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
	Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	ПериодСКД = Новый СтандартныйПериод(Параметры.ПериодОтчета.ДатаНачала, КонецДня(Параметры.ПериодОтчета.ДатаОкончания));
	
	ИменаУП = МСФОВызовСервераУХ.ПутиРеквизитовУП("ПланСчетовМСФО, ПорогСущественностиВНА");
	ЗначенияУП = МСФОВызовСервераУХ.ЗначенияУП(ИменаУП, Параметры.Организация, ПериодСКД.ДатаОкончания, Параметры.Сценарий);
	РеквизитыУП = МСФОВызовСервераУХ.ЗначенияПоОрганизацииУП(ЗначенияУП);
	
	ПараметрыСКД = Компоновщик.Настройки.ПараметрыДанных;
	
	ПараметрыСКД.УстановитьЗначениеПараметра("Период", 					ПериодСКД);
	ПараметрыСКД.УстановитьЗначениеПараметра("НачалоПериода", 			ПериодСКД.ДатаНачала);
	ПараметрыСКД.УстановитьЗначениеПараметра("КонецПериода", 			ПериодСКД.ДатаОкончания);
	ПараметрыСКД.УстановитьЗначениеПараметра("Сценарий", 				Параметры.Сценарий);
	ПараметрыСКД.УстановитьЗначениеПараметра("ПланСчетовМСФО",			РеквизитыУП.ПланСчетовМСФО);
	ПараметрыСКД.УстановитьЗначениеПараметра("ПорогСущественностиВНА",	РеквизитыУП.ПорогСущественностиВНА);
	
	//Компоновщик.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Организация", Параметры.Организация);
	ОбщегоНазначенияКлиентСервер.ИзменитьЭлементыОтбора(Компоновщик.Настройки.Отбор, "Организация", , Параметры.Организация);
	
	СкомпоноватьРезультат();
	ТекстЗаголовка = НСтр("ru = 'Запасы для рекласса ВНА: организация: <%1>, порог существенности: <%2>, период <%3>'");
	ЭтаФорма.Заголовок = СтрШаблон(ТекстЗаголовка, Параметры.Организация, РеквизитыУП.ПорогСущественностиВНА, Параметры.ПериодОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПереключитьТребующиеРеклассфикации();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПараметрЗакрытия <> Неопределено Тогда
		Возврат; 
	КонецЕсли;
	
	ОтборЗапрета = Новый Структура("ВариантУчета", НСтр("ru = 'Трансляция (требуется реклассификация)'"));
	
	СтрокиОтбора = ЗапасыДляРекласса.НайтиСтроки(ОтборЗапрета);
	
	Если СтрокиОтбора.Количество() <> 0 Тогда
		
		Отказ = Истина;
		ПараметрЗакрытия = Истина;
		
	    Результат = Новый Массив;		
		Для каждого СтрокаОтбора Из СтрокиОтбора Цикл
			Результат.Добавить(СтрокаОтбора.Запас);		
		КонецЦикла;
				
		Закрыть(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если (ИсточникВыбора.ВладелецФормы = ЭтаФорма) И (ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ГруппыВНАМСФО")) Тогда
		УстановитьПараметрыУчетаВНА(СписокВНА.ВыгрузитьЗначения(), ВыбранноеЗначение);		
		СписокВНА.Очистить();
	КонецЕсли;	
		
	СкомпоноватьРезультат();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура Обновить(Команда)
	СкомпоноватьРезультат();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПараметрыУчетаВНА1(Команда)
	
	ЗаполнитьСписокВНА();
	ОткрытьФорму("Справочник.ГруппыВНАМСФО.ФормаВыбора", , ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНеРеклассифицировать(Команда)
	
	ЗаполнитьСписокВНА();
	УстановитьПараметрыУчетаВНА(СписокВНА.ВыгрузитьЗначения(), ПредопределенноеЗначение("Справочник.ГруппыВНАМСФО.ПустаяСсылка"));
	СписокВНА.Очистить();
	СкомпоноватьРезультат();
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоТребующиеРеклассификации(Команда)
	ПереключитьТребующиеРеклассфикации();	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СкомпоноватьРезультат()
	
	ШаблонТаб = Новый ТаблицаЗначений;
	ЗапасыДляРекласса.Загрузить(ТиповыеОтчетыУХ.ПолучитьКоллекциюРезультат(ПолучитьИзВременногоХранилища(АдресСКД), Компоновщик.ПолучитьНастройки(), , , Истина, , , ШаблонТаб));

КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыУчетаВНА(ВНА, ПараметрыУчетаВНА = Неопределено)

	Отказ = Ложь;
	НачатьТранзакцию();
	Для каждого ТекущийВНА Из ВНА Цикл	
		Справочники.ГруппыВНАМСФО.СохранитьПараметрыПоУмолчаниюВНА(ТекущийВНА, ПараметрыУчетаВНА, Истина, Отказ);	
	КонецЦикла;
	
	Если Отказ Тогда
		ОтменитьТранзакцию();		
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВНА()

	СписокВНА.Очистить();
	
	Для каждого ТекИдентификатор Из Элементы.ЗапасыДляРекласса.ВыделенныеСтроки Цикл	
		СтрокаМПЗ = ЗапасыДляРекласса.НайтиПоИдентификатору(ТекИдентификатор);
		СписокВНА.Добавить(СтрокаМПЗ.Запас);	
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПереключитьТребующиеРеклассфикации()
	
	Элементы.ФормаТолькоТребующиеРеклассификации.Пометка = Не Элементы.ФормаТолькоТребующиеРеклассификации.Пометка;
	Если Элементы.ФормаТолькоТребующиеРеклассификации.Пометка Тогда
		Элементы.ЗапасыДляРекласса.ОтборСтрок = Новый ФиксированнаяСтруктура("ВариантУчета", НСтр("ru = 'Трансляция (требуется реклассификация)'"));
	Иначе	
		Элементы.ЗапасыДляРекласса.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
