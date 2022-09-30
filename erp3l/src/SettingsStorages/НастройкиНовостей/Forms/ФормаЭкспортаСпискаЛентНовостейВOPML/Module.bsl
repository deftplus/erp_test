///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если (ВРег(ЭтотОбъект.ФорматНовостей) <> ВРег("rss"))
			И (ВРег(ЭтотОбъект.ФорматНовостей) <> ВРег("atom")) Тогда
		ЭтотОбъект.ФорматНовостей = "rss";
	КонецЕсли;

	ЭтотОбъект.ЛентыНовостей.Очистить();
	Если Параметры.ЛентыНовостей.Количество() > 0 Тогда
		Для каждого ТекущаяЛентаНовостей Из Параметры.ЛентыНовостей Цикл
			// Загрузить только ленты новостей с протоколом http или https.
			Если ВРег(ТекущаяЛентаНовостей.Значение.Протокол) = ВРег("http")
					ИЛИ ВРег(ТекущаяЛентаНовостей.Значение.Протокол) = ВРег("https") Тогда
				ЭтотОбъект.ЛентыНовостей.Добавить(ТекущаяЛентаНовостей.Значение, , ТекущаяЛентаНовостей.Пометка);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если ЭтотОбъект.ЛентыНовостей.Количество() = 0 Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Файл xml';
					|en = 'XML file'")
		+ "(*.xml)|*.xml";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Укажите файл, в который надо экспортировать список лент новостей';
										|en = 'Specify a file to which to export the news feed list'");

	ДополнительныеПараметры = Новый Структура;
	ОписаниеОповещенияПослеВыбора = Новый ОписаниеОповещения("ПослеВыбораИмениФайла", ЭтотОбъект, ДополнительныеПараметры);

	ДиалогОткрытияФайла.Показать(ОписаниеОповещенияПослеВыбора); // АПК:1348 Форма не работает в веб-клиенте.

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЭкспорт(Команда)

	БылиОшибки = Ложь;

	Если (ВРег(ЭтотОбъект.ФорматНовостей) <> ВРег("rss"))
			И (ВРег(ЭтотОбъект.ФорматНовостей) <> ВРег("atom")) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Выберите правильный формат новостей';
								|en = 'Select valid news format'");
		Сообщение.УстановитьДанные("Формат");
		Сообщение.Сообщить();
		БылиОшибки = Истина;
	КонецЕсли;

	Если ПустаяСтрока(ЭтотОбъект.ИмяФайла) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Укажите имя файла, куда сохранить список новостей';
								|en = 'Specify a file name to save the news list to'");
		Сообщение.УстановитьДанные("ИмяФайла");
		Сообщение.Сообщить();
		БылиОшибки = Истина;
	КонецЕсли;

	Если БылиОшибки = Ложь Тогда
		КомандаЗаписатьНаСервере();
	КонецЕсли;

	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Экспорт завершен';
			|en = 'Export completed'"),
		ОбработкаНовостейКлиент.ПолучитьДействиеОткрытияФайла(ИмяФайла, "КакТекстВ1С"),
		НСтр("ru = 'Список лент новостей успешно экспортирован в файл.
			|Теперь в стороннем rss-агрегаторе можно выбрать из меню [Импортировать список лент новостей из OPML файла] и указать полученный файл (при условии, что rss-агрегатор поддерживает эту возможность).';
			|en = 'News feed list is successfully exported to the file.
			|Now you can select from the [Import news feed list from OPML file] menu and specify the received file (if rss-aggregator supports this capability) in a third-party rss-aggregator.'"),
		БиблиотекаКартинок.Записать);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КомандаЗаписатьНаСервере()

	ЗаписьХМЛ = Новый ЗаписьXML;
	ЗаписьХМЛ.ОткрытьФайл(ЭтотОбъект.ИмяФайла, "UTF-8");
	ЗаписьХМЛ.ЗаписатьОбъявлениеXML();
	ЗаписьХМЛ.ЗаписатьНачалоЭлемента("opml");
	ЗаписьХМЛ.ЗаписатьАтрибут("version", "1.1");
		ЗаписьХМЛ.ЗаписатьНачалоЭлемента("head");
			ЗаписьХМЛ.ЗаписатьНачалоЭлемента("title");
				ЗаписьХМЛ.ЗаписатьТекст(НСтр("ru = 'Список лент новостей (1С)';
											|en = 'News feed list (1C)'"));
			ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // title
			ЗаписьХМЛ.ЗаписатьНачалоЭлемента("dateCreated");
				ЗаписьХМЛ.ЗаписатьТекст(ПолучитьТекущуюДатуВФорматеRFC822());
			ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // dateCreated
		ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // head
		ЗаписьХМЛ.ЗаписатьНачалоЭлемента("body");
			ЗаписьХМЛ.ЗаписатьНачалоЭлемента("outline");
				ЗаписьХМЛ.ЗаписатьАтрибут("text", НСтр("ru = 'Новости 1С';
														|en = '1C news'"));
				Для каждого ТекущаяЛентаНовостей Из ЭтотОбъект.ЛентыНовостей Цикл
					Если ТекущаяЛентаНовостей.Пометка = Истина Тогда
						лкИмяФайлаНаСервере =
							ТекущаяЛентаНовостей.Значение.Протокол + "://"
							+ ТекущаяЛентаНовостей.Значение.Сайт + "/"
							+ ТекущаяЛентаНовостей.Значение.ИмяФайла;

						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "[from]", "last=40");

						// Значения предопределенных категорий.
						// Версии - точные (А.Б.В.Г), т.к. округление (А.Б.В.Г до А.Б.В.0) работает только в atom1C.
						ЭтотПродукт     = ОбработкаНовостейПовтИсп.ПолучитьЗначениеПредопределеннойКатегории("ЭтотПродукт");
						ВерсияПлатформы = ОбработкаНовостейПовтИсп.ПолучитьЗначениеПредопределеннойКатегории("ВерсияПлатформы");

						// Могли передать как /atom1c/, так и /atom1c?
						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "/atom1c/", "/" + ЭтотОбъект.ФорматНовостей + "/");
						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "/atom1c?", "/" + ЭтотОбъект.ФорматНовостей + "?");

						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "[config]", "config=" + ЭтотПродукт);
						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "[platformVersion]", "platformVersion=" + ВерсияПлатформы);
						// Фильтр не передается, поэтому заменять
						//   "[filter]"
						//  на
						//   "Справочники.ЛентыНовостей.СформироватьТекстУсловияДляСервераНовостей(ТекущаяЛентаНовостей.ЛентаНовостей))"
						//  не нужно.
						лкИмяФайлаНаСервере = СтрЗаменить(лкИмяФайлаНаСервере, "[filter]", "");

						ЗаписьХМЛ.ЗаписатьНачалоЭлемента("outline");
							ЗаписьХМЛ.ЗаписатьАтрибут("text", ТекущаяЛентаНовостей.Значение.Наименование);
							ЗаписьХМЛ.ЗаписатьАтрибут("title", ТекущаяЛентаНовостей.Значение.Наименование);
							ЗаписьХМЛ.ЗаписатьАтрибут("xmlUrl", лкИмяФайлаНаСервере);
							ЗаписьХМЛ.ЗаписатьАтрибут("htmlUrl", лкИмяФайлаНаСервере);
						ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // outline
					КонецЕсли;
				КонецЦикла;
			ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // outline
		ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // body
	ЗаписьХМЛ.ЗаписатьКонецЭлемента(); // opml
	ЗаписьХМЛ.Закрыть();

