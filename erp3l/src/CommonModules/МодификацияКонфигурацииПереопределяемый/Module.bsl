////////////////////////////////////////////////////////////////////////////////
// Переопределяемые процедуры, вызываемые из обработчиков форм, таких как:
// "ПриСозданииНаСервере", "ПриЧтенииНаСервере", "ПередЗаписьюНаСервере", 
// "ПослеЗаписи", а также при изменении некоторых реквизитов табличной части,
// таких как "Номенклатура", "Характеристика".
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ЗаполнениеОбработчиковФормы

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
// 	Отказ - Булево -
// 	СтандартнаяОбработка - Булево - 
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	#Область УХ_Внедрение
	ВстраиваниеУХ.ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	#КонецОбласти 
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
// 	ТекущийОбъект - ДокументОбъект, СправочникОбъект - 
//
Процедура ПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	#Область УХ_Внедрение
	ВстраиваниеУХ.ПриЧтенииНаСервере(Форма, ТекущийОбъект);
	#КонецОбласти 
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
// 	Отказ - Булево - 
// 	ТекущийОбъект - ДокументОбъект, СправочникОбъект - 
// 	ПараметрыЗаписи - Структура - 
//
Процедура ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	#Область УХ_Внедрение
	ВстраиваниеУХ.ПередЗаписьюНаСервере(Форма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	#КонецОбласти 
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события формы.
//
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - форма, из обработчика события которой происходит вызов процедуры.
// 	ТекущийОбъект - ДокументОбъект, СправочникОбъект - 
// 	ПараметрыЗаписи - Структура - 
//
Процедура ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи)Экспорт
	#Область УХ_Внедрение
	ВстраиваниеУХ.ПослеЗаписиНаСервере(Форма, ТекущийОбъект, ПараметрыЗаписи);
	#КонецОбласти
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеНоменклатуры

// Переопределяемая процедура, вызываемая из обработчика реквизита "Номенклатура" табличной части.
//
// Параметры:
// 	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка табличной части.
// 	ПараметрыДействия - Структура - допустимые действия для табличной части.
//	КэшированныеЗначения - Структура - Кэшированные значения табличной части.
Процедура НоменклатураПриИзмененииПереопределяемый(ТекущаяСтрока, ПараметрыДействия, КэшированныеЗначения)Экспорт


КонецПроцедуры

#КонецОбласти 

#Область ЗаполнениеХарактеристики

// Переопределяемая процедура, вызываемая из обработчика реквизита "Характеристика" табличной части.
//
// Параметры:
// 	ТекущаяСтрока - ДанныеФормыЭлементКоллекции - текущая строка табличной части.
// 	ПараметрыДействия - Структура - допустимые действия для табличной части.
//	КэшированныеЗначения - Структура - Кэшированные значения табличной части.
Процедура ХарактеристикаПриИзмененииПереопределяемый(ТекущаяСтрока, ПараметрыДействия, КэшированныеЗначения)Экспорт


КонецПроцедуры
	
#КонецОбласти 

#Область РассылкиИОповещенияКлиентам

// Переопределяемая процедура, возвращающая признак необходимости настройки для типа события регламентного задания.
//
// Параметры:
//  ТипСобытия  - ПеречислениеСсылка.ТипыСобытийОповещений - тип события оповещения, для которого указывается признак.
//
// Возвращаемое значение:
//   Булево   - Истина, если настройка регламентного задания необходима, Ложь в обратном случае.
//
Функция ДляТипаСобытияТребуетсяНастройкаРегламентногоЗадания(ТипСобытия) Экспорт

	Возврат Ложь;

КонецФункции

// Переопределяемая процедура, в которой можно настроить параметры обработки очереди оповещений по типу события.
//
// Параметры:
//  ТипСобытия         - ПеречислениеСсылка.ТипыСобытийОповещений - тип события оповещения для которого указываются настройки.
//  СтруктураНастроек  - Структура - Настройки, подробное описание см. в модуле менеджера перечисления ТипыСобытийОповещений.
//
Процедура НастройкиТипаСобытияДляОбработкиОчередиОповещений(ТипСобытия, СтруктураНастроек) Экспорт

	

КонецПроцедуры

// Переопределяемая процедура, в которой можно настроить анализ данных для оповещений клиентам и запись в очередь оповещений.
// Примеры реализации см. в общем модуле РассылкиИОповещенияКлиентам.
//
// Параметры:
//  ВидОповещения  - СправочникСсылка.ВидыОповещенийКлиентам - вид оповещения, для которого выполняется анализ данных.
//
Процедура АнализДанныхДляВидаОповещения(ВидОповещения) Экспорт

	

КонецПроцедуры 

// Переопределяемая процедура, в которой можно получить состояние объекта до записи.
//
// Параметры:
//  Источник  - Произвольный - объект или набор записей регистра, который вызвал событие "перед записью".
//  Отказ  - Булево - признак отказа от записи объекта.
//  РежимЗаписи  - РежимЗаписиДокумента - действительно, только в случае записи документа, в остальных случаях Неопределено.
//  РежимПроведения  - РежимПроведенияДокумента - действительно, только в случае проведения документа, в остальных случаях Неопределено.
//
Процедура ИсточникОповещенияПередЗаписью(Источник, Отказ, РежимЗаписи , РежимПроведения) Экспорт
	
	
	
КонецПроцедуры

// Переопределяемая процедура, в которой можно получить новое состояние объекта и при необходимости выполнить запись
// в очередь оповещений.
//
// Параметры:
//  Источник  - Произвольный - объект или набор записей регистра, который вызвал событие "при записи".
//  Отказ  - Булево - признак отказа от записи объекта.
//
Процедура ИсточникОповещенияПриЗаписи(Источник, Отказ) Экспорт
	
	
	
КонецПроцедуры 

#КонецОбласти

#КонецОбласти
