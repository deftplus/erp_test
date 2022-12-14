// Загружает новый список пиктограмм в СписокНаимнованийПиктограмм.
&НаСервере
Процедура СформироватьНовыйСписокПиктограмм()
	СписокНаименованийПиктограмм.Очистить();
	СписокНаименованийПиктограмм.Добавить("БланкиОтчетов_32");
	СписокНаименованийПиктограмм.Добавить("Валюта_32");
	СписокНаименованийПиктограмм.Добавить("ВерсияПрофиля_32");
	СписокНаименованийПиктограмм.Добавить("ВидыОтчетов_32");
	СписокНаименованийПиктограмм.Добавить("ЗакрытиеМесяца32");
	СписокНаименованийПиктограмм.Добавить("ЗначокБанк32");
	СписокНаименованийПиктограмм.Добавить("ЗначокЗарплата32");
	СписокНаименованийПиктограмм.Добавить("ЗначокКадры32");
	СписокНаименованийПиктограмм.Добавить("ЗначокКасса32");
	СписокНаименованийПиктограмм.Добавить("ЗначокМониторБухгалтера32");
	СписокНаименованийПиктограмм.Добавить("ЗначокНастройкаПрограммы32");
	СписокНаименованийПиктограмм.Добавить("ЗначокНематериальныеАктивы32");
	СписокНаименованийПиктограмм.Добавить("ЗначокОсновныеСредства32");
	СписокНаименованийПиктограмм.Добавить("ЗначокПокупка32");
	СписокНаименованийПиктограмм.Добавить("ЗначокПредприятие32");
	СписокНаименованийПиктограмм.Добавить("ЗначокПродажа32");
	СписокНаименованийПиктограмм.Добавить("ЗначокСклад32");
	СписокНаименованийПиктограмм.Добавить("ЗначокСправочник32");
	СписокНаименованийПиктограмм.Добавить("ЗначокФизическиеЛица32");
	СписокНаименованийПиктограмм.Добавить("ЗначокФинансы32");
	СписокНаименованийПиктограмм.Добавить("Инвесторы_32");
	СписокНаименованийПиктограмм.Добавить("ИнформацияНовости32Анимированная");
	СписокНаименованийПиктограмм.Добавить("ОбменДанными32");
	СписокНаименованийПиктограмм.Добавить("ОбщаяКартинка54ФЗEmail_32");
	СписокНаименованийПиктограмм.Добавить("ОбщаяКартинка54ФЗSMS_32");
	СписокНаименованийПиктограмм.Добавить("ОнлайнСервисРО32");
	СписокНаименованийПиктограмм.Добавить("ПараметрОтчета_32");
	СписокНаименованийПиктограмм.Добавить("Период_32");
	СписокНаименованийПиктограмм.Добавить("ПоказательОтчета_32");
	СписокНаименованийПиктограмм.Добавить("ПометкаНовостиФлагЖелтый32");
	СписокНаименованийПиктограмм.Добавить("ПометкаНовостиФлагЗеленый32");
	СписокНаименованийПиктограмм.Добавить("ПометкаНовостиФлагКонтур32");
	СписокНаименованийПиктограмм.Добавить("ПометкаНовостиФлагКрасный32");
	СписокНаименованийПиктограмм.Добавить("ПометкаНовостиФлагСиний32");
	СписокНаименованийПиктограмм.Добавить("ПравилоПроверки_32");
	СписокНаименованийПиктограмм.Добавить("СоставПериметра_32");
	СписокНаименованийПиктограмм.Добавить("СоставПрофиля_32");
	СписокНаименованийПиктограмм.Добавить("Сценарий_32");
	СписокНаименованийПиктограмм.Добавить("УправлениеПериодомСценария_32");
	СписокНаименованийПиктограмм.Добавить("ЭтапыПроцессов_32");
КонецПроцедуры

// Добавляет на форму в группу ГруппаРодительВход элемент декорацию-картинку ПрефиксВход с
// префиксом и идентификатором ИдентификаторВход.
&НаСервере
Функция ДобавитьДекорациюКартинка(ПрефиксВход, ГруппаРодительВход, ИдентификаторВход, КартинкаВход)
	НаименованиеЭлемента = ПрефиксВход + Строка(ИдентификаторВход);
	НовыйЭлемент = Элементы.Вставить(НаименованиеЭлемента, Тип("ДекорацияФормы"), ГруппаРодительВход);
	НовыйЭлемент.Вид = ВидДекорацииФормы.Картинка;
	НовыйЭлемент.Картинка = КартинкаВход;
	Возврат НовыйЭлемент;
КонецФункции

// Добавляет группу элементов формы в родительскую группу ГруппаРодительВход с префиксом ПрефиксВход, 
// идентификатором ИдентификаторВход. ГруппировкаВход задаёт способ размещения (группировку) элементов.
&НаСервере
Функция ДобавитьГруппуЭлементов(ПрефиксВход, ГруппаРодительВход, ИдентификаторВход, ГруппировкаВход, ЗаголовокВход = "", ОтображатьЗаголовокВход = Ложь)
	НаименованиеНовогоРеквизита = ПрефиксВход + Строка(ИдентификаторВход);
	НовыйЭлемент									 = Элементы.Вставить(НаименованиеНовогоРеквизита, Тип("ГруппаФормы"), ГруппаРодительВход);
	НовыйЭлемент.Вид								 = ВидГруппыФормы.ОбычнаяГруппа;
	НовыйЭлемент.ОтображатьЗаголовок				 = ОтображатьЗаголовокВход;
	НовыйЭлемент.Заголовок							 = ЗаголовокВход;
	НовыйЭлемент.ГоризонтальноеПоложениеПодчиненных	 = ГоризонтальноеПоложениеЭлемента.Центр;
	НовыйЭлемент.Объединенная						 = Истина;
	НовыйЭлемент.Отображение						 = ОтображениеОбычнойГруппы.Нет;
	НовыйЭлемент.Группировка						 = ГруппировкаВход;
	Возврат НовыйЭлемент;
КонецФункции

// Возвращает элемент на форме, наименование которого получается из префикса ПрефиксВход
// и идентификатора ИдентификаторПоказателяВход.
&НаСервере
Функция НайтиЭлементНаФорме(ПрефиксВход, ИдентификаторВход)
	НаименованиеЭлемента = ПрефиксВход + Строка(ИдентификаторВход);
	Если Элементы.Найти(НаименованиеЭлемента) <> Неопределено Тогда
		РезультатФункции = Элементы[НаименованиеЭлемента];
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось найти элемент %НаименованиеЭлемента%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НаименованиеЭлемента%", Строка(НаименованиеЭлемента));
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		РезультатФункции = Неопределено;
	КонецЕсли;
	Возврат РезультатФункции;
КонецФункции

// Выделяет/сбрасывает выделение выбранные картинки на форме.
&НаСервере
Процедура ОбновитьВыбранныеПиктограммы()
	Для Каждого ТекСписокНаименованийПиктограмм Из СписокНаименованийПиктограмм Цикл
		ТекНаименованиеПиктограммы = ТекСписокНаименованийПиктограмм.Значение;
		ДекорацияПиктограмма = НайтиЭлементНаФорме(ПрефиксДекорацияПиктограмм, ТекНаименованиеПиктограммы); 
		Если ДекорацияПиктограмма <> Неопределено Тогда
			Если СокрЛП(ТекНаименованиеПиктограммы) = СокрЛП(ВыбраннаяПиктограмма) Тогда
				ДекорацияПиктограмма.ЦветРамки = WebЦвета.Золотой;
				ДекорацияПиктограмма.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
			Иначе
				ДекорацияПиктограмма.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки, 1);
			КонецЕсли;
		Иначе
			// Декорация не определена. Не изменяем её рамку.
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// Возвращает сущесмтвование общей картинки с именем ИмяКартинкиВход.
&НаСервереБезКонтекста
Функция ЕстьОбщаяКартинка(ИмяКартинкиВход)
	НайденнаяКартинка = Метаданные.ОбщиеКартинки.Найти(ИмяКартинкиВход);
	РезультатФункции = (НайденнаяКартинка <> Неопределено);
	Возврат РезультатФункции;
КонецФункции