КонецПроцедуры

&НаСервере
// Возвращает текущую дату в формате RFC822.
//
// Возвращаемое значение:
//   Строка - текущая дата в формате RFC822.
//
Функция ПолучитьТекущуюДатуВФорматеRFC822()

	лкТекущаяДата = ТекущаяУниверсальнаяДата(); // В GMT

	лкДеньНедели  = ДеньНедели(лкТекущаяДата);
	Если лкДеньНедели = 1 Тогда
		лкДеньНеделиСтрокой = "Mon";
	ИначеЕсли лкДеньНедели = 2 Тогда
		лкДеньНеделиСтрокой = "Tue";
	ИначеЕсли лкДеньНедели = 3 Тогда
		лкДеньНеделиСтрокой = "Wed";
	ИначеЕсли лкДеньНедели = 4 Тогда
		лкДеньНеделиСтрокой = "Thu";
	ИначеЕсли лкДеньНедели = 5 Тогда
		лкДеньНеделиСтрокой = "Fri";
	ИначеЕсли лкДеньНедели = 6 Тогда
		лкДеньНеделиСтрокой = "Sat";
	Иначе // 7 и другие
		лкДеньНеделиСтрокой = "Sun";
	КонецЕсли;

	лкМесяц = Месяц(лкТекущаяДата);
	Если лкМесяц = 1 Тогда
		лкМесяцСтрокой = "Jan";
	ИначеЕсли лкМесяц = 2 Тогда
		лкМесяцСтрокой = "Feb";
	ИначеЕсли лкМесяц = 3 Тогда
		лкМесяцСтрокой = "Mar";
	ИначеЕсли лкМесяц = 4 Тогда
		лкМесяцСтрокой = "Apr";
	ИначеЕсли лкМесяц = 5 Тогда
		лкМесяцСтрокой = "May";
	ИначеЕсли лкМесяц = 6 Тогда
		лкМесяцСтрокой = "Jun";
	ИначеЕсли лкМесяц = 7 Тогда
		лкМесяцСтрокой = "Jul";
	ИначеЕсли лкМесяц = 8 Тогда
		лкМесяцСтрокой = "Aug";
	ИначеЕсли лкМесяц = 9 Тогда
		лкМесяцСтрокой = "Sep";
	ИначеЕсли лкМесяц = 10 Тогда
		лкМесяцСтрокой = "Oct";
	ИначеЕсли лкМесяц = 11 Тогда
		лкМесяцСтрокой = "Nov";
	Иначе
		лкМесяцСтрокой = "Dec";
	КонецЕсли;

	Результат =
		лкДеньНеделиСтрокой + ", "
		+ Формат(лкТекущаяДата, "ДФ=dd") + " "
		+ лкМесяцСтрокой + " "
		+ Формат(Год(лкТекущаяДата), "ЧЦ=4; ЧДЦ=; ЧГ=0") + " "
		+ Формат(лкТекущаяДата, "ДФ=HH:mm:ss") // АПК:335 Специальный формат даты - RFC822.
		+ " GMT";

	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПослеВыбораИмениФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт

	ТипМассив = Тип("Массив");

	Если (ТипЗнч(ВыбранныеФайлы) = ТипМассив)
			И (ВыбранныеФайлы.Количество() > 0) Тогда
		ИмяФайла = ВыбранныеФайлы[0];
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
