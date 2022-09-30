#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// В качестве данных заполнения может принимать структуру с полями.
//		Ссылка
//		Действие
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	НачислениеЗаПервуюПоловинуМесяца.Организация,
			|	НачислениеЗаПервуюПоловинуМесяца.Подразделение,
			|	НачислениеЗаПервуюПоловинуМесяца.Начислено,
			|	НачислениеЗаПервуюПоловинуМесяца.Удержано,
			|	НачислениеЗаПервуюПоловинуМесяца.КраткийСоставДокумента,
			|	НачислениеЗаПервуюПоловинуМесяца.Ответственный,
			|	НачислениеЗаПервуюПоловинуМесяца.Комментарий
			|ИЗ
			|	Документ.НачислениеЗаПервуюПоловинуМесяца КАК НачислениеЗаПервуюПоловинуМесяца
			|ГДЕ
			|	НачислениеЗаПервуюПоловинуМесяца.Ссылка = &Ссылка");
			
			Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	// Заполним описание данных для проведения в учете начисленной зарплаты.
	ДанныеДляПроведенияУчетЗарплаты = ОтражениеЗарплатыВУчете.ОписаниеДанныеДляПроведения();
	ДанныеДляПроведенияУчетЗарплаты.Движения 				= Движения;
	ДанныеДляПроведенияУчетЗарплаты.Организация 			= Организация;
	ДанныеДляПроведенияУчетЗарплаты.ПериодРегистрации 		= МесяцНачисления;
	ДанныеДляПроведенияУчетЗарплаты.Авансом 				= Истина;
	ДанныеДляПроведенияУчетЗарплаты.ОкончательныйРасчет		= Ложь;
	ДанныеДляПроведенияУчетЗарплаты.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
	
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьНачисленияАвансом(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.НачисленияПоСотрудникам);
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьОтработанноеВремяАвансом(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам);

	УчетНачисленнойЗарплаты.СоздатьВТРаспределениеНачисленийТекущегоДокумента(ДанныеДляПроведенияУчетЗарплаты);
	
	УчетНачисленнойЗарплатыРасширенный.ЗарегистрироватьУдержанияАвансом(ДанныеДляПроведенияУчетЗарплаты, Отказ, ДанныеДляПроведения.УдержанияПоСотрудникам);
		
	Если НДФЛ.Количество() > 0 
		И (УдержатьНалогПриВыплатеАванса 
			Или УчетНДФЛРасширенный.УдерживатьНалогПриВыплатеАванса(Организация) 
			Или ПланируемаяДатаВыплаты >= НачалоДня(КонецМесяца(МесяцНачисления))) Тогда
		// - Регистрация в учете по НДФЛ и регистрация НДФЛ в учете начислений и удержаний.
		УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПриНачисленииАванса(Ссылка, Движения, Отказ, Организация, Дата, МесяцНачисления, ПланируемаяДатаВыплаты, ДанныеДляПроведения);
	КонецЕсли;
	
	// - Регистрация НДФЛ в учете начислений и удержаний.
	УчетНачисленнойЗарплаты.ПодготовитьДанныеНДФЛКРегистрации(ДанныеДляПроведения.НДФЛПоСотрудникам, Организация, МесяцНачисления);
	УчетНачисленнойЗарплаты.ЗарегистрироватьНДФЛИКорректировкиВыплаты(ДанныеДляПроведенияУчетЗарплаты, Отказ,
		ДанныеДляПроведения.НДФЛПоСотрудникам, Неопределено);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьПериодДействияНачислений(Отказ);
	
	УчетНДФЛДокументы.ПроверитьЗаполненияКодовВычетаДокумента(ЭтотОбъект, Отказ);
	
	// Проверка корректности распределения по источникам финансирования
	ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,Удержания,НДФЛ";
	
	ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
		ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
	
	// Проверка корректности распределения по территориям и условиям труда
	ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления";
	
	РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
		ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Начисления", "Начисления"));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", "Удержания", "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Функция ДанныеДляПроведения()
	
	СписокФизическихЛиц = Неопределено;
	Если ДополнительныеСвойства.Свойство("ФизическиеЛица")
		И ДополнительныеСвойства.ФизическиеЛица.Количество() > 0 Тогда
		
		СписокФизическихЛиц = ДополнительныеСвойства.ФизическиеЛица
		
	КонецЕсли;
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, Ссылка, "Начисления", "Ссылка.МесяцНачисления", , СписокФизическихЛиц);
	РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведения, Ссылка, , СписокФизическихЛиц);
	РасчетЗарплаты.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, Ссылка, , СписокФизическихЛиц);
	
	РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, Ссылка, СписокФизическихЛиц);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли