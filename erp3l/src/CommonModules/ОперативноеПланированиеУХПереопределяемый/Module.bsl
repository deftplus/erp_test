#Область СлужебныйПрограммныйИнтерфейс

// Процедура корректирует доступные виды операций документ ОперативныйПлан для текущего решения
Процедура РазрешенныеОперацииОперПланаРешения(ВидБюджета, ВидыОпераций) Экспорт
	
	// Для ERP.УХ планирование и резервирование по бюджету закупок невозможно.
	Если ВидБюджета = Перечисления.ПредназначенияЭлементовСтруктурыОтчета.БюджетДвиженияРесурсов Тогда
		ВидыОпераций.Удалить(Перечисления.ВидыОперацийОперативныйПлан.Планирование);
		ВидыОпераций.Удалить(Перечисления.ВидыОперацийОперативныйПлан.Резервирование);
	КонецЕсли;
	
КонецПроцедуры

#Область ДополнительныеДействия
	
Процедура ЗарегистрироватьДополнительныеДействия(ОписаниеКТ) Экспорт
	
КонецПроцедуры

Функция СформироватьПараметрыДополнительныхДействий(ОписаниеКТ, Форма, ИмяДополнительногоДействия) Экспорт
	
	Возврат неопределено;
	
КонецФункции

Функция ВыполнитьОбработкуРезультатаДействия(ОписаниеКТ, Форма, ИмяДополнительногоДействия, Параметры, РезультатДействия, ДанныеКЗагрузке) Экспорт
	
КонецФункции

#КонецОбласти 

#КонецОбласти

