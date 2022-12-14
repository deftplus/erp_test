#Область ПрограммныйИнтерфейс

Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	СоздатьЭлементыФормыЭлемента(Форма);
	ВстраиваниеУХБанковскиеСчетаОрганизацийКлиентСервер.УправлениеЭлементамиФормыУХ(Форма);
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьЭлементыФормыЭлемента(Форма)
	
	Элементы = Форма.Элементы;
	
	// ПроизводственныйКалендарьУХ
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"ПроизводственныйКалендарьУХ",
		НСтр("ru = 'Производственный календарь'"),
		"Объект.ПроизводственныйКалендарь",
		ВидПоляФормы.ПолеВвода,
		Элементы.ГруппаИспользованиеЗаявок);
		
	// Страница "ВГО"
	СтруктураПараметров = Новый Структура("Группировка", ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	СтраницаВГО = ФормыУХ.СоздатьГруппуФормы(
		Элементы,
		"СтраницаВГОУХ",
		НСтр("ru = 'ВГО'"),
		ВидГруппыФормы.Страница,
		Элементы.ГруппаСтраницы,
		,
		СтруктураПараметров);
		
	// Запрет внутригрупповых переводов.
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"ЗапретВнутригрупповыхПереводов",
		НСтр("ru = 'Запрет внутригрупповых переводов'"),
		"Объект.ЗапретВнутригрупповыхПереводов",
		ВидПоляФормы.ПолеФлажка,
		СтраницаВГО);
		
	// Группа "Размещение свободных остатков"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Группировка", ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	СтруктураПараметров.Вставить("Отображение", ОтображениеОбычнойГруппы.СлабоеВыделение);
	
	ГруппаОстатки = ФормыУХ.СоздатьГруппуФормы(
		Элементы,
		"ГруппаОстатки",
		НСтр("ru = 'Размещение свободных остатков'"),
		ВидГруппыФормы.ОбычнаяГруппа,
		СтраницаВГО,
		,
		СтруктураПараметров);
		
	// Тумблер "Инструмент размещения"
	СтруктураПараметров = Новый Структура("ВидПереключателя", ВидПереключателя.Тумблер);
	Обработчики = Новый Структура("ПриИзменении", "Подключаемый_ИнструментРазмещенияСвободныхОстатковПриИзмененииУХ");
	ИнструментРазмещения = ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"ИнструментРазмещенияСвободныхОстатков",
		НСтр("ru = 'Инструмент размещения'"),
		"Объект.ИнструментРазмещенияСвободныхОстатков",
		ВидПоляФормы.ПолеПереключателя,
		ГруппаОстатки,
		,
		СтруктураПараметров,
		Обработчики);
		
	СписокВыбора = ИнструментРазмещения.СписокВыбора;
	СписокВыбора.Добавить(Перечисления.ИнструментыРазмещенияОстатков.НеИспользовать, НСтр("ru = 'Не использовать'"));
	СписокВыбора.Добавить(Перечисления.ИнструментыРазмещенияОстатков.КэшПулинг, НСтр("ru = 'Кэш-пулинг'"));
	СписокВыбора.Добавить(Перечисления.ИнструментыРазмещенияОстатков.Депозит, НСтр("ru = 'Депозит'"));
	
	// Группа "Основные параметры размещения"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Группировка", ГруппировкаПодчиненныхЭлементовФормы.Вертикальная);
	СтруктураПараметров.Вставить("Отображение", ОтображениеОбычнойГруппы.Нет);
	СтруктураПараметров.Вставить("ОтображатьЗаголовок", Ложь);
	
	ГруппаОсновныеПараметрыРазмещения = ФормыУХ.СоздатьГруппуФормы(
		Элементы,
		"ГруппаОсновныеПараметрыРазмещения",
		НСтр("ru = 'Основные параметры размещения'"),
		ВидГруппыФормы.ОбычнаяГруппа,
		ГруппаОстатки,
		,
		СтруктураПараметров);
		
	// Группа "Лимит остатка"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Группировка", ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
	СтруктураПараметров.Вставить("Отображение", ОтображениеОбычнойГруппы.Нет);
	СтруктураПараметров.Вставить("ОтображатьЗаголовок", Ложь);
	
	ГруппаЛимитОстатка = ФормыУХ.СоздатьГруппуФормы(
		Элементы,
		"ГруппаЛимитОстатка",
		НСтр("ru = 'Лимит остатка'"),
		ВидГруппыФормы.ОбычнаяГруппа,
		ГруппаОсновныеПараметрыРазмещения,
		,
		СтруктураПараметров);
		
	// Элемент "Максимальный лимит остатка"
	СтруктураПараметров = Новый Структура("ВысотаЗаголовка", 2);
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"ЛимитОстаткаМакс",
		НСтр("ru = 'Размещать сумму, превышающую'"),
		"Объект.ЛимитОстаткаМакс",
		ВидПоляФормы.ПолеВвода,
		ГруппаЛимитОстатка,
		,
		СтруктураПараметров);

	СтруктураПараметров = Новый Структура("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"НадписьВалютаМаксимальныйОстаток",
		НСтр("ru = 'Валюта счета'"),
		"Объект.ВалютаДенежныхСредств",
		ВидПоляФормы.ПолеНадписи,
		ГруппаЛимитОстатка,
		,
		СтруктураПараметров);
		
	// Декорация "Автоматическое размещение"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Право);
	СтруктураПараметров.Вставить("ОтображениеПодсказки", ОтображениеПодсказки.Кнопка);
	
	АвтоматическиПереводитьИзлишки = ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"АвтоматическиПереводитьИзлишки",
		НСтр("ru = 'Автоматическое размещение'"),
		"Объект.АвтоматическиПереводитьИзлишки",
		ВидПоляФормы.ПолеФлажка,
		ГруппаОсновныеПараметрыРазмещения,
		,
		СтруктураПараметров);
		
	АвтоматическиПереводитьИзлишки.РасширеннаяПодсказка.Заголовок = 
	НСтр("ru = 'Если флаг установлен, остатки денежных средств с данного счета, превышающие установленный лимит, 
	|будут автоматически переводиться на мастер-счет пула, либо на указанные счета.
	|В противном случае, для перевода средств следует использовать обработку ""Генерация заявок на размещение свободных остатков денежных средств""'");	
		
	// Поле "Пул ликвидности"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("КнопкаОчистки", Истина);
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"ПулЛиквидности",
		НСтр("ru = 'Входит в пул'"),
		"Объект.ПулЛиквидности",
		ВидПоляФормы.ПолеВвода,
		ГруппаОстатки,
		,
		СтруктураПараметров);
		
	// Табчасть "Управление свободными остатками"
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет);
	УправлениеСвободнымиОстатками = ФормыУХ.СоздатьТаблицуФормы(
		Элементы,
		"УправлениеСвободнымиОстатками",
		НСтр("ru = 'Получатели'"),
		"Объект.УправлениеСвободнымиОстатками",
		ГруппаОстатки,
		,
		СтруктураПараметров);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"УправлениеСвободнымиОстаткамиНомерСтроки",
		НСтр("ru = 'N'"),
		"Объект.УправлениеСвободнымиОстатками.НомерСтроки",
		,
		УправлениеСвободнымиОстатками);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"УправлениеСвободнымиОстаткамиКонтрагент",
		НСтр("ru = 'Контрагент'"),
		"Объект.УправлениеСвободнымиОстатками.Контрагент",
		,
		УправлениеСвободнымиОстатками);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"УправлениеСвободнымиОстаткамиДоговорКонтрагента",
		НСтр("ru = 'Договор'"),
		"Объект.УправлениеСвободнымиОстатками.ДоговорКонтрагента",
		,
		УправлениеСвободнымиОстатками);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"УправлениеСвободнымиОстаткамиСчетКонтрагента",
		НСтр("ru = 'Счет контрагента'"),
		"Объект.УправлениеСвободнымиОстатками.СчетКонтрагента",
		,
		УправлениеСвободнымиОстатками);
		
	ФормыУХ.СоздатьПолеФормы(
		Элементы,
		"УправлениеСвободнымиОстаткамиДоляПеречисления",
		НСтр("ru = 'Процент перечисления'"),
		"Объект.УправлениеСвободнымиОстатками.ДоляПеречисления",
		,
		УправлениеСвободнымиОстатками);
		
		
КонецПроцедуры

#КонецОбласти


