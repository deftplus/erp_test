#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция ЗначениеПоУмолчанию(ВидАктива) Экспорт

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ГруппыФинансовогоУчетаВнеоборотныхАктивов.Ссылка
	|ИЗ
	|	Справочник.ГруппыФинансовогоУчетаВнеоборотныхАктивов КАК ГруппыФинансовогоУчетаВнеоборотныхАктивов
	|ГДЕ
	|	ГруппыФинансовогоУчетаВнеоборотныхАктивов.ВидАктива = &ВидАктива
	|	И НЕ ГруппыФинансовогоУчетаВнеоборотныхАктивов.ПометкаУдаления";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВидАктива", ВидАктива);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Справочники.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ПустаяСсылка();
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ГруппыФинансовогоУчетаВнеоборотныхАктивов.ПустаяСсылка();
	КонецЕсли; 

КонецФункции

#Область ДляВызоваИзДругихПодсистем

// Заполняет реквизиты параметров настройки счетов учета внеоборотных активов, которые влияют на настройку,
// 	соответствующими им именам реквизитов аналитики учета.
//
// Параметры:
// 	СоответствиеИмен - Соответствие - ключом выступает имя реквизита, используемое в настройке счетов учета,
// 		значением является соответствующее имя реквизита аналитики учета.
// 
Процедура ЗаполнитьСоответствиеРеквизитовНастройкиСчетовУчета(СоответствиеИмен) Экспорт
	
	СоответствиеИмен.ВидАктива = "ВидАктива";
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
