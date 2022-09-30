#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ДоступностьРаспоряженийДС", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Доверенности на получение наличных денежных средств';
													|en = 'Authorization letters for cash receipt'"));
	ИмяФормыРабочееМестоДоверенности = "Документ.ДоверенностьВыданная.Форма.ФормаСпискаДокументов";
	ОткрытьФорму(ИмяФормыРабочееМестоДоверенности, ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти