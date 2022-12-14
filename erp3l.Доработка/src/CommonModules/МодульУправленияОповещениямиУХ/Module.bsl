
&ИзменениеИКонтроль("ПодготовитьТекстОповещенияПоШаблону")
Функция ллл_ПодготовитьТекстОповещенияПоШаблону(ТекстШаблона, ПараметрыПроцесса, ОбъектССылка, ФлОшибки)

	ТекстШаблонаРабочий = ТекстШаблона;
	ТекстШаблонаИтог = ТекстШаблона;
	СтруктураПараметров = Новый Структура;
	// Обработаем нессылочные параметры.
	Пока СтрНайти(ТекстШаблонаРабочий,"[Параметр.")>0 Цикл 
		СтруктураЗначениеПараметра = ОбработатьПараметрШаблона("Параметр.", ПараметрыПроцесса, ОбъектССылка, ФлОшибки, ТекстШаблонаРабочий);
		ТекстШаблонаИтог = СтрЗаменить(ТекстШаблонаИтог, СтруктураЗначениеПараметра.ТекПараметр, СтруктураЗначениеПараметра.ПредставлениеЗначения);
		ТекстШаблонаРабочий = СтрЗаменить(ТекстШаблонаРабочий,СтруктураЗначениеПараметра.ТекПараметр,"");
	КонецЦикла;	
	// Обработаем ссылочные параметры и добавим навигационную ссылку в шаблон.
	Пока СтрНайти(ТекстШаблонаРабочий,"[#Параметр.")>0 Цикл 
		СтруктураЗначениеПараметра = ОбработатьПараметрШаблона("#Параметр.", ПараметрыПроцесса, ОбъектССылка, ФлОшибки, ТекстШаблонаРабочий);
		ЗначениеВСтруктуре = СтруктураЗначениеПараметра.ЗначениеПараметра;
		Если ЗначениеЗаполнено(ЗначениеВСтруктуре) Тогда
			ЭтоСкалярныйТип = (ТипЗнч(ЗначениеВСтруктуре) = Тип("Число") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Булево") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Строка") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Дата"));
			Если НЕ ЭтоСкалярныйТип Тогда
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ЗначениеВСтруктуре);
				ЗначениеПараметра = "<a href='" + НавигационнаяСсылка + "'>" + Строка(ЗначениеВСтруктуре) + "</a>";
			Иначе
				ЗначениеПараметра = Строка(ЗначениеВСтруктуре);
			КонецЕсли;
		Иначе
			ЗначениеПараметра = "";
		КонецЕсли;
		ТекстШаблонаИтог = СтрЗаменить(ТекстШаблонаИтог, СтруктураЗначениеПараметра.ТекПараметр, ЗначениеПараметра);
		ТекстШаблонаРабочий = СтрЗаменить(ТекстШаблонаРабочий, СтруктураЗначениеПараметра.ТекПараметр, "");
	КонецЦикла;
	#Вставка
	// (. Лопатин. 22.03.2022.
	// Обработаем ссылочные параметры и добавим Внешнюю навигационную ссылку в шаблон.
	АдресПубликации = СокрЛП(Константы.АдресПубликацииИнформационнойБазыВИнтернете.Получить());
	Пока СтрНайти(ТекстШаблонаРабочий,"[##Параметр.")>0 Цикл 
		СтруктураЗначениеПараметра = ОбработатьПараметрШаблона("##Параметр.", ПараметрыПроцесса, ОбъектССылка, ФлОшибки, ТекстШаблонаРабочий);
		ЗначениеВСтруктуре = СтруктураЗначениеПараметра.ЗначениеПараметра;
		Если ЗначениеЗаполнено(ЗначениеВСтруктуре) Тогда
			ЭтоСкалярныйТип = (ТипЗнч(ЗначениеВСтруктуре) = Тип("Число") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Булево") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Строка") ИЛИ ТипЗнч(ЗначениеВСтруктуре) = Тип("Дата"));
			Если НЕ ЭтоСкалярныйТип Тогда
				НавигационнаяСсылка = ПолучитьНавигационнуюСсылку(ЗначениеВСтруктуре);
				Если ЗначениеЗаполнено(АдресПубликации) Тогда
					Если Прав(АдресПубликации, 1) <> "/" Тогда
						АдресПубликации = АдресПубликации + "/";
					КонецЕсли;
					НавигационнаяСсылка = СтрШаблон("%1#%2", АдресПубликации, НавигационнаяСсылка);
				//	ЗначениеПараметра = Новый ФорматированнаяСтрока(Строка(ЗначениеВСтруктуре),, WebЦвета.ГрифельноСиний,, НавигационнаяСсылка);
				//Иначе
				КонецЕсли;
				ЗначениеПараметра = "<a href='" + НавигационнаяСсылка + "'>" + Строка(ЗначениеВСтруктуре) + "</a>";
			Иначе
				ЗначениеПараметра = Строка(ЗначениеВСтруктуре);
			КонецЕсли;
		Иначе
			ЗначениеПараметра = "";
		КонецЕсли;
		ТекстШаблонаИтог = СтрЗаменить(ТекстШаблонаИтог, СтруктураЗначениеПараметра.ТекПараметр, ЗначениеПараметра);
		ТекстШаблонаРабочий = СтрЗаменить(ТекстШаблонаРабочий, СтруктураЗначениеПараметра.ТекПараметр, "");
	КонецЦикла;
	// ).
	#КонецВставки

	Возврат ТекстШаблонаИтог;

КонецФункции
