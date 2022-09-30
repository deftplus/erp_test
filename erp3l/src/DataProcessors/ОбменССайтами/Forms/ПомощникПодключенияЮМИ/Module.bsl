#Область ОписаниеПеременных

&НаКлиенте
Перем ИнтервалПроверкиИмениСайта, 
	ИнтервалПроверкиСозданияСайта, 
	РазрешенныеСимволыИмениСайта,
	ДанныеСозданияСайтаСтруктура;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	
	// Получить организацию для формирования имени сайта - по умолчанию или организацию пользователя.
	ОсновнаяОрганизация = ОбщегоНазначенияБЭД.ОрганизацияПоУмолчанию();
	
	Если НЕ ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		               |	Организации.Ссылка
		               |ИЗ
		               |	Справочник.Организации КАК Организации";
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			ОсновнаяОрганизация = Выборка.Ссылка;
		КонецЦикла;
	КонецЕсли;
	
	// Получить email для регистрации сайта у пользователя или организации.
	EmailРегистрацииСайта = Обработки.ОбменССайтами.КонтактнаяИнформация(
		ТекПользователь, 
		"EmailПользователя");
		
	ИмяСайта = ИмяСайтаИзИмениОрганизации();
	ПринимаюСоглашение = Истина;
	ЗаполнитьГруппыКатегории();
	
	ТипСайта = 4; //Интернет-магазин
	НомерСтраницы = 1;
	
	НадписьИмяСайтаДоступно = ?(ИмяСайта="","",РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно));
	
	ОбменССайтомПереопределяемый.ПриСозданииНаСервереФормаПомощникПодключенияЮМИ(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РазрешенныеСимволыИмениСайта = Новый Соответствие;
	РазрешенныеСимволы = "qwertyuiopasdfghjklzxcvbnm01234567890-";
	Для НомерСтроки =1 По СтрДлина(РазрешенныеСимволы) Цикл
		РазрешенныеСимволыИмениСайта.Вставить(Сред(РазрешенныеСимволы, НомерСтроки, 1), Истина);
	КонецЦикла;
	
	ИнтервалПроверкиИмениСайта = 2;
	ИнтервалПроверкиСозданияСайта = 4;
	ПодключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта", 0.1, Истина);
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборКатегорииИерархияПереключательПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяСайтаАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если СокрЛП(Текст)="" И СокрЛП(Элемент.ТекстРедактирования="") Тогда
		НадписьИмяСайтаДоступно = "";
		ИмяСайтаПроверено = Ложь;
		ОтключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта");
	ИначеЕсли ИмяСайта<>Элемент.ТекстРедактирования Тогда
		
		ИмяСайтаПроверено = Ложь;
		
		Если НЕ ПроверитьИмяСайтаТекст(Текст) Тогда
			НадписьИмяСайтаДоступно = НСтр("ru = 'Разрешены латинские буквы и цифры';
											|en = 'Latin letters and digits are allowed'");
			Возврат;
		КонецЕсли;
		
		НадписьИмяСайтаДоступно = РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно);
		ОтключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта");
		ПодключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта", ИнтервалПроверкиИмениСайта, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЛицензионноеСоглашениеСсылкаНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://umi.ru/servicelicense/");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЦены(Элемент)
	
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://umi.ru/price/");

КонецПроцедуры

&НаКлиенте
Процедура ИмяСайтаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ИмяСайтаПроверено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьИмяСайта(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяСайтаПриИзменении(Элемент)
	
	ИмяСайтаИзмененоВручную = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяОрганизацияПриИзменении(Элемент)
	
	Если НЕ ИмяСайтаИзмененоВручную Тогда
		ИмяСайта = ИмяСайтаИзИмениОрганизации();
		ОбновитьИмяСайта(ИмяСайта);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТипСайтаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьТип1(Команда)
	ОбновитьРамкиКартинок(1);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТип2(Команда)
	ОбновитьРамкиКартинок(2);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТип3(Команда)
	ОбновитьРамкиКартинок(3);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТип4(Команда)
	ОбновитьРамкиКартинок(4);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	НомерСтраницы = НомерСтраницы-1;
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	Если НомерСтраницы = 1 Тогда
		ОбновитьИмяСайта(ИмяСайта);
	КонецЕсли; 
	
	Если НомерСтраницы = 2 Тогда
		
		Если ТипСайта=0 Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите тип сайта';
															|en = 'Select website type'"));
			Возврат;
		КонецЕсли;
		
		Если НЕ ПринимаюСоглашение Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Чтобы создать сайт, нужно принять лицензионное соглашение';
															|en = 'To create a website, accept the license agreement'"));
			Возврат;
		КонецЕсли;
		
		Если СокрЛП(EmailРегистрацииСайта)="" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите e-mail, на который будет зарегистрирован сайт';
															|en = 'Specify an email to which the website will be registered'"));
			Возврат;
		КонецЕсли;
		
		Если НЕ ИмяСайтаПроверено Тогда
			 ПроверитьИмяСайтаНаСервере(Элементы.ИмяСайта.ТекстРедактирования, ИмяСайтаСвободно, ИмяСайтаПроверено);
		КонецЕсли;
		 
		Если НЕ ИмяСайтаСвободно Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Предложенное имя сайта занято, выберите другое';
															|en = 'Proposed website name is used, choose another one'"));
			Возврат;
		КонецЕсли;
		
	КонецЕсли; 
	
	НомерСтраницы = НомерСтраницы+1;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСайт(Команда)
	
	ОчиститьСообщения();
	
	Если ТипСайта=0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите тип сайта';
														|en = 'Select website type'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ПринимаюСоглашение Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Чтобы создать сайт, нужно принять пользовательское соглашение';
														|en = 'To create a website, accept the end user license agreement'"));
		Возврат;
	КонецЕсли;
	
	Если СокрЛП(EmailРегистрацииСайта)="" Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите e-mail, на который будет зарегистрирован сайт';
														|en = 'Specify an email to which the website will be registered'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ ИмяСайтаПроверено Тогда
		ПроверитьИмяСайтаНаСервере(Элементы.ИмяСайта.ТекстРедактирования, ИмяСайтаСвободно, ИмяСайтаПроверено);
	КонецЕсли;
	 
	Если НЕ ИмяСайтаСвободно Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Предложенное имя сайта занято, выберите другое';
														|en = 'Proposed website name is used, choose another one'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОсновнаяОрганизация) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Укажите организацию, на которую будет зарегистрирован сайт';
														|en = 'Specify a company for which the website will be registered'"),,
			"ОсновнаяОрганизация");
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДлительнаяОперацияОбработкаОповещения",ЭтотОбъект);
	ОткрытьФорму("Обработка.ОбменССайтами.Форма.ДлительнаяОперация",,ЭтотОбъект,,,,ОписаниеОповещения);
	
	// Запустим длительную операцию создания сайта.
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьПрогрессВыполнения      = Ложь;
	ПараметрыОжидания.ВыводитьОкноОжидания            = Ложь;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Ложь;
	ПараметрыОжидания.ВыводитьСообщения               = Ложь;
	
	ДанныеСозданияСайтаСтруктура = СвойстваСайтаВФоне();
	
	Если ДанныеСозданияСайтаСтруктура.Свойство("ОжиданиеСозданияСайта") И ДанныеСозданияСайтаСтруктура.ОжиданиеСозданияСайта = Истина Тогда
		
		ПодключитьОбработчикОжидания("СоздатьСайтПродолжить", 2, Истина);
		
	ИначеЕсли ДанныеСозданияСайтаСтруктура.Свойство("Ошибка") Тогда
		ЗакрытьФормуДлительнойОперации();
		ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеСозданияСайтаСтруктура.Ошибка);
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверкиСозданияСайта, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания()
	
	Если ЗначениеЗаполнено(ФоновоеЗаданиеИдентификатор) Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ФоновоеЗаданиеИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДлительнаяОперацияОбработкаОповещения(Результат, ДопПараметры) Экспорт
	
	ОтменитьВыполнениеЗадания();
	
	ОтключитьОбработчикОжидания("ПроверитьВыполнение");
	
	ОбновитьИмяСайта(ИмяСайта)
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоИерархииВыбранПриИзменении()
	
	ПометкаИерархииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоКатегорииВыбранПриИзменении()
	
	ПометкаКатегорииПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаИерархииПриИзменении()
	
	ТекущиеДанные = Элементы.ОтборИерархия.ТекущиеДанные;
	Если ТекущиеДанные.Представление = НСтр("ru = '<Все группы>';
											|en = '<All groups>'") Тогда
		// Все элементы дерева.
		УстановитьФлагУПодчиненных(ОтборИерархия.ПолучитьЭлементы(), "Флаг", ТекущиеДанные.Флаг);
	Иначе	
		УстановитьФлагУПодчиненных(ТекущиеДанные.ПолучитьЭлементы(), "Флаг", ТекущиеДанные.Флаг);
		Если ТекущиеДанные.Флаг = Ложь Тогда
			УстановитьФлагУРодителей(ТекущиеДанные, "Флаг", Ложь);
			ЭлементВсеГруппы = ОтборИерархия.НайтиПоИдентификатору(0);
			ЭлементВсеГруппы.Флаг = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаКатегорииПриИзменении()
	
	ТекущиеДанные = Элементы.ОтборКатегории.ТекущиеДанные;
	Если ТекущиеДанные.Представление = НСтр("ru = '<Все категории>';
											|en = '<All categories>'") Тогда
		// Все элементы дерева.
		УстановитьФлагУПодчиненных(ОтборКатегории.ПолучитьЭлементы(), "Флаг", ТекущиеДанные.Флаг);
	Иначе	
		УстановитьФлагУПодчиненных(ТекущиеДанные.ПолучитьЭлементы(), "Флаг", ТекущиеДанные.Флаг);
		Если ТекущиеДанные.Флаг = Ложь Тогда
			УстановитьФлагУРодителей(ТекущиеДанные, "Флаг", Ложь);
			ЭлементВсеКатегории = ОтборКатегории.НайтиПоИдентификатору(0);
			ЭлементВсеКатегории.Флаг = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИмяСайта(Текст)
	
	Если Текст="" Тогда
		НадписьИмяСайтаДоступно = "";
		ИмяСайтаПроверено = Ложь;
		ОтключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта");
		Возврат;
	ИначеЕсли НЕ ПроверитьИмяСайтаТекст(Текст) Тогда
		НадписьИмяСайтаДоступно = НСтр("ru = 'Разрешены латинские буквы и цифры';
										|en = 'Latin letters and digits are allowed'");
		ИмяСайтаПроверено = Ложь;
		ОтключитьОбработчикОжидания("ПроверитьДоступностьИмениСайта");
		Возврат;
	КонецЕсли;
	
	НадписьИмяСайтаДоступно = РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно);
	ПроверитьИмяСайтаНаСервере(Элементы.ИмяСайта.ТекстРедактирования, ИмяСайтаСвободно, ИмяСайтаПроверено);
	НадписьИмяСайтаДоступно = РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФормуДлительнойОперации()
	
	Оповестить("ЗакрытьФормуДлительнойОперации");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагУРодителей(ТекущиеДанные, ИмяФлага, ЗначениеФлага)
	
	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда
		Родитель[ИмяФлага] = ЗначениеФлага;
		УстановитьФлагУРодителей(Родитель, ИмяФлага, ЗначениеФлага);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлагУПодчиненных(СписокЭлементов, ИмяФлага, ЗначениеФлага)
	
	Для Каждого СтрокаДерева Из СписокЭлементов Цикл
		
		СтрокаДерева[ИмяФлага] = ЗначениеФлага;
		
		ДочерниеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ДочерниеСтроки.Количество() > 0 Тогда
			УстановитьФлагУПодчиненных(ДочерниеСтроки, ИмяФлага, ЗначениеФлага);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно)
	
	Если НЕ ИмяСайтаПроверено Тогда
		Возврат НСтр("ru = 'Проверяется ...';
					|en = 'Checking ...'");
	ИначеЕсли ИмяСайтаСвободно Тогда
		Возврат НСтр("ru = 'Имя свободно';
					|en = 'Name is available'");
	Иначе
		Возврат НСтр("ru = 'Имя занято';
					|en = 'The name is in use'");
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ПроверитьИмяСайтаТекст(Текст)
	
	нСтроки=1;
	Пока нСтроки <= СтрДлина(Текст) Цикл
		ПроверяемыйСимвол = Сред(Текст, нСтроки, 1);
		Если РазрешенныеСимволыИмениСайта.Получить(НРег(ПроверяемыйСимвол)) = Неопределено Тогда
			Возврат Ложь;
		Иначе
			нСтроки=нСтроки+1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПроверитьДоступностьИмениСайта()
	
	Если ИмяСайтаПроверено Тогда
		Возврат;
	КонецЕсли;
	
	Если СокрЛП(Элементы.ИмяСайта.ТекстРедактирования)="" Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьИмяСайтаНаСервере(Элементы.ИмяСайта.ТекстРедактирования, ИмяСайтаСвободно, ИмяСайтаПроверено);
	НадписьИмяСайтаДоступно = РезультатПроверкиИмениСайта(ИмяСайтаПроверено, ИмяСайтаСвободно);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРамкиКартинок(ВыбранныйТипСайта)
	
	ТипСайта = ВыбранныйТипСайта;
	УправлениеФормой();
	ЭтотОбъект.ТекущийЭлемент = Элементы.EmailРегистрацииСайта;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	Если НомерСтраницы = 1 Тогда
		Элементы.Назад.Видимость = Ложь;
		Элементы.СоздатьСайт.Видимость = Ложь;
		Элементы.Далее.Видимость = Истина;
	
		Элементы.ГруппаОписание.Видимость = Истина;
		Элементы.Настройки.Видимость = Ложь;
		Элементы.ДополнительныеПараметрыСозданияСайта.Видимость = Ложь;
		
	ИначеЕсли НомерСтраницы = 2 Тогда
		
		Элементы.Назад.Видимость = Истина;
		Элементы.Далее.Видимость = Ложь;
		Элементы.СоздатьСайт.Видимость = Истина;
		
		Элементы.ГруппаОписание.Видимость = Ложь;
		Элементы.Настройки.Видимость = Истина;
		Элементы.ДополнительныеПараметрыСозданияСайта.Видимость = Истина;
		
		Если ОтборКатегорииГруппыПереключатель = ПредопределенноеЗначение("Перечисление.ВидыОтборовНоменклатуры.КатегорииНоменклатуры") Тогда
			Элементы.КатегорииОтбор.Видимость = Истина;
			Элементы.ГруппыОтбор.Видимость = Ложь;
		ИначеЕсли ОтборКатегорииГруппыПереключатель = ПредопределенноеЗначение("Перечисление.ВидыОтборовНоменклатуры.ГруппыНоменклатуры") Тогда
			Элементы.КатегорииОтбор.Видимость = Ложь;
			Элементы.ГруппыОтбор.Видимость = Истина;
		КонецЕсли;
		
		Если ТипСайта=4 Тогда
			Элементы.ГруппаЦеныОстатки.Видимость = Истина;
			Элементы.ГруппаВыбратьНоменклатуру.Видимость = Истина;
		Иначе
			Элементы.ГруппаЦеныОстатки.Видимость = Ложь;
			Элементы.ГруппаВыбратьНоменклатуру.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИмяСайтаИзИмениОрганизации()
	
	ИмяСайтаТекст = СтроковыеФункции.СтрокаЛатиницей(ОсновнаяОрганизация.Наименование);
	ИмяСайтаТекст = РазрешенныеСимволы(ИмяСайтаТекст, "qwertyuiopasdfghjklzxcvbnm01234567890-");
	
	Возврат ИмяСайтаТекст;

КонецФункции

&НаСервере
Функция РазрешенныеСимволы(Текст, Разрешенные)
	
	Результат = Текст;
	Для Сч = 1 По СтрДлина(Текст) Цикл
		ТекСимвол = Сред(Текст, Сч, 1);
		Если СтрНайти(Разрешенные, НРег(ТекСимвол))=0 Тогда
			Результат = СтрЗаменить(Результат, ТекСимвол,"");
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьГруппыКатегории()
	
	ИмяСправочникаНоменклатура = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("Номенклатура");
	ИмяСправочникаВидыНоменклатуры = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("ВидыНоменклатуры");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Номенклатура.Ссылка) КАК КоличествоГрупп,
	|	0 КАК КоличествоКатегорий
	|ПОМЕСТИТЬ втКоличества
	|ИЗ
	|	Справочник."+ИмяСправочникаНоменклатура+" КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа
	|	И НЕ Номенклатура.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	0,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ КатегорииНоменклатуры.Ссылка)
	|ИЗ
	|	Справочник."+ИмяСправочникаВидыНоменклатуры+" КАК КатегорииНоменклатуры
	|ГДЕ
	|	НЕ КатегорииНоменклатуры.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(втКоличества.КоличествоГрупп) КАК КоличествоГрупп,
	|	СУММА(втКоличества.КоличествоКатегорий) КАК КоличествоКатегорий
	|ИЗ
	|	втКоличества КАК втКоличества";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		КоличествоГрупп = Выборка.КоличествоГрупп;
		КоличествоКатегорий = Выборка.КоличествоКатегорий;
		ВсегоГруппКатегорий = КоличествоКатегорий + КоличествоГрупп;
	КонецЦикла;
	
	Если ВсегоГруппКатегорий = 0 Тогда
		ОтборКатегорииГруппыПереключатель = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
		Элементы.ГруппаВыбратьНоменклатуру.Видимость = Ложь;
		Элементы.ОтборКатегорииГруппыПереключатель.Видимость	= Ложь;
		Элементы.КатегорииОтбор.Видимость = Ложь;
		Элементы.ГруппыОтбор.Видимость = Ложь;
		Элементы.ГруппаВыбратьНоменклатуру.ОтображатьЗаголовок = Ложь;
		
	ИначеЕсли КоличествоГрупп = 0 Тогда
		ОтборКатегорииГруппыПереключатель = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
		Элементы.ОтборКатегорииГруппыПереключатель.Видимость = Ложь;
		Элементы.ГруппаВыбратьНоменклатуру.Заголовок = НСтр("ru = 'Выберите категории номенклатуры для переноса на сайт';
															|en = 'Select product categories to transfer to the website'");
		Элементы.КатегорииОтбор.Видимость = Истина;
		Элементы.ГруппыОтбор.Видимость = Ложь;
		
		ЗаполнитьДеревоКатегорий();
		
	ИначеЕсли КоличествоКатегорий = 0 Тогда
		ОтборКатегорииГруппыПереключатель = Перечисления.ВидыОтборовНоменклатуры.ГруппыНоменклатуры;
		Элементы.ОтборКатегорииГруппыПереключатель.Видимость = Ложь;
		Элементы.ГруппаВыбратьНоменклатуру.Заголовок = НСтр("ru = 'Выберите группы номенклатуры для переноса на сайт';
															|en = 'Select product groups to transfer to the website'");
		Элементы.КатегорииОтбор.Видимость = Ложь;
		Элементы.ГруппыОтбор.Видимость = Истина;
		
		ЗаполнитьДеревоГрупп();
		
	Иначе
		ОтборКатегорииГруппыПереключатель = Перечисления.ВидыОтборовНоменклатуры.КатегорииНоменклатуры;
		Элементы.КатегорииОтбор.Видимость = Истина;
		Элементы.ГруппыОтбор.Видимость = Ложь;
		
		ЗаполнитьДеревоГрупп();
		ЗаполнитьДеревоКатегорий();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоГрупп()
	
	ИмяСправочникаНоменклатура = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("Номенклатура");

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Значение,
	|	Номенклатура.Наименование КАК Представление,
	|	ВЫБОР
	|		КОГДА Номенклатура.ПометкаУдаления
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Картинка,
	|	ИСТИНА КАК Флаг
	|ИЗ
	|	Справочник."+ИмяСправочникаНоменклатура+" КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Наименование ИЕРАРХИЯ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	СтрокаВсеГруппы = Дерево.Строки.Вставить(0);
	СтрокаВсеГруппы.Значение	 = Справочники[ИмяСправочникаНоменклатура].ПустаяСсылка();
	СтрокаВсеГруппы.Представление= НСтр("ru = '<Все группы>';
										|en = '<All groups>'");
	СтрокаВсеГруппы.Флаг = Истина;
	
	ЗначениеВРеквизитФормы(Дерево,"ОтборИерархия");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоКатегорий()
	
	ИмяСправочникаВидыНоменклатуры = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("ВидыНоменклатуры");

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Значение,
	|	Номенклатура.Наименование КАК Представление,
	|	Номенклатура.ПометкаУдаления КАК ПометкаУдаления,
	|	ИСТИНА КАК Флаг
	|ИЗ
	|	Справочник."+ИмяСправочникаВидыНоменклатуры+" КАК Номенклатура
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура.Наименование ИЕРАРХИЯ";
	
	Дерево = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	СтрокаВсеГруппы = Дерево.Строки.Вставить(0);
	СтрокаВсеГруппы.Значение	 = Справочники[ИмяСправочникаВидыНоменклатуры].ПустаяСсылка();
	СтрокаВсеГруппы.Представление= НСтр("ru = '<Все категории>';
										|en = '<All categories>'");
	СтрокаВсеГруппы.Флаг = Истина;
	
	ЗначениеВРеквизитФормы(Дерево,"ОтборКатегории");
	
КонецПроцедуры

&НаСервере
Функция СвойстваСайтаВФоне()

	ПараметрыСозданияСайта = ПараметрыСозданияСайта();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание сайта';
															|en = 'Website creation'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("Обработки.ОбменССайтами.СоздатьСайт", ПараметрыСозданияСайта, ПараметрыВыполнения);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ПараметрыСозданияСайта = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		ПараметрыСозданияСайта.Вставить("Ошибка", РезультатВыполнения.КраткоеПредставлениеОшибки);
	ИначеЕсли РезультатВыполнения.Статус = "Отменено" Тогда
		ТекстОшибки = НСтр("ru = 'Фоновое задание отменено администратором.';
							|en = 'Background job is canceled by administrator.'");
		ПараметрыСозданияСайта.Вставить("Ошибка", ТекстОшибки);
	Иначе
		ФоновоеЗаданиеИдентификатор  = РезультатВыполнения.ИдентификаторЗадания;
		ФоновоеЗаданиеАдресХранилища = РезультатВыполнения.АдресРезультата;
	КонецЕсли;
	
	Возврат ПараметрыСозданияСайта;

КонецФункции

&НаСервере
Функция ПараметрыСозданияСайта(ПараметрыВызоваСервера = Неопределено)
	
	АдресСайта = ИмяСайта+".1c-umi.ru";	
	
	Если ПараметрыВызоваСервера = Неопределено Тогда
		ПараметрыВызоваСервера = Новый Структура;
	КонецЕсли;
	ПараметрыВызоваСервера.Вставить("ТипСайта", ТипСайта);
	Если ТипСайта=1 Тогда
		ПараметрыВызоваСервера.Вставить("ДизайнИД", "1063");
	ИначеЕсли ТипСайта=2 Тогда
		ПараметрыВызоваСервера.Вставить("ДизайнИД", "1813");
	ИначеЕсли ТипСайта=3 Тогда
		ПараметрыВызоваСервера.Вставить("ДизайнИД", "1095");
	КонецЕсли;
	ПараметрыВызоваСервера.Вставить("ОсновнаяОрганизация", ОсновнаяОрганизация);
	ПараметрыВызоваСервера.Вставить("ИмяСайта", ИмяСайта);
	ПараметрыВызоваСервера.Вставить("АдресСайта", АдресСайта);
	ПараметрыВызоваСервера.Вставить("EmailРегистрацииСайта", EmailРегистрацииСайта);
	ПараметрыВызоваСервера.Вставить("ОтборКатегорииГруппыПереключатель", ОтборКатегорииГруппыПереключатель);
	ПараметрыВызоваСервера.Вставить("ВидЦен", ВидЦен);
	ПараметрыВызоваСервера.Вставить("ВыгружатьОстатки", ВыгружатьОстатки);
	
	ПараметрыВызоваСервера.Вставить("ОтборКатегорииГруппыПереключатель", ОтборКатегорииГруппыПереключатель);

	Возврат ПараметрыВызоваСервера;
	
КонецФункции

&НаСервере
Функция СайтВФонеПродолжение(ПараметрыСозданияСайта)
	
	Если ТипСайта=4 Тогда
		ХранилищеСистемныхНастроек.Сохранить("ТаблицаКаталоговСозданияСайта",,ТаблицаКаталогов());
	КонецЕсли;
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(ЭтотОбъект.УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Создание сайта (выгрузка данных).';
															|en = 'Site creation (data export).'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("Обработки.ОбменССайтами.СоздатьСайтПродолжить", ПараметрыСозданияСайта, ПараметрыВыполнения);
	
	Если РезультатВыполнения.Статус = "Выполнено" Тогда
		ПараметрыСозданияСайта = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
	ИначеЕсли РезультатВыполнения.Статус = "Ошибка" Тогда
		ПараметрыСозданияСайта.Вставить("Ошибка", РезультатВыполнения.КраткоеПредставлениеОшибки);
	ИначеЕсли РезультатВыполнения.Статус = "Отменено" Тогда
		ТекстОшибки = НСтр("ru = 'Фоновое задание отменено администратором.';
							|en = 'Background job is canceled by administrator.'");
		ПараметрыСозданияСайта.Вставить("Ошибка", ТекстОшибки);
	Иначе
		ФоновоеЗаданиеИдентификатор  = РезультатВыполнения.ИдентификаторЗадания;
		ФоновоеЗаданиеАдресХранилища = РезультатВыполнения.АдресРезультата;
	КонецЕсли;
	
	Возврат ПараметрыСозданияСайта;
	
КонецФункции

&НаСервере
Функция ТаблицаКаталогов()

	ИмяСправочникаНоменклатура = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("Номенклатура");
	ИмяСправочникаВидыНоменклатуры = ОбменССайтомПовтИсп.ИмяПрикладногоСправочника("ВидыНоменклатуры");
	
	// Таблица каталогов.
	ВсеГруппы = Ложь;
	СписокГрупп = Новый СписокЗначений;
	Если ОтборКатегорииГруппыПереключатель = Перечисления.ВидыОтборовНоменклатуры.ГруппыНоменклатуры Тогда
		ГруппыВДереве = ОтборИерархия.ПолучитьЭлементы();
		Если ГруппыВДереве.Количество()=0 Тогда
			// Выгружаем все товары, если категории не введены.
			ВсеГруппы = Истина;
			СписокГрупп.Добавить(Справочники[ИмяСправочникаНоменклатура].ПустаяСсылка(),"(Все)");
		Иначе
			ВыделенныеСтроки(ГруппыВДереве, СписокГрупп);
		КонецЕсли;
	Иначе	
		КатегорииВДереве = ОтборКатегории.ПолучитьЭлементы();
		Если КатегорииВДереве.Количество()=0 Тогда
			// Выгружаем все товары, если категории не введены.
			ВсеГруппы = Истина;
			СписокГрупп.Добавить(Справочники[ИмяСправочникаВидыНоменклатуры].ПустаяСсылка(),"(Все)");
		Иначе
			ВыделенныеСтроки(КатегорииВДереве, СписокГрупп);
		КонецЕсли;
	КонецЕсли;

	Если НЕ ВсеГруппы Тогда
		
		// Удаляем дубли и подчиненные элементы.
		МассивУдалить = Новый Массив;
		Для Каждого ЭлементСЗ Из СписокГрупп Цикл
			Если НЕ МассивУдалить.Найти(ЭлементСЗ) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			ТекГруппа = ЭлементСЗ.Значение;
			
			Если ЭлементСЗ.Представление = НСтр("ru = '<Все группы>';
												|en = '<All groups>'") Тогда
				МассивУдалить.Добавить(ЭлементСЗ);
				Продолжить;
			КонецЕсли;
			
			Если ЭлементСЗ.Представление = НСтр("ru = '<Все категории>';
												|en = '<All categories>'") Тогда
				МассивУдалить.Добавить(ЭлементСЗ);
				Продолжить;
			КонецЕсли;

			
			Для Каждого ЭлементСЗВложенные Из СписокГрупп Цикл
				Если НЕ МассивУдалить.Найти(ЭлементСЗВложенные) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Если НЕ ЗначениеЗаполнено(ЭлементСЗВложенные.Значение) Тогда
					Продолжить;
				КонецЕсли;
				
				Если НЕ ЭлементСЗВложенные = ЭлементСЗ
					И ЭлементСЗВложенные.Значение = ТекГруппа Тогда
					МассивУдалить.Добавить(ЭлементСЗВложенные);
				Иначе
					Если ЭлементСЗВложенные.Значение.ПринадлежитЭлементу(ТекГруппа) Тогда
						МассивУдалить.Добавить(ЭлементСЗВложенные);
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Для Каждого ЭлементМУ Из МассивУдалить Цикл
			СписокГрупп.Удалить(ЭлементМУ);
		КонецЦикла;
	
	КонецЕсли; 
	
	ТаблицаКаталоговТЗ = Новый ТаблицаЗначений;
	ТаблицаКаталоговТЗ.Колонки.Добавить("Каталог", Новый ОписаниеТипов("Строка", ,
													Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТаблицаКаталоговТЗ.Колонки.Добавить("Группы", Новый ОписаниеТипов("СписокЗначений"));
	ТаблицаКаталоговТЗ.Колонки.Добавить("ИдентификаторКаталога", Новый ОписаниеТипов("Строка", ,
													Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТаблицаКаталоговТЗ.Колонки.Добавить("ХранилищеНастроекКаталогПакет", Новый ОписаниеТипов("ХранилищеЗначения"));
	
	НовСтр = ТаблицаКаталоговТЗ.Добавить();
	НовСтр.Каталог = НСтр("ru = 'Основной каталог товаров';
							|en = 'Main goods catalog'");
	НовСтр.ИдентификаторКаталога = Строка(Новый УникальныйИдентификатор);
	НовСтр.Группы = СписокГрупп;
	
	Возврат ТаблицаКаталоговТЗ;

КонецФункции

&НаСервере
Функция ВыделенныеСтроки(СписокЭлементов, СписокВыделенных)
	
	Для каждого СтрокаДерева Из СписокЭлементов Цикл
		Если СтрокаДерева.Флаг Тогда
			СписокВыделенных.Добавить(СтрокаДерева.Значение, СтрокаДерева.Представление);
		КонецЕсли;
		
		ДочерниеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ДочерниеСтроки.Количество()>0 Тогда
			ВыделенныеСтроки(ДочерниеСтроки,СписокВыделенных);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СписокВыделенных;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ДобавитьПараметрыЗапроса(АдресЗапроса, ПараметрыЗапроса)
	
	РазделительПараметров = "?";
	Для каждого стр Из ПараметрыЗапроса Цикл
		АдресЗапроса = АдресЗапроса + РазделительПараметров + стр.Ключ+"="+стр.Значение;
		РазделительПараметров = "&";
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПроверитьИмяСайтаНаСервере(ИмяСайтаДляПроверки, ИмяСайтаСвободно, ИмяСайтаПроверено)

	РеквизитыАвторизации = Обработки.ОбменССайтами.ДанныеДляАвторизации();
	
	АдресЗапроса = РеквизитыАвторизации.Получить("АдресЗапроса");
	РеквизитыАвторизации.Вставить("host", ИмяСайтаДляПроверки+".1c-umi.ru");
	РеквизитыАвторизации.Вставить("action", "check_free");
	ДобавитьПараметрыЗапроса(АдресЗапроса, РеквизитыАвторизации);
		
	СтруктураДанныхСоздания = Новый Структура;
	СтруктураДанныхСоздания.Вставить("ТелоЗапроса", Неопределено);
	
	СтруктураДанныхСоздания.Вставить("АдресЗапроса",
		ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресЗапроса));
		
	ТекстОшибки = "";
	ДанныеСтрока = ДанныеHTTPЗапроса("GET", СтруктураДанныхСоздания.ТелоЗапроса, СтруктураДанныхСоздания.АдресЗапроса, Новый Структура,,ТекстОшибки);
	Если ТекстОшибки="" Тогда
		ИмяСайтаСвободно = ЗначениеРеквизитаJSON(ДанныеСтрока, "result");
		ИмяСайтаПроверено = Истина;
	Иначе
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСайтПродолжить()

	ДанныеСайтаСтруктура = ГотовностьСайтаНаСервере();
	
	Если ДанныеСайтаСтруктура.Свойство("Ошибка") Тогда
		 ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеСайтаСтруктура.Ошибка);
	ИначеЕсли ДанныеСайтаСтруктура.Свойство("СайтСоздан") И ДанныеСайтаСтруктура.СайтСоздан = Истина Тогда
		
		ДанныеСозданияСайтаСтруктура.СайтСоздан = Истина;
		РезультатСозданияПослеЗаполнения = СайтВФонеПродолжение(ДанныеСозданияСайтаСтруктура);
		
		Если РезультатСозданияПослеЗаполнения.Свойство("ОбменВыполнен") И РезультатСозданияПослеЗаполнения.ОбменВыполнен=Истина Тогда
			ОткрытьСозданныйСайт(РезультатСозданияПослеЗаполнения);
		Иначе
			ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверкиСозданияСайта, Истина);
		КонецЕсли;
	ИначеЕсли ДанныеСайтаСтруктура.Свойство("СайтСоздан") И ДанныеСайтаСтруктура.СайтСоздан = Ложь Тогда
		ПодключитьОбработчикОжидания("СоздатьСайтПродолжить", 2, Истина);
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнение()
	
	Попытка
		РезультатПроверки = РезультатВыполненияНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, Ложь);
	Исключение
		ЗакрытьФормуДлительнойОперации();
		ОбщегоНазначенияКлиент.СообщитьПользователю(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Если РезультатПроверки.ЗаданиеВыполнено Тогда
		
		ДействияЗаданиеВыполнено(РезультатПроверки);
		
	ИначеЕсли ДанныеСозданияСайтаСтруктура.Свойство("Ошибка") Тогда
		ЗакрытьФормуДлительнойОперации();
		ОбщегоНазначенияКлиент.СообщитьПользователю(ДанныеСозданияСайтаСтруктура.Ошибка);
		
	Иначе
		ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверкиСозданияСайта, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ГотовностьСайтаНаСервере()

	ПараметрыСозданияСайта = ПараметрыСозданияСайта();
	ДанныеСайта = Обработки.ОбменССайтами.ДанныеСозданияСайта(ПараметрыСозданияСайта);
	
	ДанныеСайтаСтруктура = Новый Структура;
	Если ТипЗнч(ДанныеСайта)= Тип("Соответствие") Тогда
		СайтСоздан = ДанныеСайта.Получить("ready");
		ОжиданиеСозданияСайта = ДанныеСайта.Получить("waiting");
		
		ДанныеСайтаСтруктура.Вставить("СайтСоздан", СайтСоздан);
		ДанныеСайтаСтруктура.Вставить("ОжиданиеСозданияСайта", ОжиданиеСозданияСайта);
		
		Возврат ДанныеСайтаСтруктура;
	Иначе
		Возврат Новый Структура("Ошибка", ДанныеСайта);
	КонецЕсли;
		
КонецФункции

&НаКлиенте
Процедура ДействияЗаданиеВыполнено(РезультатПроверки)
	
	Если ТипЗнч(РезультатПроверки.Значение) = Тип("Структура") Тогда
		
		Если РезультатПроверки.Значение.Свойство("Ошибка") Тогда
			
			ТекстОшибки = РезультатПроверки.Значение.Ошибка;
			Если ТипЗнч(ТекстОшибки)=Тип("Массив") Тогда
				Для каждого стр Из ТекстОшибки Цикл
					ОбщегоНазначенияКлиент.СообщитьПользователю(стр);
				КонецЦикла;
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
			КонецЕсли;
			
		Иначе	
			
			ДанныеСозданияСайтаСтруктура = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
			
			Если ТипЗнч(ДанныеСозданияСайтаСтруктура) = Тип("Структура") И ДанныеСозданияСайтаСтруктура.Свойство("ОбменВыполнен") 
				И ДанныеСозданияСайтаСтруктура.Свойство("СсылкаАдминЗоны") Тогда
				
				// сайт создан и заполнен данными.
				ОткрытьСозданныйСайт(ДанныеСозданияСайтаСтруктура);
				
			ИначеЕсли ТипЗнч(ДанныеСозданияСайтаСтруктура) = Тип("Структура") И ДанныеСозданияСайтаСтруктура.Свойство("СсылкаАдминЗоны") Тогда
				 // сайт создан, нужно запустить обмен.
				
				 СоздатьСайтПродолжить();
				
			ИначеЕсли ТипЗнч(ДанныеСозданияСайтаСтруктура) = Тип("Структура") И ДанныеСозданияСайтаСтруктура.Свойство("Ошибка") Тогда
				ТекстОшибки = ДанныеСозданияСайтаСтруктура.Ошибка;
				Если ТипЗнч(ТекстОшибки)=Тип("Массив") Тогда
					Для каждого стр Из ТекстОшибки Цикл
						ОбщегоНазначенияКлиент.СообщитьПользователю(стр);
					КонецЦикла;
				Иначе
					ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСозданныйСайт(ДанныеСозданияСайтаСтруктура)
	
	ЗакрытьФормуДлительнойОперации();
	
	Если Не ЗначениеЗаполнено(ДанныеСозданияСайтаСтруктура.СсылкаАдминЗоны)
		И Не ЗначениеЗаполнено(ДанныеСозданияСайтаСтруктура.АдресСайта) Тогда
		Возврат;
	КонецЕсли;
	

	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку(СтрЗаменить(ДанныеСозданияСайтаСтруктура.СсылкаАдминЗоны, "/adminzone/","/adminzone/main/"));
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("http://" +ДанныеСозданияСайтаСтруктура.АдресСайта);
	
	ПоказатьОповещениеПользователя(,,НСтр("ru = 'Создан сайт:';
											|en = 'Website is created:'")+" "+ДанныеСозданияСайтаСтруктура.АдресСайта,БиблиотекаКартинок.Информация32);
	ОбновитьИнтерфейс();
	Закрыть();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РезультатВыполненияНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, ПрерватьЕслиНеВыполнено)
	
	РезультатПроверки = Новый Структура("ЗаданиеВыполнено, Значение", Ложь, Неопределено);
	
	Если ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор) Тогда
		РезультатПроверки.ЗаданиеВыполнено = Истина;
		РезультатПроверки.Значение         = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
	ИначеЕсли ПрерватьЕслиНеВыполнено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ФоновоеЗаданиеИдентификатор);
	КонецЕсли;
	
	Возврат РезультатПроверки;
	
КонецФункции

&НаСервереБезКонтекста
Функция ДанныеHTTPЗапроса(HTTPМетод, ТелоЗапроса, АдресЗапроса, ЗаголовкиЗапроса, ContentType="", ТекстОшибки="")
	
	HTTPСоединение = Новый HTTPСоединение(
	АдресЗапроса.Хост,
	АдресЗапроса.Порт,,,,180,
	ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение());
	
	Если ContentType="" Тогда
		ContentType = "application/json;charset=utf-8";
	КонецЕсли;
	
	ЗапросHTTP = Новый HTTPЗапрос(АдресЗапроса.ПутьНаСервере);
	ЗапросHTTP.Заголовки["Cache-Control"]	= "no-cache";
	ЗапросHTTP.Заголовки["Content-type"]	= ContentType;
	Для каждого стр Из ЗаголовкиЗапроса Цикл
		ЗапросHTTP.Заголовки[стр.Ключ]	= стр.Значение;
	КонецЦикла;
	
	Если ТипЗнч(ТелоЗапроса)=Тип("Строка") Тогда
		ЗапросHTTP.УстановитьТелоИзСтроки(ТелоЗапроса,"UTF-8",ИспользованиеByteOrderMark.НеИспользовать);
	ИначеЕсли ТипЗнч(ТелоЗапроса)=Тип("ДвоичныеДанные") Тогда
		ЗапросHTTP.УстановитьТелоИзДвоичныхДанных(ТелоЗапроса);
	КонецЕсли; 
	
	Попытка
		Если HTTPМетод="GET" Тогда
		    ОтветHTTP = HTTPСоединение.Получить(ЗапросHTTP);
		ИначеЕсли HTTPМетод="POST" Тогда
			ОтветHTTP = HTTPСоединение.ОтправитьДляОбработки(ЗапросHTTP);
		ИначеЕсли HTTPМетод="PUT" Тогда
			ОтветHTTP = HTTPСоединение.Записать(ЗапросHTTP);
		ИначеЕсли HTTPМетод="DELETE" Тогда	
			ОтветHTTP = HTTPСоединение.Удалить(ЗапросHTTP);
		КонецЕсли;
	Исключение
		ТекстОшибки = ОписаниеОшибки();
		Если СтрНайти(ТекстОшибки, "Couldn't resolve host name")<>0 Тогда
		    ТекстОшибки = НСтр("ru = 'Ошибка: Нет подключения к интернету';
								|en = 'Error: No Internet connection'");
		КонецЕсли;
		Возврат "";
	КонецПопытки;
	
	Если ОтветHTTP.КодСостояния<>200 Тогда
		КодСостояния = Строка(ОтветHTTP.КодСостояния);
		ОбщегоНазначения.СообщитьПользователю(КодСостояния);
	КонецЕсли;

	ОтветКакСтрока = ОтветHTTP.ПолучитьТелоКакСтроку();
	Возврат ОтветКакСтрока;	
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаJSON(ДанныеСтрока, ИмяРеквизита)
	
	Если НЕ ЗначениеЗаполнено(ДанныеСтрока) Тогда
		Возврат 0;
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ДанныеСтрока);
	Результат = ПрочитатьJSON(ЧтениеJSON, Истина);
	РеквизитЗначение = Результат.Получить(ИмяРеквизита);
	
	Возврат РеквизитЗначение;
	
КонецФункции

#КонецОбласти