
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(Параметры.СтрокаТипов) Тогда
		
		МассивТипов=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(Параметры.СтрокаТипов,";");
		
	Иначе
		
		МассивТипов=Новый Массив;
		
	КонецЕсли;
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="Число";
	НоваяСтрока.ТаблицаАналитики=НоваяСтрока.ИмяТипа;
	НоваяСтрока.Использовать=(НЕ МассивТипов.Найти(НоваяСтрока.ТаблицаАналитики)=Неопределено);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="Строка";
	НоваяСтрока.ТаблицаАналитики=НоваяСтрока.ИмяТипа;
	НоваяСтрока.Использовать=(НЕ МассивТипов.Найти(НоваяСтрока.ТаблицаАналитики)=Неопределено);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="Дата";
	НоваяСтрока.ТаблицаАналитики=НоваяСтрока.ИмяТипа;
	НоваяСтрока.Использовать=(НЕ МассивТипов.Найти(НоваяСтрока.ТаблицаАналитики)=Неопределено);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="Булево";
	НоваяСтрока.ТаблицаАналитики=НоваяСтрока.ИмяТипа;
	НоваяСтрока.Использовать=(НЕ МассивТипов.Найти(НоваяСтрока.ТаблицаАналитики)=Неопределено);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="СправочникСсылка";	
	ЗаполнитьПодчиненныеСтрокиТипов(НоваяСтрока,"СправочникиБД","Справочник",МассивТипов);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="ДокументСсылка";	
	ЗаполнитьПодчиненныеСтрокиТипов(НоваяСтрока,"ДокументыБД","Документ",МассивТипов);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="ПеречислениеСсылка";	
	ЗаполнитьПодчиненныеСтрокиТипов(НоваяСтрока,"ПеречисленияБД","Перечисление",МассивТипов);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="ПланВидовХарактеристикСсылка";	
	ЗаполнитьПодчиненныеСтрокиТипов(НоваяСтрока,"ПланыВидовХарактеристикБД","ПланВидовХарактеристик",МассивТипов);
	
	НоваяСтрока=ДеревоТиповЗначений.ПолучитьЭлементы().Добавить();
	НоваяСтрока.ИмяТипа="ПланСчетовСсылка";	
	ЗаполнитьПодчиненныеСтрокиТипов(НоваяСтрока,"ПланыСчетовБД","ПланСчетов",МассивТипов);
	
	Если НЕ Параметры.ПараметрФормулы Тогда
		
		Элементы.СоставнойТипДанных.Видимость=Ложь;
		
	Иначе
		
		СоставнойТипДанных=(МассивТипов.Количество()>1);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодчиненныеСтрокиТипов(СтрокаТипа,ИмяОбъекта,ТипОбъектаМетаданных,МассивТипов)
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ОбъектыБД.Наименование
	|ИЗ
	|	Справочник."+ИмяОбъекта+" КАК ОбъектыБД
	|ГДЕ
	|	ОбъектыБД.Владелец = ЗНАЧЕНИЕ(Справочник.ТипыБазДанных.ТекущаяИБ)
	|Упорядочить ПО ОбъектыБД.Наименование";
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		НоваяСтрока=СтрокаТипа.ПолучитьЭлементы().Добавить();
		НоваяСтрока.ИмяТипа=Результат.Наименование;
		НоваяСтрока.ТаблицаАналитики=ТипОбъектаМетаданных+"."+Результат.Наименование;
		НоваяСтрока.Использовать=(НЕ МассивТипов.Найти(НоваяСтрока.ТаблицаАналитики)=Неопределено);
		
		Если НоваяСтрока.Использовать И СписокКРазвороту.НайтиПоЗначению(СтрокаТипа.ПолучитьИдентификатор())=Неопределено Тогда 
			
			СписокКРазвороту.Добавить(СтрокаТипа.ПолучитьИдентификатор());
			
		КонецЕсли;		
		
	КонецЦикла;
		
КонецПроцедуры // ЗаполнитьПодчиненныеСтрокиТипов() 

&НаКлиенте
Процедура ДеревоТиповЗначенийИспользоватьПриИзменении(Элемент)
	
	СтрокаТипов=Элементы.ДеревоТиповЗначений.ТекущиеДанные;
	
	Если СтрокаТипов.ПолучитьЭлементы().Количество()>0 И НЕ СоставнойТипДанных Тогда
		
		СтрокаТипов.Использовать=Ложь;
		Возврат;
		
	КонецЕсли;
		
	Если СтрокаТипов.Использовать Тогда
		
		Если Не СоставнойТипДанных Тогда
			
			ОбработатьИзменениеИспользованияТипа(?(СтрокаТипов.ПолучитьРодителя()=Неопределено,"",СтрокаТипов.ПолучитьРодителя().ИмяТипа),СтрокаТипов.ИмяТипа);
			
		ИначеЕсли СтрокаТипов.ПолучитьЭлементы().Количество()>0 Тогда
			
			Для Каждого Строка ИЗ СтрокаТипов.ПолучитьЭлементы() Цикл
				
				Строка.Использовать=Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
	ИначеЕсли СоставнойТипДанных И СтрокаТипов.ПолучитьЭлементы().Количество()>0 Тогда
		
		Для Каждого Строка ИЗ СтрокаТипов.ПолучитьЭлементы() Цикл
			
			Строка.Использовать=Ложь;
			
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеИспользованияТипа(ТекущийРодитель,ИмяТипа)
	
	Для Каждого Строка ИЗ ДеревоТиповЗначений.ПолучитьЭлементы() Цикл
		
		Если НЕ Строка.ИмяТипа=ИмяТипа Тогда
			
			Строка.Использовать=Ложь;
			
		КонецЕсли;
		
		Для Каждого ПодчиненнаяСтрока ИЗ Строка.ПолучитьЭлементы() Цикл
			
			Если НЕ ТекущийРодитель=Строка.ИмяТипа Тогда
				
				ПодчиненнаяСтрока.Использовать=Ложь;
				
			ИначеЕсли НЕ ПодчиненнаяСтрока.ИмяТипа=ИмяТипа Тогда
				
				ПодчиненнаяСтрока.Использовать=Ложь;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СоставнойТипДанныхПриИзменении(Элемент)
	
	Если НЕ СоставнойТипДанных Тогда
		
		НайденЭлемент=Ложь;
		
		Для Каждого Строка ИЗ ДеревоТиповЗначений.ПолучитьЭлементы() Цикл
			
			Если Строка.Использовать Тогда
				
				Если Строка.ПолучитьЭлементы().Количество()>0 Тогда
					
					Строка.Использовать=Ложь;
					
				ИначеЕсли НайденЭлемент Тогда
					
					Строка.Использовать=Ложь;
					
				Иначе
					
					НайденЭлемент=Истина;
					
				КонецЕсли;
				
			КонецЕсли;
			
			Для Каждого ПодчиненнаяСтрока ИЗ Строка.ПолучитьЭлементы() Цикл
				
				Если ПодчиненнаяСтрока.Использовать Тогда
					
					Если НайденЭлемент Тогда
						
						ПодчиненнаяСтрока.Использовать=Ложь;
						
					Иначе
						
						НайденЭлемент=Истина;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Оповестить("ИзмененТипЗначения"+?(Параметры.ПараметрФормулы,"ПараметраФормулы","ПоляФормулы"),СформироватьСтрокуТипов());
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция СформироватьСтрокуТипов()
	
	СтрокаТипов="";
	
	РабочееДерево=РеквизитФормыВЗначение("ДеревоТиповЗначений");
	
	МассивИспользовать=РабочееДерево.Строки.НайтиСтроки(Новый Структура("Использовать",Истина),Истина);
	
	Для Каждого Строка ИЗ МассивИспользовать Цикл
		
		СтрокаТипов=СтрокаТипов+";"+Строка.ТаблицаАналитики;
		
	КонецЦикла;
	
	Возврат Сред(СтрокаТипов,2);
		
КонецФункции // СформироватьСтрокуТипов()

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Для Каждого Элемент ИЗ СписокКРазвороту Цикл
		
		Элементы.ДеревоТиповЗначений.Развернуть(Элемент.Значение);
		
	КонецЦикла;
	
КонецПроцедуры
