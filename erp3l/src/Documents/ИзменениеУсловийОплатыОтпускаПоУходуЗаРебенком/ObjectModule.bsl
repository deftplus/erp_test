#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		ДатаНачала = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаНачала");
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru = 'Дата изменения';
																											|en = 'Change date'"), ДатаНачала, НСтр("ru = 'даты начала отпуска';
																																					|en = 'leave start dates'"), Ложь);
		ОтпускаПоУходуЗаРебенком.ПроверитьЗаполнениеПериодовВыплатыПособий(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	КонецЕсли;
	
	Если ВыплачиватьПособиеДоПолутораЛет И ДатаИзменения > ДатаОкончанияПособияДоПолутораЛет Тогда
		
		ТекстСообщения = НСтр("ru = 'Дата изменения больше срока действия';
								|en = 'Change date is greater than validity period'") + " " + ПособиеДоПолутораЛет;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ДатаОкончанияПособияДоПолутораЛет", , Отказ);
		
	КонецЕсли;
	
	Если ВыплачиватьПособиеДоТрехЛет И ДатаИзменения > ДатаОкончанияПособияДоТрехЛет Тогда
		
		ТекстСообщения = НСтр("ru = 'Дата изменения больше срока действия';
								|en = 'Change date is greater than validity period'") + " " + ПособиеДоТрехЛет;
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "Объект.ДатаОкончанияПособияДоТрехЛет", , Отказ);
		
	КонецЕсли;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	СписокФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник);
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект"));
	
	ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(СписокФизическихЛиц, Истина, Организация, ДатаИзменения);
	Если Не ОсновныеСотрудники.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = '%1 не работает в организации на %2.';
								|en = '%1 does not work for the company on %2.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сотрудник, Формат(ДатаИзменения,"ДЛФ=D"));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Объект.Сотрудник",, Отказ);
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	КадровыйУчетРасширенный.ПроверкаСпискаНачисленийКадровогоДокумента(
		ЭтотОбъект, ДатаИзменения, "Начисления,Льготы", "Показатели", Отказ, Истина, "РабочееМесто", "Начисление,Льгота");
	
	Если ИзменитьНачисления И НачисленияУтверждены Тогда
		
		ПлановыеНачисления = ПолучитьДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком(Отказ).ПлановыеНачисления;
		ТаблицаПособийПоУходу = РасчетЗарплатыРасширенный.ПустаяТаблицаПлановыхНачислений();
		Для Каждого ТекСтрока Из ПлановыеНачисления Цикл
			НоваяСтрока = ТаблицаПособийПоУходу.Добавить();
			НоваяСтрока.Сотрудник = ТекСтрока.Сотрудник;
			НоваяСтрока.Период = ТекСтрока.ДатаСобытия;
			НоваяСтрока.Начисление = ТекСтрока.Начисление;
			НоваяСтрока.Действие = Перечисления.ДействияСНачислениямиИУдержаниями.Утвердить;
		КонецЦикла;
		РасчетЗарплатыРасширенный.ПроверитьМножественностьОплатыВремениУходЗаРебенком(ДатаИзменения, Начисления, Ссылка, Отказ, ТаблицаПособийПоУходу, , ИсправленныйДокумент);		
	КонецЕсли;
	
	ИсключаемыеРеквизиты = Новый Массив;
	
	Если ИзменитьАванс Тогда
		Если Авансы.Количество() = 1 И Не ЗначениеЗаполнено(Авансы[0].СпособРасчетаАванса) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен способ расчета аванса.';
									|en = 'Advance calculation method is not entered.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "СпособРасчетаАванса",, Отказ);
			ИсключаемыеРеквизиты.Добавить("Авансы.СпособРасчетаАванса");
		КонецЕсли;
	Иначе
		ИсключаемыеРеквизиты.Добавить("Авансы.СпособРасчетаАванса");
	КонецЕсли;
	
	// Если пособие не выплачивается, то его заполнение не обязательно.
	Если Не ВыплачиватьПособиеДоПолутораЛет Или Не НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("ПособиеДоПолутораЛет");
	КонецЕсли;
	Если Не ВыплачиватьПособиеДоТрехЛет Или Не НачисленияУтверждены Тогда
		ИсключаемыеРеквизиты.Добавить("ПособиеДоТрехЛет");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
	Если НачисленияУтверждены Тогда
		УчетПособийСоциальногоСтрахованияРасширенный.ПроверитьВозможностьЗаписиРегистраУсловияОплаты(Организация, ОсновнойСотрудник, ДатаИзменения, Ссылка, Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(Ссылка, Движения, РежимПроведения, Отказ,,, ЭтотОбъект, "ДатаИзменения");
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		Возврат;
	КонецЕсли;
		
	// Проведение документа
	Если НачисленияУтверждены Тогда
		
		ДанныеДляПроведения = ПолучитьДанныеДляПроведения();
		
		ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеДляПроведения.СотрудникиДаты, Ссылка);
		
		Если ИзменитьНачисления Или ИзменитьЛьготы Тогда
			
			СтруктураПлановыхНачислений = Новый Структура;
			СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведения.ПлановыеНачисления);
			СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
			СтруктураПлановыхНачислений.Вставить("ПрименениеДополнительныхПоказателей", ДанныеДляПроведения.ПрименениеДополнительныхПоказателей);
			
			РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
			РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок(Движения, ДанныеДляПроведения.ПорядокПересчетаТарифнойСтавки);
			
		КонецЕсли;
		
		Если ИзменитьПрименениеПлановыхНачислений Тогда
			РасчетЗарплатыРасширенный.СформироватьДвиженияПримененияПлановыхНачислений(Движения, ДанныеДляПроведения.ПрименениеНачислений);
			СостоянияСотрудников.ЗарегистрироватьСостоянияСотрудников(Движения, Ссылка, ДанныеСостоянийСотрудника());
		КонецЕсли;
		
		Если ИзменитьАванс Тогда
			РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат(Движения, ДанныеДляПроведения.ПлановыеАвансы);
		КонецЕсли;
		
		ДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком = ПолучитьДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком(Отказ);
		
		СтруктураПлановыхНачислений = Новый Структура;
		СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком.ПлановыеНачисления);
		СтруктураПлановыхНачислений.Вставить("ЗначенияПоказателей", ДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком.ЗначенияПоказателей);
		
		РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
		
		Если ВыплачиватьПособиеДоПолутораЛет Тогда
			УчетПособийСоциальногоСтрахованияРасширенный.СформироватьДвиженияУсловийОплатыОтпускаПоУходуЗаРебенком(Движения, ДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком.УсловияОплатыОтпускаПоУходуЗаРебенком);
		КонецЕсли;
		
		УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
		
		Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ОсвобождатьСтавку") Тогда
			
			ДатаОкончания = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаОкончания");
			Сотрудники = КадровыйУчетРасширенный.МассивСотрудников(Сотрудник, Организация, ДатаОкончания);
			КадровыйУчетРасширенный.СформироватьДвиженияЗанятостиВременноОсвобожденныхПозицииШтатногоРасписания(
				Движения, Сотрудники, ДатаИзменения, ДатаОкончания, Истина, ДокументОснование);
			
		КонецЕсли;
	КонецЕсли;
	
	КадровыйУчетРасширенный.ЗарегистрироватьВРеестреОтпусков(Движения, ДанныеРеестраОтпусков(), Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
		
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ОбъектОснование = ДанныеЗаполнения;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("Сотрудник") Тогда
		ОбъектОснование = ДанныеЗаполнения.Сотрудник;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("СправочникСсылка.Сотрудники") Тогда
		
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ОбъектОснование);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("РабочееМесто", ОбъектОснование);
		Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
			|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка,
			|	ОтпускПоУходуЗаРебенкомНачисления.Ссылка.ДатаНачала КАК ДатаНачала
			|ИЗ
			|	Документ.ОтпускПоУходуЗаРебенком.Начисления КАК ОтпускПоУходуЗаРебенкомНачисления
			|ГДЕ
			|	ОтпускПоУходуЗаРебенкомНачисления.РабочееМесто = &РабочееМесто
			|	И ОтпускПоУходуЗаРебенкомНачисления.Ссылка.Проведен
			|
			|УПОРЯДОЧИТЬ ПО
			|	ДатаНачала УБЫВ";
			
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			
			ОбъектОснование = Выборка.Ссылка;
			
		КонецЕсли; 
		
	КонецЕсли;
	
	Если ТипЗнч(ОбъектОснование) = Тип("ДокументСсылка.ОтпускПоУходуЗаРебенком") Тогда
		
		Если Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектОснование, "Проведен") Тогда
			ВызватьИсключение НСтр("ru = 'Ввод на основании непроведенного документа невозможен.';
									|en = 'You cannot use the ""input on basis"" method for unposted document.'");
		КонецЕсли;
		
		ИменаРеквизитов = 
		"Организация, 
		|Сотрудник, 
		|ВыплачиватьПособиеДоПолутораЛет,
		|ПособиеДоПолутораЛет,
		|ВыплачиватьПособиеДоТрехЛет, 
		|ПособиеДоТрехЛет,
		|ДатаОкончанияПособияДоПолутораЛет,
		|ДатаОкончанияПособияДоТрехЛет, 
		|КоличествоДетей, 
		|КоличествоПервыхДетей";
		
		ДокументОснование = ОбъектОснование;
		ДатаИзменения = ТекущаяДатаСеанса();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбъектОснование, ИменаРеквизитов)); 
		
	ИначеЕсли ТипЗнч(ОбъектОснование) = Тип("Структура") Тогда
		Если ОбъектОснование.Свойство("Действие") И ОбъектОснование.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ОбъектОснование.Ссылка);
			
			ИсправленныйДокумент = ОбъектОснование.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьРеквизитыОснования(Реквизиты = Неопределено) Экспорт
	
	Если Реквизиты = Неопределено Тогда
		Реквизиты = 
		"ДатаНачала,
		|ВыплачиватьПособиеДоПолутораЛет,
		|ПособиеДоПолутораЛет,
		|ДатаОкончанияПособияДоПолутораЛет,
		|КоличествоДетей,
		|КоличествоПервыхДетей,
		|ФинансированиеФедеральнымБюджетом,
		|ВыплачиватьПособиеДоТрехЛет,
		|ПособиеДоТрехЛет,
		|ДатаОкончанияПособияДоТрехЛет,
		|СреднийДневнойЗаработок,
		|МинимальныйСреднедневнойЗаработок,
		|ПрименятьЛьготыПриНачисленииПособия,
		|РасчетПоПравилам2010Года,
		|ДоляНеполногоВремени,
		|РайонныйКоэффициентРФнаНачалоСобытия";
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументОснование, Реквизиты);
	
КонецФункции

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	ДанныеДляПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеУсловийОплаты.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеУсловийОплатыНачисления.РабочееМесто КАК Сотрудник,
		|	ИзменениеУсловийОплатыНачисления.Начисление,
		|	ВЫБОР
		|		КОГДА ИзменениеУсловийОплатыНачисления.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Используется,
		|	ИзменениеУсловийОплаты.Сотрудник КАК ФизическоеЛицо,
		|	ИзменениеУсловийОплаты.Организация.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ИзменениеУсловийОплатыНачисления.ДокументОснование КАК ДокументОснование,
		|	ИзменениеУсловийОплатыНачисления.Размер,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ИзменениеУсловийОплатыНачисления
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыНачисления.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|			И (ИзменениеУсловийОплаты.Ссылка = &Ссылка)
		|			И (ИзменениеУсловийОплаты.ИзменитьНачисления)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ИзменениеУсловийОплаты.ДатаИзменения,
		|	ИзменениеУсловийОплатыЛьготы.РабочееМесто,
		|	ИзменениеУсловийОплатыЛьготы.Льгота,
		|	ВЫБОР
		|		КОГДА ИзменениеУсловийОплатыЛьготы.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ,
		|	ИзменениеУсловийОплаты.Сотрудник,
		|	ИзменениеУсловийОплаты.Организация.ГоловнаяОрганизация,
		|	ИзменениеУсловийОплатыЛьготы.ДокументОснование,
		|	ИзменениеУсловийОплатыЛьготы.Размер,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Льготы КАК ИзменениеУсловийОплатыЛьготы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыЛьготы.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|			И (ИзменениеУсловийОплаты.Ссылка = &Ссылка)
		|			И (ИзменениеУсловийОплаты.ИзменитьЛьготы)";
	
	// Таблица для формирования плановых начислений.
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	ПлановыеНачисления = ?(ИзменитьНачисления Или ИзменитьЛьготы, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеУсловийОплаты.Организация КАК Организация,
		|	Сотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
		|	ИзменениеУсловийОплатыНачисления.РабочееМесто КАК Сотрудник,
		|	ИзменениеУсловийОплатыПоказатели.Показатель КАК Показатель,
		|	ИзменениеУсловийОплатыНачисления.ДокументОснование КАК ДокументОснование,
		|	ИзменениеУсловийОплатыПоказатели.Значение КАК Значение,
		|	ИзменениеУсловийОплаты.ДатаИзменения КАК ДатаСобытия
		|ПОМЕСТИТЬ ВТПоказатели
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Показатели КАК ИзменениеУсловийОплатыПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ИзменениеУсловийОплатыНачисления
		|		ПО ИзменениеУсловийОплатыПоказатели.Ссылка = ИзменениеУсловийОплатыНачисления.Ссылка
		|			И ИзменениеУсловийОплатыПоказатели.ИдентификаторСтрокиВидаРасчета = ИзменениеУсловийОплатыНачисления.ИдентификаторСтрокиВидаРасчета
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыПоказатели.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|			И (ИзменениеУсловийОплаты.ИзменитьНачисления)
		|			И (ИзменениеУсловийОплаты.Ссылка = &Ссылка)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО (Сотрудники.Ссылка = ИзменениеУсловийОплатыНачисления.РабочееМесто)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ИзменениеУсловийОплаты.Организация,
		|	ИзменениеУсловийОплаты.Сотрудник,
		|	ИзменениеУсловийОплатыЛьготы.РабочееМесто,
		|	ИзменениеУсловийОплатыПоказатели.Показатель,
		|	ИзменениеУсловийОплатыЛьготы.ДокументОснование,
		|	ИзменениеУсловийОплатыПоказатели.Значение,
		|	ИзменениеУсловийОплаты.ДатаИзменения
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Показатели КАК ИзменениеУсловийОплатыПоказатели
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Льготы КАК ИзменениеУсловийОплатыЛьготы
		|		ПО ИзменениеУсловийОплатыПоказатели.Ссылка = ИзменениеУсловийОплатыЛьготы.Ссылка
		|			И ИзменениеУсловийОплатыПоказатели.ИдентификаторСтрокиВидаРасчета = ИзменениеУсловийОплатыЛьготы.ИдентификаторСтрокиВидаРасчета
		|			И (ИзменениеУсловийОплатыЛьготы.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить))
		|			И (ИзменениеУсловийОплатыПоказатели.Ссылка = &Ссылка)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыПоказатели.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|			И (ИзменениеУсловийОплаты.ИзменитьЛьготы)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Показатели.Организация КАК Организация,
		|	Показатели.ФизическоеЛицо КАК ФизическоеЛицо,
		|	Показатели.Сотрудник КАК Сотрудник,
		|	Показатели.Показатель КАК Показатель,
		|	Показатели.ДокументОснование КАК ДокументОснование,
		|	МАКСИМУМ(Показатели.Значение) КАК Значение,
		|	Показатели.ДатаСобытия КАК ДатаСобытия,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	ВТПоказатели КАК Показатели
		|
		|СГРУППИРОВАТЬ ПО
		|	Показатели.Организация,
		|	Показатели.ФизическоеЛицо,
		|	Показатели.Сотрудник,
		|	Показатели.Показатель,
		|	Показатели.ДокументОснование,
		|	Показатели.ДатаСобытия";
	
	// Таблица значений показателей расчета зарплаты.
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	ЗначенияПоказателей = ?(ИзменитьНачисления Или ИзменитьЛьготы, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеУсловийОплатыАвансы.РабочееМесто КАК Сотрудник,
		|	ИзменениеУсловийОплатыАвансы.РабочееМесто.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
		|	ЗНАЧЕНИЕ(ПЕРЕЧИСЛЕНИЕ.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия,
		|	ИзменениеУсловийОплатыАвансы.СпособРасчетаАванса КАК СпособРасчетаАванса,
		|	ИзменениеУсловийОплатыАвансы.Аванс КАК Аванс,
		|	ИзменениеУсловийОплаты.ДатаИзменения КАК ДатаСобытия,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ИзменениеУсловийОплаты.Сотрудник КАК ФизическоеЛицо
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Авансы КАК ИзменениеУсловийОплатыАвансы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыАвансы.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|ГДЕ
		|	ИзменениеУсловийОплаты.Ссылка = &Ссылка";
	
	// Таблица значений формирования движений по авансам.
	// см. описание РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
	ПлановыеАвансы = ?(ИзменитьАванс, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ПлановыеАвансы", ПлановыеАвансы);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеУсловийОплатыПрименениеПлановыхНачислений.РабочееМесто КАК Сотрудник,
		|	ИзменениеУсловийОплатыПрименениеПлановыхНачислений.Применение,
		|	ИзменениеУсловийОплаты.ДатаИзменения КАК ДатаСобытия
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ПрименениеПлановыхНачислений КАК ИзменениеУсловийОплатыПрименениеПлановыхНачислений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком КАК ИзменениеУсловийОплаты
		|		ПО ИзменениеУсловийОплатыПрименениеПлановыхНачислений.Ссылка = ИзменениеУсловийОплаты.Ссылка
		|ГДЕ
		|	ИзменениеУсловийОплаты.Ссылка = &Ссылка";
	
	// Таблица значений формирования движений по применению плановых начислений.
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПримененияПлановыхНачислений.
	ПрименениеНачислений = ?(ИзменитьПрименениеПлановыхНачислений, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ПрименениеНачислений", ПрименениеНачислений);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.ДатаИзменения КАК ДатаСобытия,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Организация КАК Организация,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто КАК Сотрудник,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо,
		|	ВЫБОР
		|		КОГДА ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Действие = ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК Применение
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Показатели КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка КАК Ссылка,
		|			ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Показатель КАК Показатель,
		|			ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто КАК РабочееМесто
		|		ИЗ
		|			Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления
		|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Показатели КАК ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели
		|				ПО ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка = ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка
		|					И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.РабочееМесто = ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто
		|					И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.ИдентификаторСтрокиВидаРасчета = ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета
		|		ГДЕ
		|			ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Ссылка = &Ссылка
		|			И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомНачисления.Действие <> ЗНАЧЕНИЕ(Перечисление.ДействияСНачислениямиИУдержаниями.Отменить)) КАК ПоказателиНачислений
		|		ПО ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = ПоказателиНачислений.Ссылка
		|			И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.РабочееМесто = ПоказателиНачислений.РабочееМесто
		|			И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Показатель = ПоказателиНачислений.Показатель
		|ГДЕ
		|	ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Ссылка = &Ссылка
		|	И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.ИдентификаторСтрокиВидаРасчета = 0
		|	И ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенкомПоказатели.Показатель <> ЗНАЧЕНИЕ(Справочник.ПоказателиРасчетаЗарплаты.ПустаяСсылка)
		|	И ПоказателиНачислений.Показатель ЕСТЬ NULL ";
	
	// Таблица применения дополнительных показателей.
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений.
	ПрименениеДополнительныхПоказателей = ?(ИзменитьНачисления, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ПрименениеДополнительныхПоказателей",ПрименениеДополнительныхПоказателей);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПересчетТарифныхСтавок.Ссылка.ДатаИзменения КАК ДатаСобытия,
		|	ПересчетТарифныхСтавок.РабочееМесто КАК Сотрудник,
		|	ПересчетТарифныхСтавок.Ссылка.Сотрудник КАК ФизическоеЛицо,
		|	ПересчетТарифныхСтавок.ПорядокРасчетаСтоимостиЕдиницыВремени КАК ПорядокРасчета,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДействуетДо
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ПересчетТарифныхСтавок КАК ПересчетТарифныхСтавок
		|ГДЕ
		|	ПересчетТарифныхСтавок.Ссылка = &Ссылка";
	
	// Таблица порядка пересчета тарифной ставки.
	// см. описание РасчетЗарплатыРасширенный.СформироватьДвиженияПорядкаПересчетаТарифныхСтавок.
	ПорядокПересчетаТарифнойСтавки = ?(ИзменитьНачисления, Запрос.Выполнить().Выгрузить(), Неопределено);
	ДанныеДляПроведения.Вставить("ПорядокПересчетаТарифнойСтавки", ПорядокПересчетаТарифнойСтавки);
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Начисления.Ссылка.ДатаИзменения КАК ДатаСобытия,
		|	Начисления.РабочееМесто КАК Сотрудник
		|ИЗ
		|	Документ.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.Начисления КАК Начисления
		|ГДЕ
		|	Начисления.Ссылка = &Ссылка";
	
	// Таблица для формирования времени регистрации документа.
	// см. описание ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента.
	СотрудникиДаты = Запрос.Выполнить().Выгрузить();
	ДанныеДляПроведения.Вставить("СотрудникиДаты", СотрудникиДаты);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеРеестраОтпусков()
	
	// Данные для Реестра отпусков
	ДанныеРеестраОтпусков = КадровыйУчетРасширенный.ТаблицаРеестраОтпусков();
	НоваяСтрока = ДанныеРеестраОтпусков.Добавить();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", ДокументОснование);
	Запрос.УстановитьПараметр("Сотрудник", ОсновнойСотрудник);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МАКСИМУМ(РеестрОтпусков.Период) КАК Период,
		|	РеестрОтпусков.Сотрудник КАК Сотрудник,
		|	РеестрОтпусков.ДокументОснование КАК ДокументОснование
		|ПОМЕСТИТЬ ВТПоследнийПериодОснований
		|ИЗ
		|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
		|ГДЕ
		|	РеестрОтпусков.Регистратор = &Регистратор
		|	И РеестрОтпусков.Сотрудник = &Сотрудник
		|
		|СГРУППИРОВАТЬ ПО
		|	РеестрОтпусков.Сотрудник,
		|	РеестрОтпусков.ДокументОснование
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РеестрОтпусков.Сотрудник КАК Сотрудник,
		|	РеестрОтпусков.ФизическоеЛицо КАК ФизическоеЛицо,
		|	РеестрОтпусков.ДокументОснование КАК ДокументОснование,
		|	РеестрОтпусков.Номер КАК Номер,
		|	РеестрОтпусков.ВидОтпуска КАК ВидОтпуска,
		|	РеестрОтпусков.ВидДоговора КАК ВидДоговора,
		|	РеестрОтпусков.Основание КАК Основание,
		|	РеестрОтпусков.НачалоПериодаЗаКоторыйПредоставляетсяОтпуск КАК НачалоПериодаЗаКоторыйПредоставляетсяОтпуск,
		|	РеестрОтпусков.КонецПериодаЗаКоторыйПредоставляетсяОтпуск КАК КонецПериодаЗаКоторыйПредоставляетсяОтпуск,
		|	РеестрОтпусков.ДатаНачалаПериодаОтсутствия КАК ДатаНачалаПериодаОтсутствия
		|ИЗ
		|	РегистрСведений.РеестрОтпусков КАК РеестрОтпусков
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПоследнийПериодОснований КАК ПоследнийПериодОснований
		|		ПО РеестрОтпусков.Период = ПоследнийПериодОснований.Период
		|			И РеестрОтпусков.Сотрудник = ПоследнийПериодОснований.Сотрудник
		|			И РеестрОтпусков.ДокументОснование = ПоследнийПериодОснований.ДокументОснование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	
	НоваяСтрока.Период = Дата;
	НоваяСтрока.ДатаОкончанияПериодаОтсутствия = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументОснование, "ДатаОкончания");
	
	НоваяСтрока.КоличествоДнейОтпуска = ЗарплатаКадрыКлиентСервер.ДнейВПериоде(
		НоваяСтрока.ДатаНачалаПериодаОтсутствия, НоваяСтрока.ДатаОкончанияПериодаОтсутствия);
	
	Возврат ДанныеРеестраОтпусков;
	
КонецФункции

Функция ПолучитьДанныеДляПроведенияОплатаОтпускаПоУходуЗаРебенком(Отказ)
	
	ДанныеДляПроведения = Новый Структура;
	
	РегистрироватьПособиеДоПолутораЛет	= Истина;
	РегистрироватьПособиеДоТрехЛет		= Истина;
	
	ГоловнаяОрганизация = ЗарплатаКадры.ГоловнаяОрганизация(Организация);
	
	РеквизитыОснования = ПолучитьРеквизитыОснования();
	Если Не РеквизитыОснования.ВыплачиватьПособиеДоПолутораЛет И Не ВыплачиватьПособиеДоПолутораЛет Тогда
		// Если пособие не начислялось и не начисляется.
		РегистрироватьПособиеДоПолутораЛет = Ложь;
	КонецЕсли;
	
	Если Не РеквизитыОснования.ВыплачиватьПособиеДоТрехЛет И Не ВыплачиватьПособиеДоТрехЛет Тогда
		РегистрироватьПособиеДоТрехЛет = Ложь;
	КонецЕсли;
	
	ПлановыеНачисления = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииПлановыхНачислений();
	ПлановыеНачисления.Колонки.Добавить("ИспользуетсяПоОкончании", Новый ОписаниеТипов("Булево"));
	
	ЗначенияПоказателей = РасчетЗарплатыРасширенный.ПустаяТаблицаРегистрацииЗначенийПериодическихПоказателей();
	
	Если РегистрироватьПособиеДоПолутораЛет Тогда
		УсловияОплатыОтпускаПоУходуЗаРебенком = Новый ТаблицаЗначений;
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("СтраховойСлучай");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("Период");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("Сотрудник");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("Организация");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("ФизическоеЛицо");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("СреднийДневнойЗаработок");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("МинимальныйСреднедневнойЗаработок");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("КоличествоДетей");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("КоличествоПервыхДетей");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("ПрименятьЛьготыПриНачисленииПособия");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("РасчетПоПравилам2010Года");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("ФинансированиеФедеральнымБюджетом");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("ДатаНачалаСобытия");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("ДоляНеполногоВремени");
		УсловияОплатыОтпускаПоУходуЗаРебенком.Колонки.Добавить("РайонныйКоэффициентРФнаНачалоСобытия");
	КонецЕсли;
	
	СписокФизическихЛиц = Новый Массив;
	СписокФизическихЛиц.Добавить(Сотрудник);
	
	ОсновныеСотрудники = КадровыйУчет.ОсновныеСотрудникиФизическихЛиц(СписокФизическихЛиц, Истина, Организация, ДатаИзменения);
	Если Не ОсновныеСотрудники.Количество() > 0 Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = '%1 не работает в организации на %2. Проведение невозможно.';
								|en = '%1 does not work for the company on %2. Posting is impossible.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Сотрудник, Формат(ДатаИзменения,"ДЛФ=D"));
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если Не Отказ Тогда
		Если РегистрироватьПособиеДоПолутораЛет Тогда
			// Если пособие начислялось, его нужно прекратить, 
			// не прекращаем, только если оно и дальше продолжает начисляться и тем же видом оплаты.
			Если РеквизитыОснования.ВыплачиватьПособиеДоПолутораЛет Тогда
				Если Не ВыплачиватьПособиеДоПолутораЛет
					Или РеквизитыОснования.ПособиеДоПолутораЛет <> ПособиеДоПолутораЛет Тогда
					
					НоваяСтрока = ПлановыеНачисления.Добавить();
					НоваяСтрока.ДатаСобытия = ДатаИзменения;
					НоваяСтрока.Сотрудник = ОсновнойСотрудник;
					НоваяСтрока.ФизическоеЛицо = Сотрудник;
					НоваяСтрока.ГоловнаяОрганизация = ГоловнаяОрганизация;
					НоваяСтрока.Начисление = РеквизитыОснования.ПособиеДоПолутораЛет;
					НоваяСтрока.Используется = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ВыплачиватьПособиеДоПолутораЛет Тогда
			    НоваяСтрока = ПлановыеНачисления.Добавить();
				НоваяСтрока.ДатаСобытия = ДатаИзменения;
				НоваяСтрока.ДействуетДо = КонецДня(ДатаОкончанияПособияДоПолутораЛет) + 1;
				НоваяСтрока.Сотрудник = ОсновнойСотрудник;
				НоваяСтрока.ФизическоеЛицо = Сотрудник;
				НоваяСтрока.ГоловнаяОрганизация = ГоловнаяОрганизация;
				НоваяСтрока.Начисление = ПособиеДоПолутораЛет;
				НоваяСтрока.Используется = Истина;
				
				НоваяСтрока = УсловияОплатыОтпускаПоУходуЗаРебенком.Добавить();
				НоваяСтрока.Период = ДатаИзменения;
				НоваяСтрока.Организация = Организация;
				НоваяСтрока.ФизическоеЛицо = Сотрудник;
				НоваяСтрока.КоличествоДетей = КоличествоДетей;
				НоваяСтрока.КоличествоПервыхДетей = КоличествоПервыхДетей;
				НоваяСтрока.СтраховойСлучай = ДокументОснование;
				НоваяСтрока.Сотрудник = ОсновнойСотрудник;
				
				НоваяСтрока.СреднийДневнойЗаработок = РеквизитыОснования.СреднийДневнойЗаработок;
				НоваяСтрока.МинимальныйСреднедневнойЗаработок = РеквизитыОснования.МинимальныйСреднедневнойЗаработок;
				НоваяСтрока.ПрименятьЛьготыПриНачисленииПособия = РеквизитыОснования.ПрименятьЛьготыПриНачисленииПособия;
				НоваяСтрока.ФинансированиеФедеральнымБюджетом = РеквизитыОснования.ФинансированиеФедеральнымБюджетом;
				НоваяСтрока.ДатаНачалаСобытия = РеквизитыОснования.ДатаНачала;
				НоваяСтрока.РасчетПоПравилам2010Года = РеквизитыОснования.РасчетПоПравилам2010Года;
				НоваяСтрока.ДоляНеполногоВремени = РеквизитыОснования.ДоляНеполногоВремени;
				НоваяСтрока.РайонныйКоэффициентРФнаНачалоСобытия = РеквизитыОснования.РайонныйКоэффициентРФнаНачалоСобытия;
			КонецЕсли;
		КонецЕсли;
		
		Если РегистрироватьПособиеДоТрехЛет Тогда
			Если РеквизитыОснования.ВыплачиватьПособиеДоТрехЛет Тогда
				Если Не ВыплачиватьПособиеДоТрехЛет 
					Или РеквизитыОснования.ПособиеДоТрехЛет <> ПособиеДоТрехЛет Тогда
					
					НоваяСтрока = ПлановыеНачисления.Добавить();
					НоваяСтрока.ДатаСобытия = ДатаИзменения;
					НоваяСтрока.Сотрудник = ОсновнойСотрудник;
					НоваяСтрока.ФизическоеЛицо = Сотрудник;
					НоваяСтрока.ГоловнаяОрганизация = ГоловнаяОрганизация;
					НоваяСтрока.Начисление = РеквизитыОснования.ПособиеДоТрехЛет;
					НоваяСтрока.Используется = Ложь;
				КонецЕсли;
			КонецЕсли;
			
			Если ВыплачиватьПособиеДоТрехЛет Тогда
				НоваяСтрока = ПлановыеНачисления.Добавить();
				НоваяСтрока.ДатаСобытия = ДатаИзменения;
				НоваяСтрока.ДействуетДо = КонецДня(ДатаОкончанияПособияДоТрехЛет) + 1;
				НоваяСтрока.Сотрудник = ОсновнойСотрудник;
				НоваяСтрока.ФизическоеЛицо = Сотрудник;
				НоваяСтрока.ГоловнаяОрганизация = ГоловнаяОрганизация;
				НоваяСтрока.Начисление = ПособиеДоТрехЛет;
				НоваяСтрока.Размер = РазмерПособияДоТрехЛетФиксированнойСуммой;
				НоваяСтрока.Используется = Истина;
				ОтборПоказателейПособия = Новый Структура("ИдентификаторСтрокиВидаРасчета", Документы.ОтпускПоУходуЗаРебенком.ИдентификаторСтрокПоказателейПособияДоТрехЛет());
				НайденныеСтроки = Показатели.НайтиСтроки(ОтборПоказателейПособия);
				
				Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
					НоваяСтрока = ЗначенияПоказателей.Добавить();
					НоваяСтрока.ДатаСобытия = ДатаИзменения;
					НоваяСтрока.ДействуетДо = КонецДня(ДатаОкончанияПособияДоТрехЛет) + 1;
					НоваяСтрока.Сотрудник = ОсновнойСотрудник;
					НоваяСтрока.ФизическоеЛицо = Сотрудник;
					НоваяСтрока.Организация = Организация;
					НоваяСтрока.Показатель = СтрокаТаблицы.Показатель;
					НоваяСтрока.Значение = СтрокаТаблицы.Значение;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеДляПроведения.Вставить("ПлановыеНачисления", ПлановыеНачисления);
	ДанныеДляПроведения.Вставить("УсловияОплатыОтпускаПоУходуЗаРебенком", УсловияОплатыОтпускаПоУходуЗаРебенком);
	ДанныеДляПроведения.Вставить("ЗначенияПоказателей", ЗначенияПоказателей);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеСостоянийСотрудника()
	
	// Начинаем состояние либо «Работа в отпуске по уходу за ребенком», 
	// либо «Отпуск по уходу за ребенком» в зависимости от применения плановых начислений.
	ДанныеСостояний = СостоянияСотрудников.ПустаяТаблицаДанныхСостоянийСотрудника();
	Для Каждого СтрокаТаблицы Из ПрименениеПлановыхНачислений Цикл
		НоваяСтрока = ДанныеСостояний.Добавить();
		НоваяСтрока.Сотрудник = СтрокаТаблицы.РабочееМесто;
		НоваяСтрока.Начало = ДатаИзменения;
		Если СтрокаТаблицы.Применение Тогда
			НоваяСтрока.Состояние = Перечисления.СостоянияСотрудника.РаботаВОтпускеПоУходуЗаРебенком;
		Иначе
			НоваяСтрока.Состояние = Перечисления.СостоянияСотрудника.ОтпускПоУходуЗаРебенком;
		КонецЕсли;
	КонецЦикла;

	Возврат ДанныеСостояний;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ИзменениеУсловийОплатыОтпускаПоУходуЗаРебенком.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
														
КонецФункции	

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли