
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СписокЗначений", Список);
	Параметры.Свойство("Адрес", Адрес);
	
	Если ЭтоАдресВременногоХранилища(Адрес) Тогда
		ИспользуемыеПодсистемы = ПолучитьИзВременногоХранилища(Адрес);
		
		СформироватьГруппуКнопокСоздать();
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокФормы") Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = Параметры.ЗаголовокФормы; 
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокКнопкаОК") Тогда
		Элементы.ФормаОК.Заголовок = Параметры.ЗаголовокКнопкаОК;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗаголовокКнопкаОтмена") Тогда
		Элементы.ФормаОтмена.Заголовок = Параметры.ЗаголовокКнопкаОтмена;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыборе(Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьГруппуКнопокСоздать()
	
	Для каждого ПодсистемаВерхнегоУровня Из ИспользуемыеПодсистемы Цикл
		ИмяПодсистемы = ПодсистемаВерхнегоУровня.Значение[0];
		ВерхнийУровень = Метаданные.НайтиПоПолномуИмени(ИмяПодсистемы);
		
		Если Команды.Найти(ВерхнийУровень.Имя) = Неопределено Тогда
			НоваяКомандаФормы = Команды.Добавить(ВерхнийУровень.Имя);
			НоваяКомандаФормы.Заголовок = ВерхнийУровень.Синоним;
			НоваяКомандаФормы.Действие = "Подключаемый_Отметить";
			
			КомандаНаФорме = Элементы.Вставить("Форма" + ВерхнийУровень.Имя, Тип("КнопкаФормы"), Элементы.ФормаГруппаОтбор,);
			КомандаНаФорме.ИмяКоманды = ВерхнийУровень.Имя;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Отметить(Команда) 
	
	ОтметитьНаСервере(Команда.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьНаСервере(КомандаИмя)
	
	ИменаПодчиненныхПодсистем = ИспользуемыеПодсистемы[КомандаИмя];
	
	Для каждого ТекСтрока Из Список Цикл
		
		Для каждого ИмяПодсистемы Из ИменаПодчиненныхПодсистем Цикл
			ПодчиненнаяПодсистема = Метаданные.НайтиПоПолномуИмени(ИмяПодсистемы);
			
			Если ПодчиненнаяПодсистема.Состав.Содержит(Метаданные.НайтиПоТипу(ТекСтрока.Значение)) Тогда
				ТекСтрока.Пометка = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
