#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//МассивНепроверяемыхРеквизитов = Новый Массив;
	//
	//Если НЕ ДвижениеБюджетированияКлиентСерверУХ.ЭтоБДДС(ВидБюджета) Тогда
	//	МассивНепроверяемыхРеквизитов.Добавить("ДвиженияОперации.СтатьяДвиженияДенежныхСредств");
	//КонецЕсли;
	//
	//Если Не ДвижениеБюджетированияКлиентСерверУХ.ЭтоБДР(ВидБюджета) Тогда
	//	МассивНепроверяемыхРеквизитов.Добавить("ДвиженияОперации.СтатьяДоходовИРасходов");
	//КонецЕсли;
	//
	//Если Не ДвижениеБюджетированияКлиентСерверУХ.ЭтоБюджетДвиженияРесурсов(ВидБюджета) Тогда
	//	МассивНепроверяемыхРеквизитов.Добавить("ДвиженияОперации.СтатьяДвиженияРесурсов");
	//КонецЕсли;
	//
	////
	//ДенежныеСредстваВстраиваниеУХПереопределяемый.ВидыОперацийБюджетирование_ОбработкаПроверкиЗаполнения(
	//	ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	//
	//ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецЕсли
