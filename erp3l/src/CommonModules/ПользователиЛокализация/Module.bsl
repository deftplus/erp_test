#Область ПрограммныйИнтерфейс

// Позволяет указать роли, назначение которых будет контролироваться особым образом.
// 
// см. ПользователиПереопределяемый.ПриОпределенииНазначенияРолей() 
//
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	//++ Локализация
	#Область РолиСовместногоИспользованияДляВнешнихПользователейИПользователей
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.БазовыеПраваЭД.Имя);
	//++ НЕ УТ
	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить(
		Метаданные.Роли.ДобавлениеИзменениеНеразделяемыхДанныхОбменаСБанками.Имя);
	//-- НЕ УТ
	#КонецОбласти
	
	#Область БиблиотечныеРоли	

	//++ НЕ УТ
	ЗарплатаКадры.ПриОпределенииНазначенияРолей(НазначениеРолей);
	//-- НЕ УТ
	
	// ИнтернетПоддержкаПользователей
	ИнтеграцияПодсистемБИП.ПриОпределенииНазначенияРолей(НазначениеРолей);
	// Конец ИнтернетПоддержкаПользователей
	
	// БРО
	//++ НЕ УТ
	РегламентированнаяОтчетность.ПриОпределенииНазначенияРолей(НазначениеРолей);	
	//-- НЕ УТ

	#КонецОбласти
	//-- Локализация
	
		
КонецПроцедуры

#КонецОбласти
