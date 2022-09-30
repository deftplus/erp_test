#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа И ДатаРождения > ТекущаяДатаСеанса() Тогда
		
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Дата рождения не может быть больше текущей';
				|en = 'Date of birth cannot be greater than the current one'"),
			,
			"ФизическоеЛицо.ДатаРождения",
			,
			Отказ);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаРождения) Тогда
		ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаРождения, "ФизическоеЛицо.ДатаРождения", Отказ, НСтр("ru = 'Дата рождения';
																												|en = 'Date of birth'"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьНаименованиеСлужебное();
	ЗаполнитьЧастиИмени();
	ЗаполнитьИнициалы();

	ПерсонифицированныйУчетКлиентСервер.УстановитьФорматСтраховогоНомераПФР(СтраховойНомерПФР);
	Справочники.ФизическиеЛица.ПодготовитьОбновлениеЗависимыхДанныхПриОбменеПередЗаписью(ЭтотОбъект);
	
	ЗапомнитьРеквизитыПрежнегоСостоянияОбъекта();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаименованиеСлужебное()
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
		
	НаименованиеСлужебное = ФизическиеЛицаЗарплатаКадры.НаименованиеСлужебное(Наименование);
	
КонецПроцедуры

Процедура ЗаполнитьЧастиИмени()
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ФИОУстановлены") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСреза = РегистрыСведений.ФИОФизическихЛиц.СрезПоследних(, Новый Структура("ФизическоеЛицо", Ссылка));
	
	Если ДанныеСреза.Количество() > 0 И Не ПустаяСтрока(ДанныеСреза[0].Фамилия) Тогда
		ЧастиИмени = ДанныеСреза[0];
	Иначе
		ЧастиИмени = ФизическиеЛицаКлиентСервер.ЧастиИмени(ФИО);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЧастиИмени, "Фамилия,Имя,Отчество");
	
КонецПроцедуры

Процедура ЗаполнитьИнициалы()
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Инициалы) Тогда
		
		Если Не ПустаяСтрока(Имя) Тогда
			Инициалы = ФизическиеЛицаЗарплатаКадрыКлиентСервер.ИнициалыПоИмениОтчеству(Имя, Отчество);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапомнитьРеквизитыПрежнегоСостоянияОбъекта()
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	ИменаРеквизитов = ОбщегоНазначения.ВыгрузитьКолонку(Метаданные.Справочники.ФизическиеЛица.Реквизиты, "Имя");
	ПрежниеЗначения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СтрСоединить(ИменаРеквизитов, ","));
	
	ДополнительныеСвойства.Вставить("ПрежниеЗначения", ПрежниеЗначения);
	
	ФизическиеЛицаЗарплатаКадры.ЗапомнитьРеквизитыПрежнегоСостоянияОбъекта(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли