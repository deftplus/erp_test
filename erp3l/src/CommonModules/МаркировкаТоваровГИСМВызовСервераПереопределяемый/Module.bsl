////////////////////////////////////////////////////////////////////////////////
// ИнтеграцияГИСМВызовСервераПереопределяемый: переопределяемые процедуры, 
// требующие вызова сервера.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обработчик события вызывается на сервере при получении стандартной управляемой формы.
// Если требуется переопределить выбор открываемой формы, необходимо установить в параметре <ВыбраннаяФорма>
// другое имя формы или объект метаданных формы, которую требуется открыть, и в параметре <СтандартнаяОбработка>
// установить значение Ложь.
//
// Параметры:
//  ИмяДокумента - Строка - имя документа, для которого открывается форма,
//  ВидФормы - Строка - имя стандартной формы,
//  Параметры - Структура - параметры формы,
//  ВыбраннаяФорма - Строка, ФормаКлиентскогоПриложения - содержит имя открываемой формы или объект метаданных Форма,
//  ДополнительнаяИнформация - Структура - дополнительная информация открытия формы,
//  СтандартнаяОбработка - Булево - признак выполнения стандартной обработки события.
Процедура ПриПолученииФормыДокумента(ИмяДокумента, ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если ИмяДокумента = "МаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУТ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	ИначеЕсли ИмяДокумента = "ПеремаркировкаТоваровГИСМ" Тогда
		Если ВидФормы = "ФормаОбъекта" Тогда
			ВыбраннаяФорма = "ФормаДокументаУТ";
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получает массив номенклатуры КиЗ по переданному GTIN маркированного товара и списка номенклатуры КиЗ,
// подходящей под выбранные категории КиЗ в документе.
//
// Параметры:
//  СписокНоменклатураКиЗ - Массив - список номенклатуры КиЗ, отобранной по категориям КиЗ в документе.
//  GTIN - Массив - массив GTIN маркируемой номенклатуры.
//  СписокНоменклатурыРезультат - Массив - массив номенклатуры КиЗ.
Процедура ОтобратьНоменклатуруПоНомеруGTIN(СписокНоменклатураКиЗ, GTIN, СписокНоменклатурыРезультат) Экспорт
	
	//++ НЕ ГОСИС
	СписокНоменклатурыРезультат = МаркировкаТоваровГИСМВызовСервераУТ.ОтобратьНоменклатуруПоНомеруGTIN(
		СписокНоменклатураКиЗ, GTIN);
	//-- НЕ ГОСИС
	
КонецПроцедуры

// Получает массив GTIN для переданного товара
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - номенклатура (маркируемый товар).
//  Характеристика - СправочникСсылка.Номенклатура - характеристика номенклатуры (маркируемого товара).
//  СписокGTINРезультат - Массив - массив GTIN.
Процедура МассивGTINМаркированногоТовара(Номенклатура, Характеристика, СписокGTINРезультат) Экспорт
	
	//++ НЕ ГОСИС
	СписокGTINРезультат = ИнтеграцияИСВызовСервераУТ.МассивGTINМаркированногоТовара(
		Номенклатура, Характеристика);
	//-- НЕ ГОСИС
	
КонецПроцедуры

#КонецОбласти