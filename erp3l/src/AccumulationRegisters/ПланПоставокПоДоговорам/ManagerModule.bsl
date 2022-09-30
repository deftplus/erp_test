#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Добавляет в набор записей регистра движения добавляющие
// в план новые поставки.
// Все реквизиты запроса должны соотвествтовать реквизитам регистра.
// Количество должно быть в базовой единице измерения.
// Сумма в валюте учета закупок.
//
Процедура ДобавитьВПланПоставок(НаборЗаписей,
								ВыборкаЗапроса) Экспорт
	ДобавитьЗаписи(НаборЗаписей, 
					ВыборкаЗапроса, 
					ВидДвиженияНакопления.Приход, 
					1);
КонецПроцедуры

// Добавляет в набор записей регистра движения сторно
// регистрации в плане поставок.
// Все реквизиты запроса должны соотвествтовать реквизитам регистра.
// Количество должно быть в базовой единице измерения.
// Сумма в валюте учета закупок.
//
Процедура СторнироватьПланПоставокПоДокументу(НаборЗаписей,
									ВыборкаЗапроса) Экспорт
	ДобавитьЗаписи(НаборЗаписей, 
					ВыборкаЗапроса, 
					ВидДвиженияНакопления.Приход, 
					-1);	
КонецПроцедуры

// Добавляет в набор записей регистра движения списывающие
//  (закрывающие) план поставок.
//  Все реквизиты запроса должны соотвествтовать реквизитам регистра.
//  Количество должно быть в базовой единице измерения.
//  Сумма в валюте учета закупок.
//
// Параметры:
//  НаборЗаписей - РегистрНакопленияНаборЗаписей.ПланПоставокПоДоговорам -
//				   набор записей для заполнения.
//  ВыборкаЗапроса - ВыборкаИзРезультатаЗапроса - выборка - источник данных.
//  СопоставлениеРеквизитов - Неопределено|Соответствие -
//							  описание замены имен в источнике данных,
//							  на имена в наборе записей. Ключ - имя в выборке запроса,
//							  т.е. - это имя реквизита источника.
//							  Значение - имя в наборе записей, т.е. - это имя
//							  реквизита приемника.
//
Процедура СписатьИзПланаПоставок(НаборЗаписей,
								 ВыборкаЗапроса,
								 СопоставлениеИменРеквизитов=Неопределено) Экспорт
	ДобавитьЗаписи(НаборЗаписей, 
					ВыборкаЗапроса, 
					ВидДвиженияНакопления.Расход, 
					1,
					СопоставлениеИменРеквизитов);
КонецПроцедуры

// Добавляет в набор записей регистра движения сторно
// списания плана поставок.
// Все реквизиты запроса должны соотвествтовать реквизитам регистра.
// Количество должно быть в базовой единице измерения.
// Сумма в валюте учета закупок.
//
Процедура СторнироватьСписаниеПланаПоставок(НаборЗаписей,
											ВыборкаЗапроса) Экспорт
	ДобавитьЗаписи(НаборЗаписей,
					ВыборкаЗапроса, 
					ВидДвиженияНакопления.Расход, 
					-1);	
КонецПроцедуры

// Записывает данные из выборки запроса в набор записей
//  регистра. Выборка запроса должна содеражать поля
//  "Количество" и "Сумма". В зависимости от аргументов
//  процедуры они будут записаны, либо в потребность,
//  либо в обеспечение.
//
// Параметры:
//  НаборЗаписей - РегистрНакопленияНаборЗаписей.ПотребностиВНоменклатуре.
//  ВыборкаЗапроса - ВыборкаИзРезультатаЗапроса - должна содержать
//		одноименные поля для заполнения измерений, а также поля
//		"Количество" и "Сумма". Количество должно быть в базовой
//		единице измерения. Сумма в валюте учета закупок.
//	ВидДвижения - ВидДвиженияНакопления - вид движения.
//	Знак - Число: -1 | +1 - знак с которым данные будут записаны в регистр.
//
Процедура ДобавитьЗаписи(НаборЗаписей,
							ВыборкаЗапроса,
							ВидДвижения,
							Знак,
							СопоставлениеИменРеквизитов=Неопределено)
	Пока ВыборкаЗапроса.Следующий() Цикл
		Движение = НаборЗаписей.Добавить();
		Движение.ВидДвижения = ВидДвижения;
		ЗаполнитьЗначенияСвойствСЗаменойИмен(
			Движение, 
			ВыборкаЗапроса, 
			СопоставлениеИменРеквизитов);
		Если Знак < 0 Тогда
			Движение.Количество = Движение.Количество * -1;
			Движение.Сумма = Движение.Сумма * -1;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Процедура ЗаполнитьЗначенияСвойствСЗаменойИмен(
									Приемник, 
									Источник, 
									СопоставлениеИменРеквизитов=Неопределено)
	ЗаполнитьЗначенияСвойств(Приемник, Источник);
	Если СопоставлениеИменРеквизитов <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Приемник, Источник);
		Для Каждого ИмяИсточникПриемник Из СопоставлениеИменРеквизитов Цикл
			ИмяИсточник = ИмяИсточникПриемник.Ключ;
			ИмяПриемник = ИмяИсточникПриемник.Значение;
			Приемник[ИмяПриемник] = Источник[ИмяИсточник];
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры


#КонецЕсли