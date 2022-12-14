#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МожноВыполнять = Параметры.МожноВыполнять;
	ВидРЦ          = Параметры.ВидРЦ;
	РабочийЦентр   = Параметры.РабочийЦентр;
	Операция       = Параметры.Операция;
	Изделие        = Параметры.Изделие;
	Исполнитель    = Параметры.Исполнитель;
	Этап           = Параметры.Этап;
	Партия         = Параметры.Партия;
	Участок        = Параметры.Участок;
	Подразделение  = Параметры.Подразделение;
	
	ПрочитатьПараметрыПодразделения();
	
	Настройки = Обработки.ВыполнениеОпераций2_2.ПолучитьНастройкиПользователя();
	
	Если Настройки <> Неопределено Тогда
	
		Элементы.Участок.Доступность      = НЕ ЗначениеЗаполнено(Настройки.Участок);
		Элементы.РабочийЦентр.Доступность = НЕ ЗначениеЗаполнено(Настройки.РабочийЦентр);
		Элементы.Исполнитель.Доступность  = НЕ ЗначениеЗаполнено(Настройки.Исполнитель);
		
		Элементы.ВидРЦ.Видимость = Элементы.РабочийЦентр.Доступность;
	КонецЕсли;
	
	НастроитьЭлементыФормы();
	
	УправлениеПроизводствомКлиентСервер.УстановитьТипИсполнителя(Исполнитель, ИспользоватьБригадныеНаряды);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьОтборы(Команда)
	
	ПараметрыОтбора = Новый Структура();
	
	ПараметрыОтбора.Вставить("МожноВыполнять", МожноВыполнять);
	ПараметрыОтбора.Вставить("ВидРЦ", ВидРЦ);
	ПараметрыОтбора.Вставить("РабочийЦентр", РабочийЦентр);
	ПараметрыОтбора.Вставить("Исполнитель", Исполнитель);
	ПараметрыОтбора.Вставить("Операция", Операция);
	ПараметрыОтбора.Вставить("Изделие", Изделие);
	ПараметрыОтбора.Вставить("Партия", Партия);
	ПараметрыОтбора.Вставить("Этап", Этап);
	ПараметрыОтбора.Вставить("Участок", Участок);
	
	Закрыть(ПараметрыОтбора);
КонецПроцедуры

&НаКлиенте
Процедура СбросОтборов(Команда)
	
	Если Элементы.РабочийЦентр.Видимость Тогда
		ВидРЦ        = Неопределено;
		РабочийЦентр = Неопределено;
		
		ВладелецФормы.ВидРЦ        = Неопределено;
		ВладелецФормы.РабочийЦентр = Неопределено;
	КонецЕсли;
	
	Если Элементы.Исполнитель.Видимость Тогда
		УправлениеПроизводствомКлиентСервер.УстановитьТипИсполнителя(Исполнитель,ИспользоватьБригадныеНаряды);
		
		ВладелецФормы.Исполнитель = Неопределено;
	КонецЕсли;
	
	Если Элементы.Участок.Видимость Тогда
		Участок = Неопределено;
		
		ВладелецФормы.Участок = Неопределено;
	КонецЕсли;
	
	Операция = Неопределено;
	Изделие  = Неопределено;
	Этап     = Неопределено;
	Партия   = Неопределено;
	
	ВладелецФормы.Операция = Неопределено;
	ВладелецФормы.Изделие  = Неопределено;
	ВладелецФормы.Этап     = Неопределено;
	ВладелецФормы.Партия   = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийЦентрПриИзменении(Элемент)
	ВидРЦ = ПолучитьВидРЦ(РабочийЦентр);
КонецПроцедуры

&НаКлиенте
Процедура ВидРЦПриИзменении(Элемент)
	
	Если ПолучитьВидРЦ(РабочийЦентр) = ВидРЦ Тогда
		Возврат
	КонецЕсли;
	
	РабочийЦентр = Неопределено;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	// Связи параметров выбора рабочего центра
	МассивПараметров = Новый Массив;
	
	МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Подразделение", "Подразделение"));
	
	Если ИспользоватьУчастки Тогда
		МассивПараметров.Добавить(Новый СвязьПараметраВыбора("Отбор.Участок", "Участок"));
	КонецЕсли;
	
	Элементы.РабочийЦентр.СвязиПараметровВыбора = Новый ФиксированныйМассив(МассивПараметров);
	
	Элементы.Участок.Видимость = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Подразделение,
		"ИспользоватьПроизводственныеУчастки");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВидРЦ(РабочийЦентр)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РабочийЦентр, "ВидРабочегоЦентра");
КонецФункции

&НаСервере
Процедура ПрочитатьПараметрыПодразделения()
	
	Если Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(
		ЭтаФорма,
		ПроизводствоСервер.ПараметрыПроизводственногоПодразделения(Подразделение),
		"ИспользоватьБригадныеНаряды, ИспользоватьУчастки");
КонецПроцедуры

#КонецОбласти