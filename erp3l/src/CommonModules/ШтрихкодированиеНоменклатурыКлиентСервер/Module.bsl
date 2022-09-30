
#Область ПрограммныйИнтерфейс

//Возвращает структуру параметров обработки штрихкодов.
//
// Возвращаемое значение:
//  Структура:
// * ТекущаяСтрока - Неопределено
// * МассивСтрокСАкцизнымиМарками - Массив
// * МассивСтрокССериями - Массив
// * ЗагрузкаИзТСД - Булево
// * ЗаполнятьНазначения - Булево
// * ТекущийУпаковочныйЛист - Неопределено
// * УвеличиватьКоличествоВСтрокахССериями - Булево
// * МаркируемаяПродукцияВТЧ - Булево
// * ШтрихкодыВТЧ - Булево -
// * ОтработатьИзменениеУпаковочныхЛистов - Булево
// * УчитыватьУпаковочныеЛисты - Булево
// * РассчитыватьНаборы - Булево
// * ПараметрыПроверкиАссортимента - Неопределено
// * ОтложенныеТовары - Массив
// * НеизвестныеШтрихкоды - Массив
// * ТолькоНеПодакцизныйТовар - Булево
// * ТолькоТара - Булево
// * ТолькоУслуги - Булево
// * ТолькоТоварыИРабота - Булево
// * ТолькоТоварыИУслуги - Булево
// * ТолькоТовары - Булево
// * БлокироватьДанныеФормы - Булево
// * ИзменятьКоличество - Булево
// * ИмяТЧ - Строка
// * ИмяКолонкиУпаковка - Строка
// * НеИспользоватьУпаковки - Булево
// * ИмяКолонкиКоличество - Строка
// * ДействияСНеизвестнымиШтрихкодами - Строка
// * ПараметрыУказанияСерий - Неопределено
// * СтруктураДействийСоСтрокамиИзУпаковочныхЛистов - Неопределено
// * СтруктураДействийСИзмененнымиСтроками - Неопределено
// * СтруктураДействийСДобавленнымиСтроками - Неопределено
// * Штрихкоды - Неопределено
// * НеИскатьВОтмененныхСтроках - Булево - Истина - при поиске в ТЧ отмененная строка не будет учитываться
//
Функция ПараметрыОбработкиШтрихкодов() Экспорт
	
	ПараметрыОбработки = Новый Структура;
	ПараметрыОбработки.Вставить("Штрихкоды",                                      Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСДобавленнымиСтроками",         Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСИзмененнымиСтроками",          Неопределено);
	ПараметрыОбработки.Вставить("СтруктураДействийСоСтрокамиИзУпаковочныхЛистов", Неопределено);
	ПараметрыОбработки.Вставить("ПараметрыУказанияСерий",                         Неопределено);
	ПараметрыОбработки.Вставить("ДействияСНеизвестнымиШтрихкодами",               "ЗарегистрироватьПеренестиВДокумент");
	ПараметрыОбработки.Вставить("ИмяКолонкиКоличество",                           "КоличествоУпаковок");
	ПараметрыОбработки.Вставить("НеИспользоватьУпаковки",                         Ложь);
	ПараметрыОбработки.Вставить("ИмяКолонкиУпаковка",                             "Упаковка");
	ПараметрыОбработки.Вставить("ИмяТЧ",                                          "Товары");
	ПараметрыОбработки.Вставить("ИзменятьКоличество",                             Истина);
	ПараметрыОбработки.Вставить("БлокироватьДанныеФормы",                         Истина);
	ПараметрыОбработки.Вставить("ТолькоТовары",                                   Ложь);
	ПараметрыОбработки.Вставить("ТолькоТоварыИРабота",                            Ложь);
	ПараметрыОбработки.Вставить("ТолькоТоварыИУслуги",                            Ложь);
	ПараметрыОбработки.Вставить("ТолькоУслуги",                                   Ложь);
	ПараметрыОбработки.Вставить("ТолькоРаботы",                                   Ложь);
	ПараметрыОбработки.Вставить("ТолькоТара",                                     Ложь);
	ПараметрыОбработки.Вставить("ТолькоНеПодакцизныйТовар",                       Ложь);
	ПараметрыОбработки.Вставить("ДобавлятьТолькоТоварСверхЗаказа",                Ложь);
	ПараметрыОбработки.Вставить("НеизвестныеШтрихкоды",                           Новый Массив);
	ПараметрыОбработки.Вставить("ОтложенныеТовары",                               Новый Массив);
	ПараметрыОбработки.Вставить("ПараметрыПроверкиАссортимента",                  Неопределено);
	ПараметрыОбработки.Вставить("РассчитыватьНаборы",                             Ложь);
	ПараметрыОбработки.Вставить("УчитыватьУпаковочныеЛисты",                      Ложь);
	ПараметрыОбработки.Вставить("ОтработатьИзменениеУпаковочныхЛистов",           Ложь);
	ПараметрыОбработки.Вставить("ШтрихкодыВТЧ",                                   Ложь);
	ПараметрыОбработки.Вставить("МаркируемаяПродукцияВТЧ",                        Ложь);
	ПараметрыОбработки.Вставить("УвеличиватьКоличествоВСтрокахССериями",          Истина);
	ПараметрыОбработки.Вставить("ТекущийУпаковочныйЛист",                         Неопределено);
	ПараметрыОбработки.Вставить("ЗаполнятьНазначения",                            Ложь);
	ПараметрыОбработки.Вставить("ЗагрузкаИзТСД",                                  Ложь);
	ПараметрыОбработки.Вставить("НеИскатьВОтмененныхСтроках",                     Истина);
	
	//Возвращаемые параметры
	ПараметрыОбработки.Вставить("МассивСтрокССериями",          Новый Массив);
	ПараметрыОбработки.Вставить("МассивСтрокСАкцизнымиМарками", Новый Массив);
	ПараметрыОбработки.Вставить("ТекущаяСтрока",       Неопределено);
	
	Возврат ПараметрыОбработки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
