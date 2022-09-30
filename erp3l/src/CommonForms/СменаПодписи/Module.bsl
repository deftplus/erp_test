
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("РольПодписанта", РольПодписанта);
	Параметры.Свойство("ИмяРеквизитаОрганизация", ИмяРеквизитаОрганизация);
	Параметры.Свойство("ОписаниеФормыОбъекта", ОписаниеФормыОбъекта);

	ФамилияИнициалыФизическогоЛица = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(Строка(Параметры.ФизическоеЛицо));
	Если ЗначениеЗаполнено(Параметры.ПредыдущийПодписант) Тогда
		ТекстНеЗапоминать = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Нет, не запоминать, будет %1';
																						|en = 'No, do not save, there will be %1'"),
			ФизическиеЛицаКлиентСервер.ФамилияИнициалы(Строка(Параметры.ПредыдущийПодписант)));
	Иначе
		ТекстНеЗапоминать = НСтр("ru = 'Нет, не запоминать';
								|en = 'No, do not save'")
	КонецЕсли;

	Элементы.ДекорацияЗаголовокПереключателя.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Запомнить изменение и при вводе следующих документов в этом поле указывать %1?';
			|en = 'Save the change and specify %1 in this field when entering the following documents?'"),
	СклонениеПредставленийОбъектов.ПросклонятьФИО(ФамилияИнициалыФизическогоЛица, 4));

	Элементы.ПереключательСменаПодписи.СписокВыбора.Добавить(
		ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьДляВсехДокументов,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Да, теперь %1';
																	|en = 'Yes, it is now %1'"),
		ФамилияИнициалыФизическогоЛица));
	Элементы.ПереключательСменаПодписи.СписокВыбора.Добавить(
		ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьПоВидамДокументов,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Да, теперь %1, но только для документов «%2»';
																	|en = 'Yes, it is now %1, but for ""%2"" documents only'"),
		ФамилияИнициалыФизическогоЛица,
		Параметры.ВидДокумента));
	Элементы.ПереключательСменаПодписи.СписокВыбора.Добавить(
		ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().НеЗапоминать,
		ТекстНеЗапоминать);

	ПереключательСменаПодписи = Элементы.ПереключательСменаПодписи.СписокВыбора.Получить(0).Значение;
	УстановитьЗаголовокФлажкаБольшеНеСпрашивать();

	СброситьРазмерыИПоложениеОкна();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательСменаПодписиПриИзменении(Элемент)
	УстановитьЗаголовокФлажкаБольшеНеСпрашивать();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	СменаПодписантовВФорме = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(ВладелецФормы, "СменаПодписантов");
	Если ТипЗнч(СменаПодписантовВФорме) = Тип("ФиксированноеСоответствие") Тогда
		СменаПодписантов = Новый Соответствие(СменаПодписантовВФорме);
		СменаПодписантовПоОрганизации = СменаПодписантов.Получить(ИмяРеквизитаОрганизация);
		Если СменаПодписантовПоОрганизации = Неопределено Тогда
			СменаПодписантовПоОрганизации = Новый Соответствие;
		КонецЕсли;
	Иначе
		СменаПодписантов = Новый Соответствие;
		СменаПодписантовПоОрганизации = Новый Соответствие;
	КонецЕсли;
	
	СменаПодписантовПоОрганизации.Вставить(РольПодписанта, ПереключательСменаПодписи);
	СменаПодписантов.Вставить(ИмяРеквизитаОрганизация, СменаПодписантовПоОрганизации);
	ОбщегоНазначенияКлиентСервер.УстановитьРеквизитФормыПоПути(ВладелецФормы, "СменаПодписантов", Новый ФиксированноеСоответствие(СменаПодписантов));
	
	ПодписиДокументовКлиентСервер.ЗапомнитьПодписиДокументовВФорме(ВладелецФормы, ОписаниеФормыОбъекта, Истина);
	
	СохранитьНастройкиСменыПодписи();
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СохранитьНастройкиСменыПодписи()

	Если БольшеНеСпрашивать Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			"НастройкиПользователя", "НастройкиСменыПодписи", ПереключательСменаПодписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФлажкаБольшеНеСпрашивать()

	Если ПереключательСменаПодписи = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьДляВсехДокументов Тогда
		ЗаголовокФлажка = НСтр("ru = 'Больше не спрашивать и всегда при смене подписи запоминать ее для всех документов';
								|en = 'Do not ask again and always save the signature for all documents when changing the signature'");
	ИначеЕсли ПереключательСменаПодписи = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ЗапоминатьПоВидамДокументов Тогда
		ЗаголовокФлажка = НСтр("ru = 'Больше не спрашивать и всегда при смене подписи запоминать ее только для конкретного вида документов';
								|en = 'Do not ask again and always save the signature for a specific document kind only when changing the signature'");
	ИначеЕсли ПереключательСменаПодписи = ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().НеЗапоминать Тогда
		ЗаголовокФлажка = НСтр("ru = 'Больше не спрашивать и не запоминать смену подписи для последующих документов';
								|en = 'Do not ask again and do not save the signature change for subsequent documents'");
	КонецЕсли;

	Элементы.БольшеНеСпрашивать.Заголовок = ЗаголовокФлажка;

КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.СменаПодписи", "", ИмяПользователя);
	КонецЕсли;
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти


