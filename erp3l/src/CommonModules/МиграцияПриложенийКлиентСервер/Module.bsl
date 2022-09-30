#Область СлужебныйПрограммныйИнтерфейс

// Возвращаемое значение: 
//  Строка - Право запуск
Функция ПравоЗапуск() Экспорт
	
	Возврат НСтр("ru = 'Запуск';
				|en = 'Start'");
	
КонецФункции

// Возвращаемое значение: 
//  Строка - Право запуск и администрирование
Функция ПравоЗапускИАдминистрирование() Экспорт
	
	Возврат НСтр("ru = 'Запуск и администрирование';
				|en = 'Launch and administration'");
	
КонецФункции

// Возвращаемое значение: 
//  Строка - роль владелец.
Функция РольВладелец() Экспорт
	
	Возврат НСтр("ru = 'Владелец';
				|en = 'Owner'");
	
КонецФункции

// Возвращаемое значение: 
//  Строка - роль администратор.
Функция РольАдминистратор() Экспорт
	
	Возврат НСтр("ru = 'Администратор';
				|en = 'Administrator'");
	
КонецФункции

// Возвращаемое значение: 
//  Строка - роль пользователь.
Функция РольПользователь() Экспорт
	
	Возврат НСтр("ru = 'Пользователь';
				|en = 'User'");
	
КонецФункции

// Параметры: 
//  Идентификатор - Строка
// 
// Возвращаемое значение: 
//  Строка
Функция ПредставлениеРоли(Идентификатор) Экспорт
	
	Если Идентификатор = "owner" Тогда
		Возврат РольВладелец();
	ИначеЕсли Идентификатор = "administrator" Тогда
		Возврат РольАдминистратор();
	ИначеЕсли Идентификатор = "user" Тогда  
		Возврат РольПользователь();
	ИначеЕсли Идентификатор = "operator" Тогда
		Возврат РольОператор();
	КонецЕсли;
	
КонецФункции

// Параметры: 
//  Представление - Строка
// 
// Возвращаемое значение: 
//  Строка - Идентификатор API роли
Функция ИдентификаторAPIРоли(Представление) Экспорт
	
	Если Представление = РольВладелец() Тогда
		Возврат "owner";
	ИначеЕсли Представление = РольАдминистратор() Тогда
		Возврат "administrator";
	ИначеЕсли Представление = РольПользователь() Тогда
		Возврат "user";
	ИначеЕсли Представление = РольОператор() Тогда
		Возврат "operator";
	КонецЕсли;
	
КонецФункции

// Параметры: 
//  Представление - Строка
// 
// Возвращаемое значение: 
//  Строка
Функция ИдентификаторAPIПрава(Представление) Экспорт
	
	Если Представление = ПравоЗапуск() Тогда
		Возврат "user";
	ИначеЕсли Представление = ПравоЗапускИАдминистрирование() Тогда
		Возврат "administrator";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция РольОператор()
	
	Возврат НСтр("ru = 'Оператор';
				|en = 'Operator'");
	
КонецФункции

#КонецОбласти
