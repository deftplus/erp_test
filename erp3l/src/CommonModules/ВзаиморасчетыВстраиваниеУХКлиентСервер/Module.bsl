

#Область ПрограммныйИнтерфейс

Функция ВидыОперацийПоступлениеТоваровУслугПокупкаКомиссия() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПриемНаКомиссию");
КонецФункции

Функция ВидыОперацийПоступлениеТоваровУслугОборудование() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
КонецФункции

Функция ВидыОперацийПоступлениеТоваровУслугТовары() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
КонецФункции

Функция ВидыОперацийПоступлениеТоваровУслугУслуги() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика");
КонецФункции

Функция ВидыОперацийПоступлениеТоваровУслугПустаяСсылка() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
КонецФункции

Функция ВидыОперацийРеализацияТоваровПродажаКомиссия() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию");
КонецФункции

Функция ВидыОперацийРеализацияТоваровОборудование() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
КонецФункции

Функция ВидыОперацийРеализацияТоваровТовары() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
КонецФункции

Функция ВидыОперацийРеализацияТоваровУслуги() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
КонецФункции

Функция ВидыОперацийРеализацияТоваровОтгрузкаБезПереходаПраваСобственности() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ОтгрузкаБезПереходаПраваСобственности");
КонецФункции

Функция ВидыОперацийРеализацияТоваровПустаяСсылка() Экспорт
	Возврат ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПустаяСсылка");
КонецФункции

Функция ИменаРеквизитовЗаказаПоставщику() Экспорт
	
	Результат = Новый Структура;
	
	Результат.Вставить("ВалютаДокумента", "Валюта");
	Результат.Вставить("ДоговорКонтрагента", "Договор");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
