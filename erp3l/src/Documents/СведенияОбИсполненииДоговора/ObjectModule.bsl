#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Лот = ЦентрализованныеЗакупкиУХ.ПолучитьЛотДоговора(ДоговорКонтрагента);
		Если НЕ ЗначениеЗаполнено(Лот) Тогда
			ВызватьИсключение НСтр("ru = 'Исполнение предусмотрено для договоров заключенных на основании Лота.'");
		КонецЕсли;
		ДоговорКонтрагента = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ответственный) Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Ответственный = Пользователи.ТекущийПользователь();
	УИД_ЕИС = "";
	РегистрационныйНомерЕИС = 0;
КонецПроцедуры


#КонецЕсли

