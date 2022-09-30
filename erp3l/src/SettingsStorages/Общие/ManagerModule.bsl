
Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	МенеджерЗаписи = РегистрыСведений.ХранилищеНастроек.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлючОбъекта = КлючОбъекта;
	МенеджерЗаписи.КлючНастроек = КлючНастроек;
	МенеджерЗаписи.Настройки = Новый ХранилищеЗначения(Настройки);
	МенеджерЗаписи.Записать();
	
КонецПроцедуры

Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек, Пользователь)
	
	Структура = РегистрыСведений.ХранилищеНастроек.Получить(Новый Структура("КлючОбъекта,КлючНастроек", КлючОбъекта, КлючНастроек));
	
	Если НЕ Структура = Неопределено Тогда
		
		Настройки = Структура.Настройки.Получить();
		
		Если ТипЗнч(Настройки) = Тип("Структура") тогда
			СтруктураНастроек = ОписаниеНастроек.ДополнительныеСвойства;
			
			Для Каждого ЭлементНастройки Из Настройки Цикл
				СтруктураНастроек.Вставить(ЭлементНастройки.Ключ, ЭлементНастройки.Значение);
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура Удалить(КлючОбъекта, КлючНастроек) Экспорт
	
	МенеджерЗаписи = РегистрыСведений.ХранилищеНастроек.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.КлючОбъекта = КлючОбъекта;
	МенеджерЗаписи.КлючНастроек = КлючНастроек;
	МенеджерЗаписи.Удалить();
	
КонецПроцедуры
