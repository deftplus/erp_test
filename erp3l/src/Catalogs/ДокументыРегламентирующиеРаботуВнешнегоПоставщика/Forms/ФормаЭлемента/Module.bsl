
#Область ОбработкаОсновныхСобытийФормы


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПустаяСтрока(Объект.ИДФайла) Тогда
		ДобавитьФайл();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти


#Область ОбработкаСобытийЭлементовФормы

&НаКлиенте
Процедура НазначитьФайл(Команда)
	ДобавитьФайл();
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОткрытьФайл(Команда)
	ОткрытьФайл();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДобавитьФайл();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФайл();
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыНаКлиенте


&НаКлиенте
Процедура ОткрытьФайл()
	Если НЕ ПустаяСтрока(Объект.ИДФайла) Тогда
		СвязанныеФайлыКлиентУХ.ПодготовитьИОткрытьФайлДляПросмотра(Объект.ИДФайла, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(ЗаписатьОбъект=Ложь)
	// выбрать и записать новый файл
	ДопПараметры = Новый Структура("ЗаписатьОбъект", ЗаписатьОбъект);
	ОписаниеОбработчикаДобавленияФайла = Новый ОписаниеОповещения(
						"ОбработчикДобавленияФайла", ЭтаФорма, ДопПараметры);
	СвязанныеФайлыКлиентУХ.ДобавитьФайлВИБ(Объект.Ссылка, Объект.ИДФайла,
		ОписаниеОбработчикаДобавленияФайла,	ЭтаФорма.УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикДобавленияФайла(СсылкаНаФайл, ДопПараметры) Экспорт
	Если СсылкаНаФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = СвязанныеФайлыВызовСервера.ПолучитьФайлПоСсылке(СсылкаНаФайл);
	Объект.ИмяФайла = ДанныеФайла.Наименование + ?(ПустаяСтрока(ДанныеФайла.Расширение), "", "." + ДанныеФайла.Расширение);
	Объект.ИДФайла = ДанныеФайла.Идентификатор;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		Объект.Наименование = ДанныеФайла.Наименование;
	КонецЕсли;
	
	Если ДопПараметры.ЗаписатьОбъект Тогда
		Записать();
	КонецЕсли;
КонецПроцедуры


#КонецОбласти


#Область СлужебныеПроцедурыНаСервере


#КонецОбласти
