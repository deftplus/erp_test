#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ОбновитьТабличнуюЧастьСотрудники(СписокФизическихЛиц = Неопределено) Экспорт 
	
	Если СписокФизическихЛиц = Неопределено Тогда 
		СписокФизическихЛиц = ОбщегоНазначения.ВыгрузитьКолонку(Сотрудники, "ФизическоеЛицо");
	КонецЕсли;
	
	ДанныеСотрудников = Документы.ХодатайствоОБронированииГражданПребывающихВЗапасе.КадровыеДанныеФизическихЛиц(СписокФизическихЛиц, Организация, Дата);
	ДанныеСотрудников.Колонки.Добавить("ДанныеВоинскогоУчета", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(200)));
	
	Запрос = Новый Запрос;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДанныеСотрудников", ДанныеСотрудников);
	
	ОписаниеФиксацииРеквизитов = Документы.ХодатайствоОБронированииГражданПребывающихВЗапасе.ПараметрыФиксацииВторичныхДанных().ОписаниеФиксацииРеквизитов;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСотрудников.ФизическоеЛицо КАК ФизическоеЛицо,";
	Для каждого ОписаниеРеквизита Из ОписаниеФиксацииРеквизитов Цикл
		Запрос.Текст = Запрос.Текст + "
		|	ДанныеСотрудников." + ОписаниеРеквизита.Значение.ИмяРеквизита + " КАК " + ОписаниеРеквизита.Значение.ИмяРеквизита + ",";
	КонецЦикла;
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Запрос.Текст, 1);
	
	Запрос.Текст = Запрос.Текст + "
	|ПОМЕСТИТЬ ВТВторичныеДанные
	|ИЗ
	|	&ДанныеСотрудников КАК ДанныеСотрудников";
	
	Запрос.Выполнить();
	
	Возврат ФиксацияВторичныхДанныхВДокументах.ОбновитьВторичныеДанные(Запрос.МенеджерВременныхТаблиц, ЭтотОбъект, "Сотрудники");
	
КонецФункции

Функция ОбъектЗафиксирован() Экспорт
	
	Возврат Проведен;
	
КонецФункции 

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли