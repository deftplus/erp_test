#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Служебный
		И Не ПометкаУдаления
		И ЗначениеЗаполнено(Идентификатор)
		И СтатусИзвлеченияТекста = Перечисления.СтатусыИзвлеченияТекстаФайлов.Извлечен
		И ЗначениеЗаполнено(ВладелецФайла)
		И Не ИзменилсяРеквизит("ПометкаУдаления") Тогда
		
		РеквизитыВладельца = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ВладелецФайла,
			"Страхователь, ВидИзвещенияФСС, ВходящаяДата, Дата, ИдентификаторСообщения, ФизическоеЛицо");
		
		Если Идентификатор = РеквизитыВладельца.ИдентификаторСообщения Тогда
			
			Текст = СтрШаблон(
				НСтр("ru = 'Начат анализ текста извещения ФСС %1 документа %2.';
					|en = 'The analysis of the SSF notification text %1 in the document %2 has been started.'"),
				Идентификатор,
				ВладелецФайла);
			ЗаписатьПримечание(Текст);
			
			Попытка
				// Подготовка параметров анализа.
				РеквизитыВладельца.Вставить("ДатаНачалаСобытия", НачалоДня(РеквизитыВладельца.ВходящаяДата));
				Если Не ЗначениеЗаполнено(РеквизитыВладельца.ДатаНачалаСобытия) Тогда
					РеквизитыВладельца.ДатаНачалаСобытия = НачалоДня(РеквизитыВладельца.Дата);
				КонецЕсли;
				ИзвлеченныйТекст = ТекстХранилище.Получить();
				// Анализ.
				РезультатАнализа = ПроанализироватьИзвлеченныйТекст(ИзвлеченныйТекст, РеквизитыВладельца);
				// Журнал регистрации.
				Текст = СтрШаблон(
					НСтр("ru = 'Анализ завершен. Подробный журнал: %1.';
						|en = 'The analysis is complete. Detailed log: %1.'"),
					Символы.ПС + Символы.ПС + СтрСоединить(РезультатАнализа.ПодробныйЖурнал, Символы.ПС + Символы.ПС));
				ЗаписатьПримечание(Текст);
				// Обновление реквизитов владельца на основании найденных значений.
				НайденВидИзвещения = ЗначениеЗаполнено(РезультатАнализа.ВидИзвещенияФСС)
					И РеквизитыВладельца.ВидИзвещенияФСС <> РезультатАнализа.ВидИзвещенияФСС;
				НайденоФизическоеЛицо = (
					РезультатАнализа.СНИЛС.Количество() <= 1
					И РезультатАнализа.ФизическиеЛица.Количество() = 1
					И Не ЗначениеЗаполнено(РеквизитыВладельца.ФизическоеЛицо));
				Если НайденВидИзвещения Или НайденоФизическоеЛицо Тогда
					ВладелецОбъект = ВладелецФайла.ПолучитьОбъект();
					Если НайденВидИзвещения Тогда
						ВладелецОбъект.ВидИзвещенияФСС = РезультатАнализа.ВидИзвещенияФСС;
					КонецЕсли;
					Если НайденоФизическоеЛицо Тогда
						ВладелецОбъект.ФизическоеЛицо = РезультатАнализа.ФизическиеЛица[0];
					КонецЕсли;
					ВладелецОбъект.ОбновитьВторичныеДанные();
					ВладелецОбъект.Записать(РежимЗаписиДокумента.Запись);
				КонецЕсли;
				// Сохранение результата анализа в реквизит элемента справочника.
				РезультатАнализаТекста = Новый ХранилищеЗначения(РезультатАнализа, Новый СжатиеДанных(9));
			Исключение
				ЗаписатьОшибку(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИзменилсяРеквизит(ИмяРеквизита)
	Если ЭтоНовый() Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат ЭтотОбъект[ИмяРеквизита] <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
КонецФункции

Функция ПроанализироватьИзвлеченныйТекст(ИзвлеченныйТекст, РеквизитыВладельца)
	Результат = Новый Структура("ВидИзвещенияФСС, ФизическиеЛица, СНИЛС, ФИО, ПодробныйЖурнал");
	Результат.ВидИзвещенияФСС = Неопределено;
	Результат.ФизическиеЛица = Новый Массив;
	Результат.СНИЛС = Новый Массив;
	Результат.ФИО = Новый Массив;
	Результат.ПодробныйЖурнал = Новый Массив;
	
	ДлинаТекста          = СтрДлина(ИзвлеченныйТекст);
	ИзвлеченныйТекстНРег = НРег(ИзвлеченныйТекст);
	РазделителиСлов      = РазделителиСлов(ИзвлеченныйТекст);
	
	// Определение вида извещения ФСС.
	ПриОпределенииВидаИзвещенияФСС(Результат, ИзвлеченныйТекстНРег, РазделителиСлов);
	
	// Для поиска СНИЛС и ФИО разделители нужны с цифрами и подчеркиванием.
	Цифры = БуквыСлов(Истина, Ложь, Ложь, Ложь, Ложь, Ложь);
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(РазделителиСлов, Цифры);
	РазделителиСлов.Добавить("_");
	
	// Поиск СНИЛС.
	ПриПоискеСНИЛС(Результат, РеквизитыВладельца, ИзвлеченныйТекст, ИзвлеченныйТекстНРег, ДлинаТекста, РазделителиСлов, Цифры);
	
	// Если результаты анализа СНИЛС однозначны, то поиск по ФИО не требуется.
	Если Результат.СНИЛС.Количество() = 1
		И Результат.ФизическиеЛица.Количество() = 1 Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Поиск ФИО по шаблону: "Ф|<Фамилия>|И|<Имя>|О|<Отчество>".
	ПриПоискеФИО(Результат, РеквизитыВладельца, ИзвлеченныйТекст, ИзвлеченныйТекстНРег, ДлинаТекста, РазделителиСлов, 1);
	
	// Поиск ФИО по шаблону: "Фамилия|<Фамилия>|Имя|<Имя>|Отчество|<Отчество>".
	ПриПоискеФИО(Результат, РеквизитыВладельца, ИзвлеченныйТекст, ИзвлеченныйТекстНРег, ДлинаТекста, РазделителиСлов, 2);
	
	Возврат Результат;
КонецФункции

Процедура ПриОпределенииВидаИзвещенияФСС(Результат, ИзвлеченныйТекстНРег, РазделителиСлов)
	ТекстНРегБезРазделителей = СтрСоединить(СтрРазделить(ИзвлеченныйТекстНРег, СтрСоединить(РазделителиСлов, ""), Ложь), "");
	
	Если СтрНайти(ТекстНРегБезРазделителей, НРег("Приложение4КПриказуФондаСоциальногоСтрахования")) > 0
		Или СтрНайти(ТекстНРегБезРазделителей, НРег("ИзвещениеОПредставленииНедостающихДокументовИлиСведений")) > 0 Тогда
		Результат.ВидИзвещенияФСС = Перечисления.ВидыИзвещенийФСС.ИзвещениеОПредставленииНедостающихСведений;
		
	ИначеЕсли СтрНайти(ТекстНРегБезРазделителей, НРег("Приложение5КПриказуФондаСоциальногоСтрахования")) > 0
		Или СтрНайти(ТекстНРегБезРазделителей, НРег("РешениеОбОтказеВНазначенииИВыплатеПособия")) > 0 Тогда
		Результат.ВидИзвещенияФСС = Перечисления.ВидыИзвещенийФСС.РешениеОбОтказеВНазначенииИВыплатеПособия;
		
	ИначеЕсли СтрНайти(ТекстНРегБезРазделителей, НРег("Приложение9КПриказуФондаСоциальногоСтрахования")) > 0
		Или СтрНайти(ТекстНРегБезРазделителей, НРег("РешениеОбОтказеВРассмотренииДокументов")) > 0 Тогда
		Результат.ВидИзвещенияФСС = Перечисления.ВидыИзвещенийФСС.РешениеОбОтказеВРассмотренииДокументов;
		
	Иначе
		Результат.ВидИзвещенияФСС = Неопределено;
		
	КонецЕсли;
КонецПроцедуры

Функция ЧислоВСтроку(Число)
	Возврат Формат(Число, "ЧН=; ЧГ=");
КонецФункции

Процедура ПриПоискеСНИЛС(Результат, РеквизитыВладельца, ИзвлеченныйТекст, ИзвлеченныйТекстНРег, ДлинаТекста, РазделителиСлов, Цифры)
	Страхователь    = РеквизитыВладельца.Страхователь;
	Цифры           = БуквыСлов(Истина, Ложь, Ложь, Ложь, Ложь, Ложь);
	ДлинаСловаСНИЛС = СтрДлина("снилс");
	ВГраница        = ДлинаТекста - ДлинаСловаСНИЛС - 11;
	КонецСловаСНИЛС = 1;
	Пока КонецСловаСНИЛС < ВГраница Цикл
		// Поиск "СНИЛС".
		Позиция = СтрНайти(ИзвлеченныйТекстНРег, "снилс", , КонецСловаСНИЛС);
		Если Позиция = 0 Или Позиция > ВГраница Тогда
			Результат.ПодробныйЖурнал.Добавить(НСтр("ru = 'Текст ""СНИЛС"" не найден.';
													|en = 'The ""IIAN"" text was not found.'"));
			Прервать;
		КонецЕсли;
		КонецСловаСНИЛС = Позиция + ДлинаСловаСНИЛС;
		Результат.ПодробныйЖурнал.Добавить(СтрШаблон(НСтр("ru = 'Текст ""СНИЛС"" найден в позиции %1.';
															|en = 'The ""IIAN"" text was found in position %1.'"), ЧислоВСтроку(Позиция)));
		
		// Проверка что найдено целое слово, а не часть другого слова.
		// Для этого необходимо проверить что слева разделитель слов, а справа - разделитель слов или цифра.
		Если Позиция > 1 Тогда
			СимволСлева = Сред(ИзвлеченныйТекст, Позиция - 1, 1);
			Если РазделителиСлов.Найти(СимволСлева) = Неопределено Тогда
				Текст = НСтр("ru = 'Слева от текста ""СНИЛС"" находится символ ""%1"", не являющийся разделителем слов.';
							|en = 'The character ""%1"", which is not a word separator, is located to the left of the ""IIAN"" text.'");
				Результат.ПодробныйЖурнал.Добавить(СтрШаблон(Текст, СимволСлева));
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		// Наполнение СНИЛС цифрами, игнорируя разделители (в частности - минусы).
		СНИЛСВФорматеФСС = "";
		ДлинаСНИЛС = 0;
		Для НомерСимвола = КонецСловаСНИЛС По ДлинаТекста Цикл
			ОчереднойСимвол = Сред(ИзвлеченныйТекст, НомерСимвола, 1);
			Если Цифры.Найти(ОчереднойСимвол) <> Неопределено Тогда
				СНИЛСВФорматеФСС = СНИЛСВФорматеФСС + ОчереднойСимвол;
				ДлинаСНИЛС = ДлинаСНИЛС + 1;
				Если ДлинаСНИЛС = 11 Тогда
					Прервать;
				КонецЕсли;
			ИначеЕсли РазделителиСлов.Найти(ОчереднойСимвол) = Неопределено Тогда
				Если ДлинаСНИЛС = 0 Тогда
					Текст = НСтр("ru = 'Справа от текста ""СНИЛС"" находится символ ""%1"", не являющийся разделителем слов.';
								|en = 'The character ""%1"", which is not a word separator, is located to the right of the ""IIAN"" text.'");
					Результат.ПодробныйЖурнал.Добавить(СтрШаблон(Текст, ОчереднойСимвол));
				КонецЕсли;
				Прервать; // Буква (не разделитель слов).
			КонецЕсли;
		КонецЦикла;
		
		// Проверка что получен весь СНИЛС.
		Если ДлинаСНИЛС < 11 Тогда
			Если ДлинаСНИЛС > 0 Тогда
				Текст = НСтр("ru = 'Найдено слово ""СНИЛС"", после которого найдена последовательность цифр %1. Длина последовательности менее 11 символов, это не СНИЛС.';
							|en = 'Found the word ""IIAN"", after which a sequence of numbers %1 was found. The sequence length is less than 11 characters, this is not IIAN.'");
				Результат.ПодробныйЖурнал.Добавить(СтрШаблон(Текст, СНИЛСВФорматеФСС));
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		// Поиск сотрудника по СНИЛС.
		СНИЛС = УчетПособийСоциальногоСтрахованияКлиентСервер.СНИЛСВФорматеИБ(СНИЛСВФорматеФСС);
		ПриПоискеСотрудника(Результат, СНИЛС, "", "", "", РеквизитыВладельца);
	КонецЦикла;
КонецПроцедуры

Процедура ПриПоискеФИО(Результат, РеквизитыВладельца, ИзвлеченныйТекст, ИзвлеченныйТекстНРег, ДлинаТекста, РазделителиСлов, НомерШаблона)
	Если НомерШаблона = 1 Тогда
		// Поиск ФИО по шаблону: "Ф|<Фамилия>|И|<Имя>|О|<Отчество>".
		ЗаголовокФамилия  = "ф";
		ЗаголовокИмя      = "и";
		ЗаголовокОтчество = "о";
	ИначеЕсли НомерШаблона = 2 Тогда
		// Поиск ФИО по шаблону: "Фамилия|<Фамилия>|Имя|<Имя>|Отчество|<Отчество>".
		ЗаголовокФамилия  = "фамилия";
		ЗаголовокИмя      = "имя";
		ЗаголовокОтчество = "отчество";
	КонецЕсли;
	
	ДлинаЗаголовкаФамилия  = СтрДлина(ЗаголовокФамилия);
	ДлинаЗаголовкаИмя      = СтрДлина(ЗаголовокИмя);
	ДлинаЗаголовкаОтчество = СтрДлина(ЗаголовокОтчество);
	
	МаксНачалоЗаголовкаФамилия  = ДлинаТекста - ДлинаЗаголовкаФамилия - ДлинаЗаголовкаИмя - ДлинаЗаголовкаОтчество - 6;
	МаксНачалоЗаголовкаИмя      = ДлинаТекста - ДлинаЗаголовкаИмя - ДлинаЗаголовкаОтчество - 4;
	МаксНачалоЗаголовкаОтчество = ДлинаТекста - ДлинаЗаголовкаОтчество - 2;
	
	ПозицияКурсора = 1;
	Пока Истина Цикл
		// Поиск фамилии.
		НайтиКонецСлова(ИзвлеченныйТекстНРег, ЗаголовокФамилия, ДлинаЗаголовкаФамилия, РазделителиСлов, ПозицияКурсора, МаксНачалоЗаголовкаФамилия);
		Если ПозицияКурсора = 0 Тогда
			Прервать;
		КонецЕсли;
		Фамилия = СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста);
		Если Фамилия = "" Тогда
			Продолжить; // Фамилия обязательна для заполнения.
		ИначеЕсли СтрСравнить(Фамилия, ЗаголовокИмя) = 0 Тогда
			Продолжить; // Пропуск фрагментов типа "Ф|И|О" и "Фамилия|Имя|Отчество".
		КонецЕсли;
		
		// Поиск имени.
		НайтиКонецСлова(ИзвлеченныйТекстНРег, ЗаголовокИмя, ДлинаЗаголовкаИмя, РазделителиСлов, ПозицияКурсора, МаксНачалоЗаголовкаИмя);
		Если ПозицияКурсора = 0 Тогда
			Прервать;
		КонецЕсли;
		Имя = СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста);
		Если Имя = "" Тогда
			Продолжить; // Имя обязательно для заполнения.
		КонецЕсли;
		
		// Поиск отчества.
		НайтиКонецСлова(ИзвлеченныйТекстНРег, ЗаголовокОтчество, ДлинаЗаголовкаОтчество, РазделителиСлов, ПозицияКурсора, МаксНачалоЗаголовкаОтчество);
		Если ПозицияКурсора = 0 Тогда
			Отчество = ""; // Отчество не обязательно для заполнения.
		Иначе
			Отчество = СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста);
			Если СтрСравнить(Отчество, "при") = 0 Тогда
				Отчество = СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста);
				Если СтрСравнить(Отчество, "наличии") = 0 Тогда
					Отчество = СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		// Поиск сотрудника по ФИО.
		ПриПоискеСотрудника(Результат, "", Фамилия, Имя, Отчество, РеквизитыВладельца);
	КонецЦикла;
КонецПроцедуры

Процедура ПриПоискеСотрудника(Результат, СНИЛС, Фамилия, Имя, Отчество, РеквизитыВладельца) Экспорт
	// Проверка что уже искали по этому ФИО / СНИЛС.
	Если ЗначениеЗаполнено(СНИЛС) Тогда
		Если Результат.СНИЛС.Найти(СНИЛС) <> Неопределено Тогда
			Возврат; // Уже искали по этому СНИЛС.
		КонецЕсли;
		Результат.СНИЛС.Добавить(СНИЛС);
	Иначе
		ФИО = ТРег(Фамилия) + " " + ТРег(Имя) + " " + ТРег(Отчество);
		Если Результат.ФИО.Найти(ФИО) <> Неопределено Тогда
			Возврат; // Уже искали по этому ФИО.
		КонецЕсли;
		Результат.ФИО.Добавить(ФИО);
	КонецЕсли;
	
	РезультатПоиска = ФизическиеЛицаЗарплатаКадры.ФизическоеЛицоПоСНИЛСИлиФИО(СНИЛС, Фамилия, Имя, Отчество);
	ФизическоеЛицо = РезультатПоиска.ФизическоеЛицо;
	Если ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Если Результат.ФизическиеЛица.Найти(ФизическоеЛицо) = Неопределено Тогда
			Результат.ФизическиеЛица.Добавить(ФизическоеЛицо);
			Если ЗначениеЗаполнено(СНИЛС) Тогда
				Текст = СтрШаблон(НСтр("ru = 'По СНИЛС %1 найдено физическое лицо %2.';
										|en = 'Found an individual %2 by IIAN %1.'"), СНИЛС, ФизическоеЛицо);
			Иначе
				Текст = СтрШаблон(НСтр("ru = 'По ФИО %1 найдено физическое лицо %2.';
										|en = 'Found an individual %2 by full name %1.'"), ФИО, ФизическоеЛицо);
			КонецЕсли;
			Результат.ПодробныйЖурнал.Добавить(Текст);
			ЗаписатьПримечание(Текст);
		КонецЕсли;
	Иначе
		Если ЗначениеЗаполнено(СНИЛС) Тогда
			Текст = СтрШаблон(
				НСтр("ru = 'Не удалось найти физическое лицо по СНИЛС %1: %2.';
					|en = 'Cannot find the individual by IIAN %1: %2.'"),
				СНИЛС,
				РезультатПоиска.ТекстОшибки);
		Иначе
			Текст = СтрШаблон(
				НСтр("ru = 'Не удалось найти физическое лицо по ФИО %1: %2.';
					|en = 'Cannot find the individual by name %1: %2.'"),
				ФИО,
				РезультатПоиска.ТекстОшибки);
		КонецЕсли;
		Результат.ПодробныйЖурнал.Добавить(Текст);
		ЗаписатьПримечание(Текст);
	КонецЕсли;
	
КонецПроцедуры

#Область Строки

// Возвращает массив символов, являющихся разделителями слов в указанном тексте.
Функция РазделителиСлов(Знач Строка, Знач ИсключаемыеРазделители = "", Знач Цифры = Ложь, Знач Подчеркивание = Ложь)
	РазрешенныеСимволы = БуквыСлов(Не Цифры, , , , , Не Подчеркивание);
	РазрешенныеСимволы.Добавить(ИсключаемыеРазделители);
	РазрешенныеСимволы = СтрСоединить(РазрешенныеСимволы, "");
	
	Разделители = Новый Массив;
	РазделителиСтрокой = СтрСоединить(СтрРазделить(Строка, РазрешенныеСимволы, Ложь), "");
	КоличествоСимволов = СтрДлина(РазделителиСтрокой);
	КодыСимволов = Новый Соответствие;
	Для НомерСимвола = 1 По КоличествоСимволов Цикл
		КодСимвола = КодСимвола(РазделителиСтрокой, НомерСимвола);
		Если КодыСимволов[КодСимвола] = Неопределено Тогда
			КодыСимволов[КодСимвола] = Истина;
			Разделители.Добавить(Символ(КодСимвола));
		КонецЕсли;
	КонецЦикла;
	
	Возврат Разделители;
КонецФункции

// Возвращает массив букв слов.
// АПК:163-выкл Особенность реализации.
// АПК:142-выкл Особенность реализации.
Функция БуквыСлов(Цифры = Истина, ЛатиницаЗаглавные = Истина, ЛатиницаСтрочные = Истина, КириллицаЗаглавные = Истина, КириллицаСтрочные = Истина, Подчеркивание = Истина)
	Буквы = Новый Массив;
	Если Цифры Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 48, 57);
	КонецЕсли;
	Если ЛатиницаЗаглавные Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 65, 90);
	КонецЕсли;
	Если ЛатиницаСтрочные Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 97, 122);
	КонецЕсли;
	Если КириллицаЗаглавные Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 1040, 1071); // Буквы от "А" до "Я" без "Ё".
		ДобавитьСимволыВДиапазоне(Буквы, 1025, 1025); // Буква "Ё".
	КонецЕсли;
	Если КириллицаСтрочные Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 1072, 1103); // Буквы от "а" до "я" без "ё".
		ДобавитьСимволыВДиапазоне(Буквы, 1105, 1105); // Буква "ё".
	КонецЕсли;
	Если Подчеркивание Тогда
		ДобавитьСимволыВДиапазоне(Буквы, 95, 95);
	КонецЕсли;
	Возврат Буквы;
КонецФункции

Процедура НайтиКонецСлова(ТекстНРег, СловоНРег, ДлинаСлова, РазделителиСлов, ПозицияКурсора, МаксПозицияКурсора)
	Пока Истина Цикл
		Начало = СтрНайти(ТекстНРег, СловоНРег, , ПозицияКурсора);
		Если Начало = 0 Или Начало > МаксПозицияКурсора Тогда
			ПозицияКурсора = 0;
			Возврат;
		КонецЕсли;
		ПозицияКурсора = Начало + ДлинаСлова;
		
		// Проверка что найдено целое слово, а не часть другого слова.
		// Для этого необходимо проверить что слева разделитель слов, а справа - разделитель слов или цифра.
		СимволСлева = Сред(ТекстНРег, Начало - 1, 1);
		Если РазделителиСлов.Найти(СимволСлева) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СимволСправа = Сред(ТекстНРег, ПозицияКурсора, 1);
		Если РазделителиСлов.Найти(СимволСправа) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Возврат;
	КонецЦикла;
КонецПроцедуры

Функция СледующееСлово(ИзвлеченныйТекст, РазделителиСлов, ПозицияКурсора, ДлинаТекста)
	Слово = "";
	Пока ПозицияКурсора < ДлинаТекста Цикл
		ПозицияКурсора = ПозицияКурсора + 1;
		ОчереднойСимвол = Сред(ИзвлеченныйТекст, ПозицияКурсора, 1);
		Если РазделителиСлов.Найти(ОчереднойСимвол) = Неопределено Тогда
			// Буква.
			Слово = Слово + ОчереднойСимвол;
		Иначе
			// Разделитель слов.
			Если Слово <> "" Тогда
				Прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Слово;
КонецФункции

// АПК:142-вкл
// АПК:163-вкл

Процедура ДобавитьСимволыВДиапазоне(Символы, КодПервогоСимвола, КодПоследнегоСимвола)
	Для КодСимвола = КодПервогоСимвола По КодПоследнегоСимвола Цикл
		Символы.Добавить(Символ(КодСимвола));
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область Журнал

Процедура ЗаписатьПримечание(Текст)
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Обмен с ФСС.Извлечение текста';
			|en = 'Exchange with SSF.Text extraction'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Примечание,
		ВладелецФайла.Метаданные(),
		ВладелецФайла,
		Текст,
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
КонецПроцедуры

Процедура ЗаписатьОшибку(Текст)
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Обмен с ФСС.Извлечение текста';
			|en = 'Exchange with SSF.Text extraction'", ОбщегоНазначения.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,
		ВладелецФайла.Метаданные(),
		ВладелецФайла,
		Текст,
		РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли