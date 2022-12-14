

&Вместо("ПроверитьУдалитьОбъектРасчетов")
Процедура ллл_ПроверитьУдалитьОбъектРасчетов(ОбъектРасчетов, Отказ, ВызыватьИсключение) Экспорт
	
	Если Не ЗначениеЗаполнено(ОбъектРасчетов)  Тогда
		ВызватьИсключение(НСтр("ru = 'Невозможно создать объект расчетов. Не указаны обязательные параметры.';
								|en = 'Cannot create AR/AP object. Required parameters are missing.'"))
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	ОбъектРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	КритерийОтбора.ОбъектРасчетов(&ОбъектРасчетов) КАК ОбъектРасчетов
	|ГДЕ
	|	ОбъектРасчетов.Ссылка <> &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
	|ГДЕ
	|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
	|	И Расчеты.Регистратор <> &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.ДокументРегистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Расчеты
	|ГДЕ
	|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
	|	И Расчеты.ДокументРегистратор <> &Ссылка
	|	И НЕ Расчеты.ДокументРегистратор ССЫЛКА Документ.РасчетКурсовыхРазниц
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам КАК Расчеты
	|ГДЕ
	|	Расчеты.ЗаказКлиента = &ОбъектРасчетов
	|	И Расчеты.Регистратор <> &Ссылка
	|	И НЕ Расчеты.Регистратор ССЫЛКА Документ.РасчетКурсовыхРазниц
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
	|ГДЕ
	|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
	|	И Расчеты.Регистратор <> &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.ДокументРегистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК Расчеты
	|ГДЕ
	|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
	|	И Расчеты.ДокументРегистратор <> &Ссылка
	|	И НЕ Расчеты.ДокументРегистратор ССЫЛКА Документ.РасчетКурсовыхРазниц
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 100
	|	Расчеты.Регистратор КАК Ссылка
	|ИЗ
	|	РегистрНакопления.РасчетыСПоставщикамиПоДокументам КАК Расчеты
	|ГДЕ
	|	Расчеты.ЗаказПоставщику = &ОбъектРасчетов
	|	И Расчеты.Регистратор <> &Ссылка
	|	И НЕ Расчеты.Регистратор ССЫЛКА Документ.РасчетКурсовыхРазниц
	|";
	Запрос.УстановитьПараметр("ОбъектРасчетов", ОбъектРасчетов);
	Запрос.УстановитьПараметр("Ссылка", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектРасчетов, "Объект"));
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбъектРасчетовОбъект = ОбъектРасчетов.ПолучитьОбъект();
		Попытка
			ОбъектРасчетовОбъект.Заблокировать();
		Исключение
			ВызватьИсключение(НСтр("ru = 'Изменение запрещено, объект расчетов уже используется в других сеансах.';
									|en = 'Cannot make changes. The AR/AP object is already used in other sessions.'"));
		КонецПопытки; 
		попытка
			ОбъектРасчетовОбъект.Удалить();
		исключение
		
		КонецПопытки;
		
		УстановитьПривилегированныйРежим(Ложь);
	ИначеЕсли ВызыватьИсключение Тогда
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Изменение запрещено, объект расчетов %1 используется в других объектах:';
					|en = 'Cannot make changes. Reason: AR/AP object %1 is used by other objects:'"),
				ОбъектРасчетов);
		Отказ = Истина;
		Сообщить(Сообщение);
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщение = Новый СообщениеПользователю();
			Сообщение.КлючДанных = Выборка.Ссылка;
			Сообщение.Текст = Символы.Таб + Выборка.Ссылка;
			Сообщение.Сообщить();
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры