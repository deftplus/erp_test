#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьКорректировкиШаблона(Объект) Экспорт

	Если Не ЗаполнениеКорректировокДоступно(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	//очистить
	//сторно ДКЗ
	//сторно СС
	//сторно ам

КонецПроцедуры

Функция ЗаполнениеКорректировокДоступно(Объект)

	Возврат
	Не Объект.СторонаУрегулирования.Пустая()
	И Не Объект.РазделВГО.Пустая()
	И Не Объект.ПланСчетов.Пустая();

КонецФункции

#КонецЕсли
