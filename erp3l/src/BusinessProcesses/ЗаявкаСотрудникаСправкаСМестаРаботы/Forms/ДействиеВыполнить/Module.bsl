
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Ссылка = Объект.Ссылка;
	Если Ссылка.Пустая() Тогда
		ИнициализироватьФормуЗадачи();
	КонецЕсли;
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
			
	Если Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьКнопокДействий();
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ПараметрыГиперссылки = МодульРаботаСФайлами.ГиперссылкаФайлов();
		ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
		ПараметрыГиперссылки.Владелец = "Объект.БизнесПроцесс";
		МодульРаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами

	Если ЗначениеЗаполнено(Задание.УдалитьФайлОтвета) Тогда
		ВызватьИсключение НСтр("ru = 'Заявка не доступна до окончания обновления.';
								|en = 'The request is not available till the update is finished.'");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаписатьРеквизитыБизнесПроцесса(ЭтотОбъект, ТекущийОбъект);
		
	ВыполнитьЗадачу = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыЗаписи, "ВыполнитьЗадачу", Ложь);
	Если НЕ ВыполнитьЗадачу Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗаданиеВыполнено И НЕ ЗначениеЗаполнено(ТекущийОбъект.РезультатВыполнения) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Укажите причину, по которой задача отклоняется.';
				|en = 'Specify the reason why the task is declined.'"),,
			"Объект.РезультатВыполнения",,
			Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	Если ИмяСобытия = "Запись_Задание" Тогда
		Если (Источник = Объект.БизнесПроцесс ИЛИ (ТипЗнч(Источник) = Тип("Массив") 
			И Источник.Найти(Объект.БизнесПроцесс) <> Неопределено)) Тогда
			Прочитать();
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ШаблонОтветаЗаписанСправочник" Тогда
		Если (Источник = ЭтотОбъект) Тогда
			ШаблонОтвета = Параметр;
			Элементы.ШаблонОтвета.Видимость = Истина;
			ШаблонОтветаПриИзмененииНаСервере();
		КонецЕсли;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСФайлами
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализироватьФормуЗадачи();
	Элементы.Содержание.Заголовок = ЗаданиеСодержание;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ШаблонОтветаПриИзменении(Элемент)
	ШаблонОтветаПриИзмененииНаСервере();	
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент,
			ПараметрыПеретаскивания, СтандартнаяОбработка);
	КонецЕсли;	
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполненоВыполнить(Команда)
	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ВыполненоВыполнитьЗавершение");
	Иначе
		ВыполненоВыполнитьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отказать(Команда)
	
	Отказ = Ложь;
	ОтказатьНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	Если ПодписыватьЗаявкиСотрудника Тогда
		БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЗаявкуЭП(ЭтотОбъект, "ОтказатьЗавершение");
	Иначе
		ОтказатьЗавершение(Неопределено, Неопределено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Дополнительно(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.ПринятьЗадачуКИсполнению(ЭтотОбъект, ТекущийПользователь);
	УстановитьВидимостьКнопокДействий();
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Ссылка));
	Прочитать();
	БизнесПроцессыИЗадачиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗадание(Команда)
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;	
	ПоказатьЗначение(,Объект.БизнесПроцесс);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыбратьФайлОтвета(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ЗавершениеВыбратьФайлОтвета", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.Диалог.Фильтр = 
		НСтр("ru = 'Файлы MS Word (*.doc;*.docx)|*.doc;*.docx|Файлы PDF(*.pdf;*.PDF)|*.pdf;*.PDF|
			 |Архив (*.zip;*.rar;*.7z)|*.zip;*.rar;*.7z';
			 |en = 'MS Word files (*.doc;*.docx)|*.doc;*.docx|PDF files(*.pdf;*.PDF)|*.pdf;*.PDF|
			 |Archive (*.zip;*.rar;*.7z)|*.zip;*.rar;*.7z'");

	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;

	ФайловаяСистемаКлиент.ЗагрузитьФайл(Обработчик, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдалитьФайлНажатие(Элемент)
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьПрисоединенныйФайлЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Справка будет удалена. Удалить?';
											|en = 'The statement will be deleted. Delete?'"), РежимДиалогаВопрос.ДаНет);	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ФайлНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьПрисоединенныйФайл(ЭтотОбъект[Элемент.Имя]);	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайл(Команда)
	СформироватьФайлНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПодписатьЭП(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьПодписатьЭП",
												  ЭтотОбъект,
												  Новый Структура("ПечатныеФормыОбъектов"));
												  ФайлыСправок = Новый Массив;
												  
	ФайлОтветаПоЗаявке = ФайлОтвета();
	БизнесПроцессыЗаявокСотрудниковКлиент.ПодписатьЭПФайлыОтвета(ЭтотОбъект, 
																 ОписаниеОповещения,
																 ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФайлОтветаПоЗаявке),
																 ЭтоФайлПечатнойФормы(ФайлОтветаПоЗаявке));
																 
КонецПроцедуры

&НаКлиенте
Процедура СохранитьШаблонОтвета(Команда)
	БизнесПроцессыЗаявокСотрудниковКлиент.СохранитьШаблонОтвета(ЭтотОбъект);
КонецПроцедуры

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиКлиент");
		МодульРаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеОбработчикиСобытийЭлементовШапкиФормы

&НаСервере
Процедура ШаблонОтветаПриИзмененииНаСервере()
	БизнесПроцессыЗаявокСотрудниковФормы.ПослеВыбораШаблона(ЭтотОбъект, ШаблонОтвета, Неопределено);
КонецПроцедуры

#КонецОбласти

#Область СерверныеОбработчикиКомандФормы

&НаСервере
Процедура ОтказатьНаСервере(Отказ)
	Если ПустаяСтрока(Задание.ОтветПоЗаявке)
		 И Не КабинетСотрудника.ВерсияПриложенияМеньшеВерсии("3.0.2.19") Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не заполнена причина отказа.';
													|en = 'The refusal reason is not filled in.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОповещения

&НаКлиенте
Процедура ВыполненоВыполнитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	БизнесПроцессыЗаявокСотрудниковКлиент.ВыполненоВыполнитьЗавершение(ЭтотОбъект, Результат, ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОтказатьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		 И Результат.Свойство("Отказ")
		 И Результат.Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	ОтказатьЗавершениеНаСервере(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры	

&НаКлиенте
Процедура УдалитьПрисоединенныйФайлЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьПрисоединенныйФайлЗавершениеНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбратьФайлОтвета(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Данные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
	Если Данные.Размер() > КабинетСотрудникаКлиент.МаксимальныйРазмерПринимаемогоФайла() Тогда
		ПоказатьПредупреждение(,
			НСтр("ru = 'Сервис не может принять файлы размером более 5Мб. Выберите другой файл.';
				|en = 'The service cannot accept files larger than 5MB. Choose another file.'"));
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ЗавершениеВыбратьФайлОтветаНаСервере(ПомещенныйФайл);	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьПодписатьЭП(Результат, ДополнительныеПараметры) Экспорт
	ЗавершитьПодписатьЭПНаСервере();	 	
КонецПроцедуры

#КонецОбласти

#Область РаботаСФайлами

&НаСервере
Процедура СформироватьФайлНаСервере()
	
	КадровыеДанные = КадровыеДанныеДляЗапросовСправокСРаботы(Задание);
	Отбор = Новый Структура("ФизическоеЛицо,Организация", Задание.ФизическоеЛицо, Задание.Организация);
	НайденныеСтроки = КадровыеДанные.НайтиСтроки(Отбор);
	
	СотрудникиФизическогоЛица = Новый Массив;
	Для каждого СтрокаТЗ Из НайденныеСтроки Цикл
		Если СтрокаТЗ.ВидСобытия = Перечисления.ВидыКадровыхСобытий.Увольнение Тогда
			Продолжить;
		КонецЕсли;
		СотрудникиФизическогоЛица.Добавить(СтрокаТЗ.Сотрудник);
	КонецЦикла;
	
	СформироватьФайлСправкиСМестаРаботы(Задание.ФизическоеЛицо, СотрудникиФизическогоЛица);
	
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

&НаСервере
Функция СформироватьФайлСправкиСМестаРаботы(ФизическоеЛицо, МассивСотрудников)

	ТабДок = Обработки.ПечатьКадровыхПриказовРасширенная.ПечатнаяФормаСправкаСМестаРаботы(МассивСотрудников);
	
	ФайлОтветаПоЗаявке = ФайлОтвета();
	
	НачатьТранзакцию();
	Попытка
		Если ИспользуетсяКадровыйЭДО Тогда
			
			Если ЗначениеЗаполнено(ФайлОтветаПоЗаявке) Тогда
				КадровыйЭДОВызовСервера.УдалитьФайлыИзОбработкиПользователя(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФайлОтветаПоЗаявке));
			КонецЕсли;
			
			ДанныеПечатнойФормы = КадровыйЭДОВызовСервера.ДобавитьПечатнуюФорму(ТабДок,
														  						Задание.Ссылка,
														  						"СправкаСМестаРаботы"+Задание.Номер,
														  						НСтр("ru = 'Справка с места работы';
																						|en = 'Statement of employment'"),
														  						Задание.Организация,
														 						Задание.ФизическоеЛицо);
																				
			ФайлОтветаПоЗаявке = ДанныеПечатнойФормы.ФайлОбъекта.ПолучитьОбъект();
			ФайлОтветаПоЗаявке.ФайлОтвета = Истина;
			ФайлОтветаПоЗаявке.Записать();
			
		Иначе
			
			Если ЗначениеЗаполнено(ФайлОтветаПоЗаявке) Тогда
				ФайлОтветаПоЗаявкеОбъект = ФайлОтветаПоЗаявке.ПолучитьОбъект();
				ФайлОтветаПоЗаявкеОбъект.ПометкаУдаления = Истина;
				ФайлОтветаПоЗаявкеОбъект.Записать();
			КонецЕсли;
			
			Поток = Новый ПотокВПамяти();
			ТабДок.Записать(Поток, ТипФайлаТабличногоДокумента.PDF);
			ДвоичныеДанные =  Поток.ЗакрытьИПолучитьДвоичныеДанные();
			АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
			
			ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла("Описание, ФайлОтвета");
			ПараметрыФайла.ВладелецФайлов = Задание.Ссылка;
			ПараметрыФайла.ИмяБезРасширения = НСтр("ru = 'Справка с места работы';
													|en = 'Statement of employment'");
			ПараметрыФайла.РасширениеБезТочки = "pdf";
			ПараметрыФайла.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
			ПараметрыФайла.Служебный = Истина;
			ПараметрыФайла.ФайлОтвета = Истина;
			ПараметрыФайла.Описание = НСтр("ru = 'Приложение к заявке:';
											|en = 'Attachment to request:'") + " " + Строка(Задание);
			
			ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресХранилища);
			БизнесПроцессыЗаявокСотрудников.СоздатьИзменитьДокументКЭДОСправкаСотруднику(ПрисоединенныйФайл, Задание.Ссылка)
			
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявка сотрудника справка с места работы.Ошибка формирования файла справки';
										|en = 'Employee request statement of employment. An error occurred while generating the statement file'",
				ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,
			,
			,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось сформировать файл';
													|en = 'Cannot generate file'"));
	КонецПопытки;
	
КонецФункции

&НаСервереБезКонтекста
Функция КадровыеДанныеДляЗапросовСправокСРаботы(Заявка)
	
	ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолучения.КадровыеДанные = "Организация,ВидСобытия";
	ПараметрыПолучения.СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Заявка.ФизическоеЛицо);
	
	УстановитьПривилегированныйРежим(Истина);
	КадровыеДанные = КадровыйУчет.СотрудникиОрганизации(Ложь, ПараметрыПолучения);
	УстановитьПривилегированныйРежим(Ложь);
	КадровыеДанные.Индексы.Добавить("ФизическоеЛицо,Организация");
	
	Возврат КадровыеДанные;

КонецФункции

&НаСервере
Процедура ЗавершениеВыбратьФайлОтветаНаСервере(ПомещенныйФайл)
	
	СтруктураИмениФайла = БизнесПроцессыЗаявокСотрудниковФормы.СтруктураИмениФайла(ПомещенныйФайл.Имя);
	Если СтруктураИмениФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
			
		АдресХранилища = ПомещенныйФайл.Хранение;
		
		ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла("Описание, ФайлОтвета");
		ПараметрыФайла.ВладелецФайлов = Задание.Ссылка;
		ПараметрыФайла.ИмяБезРасширения = СтруктураИмениФайла.ИмяФайлаОтветаБезРасширения;
		ПараметрыФайла.РасширениеБезТочки = СтруктураИмениФайла.РасширениеФайлаОтветаБезТочки;
		ПараметрыФайла.ВремяИзмененияУниверсальное = ТекущаяУниверсальнаяДата();
		ПараметрыФайла.Служебный = Истина;
		ПараметрыФайла.ФайлОтвета = Истина;
		ПараметрыФайла.Описание = НСтр("ru = 'Приложение к заявке:';
										|en = 'Attachment to request:'") + " " + Строка(Задание.Ссылка);
			
		ПрисоединенныйФайл = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресХранилища);
		Если Не ИспользуетсяКадровыйЭДО Тогда
			БизнесПроцессыЗаявокСотрудников.СоздатьИзменитьДокументКЭДОСправкаСотруднику(ПрисоединенныйФайл, Задание.Ссылка);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
	    ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявка сотрудника справка с места работы.Ошибка прикрепления файла справки';
										|en = 'Employee request statement of employment. An error occurred while attaching the statement file'",
									  ОбщегоНазначения.КодОсновногоЯзыка()),
       							 УровеньЖурналаРегистрации.Ошибка,
        						 ,
        						 ,
        						 ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось прикрепить файл';
													|en = 'Cannot attach file'"));
		Возврат;
	КонецПопытки;
	
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПрисоединенныйФайл(ПрисоединенныйФайл)
	БизнесПроцессыЗаявокСотрудниковКлиент.ОткрытьПрисоединенныйФайл(ЭтотОбъект, ПрисоединенныйФайл);	
КонецПроцедуры

&НаСервере
Процедура ОтразитьФайлыОтвета()
	
	ДобавляемыеРеквизиты = Новый Массив;
	ЗначенияРеквизитов = Новый Структура;

	ИмяГруппы = "ГруппаФайлОтвета";
	ИмяРеквизита = "ФайлОтвета";
	
	СтруктураРеквизита = БизнесПроцессыЗаявокСотрудниковФормы.НовыйСтруктураРеквизитаФайлаОтвета();
	СтруктураРеквизита.ИмяРеквизита						= ИмяРеквизита;
	СтруктураРеквизита.ИмяТаблицыПрисоединенногоФайла	= "ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы";
		
	ГруппаФайлОтвета = Элементы.Найти(ИмяГруппы);
	Если ГруппаФайлОтвета = Неопределено Тогда
		БизнесПроцессыЗаявокСотрудниковФормы.ДобавитьЭлементыФайлаОтвета(ЭтотОбъект,
																		 ИмяГруппы,
																		 СтруктураРеквизита,
																		 ДобавляемыеРеквизиты);
		ЭлементВыбратьФайлОтвета = Элементы["Выбрать" + ИмяРеквизита];																 
		ЭлементВыбратьФайлОтвета.Заголовок = НСтр("ru = 'Выбрать файл';
													|en = 'Select file'");
		Элементы.Переместить(ЭлементВыбратьФайлОтвета, Элементы.ГруппаСформироватьИПодписатьФайлы, Элементы.ПодписатьЭП);
	КонецЕсли;

	ФайлОтветаСсылка = ФайлОтвета();
	ФайлОтвета = Элементы[ИмяРеквизита];
	БизнесПроцессыЗаявокСотрудниковФормы.ЗаполнитьЭлементыФайлаОтвета(ЭтотОбъект,
																	  ФайлОтвета,
																	  ФайлОтветаСсылка,
																	  ИмяРеквизита,
																	  ЗначенияРеквизитов);
																	  
																	  
	Если ДобавляемыеРеквизиты.Количество() > 0 Тогда
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	КонецЕсли;	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияРеквизитов);
	
	УстановитьВидимостьКнопокДействий();
	
КонецПроцедуры

&НаСервере
Функция ФайлОтвета() 
	
	Запрос = Новый Запрос();
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы КАК ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы
	               |ГДЕ
	               |	ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	               |	И ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы.ФайлОтвета = ИСТИНА
				   |	И ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы.ПометкаУдаления = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Задание.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.ЗаявкаСотрудникаСправкаСМестаРаботыПрисоединенныеФайлы.ПустаяСсылка();
	
КонецФункции
 
&НаСервере
Процедура ЗавершитьПодписатьЭПНаСервере()
	
	ФайлОтветаПоЗаявке = ФайлОтвета();
	Если Не ЭтоФайлПечатнойФормы(ФайлОтветаПоЗаявке) Тогда
		НачатьТранзакцию();
		Попытка
			БизнесПроцессыЗаявокСотрудников.СоздатьИзменитьДокументКЭДОСправкаСотруднику(ФайлОтветаПоЗаявке, Задание.Ссылка);
			РегистрыСведений.ЗапланированныеДействияСПечатнымиФормами.ЗарегистрироватьОбработкуФайлов(
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФайлОтветаПоЗаявке),
				Перечисления.ДействияСПечатнымиФормами.ПередатьВКабинетСотрудников,
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Исполнитель));
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Заявка сотрудника справка с места работы.Ошибка подписания файла справки';
											|en = 'Employee request statement of employment. An error occurred while signing the statement file'",
										  ОбщегоНазначения.КодОсновногоЯзыка()),
       								 УровеньЖурналаРегистрации.Ошибка,
        							 ,
        							 ,
        							 ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Не удалось подписать файл';
														|en = 'Cannot sign file'"));
			Возврат;
		КонецПопытки;
	КонецЕсли;
			
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЭтоФайлПечатнойФормы(ПрисоединенныйФайл)
	Возврат КадровыйЭДО.ЭтоФайлПечатнойФормы(ПрисоединенныйФайл);	
КонецФункции

&НаСервере
Процедура УдалитьПрисоединенныйФайлЗавершениеНаСервере()
	
	ФайлОтветаОбъект = ФайлОтвета().ПолучитьОбъект();
	ФайлОтветаОбъект.ПометкаУдаления = Истина;
	ФайлОтветаОбъект.Записать();
	
	ОтразитьФайлыОтвета();
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ИнициализироватьФормуЗадачи()
	
	БизнесПроцессыЗаявокСотрудниковФормы.ИнициализироватьФормуЗадачи(ЭтотОбъект);
	ИспользуетсяКадровыйЭДО = ПолучитьФункциональнуюОпцию("ИспользуетсяКадровыйЭДОКабинетСотрудника");
	ОтразитьФайлыОтвета();
	
	Элементы.Содержание.Заголовок = ЗаданиеСодержание;
	Элементы.Содержание.Видимость = НЕ (ЗаданиеСодержание = "");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьКнопокДействий()
	
	БизнесПроцессыЗаявокСотрудниковФормы.УстановитьВидимостьКнопокДействий(ЭтотОбъект, Неопределено, Истина);
	Элементы.ПодписатьЭП.Видимость = 
		(ИспользуетсяКадровыйЭДО 
		 Или (Задание.ВариантФормированияФайлаОтвета = Перечисления.ВариантыФормированияФайлаОтветаЗаявкиСотрудника.ФайлСЭП));
		 
	Если Объект.Выполнена Тогда
		Элементы.СформироватьФайл.Видимость = Ложь;
		Элементы.ПодписатьЭП.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	ФайлОтветаПоЗаявке = ФайлОтвета();
	ФайлСЭП = (Задание.ВариантФормированияФайлаОтвета = ПредопределенноеЗначение("Перечисление.ВариантыФормированияФайлаОтветаЗаявкиСотрудника.ФайлСЭП"));
	ТребуетсяЭП = ИспользуетсяКадровыйЭДО Или ФайлСЭП;
	ФайлПодготовлен = Ложь;
	Если Задание.ВариантФормированияФайлаОтвета.Пустая() Тогда
		ФайлПодготовлен = Истина;
	ИначеЕсли ЗначениеЗаполнено(ФайлОтветаПоЗаявке) Тогда
		Если ТребуетсяЭП Тогда
			ФайлПодготовлен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ФайлОтветаПоЗаявке, "ПодписанЭП");
		Иначе
			ФайлПодготовлен = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.СформироватьФайл.Доступность = Не ЗначениеЗаполнено(ФайлОтветаПоЗаявке);
	Элементы.Выполнено.Доступность = Элементы.Выполнено.Доступность И ФайлПодготовлен;
	Элементы.ПодписатьЭП.Доступность = Не ФайлПодготовлен И ЗначениеЗаполнено(ФайлОтветаПоЗаявке);
	
КонецПроцедуры

&НаСервере
Процедура ОтказатьЗавершениеНаСервере(Отказ)
	
	БизнесПроцессыЗаявокСотрудниковФормы.ОтказатьБизнесПроцессЗаявки(СостояниеЗапроса, Исполнитель);
	
	Если ЗначениеЗаполнено(Комментарий) Тогда
		Объект.РезультатВыполнения = Комментарий;
	Иначе
		Объект.РезультатВыполнения = НСтр("ru = 'Отказ';
											|en = 'Cancel'");
	КонецЕсли;
	
	ЗаданиеВыполнено = Истина;

	// Удаляем документ КЭДО справки с места работы.
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДокументКадровогоЭДО.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.ДокументКадровогоЭДО КАК ДокументКадровогоЭДО
	               |ГДЕ
	               |	ДокументКадровогоЭДО.ОснованиеДокумента = &ЗаявкаСотрудника
	               |	И ДокументКадровогоЭДО.КатегорияДокумента = ЗНАЧЕНИЕ(Перечисление.КатегорииДокументовКадровогоЭДО.СправкаСотруднику)
	               |	И ДокументКадровогоЭДО.ПометкаУдаления = ЛОЖЬ";
		
	Запрос.УстановитьПараметр("ЗаявкаСотрудника", Задание.Ссылка);
		
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДокументКЭДООбъект = Выборка.Ссылка.ПолучитьОбъект();
	    ДокументКЭДООбъект.ПометкаУдаления = Истина;
		ДокументКЭДООбъект.ДополнительныеСвойства.Вставить("РазрешенаПометкаУдаления", Истина);
		ДокументКЭДООбъект.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

