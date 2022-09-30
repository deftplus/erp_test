&НаКлиенте
Процедура ПродолжитьВыгрузку(Команда)
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить("СдачаОтчетностиВМинобороны","ПутьВыгрузки",ПутьВыгрузки);
	
	МодульДокументооборотСМинобороныВызовСервера = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныВызовСервера");
	
	Настройки = МодульДокументооборотСМинобороныВызовСервера.ПолучитьНастройки(Организация);
	
	// обновляем настройки обмена с минобороны
	Если СертификатДляПодписания <> "" Тогда
		
		МодульДокументооборотСМинобороныВызовСервера.СохранитьНастройки(Организация, СертификатДляПодписания);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			НСтр("ru = 'Сертификат криптографии не выбран, его необходимо указать для продолжения выгрузки.';
				|en = 'Cryptographic certificate is not selected, you must specify it to continue export.'"),
			,"СертификатАбонентаПредставление");
		Возврат;
	КонецЕсли; 
	
	Результат = Новый Структура("Пароль,
								|КаталогВыгрузки",
								Пароль,
								ПутьВыгрузки);
	Закрыть(Результат);
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Организация				= Параметры.Организация;
	МодульДокументооборотСМинобороныВызовСервера = ОбщегоНазначения.ОбщийМодуль("ДокументооборотСМинобороныВызовСервера");
	Настройки				= МодульДокументооборотСМинобороныВызовСервера.ПолучитьНастройки(Организация);
	СертификатДляПодписания = Настройки.СертификатАбонентаОтпечаток;
	
	ПутьВыгрузки			= ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить("СдачаОтчетностиВМинобороны","ПутьВыгрузки");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
	ПараметрыОтображенияСертификатов = Новый Массив;
	
	ПараметрыОтображенияСертификата = Новый Структура;
	ПараметрыОтображенияСертификата.Вставить("ПолеВвода", 								Элементы.СертификатАбонентаПредставление);
	ПараметрыОтображенияСертификата.Вставить("Сертификат", 								СертификатДляПодписания);
	ПараметрыОтображенияСертификата.Вставить("ИмяРеквизитаПредставлениеСертификата", 	"СертификатАбонентаПредставление");
	
	ПараметрыОтображенияСертификатов.Добавить(ПараметрыОтображенияСертификата);
	
	МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
	МодульДокументооборотСМинобороныКлиент.ОтобразитьПредставленияСертификатов(ПараметрыОтображенияСертификатов, ЭтотОбъект, Ложь);
	
	Оповещение = Новый ОписаниеОповещения("ПриОткрытииПослеПодбораСертификатаЗавершение", ЭтотОбъект, );
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДО = Результат.КонтекстЭДО;
	
	Оповещение = Новый ОписаниеОповещения("ПриОткрытииПослеПодбораСертификатаЗавершение", ЭтотОбъект, );
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("Сертификат", СертификатДляПодписания);
	ПараметрыПодбора.Вставить("КонтекстЭДО", КонтекстЭДО);
	ПараметрыПодбора.Вставить("Организация", Организация);
	МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
	МодульДокументооборотСМинобороныКлиент.ПодобратьСертификатДляАбонента(Оповещение, ПараметрыПодбора);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытииПослеПодбораСертификатаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Выполнено И СертификатДляПодписания <> Результат.ОтпечатокСертификата Тогда
		СертификатДляПодписания = Результат.ОтпечатокСертификата;
		МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
		МодульДокументооборотСМинобороныКлиент.ОтобразитьПредставлениеСертификата(
			Элементы.СертификатАбонентаПредставление,
			СертификатДляПодписания,
			ЭтотОбъект, 
			"СертификатАбонентаПредставление");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения(
		"СертификатАбонентаПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = Ложь;
	МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
	МодульДокументооборотСМинобороныКлиент.ВыбратьСертификат(
		Оповещение, СертификатДляПодписания);
		

КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = Ложь;
	Если Результат.Выполнено Тогда
		СертификатДляПодписания = Результат.ВыбранноеЗначение.Отпечаток;
		
		МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
		МодульДокументооборотСМинобороныКлиент.ОтобразитьПредставлениеСертификата(
			Элемент,
			Результат.ВыбранноеЗначение.Отпечаток,
			ЭтотОбъект,
			"СертификатАбонентаПредставление");
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ЭтоЭлектроннаяПодписьВМоделиСервиса = Ложь;
	МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
	МодульДокументооборотСМинобороныКлиент.ПоказатьСертификат(
		Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
		СертификатДляПодписания, ЭтоЭлектроннаяПодписьВМоделиСервиса));

КонецПроцедуры

&НаКлиенте
Процедура ПутьВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("БылаПопыткаУстановкиРасширения", Ложь);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодключенияРасширенияРаботаСФайлами",
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияРасширенияРаботаСФайлами(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеПодключенияРасширения",
			ЭтотОбъект,
			ДополнительныеПараметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Истина);
	Иначе
		Если ДополнительныеПараметры.БылаПопыткаУстановкиРасширения Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Расширение работы с файлами не подключено.';
										|en = 'File system extension is not attached.'"));
			Возврат;
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеУстановкиРасширенияДляРаботыСФайлами",
			ЭтотОбъект,
			ДополнительныеПараметры);
		НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры
 
&НаКлиенте
Процедура ПослеУстановкиРасширенияДляРаботыСФайлами(ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.БылаПопыткаУстановкиРасширения = Истина;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодключенияРасширенияРаботаСФайлами",
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	НачатьПодключениеРасширенияРаботыСФайлами(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияРасширения(Результат, ДополнительныеПараметры) Экспорт
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = НСтр("ru = 'Укажите каталог для сохранения пакета';
							|en = 'Specify a directory to save the package'");
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.Каталог = ПутьВыгрузки;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПутьВыгрузкиПослеВыбораКаталога",
		ЭтотОбъект); 

	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьВыгрузкиПослеВыбораКаталога(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьВыгрузки = ВыбранныеФайлы[0];
	ПутьВыгрузки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СертификатДляПодписания = "";
	МодульДокументооборотСМинобороныКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ДокументооборотСМинобороныКлиент");
	МодульДокументооборотСМинобороныКлиент.ОтобразитьПредставлениеСертификата(
		Элемент,
		СертификатДляПодписания,
		ЭтотОбъект,
		"СертификатАбонентаПредставление");
	
	Модифицированность = Истина;

КонецПроцедуры
 
#КонецОбласти
