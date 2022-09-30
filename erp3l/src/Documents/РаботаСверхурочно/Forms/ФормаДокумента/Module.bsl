#Область ОписаниеПеременных

&НаКлиенте
Перем ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	Если Параметры.Ключ.Пустая() Тогда
		
		// Создается новый документ.
		ЗначенияДляЗаполнения = Новый Структура("Организация, МесяцРасчета, Ответственный", "Объект.Организация", "Объект.ПериодРегистрации", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ЗаполнитьДанныеФормыПоОрганизации();
		ПриПолученииДанныхНаСервере();
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "СотрудникиСотрудник");
	КонецЕсли; 
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриСозданииНаСервере(ЭтотОбъект, Объект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	ОтражениеЗарплатыВБухучете.УстановитьСписокВыбораОтношениеКЕНВД(Элементы, "ОтношениеКЕНВД");
	ОтражениеЗарплатыВБухучете.УстановитьСписокВыбораОтношениеКЕНВД(Элементы, "СотрудникиОтношениеКЕНВД");
	УстановитьУсловноеОформлениеСотрудники();
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ЗаполнитьФормуПоДаннымОбъекта(ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	ЗаполнитьОбъектПоДаннымФормы(ТекущийОбъект);
	
	Если НЕ ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;
	
	// Переадресуем сообщения с полей объекта на поля формы.
	Колонок = ДниСверхурочнойРаботы.Количество();
	Если Колонок > 0 Тогда
		Сообщения = ПолучитьСообщенияПользователю(Ложь);
		Для Каждого Сообщение Из Сообщения Цикл
			ПозицияИндексаСотрудники = Найти(Сообщение.Поле, "Сотрудники[");
			Если ПозицияИндексаСотрудники > 0 Тогда
				// Заменяем индекс строки.
				ПозицияИндексаСотрудники = ПозицияИндексаСотрудники + 11;
				КонецИндексаСотрудники = Найти(Сообщение.Поле, "]");
				СтрокаИндекса = Сред(Сообщение.Поле, ПозицияИндексаСотрудники, КонецИндексаСотрудники - ПозицияИндексаСотрудники);
				СтрокаВФорме = Цел(Число(СтрокаИндекса)/Колонок);
				Сообщение.Поле = СтрЗаменить(Сообщение.Поле, "Сотрудники[" + СтрокаИндекса + "]", "Сотрудники[" + Строка(СтрокаВФорме) + "]");
				// Указываем верную колонку.
				Если Найти(Сообщение.Поле, ".Дата") > 0 Тогда
					НомерКолонкиВСписке = Число(СтрокаИндекса) - Цел(Число(СтрокаИндекса)/Колонок)*Колонок;
					Если НомерКолонкиВСписке >= 0 Тогда
						ДатаДень = ДниСверхурочнойРаботы[НомерКолонкиВСписке]; 
						Сообщение.Поле = СтрЗаменить(Сообщение.Поле, ".Дата", "." + ИмяКолонкиСтрока(ДатаДень.Значение));
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");	
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки = ОценкаПроизводительностиКлиент.ЗамерВремени();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ЗаполнитьОбъектПоДаннымФормы(ТекущийОбъект);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи, Отказ);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ПослеЗаписиНаСервере(ЭтаФорма);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
	// СтандартныеПодсистемы.КонтрольВеденияУчета
	КонтрольВеденияУчетаБЗК.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.КонтрольВеденияУчета
	
	ЗаполнитьФормуПоДаннымОбъекта(ТекущийОбъект);
	УстановитьДоступностьЭлементов();
	
	ПерерасчетЗарплаты.РегистрацияПерерасчетовПоПредварительнымДаннымВФоне(ТекущийОбъект.Ссылка);
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведениеНеНужнаРегистрацияОшибки, "ПроведениеДокументаРаботаСверхурочно");
	КонецЕсли;
	
	Оповестить("Запись_РаботаСверхурочно", ПараметрыЗаписи, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ПередЗакрытием(ЭтотОбъект, Объект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	КонецЕсли;	
	// Конец ПроцессыОбработкиДокументов
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры
	
#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МесяцНачисленияСтрокойПриИзменении(Элемент)
	
	ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Модифицированность);
	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцНачисленияСтрокойНачалоВыбораЗавершение", ЭтотОбъект);
	ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(ЭтаФорма, ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", , Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт
	
	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой", Направление, Модифицированность);
	ПодключитьОбработчикОжидания("ОбработчикОжиданияМесяцНачисленияПриИзменении", 0.3, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МесяцНачисленияСтрокойОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияМесяцНачисленияПриИзменении()

	ПериодРегистрацииПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуПоСпособуВводаБухучета()
	
	ПоляБухучета = "СтатьяФинансирования,СтатьяРасходов,СпособОтраженияЗарплатыВБухучете,ОтношениеКЕНВД";
	
	Если Объект.БухучетЗаданВСтрокахДокумента Тогда
		Бухучет = Новый Структура(ПоляБухучета);
		ЗаполнитьЗначенияСвойств(Бухучет, Объект);
		БухучетПрежнееЗначение = Новый ФиксированнаяСтруктура(Бухучет);
		ЗаполнитьЗначенияСвойств(Объект, Новый Структура(ПоляБухучета));
	ИначеЕсли БухучетПрежнееЗначение <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Объект, БухучетПрежнееЗначение);
	КонецЕсли;
	
	ПоляБухучета = СтрРазделить(ПоляБухучета,",");
	Для каждого ИмяПоляБухучета Из ПоляБухучета Цикл
	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, ИмяПоляБухучета,
			"Доступность", Не Объект.БухучетЗаданВСтрокахДокумента);
			
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "Сотрудники" + ИмяПоляБухучета,
			"Видимость", Объект.БухучетЗаданВСтрокахДокумента);
	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	УстановитьОтветственныхЛиц();
КонецПроцедуры

&НаКлиенте
Процедура ВремяУчтеноПриИзменении(Элемент)
	ВремяУчтеноПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВремяУчтеноПриИзмененииНаСервере()
	ЗарплатаКадрыРасширенный.УстановитьВторогоОтветственногоВМногофункциональныхДокументах(ЭтаФорма, РегистрацияВремениДоступна);
КонецПроцедуры

&НаКлиенте
Процедура БухучетВСтрокахПриИзменении(Элемент)
	
	Объект.БухучетЗаданВСтрокахДокумента = (БухучетВСтрокахДокумента <> 0);
	ОбновитьФормуПоСпособуВводаБухучета();
	
КонецПроцедуры

// Обработчик подсистемы "ПодписиДокументов".
&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементПриИзменении(Элемент) 
	ПодписиДокументовКлиент.ПриИзмененииПодписывающегоЛица(ЭтаФорма, Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПодписиДокументовЭлементНажатие(Элемент) 
	ПодписиДокументовКлиент.РасширеннаяПодсказкаНажатие(ЭтаФорма, Элемент.Имя);
КонецПроцедуры
// Конец Обработчик подсистемы "ПодписиДокументов".

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиПриИзменении(Элемент)
	Если РегистрацияВремениДоступна Тогда 
		УстановитьСвойствоВремяУчтено();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбработкаПодбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДниСверхурочнойРаботы

&НаКлиенте
Процедура ДниСверхурочнойРаботыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьДатыСервер(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДниСверхурочнойРаботыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СтруктураПараметровВыбора = Новый Структура;
	СтруктураПараметровВыбора.Вставить("ПериодРегистрации", Объект.ПериодРегистрации);
	СтруктураПараметровВыбора.Вставить("МассивДат", ДниСверхурочнойРаботы.ВыгрузитьЗначения());
	СтруктураПараметровВыбора.Вставить("Подсказка", НСтр("ru = 'Выберите даты сверхурочной работы';
														|en = 'Select dates of overtime work'"));
	
	ОткрытьФорму("ОбщаяФорма.ВыборДат", СтруктураПараметровВыбора, Элемент);
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДниСверхурочнойРаботыПослеУдаления(Элемент)
	
	ДниСверхурочнойРаботыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДниСверхурочнойРаботыЗначениеПриИзменении(Элемент)
	
	ДниСверхурочнойРаботыПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#Область ОбработчикиСобытийПроцессыОбработкиДокументов

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокумента(Команда)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Команда, Объект)
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьЗадачуПоОбработкеДокументаОповещение(Контекст, ДополнительныеПараметры) Экспорт
	ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст);
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Контекст);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗадачуПоОбработкеДокументаНаСервере(Контекст)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначения.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплата");
		МодульПроцессыОбработкиДокументовЗарплата.ВыполнитьЗадачу(ЭтотОбъект, Контекст, Объект);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийНаправившегоОткрытие(Элемент, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийНаправившегоОткрытие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КомментарийСледующемуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	// ПроцессыОбработкиДокументов
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ПроцессыОбработкиДокументовЗарплата") Тогда	
		МодульПроцессыОбработкиДокументовЗарплата = ОбщегоНазначенияКлиент.ОбщийМодуль("ПроцессыОбработкиДокументовЗарплатаКлиент");
		МодульПроцессыОбработкиДокументовЗарплата.КомментарийСледующемуНачалоВыбора(ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	КонецЕсли;		
	// Конец ПроцессыОбработкиДокументов
КонецПроцедуры

#КонецОбласти

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

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОткрытия = Неопределено;
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		ПараметрыОткрытия = Новый Структура("ВключатьВедомственныхВоенных", Истина);
		Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("ГосударственнаяСлужбаКлиент");
		Модуль.УточнитьПараметрыОткрытияФормыВыбораСотрудников(ПараметрыОткрытия);
	КонецЕсли; 
		
	ДатаНачала = Объект.ПериодРегистрации;
	ДатаОкончания = КонецМесяца(ДатаНачала);
	
	КадровыйУчетКлиент.ВыбратьСотрудниковРаботающихВПериодеПоПараметрамОткрытияФормыСписка(
		Элементы.Сотрудники,
		Объект.Организация,
		,
		ДатаНачала,
		ДатаОкончания,
		Истина,
		АдресСпискаПодобранныхСотрудников(),
		ПараметрыОткрытия);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтрольВеденияУчета

&НаКлиенте
Процедура Подключаемый_ОткрытьОтчетПоПроблемам(ЭлементИлиКоманда, НавигационнаяСсылка, СтандартнаяОбработка)
	
	КонтрольВеденияУчетаКлиентБЗК.ОткрытьОтчетПоПроблемамОбъекта(ЭтотОбъект, Объект.Ссылка, СтандартнаяОбработка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтрольВеденияУчета

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = Объект;
	КонецЕсли;
	
	УстановитьДоступностьРегистрацииВремени();
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	УстановитьДоступностьЭлементов();
	ЗарплатаКадрыРасширенный.УстановитьВторогоОтветственногоВМногофункциональныхДокументах(ЭтаФорма, РегистрацияВремениДоступна);
	
	БухучетВСтрокахДокумента = ?(ТекущийОбъект.БухучетЗаданВСтрокахДокумента, 1, 0);
	ОбновитьФормуПоСпособуВводаБухучета();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораНаСервере(МассивСотрудников)
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл
		Если Сотрудники.НайтиСтроки(Новый Структура("Сотрудник", Сотрудник)).Количество() = 0 Тогда
			СтрокаТаблицы = Сотрудники.Добавить();
			СтрокаТаблицы.Сотрудник = Сотрудник;
			СтрокаТаблицы.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.ПовышеннаяОплата");
		КонецЕсли;	
	КонецЦикла;	
		
КонецПроцедуры

&НаСервере
Процедура ДобавитьДатыСервер(ДатыСверхурочнойРаботы)
	
	ДниСверхурочнойРаботы.ЗагрузитьЗначения(ДатыСверхурочнойРаботы);
	ДниСверхурочнойРаботыПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКолонкиТаблицыСотрудники(МассивДат)
	
	// Формирование массива имен колонок таблицы Сотрудники.
	РеквизитыТаблицыСотрудники = ПолучитьРеквизиты("Сотрудники");
	
	ИменаКолонок = Новый Массив;
	
	Для Каждого РеквизитТаблицы Из РеквизитыТаблицыСотрудники Цикл 
		ИменаКолонок.Добавить(РеквизитТаблицы.Имя);
	КонецЦикла;
	
	// Добавление реквизитов формы.
	ДобавляемыеРеквизиты = Новый Массив;
	
	ПараметрыЧисла = Новый КвалификаторыЧисла(7, 2, ДопустимыйЗнак.Неотрицательный);
	
	Для Каждого ДатаРаботы Из МассивДат Цикл 
		
		Если ДатаРаботы = '00010101' Тогда 
			Продолжить;
		КонецЕсли;	
		
		ИмяКолонки = ИмяКолонкиСтрока(ДатаРаботы);
        ЗаголовокКолонки = Формат(ДатаРаботы, "ДЛФ=Д");
		
		Если ИменаКолонок.Найти(ИмяКолонки) = Неопределено Тогда 
			РеквизитФормы = Новый РеквизитФормы(ИмяКолонки, Новый ОписаниеТипов("Число", ПараметрыЧисла), "Сотрудники", ЗаголовокКолонки, Истина); 
			ДобавляемыеРеквизиты.Добавить(РеквизитФормы);
		КонецЕсли;
		
	КонецЦикла;

	ИзменитьРеквизиты(ДобавляемыеРеквизиты);

	// Добавление элементов формы
	Для Каждого РеквизитФормы Из ДобавляемыеРеквизиты Цикл 
		
		СледующийЭлемент = СледующийЭлементТаблицыСотрудники(РеквизитФормы.Имя);
		
		Элемент = Элементы.Вставить(РеквизитФормы.Имя, Тип("ПолеФормы"), Элементы.СотрудникиДаты, СледующийЭлемент); 
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Сотрудники." + РеквизитФормы.Имя;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СледующийЭлементТаблицыСотрудники(ИмяНовойКолонки)

	Для Каждого Колонка Из Элементы.СотрудникиДаты.ПодчиненныеЭлементы Цикл
		Если Лев(Колонка.Имя, 4) = "Дата" И ИмяНовойКолонки < Колонка.Имя Тогда 
			Возврат Колонка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ДниСверхурочнойРаботыПриИзмененииНаСервере()
	
	РеквизитыТаблицыСотрудники = ПолучитьРеквизиты("Сотрудники");
	
	ИменаКолонок = Новый Структура;
	
	Для Каждого РеквизитТаблицы Из РеквизитыТаблицыСотрудники Цикл
		Если Лев(РеквизитТаблицы.Имя, 4) = "Дата" Тогда 
			ИменаКолонок.Вставить(РеквизитТаблицы.Имя, Истина);
		КонецЕсли;
	КонецЦикла;
	
	ДобавленныеДаты = Новый Массив;
	
	Для Каждого ЭлементСписка Из ДниСверхурочнойРаботы Цикл 
		
		ДатаРаботы = ЭлементСписка.Значение;
		
		Если ДатаРаботы = '00010101' Тогда
			ЭлементСписка.Представление = Формат(ДатаРаботы, "ДЛФ=Д");
			Продолжить;
		КонецЕсли;	
		
		ИмяКолонки = ИмяКолонкиСтрока(ДатаРаботы);
		Если ИменаКолонок.Свойство(ИмяКолонки) Тогда
			ИменаКолонок.Удалить(ИмяКолонки);
		Иначе
			ДобавленныеДаты.Добавить(ДатаРаботы);
			ЭлементСписка.Представление = Формат(ДатаРаботы, "ДЛФ=Д");
		КонецЕсли;
		
	КонецЦикла;
	
	Если ДобавленныеДаты.Количество() > 0 Тогда 
		ДниСверхурочнойРаботы.СортироватьПоЗначению();
		ДобавитьКолонкиТаблицыСотрудники(ДобавленныеДаты);
		УстановитьДоступностьЭлементов();
	КонецЕсли;
	
	УдаляемыеРеквизиты = Новый Массив;
	
	Для Каждого КлючИЗначение Из ИменаКолонок Цикл 
		
		ПутьКРеквизиту = "Сотрудники." + КлючИЗначение.Ключ;
		УдаляемыеРеквизиты.Добавить(ПутьКРеквизиту);
		
		Элемент = Элементы.Найти(КлючИЗначение.Ключ);
		Если Элемент <> Неопределено Тогда 
			Элементы.Удалить(Элемент);
		КонецЕсли;
		
	КонецЦикла;

	ИзменитьРеквизиты(, УдаляемыеРеквизиты);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектПоДаннымФормы(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущийОбъект.Сотрудники.Очистить();
	
	ПоляБухучета = "";
	Если ТекущийОбъект.БухучетЗаданВСтрокахДокумента Тогда
		ПоляБухучета = "СтатьяФинансирования,СтатьяРасходов,СпособОтраженияЗарплатыВБухучете,ОтношениеКЕНВД";
	КонецЕсли;
	
	ДниРаботы = Новый Структура;
	
	Для Каждого ЭлементСписка Из ДниСверхурочнойРаботы Цикл 
		ДниРаботы.Вставить(ИмяКолонкиСтрока(ЭлементСписка.Значение), ЭлементСписка.Значение);
	КонецЦикла;
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл 
		
		Для Каждого ДеньРаботы Из ДниРаботы Цикл 
			
			НоваяСтрока = ТекущийОбъект.Сотрудники.Добавить();
			НоваяСтрока.СпособКомпенсацииПереработки = СтрокаТаблицы.СпособКомпенсацииПереработки;
			НоваяСтрока.Сотрудник 		= СтрокаТаблицы.Сотрудник;
			НоваяСтрока.Дата 			= ДеньРаботы.Значение;
			НоваяСтрока.ОтработаноЧасов = СтрокаТаблицы[ДеньРаботы.Ключ];
			
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы, ПоляБухучета);
			
		КонецЦикла;
		
		Если ДниРаботы.Количество() = 0 Тогда 
			НоваяСтрока = ТекущийОбъект.Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = СтрокаТаблицы.Сотрудник;
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы, ПоляБухучета);
		КонецЕсли;	
		
	КонецЦикла;
	
	Если Сотрудники.Количество() = 0 Тогда 
		Для Каждого ДеньРаботы Из ДниРаботы Цикл 
			НоваяСтрока = ТекущийОбъект.Сотрудники.Добавить();
			НоваяСтрока.Дата = ДеньРаботы.Значение;
		КонецЦикла;
	КонецЕсли;
	
	ТекущийОбъект.ДатаНачалаСобытия = ?(ДниСверхурочнойРаботы.Количество() > 0, ДниСверхурочнойРаботы[0].Значение, Объект.ПериодРегистрации);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоДаннымОбъекта(ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДниСверхурочнойРаботы.Очистить();
	Сотрудники.Очистить();
	
	ДниРаботы = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийОбъект.Сотрудники, "Дата", Истина);
	Для каждого ДеньРаботы Из ДниРаботы Цикл
		ДниСверхурочнойРаботы.Добавить(ДеньРаботы, Формат(ДеньРаботы, "ДЛФ=Д"));
	КонецЦикла;
	ДобавитьКолонкиТаблицыСотрудники(ДниСверхурочнойРаботы.ВыгрузитьЗначения());
	
	СтрокиСотрудников 	= Новый Соответствие;
	СотрудникиДокумента = Новый Массив;
	Для каждого СтрокаТЧ Из ТекущийОбъект.Сотрудники Цикл
		Если СотрудникиДокумента.Найти(СтрокаТЧ.Сотрудник) = Неопределено Тогда
			СотрудникиДокумента.Добавить(СтрокаТЧ.Сотрудник);
		КонецЕсли;
		СтрокиСотрудника = СтрокиСотрудников[СтрокаТЧ.Сотрудник];
		Если СтрокиСотрудника = Неопределено Тогда
			СтрокиСотрудникаПоСпособуКомпенсации = Новый Массив;
			СтрокиСотрудника = Новый Соответствие;
			СтрокиСотрудника.Вставить(СтрокаТЧ.СпособКомпенсацииПереработки, СтрокиСотрудникаПоСпособуКомпенсации);
			СтрокиСотрудников.Вставить(СтрокаТЧ.Сотрудник, СтрокиСотрудника);
		Иначе
			СтрокиСотрудникаПоСпособуКомпенсации = СтрокиСотрудника[СтрокаТЧ.СпособКомпенсацииПереработки];
			Если СтрокиСотрудникаПоСпособуКомпенсации = Неопределено Тогда
				СтрокиСотрудникаПоСпособуКомпенсации = Новый Массив;
				СтрокиСотрудника.Вставить(СтрокаТЧ.СпособКомпенсацииПереработки, СтрокиСотрудникаПоСпособуКомпенсации);
			КонецЕсли;
		КонецЕсли;
		СтрокиСотрудникаПоСпособуКомпенсации.Добавить(СтрокаТЧ);
	КонецЦикла;
	
	Для каждого СотрудникДокумента Из СотрудникиДокумента Цикл
		
		СтрокиСотрудника = СтрокиСотрудников[СотрудникДокумента];
		Для каждого СтрокиПоСпособуКомпенсации Из СтрокиСотрудника Цикл
			
			НоваяСтрока = Сотрудники.Добавить();
			НоваяСтрока.Сотрудник = СотрудникДокумента;
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокиПоСпособуКомпенсации.Значение[0]);
			
			Для каждого СтрокаТЧ Из СтрокиПоСпособуКомпенсации.Значение Цикл
				Если ЗначениеЗаполнено(СтрокаТЧ.Дата) Тогда 
					НоваяСтрока[ИмяКолонкиСтрока(СтрокаТЧ.Дата)] = СтрокаТЧ.ОтработаноЧасов;
				КонецЕсли;
			КонецЦикла;
		
		КонецЦикла;
		
	КонецЦикла;
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяКолонкиСтрока(Период)
	
	Возврат "Дата" + Формат(Период, "ДФ=""ггггММдд""");

КонецФункции

&НаСервере
Процедура УстановитьДоступностьРегистрацииВремени()
	РегистрацияВремениДоступна = МногофункциональныеДокументыБЗК.ЕстьПравоНаДокумент(
		ЭтотОбъект.Объект,
		МногофункциональныеДокументыБЗККлиентСервер.ВидыПравНаРазделыДанных().Редактирование, 
		МногофункциональныеДокументыБЗККлиентСервер.РазделыДанных().РабочееВремя);
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	Для Каждого Колонка Из Элементы.СотрудникиДаты.ПодчиненныеЭлементы Цикл
		Если Лев(Колонка.Имя, 4) = "Дата" Тогда 
			Колонка.ТолькоПросмотр = Не РегистрацияВремениДоступна;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "СотрудникиБухучет",
			"Доступность", РегистрацияВремениДоступна И ИспользуетсяРасчетЗарплаты);
			
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, "БухучетВСтроках",
			"Доступность", РегистрацияВремениДоступна И ИспользуетсяРасчетЗарплаты);
	
	Если ИспользуетсяРасчетЗарплаты И Не РегистрацияВремениДоступна И Объект.ВремяУчтено Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Элементы.ИнфоНадпись.Видимость = ИспользуетсяРасчетЗарплаты И Не РегистрацияВремениДоступна И Объект.ВремяУчтено;
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьСвойствоВремяУчтено()
	
	Если РегистрацияВремениДоступна Тогда 
		Объект.ВремяУчтено = Истина;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.УстановитьВторогоОтветственногоВМногофункциональныхДокументах(ЭтаФорма, РегистрацияВремениДоступна);
	
КонецПроцедуры	

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(Сотрудники.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	ЗаполнитьДанныеФормыПоОрганизации();
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтветственныхЛиц()
	
	Если Не ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	// ЗарплатаКадрыПодсистемы.ПодписиДокументов
	ПодписиДокументов.ЗаполнитьПодписиПоОрганизации(ЭтотОбъект);
	// Конец ЗарплатаКадрыПодсистемы.ПодписиДокументов
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеФормыПоОрганизации()
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ЗапрашиваемыеЗначения = Новый Структура("Организация, МесяцРасчета", "Объект.Организация", "Объект.ПериодРегистрации");
	ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтаФорма, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
	ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтаФорма, "Объект.ПериодРегистрации", "МесяцНачисленияСтрокой");
	
	УстановитьОтветственныхЛиц();
	
КонецПроцедуры

&НаСервере
Процедура ПериодРегистрацииПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПараметрыФО = Новый Структура("Организация, Период", Объект.Организация, НачалоДня(Объект.ПериодРегистрации));
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеСотрудники()
	
	ПоляБухучета = СтрРазделить("СтатьяФинансирования,СтатьяРасходов,СпособОтраженияЗарплатыВБухучете,ОтношениеКЕНВД",",");
	
	Для каждого ИмяПоляБухучета Из ПоляБухучета Цикл
		
		ТекстПустогоЗначения = Элементы["Сотрудники"+ИмяПоляБухучета].ПодсказкаВвода;
		
		ЭлементОформления = УсловноеОформление.Элементы.Добавить();
		// Вид оформления
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", ТекстПустогоЗначения);
		ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
		// Оформляемое поле
		ПолеОформления = ЭлементОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("Сотрудники" + ИмяПоляБухучета);
		// условие для оформления
		ЭлементОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Сотрудники." + ИмяПоляБухучета);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
