#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция НайтиСоздатьСеансОбменаДанными(СтруктураПоиска,СоздаватьНовые=Истина) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|Ссылка
	|ИЗ Справочник.СеансыОбменаДанными";
	
	Если СтруктураПоиска.Количество() Тогда
		
		Запрос.Текст = Запрос.Текст + Символы.ПС + "ГДЕ" + Символы.ПС;
		
		ТекстОтбора = Новый Массив;
		Разделитель = Символы.ПС + "И ";
		Для Каждого КлючИЗначение Из СтруктураПоиска Цикл
			ТекстОтбора.Добавить(СтрШаблон("%1 = &%1", КлючИЗначение.Ключ));
			Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		Запрос.Текст = Запрос.Текст + СтрСоединить(ТекстОтбора, Разделитель);
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Возврат Выборка.Ссылка;
		
	Иначе
		
		Если СоздаватьНовые Тогда
			
			НовыйЭлемент = Справочники.СеансыОбменаДанными.СоздатьЭлемент();
			НовыйЭлемент.Заполнить(СтруктураПоиска);
			НовыйЭлемент.Записать();
			
			Возврат НовыйЭлемент.Ссылка;
			
		Иначе
			
			Возврат Неопределено;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

	
#КонецОбласти	
	
	
#КонецЕсли