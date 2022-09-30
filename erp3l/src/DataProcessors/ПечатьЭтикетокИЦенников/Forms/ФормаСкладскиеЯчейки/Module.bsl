
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Объект.КоличествоЭкземпляров = 1;
	Объект.ШаблонЭтикетки        = Справочники.ШаблоныЭтикетокИЦенников.ШаблонПоУмолчанию(Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек);
	Объект.НазначениеШаблона = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек;
		
	Если ЭтоАдресВременногоХранилища(Параметры.АдресВХранилище) Тогда
		СтуктураПараметров = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище);
		
		Склад     = СтуктураПараметров.Склад;
		Помещение = СтуктураПараметров.Помещение;
		
		Объект.СкладскиеЯчейки.Загрузить(СтуктураПараметров.Ячейки);
		
		Для Каждого СтрТабл Из Объект.СкладскиеЯчейки Цикл
			СтрТабл.Штрихкод = ЧисловойКодПоСсылке(СтрТабл.Ячейка); 
		КонецЦикла;
		
	КонецЕсли;
	
	Склад = ЗначениеНастроекПовтИсп.ПолучитьСкладПоУмолчанию(Склад);
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад",Склад));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СкладПриИзменении(Элемент)
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Склад",Склад));
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСкладскиеЯчейки

&НаКлиенте
Процедура СкладскиеЯчейкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Ячейка) Тогда
		ТекущиеДанные.Штрихкод = ЧисловойКодПоСсылке(ТекущиеДанные.Ячейка);
	Иначе
		ТекущиеДанные.Штрихкод = "";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.СкладскиеЯчейки.ПустаяСсылка"));
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЭтикетокИЦенников",
		"ЭтикеткаСкладскиеЯчейки",
		ПараметрКоманды,
		ЭтаФорма,
		ПолучитьПараметрыДляСкладскихЯчеек());

КонецПроцедуры

#Область Прочее

&НаСервере
Функция ПолучитьПараметрыДляСкладскихЯчеек()
	
	СкладскиеЯчейки = Объект.СкладскиеЯчейки.Выгрузить();
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("СкладскиеЯчейки",        ПоместитьВоВременноеХранилище(СкладскиеЯчейки, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки",         Объект.ШаблонЭтикетки);
	ПараметрыПечати.Вставить("КоличествоЭкземпляров",  Объект.КоличествоЭкземпляров);
	ПараметрыПечати.Вставить("СтруктураМакетаШаблона", Неопределено);
	
	Возврат ПараметрыПечати;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЧисловойКодПоСсылке(Ячейка)
	Возврат ШтрихкодированиеПечатныхФорм.ЧисловойКодПоСсылке(Ячейка);
КонецФункции

#КонецОбласти

#КонецОбласти
