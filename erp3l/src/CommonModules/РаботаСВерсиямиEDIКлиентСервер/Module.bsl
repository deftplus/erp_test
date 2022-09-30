
#Область СлужебныйПрограммныйИнтерфейс

#Область ЛокализацияИдентификаторов

// Режим сравнения.
// 
// Возвращаемое значение:
// 	Строка - идентификатор режима сравнения
Функция РежимПросмотраСравнение() Экспорт 
	Возврат "Сравнение";
КонецФункции

// Режим просмотра.
// 
// Возвращаемое значение:
// 	Строка - идентификатор режима просмотра
Функция РежимПросмотраПросмотр() Экспорт 
	Возврат "Просмотр";
КонецФункции

// Состояние "не редактируется"
// 
// Возвращаемое значение:
// 	Строка - идентификатор состояния документа "не редактируется"
Функция СостояниеДокументаНеРедактируется() Экспорт
	Возврат "НеДоступен";
КонецФункции

// Состояние "редактируется"
// 
// Возвращаемое значение:
// 	Строка - идентификатор состояния документа "редактируется"
Функция СостояниеДокументаРедактируется() Экспорт
	Возврат "Редактируется";
КонецФункции

// Состояние "рассмотрение присланной версии"
// 
// Возвращаемое значение:
// 	Строка - идентификатор состояния документа "рассмотрение присланной версии"
Функция СостояниеДокументаРассмотрениеПрисланнойВерсии() Экспорт
	Возврат "РассмотрениеПрисланнойВерсии";
КонецФункции

#КонецОбласти

#Область Конструкторы

// Конструктор параметров определения доступных команд формы
// 
// Возвращаемое значение:
// 	Структура - Описание:
// * Версия                           - Строка - идентификатор версии сервиса
// * ВерсияДляСравнения               - Строка - идентификатор версии сервиса для сравнения
// * ПрисланнаяНаСогласованиеВерсия   - Строка - идентификатор, присланной на согласование, версии сервиса
// * АктуальнаяВерсия                 - Строка - идентификатор актуальной версии сервиса
// * СтроковоеПредставлениеВерсииДляСравнения - Строка - пользовательское представление версии документа
// * СтроковоеПредставлениеВерсии             - Строка - пользовательское представление сравниваемой версии документа
// * СостояниеРедактированияДокумента - Строка                         - идентификатор состояния редактирования документа:
//     см. РаботаСВерсиямиEDIКлиентСервер.СостояниеДокументаНеРедактируется()
//     см. РаботаСВерсиямиEDIКлиентСервер.СостояниеДокументаРедактируется()
//     см. РаботаСВерсиямиEDIКлиентСервер.СостояниеДокументаРассмотрениеПрисланнойВерсии()
// * РежимПросмотра                   - Строка - идентификатор режима просмотра, один из:
//                                               - см. РаботаСВерсиямиEDIКлиентСервер.РежимПросмотраПросмотр
//                                               - см. РаботаСВерсиямиEDIКлиентСервер.РежимПросмотраСравнение
//
Функция НовыйПараметрыОпределенияДоступныхКоманд() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("РежимПросмотра",                           "");
	Параметры.Вставить("СостояниеРедактированияДокумента",         "");
	Параметры.Вставить("СтроковоеПредставлениеВерсии",             "");
	Параметры.Вставить("СтроковоеПредставлениеВерсииДляСравнения", "");
	Параметры.Вставить("АктуальнаяВерсия",                         "");
	Параметры.Вставить("ПрисланнаяВерсия",                         "");
	Параметры.Вставить("Версия",                                   "");
	Параметры.Вставить("ВерсияДляСравнения",                       "");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти

#КонецОбласти
