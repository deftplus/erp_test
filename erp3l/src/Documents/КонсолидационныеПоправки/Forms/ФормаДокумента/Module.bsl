
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ТекущаяСтрока = Новый Структура("Организация,ОтношениеКГруппеНаКонец,КлючСтроки");		
	КонецЕсли;
	
	ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РасчетЭффективныхДолейВладения" Тогда
	
		Если ЭтоАдресВременногоХранилища(Параметр) Тогда			
			ЗаполнитьИзРасчетаПолныхДолей(Параметр);			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПодготовитьФормуНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийРеквизитовОбъекта
 
&НаКлиенте
Процедура ОрганизацияДляЭлиминацииПриИзменении(Элемент)
	ЗаполнитьКонсолидирующуюОрганизацию();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	ЗаполнитьНаСервере();
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЧАПоДаннымУчета(Команда)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЧАНаСервере(ТекущаяСтрока.КлючСтроки, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЧАНаДатуДвиженияПоКоэффициенту(Команда)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЧАНаСервере(ТекущаяСтрока.КлючСтроки, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	Элементы.ИзменениеДолейПоказатьПодробно.Пометка = Не Элементы.ИзменениеДолейПоказатьПодробно.Пометка;
	
	Если Элементы.ИзменениеДолейПоказатьПодробно.Пометка Тогда
		
		Элементы.Страница_Инвестиции.Видимость = Истина;		
				
	Иначе	
		
		Элементы.Страница_Инвестиции.Видимость = Ложь;
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭкземплярыОрганизации(Команда)
	
	ОткрытьФорму("Документ.НастраиваемыйОтчет.ФормаСписка", ПолучитьОтборЭкземплярыОрганизаций());
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличнойЧасти_МетодПолногоПриобретения

&НаКлиенте
Процедура ИзменениеЧистыхАктивовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.ИзменениеЧистыхАктивов.ТекущиеДанные;
	ИменаСубконто = Этаформа.КэшируемыеЗначения.ИменаСубконто.ИзменениеЧистыхАктивов;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат; 
	КонецЕсли;
	
	Если ТекущаяСтрока.ОбъектИнвестирования.Пустая() Тогда
		ТекущаяСтрока.ОбъектИнвестирования = Элементы.ИзменениеЧистыхАктивов.ОтборСтрок.ОбъектИнвестирования; 
	КонецЕсли;
	
	МСФОКлиентСерверУХ.ОбновитьСубконтоСчетаТЧ(Этаформа, ТекущаяСтрока, "СчетЧА", "ИзменениеЧистыхАктивов", ИменаСубконто);

КонецПроцедуры

&НаКлиенте
Процедура МетодПолногоПриобретенияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
КонецПроцедуры

&НаКлиенте
Процедура ЧистыеАктивыСчетКапиталаПриИзменении(Элемент)
	МСФОКлиентСерверУХ.ПриИзмененииСчетаТЧ(ЭтаФорма, Элемент, "Капитал");
КонецПроцедуры

&НаКлиенте
Процедура МетодПолногоПриобретенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Элементы.ИзменениеДолей.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Не выбрана строка изменения долей'"), Отказ); 
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличнойЧасти_МетодДолевогоУчастия

&НаКлиенте
Процедура МетодДолевогоУчастияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МетодДолевогоУчастия.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьРеквизитыСтрокиДетали(ТекущаяСтрока, Неопределено);
	
	КэшПоКлючуСтроки = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшВладельцаПоКлючуСтроки(Объект.ИзменениеДолей, ТекущаяСтрока.КлючСтроки);
	КэшированныеЗначения = Новый Структура("КэшПоКлючуСтроки", КэшПоКлючуСтроки);
	
	СтруктураДействий = Новый Структура;	
	
	СтруктураДействий.Вставить("РассчитатьИзменениеЧистыхАктивов");
	СтруктураДействий.Вставить("РассчитатьФинансовыйРезультат");
	СтруктураДействий.Вставить("РассчитатьДолюВФинансовомРезультате");
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);	
	
	УстановитьРучноеРедактированиеЧА(ТекущаяСтрока, КэшПоКлючуСтроки.Получить(ТекущаяСтрока.КлючСтроки));	
	ОбновитьДанныеПодвалаЧА(ТекущаяСтрока.КлючСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ДолевоеУчастиеПолнаяДоляВладенияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ФинансовыйРезультат.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("РассчитатьДолюГруппыВФинансовомРезультате", КэшируемыеЗначения.МетодыКонсолидации);
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий);

КонецПроцедуры

&НаКлиенте
Процедура ДолевоеУчастиеФинансовыйРезультатПериодаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ФинансовыйРезультат.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("РассчитатьДолюГруппыВФинансовомРезультате");
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий);
	
КонецПроцедуры

&НаКлиенте
Процедура МетодДолевогоУчастияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Элементы.ИзменениеДолей.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(НСтр("ru = 'Не выбрана строка изменения долей'"), Отказ); 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиТабличнойЧасти_ИзменениеДолей

&НаКлиенте
Процедура ИзменениеДолейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДатаОкончанияПериода = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(Объект.ПериодОтчета, "ДатаОкончания");
	Если ТекущаяСтрока.ДатаИзмененияДоли = ДатаОкончанияПериода Тогда
		Возврат;
	КонецЕсли;
	
	ОтборСтрок = Новый Структура("ДатаПредыдущегоИзменения", ОбщегоНазначенияУХ.ДобавитьДень(ТекущаяСтрока.ДатаИзмененияДоли, 1));	
	Для каждого СтрокаДоли Из Объект.ИзменениеДолей.НайтиСтроки(ОтборСтрок) Цикл		
		КэшируемыеЗначения.Вставить("СледующийИдентификатор", СтрокаДоли.ПолучитьИдентификатор());
		Прервать;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ТекущаяСтрока = Новый Структура("ОбъектИнвестирования,ОтношениеКГруппеНаКонец,КлючСтроки");		
	КонецЕсли;
	
	ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
	ОбновитьДанныеПодвалаЧА(ТекущаяСтрока.КлючСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейПередУдалением(Элемент, Отказ)
		
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	Отбор = Новый Структура("ОбъектИнвестирования", ТекущаяСтрока.ОбъектИнвестирования);
	
	Для каждого СтрокаДляУдаления Из Объект.МетодДолевогоУчастия.НайтиСтроки(Отбор) Цикл
		Объект.МетодДолевогоУчастия.Удалить(СтрокаДляУдаления);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовТабличнойЧасти_ИзменениеДолей

&НаКлиенте
Процедура ИзменениеДолейГруппаНаКонецПериодаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ПересчитатьСтрокуИзменениеДолей(Элементы.ИзменениеДолей.ТекущаяСтрока, Неопределено, Истина);
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ИзменениеДолейПолнаяДоляВладенияНаКонецПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
	
	ПересчитатьСтрокуИзменениеДолей(Элементы.ИзменениеДолей.ТекущаяСтрока, Неопределено);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейГудвилПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
	КэшПоКлючуСтроки =  ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки);
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьИзменениеНДУПриИзмененииДоли");
	СтруктураДействий.Вставить("РассчитатьРезультатАкционеровОтИзмененияДоли");
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", КэшПоКлючуСтроки);
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейНДУПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
	КэшПоКлючуСтроки =  ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки);
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьГудвил");
	СтруктураДействий.Вставить("РассчитатьИзменениеНДУПриИзмененииДоли");
	СтруктураДействий.Вставить("РассчитатьРезультатАкционеровОтИзмененияДоли");
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", КэшПоКлючуСтроки);
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейРезультатАкционеровОтИзмененияДолиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейИзменениеНДУПриИзмененииДолиПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейВозмещаемаяСтоимостьНаОтчетнуюДатуПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
	КэшПоКлючуСтроки =  ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки);
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", КэшПоКлючуСтроки);
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейГудвилНаОтчетнуюДатуПриИзменении(Элемент)
		
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
	КэшПоКлючуСтроки = ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки);
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", КэшПоКлючуСтроки);
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейЧистыеАктивыНаОтчетнуюДатуПриИзменении(Элемент)
		
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
	КэшПоКлючуСтроки =  ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки);
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", КэшПоКлючуСтроки);
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеДолейОбесценениеГудвилаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ИзменениеДолей.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда	
		ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
		Возврат; 
	КонецЕсли;
	
	ТекущаяСтрока.РучноеРедактирование = Истина;
		
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеИзмениеДолей

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьИзменениеДолейПриИзмененииЧА(Форма, КлючСтроки = Неопределено, СтрокаИзменениеДолей = Неопределено)

	Объект = Форма.Объект;
	
	Если СтрокаИзменениеДолей = Неопределено Тогда		
		СтрокиВладельцыПоКлючамСтроки = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшВладельцаПоКлючуСтроки(Объект.ИзменениеДолей,КлючСтроки);
		СтрокаИзменениеДолей = СтрокиВладельцыПоКлючамСтроки.Получить(КлючСтроки);		
	КонецЕсли;
	
	КэшированныеЗначения = Новый Структура("ИтогиЧА", ПолучитьКэшЧА(Форма, КлючСтроки));
	
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьНДУ");
	СтруктураДействий.Вставить("РассчитатьГудвил");
	СтруктураДействий.Вставить("РассчитатьИзменениеНДУПриИзмененииДоли");
	СтруктураДействий.Вставить("РассчитатьРезультатАкционеровОтИзмененияДоли");
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");	
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(СтрокаИзменениеДолей, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьСтрокуИзменениеДолей(ТекущаяСтрокаИндекс, СтруктураДействий = Неопределено, ОбновитьСледующееИзменениеДоли = Ложь)
	
	Если ТекущаяСтрокаИндекс = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущаяСтрокаИндекс) = Тип("Число") Тогда
		ТекущаяСтрока = Объект.ИзменениеДолей.НайтиПоИдентификатору(ТекущаяСтрокаИндекс);
	Иначе 	
		ТекущаяСтрока = ТекущаяСтрокаИндекс;
	КонецЕсли;	
	
	Если СтруктураДействий = Неопределено Тогда
		
		СтруктураДействий = Новый Структура;	
		СтруктураДействий.Вставить("РассчитатьНДУ");
		СтруктураДействий.Вставить("РассчитатьГудвил");
		СтруктураДействий.Вставить("РассчитатьИзменениеНДУПриИзмененииДоли");
		СтруктураДействий.Вставить("РассчитатьРезультатАкционеровОтИзмененияДоли");
		СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");
		
	КонецЕсли;
    
    КэшированныеЗначения = Новый Структура("ИтогиЧА", ПолучитьКэшЧА(ЭтаФорма, ТекущаяСтрока.КлючСтроки));
    
    ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
    
    ОбновитьОтображениеЗависимыхТЧ(ЭтаФорма, ТекущаяСтрока.КлючСтроки, ТекущаяСтрока.ОтношениеКГруппеНаКонец);
    
    // обновим ЧА
    КэшЧА = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшДеталиПоКлючуСтроки(Объект.МетодДолевогоУчастия, ТекущаяСтрока.КлючСтроки);
    КэшДоли = Новый Соответствие;
    КэшДоли.Вставить(ТекущаяСтрока.КлючСтроки, ТекущаяСтрока); 
    
    ОбработатьСтрокиЧА(ЭтаФорма, КэшЧА.Получить(ТекущаяСтрока.КлючСтроки), КэшДоли, ТекущаяСтрока.ОбъектИнвестирования);
	
	Если ОбновитьСледующееИзменениеДоли Тогда	
		ОбновитьСледующееИзменениеДоли(ТекущаяСтрока);	
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбновитьСледующееИзменениеДоли(ТекущаяСтрока)

 	ДатаСледующегоИнтервала = ОбщегоНазначенияУХ.ДобавитьДень(ТекущаяСтрока.ДатаИзмененияДоли, 1);
	
	ПоискСледующейСтроки = Новый Структура;
	ПоискСледующейСтроки.Вставить("ДатаПредыдущегоИзменения", ДатаСледующегоИнтервала);
	ПоискСледующейСтроки.Вставить("ОбъектИнвестирования", ТекущаяСтрока.ОбъектИнвестирования);
											
	Для каждого СтрокаСледующегоИнтервала Из Объект.ИзменениеДолей.НайтиСтроки(ПоискСледующейСтроки) Цикл
		
		СтрокаСледующегоИнтервала.ОтношениеКГруппеНаНачало = ТекущаяСтрока.ОтношениеКГруппеНаКонец;
		СтрокаСледующегоИнтервала.ОтношениеКГруппеНаКонец = ТекущаяСтрока.ОтношениеКГруппеНаКонец;
		СтрокаСледующегоИнтервала.РучноеРедактирование = Истина;
		
		ПересчитатьСтрокуИзменениеДолей(СтрокаСледующегоИнтервала);
		ОбновитьСледующееИзменениеДоли(СтрокаСледующегоИнтервала);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеЧистыеАктивы

&НаКлиентеНаСервереБезКонтекста
Процедура ПересчитатьЧистыеАктивыПриИзмененииДолей(Форма, КлючСтроки = Неопределено, СтрокаИзменениеДолей = Неопределено)

	Объект = Форма.Объект;
	
	Если СтрокаИзменениеДолей = Неопределено Тогда		
		СтрокиВладельцыПоКлючамСтроки = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшВладельцаПоКлючуСтроки(Объект.ИзменениеДолей,КлючСтроки);
		СтрокаИзменениеДолей = СтрокиВладельцыПоКлючамСтроки.Получить(КлючСтроки);		
	КонецЕсли;
		
	СтруктураДействий = Новый Структура;	
	СтруктураДействий.Вставить("РассчитатьНДУ");
	СтруктураДействий.Вставить("РассчитатьГудвил");
	СтруктураДействий.Вставить("РассчитатьИзменениеНДУПриИзмененииДоли");
	СтруктураДействий.Вставить("РассчитатьРезультатАкционеровОтИзмененияДоли");
	СтруктураДействий.Вставить("РассчитатьОбесценениеГудвила");	
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(СтрокаИзменениеДолей, СтруктураДействий, Форма.КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьЧистыеАктивы(Форма, ОбъектИнвестирования = Неопределено)

	МетодДолевогоУчастия = Новый Соответствие;
	
	Если ОбъектИнвестирования = Неопределено Тогда		
		ТаблицаЧА = Форма.Объект.МетодДолевогоУчастия;		
	Иначе		
		ОтборЧА = Новый Структура("ОбъектИнвестирования", ОбъектИнвестирования);
		ТаблицаЧА = Форма.Объект.МетодДолевогоУчастия.НайтиСтроки(ОтборЧА);		
	КонецЕсли;
	
	Для каждого СтрокаЧА Из ТаблицаЧА Цикл
		
		СуммаЧА = МетодДолевогоУчастия.Получить(СтрокаЧА.ОбъектИнвестирования);
		МетодДолевогоУчастия.Вставить(СтрокаЧА.ОбъектИнвестирования, 
				?(СуммаЧА = Неопределено, СтрокаЧА.ЧистыеАктивыПослеИзменения, СуммаЧА + СтрокаЧА.ЧистыеАктивыПослеИзменения));
		
	КонецЦикла;	

	Возврат МетодДолевогоУчастия;
	
КонецФункции

&НаСервере
Функция ЗагрузитьТаблицуЧА(ТаблицаЧА, СтрокаДоли, НаДатуДвижений)

	СтрокиДляОбработки = Новый Массив;		
	Для каждого СтрокаЧА Из ТаблицаЧА Цикл
		
		Если (СтрокаЧА.ЧистыеАктивыДоИзменения = 0) И (СтрокаЧА.ЧистыеАктивыПослеИзменения = 0) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаПриемник = Объект.МетодДолевогоУчастия.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаПриемник, СтрокаЧА, , "ЧистыеАктивыДоИзменения,ЧистыеАктивыПослеИзменения");
		СтрокаПриемник.КлючСтроки = СтрокаДоли.КлючСтроки;
			
		СтрокаПриемник.ЧистыеАктивыДоИзменения = СтрокаЧА.ЧистыеАктивыДоИзменения;
		СтрокаПриемник.ЧистыеАктивыПослеИзменения = СтрокаЧА.ЧистыеАктивыПослеИзменения;

		СтрокиДляОбработки.Добавить(СтрокаПриемник);
		
	КонецЦикла;		
	
	Возврат СтрокиДляОбработки;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбработатьСтрокиЧА(Форма, СтрокиДляОбработки, КэшДоли, ОбъектИнвестирования)
	
	КэшированныеЗначения = Новый Структура("КэшПоКлючуСтроки", КэшДоли);
	
	СтруктураДействий = Новый Структура;
	
	СтруктураДействий.Вставить("РассчитатьИзменениеЧистыхАктивов");
	СтруктураДействий.Вставить("РассчитатьФинансовыйРезультат");
	СтруктураДействий.Вставить("ЗаполнитьСчетДляМДУ");
	СтруктураДействий.Вставить("РассчитатьДолюВФинансовомРезультате");		
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьТЧ_Инвестиции(СтрокиДляОбработки, СтруктураДействий, КэшированныеЗначения);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПодвалаЧА(КлючСтроки)
	
	Перем КлючТекущейСтроки;
	
	ПодвалЧА_Дивиденды = 0;
	ПодвалЧА_ИзменениеЧистыхАктивов = 0;
	ПодвалЧА_НалогНаДивиденды = 0;
	ПодвалЧА_ФинансовыйРезультат = 0;
	ПодвалЧА_ЧистыеАктивыДоИзменения = 0;
	ПодвалЧА_ЧистыеАктивыПослеИзменения = 0;
	
	ОтборСтрок = Элементы.МетодДолевогоУчастия.ОтборСтрок;
	Если (ОтборСтрок = Неопределено) Или НЕ ОтборСтрок.Свойство("КлючСтроки") Тогда
		Возврат;				
	КонецЕсли;
	
	СтрокиЧА = Объект.МетодДолевогоУчастия.НайтиСтроки(Новый Структура(ОтборСтрок));
	Для каждого СтрокаЧА Из СтрокиЧА Цикл
	
		ПодвалЧА_Дивиденды 						= ПодвалЧА_Дивиденды + СтрокаЧА.Дивиденды;
		ПодвалЧА_ИзменениеЧистыхАктивов 		= ПодвалЧА_ИзменениеЧистыхАктивов + СтрокаЧА.ИзменениеЧистыхАктивов;
		ПодвалЧА_НалогНаДивиденды 				= ПодвалЧА_НалогНаДивиденды + СтрокаЧА.НалогНаДивиденды;
		ПодвалЧА_ФинансовыйРезультат 			= ПодвалЧА_ФинансовыйРезультат + СтрокаЧА.ФинансовыйРезультат;
		ПодвалЧА_ЧистыеАктивыДоИзменения 		= ПодвалЧА_ЧистыеАктивыДоИзменения + СтрокаЧА.ЧистыеАктивыДоИзменения;
		ПодвалЧА_ЧистыеАктивыПослеИзменения 	= ПодвалЧА_ЧистыеАктивыПослеИзменения + СтрокаЧА.ЧистыеАктивыПослеИзменения;
	
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьКэшЧА(Форма, КлючСтроки)

	Возврат ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшИтоговДеталиПоКлючуСтроки(
						Форма.Объект.МетодДолевогоУчастия, 
						"ЧистыеАктивыДоИзменения,ЧистыеАктивыПослеИзменения", 
						КлючСтроки);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьЧАНаСервере(КлючСтроки, НаДатуДвижений = Истина)

	Перем ТекущаяСтрока,ДатыЭкземпляров;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");	
	КэшПоКлючуСтроки = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшВладельцаПоКлючуСтроки(Объект.ИзменениеДолей, КлючСтроки);
	ТабДоли = ДокументОбъект.ИзменениеДолей.Выгрузить(Новый Структура("КлючСтроки", КлючСтроки));
	ТекущаяСтрока = КэшПоКлючуСтроки.Получить(КлючСтроки);	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.УдалитьСтрокиДеталиПоКлючуСтроки(Объект.МетодДолевогоУчастия, "КлючСтроки", КлючСтроки);	
	
	ТабЧА = Документы.КонсолидационныеПоправки.ПолучитьТаблицуЧистыеАктивы(ДокументОбъект, ТабДоли, НаДатуДвижений);

	ТекущаяСтрока.КоэффициентЧА = ТабДоли[0].КоэффициентЧА;//обновим коэффициент
	
	ТабЧА.Колонки.Добавить("КлючСтроки");	
	ТабЧА.ЗаполнитьЗначения(КлючСтроки, "КлючСтроки");	
			
	СтрокиДляОбработки = ЗагрузитьТаблицуЧА(ТабЧА, ТекущаяСтрока, НаДатуДвижений);
	ОбработатьСтрокиЧА(ЭтаФорма, СтрокиДляОбработки, КэшПоКлючуСтроки, ТекущаяСтрока.ОбъектИнвестирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРеквизитыСтрокиДетали(СтрокаДетали, СтрокаВладелец = Неопределено)
	
	Если СтрокаВладелец = Неопределено Тогда		
		СтрокаВладелец = Элементы.ИзменениеДолей.ТекущиеДанные;	
		Если СтрокаВладелец = Неопределено Тогда
			Возврат; 
		КонецЕсли;	
	КонецЕсли;
	
	ОбщегоНазначенияУХ.УстановитьНовоеЗначение(СтрокаДетали.КлючСтроки, 			СтрокаВладелец.КлючСтроки);
	ОбщегоНазначенияУХ.УстановитьНовоеЗначение(СтрокаДетали.ОбъектИнвестирования,	СтрокаВладелец.ОбъектИнвестирования);
	ОбщегоНазначенияУХ.УстановитьНовоеЗначение(СтрокаДетали.ДатаИзмененияДоли, 		СтрокаВладелец.ДатаИзмененияДоли);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРучноеРедактированиеЧА(СтрокаЧА, СтрокаДоли = Неопределено)

	СтрокаЧА.РучноеРедактирование = Истина;
	
	Если СтрокаДоли <> Неопределено Тогда	
		СтрокаДоли.КоэффициентЧА = 0;	
		ПересчитатьИзменениеДолейПриИзмененииЧА(ЭтаФорма, СтрокаДоли.КлючСтроки, СтрокаДоли);		
	КонецЕсли;	

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФукнции

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ИменаСубконто = Документы.КонсолидационныеПоправки.ПолучитьИменаСубконто();
	
	ЭтаФорма.КэшируемыеЗначения = Новый Структура;	
	ЭтаФорма.КэшируемыеЗначения.Вставить("ИменаСубконто", 			ИменаСубконто);
	ЭтаФорма.КэшируемыеЗначения.Вставить("МетодыКонсолидации", 		МСФОВызовСервераУХ.ПолучитьСтруктуруСоЗначениямиПеречисления("МетодыКонсолидации"));
	ЭтаФорма.КэшируемыеЗначения.Вставить("ВидыОтношенийКГруппе",	МСФОВызовСервераУХ.ПолучитьСтруктуруСоЗначениямиПеречисления("ВидыОтношенийКГруппе"));
	
	ЗаполнитьКонсолидирующуюОрганизацию();
	
	Для каждого СубконтоТЧ Из ЭтаФорма.КэшируемыеЗначения.ИменаСубконто Цикл
		МСФОУХ.ЗаполнитьДоступностьСубконто(ЭтаФорма, СубконтоТЧ.Значение, СубконтоТЧ.Ключ);	
	КонецЦикла;
	
	ПараметрыВыбораСчетов = МСФОКлиентСерверУХ.ПолучитьПараметрыВыбораДляСчетаБД(КэшируемыеЗначения.ПланСчетовМСФО, Неопределено);
	Элементы.МетодДолевогоУчастияСчетЧА.ПараметрыВыбора = ПараметрыВыбораСчетов;
	Элементы.МетодДолевогоУчастияСчетДляМДУ.ПараметрыВыбора = ПараметрыВыбораСчетов;
	
	МСФОУХ.ДобавитьОформлениеДоступностиСубконто(ЭтаФорма, ИменаСубконто, "МетодДолевогоУчастия");
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКонсолидирующуюОрганизацию()

	КонсолидирующаяОрганизация = УправлениеРабочимиПроцессамиУХ.ПолучитьКонсолидирующуюОрганизацию(
																	Объект.Организация,
																	Объект.Сценарий, 
																	Объект.ПериодОтчета);
																	
	МСФОУХ.ОбновитьКэшируемыеЗначенияОрганизации(ЭтаФорма, КонсолидирующаяОрганизация);
										
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Если КонсолидирующаяОрганизация.Пустая() Тогда
		Сообщить(Нстр("ru = 'Не удалось определить консолидирующую организацию регламента по элиминирующей. Заполнение не возможно'"));
		Возврат; 
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	
	ДокументОбъект.ДополнительныеСвойства.Вставить("КонсолидирующаяОрганизация", КонсолидирующаяОрганизация);
	ДокументОбъект.Заполнить(Новый Структура("ЗаполнитьПоМСФО", Истина));
	
	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтображениеЗависимыхТЧ(Форма, КлючСтроки, ТекущееОтношениеКГруппе = Неопределено)

	Перем ВидОтношенияКГруппе;
	
	КэшируемыеЗначения = Форма.КэшируемыеЗначения;
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСтроки", КлючСтроки);
	
	Элементы.Инвестиции.ОтборСтрок = ОтборСтрок;
	
	Если ТекущееОтношениеКГруппе <> Неопределено Тогда
		ВидОтношенияКГруппе = ОбщегоНазначенияУХ.ПолучитьЗначениеРеквизита(ТекущееОтношениеКГруппе, "ВидОтношенияКГруппе");
	КонецЕсли;
	
	Если (ВидОтношенияКГруппе = КэшируемыеЗначения.ВидыОтношенийКГруппе.Дочернее)
		Или (ВидОтношенияКГруппе = КэшируемыеЗначения.ВидыОтношенийКГруппе.Материнское) Тогда 
		
		ОбновитьОтображениеЧА(Форма, Истина, Истина, ОтборСтрок);
		
		Элементы.Страница_ОбесценениеГудвила.Видимость = Истина;
		Элементы.Страница_ОбесценениеГудвила.Заголовок = НСтр("ru = 'Обесценение гудвила'");		
		Элементы.ИзменениеДолейГудвилНаОтчетнуюДату.Видимость = Истина;
		Элементы.ИзменениеДолейЧистыеАктивыНаОтчетнуюДату.Заголовок = НСтр("ru = 'Чистые активы на отчетную дату'");
				
	ИначеЕсли (ВидОтношенияКГруппе = КэшируемыеЗначения.ВидыОтношенийКГруппе.Ассоциированное) 
		Или (ВидОтношенияКГруппе = КэшируемыеЗначения.ВидыОтношенийКГруппе.Совместное) Тогда
		
		ОбновитьОтображениеЧА(Форма, Истина, Ложь, ОтборСтрок);
		
		Элементы.Страница_ОбесценениеГудвила.Видимость = Истина;
		Элементы.Страница_ОбесценениеГудвила.Заголовок = НСтр("ru = 'Обесценение инвестиций по МДУ'");
		Элементы.ИзменениеДолейГудвилНаОтчетнуюДату.Видимость = Ложь;
		Элементы.ИзменениеДолейЧистыеАктивыНаОтчетнуюДату.Заголовок = НСтр("ru = 'Инвестиция на отчетную дату'");
				
	Иначе
		
		Элементы.Страница_ОбесценениеГудвила.Видимость = Ложь;		
		Элементы.ИзменениеДолейЧистыеАктивыНаОтчетнуюДату.Заголовок = "";
		
		ОбновитьОтображениеЧА(Форма, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтображениеЧА(Форма, ВидимостьТЧ = Истина, ДочерняяИлиМатеринская = Истина, ОтборСтрок = Неопределено)
	
	Элементы = Форма.Элементы;
	
	Элементы.Страница_МетодДолевогоУчастия.Видимость = ВидимостьТЧ;	
	Если ВидимостьТЧ = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	Если ДочерняяИлиМатеринская Тогда
	   	Элементы.Страница_МетодДолевогоУчастия.Заголовок = "Метод полного приобретения";	
		Элементы.МетодДолевогоУчастияФинансовыйРезультат.Заголовок = "Результат для НДУ";
	Иначе	
		Элементы.Страница_МетодДолевогоУчастия.Заголовок = "Метод долевого участия";
		Элементы.МетодДолевогоУчастияФинансовыйРезультат.Заголовок = "Результат для инвестора";
	КонецЕсли;
		
	Элементы.МетодДолевогоУчастияСчетДляМДУ.Видимость 				= Не ДочерняяИлиМатеринская;
	Элементы.МетодДолевогоУчастияСчетДляМДУНаименование.Видимость 	= Не ДочерняяИлиМатеринская;
	Элементы.МетодДолевогоУчастияДивиденды.Видимость 				= Не ДочерняяИлиМатеринская;
	Элементы.МетодДолевогоУчастияНалогНаДивиденды.Видимость 		= Не ДочерняяИлиМатеринская;
	
	Элементы.МетодДолевогоУчастия.ОтборСтрок = ОтборСтрок;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИзРасчетаПолныхДолей(АдресРасчетаПолныхДолей)

	ТаблицаПолныхДолей = ПолучитьИзВременногоХранилища(АдресРасчетаПолныхДолей);
	ТаблицаПолныхДолей.Колонки.ЭффективнаяДоля.Имя = "ЭффективнаяДоляНаКонец";
	
	Объект.Элиминация.Загрузить(ТаблицаПолныхДолей);	
	
	Контекст = Новый Структура("Сценарий,ПериодОтчета,КонсолидирующаяОрганизация", 
								Объект.Сценарий, Объект.ПериодОтчета, КонсолидирующаяОрганизация);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьГруппуНаНачалоПериода", Контекст);
	СтруктураДействий.Вставить("ЗаполнитьГруппуНаКонецПериода");
		
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьТЧ_Инвестиции(Объект.Элиминация, СтруктураДействий);
	
	УдалитьИзВременногоХранилища(АдресРасчетаПолныхДолей);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСуммуВВалюте(Сумма, ДанныеКурсаНач, ДанныеКурсаКон)
	
	Возврат РаботаСКурсамиВалютКлиентСерверУХ.ПересчитатьИзВалютыВВалюту(
					Сумма, 
					ДанныеКурсаНач.Валюта, 
					ДанныеКурсаКон.Валюта,
					ДанныеКурсаНач.Курс,
					ДанныеКурсаКон.Курс,
					ДанныеКурсаНач.Кратность,
					ДанныеКурсаКон.Кратность);
	
КонецФункции

&НаСервере
Функция ПолучитьОтборЭкземплярыОрганизаций()
    
    Перем ПараметрыОткрытия;

	РеквизитыУП = МСФОВызовСервераУХ.РеквизитыДляФормыУП(Объект.Организация, Объект.ПериодОтчета.ДатаОкончания, Объект.Сценарий);

	ВидОтчетаОСВ = Справочники.ВидыОтчетов.ПолучитьВидОтчетаОСВ(РеквизитыУП.ПланСчетовМСФО);
    
    ПараметрыОткрытия = Новый Структура;
    ПараметрыОткрытия.Вставить("Сценарий", Объект.Сценарий);
	ПараметрыОткрытия.Вставить("ВидОтчета", ВидОтчетаОСВ);
	
	Если (Элементы.ИзменениеДолей.ТекущаяСтрока <> Неопределено) Тогда
		ТекущаяСтрока = Объект.ИзменениеДолей.НайтиПоИдентификатору(Элементы.ИзменениеДолей.ТекущаяСтрока);
		ПараметрыОткрытия.Вставить("Организация", ТекущаяСтрока.ОбъектИнвестирования);
	КонецЕсли;
	
	Возврат ПараметрыОткрытия;

КонецФункции

&НаКлиенте
Процедура МетодДолевогоУчастияСчетЧАПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.МетодДолевогоУчастия.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КэшПоКлючуСтроки = ОбработкаТабличныхЧастейКлиентСерверУХ.ПолучитьКэшВладельцаПоКлючуСтроки(Объект.ИзменениеДолей, ТекущаяСтрока.КлючСтроки);
	КэшированныеЗначения = Новый Структура("КэшПоКлючуСтроки", КэшПоКлючуСтроки);
	
	СтруктураДействий = Новый Структура;	
	
	СтруктураДействий.Вставить("ЗаполнитьСчетДляМДУ");
	
	ОбработкаТабличныхЧастейКлиентСерверУХ.ОбработатьСтрокуТЧ_Инвестиции(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);	
	
	УстановитьРучноеРедактированиеЧА(ТекущаяСтрока, КэшПоКлючуСтроки.Получить(ТекущаяСтрока.КлючСтроки));	
	ОбновитьДанныеПодвалаЧА(ТекущаяСтрока.КлючСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсиюРегламента(Команда)
	
	ВерсияРегламента = УправлениеРабочимиПроцессамиУХ
							.ПолучитьВерсиюРегламентаПодготовкиОтчетности(
								Объект.Сценарий, 
								Объект.ПериодОтчета);
								
	ПоказатьЗначение(,ВерсияРегламента);
	
КонецПроцедуры

#КонецОбласти
