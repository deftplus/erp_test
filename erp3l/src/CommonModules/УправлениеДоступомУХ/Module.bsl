
#Область ПрограммныйИнтерфейс

Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
		
	ПриЗаполненииСписковСОграничениемДоступа_БМ(Списки);
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		ПриЗаполненииСписковСОграничениемДоступа_УХМСФО(Списки);
		ПриЗаполненииСписковСОграничениемДоступа_УХ(Списки);
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаполненииПоставляемыхПрофилейГруппДоступа(ОписанияПрофилей, ПараметрыОбновления) Экспорт
	
	ДобавитьОписаниеПрофиля_ПросмотрЭкземпляровКорректировок(ОписанияПрофилей, ПараметрыОбновления);//МСФО
	ДобавитьОписаниеПрофиля_РедактированиеЭкземпляровКорректировок(ОписанияПрофилей, ПараметрыОбновления);//МСФО
	ДобавитьОписаниеПрофиля_РаботаСНастраиваемойОтчетностью(ОписанияПрофилей, ПараметрыОбновления);
		
	Если Не ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
		Возврат;	
	КонецЕсли;
	
	ДобавитьОписаниеПрофиля_УправлениеПроцессом(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_БюджетированиеКазначейство(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_ПросмотрБюджетированиеКазначейство(ОписанияПрофилей, ПараметрыОбновления);
	
	ДобавитьОписаниеПрофиля_СаморегистрацияПоставщика(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_РабочийСтолПоставщика(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_ЦентрализованноеУправлениеЗакупками(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_ОценкаИВыборАльтернатив(ОписанияПрофилей, ПараметрыОбновления);
	
	ДобавитьОписаниеПрофиля_ИсполнительСверкиВГО(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_РуководительСверкиВГО(ОписанияПрофилей, ПараметрыОбновления);
	ДобавитьОписаниеПрофиля_АдминистраторСверкиВГО(ОписанияПрофилей, ПараметрыОбновления);
		
КонецПроцедуры

Процедура ДополнитьПоставляемыеПрофилиГруппДоступа_РСБУ(ОписанияПрофилей, ПараметрыОбновления) Экспорт

	РольИзменениеРСБУ = РольИзменениеРСБУ();
	РольПросмотрРСБУ = РольПросмотрРСБУ();
	
	// Вначале типовым профилям БП добавляются роли УХ
	Для Каждого ОписаниеПрофиля Из ОписанияПрофилей Цикл
		
		Если НЕ ОписаниеПрофиля.Свойство("Назначение") Тогда
		    Продолжить;//группа				
		ИначеЕсли ЕстьВнешнийПользователь(ОписаниеПрофиля) Тогда
			Продолжить;//профиль внешних пользователей
		КонецЕсли;
		
		Если ОписаниеПрофиля.Идентификатор = "62730c03-81d6-11e0-a42a-be487808c52b" Тогда
			Если ИдентификацияПродуктаУХКлиентСервер.ЭтоУправлениеХолдингом() Тогда
				ОписаниеПрофиля.Роли.Добавить("ОтправкаНалоговойОтчетностиУХ");
			КонецЕсли;
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхИнструментыМСФО");
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеТрансляции");
		КонецЕсли;
		
		Если ОписаниеПрофиля.Роли.Найти(РольИзменениеРСБУ) <> Неопределено Тогда
			
			ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхБухгалтерииУХ");
			Если ОбщегоНазначения.ПодсистемаСуществует("ОбъектыКПереносуУП") Тогда				
				ОписаниеПрофиля.Роли.Добавить("ЧтениеПроцессыИСогласование");
			КонецЕсли;
			
		ИначеЕсли ОписаниеПрофиля.Роли.Найти(РольПросмотрРСБУ) <> Неопределено Тогда
			
			ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхБухгалтерииУХ");
			
		КонецЕсли;
		
		ОписаниеПрофиля.Роли.Добавить("БазовыеПраваУХ");
		ОписаниеПрофиля.Роли.Добавить("БазовыеПраваБПУХ");
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область ОписанияПрофилей

Процедура ДобавитьОписаниеПрофиля_ПросмотрЭкземпляровКорректировок(ОписанияПрофилей, ПараметрыОбновления)

 	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "0b1ad145-b715-4ae4-9dec-bcbcad509f44";
	ОписаниеПрофиля.Имя = "ПросмотрЭкземпляровКорректировокУХ";
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Просмотр экземпляров отчетов и корректировок'");

	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля, Истина);
	ДобавитьБазовыеРоли_ДокументыБП(ОписаниеПрофиля, Истина);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"		);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеЭкземпляровОтчетовДокументовУХ"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеБюджетированиеКазначейство"		);
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_РедактированиеЭкземпляровКорректировок(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "c77e865b-8685-44e8-a4a4-6c601de3ffc4";
	ОписаниеПрофиля.Наименование  = "Редактирование экземпляров отчетов и корректировок";

	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля, Ложь);
	ДобавитьБазовыеРоли_ДокументыБП(ОписаниеПрофиля, Истина);
		
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДанныхУчетаУХ"	        );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"			);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДанныхИнструментыМСФО"	);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"			);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеТрансляции"				);
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_РаботаСНастраиваемойОтчетностью(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "c0cb16f1-6b8f-4e41-a1a4-a0de4aa48c86";
									

	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Работа с настраиваемой отчетностью (экземпляры отчетов,корректировки,сводная таблица)'");
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Раздельный доступ к работе с данными настраиваемой отчетности в разрезе видов отчетов, бланков отчетов, бланков сводных таблиц,
		           |пользователей и организационных единиц.'");

	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
			
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"					);
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_УправлениеПроцессом(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "c0cb16f1-6b8f-4e41-a1a4-a0de4aa48c55";
	ОписаниеПрофиля.Имя = "УправлениеПроцессомПодготовкиОтчетностиУХ";
									
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Управление процессом подготовки отчетности'");
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеУправлениеПроцессом");
	ОписаниеПрофиля.Роли.Добавить("УправлениеПроцессамиИСогласованием");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНастройкиМоделиОтчетности");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеПроцессыИСогласование");
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_ЦентрализованноеУправлениеЗакупками(ОписанияПрофилей, ПараметрыОбновления)
	// Профиль "Централизованное управление закупками".
	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "ed172caa-7c13-11e6-b800-20cf30e74fce";
	ОписаниеПрофиля.Имя = "ЦентрализованноеУправлениеЗакупкамиУХ";
	
	ОписаниеПрофиля.Наименование  =
		НСтр("ru = 'Корпоративные закупки'",
			Метаданные.ОсновнойЯзык.КодЯзыка);
			
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваУХ");
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваЭД");
	
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхЦентрализованныхЗакупок");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхУчетаУХ");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеМероприятий");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеНоменклатуры");
	ОписаниеПрофиля.Роли.Добавить("ОценкаИВыборАльтернатив");
	ОписаниеПрофиля.Роли.Добавить("РедактированиеПоступленияТоваровИУслуг");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхПервичныхДокументов");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеНоменклатуры");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ПереопределяемыеОбъектыУП") Тогда
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратовТоваровОтКлиентов");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоговоров");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДоговоровКонтрагентов");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеЗаказовПоставщикам");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеКлассификаторовИНастроекНоменклатуры");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПлановЗакупок");
		ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизацийИБанковскихСчетовОрганизаций");
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("ОбъектыКПереносуУП") Тогда
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхБухгалтерии");
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеВозвратТоваровОтПокупателя");		
		ОписаниеПрофиля.Роли.Добавить("ЧтениеОрганизаций");
	КонецЕсли;
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_БюджетированиеКазначейство(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор 	= "c0cb16f1-6b8f-4e41-a1a4-a0de4aa48c44";
	ОписаниеПрофиля.Имя 			= "БюджетированиеКазначействоУХ";								
	ОписаниеПрофиля.Наименование  	= НСтр("ru = 'Бюджетирование и казначейство'");
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ВстраиваниеУХ.ДобавитьРоль_ДобавлениеИзменениеДанныхБухгалтерии(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДанныхРегламентированнойОтчетности"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДополнительныхСведений"              );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОбщейБухгалтерскойНСИ"               );
	
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЗарплатаКадры"								);
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЭД"                            			);	
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДепонированнойЗарплаты"            	);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДанныхДляНачисленияЗарплаты"        );
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеВыплаченнойЗарплаты"				);
				
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеБюджетированиеКазначейство"			);
	
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБИД" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБП" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБРО" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБТС" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваВЕТИС" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваГИСМ" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЕГАИС" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваИПП" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваИСМП" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваСервисДоставки" );
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваУТ" );
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОрганизацийИБанковскихСчетовОрганизаций" );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоров" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоровАренды" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоровКонтрагентов" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоровКредитовИДепозитов" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоровРасширенная" );
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДокументовПоБанку" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеИзмененийУсловийАрендыОС" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеЗаключенийДоговоровАренды" );
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеПрекращенийДоговоровАренды" );
		
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_СаморегистрацияПоставщика(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = АккредитацияПоставщиковУХ
			.ПолучитьИдентификаторПрофиляГруппыДоступаСаморегистрацияПоставщика();
	ОписаниеПрофиля.Имя = "СаморегистрацияПоставщикаУХ";								
	
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Саморегистрация поставщиков'");
	ОписаниеПрофиля.Назначение.Добавить(Тип("СправочникСсылка.АнкетыПоставщиков"));
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Возможность внешнему поставщику зайти анонимно и
		           |зарегистрироваться в системе.'",
			Метаданные.ОсновнойЯзык.КодЯзыка);
			
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваВнешнихПользователейБСП");	
	ОписаниеПрофиля.Роли.Добавить("ЗапускВебКлиента");	
	ОписаниеПрофиля.Роли.Добавить("ЗапускТонкогоКлиента");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеЗаявкиНаРегистрациюПоставщика");

	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_РабочийСтолПоставщика(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = АккредитацияПоставщиковУХ
			.ПолучитьИдентификаторПрофиляГруппыДоступаРабочийСтолПоставщика();
	ОписаниеПрофиля.Имя = "РабочийСтолПоставщикаУХ";								
									
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Рабочий стол поставщика'");
	ОписаниеПрофиля.Назначение.Добавить(Тип("СправочникСсылка.АнкетыПоставщиков"));
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Возможность внешнему поставщику зайти под своим именем
		           |и заполнить информацию в анекте.'",
			Метаданные.ОсновнойЯзык.КодЯзыка);
			
			
	ОписаниеПрофиля.Роли.Добавить("БазовыеПраваВнешнихПользователейБСП");	
	ОписаниеПрофиля.Роли.Добавить("ЗапускВебКлиента");	
	ОписаниеПрофиля.Роли.Добавить("ЗапускТонкогоКлиента");
	ОписаниеПрофиля.Роли.Добавить("РабочийСтолПоставщика");
	ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеПапокИФайловВнешнимПоставщиком");
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("ВнешниеПользователи");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_ОценкаИВыборАльтернатив(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "7165bd17-3ce9-4380-bdbf-8475b3d2f0b3";
	ОписаниеПрофиля.Имя = "ОценкаИВыборАльтернативУХ";									
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Оценка и выбор альтернатив'");
	
	ОписаниеПрофиля.Описание =
		НСтр("ru = 'Пользователь может оценивать и выбирать доступные для него объекты.'",
			Метаданные.ОсновнойЯзык.КодЯзыка);
			
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить("ОценкаИВыборАльтернатив");

	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_ИсполнительСверкиВГО(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "88bad7e0-43b5-400c-8162-aa938b7e330e";
	ОписаниеПрофиля.Имя = "ИсполнительСверкиВГОУХ";									
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Исполнитель сверки ВГО'");
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДанныхРегламентированнойОтчетности"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДополнительныхСведений"              );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОбщейБухгалтерскойНСИ"               );
	
	ОписаниеПрофиля.Роли.Добавить(  "ИсполнительСверкиВГО"	);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеБюджетированиеКазначейство"			);
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_РуководительСверкиВГО(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "f31d27ae-35cb-49e4-83c4-c149a5a0f527";
									
	ОписаниеПрофиля.Наименование  = "Руководитель сверки ВГО";
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДанныхРегламентированнойОтчетности"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДополнительныхСведений"              );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОбщейБухгалтерскойНСИ"               );
	
	ОписаниеПрофиля.Роли.Добавить(  "ИсполнительСверкиВГО"	);
	ОписаниеПрофиля.Роли.Добавить(  "РуководительСверкиВГО"	);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеБюджетированиеКазначейство"			);
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_АдминистраторСверкиВГО(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "f451faa8-9d90-4e6c-ab3f-9a8a96216737";
	ОписаниеПрофиля.Имя = "АдминистраторСверкиВГОУХ";									
									
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Администратор сверки ВГО'");
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДанныхРегламентированнойОтчетности"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДополнительныхСведений"              );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОбщейБухгалтерскойНСИ"               );
	
	ОписаниеПрофиля.Роли.Добавить(  "ИсполнительСверкиВГО"	);
	ОписаниеПрофиля.Роли.Добавить(  "АдминистраторСверкиВГО"	);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеОтчетностиУХ"						);
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеБюджетированиеКазначейство"			);
	
	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

//Устарела
Процедура ДобавитьОписаниеПрофиля_НалоговыйМониторинг(ОписанияПрофилей, ПараметрыОбновления)

	ПрофильИсточник = Неопределено;
	
	Для каждого ТекущийПрофиль Из ОписанияПрофилей Цикл
		Если ТекущийПрофиль.Имя = "ТолькоПросмотр" ИЛИ ТекущийПрофиль.Имя = "Аудитор" Тогда
			ПрофильИсточник = ТекущийПрофиль;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ПрофильИсточник = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеПрофиля = ОбщегоНазначенияКлиентСервер.СкопироватьРекурсивно(ПрофильИсточник);
	
	ОписаниеПрофиля.Идентификатор	= ИдентификаторПрофиляНалоговогоМониторинга();
	ОписаниеПрофиля.Наименование  	= НСтр("ru = 'Инспектор налогового мониторинга'", Метаданные.ОсновнойЯзык.КодЯзыка);
	ОписаниеПрофиля.Имя				= "ИнспекторНалоговогоМониторинга";
	
	ОписаниеПрофиля.Роли.Добавить("НалоговыйМониторинг");
	ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхБухгалтерииУХ");
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоЕХ() Тогда
		ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхРегламентированнойОтчетности");
		ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхРегламентированногоУчета");
	КонецЕсли;
	
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
	
КонецПроцедуры

Процедура ДобавитьОписаниеПрофиля_ПросмотрБюджетированиеКазначейство(ОписанияПрофилей, ПараметрыОбновления)

	ОписаниеПрофиля = УправлениеДоступом.НовоеОписаниеПрофиляГруппДоступа();
	ОписаниеПрофиля.Идентификатор = "317a3d07-e994-4e3b-9529-0f7ee1a467ee";
	ОписаниеПрофиля.Имя = "ПросмотрБюджетированиеКазначействоУХ";								
	ОписаниеПрофиля.Наименование  = НСтр("ru = 'Просмотр бюджетирование и казначейство'");
	
	ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля);
	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДанныхРегламентированнойОтчетности"	);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДополнительныхСведений"              );	
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеОбщейБухгалтерскойНСИ"               );
	
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЗарплатаКадры"					);
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЭД"							);	
				
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНастройкиМоделиОтчетности"			);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеЭкземпляровОтчетовДокументовУХ"		);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеБюджетированиеКазначейство"			);

	ОписаниеПрофиля.ВидыДоступа.Добавить("Организации");
	ОписанияПрофилей.Добавить(ОписаниеПрофиля);
		
КонецПроцедуры

Функция ИдентификаторПрофиляНалоговогоМониторинга() Экспорт	
	Возврат "588f3e39-a50b-4d3d-83b3-8633e9f3e900";
КонецФункции

#КонецОбласти

#Область БазовыеРоли

Процедура ДобавитьБазовыеРолиБПУХ(ОписаниеПрофиля, ТолькоПросмотр = Ложь)

	//базовые роли (БП и УХ) для базового открытия конфигурации (например профиль РабочийСтолПоставщика)
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоЕХ() Тогда
		
		МодульЕРПУХ = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомУТ");
		МодульЕРПУХ.ДополнитьПрофильОбязательнымиРолями(ОписаниеПрофиля);
				
	Иначе	
		
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБСП"                               );
		ОписаниеПрофиля.Роли.Добавить(  "ВыводНаПринтерФайлБуферОбмена"                 );
		ОписаниеПрофиля.Роли.Добавить(  "ЗапускВебКлиента"                              );
		ОписаниеПрофиля.Роли.Добавить(  "ЗапускТонкогоКлиента"                          );
		ОписаниеПрофиля.Роли.Добавить(  "СохранениеДанныхПользователя"                  );
		ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеВариантовОтчетов"           );//устарела
		ОписаниеПрофиля.Роли.Добавить(  "ЧтениеВариантовОтчетов"                 		);//устарела
		ОписаниеПрофиля.Роли.Добавить(  "ЧтениеЭлектронныхДокументов"					);
	
	КонецЕсли;
	
	ДобавитьБазовыеРолиУХ(ОписаниеПрофиля);

	Если ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеДополнительныхРеквизитовИСведений"  );
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеКурсовВалют"                        );
	ОписаниеПрофиля.Роли.Добавить(  "ДобавлениеИзменениеВидовКонтактнойИнформации"          );
	ОписаниеПрофиля.Роли.Добавить(  "ИзменениеДополнительныхСведений"                       );
	ОписаниеПрофиля.Роли.Добавить(  "ИзменениеМакетовПечатныхФорм"                          );	
	ОписаниеПрофиля.Роли.Добавить(	"ЧтениеДополнительныхОтчетовИОбработок"					);
	ОписаниеПрофиля.Роли.Добавить(  "РедактированиеРеквизитовОбъектов"                      );
		
КонецПроцедуры

Процедура ДобавитьБазовыеРолиУХ(ОписаниеПрофиля)
	
	//базовые роли(УХ) для базового открытия конфигурации (например профиль РабочийСтолПоставщика)
	
	ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБПУХ"			    );
	ОписаниеПрофиля.Роли.Добавить(  "РаботаСКомментариямиУХ"		);
	ОписаниеПрофиля.Роли.Добавить(  "ЧтениеПроцессыИСогласование"	);
	ОписаниеПрофиля.Роли.Добавить(	"БазовыеПраваУХ"				);
	
КонецПроцедуры

Процедура ДобавитьБазовыеРоли_ДокументыБП(ОписаниеПрофиля, ТолькоПросмотр = Ложь)

	//базовые роли (БП) для работы учетных документов, кроме ролей ДобавитьБазовыеРолиБПУХ
	
	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоЕХ() Тогда
		
		МодульЕРПУХ = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомУТ");
		МодульЕРПУХ.ДобавитьРолиБухгалтераРеглУчетаНаЧтение(ОписаниеПрофиля);
		
		//ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоров" );// из ЗУП		
		//ОписаниеПрофиля.Роли.Добавить(  "ЧтениеДоговоровРасширенная" );// из ЗУП
			 		
		#Область ПереносИз_МУ_в_МСФО
		ОписаниеПрофиля.Роли.Добавить("ПодсистемаМеждународныйФинансовыйУчет");
		ОписаниеПрофиля.Роли.Добавить("ЧтениеМеждународныйУчет");
		ОписаниеПрофиля.Роли.Добавить("ЧтениеНастройкаМеждународногоУчета");
		ОписаниеПрофиля.Роли.Добавить("ЧтениеНастроекСчетовУчетаПрочихОпераций");
		
		МодульЕРПУХ = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступомЛокализация");
		МодульЕРПУХ.ДополнитьПрофильПользовательОтчетностиМеждународногоУчета(ОписаниеПрофиля);
		#КонецОбласти

	Иначе //УХ, БМ, НМ
		
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБИД" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБП" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБРО" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваБТС" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваВЕТИС" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваГИСМ" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЕГАИС" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваИПП" );
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваИСМП" );
		
		ОписаниеПрофиля.Роли.Добавить(  "ЧтениеНовостей" );	
		ОписаниеПрофиля.Роли.Добавить(  "БазовыеПраваЭД" );
		
	КонецЕсли;
			
	Если ТолькоПросмотр Тогда
		ОписаниеПрофиля.Роли.Добавить("ЧтениеДанныхБухгалтерииУХ");
	Иначе 
		ОписаниеПрофиля.Роли.Добавить("ДобавлениеИзменениеДанныхБухгалтерииУХ");			
	КонецЕсли;
	
	// Описание поставляемого профиля.
	ОписаниеПрофиля.Описание = НСтр("ru = 'Под профилем выполняются задачи:
						|1. Ведение учета по МСФО.
						|2. Получение отчетов по данным международного учета.';
						|en = 'The following tasks are performed under the profile:
						|1. Financial accounting.
						|2. Receipt of reports according to the financial accounting data.'");

КонецПроцедуры

Функция ЕстьВнешнийПользователь(ОписаниеПрофиля)
	
	Для каждого Назначение Из ОписаниеПрофиля.Назначение Цикл
		Если Назначение = Метаданные.ОпределяемыеТипы.ВнешнийПользователь.Тип Тогда
			Возврат Истина;			
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции

Функция РольИзменениеРСБУ()

	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоЕХ() Тогда
		Возврат "ДобавлениеИзменениеДанныхРегламентированногоУчета";	
	Иначе
		Возврат "ДобавлениеИзменениеДанныхБухгалтерии";
	КонецЕсли;

КонецФункции

Функция РольПросмотрРСБУ()

	Если ИдентификацияПродуктаУХКлиентСервер.ЭтоЕХ() Тогда
		Возврат "ЧтениеДанныхРегламентированногоУчета";	
	Иначе
		Возврат "ЧтениеДанныхБухгалтерии";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ПриЗаполненииСписковСОграничениемДоступа

Процедура ПриЗаполненииСписковСОграничениемДоступа_БМ(Списки)

	#Область ЭО
	Списки.Вставить(Метаданные.Документы.Трансляция, Истина);
	Списки.Вставить(Метаданные.Документы.ТрансформационнаяКорректировка, Истина);
	#КонецОбласти
	
	#Область ДокументыМСФО
	
	Списки.Вставить(Метаданные.Документы.ВводВНАВЭксплуатациюМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ВводНачальныхОстатковВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ВводСведенийВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ВводСведенийОФинансовыхИнструментах, Истина);
	Списки.Вставить(Метаданные.Документы.ВводСобытийВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ВосстановлениеВНАИзРасходов, Истина);
	Списки.Вставить(Метаданные.Документы.ВыбытиеВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ВыработкаВНА, Истина);
	Списки.Вставить(Метаданные.Документы.ИзменениеПараметровВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.МодернизацияВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.НачислениеАмортизацииВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.НачислениеОперацийМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.НачисленияПоФинансовымИнструментам, Истина);
	Списки.Вставить(Метаданные.Документы.ОбесценениеВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ОперацияМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ПереоценкаВалютныхАктивовОбязательств, Истина);
	Списки.Вставить(Метаданные.Документы.ПереоценкаВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.ПереоценкаФинансовыхИнструментов, Истина);
	Списки.Вставить(Метаданные.Документы.ПоступлениеВНАМСФО, Истина);
	
	Списки.Вставить(Метаданные.Документы.ПризнаниеРасходовПоАмортизацииНСБУ, Истина);
	Списки.Вставить(Метаданные.Документы.ПризнаниеРасходовФинансовыхИнструментов, Истина);
	Списки.Вставить(Метаданные.Документы.РасчетОтложенныхНалогов, Истина);
	Списки.Вставить(Метаданные.Документы.РасчетСебестоимости, Истина);
	Списки.Вставить(Метаданные.Документы.РасчетФинансовогоРезультата, Истина);
	Списки.Вставить(Метаданные.Документы.РегламентнаяОперацияПериодаВНАМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.РегламентнаяОперацияПериодаПоФинансовымИнструментамМСФО, Истина);
	Списки.Вставить(Метаданные.Документы.РезервыПоДЗИАвансамВыданным, Истина);
	Списки.Вставить(Метаданные.Документы.РезервыПоЗапасам, Истина);
	Списки.Вставить(Метаданные.Документы.РеклассАПСчетов, Истина);
	Списки.Вставить(Метаданные.Документы.РеклассОтложенныхНалогов, Истина);
	Списки.Вставить(Метаданные.Документы.РеформацияБаланса, Истина);
	
	#КонецОбласти
	
	Списки.Вставить(Метаданные.ЖурналыДокументов.ДокументыПоВНАМСФО, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.ДокументыПоФинансовымИнструментам, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.РегламентныеОперацииМСФО, Истина);
	
	#Область РегистрыМСФО
	Списки.Вставить(Метаданные.РегистрыСведений.АрендованныеВНА, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.ЗапасыРеклассифицированныеВОС, Истина);
	
	Списки.Вставить(Метаданные.РегистрыНакопления.ВыработкаВНА, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.РасчетныеДанныеВНА, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.РасчетныеДанныеДЗ, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.РасчетныеДанныеЗапасы, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.РасчетныеДанныеФИ, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.СтоимостьВНАМСФО, Истина);
	
	Списки.Вставить(Метаданные.РегистрыБухгалтерии.МСФО, Истина);
	#КонецОбласти
	
КонецПроцедуры

Процедура ПриЗаполненииСписковСОграничениемДоступа_УХ(Списки)

	Списки.Вставить(Метаданные.РегистрыСведений.АккредитованыеПоставщики, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.НоменклатураАккредитованыхПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.ПоставщикиПоЛотам, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СостоянияАккредитованныхПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УсловияПредложенийПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УчастникиКвалификации, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УчастникиКвалифицированныеПоЛоту, Истина);
	
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияАккредитив, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияБанковскаяГарантия, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияВалютноПроцентныйСвоп, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияВалютныйСвоп, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияВалютныйФорвард, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияДепозит, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияКоммерческийДоговор, Истина);
	Списки.Вставить(Метаданные.Документы.ВерсияСоглашенияКредит, Истина);
	
	Списки.Вставить(Метаданные.Документы.ОтражениеФактическихДанныхБюджетирования, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СогласованиеОтчетов, Истина);
	Списки.Вставить(Метаданные.Документы.КорректировкаНачальныхОстатков, Истина);
	Списки.Вставить(Метаданные.Документы.АккредитацияПоставщика, Истина); 
	Списки.Вставить(Метаданные.Документы.ОповещениеАккредитованныхПоставщиковОТоргах, Истина); 
	Списки.Вставить(Метаданные.Документы.ОтзывАккредитации, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.ИспользованиеЭТППоставщиками, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.НоменклатураАккредитованыхПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.ПоставщикиПоЛотам, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.СостоянияАккредитованныхПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УсловияПредложенийПоставщиков, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УчастникиКвалификации, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.УчастникиКвалифицированныеПоЛоту, Истина);
	Списки.Вставить(Метаданные.Справочники.Лоты, Истина);
		
	Списки.Вставить(Метаданные.Документы.КвалификацияПоставщика, Истина);
	Списки.Вставить(Метаданные.Документы.ПредложениеПоставщика, Истина);
	Списки.Вставить(Метаданные.Документы.СогласованиеДокументов, Истина);
	Списки.Вставить(Метаданные.РегистрыСведений.АккредитованыеПоставщики, Истина);
	Списки.Вставить(Метаданные.Справочники.АнкетыПоставщиков, Истина);
	Списки.Вставить(Метаданные.Документы.РеестрПлатежей, 	Истина);
	
	//
	
	Списки.Вставить(Метаданные.Документы.ЗаявкаНаРасходованиеДенежныхСредств, Истина);		
	Списки.Вставить(Метаданные.Документы.ОжидаемоеПоступлениеДенежныхСредств, Истина);	
	Списки.Вставить(Метаданные.Документы.СправкаОПодтверждающихДокументах, Истина); 
	Списки.Вставить(Метаданные.Справочники.ВнешнихПоставщиковПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ЗаказПоставщику, Истина);
	
	Списки.Вставить(Метаданные.Документы.АкцептПротестПереводногоВекселя, Истина);
	Списки.Вставить(Метаданные.Документы.ВыбытиеВекселей, Истина);
	Списки.Вставить(Метаданные.Документы.ВыпускЦеннойБумаги, Истина);
	Списки.Вставить(Метаданные.Документы.ПоступлениеВекселя, Истина);
	Списки.Вставить(Метаданные.Документы.ПриобретениеЦеннойБумаги, Истина);
	Списки.Вставить(Метаданные.Документы.ПродажаЦеннойБумаги, Истина);
	Списки.Вставить(Метаданные.Документы.ВыкупЦеннойБумаги, Истина);
	
	Списки.Вставить(Метаданные.ЖурналыДокументов.ОперацииСВекселями, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.ОперацииСЦеннымиБумагами, Истина);
	
КонецПроцедуры

Процедура ПриЗаполненииСписковСОграничениемДоступа_УХМСФО(Списки)
	
	#Область ТК
	Списки.Вставить(Метаданные.Документы.РучныеКорректировки, Истина);
	#КонецОбласти
	
	#Область Инвестиции
	Списки.Вставить(Метаданные.Документы.ВыбытиеИнвестиций, Истина);
	Списки.Вставить(Метаданные.Документы.КонсолидационныеПоправки, Истина);
	Списки.Вставить(Метаданные.Документы.ПоступлениеИнвестиций, Истина);
	Списки.Вставить(Метаданные.ЖурналыДокументов.ДвижениеИнвестиций, Истина);
	Списки.Вставить(Метаданные.РегистрыНакопления.ДвижениеИнвестиций, Истина);
	#КонецОбласти
	
	Списки.Вставить(Метаданные.Документы.ПовторениеКорректировокПрошлыхПериодов, Истина);
	
КонецПроцедуры

#КонецОбласти
