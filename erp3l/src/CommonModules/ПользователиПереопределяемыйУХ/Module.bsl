// Внешним пользователям можно назначать ролью ДобавлениеЗаявкиНаРегистрациюПоставщика 
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ДобавлениеЗаявкиНаРегистрациюПоставщика.Имя);
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.РабочийСтолПоставщика.Имя);
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(
		Метаданные.Роли.ДобавлениеИзменениеПапокИФайловВнешнимПоставщиком.Имя);

КонецПроцедуры