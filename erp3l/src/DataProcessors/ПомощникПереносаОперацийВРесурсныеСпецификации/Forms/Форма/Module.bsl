#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения") Тогда
		ВызватьИсключение(
			НСтр("ru = 'Для работы помощника переноса операций необходимо включить использование дополнительных реквизитов и сведений.';
				|en = 'Enable additional attributes and information records to use operations transfer assistant.'"));
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьМаршрутныеКарты") Тогда
		ВызватьИсключение(
			НСтр("ru = 'Использование маршрутных карт отключено, возможно переход на хранение операций в спецификациях уже завершен.';
				|en = 'Using route sheets is disabled, the transition to storing operations in the bills of materials has already been completed.'"));
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ОтметкаШаг_1 Тогда
		НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартам();
	ИначеЕсли НЕ ОтметкаШаг_2 И ОтметкаШаг_1 Тогда
		НачатьОбновлениеИнформацииПоНаличиюКонфликтов();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#Область Отметки

&НаКлиенте
Процедура ОтметкаГотовоШаг1Нажатие(Элемент)
	
	СброситьОтметку(ЭтотОбъект, 1);
	
	НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартам();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкаНеГотовоШаг1Нажатие(Элемент)
	
	УстановитьОтметку(ЭтотОбъект, 1);
	
	НачатьОбновлениеИнформацииПоНаличиюКонфликтов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкаГотовоШаг2Нажатие(Элемент)
	
	СброситьОтметку(ЭтаФорма, 2);
	
	НачатьОбновлениеИнформацииПоНаличиюКонфликтов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкаНеГотовоШаг2Нажатие(Элемент)
	
	УстановитьОтметку(ЭтотОбъект, 2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкаГотовоШаг3Нажатие(Элемент)
	
	СброситьОтметку(ЭтаФорма, 3);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметкаНеГотовоШаг3Нажатие(Элемент)
	
	УстановитьОтметку(ЭтотОбъект, 3);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВариантОтбораМаршрутныхКартПриИзменении(Элемент)
	
	ВыбранныеМаршрутныеКартыКоличество = 0;
	
	НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартам();
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "СозданиеТиповыхТехнологическихПроцессов");
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольныйОтборНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкиКомпоновки", НастройкиКомпоновки);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроизвольныйОтборЗавершение", ЭтотОбъект);
		
	ОткрытьФорму("Обработка.ПомощникПереносаОперацийВРесурсныеСпецификации.Форма.ФормаПроизвольныйОтбор",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВыбраноМаршрутныхКартНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	Если НЕ ВариантОтбораМаршрутныхКарт = ВариантОтбораМаршрутныхКартВсе() Тогда
		ПараметрыФормы.Вставить("ВыбранныеМаршрутныеКартыАдрес", ВыбранныеМаршрутныеКартыАдрес);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПомощникПереносаОперацийВРесурсныеСпецификации.Форма.ФормаВыбранныеМаршрутныеКарты",
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнформацияОКонфликтахОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НачатьОбновлениеИнформацииПоНаличиюКонфликтов(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьТехнологическиеПроцессы(Команда)
	
	НачатьСозданиеТиповыхТехнологическихПроцессов();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПереносОпераций(Команда)
	
	НачатьОбъединениеСправочников();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьИспользованиеМаршрутныхКарт(Команда)
	
	ОтключитьИспользованиеМаршрутныхКартНаСервере();
	
	ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	
	Оповестить("Запись_НаборКонстант", Новый Структура, "ИспользоватьМаршрутныеКарты");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отметки

&НаКлиентеНаСервереБезКонтекста
Функция ПоследовательностьШагов()
	
	Результат = Новый Массив;
	
	Результат.Добавить(1);
	Результат.Добавить(2);
	Результат.Добавить(3);
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредыдущийШаг(Форма, ТекущийШаг)
	
	Возврат ТекущийШаг-1;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ШагДоступен(Форма, ТекущийШаг)
	
	Если Форма.ДлительнаяОперацияОбработкаДанных <> Неопределено Тогда
		
		Возврат Ложь;
	
	Иначе
	
		Возврат (ТекущийШаг = 1 ИЛИ Форма["ОтметкаШаг_"+ПредыдущийШаг(Форма, ТекущийШаг)]);
		
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭлементыШагаДоступны(Форма, ТекущийШаг)
	
	Возврат ШагДоступен(Форма, ТекущийШаг) И НЕ Форма["ОтметкаШаг_"+ТекущийШаг];
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтметку(Форма, ТекущийШаг)
	
	Форма["ОтметкаШаг_"+ТекущийШаг] = Истина;
	
	НастроитьЗависимыеЭлементыФормы(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СброситьОтметку(Форма, ТекущийШаг)
	
	Для каждого Шаг Из ПоследовательностьШагов() Цикл
		
		Если Шаг < ТекущийШаг Тогда
			Продолжить;
		КонецЕсли;
		
		Форма["ОтметкаШаг_"+Шаг] = Ложь;
		
	КонецЦикла;
	
	НастроитьЗависимыеЭлементыФормы(Форма);
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеТиповыхТехнологическихПроцессов

&НаКлиентеНаСервереБезКонтекста
Функция ВариантОтбораМаршрутныхКартМногократноИспользуемые()
	Возврат 1;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВариантОтбораМаршрутныхКартПоОтбору()
	Возврат 2;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВариантОтбораМаршрутныхКартВсе()
	Возврат 0;
КонецФункции

&НаКлиенте
Процедура ПроизвольныйОтборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		НастройкиКомпоновки = Результат;
		
		НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартам();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартам()
	
	Элементы.ГруппаСтраницы1_4.ТекущаяСтраница = Элементы.ГруппаСтраница1_4_Ожидание;
	
	НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартамНаСервере();
	
	Если ДлительнаяОперацияИнтерфейс <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбновлениеИнформацииПоОтобраннымМаршрутнымКартамЗавершение",
			ЭтотОбъект);
			
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперацияИнтерфейс,
			ОписаниеОповещения,
			ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачатьОбновлениеИнформацииПоОтобраннымМаршрутнымКартамНаСервере()
	
	Если ДлительнаяОперацияИнтерфейс <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперацияИнтерфейс.ИдентификаторЗадания);
		ДлительнаяОперацияИнтерфейс = Неопределено;
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Получение списка отобранных маршрутных карт.';
															|en = 'Getting a list of selected route sheets.'");
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ВариантОтбораМаршрутныхКарт", ВариантОтбораМаршрутныхКарт);
	ПараметрыПроцедуры.Вставить("НастройкиКомпоновки", НастройкиКомпоновки);
	
	ДлительнаяОперацияИнтерфейс = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникПереносаОперацийВРесурсныеСпецификации.СписокОтобранныхМаршрутныхКартВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
	Если ДлительнаяОперацияИнтерфейс.Статус <> "Выполняется" Тогда
		
		ОбработатьРезультатОбновленияСпискаОтобранныхМаршрутныхКарт(ДлительнаяОперацияИнтерфейс);
		
		ДлительнаяОперацияИнтерфейс = Неопределено;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеИнформацииПоОтобраннымМаршрутнымКартамЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперацияИнтерфейс = Неопределено;
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		
		ОбработатьРезультатОбновленияСпискаОтобранныхМаршрутныхКарт(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатОбновленияСпискаОтобранныхМаршрутныхКарт(ДлительнаяОперация)
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	ВыбранныеМаршрутныеКартыКоличество = Результат.МаршрутныеКартыКоличество;
	Если ВариантОтбораМаршрутныхКартВсе() Тогда
		ВыбранныеМаршрутныеКартыАдрес = Неопределено;
	Иначе
		ВыбранныеМаршрутныеКартыАдрес = ПоместитьВоВременноеХранилище(Результат.МаршрутныеКарты, УникальныйИдентификатор);
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "СозданиеТиповыхТехнологическихПроцессов");
	
	Элементы.ГруппаСтраницы1_4.ТекущаяСтраница = Элементы.ГруппаСтраница1_4_Надпись; 
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьСозданиеТиповыхТехнологическихПроцессов()
	
	Если ДлительнаяОперацияОбработкаДанных <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаШаг1_Обработка.ТекущаяСтраница = Элементы.ГруппаШаг1_Обработка_Ожидание;
	
	НачатьСозданиеТиповыхТехнологическихПроцессовНаСервере();
	
	Если ДлительнаяОперацияОбработкаДанных <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"СозданиеТиповыхТехнологическихПроцессовЗавершение",
			ЭтотОбъект);
			
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперацияОбработкаДанных,
			ОписаниеОповещения,
			ПараметрыОжидания);
		
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура НачатьСозданиеТиповыхТехнологическихПроцессовНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание типовых технологических процессов.';
															|en = 'Generating standard technological processes.'");
	
	ПараметрыПроцедуры = Новый Структура("ВариантОтбораМаршрутныхКарт,МаршрутныеКарты");
	ПараметрыПроцедуры.ВариантОтбораМаршрутныхКарт = ВариантОтбораМаршрутныхКарт;
	Если НЕ ВариантОтбораМаршрутныхКарт = ВариантОтбораМаршрутныхКартВсе()
			И ЭтоАдресВременногоХранилища(ВыбранныеМаршрутныеКартыАдрес) Тогда
		ПараметрыПроцедуры.МаршрутныеКарты = ПолучитьИзВременногоХранилища(ВыбранныеМаршрутныеКартыАдрес);
	КонецЕсли;
	
	ДлительнаяОперацияОбработкаДанных = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникПереносаОперацийВРесурсныеСпецификации.СоздатьТиповыеТехнологическиеПроцессыВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура СозданиеТиповыхТехнологическихПроцессовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперацияОбработкаДанных = Неопределено;
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		
		РезультатЗадания = ОбработатьРезультатСозданияТехнологическихПроцессов(Результат);
		
		Если РезультатЗадания.ЕстьОшибки Тогда
			
			Сообщение = НСтр("ru = 'Завершено с ошибками.
			|	Подробности см. в журнале регистрации';
			|en = 'Completed with errors.
			|	See event log for details.'");
			Картинка  = БиблиотекаКартинок.Ошибка32;
			
		Иначе
			
			Сообщение = СтрШаблон(НСтр("ru = 'Завершено успешно.
			|	Создано технологических процессов: %1';
			|en = 'Completed successfully.
			|	Technological processes generated: %1'"), РезультатЗадания.КоличествоСоздано);
			Картинка  = БиблиотекаКартинок.Информация32;
			
			НачатьОбновлениеИнформацииПоНаличиюКонфликтов();
			
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Создание технологических процессов';
											|en = 'Creating technological processes'"),,
			Сообщение,
			Картинка);
			
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьРезультатСозданияТехнологическихПроцессов(ДлительнаяОперация)
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	Если НЕ Результат.ЕстьОшибки Тогда
	
		ОтметкаШаг_1 = Истина;
		Константы.ИспользоватьТехнологическиеПроцессы.Установить(Истина);
		
	КонецЕсли;
		
	Элементы.ГруппаШаг1_Обработка.ТекущаяСтраница = Элементы.ГруппаШаг1_Обработка_Пустая;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбъединениеСправочников

&НаКлиенте
Процедура НачатьОбновлениеИнформацииПоНаличиюКонфликтов(СформироватьОтчет = Ложь)
	
	Если СформироватьОтчет Тогда
		Элементы.Группа2_2Конфликты.ТекущаяСтраница = Элементы.Группа2_2_ОжиданиеОтчета;
	Иначе
		Элементы.Группа2_2Конфликты.ТекущаяСтраница = Элементы.Группа2_2_Ожидание;
	КонецЕсли;
	
	НачатьОбновлениеИнформацииПоНаличиюКонфликтовНаСервере(СформироватьОтчет);
	
	Если ДлительнаяОперацияИнтерфейс <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбновлениеИнформацииПоНаличиюКонфликтовЗавершение",
			ЭтотОбъект);
			
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперацияИнтерфейс,
			ОписаниеОповещения,
			ПараметрыОжидания);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НачатьОбновлениеИнформацииПоНаличиюКонфликтовНаСервере(СформироватьОтчет = Ложь)
	
	Если ДлительнаяОперацияИнтерфейс <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперацияИнтерфейс.ИдентификаторЗадания);
		ДлительнаяОперацияИнтерфейс = Неопределено;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("СформироватьОтчет", СформироватьОтчет);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление информации о наличии конфликтов.';
															|en = 'Updating conflict information.'");
	
	ДлительнаяОперацияИнтерфейс = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникПереносаОперацийВРесурсныеСпецификации.ОпределитьНаличиеКонфликтовВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеИнформацииПоНаличиюКонфликтовЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперацияИнтерфейс = Неопределено;
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		
		ДанныеОКонфликтах = Неопределено; // ТабличныйДокумент
		
		ОбработатьРезультатОбновленияИнформацииПоНаличиюКонфликтов(Результат, ДанныеОКонфликтах);
		
		Если ДанныеОКонфликтах <> Неопределено Тогда
			
			ОткрытьФорму("Обработка.ПомощникПереносаОперацийВРесурсныеСпецификации.Форма.ФормаИнформацияОКонфликтах",
				ДанныеОКонфликтах, ЭтотОбъект);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультатОбновленияИнформацииПоНаличиюКонфликтов(ДлительнаяОперация, ДанныеОКонфликтах = Неопределено)
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	Если Результат.ЕстьКонфликты = Истина Тогда
		Элементы.Группа2_2Конфликты.ТекущаяСтраница = Элементы.Группа2_2_ЕстьКонфликты;
		Если Результат.СформироватьОтчет Тогда
			АдресДанныеОКонфликтах = ПоместитьВоВременноеХранилище(Результат.ДанныеОКонфликтах, УникальныйИдентификатор);
			ДанныеОКонфликтах = Новый Структура("АдресДанныеОКонфликтах", АдресДанныеОКонфликтах);
		КонецЕсли;
	Иначе
		НадписьНетКонфликтов = НСтр("ru = 'Конфликтов не обнаружено либо все спецификации уже обработаны';
									|en = 'No conflicts found or all the bills of materials have already been processed'");
		Элементы.Группа2_2Конфликты.ТекущаяСтраница = Элементы.Группа2_2_НетКонфликтов;
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект, "ОбъединениеСправочников");
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбъединениеСправочников()
	
	Если ДлительнаяОперацияОбработкаДанных <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаШаг2_Обработка.ТекущаяСтраница = Элементы.ГруппаШаг2_Обработка_Ожидание;
	
	НачатьОбъединениеСправочниковНаСервере();
	
	Если ДлительнаяОперацияОбработкаДанных <> Неопределено Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОбъединениеСправочниковЗавершение",
			ЭтотОбъект);
			
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
			
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			ДлительнаяОперацияОбработкаДанных,
			ОписаниеОповещения,
			ПараметрыОжидания);
		
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура НачатьОбъединениеСправочниковНаСервере()
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ЗапуститьВФоне              = Истина;
	ПараметрыВыполнения.ОжидатьЗавершение           = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Перенос операций в ресурсные спецификации.';
															|en = 'Transferring operations to bills of materials.'");
	
	ПараметрыПроцедуры = Новый Структура;
	
	ДлительнаяОперацияОбработкаДанных = ДлительныеОперации.ВыполнитьВФоне(
		"Обработки.ПомощникПереносаОперацийВРесурсныеСпецификации.ОбъединениеСправочниковВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъединениеСправочниковЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперацияОбработкаДанных = Неопределено;
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		
		РезультатЗадания = ОбработатьРезультатОбъединенияСправочников(Результат);
		
		Если РезультатЗадания.ЕстьОшибки Тогда
					
			Сообщение = НСтр("ru = 'Завершен с ошибками.
			|	Подробности см. в журнале регистрации';
			|en = 'Completed with errors.
			|	See event log for details.'");
			Картинка  = БиблиотекаКартинок.Ошибка32;
			
		Иначе
			
			МассивТекстов = Новый Массив;
			МассивТекстов.Добавить(НСтр("ru = 'Завершен успешно.';
										|en = 'Completed successfully.'"));
			МассивТекстов.Добавить(СтрШаблон(НСтр("ru = 'Обработано спецификаций: %1';
													|en = 'Bills of materials processed: %1'"), РезультатЗадания.ОбработаноСпецификаций));
			Если РезультатЗадания.ПеренесеноОпераций > 0 Тогда
				МассивТекстов.Добавить(СтрШаблон(НСтр("ru = 'Перенесено операций: %1';
														|en = 'Operations transferred: %1'"), РезультатЗадания.ПеренесеноОпераций));
			КонецЕсли;
			Если РезультатЗадания.ПодключеноТехпроцессов > 0 Тогда
				МассивТекстов.Добавить(СтрШаблон(НСтр("ru = 'Подключено технологических процессов: %1';
														|en = 'Technological processes attached: %1'"), РезультатЗадания.ПодключеноТехпроцессов));
			КонецЕсли;
			
			Сообщение = СтрСоединить(МассивТекстов, Символы.ПС);
			Картинка  = БиблиотекаКартинок.Информация32;
			
			ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
			
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Перенос операций';
											|en = 'Transferring operations'"),,
			Сообщение,
			Картинка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьРезультатОбъединенияСправочников(ДлительнаяОперация)
	
	Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
	
	Если НЕ Результат.ЕстьОшибки Тогда
		
		ОтметкаШаг_2 = Истина;
		Константы.ХранитьОперацииВРесурсныхСпецификациях.Установить(Истина);
		
	КонецЕсли;
	
	Элементы.ГруппаШаг2_Обработка.ТекущаяСтраница = Элементы.ГруппаШаг2_Обработка_Пустая;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОтключениеИспользованияМаршрутныхКарт

&НаСервере
Процедура ОтключитьИспользованиеМаршрутныхКартНаСервере()
	
	Константы.ИспользоватьМаршрутныеКарты.Установить(Ложь);
	
	Константы.ХранитьОперацииВРесурсныхСпецификациях.Установить(Истина);
	Константы.ИспользоватьТехнологическиеПроцессы.Установить(Истина);
	
	ОтметкаШаг_3 = Истина;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ВариантОтбораМаршрутныхКарт    = ВариантОтбораМаршрутныхКартМногократноИспользуемые();
	
	НадписьНетКонфликтов           = НСтр("ru = 'Поиск конфликтов не производился';
											|en = 'Conflict search was not performed'");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьТехнологическиеПроцессы") Тогда
		ОтметкаШаг_1 = Истина;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ХранитьОперацииВРесурсныхСпецификациях") Тогда
		ОтметкаШаг_1 = Истина;
		ОтметкаШаг_2 = Истина;
	КонецЕсли;
	
	НастроитьЗависимыеЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Элементы = Форма.Элементы;
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Если СтруктураРеквизитов.Свойство("Отметки")
		ИЛИ Инициализация Тогда
			
		Шаги = ПоследовательностьШагов();
		Для каждого Шаг Из Шаги Цикл
			ГруппаШаг = Элементы["ГруппаОтметкаШаг"+Шаг];
			Если ШагДоступен(Форма, Шаг) Тогда
				Если Форма["ОтметкаШаг_"+Шаг] = Истина Тогда
					ГруппаШаг.ТекущаяСтраница = Элементы["СтраницаГотовоШаг"+Шаг];
				Иначе
					ГруппаШаг.ТекущаяСтраница = Элементы["СтраницаНеГотовоШаг"+Шаг];
				КонецЕсли;
			Иначе
				ГруппаШаг.ТекущаяСтраница = Элементы["СтраницаНедоступноШаг"+Шаг];
			КонецЕсли;
		КонецЦикла;
			
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("СозданиеТиповыхТехнологическихПроцессов")
		ИЛИ Инициализация Тогда
		
		ЭлементыДоступны = ЭлементыШагаДоступны(Форма, 1);
		
		Элементы.Группа1_2.Доступность = ЭлементыДоступны;
		Элементы.ПроизвольныйОтбор.Видимость = (Форма.ВариантОтбораМаршрутныхКарт = ВариантОтбораМаршрутныхКартПоОтбору());
		Элементы.ГруппаСтраницы1_4.Доступность = ЭлементыДоступны;
		
		Если Форма.ВыбранныеМаршрутныеКартыКоличество > 0 Тогда
			ВыбраноМаршрутныхКарт = СтрШаблон(НСтр("ru = 'Выбрано маршрутных карт (%1)';
													|en = 'Route sheets selected (%1)'"), Форма.ВыбранныеМаршрутныеКартыКоличество);
			Элементы.НадписьВыбраноМаршрутныхКарт.Гиперссылка = Истина;
			Элементы.СоздатьТехнологическиеПроцессы.Доступность = ЭлементыДоступны;
		Иначе
			ВыбраноМаршрутныхКарт = НСтр("ru = 'Нет маршрутных карт для обработки';
										|en = 'No route sheets for processing'");
			Элементы.НадписьВыбраноМаршрутныхКарт.Гиперссылка = Ложь;
			Элементы.СоздатьТехнологическиеПроцессы.Доступность = Ложь;
		КонецЕсли;
		Форма.НадписьВыбраноМаршрутныхКарт = ВыбраноМаршрутныхКарт;
			
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("ОбъединениеСправочников")
		ИЛИ Инициализация Тогда
		
		ЭлементыДоступны = ЭлементыШагаДоступны(Форма, 2);
		
		Элементы.Группа2_2Конфликты.Доступность = ЭлементыДоступны;
		Элементы.ВыполнитьПереносОпераций.Доступность = ЭлементыДоступны;
		
	КонецЕсли;
	
	Если СтруктураРеквизитов.Свойство("ОтключениеИспользованияМаршрутныхКарт")
		ИЛИ Инициализация Тогда
		
		ЭлементыДоступны = ЭлементыШагаДоступны(Форма, 3);
		
		Элементы.Группа3_2.Доступность = ЭлементыДоступны;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти