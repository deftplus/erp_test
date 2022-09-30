
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;
&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ Объект.Ссылка.Пустая()
		И ФорматПоПостановлению735 Тогда 
		ПодключитьОбработчикОжидания("Подключаемый_ВосстановитьИзХранилищаЗначения", 0.1, Истина);
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ОрганизацияЗаполнения <> Объект.Организация
		ИЛИ НачалоКвартала(ПериодЗаполнения) <> НачалоКвартала(Объект.НалоговыйПериод) Тогда 
		ТекстВопроса	= НСтр("ru = 'Документ будет перезаполнен. Продолжить?';
								|en = 'The document will be refilled. Continue?'");
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьДокументЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	НайденныеДокументы	= Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.НайтиДокументыЗаНалоговыйПериод(
		Объект.Организация, Объект.НалоговыйПериод, Объект.Дата, 1);
		
	Если НЕ НайденныеДокументы = Неопределено Тогда
		НеобходимоПерезаполнитьДокументы = Истина;
	КонецЕсли;
	
	Если ЗаписыватьВХранилищеЗначения Тогда 
		ТекущийОбъект.ДополнительныеСвойства.Вставить("АдресДанныхДляПередачи", АдресХранилища);
		ЗаписыватьВХранилищеЗначения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если НеобходимоПерезаполнитьДокументы Тогда
		
		ТекстПредупреждения	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имеются оформленные дополнительные листы книги продаж
				|по периоду %2 с датой позднее %1, 
				|их необходимо перезаполнить';
				|en = 'There are created additional sales ledger sheets
				|for period %2 with a date later than %1, 
				|it is required to refill them'"),
			Формат(Объект.Дата, "ДЛФ=ДД"), 
			ПредставлениеПериода(НачалоКвартала(Объект.НалоговыйПериод), КонецКвартала(Объект.НалоговыйПериод), "ФП = Истина"));
			
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗаписиЗавершение", ЭтотОбъект);
		
		ПоказатьПредупреждение(ОписаниеОповещения, ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Флаг предупреждения сбрасывается в процедуре ПередЗакрытием, а не в обработчике ПослеЗаписиЗавершение,
	// чтобы в обработчике по тому, что флаг сброшен, было понятно, что нужно закрыть форму.
	
	Если НеобходимоПерезаполнитьДокументы Тогда  
		Отказ = Истина;
		НеобходимоПерезаполнитьДокументы = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписиЗавершение(Результат) Экспорт
	
	// В данный обработчик мы можем попасть и при выполнении команды "Записать", и при выполнении команды "Записать и закрыть".
	// Необходимо, чтобы обработчик по-разному отрабатывал в этих ситуациях,
	// т.е. нам необходимо понять, нужно ли закрывать форму. 
	// Для этого используется следующий прием:
	// т.к. при выполнении команды "Записать и закрыть" в процедуру ПередЗакрытием мы попадаем раньше, 
	// чем в обработчик оповещения, то мы можем сбрасывать флаг предупреждения в ней, а не в обработчике.
	// А в обработчике по тому, что флаг сброшен, мы понимаем, что отработало ПередЗакрытием и нужно закрыть форму.
	
	Если НЕ НеобходимоПерезаполнитьДокументы Тогда
		Закрыть();
	Иначе
		НеобходимоПерезаполнитьДокументы = Ложь;
	КонецЕсли;	

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	УстановитьСостояниеДокумента();
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда 
		Объект.ТабличнаяЧасть.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеорганизацияПриИзменении(Элемент)
	
	УстановитьПериодПоСКНП();
	
КонецПроцедуры

#КонецОбласти
 
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьДокумент(Команда)

	Результат = ЗаполнитьДокументНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийПериод(Команда)

	ИзменитьПериод(-1);

КонецПроцедуры

&НаКлиенте
Процедура СледующийПериод(Команда)

	ИзменитьПериод(1);

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
	УправлениеФормой(ЭтаФорма);
	ОрганизацияЗаполнения 	= Объект.Организация;
	ПериодЗаполнения 		= Объект.НалоговыйПериод;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВосстановитьИзХранилищаЗначения()
	
	Результат = ВосстановитьИзХранилищаЗначенияНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВосстановитьИзХранилищаЗначенияНаСервере()
	
	ПараметрыДляЗаполнения = Новый Структура;
	ПараметрыДляЗаполнения.Вставить("ДокументСсылка", 				Объект.Ссылка);
	НаименованиеЗадания = НСтр("ru = 'Открытие документа ""Доп. лист книги продаж для передачи в электронном виде""';
								|en = 'Open document ""Additional sales ledger sheet for electronic filing""'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
	УникальныйИдентификатор,
	"Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ВосстановитьДанныеДляОтправки", 
	ПараметрыДляЗаполнения, 
	НаименованиеЗадания);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ТаблицаДокумента = ПолучитьИзВременногоХранилища(Результат.АдресХранилища);
		Если ТаблицаДокумента <> Неопределено Тогда 
			ТабличныйДокументФормат4кв2014.Вывести(ТаблицаДокумента);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Форма.ФорматПоПостановлению735       = Объект.НалоговыйПериод >= '20141001';
	Форма.ПредставлениеНалоговогоПериода = ПредставлениеПериода(
		Объект.НалоговыйПериод,
		КонецКвартала(Объект.НалоговыйПериод),
		"ФП = Истина" );
	
	Элементы.ТабличныйДокументФормат4кв2014.Видимость = Форма.ФорматПоПостановлению735;
	Элементы.ТабличнаяЧасть.Видимость                 = НЕ Форма.ФорматПоПостановлению735;
	Элементы.НомерДополнительногоЛиста.Видимость      = НЕ Форма.ФорматПоПостановлению735;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПериод(Шаг)
	
	Если Шаг > 0 Тогда 
		
		Число	= КонецДня(КонецКвартала(Объект.НалоговыйПериод));
		
		Число	= Число + 1;
		Объект.НалоговыйПериод	= НачалоКвартала(Число);
		
	ИначеЕсли Шаг < 0 Тогда 
		
		Число	= НачалоДня(Объект.НалоговыйПериод);
		
		Если Число = Дата(2012, 04, 01) Тогда
			ТекстСообщения	= НСтр("ru = 'Документ может быть составлен только в соответствии с постановлением Правительства Российской Федерации от 26 декабря 2011 г. № 1137';
									|en = 'The document can be created only according to decree of the Government of the Russian Federation No. 1137 from December 26, 2011'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "ПредставлениеНалоговогоПериода");
			Возврат;
		КонецЕсли;
		
		Число	= Число - 1;
		Объект.НалоговыйПериод	= НачалоКвартала(Число);
		
	КонецЕсли;
	
	Если Объект.ТабличнаяЧасть.Количество() > 0 Тогда 
		Объект.ТабличнаяЧасть.Очистить();
	КонецЕсли;
	
	УстановитьПериодПоСКНП();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПериодПоСКНП()
	
	ПериодПоСКНПНовый = УчетНДСКлиентСервер.ПолучитьКодПоСКНП(Объект.НалоговыйПериод, Объект.Реорганизация);
	
	Если ПериодПоСКНПНовый <> Объект.ПериодПоСКНП Тогда 
		Объект.ПериодПоСКНП = ПериодПоСКНПНовый;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьДокументЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Результат = ЗаполнитьДокументНаСервере();
		
		Если НЕ Результат.ЗаданиеВыполнено Тогда
			ИдентификаторЗадания = Результат.ИдентификаторЗадания;
			АдресХранилища       = Результат.АдресХранилища;
			
			ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		КонецЕсли;
		
	Иначе
		Объект.Организация 		= ОрганизацияЗаполнения;
		Объект.НалоговыйПериод 	= ПериодЗаполнения;
		УправлениеФормой(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДокументНаСервере()

	ПараметрыДляЗаполнения = Новый Структура;
	ПараметрыДляЗаполнения.Вставить("Дата", 					Объект.Дата);
	ПараметрыДляЗаполнения.Вставить("Ссылка", 					Объект.Ссылка);
	ПараметрыДляЗаполнения.Вставить("Организация", 				Объект.Организация);
	ПараметрыДляЗаполнения.Вставить("НалоговыйПериод", 			Объект.НалоговыйПериод);
	ПараметрыДляЗаполнения.Вставить("ПериодПоСКНП", 			Объект.ПериодПоСКНП);
	ПараметрыДляЗаполнения.Вставить("ФорматПоПостановлению735", ФорматПоПостановлению735);
	
	ОрганизацияЗаполнения 	= Объект.Организация;
	ПериодЗаполнения 		= Объект.НалоговыйПериод;
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("НалоговыйПериод", Объект.НалоговыйПериод);
	СтруктураПараметров.Вставить("Организация", Объект.Организация);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	
	НаименованиеЗадания = НСтр("ru = 'Заполнение документа ""Доп. лист книги продаж для передачи в электронном виде""';
								|en = 'Fill in document ""Additional sales ledger sheet for electronic filing""'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Документы.ДопЛистКнигиПродажДляПередачиВЭлектронномВиде.ПодготовитьДанныеДляЗаполнения", 
		ПараметрыДляЗаполнения, 
		НаименованиеЗадания);
	
	АдресХранилища = Результат.АдресХранилища;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	РазделыОтчета 	= ПроверкаКонтрагентов.РазделыОтчета(СтруктураДанных);
		
	Если ФорматПоПостановлению735 Тогда
		
		ЗаписыватьВХранилищеЗначения = Истина;
		ТабличныйДокументФормат4кв2014.Очистить();
		Если РазделыОтчета.Количество() > 0 Тогда
			ТабличныйДокументФормат4кв2014.Вывести(РазделыОтчета[0].ХранилищеОтчета.Получить());
		КонецЕсли;
		
	Иначе
		
		Если СтруктураДанных.Свойство("РеквизитыДокумента") Тогда
			ЗаполнитьЗначенияСвойств(Объект, СтруктураДанных.РеквизитыДокумента);
		КонецЕсли;
		
		Если СтруктураДанных.Свойство("ТабличнаяЧасть") Тогда
			Объект.ТабличнаяЧасть.Загрузить(СтруктураДанных.ТабличнаяЧасть);
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДокумент(Команда)
	
	Если Не ПроверитьЗаполнениеНаСервере() Тогда
		Возврат;
	КонецЕсли;
	
	ВыгружаемыеДанные = ВыгрузитьНаСервере(УникальныйИдентификатор);
	
	Если ВыгружаемыеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	#Если НЕ ВебКлиент Тогда
		ПутьВыгрузки = РегламентированнаяОтчетностьКлиент.ПолучитьПутьВыгрузки();
		Если ПутьВыгрузки = Ложь Тогда
			Возврат;
		КонецЕсли;
	#КонецЕсли
	
	Для Каждого ФайлВыгрузки Из ВыгружаемыеДанные Цикл
		
		#Если ВебКлиент Тогда
			Попытка
				ПолучитьФайл(ФайлВыгрузки.АдресФайлаВыгрузки, ФайлВыгрузки.ИмяФайлаВыгрузки);
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось записать файл ""%1"". Возможно, недостаточно места на диске, диск защищен от записи или не подключено расширение для работы с файлами.';
										|en = 'Cannot save file ""%1"". There may not be enough space on the hard drive, the hard drive is write protected, or file system extension is not attached.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки);
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
			КонецПопытки;
		#Иначе
			ДвоичныйФайл = ПолучитьИзВременногоХранилища(ФайлВыгрузки.АдресФайлаВыгрузки);
			Попытка
				ДвоичныйФайл.Записать(ПутьВыгрузки + ФайлВыгрузки.ИмяФайлаВыгрузки);
				
				ТекстСообщения = НСтр("ru = 'Файл выгрузки регламентированного отчета ""%1"" сохранен в каталог ""%2"".';
										|en = 'Export file of local report ""%1"" is saved to directory ""%2"".'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки, ПутьВыгрузки);
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
			Исключение
				ТекстСообщения = НСтр("ru = 'Не удалось записать файл ""%1"". Возможно, недостаточно места на диске или диск защищен от записи.';
										|en = 'Cannot save file ""%1"". There may not be enough space on the hard drive, or the hard drive is write protected.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ФайлВыгрузки.ИмяФайлаВыгрузки);
				
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
			КонецПопытки;
		#КонецЕсли
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеНаСервере()

	Возврат ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Функция ВыгрузитьНаСервере(УникальныйИдентификатор)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ОбъектДокумента = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектДокумента.ВыгрузитьДокумент(УникальныйИдентификатор);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

#КонецОбласти
