////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ.

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализацияУсловийСогласования();
	УстановитьВидимостьПанелей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ВосстановитьНастройкиТаблицыИзВременногоХранилища(ВыбранноеЗначение);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.УсловияСогласования = Новый ХранилищеЗначения(РеквизитФормыВЗначение("ТабличноеПолеПерехода"));
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ЭтапыСогласования.ОбновитьЭтапыПредшественники(ТекущийОбъект.Ссылка, ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТабличноеПолеПерехода")));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьОтчет", , Объект.Владелец);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ.
//
&НаКлиенте
Процедура ТипЭтапаПриИзменении(Элемент)
	
	УстановитьВидимостьПанелей();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуУсловногоПерехода(Команда)
	
	Перем АдресДеревоОтборов, АдресТабличноеПолеПереходов, АдресКэшВидовСубконто, ОбычныйЭтап;
	СохранитьТаблицыВоВременномХранилище(АдресДеревоОтборов, АдресТабличноеПолеПереходов, АдресКэшВидовСубконто, ОбычныйЭтап);
	ОткрытьФорму("Справочник.ЭтапыСогласования.Форма.ФормаНастройкиУсловногоПерехода"
				, Новый Структура("АдресДеревоОтборов, АдресТабличноеПолеПереходов, АдресКэшВидовСубконто, ОбычныйЭтап, СписокВыбораУсловий, СписокВыбораДействий, МаршрутСогласования"
									, АдресДеревоОтборов
									, АдресТабличноеПолеПереходов
									, АдресКэшВидовСубконто
									, ОбычныйЭтап
									, СписокВыбораУсловий
									, СписокВыбораДействий
									, ОБъект.Владелец)
				, ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ.
//

&НаСервере
Процедура ДобавитьЗначениеУсловия(ЗначениеУсловия)
	
	Если (НЕ ЗначениеЗаполнено(ЗначениеУсловия)) ИЛИ ОбщегоНазначенияУХ.ПримитивныйТип(ТипЗнч(ЗначениеУсловия))Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НоваяСтрока=Объект.ЗначенияУсловийОтборов.Добавить();
	НоваяСтрока.ЗначениеУсловия=ЗначениеУсловия;
	
КонецПроцедуры // ДобавитьЗначениеУсловия()

&НаСервере
Процедура ВосстановитьНастройкиТаблицыИзВременногоХранилища(АдресХранилища)
	
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		
		ДеревоПереходов=ПолучитьИзВременногоХранилища(АдресХранилища);
		
		МассивУсловий=ДеревоПереходов.Строки.НайтиСтроки(Новый Структура("ЯвляетсяУсловием",1),Истина);
		
		Объект.ЗначенияУсловийОтборов.Очистить();
		
		Для Каждого СтрУсловие ИЗ МассивУсловий Цикл
			
			Если ЗначениеЗаполнено(СтрУсловие.ЗначениеОтбора) Тогда
				
				Если ТипЗнч(СтрУсловие.ЗначениеОтбора)=Тип("СписокЗначений") Тогда
					
					Для Каждого УсловиеОтбора ИЗ СтрУсловие.ЗначениеОтбора Цикл
						
						ДобавитьЗначениеУсловия(УсловиеОтбора.Значение);
						
					КонецЦикла;
					
				Иначе
					
					 ДобавитьЗначениеУсловия(СтрУсловие.ЗначениеОтбора);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
				
		ЗначениеВРеквизитФормы(ДеревоПереходов, "ТабличноеПолеПерехода");
		УдалитьИзВременногоХранилища(АдресХранилища);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьТаблицыВоВременномХранилище(АдресДеревоОтборов, АдресТабличноеПолеПереходов, АдресКэшВидовСубконто, ОбычныйЭтап)
	
	АдресДеревоОтборов          = ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ДеревоОтборов"), УникальныйИдентификатор);
	АдресТабличноеПолеПереходов = ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("ТабличноеПолеПерехода"), УникальныйИдентификатор);
	АдресКэшВидовСубконто       = ПоместитьВоВременноеХранилище(РеквизитФормыВЗначение("КэшВидовСубконто"), УникальныйИдентификатор);
	ОбычныйЭтап = Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.ЭтапСогласования;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьПанелей()
	
	Если Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.ДочернийМаршрут Тогда
		ТекущаяСтраница = Элементы.ДочернийПроцесс;
	ИначеЕсли Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.ЭтапСогласования Тогда
		ТекущаяСтраница = Элементы.ОбычныйЭтап;
	ИначеЕсли Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.УсловныйПереход Тогда
		ТекущаяСтраница = Элементы.УсловныйПереход;
	ИначеЕсли Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.Автоотклонение Тогда
		ТекущаяСтраница = Элементы.АвтоЭтап_Отклонение;
	ИначеЕсли Объект.ТипЭтапа = Перечисления.ТипыЭтаповСогласования.Автоутверждение Тогда
		ТекущаяСтраница = Элементы.АвтоЭтап_Согласование;
	Иначе
		ТекущаяСтраница = Элементы.ЭтапНеЗадан;
	КонецЕсли;
	
	Элементы.ПанельНастроек.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияУсловийСогласования()
	
	Если НЕ Параметры.Ключ.Пустая() Тогда // Если этап уже сохранялся, то прочитаем настройки перехода из реквизита.
		
		ТекОбъект = РеквизитФормыВЗначение("Объект");
		СохраненныеУсловия = ТекОбъект.УсловияСогласования.Получить();
		Если СохраненныеУсловия <> Неопределено Тогда
			
			ЗначениеВРеквизитФормы(СохраненныеУсловия, "ТабличноеПолеПерехода");
			
		КонецЕсли;
		
	КонецЕсли;
	
	СписокВыбораДействий.Очистить();
	СписокВыбораУсловий.Очистить();
	СписокВыбораДействий.Добавить(Перечисления.ДействияЭтапа.ПерейтиКЭтапу);
	Вн_ДеревоОтборов = РеквизитФормыВЗначение("ДеревоОтборов");
	
		
	Если Объект.Владелец.ТипОбъектаСогласования=Неопределено Тогда	
		ТипОбъектаСогласования = "НастраиваемыйОтчет";
		РеквизитыОбъектаСогласования = Новый ТаблицаЗначений;
		СогласованиеЗаявкиНСИ = Ложь;
		
	Иначе	
		
		ТипОбъектаСогласования = Объект.Владелец.ТипОбъектаСогласования.Наименование;
		РеквизитыОбъектаСогласования = Объект.Владелец.ТипОбъектаСогласования.Реквизиты.Выгрузить();
		СогласованиеЗаявкиНСИ =  Объект.Владелец.СогласованиеЗаявкиНСИ;
		
		
	КонецЕсли;	
	
		
	Если  ТипОбъектаСогласования = "ЗаявкаНаОперацию" Тогда
		
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
	    НоваяСтрока.Элемент = "Ключевые реквизиты";

		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Организация;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Организация;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Организация);

		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Договор;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Договор;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Договор);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Контрагент;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Контрагент;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Контрагент);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.СуммаПлатежа;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.СуммаПлатежа;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.СуммаПлатежа);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.ПриоритетЗаявки;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.ПриоритетЗаявки;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.ПриоритетЗаявки);
		
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
		НоваяСтрока.Элемент = "Лимиты";
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.ОстаткиДС;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.ОстаткиДС;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.ОстаткиДС);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.ПланыДДС;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.ПланыДДС;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.ПланыДДС);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Взаиморасчеты;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Взаиморасчеты;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Взаиморасчеты);
	
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
		НоваяСтрока.Элемент = "Прочие реквизиты";
		Для каждого Рек из РеквизитыОбъектаСогласования Цикл
			
			Если Рек.Имя = "Ссылка" ИЛИ Рек.Имя = "ДоговорКонтрагента" ИЛИ Рек.Имя = "Организация" 
				ИЛИ Рек.Имя = "Контрагент" ИЛИ Рек.Имя = "СуммаДокумента" ИЛИ  Рек.Имя = "Приоритет"  Тогда  //Ссылку на текущий тип не добавляем и не дублируем ключевые реквизиты
				Продолжить;
			КонецЕсли;	
			
			
			
			Если СтрНайти(Рек.ТипДанных,";")>0 Тогда  //Составной тип не добавляем
				Продолжить;
			КонецЕсли;		
			
			СтрокаУсловия = НоваяСтрока.Строки.Добавить();
			СтрокаУсловия.Элемент = Рек.Имя;
			СтрокаУсловия.Условие = Рек.Имя;
			
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Справочник.","СправочникСсылка.");
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Перечисление.","ПеречислениеСсылка.");
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Документ.","ДокументСсылка.");
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"ПланСчетов.","ПланСчетовСсылка.");
			
			СписокВыбораУсловий.Добавить(Рек.Имя,Рек.ТипДанных);
		КонецЦикла;

		
		
		ЗначениеВРеквизитФормы(Вн_ДеревоОтборов,    "ДеревоОтборов");

		
	ИначеЕсли 	ТипОбъектаСогласования = "НастраиваемыйОтчет" Тогда
		
		
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
	    НоваяСтрока.Элемент = "Ключевые реквизиты";

		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Организация;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Организация;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Организация);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.ВидОтчета;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.ВидОтчета;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.ВидОтчета);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.Исполнитель;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.Исполнитель;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.Исполнитель);
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.ПараметрическоеУсловие;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.ПараметрическоеУсловие;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.ПараметрическоеУсловие);
		
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
		НоваяСтрока.Элемент = "Аналитики на уровне отчета";
		
		Запрос = Новый Запрос;
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВидыСубконто.Ссылка КАК Ссылка,
		|	ВидыСубконто.ТипЗначения КАК ТипЗначения,
		|	ВидыСубконто.Представление КАК Представление
		|ИЗ
		|	ПланВидовХарактеристик.ВидыСубконтоКорпоративные КАК ВидыСубконто
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики1 КАК ВидАналитики
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики2
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики3
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики4
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики5
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов
		|		
		|		ОБЪЕДИНИТЬ
		|		
		|		ВЫБРАТЬ
		|			ВидыОтчетов.ВидАналитики6
		|		ИЗ
		|			Справочник.ВидыОтчетов КАК ВидыОтчетов) КАК ВидыАналитик
		|		ПО (ВидыАналитик.ВидАналитики = ВидыСубконто.Ссылка)";

		Вн_КэшВидовСубконто = Запрос.Выполнить().Выгрузить();
		Для Каждого Строка Из Вн_КэшВидовСубконто Цикл
			СписокВыбораУсловий.Добавить(Строка.Ссылка, "Аналитика отчета: " + Строка.Представление);
			СтрокаУсловия = НоваяСтрока.Строки.Добавить();
			СтрокаУсловия.Элемент = Строка.Представление;
			СтрокаУсловия.Условие = Строка.Ссылка;
		КонецЦикла;
		
		ЗначениеВРеквизитФормы(Вн_ДеревоОтборов,    "ДеревоОтборов");
		ЗначениеВРеквизитФормы(Вн_КэшВидовСубконто, "КэшВидовСубконто");

			
	ИначеЕсли СогласованиеЗаявкиНСИ Тогда//Для заявки на изменение НСИ - реквизиты изменяемого объекта...	
		
		//Вид заявки из документа
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
	    НоваяСтрока.Элемент = "Ключевые реквизиты";
		
		СтрокаУсловия = НоваяСтрока.Строки.Добавить();
		СтрокаУсловия.Элемент = Перечисления.УсловияЭтапа.НСИВидЗаявки;
		СтрокаУсловия.Условие = Перечисления.УсловияЭтапа.НСИВидЗаявки;
		СписокВыбораУсловий.Добавить(Перечисления.УсловияЭтапа.НСИВидЗаявки);

		//Остальное из реквизитов изменяемого объекта
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
	    НоваяСтрока.Элемент = "Реквизиты контролируемого объекта";
		
		Для каждого Рек из РеквизитыОбъектаСогласования Цикл
						
			Если Рек.Имя = "Ссылка" Тогда  //Ссылку на текущий тип не добавляем
				Продолжить;
			КонецЕсли;	
			
			Если СтрНайти(Рек.Имя,";")>0 Тогда  //Составной тип не добавляем
				Продолжить;
			КонецЕсли;		
			
			СтрокаУсловия = НоваяСтрока.Строки.Добавить();
			СтрокаУсловия.Элемент = Рек.Имя;
			СтрокаУсловия.Условие = Рек.Имя;

			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Справочник.","СправочникСсылка.");
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Перечисление.","ПеречислениеСсылка.");
            Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Документ.","ДокументСсылка.");
            Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"ПланСчетов.","ПланСчетовСсылка.");

			СписокВыбораУсловий.Добавить(Рек.Имя,Рек.ТипДанных);
		КонецЦикла;
		
		ЗначениеВРеквизитФормы(Вн_ДеревоОтборов,    "ДеревоОтборов");	
		
	Иначе	//реквизиты текущего объекта метаданных
		
		
		НоваяСтрока = Вн_ДеревоОтборов.Строки.Добавить();
	    НоваяСтрока.Элемент = "Ключевые реквизиты";
		
		Для каждого Рек из РеквизитыОбъектаСогласования Цикл
						
			Если Рек.Имя = "Ссылка" Тогда  //Ссылку на текущий тип не добавляем
				Продолжить;
			КонецЕсли;	
			
			Если СтрНайти(Рек.ТипДанных,";")>0 Тогда  //Составной тип не добавляем
				Продолжить;
			КонецЕсли;		
			
			СтрокаУсловия = НоваяСтрока.Строки.Добавить();
			СтрокаУсловия.Элемент = Рек.Имя;
			СтрокаУсловия.Условие = Рек.Имя;

			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Справочник.","СправочникСсылка.");
			Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Перечисление.","ПеречислениеСсылка.");
            Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"Документ.","ДокументСсылка.");
            Рек.ТипДанных = СтрЗаменить(Рек.ТипДанных,"ПланСчетов.","ПланСчетовСсылка.");

			СписокВыбораУсловий.Добавить(Рек.Имя,Рек.ТипДанных);
		КонецЦикла;
		
		ЗначениеВРеквизитФормы(Вн_ДеревоОтборов,    "ДеревоОтборов");

	КонецЕсли;
	
		
КонецПроцедуры










