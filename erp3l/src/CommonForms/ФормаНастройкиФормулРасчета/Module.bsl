&НаКлиенте
Перем ВыполняетсяЗакрытие;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НазначениеРасчетов = ?(ЗначениеЗаполнено(Параметры.ИсточникДанныхДляРасчетов),Параметры.ИсточникДанныхДляРасчетов.НазначениеРасчетов,Параметры.НазначениеРасчетов);
	ПотребительРасчета = Параметры.ПотребительРасчета;
	СпособИспользования = Параметры.СпособИспользования;
	
	Если Параметры.ТекстПроцедуры = Неопределено Тогда
		
		ДанныеПроцедуры = УправлениеОтчетамиУХ.ПолучитьФормулыРасчета(НазначениеРасчетов, ПотребительРасчета);
		
		Если ДанныеПроцедуры.Количество() > 0 Тогда
			
			ПроизвольныйКод 		= ДанныеПроцедуры[0].ПроизвольныйКод;
			ТекстПроцедуры 			= ДанныеПроцедуры[0].Процедура;
			ПересчитыватьПриОткрытии= ДанныеПроцедуры[0].ПересчитыватьПриОткрытии;
			РедактированиеВозможно	= ДанныеПроцедуры[0].РедактированиеВозможно;
			
		Иначе
			ТекстПроцедуры = "";
		КонецЕсли;
		
	Иначе
		
		ФормаНеЗаписывать = Истина;
		ПроизвольныйКод 		= Параметры.ПроизвольныйКод;
		ТекстПроцедуры 			= Параметры.ТекстПроцедуры;
		ПересчитыватьПриОткрытии= Параметры.ПересчитыватьПриОткрытии;
		РедактированиеВозможно	= Параметры.РедактированиеВозможно;
		
	КонецЕсли;
		
	Если ПроизвольныйКод Тогда
		ПолеТекстовогоДокументаПроцедура.УстановитьТекст(ТекстПроцедуры);
	Иначе
		ПолеТекстовогоДокументаПроцедура.УстановитьТекст(ОбщегоНазначенияУХ.ЗаменитьКодыВТекстеФормулы(ТекстПроцедуры, НазначениеРасчетов, ПотребительРасчета));
	КонецЕсли;
	
	ПолеТекстовогоДокументаПроцедура.УстановитьТекст(ТекстПроцедуры);
	
	Если ПроизвольныйКод Тогда
		
		Элементы.ГруппаВидРасчета.ТекущаяСтраница=Элементы.ГруппаВидРасчета.ПодчиненныеЭлементы.ГруппаПроизвольныйКод;
		
	Иначе
		
		Элементы.ГруппаВидРасчета.ТекущаяСтраница=Элементы.ГруппаВидРасчета.ПодчиненныеЭлементы.ГруппаПараметрика;
		
	КонецЕсли;
	
	Если СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета Тогда
		
		ДляТрансформационныхКорректировок=(ТипЗнч(ПотребительРасчета.Владелец)=Тип("СправочникСсылка.ШаблоныТрансформационныхКорректировок"));
		
		Если ДляТрансформационныхКорректировок Тогда
			
			Элементы.ПотребительРасчета.Заголовок = Нстр("ru = 'Шаблон проводки'");
			
		Иначе
			
			Элементы.ПотребительРасчета.Заголовок = Нстр("ru = 'Показатель'");
			ВидОтчета = НазначениеРасчетов.Владелец;
			
		КонецЕсли;
		
	ИначеЕсли СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляКонтрольныхСоотношений Тогда
		
		ВидОтчета = НазначениеРасчетов.Владелец;
		
	ИначеЕсли СпособИспользования = Перечисления.СпособыИспользованияОперандов.ДляПараметрическихУсловий Тогда
		
		ВидОтчета = НазначениеРасчетов.ВидОтчета;
		
	КонецЕсли;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	ОтборФормулы=ОперандыДляРасчетов.Отбор.Элементы;
	
	УсловиеОтбора=ОтборФормулы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("НазначениеРасчетов");
	УсловиеОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	УсловиеОтбора.ПравоеЗначение=НазначениеРасчетов;
	
	УсловиеОтбора=ОтборФормулы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("ПотребительРасчета");
	УсловиеОтбора.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
	УсловиеОтбора.ПравоеЗначение=ПотребительРасчета;
	
	УсловиеОтбора=ОтборФормулы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("СпособИспользования");
	УсловиеОтбора.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
	УсловиеОтбора.ПравоеЗначение=СпособИспользования;
	
	Если СпособИспользования=Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета
		И (НЕ ДляТрансформационныхКорректировок) Тогда
		
		ОтборРасшифровки=ОперандыДляРасшифровок.Отбор.Элементы;
		
		УсловиеОтбора=ОтборРасшифровки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("НазначениеРасчетов");
		УсловиеОтбора.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		УсловиеОтбора.ПравоеЗначение=НазначениеРасчетов;
		
		УсловиеОтбора=ОтборРасшифровки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("ПотребительРасчета");
		УсловиеОтбора.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		УсловиеОтбора.ПравоеЗначение=ПотребительРасчета;
		
		УсловиеОтбора=ОтборРасшифровки.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		УсловиеОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных("СпособИспользования");
		УсловиеОтбора.ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		УсловиеОтбора.ПравоеЗначение=Перечисления.СпособыИспользованияОперандов.ДляПримечаний;
				
	КонецЕсли;	
				
	Если ЗначениеЗаполнено(Параметры.ИсточникДанныхДляРасчетов) Тогда
		
		Элементы.ОперандыДляРасчетов.ТекущаяСтрока=Параметры.ИсточникДанныхДляРасчетов;
		
	КонецЕсли;
	
	УстановитьВидимость();
		
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Если ФормаНеЗаписывать Тогда
		
		Элементы.ФормаЗаписать.Видимость = Ложь;
		ЭтаФорма.Команды.Найти("ФормаЗаписатьИЗакрыть").Заголовок = "ОК";
		
	КонецЕсли;
	
	Если ДляТрансформационныхКорректировок Тогда
		
		Элементы.ПроизвольныйКод.Видимость=Ложь;
		Элементы.ГруппаПараметры.Видимость=Ложь;
		
		Элементы.ДополнительныеРасшифровки.Видимость=Ложь;
		Элементы.ОперандыПоказателей.ОтображениеСтраниц=ОтображениеСтраницФормы.Нет;
		
		Элементы.ОперандыДляРасчетовВставитьПоказатели.Видимость=Ложь;
		Элементы.ОперандыДляРасчетовИтогПоСчету.Видимость=Ложь;
		
	КонецЕсли;	
	
КонецПроцедуры // УстановитьВидимость()

&НаКлиенте
Процедура ПередЗакрытием_Завершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;			// Отменяем закрытие.
	ИначеЕсли Результат = КодВозвратаДиалога.Да Тогда
		Если ЗаписатьФормулу() Тогда
			ВыполняетсяЗакрытие = Истина;
			Если ЭтаФорма.Открыта() Тогда
				ЭтаФорма.Закрыть();
			Иначе
				// Форма уже закрыта.
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось записать формулу. Закрытие отменено.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		ВыполняетсяЗакрытие = Истина;
		Если ЭтаФорма.Открыта() Тогда
			ЭтаФорма.Закрыть();
		Иначе
			// Форма уже закрыта.
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Неизвестный вариант выбора: %ВыбранноеЗначение%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВыбранноеЗначение%", Строка(Результат));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Если Не ВыполняетсяЗакрытие Тогда
			Отказ = Истина;
			СтруктураПараметров = Новый Структура;
			ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
			Режим = РежимДиалогаВопрос.ДаНетОтмена;
			Оповещение = Новый ОписаниеОповещения("ПередЗакрытием_Завершение", ЭтаФорма, СтруктураПараметров);
			ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
			Возврат;
		Иначе
			// Выполняем далее.
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Преобразует список кодов показателей СписокПоказателейВход отчета 
// ВидОтчетаВход в массив ссылок.
&НаСервереБезКонтекста
Функция НайтиПоказателиПоКоду(СписокПоказателейВход, ВидОтчетаВход)
	// Стандартизиируем коды показателей.
	РезультатФункции = Новый Массив;
	МассивПоиска = Новый Массив;
	ДлинаКодаПоказателя = Метаданные.Справочники.ПоказателиОтчетов.ДлинаКода;
	Для Каждого ТекСписокПоказателейВход Из СписокПоказателейВход Цикл
		ТекстПоказатель = СтрЗаменить(ТекСписокПоказателейВход.Значение, "Показатели.", "");
		КодПоказателя = ОбщегоНазначенияУХ.ДополнитьДоЗаданнойДлины(ТекстПоказатель, ДлинаКодаПоказателя);
		МассивПоиска.Добавить(КодПоказателя);
	КонецЦикла;
	// Выполним поиск показателей.
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ПоказателиОтчетов.Код,
		|	ПоказателиОтчетов.Владелец,
		|	ПоказателиОтчетов.Ссылка
		|ИЗ
		|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
		|ГДЕ
		|	НЕ ПоказателиОтчетов.ПометкаУдаления
		|	И ПоказателиОтчетов.Код В(&Код)
		|	И ПоказателиОтчетов.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", ВидОтчетаВход);
	Запрос.УстановитьПараметр("Код", МассивПоиска);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		РезультатФункции.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

&НаКлиенте
Процедура СозданиеИсточников_Завершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		СоздатьПоказателиПоСпискуКодов(ДополнительныеПараметры.МассивПоказателей, ДополнительныеПараметры.ВидОтчета, Истина);
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда	
		СоздатьПоказателиПоСпискуКодов(ДополнительныеПараметры.МассивПоказателей, ДополнительныеПараметры.ВидОтчета, Ложь);
	ИначеЕсли Результат = КодВозвратаДиалога.Отмена Тогда		
		Возврат;		// Пользователь отменил выполнение операции.
	Иначе
		ТекстСообщения = НСтр("ru = 'Выбрано неизвестное значение: %ВыбранноеЗначение%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ВыбранноеЗначение%", Строка(Результат));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

// По списку кодов СписокКодовВход создаёт операнды, ссылающиеюся на показатели
// отчета ВидОтчетаВход. Параметр ПропускатьДубликаты указывает действия в случае
// нахождения дублирующихся источников, ссылающихся на одни и те же показатели.
&НаКлиенте
Процедура СоздатьПоказателиПоСпискуКодов(СписокКодовВход, ВидОтчетаВход, ПропускатьДубликаты)
	Для Каждого СтрПоказатель ИЗ СписокКодовВход Цикл
		
		СдвигПериодов=0;
		
		СтруктураДанных=Новый Структура;
		
		Если ТипЗнч(СтрПоказатель.Значение)=Тип("Строка") Тогда	
			СтруктураДанных.Вставить("ТекстПоказатель",СтрПоказатель.Значение);
		Иначе
			СтруктураДанных.Вставить("ИсхПоказатель",СтрПоказатель.Значение);
		КонецЕсли;
		
		СтруктураДанных.Вставить("ВидОтчета", ВидОтчетаВход);
		СтруктураДанных.Вставить("КодПоказателя");
		СтруктураДанных.Вставить("ПоказательОтбор");
		СтруктураДанных.Вставить("НазначениеРасчетов", НазначениеРасчетов);
		СтруктураДанных.Вставить("ПотребительРасчета", ПотребительРасчета);
		
		Если ЗаполнениеПримечаний Тогда
			
			СтруктураДанных.Вставить("СпособИспользования",ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляПримечаний"));
			
		Иначе
			
			СтруктураДанных.Вставить("СпособИспользования", СпособИспользования);
			
		КонецЕсли;
		
		СтруктураДанных.Вставить("ЕстьАналогичныйПоказатель",Ложь);
		СтруктураДанных.Вставить("СдвигПериодов",СдвигПериодов);
		СтруктураДанных.Вставить("КодСуществующегоОперанда");
		СтруктураДанных.Вставить("КодОперанда");
		СтруктураДанных.Вставить("ВставитьТекстВФормулу",Ложь);
		
		Если НЕ СоздатьИсточникДанных(СтруктураДанных) Тогда // Определяем причину отказа
			
			Если СтруктураДанных.ЕстьАналогичныйПоказатель Тогда
				Если НЕ ПропускатьДубликаты Тогда

					Если НЕ СоздатьИсточникДанных(СтруктураДанных) Тогда
						
						Продолжить;
						
					Иначе
						
						Если СтруктураДанных.ВставитьТекстВФормулу Тогда
							
							ТекстВставки=СтруктураДанных.КодУпрощеннойФормулы;
							ВставитьТекстВФормулу(ТекстВставки);
							
							Элементы.ОперандыДляРасчетов.Обновить();
							
						Иначе
							
							Элементы.ОперандыДляРасшифровок.Обновить();
							
						КонецЕсли;
						
					КонецЕсли;
				Иначе
					Продолжить;		// Не создаём дублирующиеся элементы.
				КонецЕсли;
				
			Иначе // Ошибка при записи операнда
				
				Продолжить;
				
			КонецЕсли;
			
		Иначе
			
			Если СтруктураДанных.ВставитьТекстВФормулу Тогда
				
				ТекстВставки=СтруктураДанных.КодУпрощеннойФормулы;
				ВставитьТекстВФормулу(ТекстВставки);
				
				Элементы.ОперандыДляРасчетов.Обновить();
				
			Иначе
				
				Элементы.ОперандыДляРасшифровок.Обновить();
				
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ТекстВставки = "";
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ТекВидОтчета = ВыбранноеЗначение.ВидОтчета;
		МассивПоказателей = ВыбранноеЗначение.МассивПоказателей;
		
		Если ПроизвольныйКод Тогда
			
			Для Каждого СтрПоказатель ИЗ МассивПоказателей Цикл
				
				ТекстВставки=ТекстВставки+?(ТекВидОтчета=ВидОтчета,СтрПоказатель.Значение,СтрПоказатель.Представление)+" ";
				
			КонецЦикла;
			
			ПТД = Элементы.ПолеТекстовогоДокументаПроцедура;
			
			ПТД.ВыделенныйТекст=ТекстВставки;
			
		Иначе
			СсылкаМассивПоказателей = НайтиПоказателиПоКоду(МассивПоказателей, ТекВидОтчета);
			Если ЗаполнениеПримечаний Тогда
				МассивАналогичных = ОбщегоНазначенияУХ.ОпределитьНаличиеАналогичныхОперандов(НазначениеРасчетов, ПотребительРасчета, СсылкаМассивПоказателей, ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляПримечаний"));
			Иначе
				МассивАналогичных = ОбщегоНазначенияУХ.ОпределитьНаличиеАналогичныхОперандов(НазначениеРасчетов, ПотребительРасчета, СсылкаМассивПоказателей, СпособИспользования);
			КонецЕсли;
			КоличествоАналогичных = МассивАналогичных.Количество();
			Если КоличествоАналогичных > 0 Тогда
				СтруктураПараметров = Новый Структура;
				СтруктураПараметров.Вставить("МассивПоказателей", МассивПоказателей);
				СтруктураПараметров.Вставить("ВидОтчета", ТекВидОтчета);
				ТекстВопроса = НСтр("ru = 'Пропускать дублирующиеся?'");
				Если КоличествоАналогичных = 1 Тогда
					ПервыйЭлемент = МассивАналогичных[0];
					ПоказательПервый = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПервыйЭлемент, "ПоказательОтбор", ПредопределенноеЗначение("Справочник.ПоказателиОтчетов.ПустаяСсылка"));
					ТекстВопроса = НСтр("ru = 'В формуле уже присутствуют ссылки на показатель %ПоказательОтбор%. Пропускать дублирующиеся?'");
					ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ПоказательОтбор%", Строка(ПоказательПервый));
				Иначе
					ТекстВопроса = НСтр("ru = 'В формуле уже присутствуют ссылки на данные показатели (%КоличествоАналогичных%). Пропускать дублирующиеся?'");
					ТекстВопроса = СтрЗаменить(ТекстВопроса, "%КоличествоАналогичных%", Строка(КоличествоАналогичных));
				КонецЕсли;
				Режим = РежимДиалогаВопрос.ДаНетОтмена;
				Оповещение = Новый ОписаниеОповещения("СозданиеИсточников_Завершение", ЭтаФорма, СтруктураПараметров);
				ПоказатьВопрос(Оповещение, ТекстВопроса, Режим, 0);
			Иначе
				СоздатьПоказателиПоСпискуКодов(МассивПоказателей, ТекВидОтчета, Ложь);
			КонецЕсли;		
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ИзмененаПроцедураРасчета" И ТипЗнч(Параметр)=Тип("Структура") Тогда
		
		ПолеТекстовогоДокументаПроцедура.УстановитьТекст(Параметр.ТекстПроцедуры);
		
	ИначеЕсли ИмяСобытия="ВыбранИтогПоСчету" Тогда
		
		ТекстВставки=ОбработатьТекстИтогаДтКт(Параметр);
		
		Если Не ТекстВставки="" Тогда
			
			ВставитьТекстВФормулу(ТекстВставки);
			Элементы.ОперандыДляРасчетов.Обновить();
			
		КонецЕсли;
		
	КонецЕсли;	
			
КонецПроцедуры

&НаСервере
Функция ОбработатьТекстИтогаДтКт(ТекстИтога)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ТекстПроцедуры",		ТекстИтога);
	СтруктураДанных.Вставить("ТипЯчейки",			"Показатель");
	СтруктураДанных.Вставить("Владелец",			ВидОтчета);
	СтруктураДанных.Вставить("НазначениеРасчетов",	НазначениеРасчетов);
	СтруктураДанных.Вставить("ПотребительРасчета",	ПотребительРасчета);
	СтруктураДанных.Вставить("ПроизвольныйКод",		Ложь);
	СтруктураДанных.Вставить("СпособИспользования",	Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета);
	
	Если УправлениеОтчетамиУХ.ОбработатьТекстУпрощеннойФормулы(СтруктураДанных) Тогда		
		
		Возврат СтруктураДанных.РабочийТекстРедактирования;
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;
	
КонецФункции // ОбработатьТекстИтогаДтКт() 


&НаКлиенте
Функция ПроверитьТекстФормулы()
	
	Если НЕ (Модифицированность И ТипЗнч(НазначениеРасчетов) = Тип("СправочникСсылка.ПравилаОбработки")) Тогда // Проверка осуществляется только для операндов расчета показателей
		
		Возврат Истина;
		
	КонецЕсли;
	
	Если ПроверитьТекстФормулыСервер(СформироватьСтруктуруДляЗаписиФормулы()) Тогда
				
		Сообщить(Нстр("ru = 'Проверка успешно пройдена.'"));
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
		
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьТекстФормулыСервер(СтруктураДанных)

	Если НЕ СтруктураДанных.ПроизвольныйКод Тогда
		
		СтруктураДанных.Вставить("ТекстПроцедуры",ОбщегоНазначенияУХ.ЗаменитьКодыВТекстеФормулы(СтруктураДанных.ТекстПроцедуры, СтруктураДанных.НазначениеРасчетов, СтруктураДанных.ПотребительРасчета, Истина));
		
	КонецЕсли;
	
	Если Не УправлениеОтчетамиУХ.ПроверитьФормулуПоказателя(СтруктураДанных) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(Нстр("ru = 'При записи формулы обнаружены ошибки.'"),,,СтатусСообщения.Важное);
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции // ПроверитьТекстФормулы()

&НаСервере
Функция ЗаписатьПроцедуруРасчета(СтруктураДанных)
	
	Если ПроизвольныйКод Тогда
		
		Если НЕ УправлениеОтчетамиУХ.ПроверитьФормулуПоказателя(СтруктураДанных) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		РабочийТекстФормулы=СтруктураДанных.ТекстПроцедуры;
		РабочийТекстРедактирования=СтруктураДанных.ТекстПроцедуры;
		
	Иначе
		
		Если НЕ УправлениеОтчетамиУХ.ОбработатьТекстУпрощеннойФормулы(СтруктураДанных) Тогда		
			Возврат Ложь;	
		КонецЕсли;
		
		РабочийТекстФормулы=СтруктураДанных.ТекстПроцедуры;
		РабочийТекстРедактирования=СтруктураДанных.РабочийТекстРедактирования;
		
	КонецЕсли;
	
	УправлениеОтчетамиУХ.ЗаписатьПроцедуруРасчета(СтруктураДанных);
		
	ПолеТекстовогоДокументаПроцедура.УстановитьТекст(РабочийТекстРедактирования);
	
	Возврат Истина;
	
КонецФункции // ЗаписатьПроцедуруРасчета()


&НаКлиенте
Функция СформироватьСтруктуруДляЗаписиФормулы()
	
	СтруктураДанных=Новый Структура;
	СтруктураДанных.Вставить("ТекстПроцедуры",ПолеТекстовогоДокументаПроцедура.ПолучитьТекст());
	СтруктураДанных.Вставить("Владелец",ВидОтчета);
	СтруктураДанных.Вставить("НазначениеРасчетов",НазначениеРасчетов);
	СтруктураДанных.Вставить("ПотребительРасчета",ПотребительРасчета);
	СтруктураДанных.Вставить("ПроизвольныйКод",ПроизвольныйКод);
	СтруктураДанных.Вставить("ПересчитыватьПриОткрытии",ПересчитыватьПриОткрытии);
	СтруктураДанных.Вставить("РедактированиеВозможно",РедактированиеВозможно);
	
	Если ТипЗнч(НазначениеРасчетов)=Тип("СправочникСсылка.ПравилаЗаполненияОбъектовБД") Тогда
		
		СтруктураДанных.Вставить("СпособИспользования",ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляЗаполненияОбъектовБД"));
		
		Иначе
	
	СтруктураДанных.Вставить("СпособИспользования",ПредопределенноеЗначение("Перечисление.СпособыИспользованияОперандов.ДляФормулРасчета"));
	
	КонецЕсли;

	Возврат СтруктураДанных;
				
КонецФункции // СформироватьСтруктуруДляЗаписиФормулы()

&НаСервере
Функция ЗаписатьТекстФормулы(СтруктураПараметров)
				
	УправлениеОтчетамиУХ.ЗаписатьПроцедуруРасчета(СтруктураПараметров);
			
КонецФункции
 
&НаСервереБезКонтекста
Функция СоздатьИсточникДанных(СтруктураДанных)
	
	Возврат ОбщегоНазначенияУХ.СоздатьИсточникДанных(СтруктураДанных);	
	
КонецФункции
 
&НаКлиенте
Процедура ФормаЗаписатьИЗакрыть(Команда)
	
	Если ЗаписатьФормулу() Тогда
		
		Закрыть();
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ФормаЗаписать(Команда)
	
	ЗаписатьФормулу();
			
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьФормулу()
	
	Если Модифицированность=Ложь Тогда
		
		Возврат Истина;
		
	КонецЕсли;	
	
	СтруктураПараметров=СформироватьСтруктуруДляЗаписиФормулы();		
	
	Если ЗаписатьПроцедуруРасчета(СформироватьСтруктуруДляЗаписиФормулы()) Тогда
		
		Элементы.ОперандыДляРасчетов.Обновить();
		Модифицированность=Ложь;
		
		ВыполнитьОповещение(СтруктураПараметров.ТекстПроцедуры);
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции // 

&НаКлиенте
Процедура ВыполнитьОповещение(ТекстПроцедуры)
	
	СтруктураОтвета = Новый Структура;
	СтруктураОтвета.Вставить("ТекстПроцедуры", ТекстПроцедуры);
	СтруктураОтвета.Вставить("ПроцедураРедактирования", ПолеТекстовогоДокументаПроцедура.ПолучитьТекст());
	СтруктураОтвета.Вставить("ПотребительРасчета", ПотребительРасчета);
	СтруктураОтвета.Вставить("ПроизвольныйКод", ПроизвольныйКод);
	
	Оповестить("ИзмененаФормулаРасчета",СтруктураОтвета);
		
КонецПроцедуры


&НаКлиенте
Процедура РедактироватьПроцедуру(Команда)
	
	СтруктураПараметров=Новый Структура;
	СтруктураПараметров.Вставить("ТекстПроцедуры",ПолеТекстовогоДокументаПроцедура.ПолучитьТекст());
	СтруктураПараметров.Вставить("ВидОтчета", ВидОтчета);
	СтруктураПараметров.Вставить("НазначениеРасчетов",НазначениеРасчетов);
	СтруктураПараметров.Вставить("ПотребительРасчета",ПотребительРасчета);
	
	СписокВидовОтчетов=Новый СписокЗначений;
	СписокВидовОтчетов.Добавить(ВидОтчета);
	
	Если ЗначениеЗаполнено(ВидОтчетаОтбор) Тогда
		
		СписокВидовОтчетов.Добавить(ВидОтчетаОтбор);
		
	КонецЕсли;
	
	СтруктураПараметров.Вставить("ИспользуемыеВидыОтчетов",СписокВидовОтчетов);	
	ОткрытьФорму("ОбщаяФорма.ФормаРедактированияПроцедур", СтруктураПараметров, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьТекстВФормулу(ТекстВставки, Сдвиг = 0)
	
	ПТД = Элементы.ПолеТекстовогоДокументаПроцедура;	
	
	СтрокаНач=0;
	СтрокаКон=0;
	КолонкаНач=0;
	КолонкаКон=0;
	
	ПТД.ПолучитьГраницыВыделения(СтрокаНач,
								КолонкаНач,
								СтрокаКон,
								КолонкаКон);
	
	
	Если ПустаяСтрока(СокрЛП(ПолеТекстовогоДокументаПроцедура.ПолучитьТекст())) Тогда
		
		ПТД.УстановитьГраницыВыделения(1,1,1,1);
				
	КонецЕсли;
		
	ПТД.ВыделенныйТекст = ТекстВставки;
	
	Если НЕ Сдвиг=0 Тогда
		
		ПТД.ПолучитьГраницыВыделения(СтрокаНач,
									КолонкаНач,
									СтрокаКон,
									КолонкаКон);
		
		ПТД.УстановитьГраницыВыделения(СтрокаНач,КолонкаНач+Сдвиг,СтрокаКон,КолонкаКон+Сдвиг);
		
		
	КонецЕсли;
	
	Модифицированность = Истина;
	
	
КонецПроцедуры 

&НаКлиенте
Процедура КнопкаПлюс(Команда)
	
	ВставитьТекстВФормулу(" + ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМинус(Команда)
	
	ВставитьТекстВФормулу(" - ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаУмножить(Команда)
	
	ВставитьТекстВФормулу(" * ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаРазделить(Команда)
	
	ВставитьТекстВФормулу(" / ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаСкобки(Команда)
	
	ВставитьТекстВФормулу(" ()",-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаУсловие(Команда)
	
	ВставитьТекстВФормулу(" ?(,,)",-3);
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаМеньше(Команда)
	
	ВставитьТекстВФормулу(" < ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаРавно(Команда)
	
	ВставитьТекстВФормулу(" = ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаБольше(Команда)
	
	ВставитьТекстВФормулу(" > ");
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаВставитьСкобки(Команда)
	
	ВставитьТекстВФормулу("[]",-1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВФормулу(Команда)
	
	Если Элементы.ОперандыДляРасчетов.ТекущиеДанные=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекстДляВставки="";
	
	Для Каждого Строка ИЗ Элементы.ОперандыДляРасчетов.ВыделенныеСтроки Цикл
		
		ТекстДляВставки=ТекстДляВставки+" "+Элементы.ОперандыДляРасчетов.ДанныеСтроки(Строка).КодУпрощеннойФормулы;
		
	КонецЦикла;
		
	ВставитьТекстВФормулу(ТекстДляВставки+" ");
		
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПоказатели(Команда)
	
	ВставитьОбращениеКПоказателю();
	
КонецПроцедуры

&НаКлиенте
Процедура ВставитьОбращениеКПоказателю()
	
	Если НЕ ЗначениеЗаполнено(ВидОтчетаОтбор) Тогда
		
		ТекВидОтчета=ВидОтчета;
		
	Иначе
		
		ТекВидОтчета=ВидОтчетаОтбор;
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ПоказателиОтчетов.Форма.ФормаВыбора",Новый Структура("Отбор,ВозвращатьКод",Новый Структура("Владелец",ТекВидОтчета),Истина),ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ОперандыПоказателейПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ЗаполнениеПримечаний = (ТекущаяСтраница = Элементы.ДополнительныеРасшифровки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизвольныйКодПриИзменении(Элемент)
	
	Если ПроизвольныйКод Тогда
		
		Элементы.ГруппаВидРасчета.ТекущаяСтраница = Элементы.ГруппаПроизвольныйКод;
		
	Иначе
		
		Элементы.ГруппаВидРасчета.ТекущаяСтраница = Элементы.ГруппаПараметрика;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	ПроверитьТекстФормулы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеТекстовогоДокументаПроцедураПриИзменении(Элемент)
	
	Модифицированность=Истина;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьРабочийПланСчетов(ПравилоОбработки)
	
	Возврат ПравилоОбработки.ПланСчетовПоУмолчанию;	
	
КонецФункции // ПолучитьРабочийПланСчетов()

&НаКлиенте
Процедура ИтогПоСчету(Команда)
	
	РабочийПланСчетов=ПолучитьРабочийПланСчетов(НазначениеРасчетов);
	
	Если ЗначениеЗаполнено(РабочийПланСчетов) Тогда
		
		ОткрытьФорму("Справочник.СчетаБД.Форма.ФормаВыбораВидаИтога",Новый Структура("ПланСчетов",РабочийПланСчетов));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОперандыДляРасчетовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	ТекстДляВставки="";
	
	Для Каждого Строка ИЗ ПараметрыПеретаскивания.Значение Цикл
		
		ТекстДляВставки=ТекстДляВставки+" "+Элементы.ОперандыДляРасчетов.ДанныеСтроки(Строка).КодУпрощеннойФормулы;
		
	КонецЦикла;
	
	ПараметрыПеретаскивания.Значение=ТекстДляВставки;

КонецПроцедуры

ВыполняетсяЗакрытие = Ложь;