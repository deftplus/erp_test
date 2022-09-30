#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = НастройкиСистемыПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Элементы.ЛокализацияГруппаВнеоборотныеАктивы22.Видимость = Ложь;
	Элементы.ОткрытьПомощникПерехода.Видимость = Ложь;
	
	ОпределитьНаличиеУчета();
	УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
	
	НастройкиСистемыЛокализация.ПриСозданииНаСервере_ВнеоборотныеАктивы(ЭтаФорма);
	
	УстановитьВидимостьЭлементовФормы();
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
	
		// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
		// то прочитаем значения констант и обновим элементы этой формы.
		Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
		 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
		 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
		 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0)
		 ИЛИ Источник = "ИспользоватьВнеоборотныеАктивы2_4" Тогда
			
			ЭтаФорма.Прочитать();
			УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
			УстановитьДоступность();
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда
		УстановитьДоступность();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриИзмененииРеквизита(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НастройкиСистемыКлиентЛокализация.ПриИзмененииРеквизитаНачалоВыбора_ВнеоборотныеАктивы(
		ЭтаФорма,
		Элемент,
		ДанныеВыбора,
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетВнеоборотныхАктивовПриИзменении(Элемент)
	
	ОпределитьНаличиеУчета();
	
	Отказ = Ложь;
	
	Если УчетВнеоборотныхАктивов = "2_4" И НЕ ДоступностьУчета24.ДоступенУчет Тогда
		
		ПоказатьПредупреждение(, ДоступностьУчета24.КомментарийУчет2_4); 
		
		Отказ = Истина;
	
	Иначе
		
		НастройкиСистемыКлиентЛокализация.УчетВнеоборотныхАктивовПриИзменении(ЭтаФорма, Отказ);
		
	КонецЕсли;
	
	Если Отказ Тогда
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
		Возврат;
	КонецЕсли;
	
	// При понижении версии нужно предупредить пользователя
	ТекстВопроса = "";
	Если УчетВнеоборотныхАктивов = ""
		И НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
			
		Если НЕ НаличиеУчета.МожноОтключитьУчет Тогда
			ТекстВопроса = НСтр("ru = 'Отключать учет внеоборотных активов после начала работы с системой не рекомендуется.
		                            |Продолжить редактирование?';
		                            |en = 'It is not recommended that you disable fixed and intangible assets accounting after you start working with the application.
		                            |Continue editing?'");
		КонецЕсли;
		
	Иначе
		
		НастройкиСистемыКлиентЛокализация.ПриПониженииВерсииУчетаВнеоборотныхАктивов(ЭтаФорма, ТекстВопроса);
		
	КонецЕсли;
	
	Если ТекстВопроса <> "" Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("УчетВнеоборотныхАктивовПриИзмененииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантОбособленияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

// Параметры:
// 	ИмяЭлемента - Строка -
// 	ДополнительныеПараметры - Структура:
//		* ПараметрыОбработки - Структура:
//			** Элемент - ПолеФормы
//			** ОбновлятьИнтерфейс - Булево
&НаКлиенте
Процедура ПриОкончанииИзмененияРеквизитаЛокализации(ИмяЭлемента, ДополнительныеПараметры) Экспорт
	Подключаемый_ПриИзмененииРеквизита(
		ДополнительныеПараметры.ПараметрыОбработки.Элемент, 
		ДополнительныеПараметры.ПараметрыОбработки.ОбновлятьИнтерфейс);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
	УстановитьВидимостьОбесценения();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Нажатие(Элемент)
	
	НастройкиСистемыКлиентЛокализация.ОбработкаСобытияНажатия_ВнеоборотныеАктивы(Элемент, ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УчетВнеоборотныхАктивовПриИзмененииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Подключаемый_ПриИзмененииРеквизита(Элементы.УчетВнеоборотныхАктивов);
	Иначе
		УчетВнеоборотныхАктивов = ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Новый Структура);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если СтрНачинаетсяС(НРег(РеквизитПутьКДанным), НРег("НаборКонстант.")) Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		ЧастиИмени = СтрРазделить(РеквизитПутьКДанным, ".");
		КонстантаИмя = ЧастиИмени[1];
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" Тогда
		
		Если УчетВнеоборотныхАктивов = "2_4" Тогда
			КонстантаИмя = "ИспользоватьВнеоборотныеАктивы2_4";
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 = Истина;
		ИначеЕсли УчетВнеоборотныхАктивов = "" Тогда
			КонстантаИмя = "ИспользоватьВнеоборотныеАктивы2_4";
			НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 = Ложь;
		КонецЕсли;
		
		Если Константы.ИспользоватьВнеоборотныеАктивы2_4.Получить() <> НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
			
			Константы.ИспользоватьВнеоборотныеАктивы2_4.Установить(НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4);
			
			Если НастройкиСистемыПовтИсп.ЕстьПодчиненныеКонстанты("ИспользоватьВнеоборотныеАктивы2_4", НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4) Тогда
				ЭтаФорма.Прочитать();
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	ВнеоборотныеАктивыЛокализация.СохранитьЗначениеРеквизита_ПанельАдминистрированияКА(
		ЭтаФорма, РеквизитПутьКДанным, КонстантаИмя);
	
	Возврат КонстантаИмя;
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовФормы()
	
	УправлениеПредприятием = ПолучитьФункциональнуюОпцию("УправлениеПредприятием");
	
	Элементы.ГруппаНастройкиРемонты.Видимость = УправлениеПредприятием;
	Элементы.ГруппаУчетВнеоборотныхАктивов.ОтображатьЗаголовок = УправлениеПредприятием;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	ОпределитьДоступностьУчета2_4();
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьОбъектыСтроительства.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьОбъектыСтроительства" 
		ИЛИ РеквизитПутьКДанным = "УчетВнеоборотныхАктивов"
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьОбъектыСтроительства, 
			НаборКонстант.ИспользоватьОбъектыСтроительства И НаличиеУчета.ЕстьУчет2_4);
	КонецЕсли;
		
	//++ НЕ УТКА

	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУправлениеРемонтами" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьУправлениеРемонтами,
			НаборКонстант.ИспользоватьУправлениеРемонтами);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУзлыОбъектовЭксплуатации" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьУзлыОбъектовЭксплуатации,
			НаборКонстант.ИспользоватьУзлыОбъектовЭксплуатации);
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьУправлениеРемонтами" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ИспользоватьУзлыОбъектовЭксплуатации.Доступность = НаборКонстант.ИспользоватьУправлениеРемонтами;
		Элементы.ВариантОбособленияМатериаловВРемонтах.Доступность = НаборКонстант.ИспользоватьУправлениеРемонтами
			И Константы.ФормироватьФинансовыйРезультат.Получить();
	КонецЕсли;
	
	ИспользоватьОбособленноеОбеспечениеЗаказов = Константы.ИспользоватьОбособленноеОбеспечениеЗаказов.Получить();
	Элементы.ГруппаВариантОбособленияМатериаловВРемонтах.Видимость = ИспользоватьОбособленноеОбеспечениеЗаказов;
	//-- НЕ УТКА
	
	НастройкиСистемыЛокализация.УстановитьДоступность_ВнеоборотныеАктивы(ЭтаФорма, РеквизитПутьКДанным);
	
	//++НЕ УТ
	УстановитьВидимостьОбесценения();
	//--НЕ УТ
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьУчета2_4()
	
	ДоступностьУчета24 = Новый ФиксированнаяСтруктура(ВнеоборотныеАктивы.УсловияПереходаНаУчет2_4());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЗначениеВыбораУчетВнеоборотныхАктивов(НаборКонстант)

	Если НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4 Тогда
		Возврат "2_4";
	ИначеЕсли НаборКонстант.ИспользоватьВнеоборотныеАктивы2_2 Тогда
		Возврат "2_2";
	Иначе
		Возврат "";
	КонецЕсли; 

КонецФункции

&НаСервере
Процедура ОпределитьНаличиеУчета()

	НаличиеУчетаВПрограмме = Новый Структура;
	НаличиеУчетаВПрограмме.Вставить("ЕстьУчет", ВнеоборотныеАктивыСлужебный.ЕстьУчетВнеоборотныхАктивов());
	НаличиеУчетаВПрограмме.Вставить("ЕстьУчет2_4", ВнеоборотныеАктивыСлужебный.ЕстьУчетВнеоборотныхАктивов2_4());
	НаличиеУчетаВПрограмме.Вставить("МожноОтключитьУчет", НЕ НаличиеУчетаВПрограмме.ЕстьУчет И НЕ НаличиеУчетаВПрограмме.ЕстьУчет2_4);
			
	ВнеоборотныеАктивыЛокализация.ДополнитьНаличиеУчета(НаличиеУчетаВПрограмме);
	
	НаличиеУчета = Новый ФиксированнаяСтруктура(НаличиеУчетаВПрограмме);
	
КонецПроцедуры

//++НЕ УТ
&НаСервере
Процедура УстановитьВидимостьОбесценения()
	
	Элементы.ГруппаИспользоватьОбесценениеВНА.Видимость = НаборКонстант.ИспользоватьВнеоборотныеАктивы2_4;

КонецПроцедуры
//--НЕ УТ

#КонецОбласти

#КонецОбласти