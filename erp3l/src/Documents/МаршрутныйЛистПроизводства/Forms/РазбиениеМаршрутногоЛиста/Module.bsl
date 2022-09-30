//++ Устарело_Производство21
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	МаршрутныйЛист = Параметры.МаршрутныйЛист;
	ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий = Макс(Параметры.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий, 1);
	ИсходноеКоличество = Параметры.Количество;
	
	Если Параметры.Свойство("ВыбранныйВидРабочегоЦентра") Тогда
		ВыбранныйВидРабочегоЦентра = Параметры.ВыбранныйВидРабочегоЦентра;
		ИнтервалПланированияНачало = Параметры.ИнтервалПланированияНачало;
		ЕдиницаИзмеренияЗагрузки = Параметры.ЕдиницаИзмеренияЗагрузки;
		ПараллельнаяЗагрузка = Параметры.ПараллельнаяЗагрузка;
		ЗагрузкаНорматив = Параметры.ЗагрузкаНорматив;
	КонецЕсли; 
	
	Если НЕ ПараллельнаяЗагрузка Тогда
		Элементы.ГруппаЗагрузка.Видимость = Ложь;
	КонецЕсли;
	
	Количество = Мин(ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий, ИсходноеКоличество - 1);
	Элементы.Количество.МаксимальноеЗначение = ИсходноеКоличество - 1;
	
	КоличествоТекущий = ИсходноеКоличество - Количество;
	Элементы.КоличествоТекущий.МаксимальноеЗначение = ИсходноеКоличество - 1;
	
	Если Параметры.Свойство("ВремяРаботы") Тогда
		
		ОтображатьОбъемРабот = Истина;
		
		ВремяРаботы = Параметры.ВремяРаботы;
		
		СвободноПревышено = Параметры.СвободноПревышено;
		Если Параметры.ПревышенаДоступность Тогда
			Элементы.СвободноПревышено.Заголовок = НСтр("ru = 'Время рабочего центра (превышено)';
														|en = 'Work center operation time (exceeded)'");
			Элементы.СвободноПревышено.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
		КонецЕсли;
		
		РассчитатьИтоги(ЭтаФорма);
		
	Иначе
		
		Элементы.ОбъемРабот.Видимость = Ложь;
		Элементы.ОбъемРаботЕдИзм.Видимость = Ложь;
		Элементы.ОбъемРаботТекущий.Видимость = Ложь;
		Элементы.ОбъемРаботТекущийЕдИзм.Видимость = Ложь;
		
		Элементы.Загрузка.Видимость = Ложь;
		Элементы.ЗагрузкаЕдиницаИзмерения.Видимость = Ложь;
		Элементы.ЗагрузкаТекущий.Видимость = Ложь;
		Элементы.ЗагрузкаТекущийЕдиницаИзмерения.Видимость = Ложь;
		
		Элементы.СвободноПревышено.Видимость = Ложь;
		Элементы.СвободноПревышеноЕдИзм.Видимость = Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоТекущийПриИзменении(Элемент)
	
	Количество = ИсходноеКоличество - КоличествоТекущий;
	РассчитатьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоПриИзменении(Элемент)
	
	КоличествоТекущий = ИсходноеКоличество - Количество;
	РассчитатьИтоги(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	РегулированиеКоличества(Количество, КоличествоТекущий, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоТекущийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	РегулированиеКоличества(КоличествоТекущий, Количество, Направление, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ДанныеПолученныхМЛ = РазбитьМаршрутныйЛист();
	Если ДанныеПолученныхМЛ <> Неопределено Тогда
		Закрыть(ДанныеПолученныхМЛ);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция РазбитьМаршрутныйЛист()
	
	НачатьТранзакцию();
	Попытка
	
		ТекущийМаршрутныйЛист = МаршрутныйЛист.ПолучитьОбъект();
		НовыйМаршрутныйЛист   = МаршрутныйЛист.Скопировать();
		
		УстановитьНовоеЗначениеЗапланировано(ТекущийМаршрутныйЛист, ТекущийМаршрутныйЛист.Запланировано - Количество);
		
		Если ТекущийМаршрутныйЛист.СостояниеРасписания = Перечисления.СостоянияРасписанияРабочихЦентров.Сформировано Тогда
			ТекущийМаршрутныйЛист.СостояниеРасписания = Перечисления.СостоянияРасписанияРабочихЦентров.НеАктуально;
		КонецЕсли;
		
		ТекущийМаршрутныйЛист.Записать(РежимЗаписиДокумента.Проведение);
		
		УстановитьНовоеЗначениеЗапланировано(НовыйМаршрутныйЛист, Количество);
		НовыйМаршрутныйЛист.Дата = ТекущаяДатаСеанса();
		НовыйМаршрутныйЛист.Записать(РежимЗаписиДокумента.Проведение);
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		ОтменитьТранзакцию();
		ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецПопытки; 
		
	ДанныеПолученныхМЛ = Новый Соответствие;
	
	// Старый МЛ
	ДанныеМаршрутныйЛист = Новый Структура;
	ДанныеМаршрутныйЛист.Вставить("Количество", ТекущийМаршрутныйЛист.Запланировано);
	
	Если НЕ ВыбранныйВидРабочегоЦентра.Пустая() Тогда
		// Нужно подготовить данные полученных МЛ, чтобы больше не вызывать сервер для их получения.
		ВремяРаботыВидаРЦ = 0;
		ЗагрузкаВидаРЦ = 0;
		ВариантНаладкиПредставление = "";
		Для каждого ДанныеСтроки Из ТекущийМаршрутныйЛист.ЗанятостьВидовРабочихЦентровПоГрафику Цикл
			Если ДанныеСтроки.ДатаИнтервала <= ИнтервалПланированияНачало
				И ДанныеСтроки.ВидРабочегоЦентра = ВыбранныйВидРабочегоЦентра Тогда
				ВремяРаботыВидаРЦ = ВремяРаботыВидаРЦ + ДанныеСтроки.ВремяРаботы;
				ЗагрузкаВидаРЦ = ЗагрузкаВидаРЦ + ДанныеСтроки.Загрузка;
				ВариантНаладкиПредставление = Строка(ДанныеСтроки.ВариантНаладки);
			КонецЕсли;
		КонецЦикла; 
		ДанныеМаршрутныйЛист.Вставить("ВремяРаботы", ВремяРаботыВидаРЦ);
		ДанныеМаршрутныйЛист.Вставить("Загрузка", ЗагрузкаВидаРЦ);
		ДанныеМаршрутныйЛист.Вставить("ВариантНаладкиПредставление", ВариантНаладкиПредставление);
	КонецЕсли; 
	
	ДанныеПолученныхМЛ.Вставить(ТекущийМаршрутныйЛист.Ссылка, ДанныеМаршрутныйЛист);
	
	// Новый МЛ
	ДанныеМаршрутныйЛист = Новый Структура;
	ДанныеМаршрутныйЛист.Вставить("Этап",               НовыйМаршрутныйЛист.Этап);
	ДанныеМаршрутныйЛист.Вставить("Спецификация",       НовыйМаршрутныйЛист.Спецификация);
	ДанныеМаршрутныйЛист.Вставить("Количество",         НовыйМаршрутныйЛист.Запланировано);
	ДанныеМаршрутныйЛист.Вставить("Номенклатура",       НовыйМаршрутныйЛист.Номенклатура);
	ДанныеМаршрутныйЛист.Вставить("Характеристика",     НовыйМаршрутныйЛист.Характеристика);
	ДанныеМаршрутныйЛист.Вставить("Непрерывный",        НовыйМаршрутныйЛист.Непрерывный);
	ДанныеМаршрутныйЛист.Вставить("Статус",             НовыйМаршрутныйЛист.Статус);
	ДанныеМаршрутныйЛист.Вставить("ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий", НовыйМаршрутныйЛист.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий);
	
	НомерНаПечать = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(НовыйМаршрутныйЛист.Номер, Ложь, Истина);
	МаршрутныйЛистСтрока = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
												НСтр("ru = '№%1 от %2';
													|en = 'No. %1 from %2'"),
												НомерНаПечать,
												Формат(НовыйМаршрутныйЛист.Дата, "ДЛФ=D"));
	ДанныеМаршрутныйЛист.Вставить("МаршрутныйЛистСтрока", МаршрутныйЛистСтрока);
	
	
	Если НЕ ВыбранныйВидРабочегоЦентра.Пустая() Тогда
		// Нужно подготовить данные полученных МЛ, чтобы больше не вызывать сервер для их получения.
		НоменклатураХарактеристика = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
															Строка(НовыйМаршрутныйЛист.Номенклатура),
															Строка(НовыйМаршрутныйЛист.Характеристика));
		ДанныеМаршрутныйЛист.Вставить("НоменклатураХарактеристика", НоменклатураХарактеристика);
		
		МногоэтапныйПроизводственныйПроцесс = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НовыйМаршрутныйЛист.Спецификация, "МногоэтапныйПроизводственныйПроцесс");
		ЭтапСпецификация = УправлениеДаннымиОбИзделияхКлиентСервер.ПредставлениеЭтапа(
												Строка(НовыйМаршрутныйЛист.Спецификация),
												Строка(НовыйМаршрутныйЛист.Этап),
												МногоэтапныйПроизводственныйПроцесс,
												НовыйМаршрутныйЛист.ЭтапВосстановленияБрака);
		ДанныеМаршрутныйЛист.Вставить("ЭтапСпецификация", ЭтапСпецификация);
		
		ВремяРаботыВидаРЦ = 0;
		ЗагрузкаВидаРЦ = 0;
		ВариантНаладкиВидаРЦ = "";
		ВариантНаладкиПредставление = "";
		Для каждого ДанныеСтроки Из НовыйМаршрутныйЛист.ЗанятостьВидовРабочихЦентровПоГрафику Цикл
			Если ДанныеСтроки.ДатаИнтервала <= ИнтервалПланированияНачало
				И ДанныеСтроки.ВидРабочегоЦентра = ВыбранныйВидРабочегоЦентра Тогда
				ВремяРаботыВидаРЦ = ВремяРаботыВидаРЦ + ДанныеСтроки.ВремяРаботы;
				ЗагрузкаВидаРЦ = ЗагрузкаВидаРЦ + ДанныеСтроки.Загрузка;
				ВариантНаладкиВидаРЦ = ДанныеСтроки.ВариантНаладки;
				ВариантНаладкиПредставление = Строка(ДанныеСтроки.ВариантНаладки);
			КонецЕсли;
		КонецЦикла; 
		ДанныеМаршрутныйЛист.Вставить("ВремяРаботы", ВремяРаботыВидаРЦ);
		ДанныеМаршрутныйЛист.Вставить("Загрузка", ЗагрузкаВидаРЦ);
		ДанныеМаршрутныйЛист.Вставить("ВариантНаладки", ВариантНаладкиВидаРЦ);
		ДанныеМаршрутныйЛист.Вставить("ВариантНаладкиПредставление", ВариантНаладкиПредставление);
	КонецЕсли; 
	
	ДанныеПолученныхМЛ.Вставить(НовыйМаршрутныйЛист.Ссылка, ДанныеМаршрутныйЛист);
		
	Возврат ДанныеПолученныхМЛ;
	
КонецФункции
 
&НаСервере
Процедура УстановитьНовоеЗначениеЗапланировано(МаршрутныйЛистОбъект, НовоеЗначениеЗапланировано)

	Коэффициент = НовоеЗначениеЗапланировано / МаршрутныйЛистОбъект.Запланировано;
	
	МаршрутныйЛистОбъект.Запланировано = НовоеЗначениеЗапланировано;
	
	Для каждого СтрокаОперация Из МаршрутныйЛистОбъект.Операции Цикл
		СтрокаОперация.ВремяВыполнения = СтрокаОперация.ВремяВыполнения * Коэффициент;
	КонецЦикла; 
	
	ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВыходныеИзделия,  Коэффициент, Истина);
	ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВозвратныеОтходы, Коэффициент, Истина);
	ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.МатериалыИУслуги, Коэффициент, Истина);
	ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.Трудозатраты,     Коэффициент, Ложь);
	
	Если МаршрутныйЛистОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Создан Тогда
		
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВыходныеИзделия,  0, Истина, "Факт", "");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВозвратныеОтходы, 0, Истина, "Факт", "");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.МатериалыИУслуги, 1, Истина, "Факт", "");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.Трудозатраты,     1, Ложь,   "Факт", "");
		
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.ВыходныеИзделия,  Истина);
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.ВозвратныеОтходы, Истина);
		
	Иначе
		
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВыходныеИзделия,  Коэффициент, Истина, "Факт", "Факт");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.ВозвратныеОтходы, Коэффициент, Истина, "Факт", "Факт");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.МатериалыИУслуги, Коэффициент, Истина, "Факт", "Факт");
		ОперативныйУчетПроизводства.ПересчитатьКоличествоТабличнойЧасти(МаршрутныйЛистОбъект.Трудозатраты,     Коэффициент, Ложь,   "Факт", "Факт");
		
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.ВыходныеИзделия,  Истина);
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.ВозвратныеОтходы, Истина);
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.МатериалыИУслуги, Истина);
		ПересчитатьОтклонениеОтНорматива(МаршрутныйЛистОбъект.Трудозатраты,     Ложь);
		
	КонецЕсли; 
	
	МаршрутныйЛистОбъект.ЗаполнитьЗанятостьВидовРЦПоЗаказу();
	МаршрутныйЛистОбъект.ЗаполнитьДанныеРаспоряжения();
	ОперативныйУчетПроизводстваКлиентСервер.ЗаполнитьДанныеРаспоряженияМаршрутногоЛиста(МаршрутныйЛистОбъект);

КонецПроцедуры

&НаСервере
Процедура ПересчитатьОтклонениеОтНорматива(СписокСтрок, ЕстьУпаковки)

	Для каждого СтрокаТабличнойЧасти Из СписокСтрок Цикл
		
		СтрокаТабличнойЧасти.КоличествоОтклонение = СтрокаТабличнойЧасти.КоличествоФакт 
														- СтрокаТабличнойЧасти.Количество;
		Если ЕстьУпаковки Тогда
			СтрокаТабличнойЧасти.КоличествоУпаковокОтклонение = СтрокаТабличнойЧасти.КоличествоУпаковокФакт 
																- СтрокаТабличнойЧасти.КоличествоУпаковок;
																
		КонецЕсли; 													
			
	КонецЦикла; 

КонецПроцедуры

&НаКлиенте
Процедура РегулированиеКоличества(ИзменяемоеКоличество, ЗависимоеКоличество, Направление, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ИзменяемоеКоличество = ОперативныйУчетПроизводстваКлиент.РегулированиеКоличества(
								ИзменяемоеКоличество,
								ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий,
								Направление,
								1,
								ИсходноеКоличество - 1);
								
	ЗависимоеКоличество = ИсходноеКоличество - ИзменяемоеКоличество;
	
	РассчитатьИтоги(ЭтаФорма);
	
КонецПроцедуры
 
&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтоги(Форма)

	Если Форма.ОтображатьОбъемРабот Тогда
		Если Форма.ПараллельнаяЗагрузка Тогда
			Форма.ОбъемРабот        = Форма.ВремяРаботы / 3600;
																	
			Форма.ОбъемРаботТекущий = Форма.ВремяРаботы / 3600;
		Иначе
			Форма.ОбъемРабот        = ОперативныйУчетПроизводстваКлиентСервер.ОбъемРабот(
																	Форма.ВремяРаботы, 
																	Форма.Количество, 
																	Форма.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий) / 3600;
																	
			Форма.ОбъемРаботТекущий = ОперативныйУчетПроизводстваКлиентСервер.ОбъемРабот(
																	Форма.ВремяРаботы, 
																	Форма.КоличествоТекущий, 
																	Форма.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий) / 3600;
		КонецЕсли; 
	КонецЕсли; 

	Если Форма.ПараллельнаяЗагрузка Тогда
		Форма.Загрузка        = ОперативныйУчетПроизводстваКлиентСервер.Загрузка(
																Форма.ЗагрузкаНорматив, 
																Форма.Количество, 
																Форма.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий);
																
		Форма.ЗагрузкаТекущий = ОперативныйУчетПроизводстваКлиентСервер.Загрузка(
																Форма.ЗагрузкаНорматив, 
																Форма.КоличествоТекущий, 
																Форма.ОдновременноПроизводимоеКоличествоЕдиницПартийИзделий);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
//-- Устарело_Производство21