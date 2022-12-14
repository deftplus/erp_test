// Управляет доступностью элементов формы
&НаСервере
Процедура УправлениеДоступностью()
	РеквизитыЗаполнены = ЗначениеЗаполнено(Объект.ЭтапСогласования) И ЗначениеЗаполнено(Объект.ЭкземплярПроцесса);
	Элементы.ФормаДобавитьСогласующих.Доступность = РеквизитыЗаполнены;
КонецПроцедуры

// Отображает таблицу дополнительных согласующих по этапу ЭтапВход
&НаСервере
Процедура ОтображениеТаблицыДопСогласования(ЭтапВход)
	ТаблицаДопСогласования.Очистить();
	Если ЗначениеЗаполнено(Объект.ЭкземплярПроцесса) И ЗначениеЗаполнено(Объект.ЭтапСогласования) Тогда
		РезультатДопСогласование = МодульСогласованияДокументовУХ.ПолучитьТаблицуДопСогласующихПоЭтапу(Объект.ЭкземплярПроцесса, ЭтапВход);
		РезультатДопСогласование.Колонки.Добавить("ПредставлениеСтатуса");
		Для Каждого ТекРезультатДопСогласование Из РезультатДопСогласование Цикл
			ТекАрхивнаяЗапись	 = ТекРезультатДопСогласование.АрхивнаяЗапись;
			ТекВиза				 = ТекРезультатДопСогласование.Виза;
			ТекПредставление = МодульСогласованияДокументовУХ.ПредставлениеСтатусаДопСогласования(ТекАрхивнаяЗапись, ТекВиза);
			ТекРезультатДопСогласование.ПредставлениеСтатуса = ТекПредставление;
		КонецЦикла;
		ТаблицаДопСогласования.Загрузить(РезультатДопСогласование);
	Иначе
		// Нет необходимых данных для обновления таблицы.
	КонецЕсли;
КонецПроцедуры

// Возвращает организацию, которая сопоставлена текущему документу согласования.
&НаСервере
Функция ПолучитьОрганизациюДокумента()
	РезультатФункции = Справочники.Организации.ПустаяСсылка();
	Если ЗначениеЗаполнено(Объект.ЭкземплярПроцесса) Тогда
		РезультатФункции = Объект.ЭкземплярПроцесса.Организация;
	Иначе
		РезультатФункции = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Добавляет на теущий этап согласования дополнительных согласующих из массива 
// МассивДобавляемыхВход от имени текущего пользователя.
&НаКлиенте
Процедура ДобавитьДополнительныхСогласующихНаТекущийЭтап(МассивДобавляемыхВход)
	ТекПользователь = ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	РезультатДобавления = МодульСогласованияДокументовУХ.ДобавитьДополнительныхСогласующих(МассивДобавляемыхВход, Объект.ЭкземплярПроцесса, Объект.ЭтапСогласования, ТекПользователь);
	Если РезультатДобавления Тогда
		Если МассивДобавляемыхВход.Количество() = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Согласующий %Пользователь% на этап %Этап% добавлен'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Этап%", Строка(Объект.ЭтапСогласования));
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Пользователь%", Строка(МассивДобавляемыхВход[0]));
		Иначе	
			ТекстПредупреждения = НСтр("ru = 'Согласующие на этап %Этап% добавлены'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Этап%", Строка(Объект.ЭтапСогласования));
		КонецЕсли;
		ЗаголовокПредупреждения = НСтр("ru = 'Добавление согласующих'");
		ПоказатьОповещениеПользователя(ЗаголовокПредупреждения, , ТекстПредупреждения, БиблиотекаКартинок.ЗначокКадры32);
	Иначе
		ТекстОшибки = НСтр("ru = 'Не удалось добавить согласующих на этап %Этап%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Этап%", Строка(Объект.ЭтапСогласования));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСогласующихЗавершение(Результат, Параметры) Экспорт
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
	МассивСогласующих = Параметры.МассивСогласующих;
	ОрганизацияДокумента = ПолучитьОрганизациюДокумента();
	РезультатДобавления = МодульСогласованияДокументовУХ.УдалитьДополнительныхСогласующих(МассивСогласующих, Объект.ЭкземплярПроцесса, Объект.ЭтапСогласования, ОрганизацияДокумента);
	Если РезультатДобавления Тогда
		Если МассивСогласующих.Количество() = 1 Тогда
			ТекстПредупреждения = НСтр("ru = 'Согласующий %Пользователь% на этапе %Этап% удален'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Этап%", Строка(Объект.ЭтапСогласования));
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Пользователь%", Строка(МассивСогласующих[0]));
		Иначе	
			ТекстПредупреждения = НСтр("ru = 'Согласующие на этапе %Этап% удалены'");
			ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%Этап%", Строка(Объект.ЭтапСогласования));
		КонецЕсли;
		ЗаголовокПредупреждения = НСтр("ru = 'Удаление согласующих'");
		ПоказатьОповещениеПользователя(ЗаголовокПредупреждения, , ТекстПредупреждения, БиблиотекаКартинок.ЗначокКадры32);
	Иначе
		ТекстОшибки = НСтр("ru = 'Не удалось удалить согласующих на этап %Этап%'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Этап%", Строка(Объект.ЭтапСогласования));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстОшибки);
	КонецЕсли;
	ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
	Оповестить("ОбновитьДопСогласующих");
	УправлениеДоступностью();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Получение параметров.
	Объект.ЭкземплярПроцесса	 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ЭкземплярПроцесса", Документы.ЭкземплярПроцесса.ПустаяСсылка());
	Объект.ЭтапСогласования		 = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ЭтапСогласования", Справочники.ЭтапыУниверсальныхПроцессов.ПустаяСсылка());
	
	////Одновременное допсогласование с замещением в текущей версии не поддерживается.
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//|	Заместители.ЗамещаемыйПользователь
	//|ИЗ
	//|	РегистрСведений.Заместители КАК Заместители";
	//
	//Заместители = Запрос.Выполнить().Выбрать();
	//Пока Заместители.Следующий() Цикл 		
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
	//	НСтр("ru = 'При наличии заместителей назначение дополнительных согласующих запрещено'"),,,);		
	//	Отказ = Истина;
	//КонецЦикла;	 
		
	Если ЗначениеЗаполнено(Объект.ЭтапСогласования) Тогда
		
		Если Объект.ЭтапСогласования.ТипЭтапа<>Перечисления.ТипыЭтаповУниверсальныхПроцессов.ЭтапСогласования Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Для данного этапа управление дополнительными согласующими запрещено'"),,,);		
			Отказ = Истина;
		КонецЕсли;	 
		
	КонецЕсли;	
	
	// Заполнение данных.
	ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСогласующих(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ОткрытьФорму("Справочник.Пользователи.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
	УправлениеДоступностью();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив") Тогда
		ДобавитьДополнительныхСогласующихНаТекущийЭтап(ВыбранноеЗначение);
		ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
		УправлениеДоступностью();
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи") Тогда
		МассивДляДобавления = Новый Массив;
		МассивДляДобавления.Добавить(ВыбранноеЗначение);
		ДобавитьДополнительныхСогласующихНаТекущийЭтап(МассивДляДобавления);
		ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
		УправлениеДоступностью();
	Иначе
		ТекстОшибки = НСтр("ru = 'Неизвестный вариант добавления согласующих: %ВыбранноеЗначение%. Операция отменена.'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%ВыбранноеЗначение%", Строка(ВыбранноеЗначение));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстОшибки);
	КонецЕсли;
	Оповестить("ОбновитьДопСогласующих");
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСогласующих(Команда)
	МассивСогласующих = Новый Массив;
	Для Каждого ТекВыделенныеСтроки Из Элементы.ТаблицаДопСогласования.ВыделенныеСтроки Цикл
		ТекСтрокаТаблицы = Элементы.ТаблицаДопСогласования.ДанныеСтроки(ТекВыделенныеСтроки);
		МассивСогласующих.Добавить(ТекСтрокаТаблицы.Согласующий);
	КонецЦикла;
	Если МассивСогласующих.Количество() > 0 Тогда
		ТекстВопроса = НСтр("ru = 'Удалить %КоличествоПользователей% дополнительных согласующих из этапа %Этап%?'");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%КоличествоПользователей%", Строка(МассивСогласующих.Количество()));
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%Этап%", Строка(Объект.ЭтапСогласования));
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("МассивСогласующих", МассивСогласующих);
		ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСогласующихЗавершение", ЭтаФорма, ДополнительныеПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		// Нет пользователей для удаления. Ничего не делаем.
	КонецЕсли;
	ОтображениеТаблицыДопСогласования(Объект.ЭтапСогласования);
	УправлениеДоступностью();
КонецПроцедуры

