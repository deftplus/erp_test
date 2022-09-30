// Функция возвращает числовое значение ставки НДС по значению СтавкаНДС перечисления
// СтавкиНДС.
Функция ПолучитьСтавкуНДС(СтавкаНДС) Экспорт

	Возврат ВстраиваниеУХВызовСервера.ПолучитьСтавкуНДС(СтавкаНДС);

КонецФункции // ПолучитьСтавкуНДС()

// Создаёт банковский счёт-копию для счёта СчетИсточникВход и устанавливает
// новому счёту владельцем элемент НовыйВладелецВход. Возвращает ссылку на созданный
// счёт.
Функция СоздатьКопиюСчетаДляВладельца(СчетИсточникВход, НовыйВладелецВход) Экспорт
	РезультатФункции = УправлениеДенежнымиСредствамиУХ.СоздатьКопиюСчетаДляВладельца(СчетИсточникВход, НовыйВладелецВход);
	Возврат РезультатФункции;
КонецФункции

