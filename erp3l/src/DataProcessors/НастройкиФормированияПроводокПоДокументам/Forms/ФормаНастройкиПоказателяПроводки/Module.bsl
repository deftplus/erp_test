
&НаКлиенте
Процедура ПроцедураРедактированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	 СтандартнаяОбработка=Ложь;
	 ПерейтиВРежимРедактированияПроцедуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВРежимРедактированияПроцедуры()
	
	Если (Не ЗначениеЗаполнено(ПоказательОтчета)) ИЛИ Модифицированность Тогда
		
		ТекстВопроса = НСтр("ru = 'Для вызова окна редактирования процедуры шаблон проводки нужно записать. Продолжить?'");
		
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ЗаписатьПриВходеВрЕжимРедактированияПроцедуры", ЭтаФорма);
		ПоказатьВопрос(Оповещение, ТекстВопроса, Режим);
		
		Возврат;
		
	КонецЕсли;
	
	ОткрытьФормуРедактированияПроцедуры();
	
КонецПроцедуры // ПерейтиВРежимРедактированияПроцедуры()

&НаКлиенте
Процедура ЗаписатьПриВходеВрЕжимРедактированияПроцедуры(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		СохранитьНастройкиПроводки();
		ПерейтиВРежимРедактированияПроцедуры();
				
	Иначе
		
		Возврат;
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияПроцедуры()
	
	СтандартнаяОбработка=Ложь;
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("НазначениеРасчетов",	ПравилоОбработки);
	СтруктураПараметров.Вставить("ПотребительРасчета",	ПоказательОтчета);
	СтруктураПараметров.Вставить("СпособИспользования",	ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляФормулРасчета"));
	
	ОткрытьФорму("ОбщаяФорма.ФормаНастройкиФормулРасчета",СтруктураПараметров);
	
КонецПроцедуры // ОткрытьФормуНастройкиПроцедуры()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ТипЗнч(Параметр)=Тип("Структура") 
		И Параметр.Свойство("ТекстПроцедуры")
		И Параметр.ПотребительРасчета = ПоказательОтчета Тогда
			
		ПроцедураРедактирования=Параметр.ПроцедураРедактирования;
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ШаблонКорректировки) Тогда
		
		ШаблонКорректировки	= Параметры.ШаблонКорректировки;
		ПланСчетов			= Параметры.ПланСчетов;
		ДокументБД			= Параметры.ДокументБД;
		
	ИначеЕсли ЗначениеЗаполнено(Параметры.ПоказательОтчета) Тогда
		
		ПоказательОтчета	= Параметры.ПоказательОтчета;
		ЗаполнитьПоПоказателюОтчета();
		
	КонецЕсли;
		
	ПолучитьПравилоОбработки();
	ОбновитьРесурсыРегистра();
	
	Если ЗначениеЗаполнено(ПоказательОтчета) Тогда
		
		ПолучитьПроцедуруРасчета();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПоПоказателюОтчета()
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ПоказателиОтчетов.Владелец КАК ШаблонКорректировки,
	|	ПоказателиОтчетов.Владелец.ПланСчетов КАК ПланСчетов,
	|	ПоказателиОтчетов.СчетБД КАК СчетДт,
	|	ПоказателиОтчетов.КоррСчетБД КАК СчетКт,
	|	ПоказателиОтчетов.РесурсРегистра КАК РесурсРегистра,
	|	ПоказателиОтчетов.Владелец.ДокументБД КАК ДокументБД
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|ГДЕ
	|	ПоказателиОтчетов.Ссылка = &ПоказательОтчета";
	
	Запрос.УстановитьПараметр("ПоказательОтчета",ПоказательОтчета);
	
	Результат=Запрос.Выполнить().Выбрать();
	Результат.Следующий();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект,Результат);
		
КонецПроцедуры // ЗаполнитьПоПоказателюОтчета() 	
	
&НаСервере
Процедура ОбновитьРесурсыРегистра()
	
	Элементы.РесурсРегистра.СписокВыбора.Очистить();
	
	Для Каждого СтрРесурс Из Параметры.РегистрБухгалтерии.Ресурсы Цикл
		
		Элементы.РесурсРегистра.СписокВыбора.Добавить(СтрРесурс.Имя,СтрРесурс.Синоним,СтрРесурс.Балансовый);
		
	КонецЦикла;
			
КонецПроцедуры // ОбновитьРесурсыРегистра()

&НаСервере
Процедура ПолучитьПроцедуруРасчета()
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ПроцедурыРасчетов.Процедура КАК ПроцедураРасчета,
	|	ПроцедурыРасчетов.ПроизвольныйКод КАК ПроизвольныйКод
	|ИЗ
	|	РегистрСведений.ПроцедурыРасчетов КАК ПроцедурыРасчетов
	|ГДЕ
	|	ПроцедурыРасчетов.НазначениеРасчетов = &НазначениеРасчетов
	|	И ПроцедурыРасчетов.ПотребительРасчета = &ПотребительРасчета";
	
	Запрос.УстановитьПараметр("НазначениеРасчетов",ПравилоОбработки);
	Запрос.УстановитьПараметр("ПотребительРасчета",ПоказательОтчета);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Если Результат.Следующий() Тогда
		
		ПроцедураРасчета=Результат.ПроцедураРасчета;
		ПроцедураРедактирования=ПроцедураРасчета;
		ЗаполнитьПроцедуруРедактирования();
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоПоказателюОтчета()

&НаСервере
Процедура ЗаполнитьПроцедуруРедактирования()
	
	Если ПроизвольныйКод Тогда
		
		ПроцедураРедактирования=ПроцедураРасчета;
		Возврат;
		
	КонецЕсли;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	РеквизитыИсточниковДанныхДляФормул.КодИсточника КАК КодИсточника,
	|	РеквизитыИсточниковДанныхДляФормул.ПоказательТекущегоОтчета КАК ПоказательТекущегоОтчета,
	|	РеквизитыИсточниковДанныхДляФормул.ЕстьНестандартныеОтборы КАК ЕстьНестандартныеОтборы,
	|	РеквизитыИсточниковДанныхДляФормул.КодУпрощеннойФормулы КАК КодУпрощеннойФормулы,
	|	РеквизитыИсточниковДанныхДляФормул.ПотребительРасчета КАК ПотребительРасчета,
	|	РеквизитыИсточниковДанныхДляФормул.КодПоказательОтбор КАК КодПоказательОтбор
	|ИЗ
	|	РегистрСведений.РеквизитыИсточниковДанныхДляФормул КАК РеквизитыИсточниковДанныхДляФормул
	|ГДЕ
	|	РеквизитыИсточниковДанныхДляФормул.НазначениеРасчетов = &НазначениеРасчетов
	|	И РеквизитыИсточниковДанныхДляФормул.СпособИспользования = &СпособИспользования
	|	И РеквизитыИсточниковДанныхДляФормул.ПотребительРасчета = &ПотребительРасчета";
	
	Запрос.УстановитьПараметр("НазначениеРасчетов",ПравилоОбработки);
	Запрос.УстановитьПараметр("СпособИспользования",Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета);
	Запрос.УстановитьПараметр("ПотребительРасчета",ПОказательОтчета);
	
	ТекстПроцедуры=ПроцедураРасчета;
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		ТекстОперанда=Результат.КодУпрощеннойФормулы;					
		ТекстПроцедуры=СтрЗаменить(ТекстПроцедуры,"["+СокрЛП(Результат.КодИсточника)+"]",ТекстОперанда);
		
	КонецЦикла;
	
	ПроцедураРедактирования=ТекстПроцедуры;
		
КонецПроцедуры // ЗаполнитьПроцедурыРедактирования()

&НаСервере
Процедура ПолучитьПравилоОбработки()
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ПравилаОбработки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ПравилаОбработки КАК ПравилаОбработки
	|ГДЕ
	|	ПравилаОбработки.Владелец = &Владелец";
	
	Запрос.УстановитьПараметр("Владелец",ШаблонКорректировки);
	
	Результат=Запрос.Выполнить().Выбрать();	
	
	Если Результат.Следующий() Тогда
		
		ПравилоОбработки=Результат.Ссылка;
		
	КонецЕсли;
	
КонецПроцедуры // ПолучитьПравилоОбработки()

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если СохранитьНастройкиПроводки() Тогда
		
		Оповестить("ЗаписанШаблонПроводки",ДокументБД);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	Если СохранитьНастройкиПроводки() Тогда
		
		Оповестить("ЗаписанШаблонПроводки",ДокументБД);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СохранитьНастройкиПроводки()
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("Ссылка",ПоказательОтчета);
	СтруктураПараметров.Вставить("Владелец",ШаблонКорректировки);
	СтруктураПараметров.Вставить("СчетБД",СчетДт);
	СтруктураПараметров.Вставить("КоррСчетБД",СчетКт);
	СтруктураПараметров.Вставить("РесурсРегистра",РесурсРегистра);
	
	Отказ=Ложь;
	
	Справочники.ПоказателиОтчетов.ИзменитьОбъектПоПараметрам(СтруктураПараметров,Отказ);
	
	Если НЕ Отказ Тогда
		
		Если НЕ ЗначениеЗаполнено(ПоказательОтчета) Тогда
			
			ПоказательОтчета=СтруктураПараметров.Ссылка;
			
		КонецЕсли;
		
		Модифицированность=Ложь;
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции //  СохранитьНастройкиПроводки()
