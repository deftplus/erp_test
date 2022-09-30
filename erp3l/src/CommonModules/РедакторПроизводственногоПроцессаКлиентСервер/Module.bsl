////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции редактора производственного процесса
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

#Область ЭтапПроизводства

// Устанавливает доступность реквизитов длительности этапа
// 
// Параметры:
// 	Объект - СправочникОбъект.ЭтапыПроизводства
// 	Форма - ФормаКлиентскогоПриложения
// 	ПрефиксЭлементов - Строка - префикс элементов
Процедура НастроитьЭлементыГруппыДлительностьЭтапа(Объект, Форма, ПрефиксЭлементов = "") Экспорт
	
	Элементы = Форма.Элементы;
	
	ДлительностьТолькоПросмотр = РассчитыватьДлительностьАвтоматически(Объект,
		Форма.ИспользуетсяПроизводство21,
		Форма.ИспользуетсяПланированиеПоМатериальнымРесурсам,
		Форма.ИспользуетсяПланированиеПоПроизводственнымРесурсам);
	
	СоответствиеЭлементов = СоответствиеЭлементов(ПрефиксЭлементов);
	
	Элементы[СоответствиеЭлементов.ДлительностьЭтапа].ТолькоПросмотр                 = ДлительностьТолькоПросмотр;
	Элементы[СоответствиеЭлементов.ЕдиницаИзмеренияДлительностиЭтапа].ТолькоПросмотр = ДлительностьТолькоПросмотр;
	
КонецПроцедуры

//++ НЕ УТКА

// Устанавливает доступность и прочие настройки реквизитов маршрутной карты
// 
// Параметры:
// 	Объект - СправочникОбъект.ЭтапыПроизводства
// 	Форма - ФормаКлиентскогоПриложения
// 	ПрефиксЭлементов - Строка - префикс элементов
Процедура НастроитьЭлементыГруппыМаршрутнаяКарта(Объект, Форма, ПрефиксЭлементов = "") Экспорт
	
	Элементы = Форма.Элементы;
	
	ОтображатьКоэффициент = 
		Форма.ИспользуетсяПроизводство22
		И Форма.ИспользоватьМаршрутныеКарты
		И НЕ Форма.ИспользуетсяПроизводство21;
	
	СоответствиеЭлементов = СоответствиеЭлементов(ПрефиксЭлементов);
	
	Элементы[СоответствиеЭлементов.КоэффициентМаршрутнойКарты].Видимость = ОтображатьКоэффициент;
	Элементы[СоответствиеЭлементов.КоэффициентМаршрутнойКарты].АвтоОтметкаНезаполненного = ЗначениеЗаполнено(Объект.МаршрутнаяКарта);
	Элементы[СоответствиеЭлементов.КоэффициентМаршрутнойКарты].ТолькоПросмотр = НЕ Форма.ДоступностьРеквизитов
		ИЛИ Форма.СпецификацияЗакрыта
		ИЛИ НЕ ЗначениеЗаполнено(Объект.МаршрутнаяКарта);
		
	Элементы[СоответствиеЭлементов.РассчитатьКоэффициентМаршрутнойКарты].Видимость = ОтображатьКоэффициент;
	
	Элементы[СоответствиеЭлементов.РассчитатьКоэффициентМаршрутнойКарты].Доступность = ОтображатьКоэффициент
		И НЕ Элементы[СоответствиеЭлементов.КоэффициентМаршрутнойКарты].ТолькоПросмотр
		И Форма[СоответствиеЭлементов.РассчитыватьКоэффициент];
	
	Элементы[СоответствиеЭлементов.СтраницыРазбиватьМаршрутныеЛисты].ТекущаяСтраница =
		?(ЗначениеЗаполнено(Объект.МаршрутнаяКарта),
			Элементы[СоответствиеЭлементов.СтраницаРазбиватьМаршрутныеЛистыПоМаршрутнойКарте],
			Элементы[СоответствиеЭлементов.СтраницаРазбиватьМаршрутныеЛисты]);
			
КонецПроцедуры

Функция ПолучитьНастройкиМаршрутнойКарты(Объект) Экспорт
	
	Результат = Новый Структура;
	
	Если ЗначениеЗаполнено(Объект.МаршрутнаяКарта) Тогда
		
		РеквизитыМК = УправлениеДаннымиОбИзделияхВызовСервера.ЗначенияРеквизитовМаршрутнойКарты(Объект.МаршрутнаяКарта);
		
		Результат.Вставить("РассчитыватьКоэффициент", РеквизитыМК.РассчитыватьКоэффициент);
		Результат.Вставить("РазбиватьМаршрутныеЛистыПоМаршрутнойКарте", РеквизитыМК.МаксимальноеКоличествоЕдиницПартийИзделия <> 0);
		
	Иначе
		
		Результат.Вставить("РассчитыватьКоэффициент", Ложь);
		Результат.Вставить("РазбиватьМаршрутныеЛисты", Объект.МаксимальноеКоличествоЕдиницПартийИзделия <> 0);
		Результат.Вставить("МаксимальноеКоличествоЕдиницПартийИзделия", Объект.МаксимальноеКоличествоЕдиницПартийИзделия);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

//-- НЕ УТКА

// Производит заполнение реквизитов пояснения настроек этапа
// 
// Параметры:
// 	Объект - СправочникОбъект.ЭтапыПроизводства
// 	Форма - ФормаКлиентскогоПриложения
// 	ПрефиксЭлементов - Строка - префикс элементов
Процедура ЗаполнитьПояснениеОсновныхНастроек(Объект, Форма, ПрефиксЭлементов = "") Экспорт
	
	МассивСтрок = Новый Массив;
	
	Элементы = Форма.Элементы;
	
	СоответствиеЭлементов = СоответствиеЭлементов(ПрефиксЭлементов);
	
	//++ НЕ УТКА
	
	Производство21 = Форма.ИспользуетсяПроизводство21;
	ПланироватьПоПроизводственнымРесурсам = Форма.ИспользуетсяПланированиеПоПроизводственнымРесурсам;
	ПланироватьПоМатериальнымРесурсам = Форма.ИспользуетсяПланированиеПоМатериальнымРесурсам;
	ИспользоватьВРЦ = Объект.ПланироватьРаботуВидовРабочихЦентров;
	ИспользоватьПланыПроизводства = Форма.ИспользоватьПланированиеПроизводства;
	ПроизводствоНаСтороне = НЕ (Форма[СоответствиеЭлементов.СпособПроизводства] = 0);
	
	Если (НЕ ПланироватьПоПроизводственнымРесурсам И ПланироватьПоМатериальнымРесурсам)
		И Производство21
		И ИспользоватьВРЦ Тогда
		
		МассивСтрок.Добавить(
			НСтр("ru = 'Виды рабочих центров используются для построения графика с учетом доступности (в управлении производством версии 2.1).';
				|en = 'Work center types are used to create a schedule considering availability (in Production management, version 2.1).'"));
		
		МассивСтрок.Добавить(
			НСтр("ru = 'Длительность этапа используется для построения графика производства (в управлении производством версии 2.2).';
				|en = 'Stage duration is used to create a production schedule (in Production management, version 2.2).'"));
		
	Иначе
		
		Если (ПланироватьПоПроизводственнымРесурсам ИЛИ Производство21) И ИспользоватьВРЦ Тогда
			
			МассивСтрок.Добавить(
				НСтр("ru = 'Виды рабочих центров используются для построения графика с учетом доступности.';
					|en = 'Work center types are used to create a schedule considering availability.'"));
			
		ИначеЕсли ИспользоватьПланыПроизводства И ИспользоватьВРЦ Тогда
			
			МассивСтрок.Добавить(
				НСтр("ru = 'Виды рабочих центров используются для расчета потребностей по планам производства.';
					|en = 'Work center types are used to calculate demand according to production plans.'"));
				
		ИначеЕсли ИспользоватьВРЦ Тогда
			
			МассивСтрок.Добавить(НСтр("ru = 'Виды рабочих центров задаются справочно.';
										|en = 'Work center types are set for reference.'"));
			
		КонецЕсли;
		
		Если (
				(ПланироватьПоПроизводственнымРесурсам ИЛИ Производство21)
				И НЕ ИспользоватьВРЦ
			)
			ИЛИ (
					НЕ ПланироватьПоПроизводственнымРесурсам И ПланироватьПоМатериальнымРесурсам
				)
			ИЛИ ПроизводствоНаСтороне Тогда
			
			МассивСтрок.Добавить(
				НСтр("ru = 'Длительность этапа используется для построения графика производства.';
					|en = 'Stage duration is used to create a production schedule.'"));
			
		ИначеЕсли ПланироватьПоПроизводственнымРесурсам И ИспользоватьВРЦ Тогда
			
			МассивСтрок.Добавить(
				НСтр("ru = 'Длительность этапа используется для определения сроков изготовления продукции без построения графика.';
					|en = 'Stage duration is used to determine product manufacturing deadlines without making a schedule.'"));
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если (ПланироватьПоПроизводственнымРесурсам ИЛИ ПланироватьПоМатериальнымРесурсам) И ПроизводствоНаСтороне Тогда
		
		МассивСтрок.Добавить(
			НСтр("ru = 'Планирование производства будет происходить по графику работы предприятия.';
				|en = 'Production planning will occur according to the enterprise work schedule.'"));
		
	КонецЕсли;
	
	Если РассчитыватьДлительностьАвтоматически(Объект,
		Производство21,
		ПланироватьПоМатериальнымРесурсам,
		ПланироватьПоПроизводственнымРесурсам) Тогда
		
		МассивСтрок.Добавить(
				НСтр("ru = 'Длительность рассчитывается автоматически по размеру буферов и времени работы видов рабочих центров.';
					|en = 'Duration is calculated automatically according to the buffer size and working hours of work center types.'"));
		
	КонецЕсли;
	
	//-- НЕ УТКА
	
	ГруппаПояснение = Элементы[СоответствиеЭлементов.ГруппаДлительность];
	ГруппаПояснение.Подсказка = ?(МассивСтрок.ВГраница() <> -1, СтрСоединить(МассивСтрок, Символы.ПС), "");
	
КонецПроцедуры

Функция ОбязательностьЗаполненияЕдиницИзмеренияБуферов(Объект) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЕдиницаИзмеренияПредварительногоБуфера", Ложь);
	Результат.Вставить("ЕдиницаИзмеренияЗавершающегоБуфера", Ложь);
	
	Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмеренияПредварительногоБуфера)
		И Объект.ПредварительныйБуфер <> 0 Тогда
		Результат.ЕдиницаИзмеренияПредварительногоБуфера = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмеренияЗавершающегоБуфера)
		И Объект.ЗавершающийБуфер <> 0 Тогда
		Результат.ЕдиницаИзмеренияЗавершающегоБуфера = Истина;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция РассчитыватьДлительностьАвтоматически(Объект,
	ИспользуетсяПроизводство21,
	ИспользуетсяПланированиеПоМатериальнымРесурсам,
	ИспользуетсяПланированиеПоПроизводственнымРесурсам) Экспорт
	
	Возврат Объект.ПланироватьРаботуВидовРабочихЦентров
		И (
			ИспользуетсяПланированиеПоПроизводственнымРесурсам
			ИЛИ (
					ИспользуетсяПроизводство21
					И НЕ ИспользуетсяПланированиеПоМатериальнымРесурсам
				)
		);
	
КонецФункции

#Область ВидыРабочихЦентров

//++ НЕ УТКА

// Выполняет стандартные действия при вводе новой строки видов рабочих центров
// - устанавливает количество альтернативных видов рабочих центров.
//
// Параметры:
//  ДанныеСтроки						- ДанныеФормыСтруктура - содержит данные строки
//  Копирование							- Булево - Истина, если выполняется копирование строки
//  АльтернативныеВидыРабочихЦентров	- ТабличнаяЧасть - таблица содержащая данные ТЧ "АльтернативныеВидыРабочихЦентров".
//
Процедура ПриВводеНовойСтрокиВидовРабочихЦентров(ДанныеСтроки, Копирование, АльтернативныеВидыРабочихЦентров = Неопределено) Экспорт

	Если НЕ Копирование И НЕ ЗначениеЗаполнено(ДанныеСтроки.ЕдиницаИзмерения) Тогда
		
		ДанныеСтроки.ЕдиницаИзмерения  = УправлениеДаннымиОбИзделияхКлиентСервер.ОсновнаяЕдиницаВремени();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьЕстьВРЦССинхроннойЗагрузкой(ВидыРабочихЦентров, Флаг) Экспорт
	
	Флаг = Ложь;
	
	Для каждого ОсновнойВРЦ Из ВидыРабочихЦентров.ПолучитьЭлементы() Цикл
		
		Если ОсновнойВРЦ.СинхроннаяЗагрузка Тогда
			Флаг = Истина;
			Прервать;
		КонецЕсли;
		
		Для каждого АльтернативныйВРЦ Из ОсновнойВРЦ.ПолучитьЭлементы() Цикл
			
			Если АльтернативныйВРЦ.СинхроннаяЗагрузка Тогда
				Флаг = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Флаг Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность и прочие настройки переключателя загрузки нескольких видов рабочих центров 
// 
// Параметры:
// 	Объект - СправочникОбъект.ЭтапыПроизводства
// 	Форма - ФормаКлиентскогоПриложения
// 	ПрефиксЭлементов - Строка - префикс элементов
Процедура НастроитьЭлементПорядокРаботыВидовРабочихЦентров(Объект, Форма, ПрефиксЭлементов = "") Экспорт
	
	Элементы = Форма.Элементы;
	
	РеквизитыФормы = Новый Структура("Режим");
	ЗаполнитьЗначенияСвойств(РеквизитыФормы, Форма);
	
	ВидимостьПорядкаРаботыВРЦ = Объект.ПланироватьРаботуВидовРабочихЦентров
		И Форма.ИспользуетсяПроизводство22
		И РеквизитыФормы.Режим <> "СпецификацияЗаказа";
	
	СоответствиеЭлементов = СоответствиеЭлементов(ПрефиксЭлементов);
	
	Если ВидимостьПорядкаРаботыВРЦ Тогда
		
		НесколькоВидовРЦ = Форма[СоответствиеЭлементов.ВидыРабочихЦентров].ПолучитьЭлементы().Количество() > 1;
		
		Если НесколькоВидовРЦ Тогда
			Элементы[СоответствиеЭлементов.ПорядокРаботыВидовРабочихЦентров].ПодсказкаВвода = "";
		Иначе
			Элементы[СоответствиеЭлементов.ПорядокРаботыВидовРабочихЦентров].ПодсказкаВвода = НСтр("ru = '<не используется>';
																									|en = '<not used>'");
		КонецЕсли;
		
		Если Форма.ДоступностьРеквизитов И НЕ Форма.СпецификацияЗакрыта Тогда
			Элементы[СоответствиеЭлементов.ПорядокРаботыВидовРабочихЦентров].ТолькоПросмотр = НЕ НесколькоВидовРЦ;
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы[СоответствиеЭлементов.ПорядокРаботыВидовРабочихЦентров].Видимость = ВидимостьПорядкаРаботыВРЦ;
	
КонецПроцедуры

//-- НЕ УТКА

// Настраивает элементы страницы "Виды рабочих центров" 
// 
// Параметры:
// 	Объект - СправочникОбъект.ЭтапыПроизводства
// 	Форма - ФормаКлиентскогоПриложения
// 	ПрефиксЭлементов - Строка - префикс элементов
Процедура НастроитьЭлементыГруппыВидыРабочихЦентров(Объект, Форма, ПрефиксЭлементов = "") Экспорт
	
	Элементы = Форма.Элементы;
	
	СобственноеПроизводство = НЕ Объект.ПроизводствоНаСтороне;
		
	ИспользоватьВРЦ = Объект.ПланироватьРаботуВидовРабочихЦентров;
	
	Планирование22 = Форма.ИспользуетсяПроизводство22
		И Форма.ИспользуетсяПланированиеПоПроизводственнымРесурсам;
	
	ПланированиеПоЗагрузкеВРЦ = ИспользоватьВРЦ
		И (Планирование22 ИЛИ Форма.ИспользуетсяПроизводство21);
	
	СоответствиеЭлементов = СоответствиеЭлементов(ПрефиксЭлементов);
	
	Элементы[СоответствиеЭлементов.СтраницаВидыРабочихЦентров].Видимость = ИспользоватьВРЦ;
	
	Если ИспользоватьВРЦ Тогда
		
		Элементы[СоответствиеЭлементов.ВидыРабочихЦентров].Видимость = Истина;
		
		Элементы[СоответствиеЭлементов.ГруппаОдновременноПроизводимоеКоличество].Видимость = Истина;
		
		Элементы[СоответствиеЭлементов.ИнтервалПланирования].Видимость = ПланированиеПоЗагрузкеВРЦ
			И СобственноеПроизводство;
			
		Элементы[СоответствиеЭлементов.ГруппаБуферы].Видимость = ПланированиеПоЗагрузкеВРЦ И СобственноеПроизводство;
		
		Элементы[СоответствиеЭлементов.Непрерывный].Видимость = ПланированиеПоЗагрузкеВРЦ И СобственноеПроизводство;
		
		//++ НЕ УТКА
		РедакторПроизводственногоПроцессаКлиентСервер.НастроитьЭлементПорядокРаботыВидовРабочихЦентров(Объект, Форма, ПрефиксЭлементов);
		//-- НЕ УТКА
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//++ НЕ УТКА

#Область ТехнологическаяОперация

Функция ВидРабочегоЦентра(РабочийЦентр) Экспорт
	
	Если ТипЗнч(РабочийЦентр) = Тип("СправочникСсылка.ВидыРабочихЦентров") Тогда
		
		Возврат РабочийЦентр;
		
	Иначе
		
		Возврат ОбщегоНазначенияУТВызовСервера.ЗначениеРеквизитаОбъекта(РабочийЦентр, "ВидРабочегоЦентра");
		
	КонецЕсли;
	
КонецФункции

// Производит заполнение единицы измерения передаточной партии
// 
// Параметры:
// 	Объект - СправочникОбъект.ТехнологическиеОперации
// 	ЕдиницаИзмеренияПередаточнойПартии - Строка
Процедура ЗаполнитьЕдиницуИзмеренияПередаточнойПартии(Объект, ЕдиницаИзмеренияПередаточнойПартии) Экспорт
	
	Если Объект.ПередаточнаяПартия = 0 Тогда
		ЕдиницаИзмеренияПередаточнойПартии = НСтр("ru = 'передается вся партия этапа';
													|en = 'whole stage lot is transferred'");
	Иначе
		ЕдиницаИзмеренияПередаточнойПартии = " * " + 
			Объект.Количество + ?(ЗначениеЗаполнено(Объект.ЕдиницаИзмерения), " " + 
			УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
				Объект.ЕдиницаИзмерения, 
				Объект.Количество), "") + " = " + 
			(Объект.ПередаточнаяПартия * Объект.Количество) + " " +
			УправлениеПроизводствомКлиентСервер.ПредставлениеЕдиницыИзмеренияОперации(
				Объект.ЕдиницаИзмерения, 
				Объект.ПередаточнаяПартия * Объект.Количество);
	КонецЕсли;
		
КонецПроцедуры

#Область ДополнительныеРеквизитыВидаОперации

Процедура ЗагрузитьНормативыВидаОперации(Объект, ДопРеквизиты) Экспорт
	
	Объект.НормативыВидаОперации.Очистить();
	
	Для каждого Строка Из ДопРеквизиты Цикл
		Если Строка.ЗначениеМин <> 0 ИЛИ Строка.ЗначениеМакс <> 0 Тогда
			ЗаполнитьЗначенияСвойств(Объект.НормативыВидаОперации.Добавить(), Строка, "Свойство, ЗначениеМин, ЗначениеМакс");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

//-- НЕ УТКА

#Область Прочее

Процедура УстановитьКартинкуЭлемента(ДанныеСтроки, КартинкиЭлементов = Неопределено) Экспорт
	
	Если ДанныеСтроки.ВидЭлемента = "Этап" Тогда
		ИндексКартинки = 0;
	//++ НЕ УТКА
	ИначеЕсли ДанныеСтроки.ВидЭлемента = "Операция" Тогда
		ИндексКартинки = ?(НЕ ЗначениеЗаполнено(ДанныеСтроки.ТехнологическийПроцесс), 1, 2);
	//-- НЕ УТКА
	КонецЕсли;
	
	Если КартинкиЭлементов = Неопределено Тогда
		КартинкиЭлементов = Новый Массив;
		КартинкиЭлементов.Добавить(БиблиотекаКартинок.РедакторПроизводственногоПроцессаЭтап);
		//++ НЕ УТКА
		КартинкиЭлементов.Добавить(БиблиотекаКартинок.РедакторПроизводственногоПроцессаОперация);
		КартинкиЭлементов.Добавить(БиблиотекаКартинок.РедакторПроизводственногоПроцессаТехпроцесс);
		//-- НЕ УТКА
	КонецЕсли;
	
	ДанныеСтроки.Картинка = КартинкиЭлементов[ИндексКартинки];
	
КонецПроцедуры

Функция СоответствиеЭлементов(ПрефиксЭлементов) Экспорт
	
	Результат = Новый Структура;
	
	Если ПрефиксЭлементов = "Этап" ИЛИ ПустаяСтрока(ПрефиксЭлементов) Тогда
		
		Результат.Вставить("ГруппаБуферы",                                          "ЭтапГруппаБуферы");
		Результат.Вставить("ГруппаДлительность",                                    "ЭтапГруппаДлительность");
		Результат.Вставить("ГруппаОдновременноПроизводимоеКоличество",              "ЭтапГруппаОдновременноПроизводимоеКоличество");
		Результат.Вставить("СтраницаВидыРабочихЦентров",                            "ЭтапСтраницаВидыРабочихЦентров");
		Результат.Вставить("СтраницаРазбиватьМаршрутныеЛисты",                      "ЭтапСтраницаРазбиватьМаршрутныеЛисты");
		Результат.Вставить("СтраницыРазбиватьМаршрутныеЛисты",                      "ЭтапСтраницыРазбиватьМаршрутныеЛисты");
		Результат.Вставить("СтраницаРазбиватьМаршрутныеЛистыПоМаршрутнойКарте",     "ЭтапСтраницаРазбиватьМаршрутныеЛистыПоМаршрутнойКарте");
		
		Результат.Вставить("Непрерывный",                                           "ЭтапНепрерывный");
		Результат.Вставить("ИнтервалПланирования",                                  "ЭтапИнтервалПланирования");
		
		Результат.Вставить("ВидыРабочихЦентров",                                    "ЭтапВидыРабочихЦентров");
		
		Результат.Вставить("ПорядокРаботыВидовРабочихЦентров",                      "ЭтапПорядокРаботыВидовРабочихЦентров");
		Результат.Вставить("СпособПроизводства",                                    "ЭтапСпособПроизводства");
		Результат.Вставить("КоэффициентМаршрутнойКарты",                            "ЭтапКоэффициентМаршрутнойКарты");
		Результат.Вставить("РассчитатьКоэффициентМаршрутнойКарты",                  "ЭтапРассчитатьКоэффициентМаршрутнойКарты");
		Результат.Вставить("РассчитыватьКоэффициент",                               "ЭтапРассчитыватьКоэффициент");

		Результат.Вставить("РазбиватьМаршрутныеЛистыПоМаршрутнойКарте",             "ЭтапРазбиватьМаршрутныеЛистыПоМаршрутнойКарте");
		Результат.Вставить("РазбиватьМаршрутныеЛисты",                              "ЭтапРазбиватьМаршрутныеЛисты");
		Результат.Вставить("МаксимальноеКоличествоЕдиницПартийИзделия",             "ЭтапМаксимальноеКоличествоЕдиницПартийИзделия");
		
		Результат.Вставить("НомерЭтапа",                                            "ЭтапНомерЭтапа");
		Результат.Вставить("НомерСледующегоЭтапа",                                  "ЭтапНомерСледующегоЭтапа");
		Результат.Вставить("Подразделение",                                         "ЭтапПодразделение");
		Результат.Вставить("СпособПроизводства",                                    "ЭтапСпособПроизводства");
		Результат.Вставить("ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий", "ЭтапОдновременноПроизводимоеКоличествоЕдиницПартийИзделий");
		Результат.Вставить("ПланироватьРаботуВидовРабочихЦентров",                  "ЭтапПланироватьРаботуВидовРабочихЦентров");
		Результат.Вставить("ВидыРабочихЦентров",                                    "ЭтапВидыРабочихЦентров");
		Результат.Вставить("Партнер",                                               "ЭтапПартнер");
		Результат.Вставить("ГрафикРаботыПартнера",                                  "ЭтапГрафикРаботыПартнера");
		Результат.Вставить("ПорядокРаботыВидовРабочихЦентров",                      "ЭтапПорядокРаботыВидовРабочихЦентров");
		Результат.Вставить("ЗаполнитьВидыРабочихЦентров",                           "ЭтапЗаполнитьВидыРабочихЦентров");
		Результат.Вставить("ВидыРабочихЦентровДобавитьАльтернативный",              "ЭтапВидыРабочихЦентровДобавитьАльтернативный");
		Результат.Вставить("ПредварительныйБуфер",                                  "ЭтапПредварительныйБуфер");
		Результат.Вставить("ЗавершающийБуфер",                                      "ЭтапЗавершающийБуфер");
		Результат.Вставить("ЕдиницаИзмеренияПредварительногоБуфера",                "ЭтапЕдиницаИзмеренияПредварительногоБуфера");
		Результат.Вставить("ЕдиницаИзмеренияЗавершающегоБуфера",                    "ЭтапЕдиницаИзмеренияЗавершающегоБуфера");
		Результат.Вставить("ДлительностьЭтапа",                                     "ЭтапДлительностьЭтапа");
		Результат.Вставить("ЕдиницаИзмеренияДлительностиЭтапа",                     "ЭтапЕдиницаИзмеренияДлительностиЭтапа");
		Результат.Вставить("ЕстьСинхроннаяЗагрузка",                                "ЭтапЕстьСинхроннаяЗагрузка");
		
	КонецЕсли;
		
	//++ НЕ УТКА
	
	Если ПрефиксЭлементов = "Операция" ИЛИ ПустаяСтрока(ПрефиксЭлементов) Тогда
		
		Результат.Вставить("ДоступностьЭлементов",                      "ОперацияДоступностьЭлементов");
		Результат.Вставить("ГруппаКоличество",                          "ОперацияГруппаКоличество");
		Результат.Вставить("ГруппаВыполнение",                          "ОперацияГруппаВыполнение");
		Результат.Вставить("ГруппаПередаточнаяПартия",                  "ОперацияГруппаПередаточнаяПартия");
		Результат.Вставить("СтраницаВспомогательныеРабочиеЦентры",      "ОперацияСтраницаВспомогательныеРабочиеЦентры");
		
		Результат.Вставить("ДопРеквизиты",                              "ОперацияДопРеквизиты");
		Результат.Вставить("ДопРеквизитыКоличество",                    "ОперацияДопРеквизитыКоличество");
		Результат.Вставить("ДопРеквизитыЗначениеМин",                   "ОперацияДопРеквизитыЗначениеМин");
		Результат.Вставить("ДопРеквизитыЗначениеМакс",                  "ОперацияДопРеквизитыЗначениеМакс");
		
		Результат.Вставить("ВремяРаботыПриСинхроннойЗагрузке",          "ОперацияВремяРаботыПриСинхроннойЗагрузке");
		Результат.Вставить("ЕдиницаИзмеренияПриСинхроннойЗагрузке",     "ОперацияЕдиницаИзмеренияПриСинхроннойЗагрузке");
		
		Результат.Вставить("РабочийЦентр",                              "ОперацияРабочийЦентр");
		Результат.Вставить("ВспомогательныеРабочиеЦентры",              "ОперацияВспомогательныеРабочиеЦентры");
		Результат.Вставить("ВспомогательныеРабочиеЦентрыРабочийЦентр",  "ОперацияВспомогательныеРабочиеЦентрыРабочийЦентр");
		
		Результат.Вставить("ВидОперации",                               "ОперацияВидОперации");
		Результат.Вставить("НомерОперации",                             "ОперацияНомерОперации");
		Результат.Вставить("НомерСледующейОперации",                    "ОперацияНомерСледующейОперации");
		Результат.Вставить("Количество",                                "ОперацияКоличество");
		Результат.Вставить("ЕдиницаИзмерения",                          "ОперацияЕдиницаИзмерения");
		Результат.Вставить("ВремяШтучное",                              "ОперацияВремяШтучное");
		Результат.Вставить("ВремяШтучноеЕдИзм",                         "ОперацияВремяШтучноеЕдИзм");
		Результат.Вставить("ВремяПЗ",                                   "ОперацияВремяПЗ");
		Результат.Вставить("ВремяПЗЕдИзм",                              "ОперацияВремяПЗЕдИзм");
		Результат.Вставить("Загрузка",                                  "ОперацияЗагрузка");
		Результат.Вставить("ЕдиницаИзмеренияЗагрузки",                  "ОперацияЕдиницаИзмеренияЗагрузки");
		
		Результат.Вставить("Непрерывная",                               "ОперацияНепрерывная");
		Результат.Вставить("МожноПовторить",                            "ОперацияМожноПовторить");
		Результат.Вставить("МожноПропустить",                           "ОперацияМожноПропустить");
		Результат.Вставить("ИспользуютсяВариантыНаладки",               "ОперацияИспользуютсяВариантыНаладки");
		Результат.Вставить("ВариантНаладки",                            "ОперацияВариантНаладки");
		Результат.Вставить("СинхроннаяЗагрузка",                        "ОперацияСинхроннаяЗагрузка");
		Результат.Вставить("ПараллельнаяЗагрузка",                      "ОперацияПараллельнаяЗагрузка");
		
	КонецЕсли;
	
	//-- НЕ УТКА
	
	Если ПустаяСтрока(ПрефиксЭлементов) Тогда
		Для каждого КлючИЗначение из Результат Цикл
			Результат[КлючИЗначение.Ключ] = КлючИЗначение.Ключ;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
