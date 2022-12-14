#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СведенияОВалютныхОперациях") Тогда	
		Корректировка = Истина;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Номер,Дата,Проведен");
		ВалютныеОперации.Загрузить(ДанныеЗаполнения.ВалютныеОперации.Выгрузить());
		ДокументОснование = ДанныеЗаполнения;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	
	Движения.СведенияВалютногоКонтроляУчетныхДокументов.Записывать = Истина;
	
	Для Каждого ТекСтрока Из ВалютныеОперации Цикл
		НовоеДвижение = Движения.СведенияВалютногоКонтроляУчетныхДокументов.Добавить();
		НовоеДвижение.ДокументРасчетов = ТекСтрока.Документ;
		НовоеДвижение.Период = Дата;
		НовоеДвижение.СрокРепатриации = ТекСтрока.ОжидаемыйСрок;
		НовоеДвижение.СуммаДокументаРасчетов = ТекСтрока.СуммаОперации;
	КонецЦикла;
	
	// Напоминание.
	СоздатьНапоминаниеПроверитьОжидаемыеСрокиСВО();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СведенияОВалютныхОперациях.Ссылка
	|ИЗ
	|	Документ.СведенияОВалютныхОперациях КАК СведенияОВалютныхОперациях
	|ГДЕ
	|	СведенияОВалютныхОперациях.ДокументОснование = &Ссылка
	|	И СведенияОВалютныхОперациях.Проведен";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(
			НСтр("ru = 'Обнаружены корректировочные СВО к текущему документу. Удаление проведения невозможно.'"),
			Отказ,,
			СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Генерирует напоминание о необходимости проверить ожидаемые сроки 
// в документе Справка о валютных операциях.
Процедура СоздатьНапоминаниеПроверитьОжидаемыеСрокиСВО()
	// Если это корректировка, то сбросим все задачи по основанию.
	Если ЗначениеЗаполнено(ДокументОснование) Тогда
		МодульРегламентныхЗаданийУХ.СброситьЗадачиПоСвязанномуОбъекту(ДокументОснование);
	Иначе
		// Не корректировка. Не нужно сбрасывать основание.
	КонецЕсли;
	
	// Непосредственная отправка напоминаний.
	ВидСобытияПроверитьОжидаемыеСрокиСВО = Справочники.ВидыСобытийОповещений.Напоминание_ПроверитьОжидаемыеСрокиСВО;
	СтруктураНастроек = МодульУправленияОповещениямиУХ.ПолучитьНастройкиОповещенийПоВидуСобытия(ВидСобытияПроверитьОжидаемыеСрокиСВО);
	Если СтруктураНастроек.Количество() > 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	&Организация КАК Организация,
		|	РасчетыСКонтрагентамиПоДокументамОстатки.СуммаОстаток КАК СуммаОстаток,
		|	ВалютныеОперации.ОжидаемыйСрок КАК ОжидаемыйСрок,
		|	&Ответственный КАК Ответственный
		|ИЗ
		|	Документ.СведенияОВалютныхОперациях.ВалютныеОперации КАК ВалютныеОперации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.РасчетыСКонтрагентамиПоДокументам.Остатки(, Организация = &Организация) КАК РасчетыСКонтрагентамиПоДокументамОстатки
		|		ПО ВалютныеОперации.Документ = РасчетыСКонтрагентамиПоДокументамОстатки.ДокументРасчетов
		|ГДЕ
		|	ВалютныеОперации.Ссылка = &Ссылка
		|	И ВалютныеОперации.ОжидаемыйСрок <> &ПустаяДата
		|	И РасчетыСКонтрагентамиПоДокументамОстатки.СуммаОстаток <> 0";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Ответственный", Ответственный);
		Запрос.УстановитьПараметр("Организация", Организация);
		Запрос.УстановитьПараметр("ПустаяДата", Дата(1, 1, 1));
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ПользовательАдресат = ВыборкаДетальныеЗаписи.Ответственный;
			ДатаФормированияСВО = ВыборкаДетальныеЗаписи.ОжидаемыйСрок;
			СтруктураНапоминание = МодульУправленияОповещениямиУХ.СоздатьСтруктуруНапоминанияПоУмолчанию(СтруктураНастроек, ПользовательАдресат, ДатаФормированияСВО, Ссылка);
			МодульУправленияОповещениямиУХ.ДобавитьНапоминаниеПользователяСЗадачей(СтруктураНапоминание);
		КонецЦикла;
	Иначе
		// Не настроек по данному оповещению. Не отправляем.
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
	

#КонецЕсли