// Возвращает копию списка СписокВход, из которого удалены неактуальные 
// наименования пиктограмм.
&НаСервереБезКонтекста
Функция ОчиститьНесуществующиеПиктограммы(СписокВход)
	РезультатФункции = Новый СписокЗначений;
	Для Каждого ТекСписокВход Из СписокВход Цикл
		ТекНаименованиеПиктограммы = ТекСписокВход.Значение;
		Если ЕстьОбщаяКартинка(ТекНаименованиеПиктограммы) Тогда
			РезультатФункции.Добавить(ТекСписокВход.Значение);
		Иначе
			Продолжить;			// Не найдено. Не добавляем в список.
		КонецЕсли;
	КонецЦикла;
	Возврат РезультатФункции;
КонецФункции

// Выводит картинки списка пиктограмм.
&НаСервере
Процедура ОтобразитьСписокПиктограмм()
	КоличествоСтолбцов = 10;
	ПрефиксДекорацияПиктограмм = "КартинкаПиктограмма_";
	ПрефиксГруппаПиктограмм = "КартинкаПиктограмма_";
	ГруппаГалереяПиктограмм = Элементы.ГруппаГалерея;
	Счетчик = 0;
	ТекГруппа = ГруппаГалереяПиктограмм;
	Для Каждого ТекСписокНаименованийПиктограмм Из СписокНаименованийПиктограмм Цикл
		// Создание группы строк.
		Если (Счетчик % КоличествоСтолбцов) = 0 Тогда
			ТекГруппа = ДобавитьГруппуЭлементов(ПрефиксГруппаПиктограмм, ГруппаГалереяПиктограмм, Строка(Счетчик), ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная);
		Иначе
			// Оставляем предыдущую группу.
		КонецЕсли;
		// Вывод картинки.
		ТекНаименованиеПиктограммы = ТекСписокНаименованийПиктограмм.Значение;
		Если ЕстьОбщаяКартинка(ТекНаименованиеПиктограммы) Тогда
			ТекКартинка = БиблиотекаКартинок[ТекНаименованиеПиктограммы];
			ДекорацияПиктограмма = ДобавитьДекорациюКартинка(ПрефиксДекорацияПиктограмм, ТекГруппа, ТекНаименованиеПиктограммы, ТекКартинка); 
			ДекорацияПиктограмма.Гиперссылка = Истина;
			ДекорацияПиктограмма.УстановитьДействие("Нажатие", "ДекорацияНажатие_Подключаемый");
		Иначе
			// Пропускаем.
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ОбновитьВыбранныеПиктограммы();
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНажатие_Подключаемый(Элемент)
	ИмяВыбранногоЭлемента = Элемент.Имя;
	Если ЗначениеЗаполнено(ИмяВыбранногоЭлемента) Тогда
		ДлинаПрефикса = СтрДлина(ПрефиксДекорацияПиктограмм);
		ДлинаИмениЭлемента = СтрДлина(ИмяВыбранногоЭлемента);
		ВыбраннаяПиктограмма = Сред(ИмяВыбранногоЭлемента, ДлинаПрефикса + 1, ДлинаИмениЭлемента - ДлинаПрефикса);
	Иначе
		// Неизвестный эемент. Ничего не делаем.
	КонецЕсли;
	ОбновитьВыбранныеПиктограммы();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СформироватьНовыйСписокПиктограмм();
	СписокНаименованийПиктограмм = ОчиститьНесуществующиеПиктограммы(СписокНаименованийПиктограмм);
	ОтобразитьСписокПиктограмм();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПиктограмму(Команда)
	Если ЗначениеЗаполнено(ВыбраннаяПиктограмма) Тогда
		Если ЕстьОбщаяКартинка(ВыбраннаяПиктограмма) Тогда
			Если ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("УправляемаяФорма") Тогда
				ИдентификаторВладельца = ЭтаФорма.ВладелецФормы.УникальныйИдентификатор;
			Иначе
				ИдентификаторВладельца = УникальныйИдентификатор;
			КонецЕсли;
			АдресХранилища = ПоместитьВоВременноеХранилище(БиблиотекаКартинок[ВыбраннаяПиктограмма], ИдентификаторВладельца);
			ОповеститьОВыборе(АдресХранилища);
		Иначе
			ТекстСообщения = НСтр("ru = 'Не удалось получить пиктограмму. Действие отменено.'");
			ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'Пиктограмма не выбрана. Действие отменено.'");
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры
