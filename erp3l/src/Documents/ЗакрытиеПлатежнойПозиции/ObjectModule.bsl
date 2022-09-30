#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("УникальныйИдентификатор") Тогда
		ИдентификаторПозиции = ДанныеЗаполнения;
		ДанныеЗаполнения = Новый Структура;
		ЗаполнитьПоУникальномуИдентификаторуПозиции(ИдентификаторПозиции, ДанныеЗаполнения);
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ДанныеЗаполнения.Вставить("Ответственный", Пользователи.ТекущийПользователь());
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	//
	ПроведениеСерверОПК.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ЗакрытиеПлатежнойПозиции.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	ПроведениеСерверОПК.ПодготовитьНаборыЗаписейКПроведению(ЭтотОбъект);	
	
	// Движения по регистрам
	КонтрольЛимитовУХ.ОтразитьОперативныйПланПоБюджету(ДополнительныеСвойства, Движения, Отказ);
	КонтрольЛимитовУХ.ОтразитьЛимитыПоБюджетам(ДополнительныеСвойства, Движения, Отказ);
	
	// Отмена позиций
	СостояниеОтменена = Перечисления.СостоянияИсполненияЗаявки.Отменена;
	Для Каждого Строка Из ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСостоянияИсполненияДокументовПланирования Цикл
		
		Если Строка.СостояниеИсполнения = СостояниеОтменена Тогда
			Продолжить;
		КонецЕсли;
		ПлатежныеПозиции.УстановитьСостояниеИсполненияДокумента(Строка.ЗаявкаНаОперацию, Строка.ИдентификаторПозиции, СостояниеОтменена, , , Ссылка);
	КонецЦикла;
	
	//
	ПроведениеСерверОПК.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	//
	ПроведениеСерверОПК.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Удаление состояния отмены платежных позиций
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументИзменившийСостояние", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СостоянияИсполненияДокументовПланирования.ДокументПланирования КАК ДокументПланирования,
	|	СостоянияИсполненияДокументовПланирования.ИдентификаторПозиции КАК ИдентификаторПозиции,
	|	СостоянияИсполненияДокументовПланирования.ДокументИзменившийСостояние КАК ДокументИзменившийСостояние
	|ИЗ
	|	РегистрСведений.СостоянияИсполненияДокументовПланирования КАК СостоянияИсполненияДокументовПланирования
	|ГДЕ
	|	СостоянияИсполненияДокументовПланирования.ДокументИзменившийСостояние = &ДокументИзменившийСостояние";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Очищаем 
		НЗ = РегистрыСведений.СостоянияИсполненияДокументовПланирования.СоздатьНаборЗаписей();
		НЗ.Отбор.ДокументПланирования.Установить(Выборка.ДокументПланирования);
		НЗ.Отбор.ИдентификаторПозиции.Установить(Выборка.ИдентификаторПозиции);
		НЗ.Прочитать();
		
		Поз = 0;
		Пока Поз < НЗ.Количество() Цикл
			
			ДВ = НЗ[Поз];
			Если ДВ.ДокументИзменившийСостояние = Ссылка Тогда
				НЗ.Удалить(ДВ);
			Иначе
				Поз = Поз + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		НЗ.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоУникальномуИдентификаторуПозиции(ИдентификаторПозиции, ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПозиции", ИдентификаторПозиции);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	РазмещениеЗаявок.ЗаявкаНаОперацию КАК ЗаявкаНаОперацию,
	|	РазмещениеЗаявок.ПриходРасход КАК ПриходРасход,
	|	РазмещениеЗаявок.ИдентификаторПозиции КАК ИдентификаторПозиции
	|ИЗ
	|	РегистрСведений.РазмещениеЗаявок КАК РазмещениеЗаявок
	|ГДЕ
	|	РазмещениеЗаявок.ИдентификаторПозиции = &ИдентификаторПозиции";
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеЗаполнения.Вставить("ЗаявкаНаОперацию");
		ДанныеЗаполнения.Вставить("ПриходРасход");
		ДанныеЗаполнения.Вставить("ИдентификаторПозиции");
		ЗаполнитьЗначенияСвойств(ДанныеЗаполнения, Выборка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли 
