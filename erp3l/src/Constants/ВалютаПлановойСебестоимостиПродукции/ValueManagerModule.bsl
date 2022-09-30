#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Вызывает исключение с текстом ошибки, в случаях, когда константа необходима, но не включена.
//
Процедура СообщитьКонстантаНеЗаполненаИВызватьИсключение() Экспорт
	
	ТекстИсключения = НСтр("ru = 'Не задана валюта плановой себестоимости продукции. Валюта устанавливается в разделе ""НСИ и администрирование"" - ""Производство"".';
							|en = 'Product target cost currency is not specified. The currency is set in section ""Master data and settings"" - ""Manufacturing"".'");
	ВызватьИсключение ТекстИсключения;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли