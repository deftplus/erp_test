
&НаКлиенте
Процедура Применить(Команда)
	
	Закрыть(СтрЗАменить(ПолеШаблонаТекст,Символ(10),""));
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		
	//СКДТекущегоПоля = ПолучитьОбщийМакет("МакетНастройкиОтборов");
	
	СКДТекущегоПоля = ПолучитьИзВременногоХранилища(Параметры.СКДТекущегоПоляАдрес);
	
	//НП =  СКДТекущегоПоля.НаборыДанных[0].Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
	//НП.Заголовок = Строка(АналитикаПоле);
	//НП.ПутьКДанным = Строка(АналитикаПоле);
	//НП.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
	//НП.Поле = Строка(АналитикаПоле);
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ПоместитьВоВременноеХранилище(СКДТекущегоПоля, УникальныйИдентификатор)));
	
	ПолеШаблонаТекст = Параметры.ТекущееПредставление;
	
	ПредставлениеАналитики = Строка(Параметры.АналитикаСубконто);
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядкаНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	ТекСтр = Элементы.КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядка.ТекущаяСтрока;
	Если НЕ ТекСтр = Неопределено Тогда
		СтрокаОтбора = КомпоновщикНастроек.Настройки.Порядок.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядка.ТекущаяСтрока);
		Если СтрокаОтбора.Папка Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ПараметрыПеретаскивания.Значение = ПолучитьИмяПоляВШаблоне(Строка(СтрокаОтбора.Заголовок),Строка(СтрокаОтбора.Поле));

КонецПроцедуры

&НаКлиенте
Функция ПолучитьИмяПоляВШаблоне(ИмяПоля,ПутьКПолю)
	
	ПозицияПервойТочкиВИмениПоля = СтрНайти(ИмяПоля,".");
	
	Если ПозицияПервойТочкиВИмениПоля = 0 Тогда
		//Не делаем ничего, нас устраивает синоним поля
	Иначе	
		ПозицияПервойТочкиВКодеПоля = СтрНайти(ПутьКПолю,".");
		ИмяПоля = Лев(ИмяПоля,ПозицияПервойТочкиВИмениПоля-1)+"."+Сред(ПутьКПолю,ПозицияПервойТочкиВКодеПоля+1);	
	КонецЕсли;	
	
	Возврат "["+ИмяПоля+"]";
	
КонецФункции

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекСтр = ВыбраннаяСтрока;
	Если НЕ ТекСтр = Неопределено Тогда
		СтрокаОтбора = КомпоновщикНастроек.Настройки.Порядок.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(Элементы.КомпоновщикНастроекНастройкиПорядокДоступныеПоляПорядка.ТекущаяСтрока);
		Если СтрокаОтбора.Папка Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	Иначе
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Значение = ПолучитьИмяПоляВШаблоне(Строка(СтрокаОтбора.Заголовок),Строка(СтрокаОтбора.Поле));

	ПолеШаблонаТекст  = ПолеШаблонаТекст+ Значение;
	
	// Вставить содержимое обработчика.
КонецПроцедуры



