Перем Эксель Экспорт;
Перем Workbook;

Функция ИнициализацияДокумента() Экспорт
	
	Попытка
		
		Если Эксель = Неопределено Тогда
			Эксель = Новый COMОбъект("Excel.Application");
		Иначе
			Workbook.Close(Ложь);
		КонецЕсли;
		
		Workbook = Эксель.WorkBooks.Open(ФайлЭксель);
		Возврат Истина;
		
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке("Не удалось создать объект Microsoft Excel");
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

Функция СимволСтроки(Символ)
	Возврат СтрЧислоВхождений("ABCDEFGHIJKLMNOPQRSTUVWXYZ", ВРег(Символ))>0 ;
КонецФункции

Функция СимволЧисло(Символ)
	Возврат СтрЧислоВхождений("1234567890", ВРег(Символ)) >0;
КонецФункции

Функция РассчитатьКоординатуКолонки(ИмяКолонки)
	
	КодСимволаНачала = КодСимвола("A");
	Если СтрДлина(ИмяКолонки) = 2 Тогда
		Координата = (КодСимвола(ИмяКолонки, 2) - КодСимволаНачала + 1)*28 + (КодСимвола(ИмяКолонки, 2) - КодСимволаНачала);
	Иначе
		Координата = КодСимвола(ИмяКолонки, 1) - КодСимволаНачала + 1;
	КонецЕсли;
	
	Возврат Координата;
	
КонецФункции

Функция РассчитатьИмяКолонкиПоНомеру(КодЧисло)
	
	ВторойСимвол = Цел(КодЧисло/28);
	ПервыйСимвол = КодЧисло - ВторойСимвол * 28;
	
	КодСимволаНачала = КодСимвола("A");
	Возврат ?(ВторойСимвол = 0, "", Символ(КодСимволаНачала + ВторойСимвол - 1)) + Символ(КодСимволаНачала + ПервыйСимвол - 1);
	
КонецФункции

Функция ЗаменитьФункциюСуммы(ТекстФормулы)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Начало");
	Таблица.Колонки.Добавить("Конец");
	
	Начало = СтрНайти(ТекстФормулы, "SUM(");
	
	Пока Начало > 0 Цикл
	
		НайденКонецФормулы = Ложь;
		ДлинаСтроки        = СтрДлина(ТекстФормулы);
		ТекущийИндекс = Начало + 4;
		НачалоДиапазона = Истина;
		КодЯчейкиНачала = "";
		КодЯчейкиКонца  = "";
		
		Пока НЕ НайденКонецФормулы И Начало <= ДлинаСтроки Цикл
			
			ТекСимвол = Сред(ТекстФормулы, ТекущийИндекс, 1);
			
			Если ТекСимвол = ":" Тогда
				
				НачалоДиапазона = Ложь;
				
			ИначеЕсли ТекСимвол = "," Тогда
				
				НоваяСтрока = Таблица.Добавить();
				Если НачалоДиапазона Тогда
					НоваяСтрока.Начало = КодЯчейкиНачала;
					НоваяСтрока.Конец  = КодЯчейкиНачала;
				Иначе
					НоваяСтрока.Начало = КодЯчейкиНачала;
					НоваяСтрока.Конец  = КодЯчейкиКонца;
				КонецЕсли;
				
				НачалоДиапазона = Истина;
				КодЯчейкиНачала = "";
				КодЯчейкиКонца = "";
				
				
			ИначеЕсли ТекСимвол = ")" Тогда
				
				НайденКонецФормулы = Истина;
				
				НоваяСтрока = Таблица.Добавить();
				Если НачалоДиапазона Тогда
					НоваяСтрока.Начало = КодЯчейкиНачала;
					НоваяСтрока.Конец  = КодЯчейкиНачала;
				Иначе
					НоваяСтрока.Начало = КодЯчейкиНачала;
					НоваяСтрока.Конец  = КодЯчейкиКонца;
				КонецЕсли;
				
			Иначе
				Если НачалоДиапазона Тогда
					КодЯчейкиНачала = КодЯчейкиНачала + ТекСимвол;
				Иначе
					КодЯчейкиКонца = КодЯчейкиКонца + ТекСимвол;
				КонецЕсли;
				
			КонецЕсли;
			
			ТекущийИндекс = ТекущийИндекс + 1;
			
		КонецЦикла;
		
		СтрокаПодмены = "";
		Для Каждого Строка Из Таблица Цикл
			
			Если Строка.Начало = Строка.Конец Тогда
				СтрокаПодмены = СтрокаПодмены + "+" + Строка.Начало;
			Иначе
				КоординатыНачала = ВернутьКоординатыКолонки(Строка.Начало);
				КоординатыКонца  = ВернутьКоординатыКолонки(Строка.Конец);
				Для Инд = КоординатыНачала.Колонка По КоординатыКонца.Колонка Цикл
					
					Для Инд2 = КоординатыНачала.Строка по КоординатыКонца.Строка Цикл
						
						СтрокаПодмены = СтрокаПодмены + "+" + РассчитатьИмяКолонкиПоНомеру(Инд) + Строка(Инд2);
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ТекстФормулы = СтрЗаменить(ТекстФормулы, Сред(ТекстФормулы, Начало, ТекущийИндекс - 1), "(" + Сред(СтрокаПодмены, 2) + ")");
		Начало = СтрНайти(ТекстФормулы, "SUM(");
		
	КонецЦикла;
	
	
	Возврат Истина;
	
КонецФункции

Функция ВернутьКоординатыКолонки(ИмяКолонки)
	
	ДлинаИмени = СтрДлина(ИмяКолонки);
	Колонка    = "";
	Строка     = "";
	
	ПишемСтроку = Ложь;
	Для Инд = 1 По ДлинаИмени Цикл
		
		ТекСимвол = Сред(ИмяКолонки, Инд, 1);
		Если СимволЧисло(ТекСимвол) Тогда
			ПишемСтроку = Истина;
		КонецЕсли;
		
		Если ПишемСтроку Тогда
			Строка = Строка + ТекСимвол;
		Иначе
			Колонка = Колонка + ТекСимвол;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый Структура("Строка, Колонка", Число(Строка), РассчитатьКоординатуКолонки(Колонка));
	
КонецФункции

Функция АнализФормулы(Формула)
	
	ИтоговаяФормула = "";
	
	ТаблицаКолонок = Новый ТаблицаЗначений;
	ТаблицаКолонок.Колонки.Добавить("ИмяКолонки");
	ТаблицаКолонок.Колонки.Добавить("ТипКолонки");
	
	НоваяСтрока = ТаблицаКолонок.Добавить();
	НоваяСтрока.ИмяКолонки = "Х1";
	НоваяСтрока.ТипКолонки = "Строка";
	
	НоваяСтрока = ТаблицаКолонок.Добавить();
	НоваяСтрока.ИмяКолонки = "У1";
	НоваяСтрока.ТипКолонки = "Число";
	
	
	ТаблицаПеременных = Новый ТаблицаЗначений;
	ТаблицаПеременных.Колонки.Добавить("Х1");
	ТаблицаПеременных.Колонки.Добавить("У1");
	ТаблицаПеременных.Колонки.Добавить("Начало");
	
	ТекИндексКолонки = 0;
	ТекСтрока = Неопределено;
	
	// Заменим вхождение функции SUM в виде обычного арифметического выражения.
	
	ЗаменитьФункциюСуммы(Формула);
	
	Для Инд = 1 ПО СтрДлина(Формула) Цикл
		Символ = Сред(Формула, Инд, 1);
		ТекКолонка = ТаблицаКолонок[ТекИндексКолонки];
		Если СимволСтроки(Символ) Тогда
			Если ТекКолонка.ТипКолонки = "Строка" Тогда
				
				Если ТекСтрока = Неопределено Тогда
					ТекСтрока = ТаблицаПеременных.Добавить();
				КонецЕсли;
				
				Если ПустаяСтрока(ТекСтрока[ТекКолонка.ИмяКолонки]) Тогда
					ТекСтрока.Начало = Инд;
					ТекСтрока[ТекКолонка.ИмяКолонки] = Символ;
				Иначе
					ТекСтрока[ТекКолонка.ИмяКолонки] = "" + ТекСтрока[ТекКолонка.ИмяКолонки] + Символ;
				КонецЕсли;
			Иначе
				ТекИндексКолонки = ТекИндексКолонки + 1;
				ТекКолонка       = ТаблицаКолонок[ТекИндексКолонки];
				
				Если ТекИндексКолонки > 1 Тогда
					
					ТекИндексКолонки = 0;
					ТекСтрока = ТаблицаПеременных.Добавить();
					ТекКолонка = ТаблицаКолонок[ТекИндексКолонки];
					ТекСтрока[ТекКолонка.ИмяКолонки] = Символ;
					
				ИначеЕсли ТекКолонка.ТипКолонки <> "Число" Тогда
					
					ТаблицаПеременных.Удалить(ТекСтрока);
					ТекСтрока = ТаблицаПеременных.Добавить();
					ТекИндексКолонки = 0;
					ТекКолонка = ТаблицаКолонок[ТекИндексКолонки];
				Иначе
					ТекСтрока[ТекКолонка.ИмяКолонки] = Символ;
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли СимволЧисло(Символ) Тогда
			
			Если ТекСтрока <> Неопределено Тогда
			
				Если ТекКолонка.ТипКолонки = "Число" Тогда
					ТекСтрока[ТекКолонка.ИмяКолонки] = "" + ТекСтрока[ТекКолонка.ИмяКолонки] + Символ;
				Иначе
					ТекИндексКолонки = ТекИндексКолонки + 1;
					ТекКолонка       = ТаблицаКолонок[ТекИндексКолонки];
					ТекСтрока[ТекКолонка.ИмяКолонки] = Символ;
				КонецЕсли;
				
			КонецЕсли;
		Иначе
			Если ТекИндексКолонки = 1 Тогда
				ТекИндексКолонки = 0;
				ТекКолонка = ТаблицаКолонок[ТекИндексКолонки];
				ТекСтрока = ТаблицаПеременных.Добавить();
			ИначеЕсли ТекИндексКолонки <> 0 Тогда
				ТаблицаПеременных.Удалить(ТекСтрока);
				ТекСтрока = ТаблицаПеременных.Добавить();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаПеременных.Колонки.Добавить("НаименованиеЯчейки");
	ТаблицаПеременных.Колонки.Добавить("Верх");
	ТаблицаПеременных.Колонки.Добавить("Лево");
	
	ИтоговаяФормула = "";
	НачалоКопирования = 1;
	
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого Строка Из ТаблицаПеременных Цикл
		Если СтрДлина(Строка.Х1) > 2 Тогда
			ОбщегоНазначенияУХ.СообщитьОбОшибке("Формула: " + Формула + " не импортирована. Формула должна содержать только арифметические функции");
			Возврат Неопределено;
		ИначеЕсли ПустаяСтрока(Строка.Х1) Тогда
			МассивУдаляемыхСтрок.Добавить(Строка);
		Иначе
			Строка.НаименованиеЯчейки = Строка.Х1 + Строка.У1;
			Строка.Лево        = РассчитатьКоординатуКолонки(Строка.Х1);
			Строка.Верх        = Число(Строка.У1);
			ИтоговаяФормула = ИтоговаяФормула + Сред(Формула, НачалоКопирования, Строка.Начало - НачалоКопирования) + "{" + Строка.НаименованиеЯчейки + "}";
			НачалоКопирования = Строка.Начало + СтрДлина(Строка.НаименованиеЯчейки);
		КонецЕсли;
	КонецЦикла;
	
	ИтоговаяФормула = ИтоговаяФормула + Сред(Формула, НачалоКопирования);
	
	Для Каждого Строка Из МассивУдаляемыхСтрок Цикл
		ТаблицаПеременных.Удалить(Строка);
	КонецЦикла;
	
	Формула = ИтоговаяФормула;
	
	Возврат ТаблицаПеременных;
	
КонецФункции

Функция ОпределитьПоказательПоКоду(КодПоказателя, ТолькоВычисляемыеПоказатели = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПоказателиОтчетов.Ссылка
	|ИЗ
	|	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	|ГДЕ
	|	ПоказателиОтчетов.Код = &КодПоказателя
	|	И ПоказателиОтчетов.Владелец = &ВидОтчета
	|	И (НЕ ПоказателиОтчетов.ПометкаУдаления)";
		
	Запрос.УстановитьПараметр("КодПоказателя", КодПоказателя);
	Запрос.УстановитьПараметр("ВидОтчета"    , ВидОтчета);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		ВОзврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ОпределитьОперанды(ТаблицаОперандов, ТекстФормулы, Макет)
	
	ТаблицаОперандов.Колонки.Добавить("Показатель");
	
	Для Каждого Строка Из ТаблицаОперандов Цикл
		ТекОбласть = Макет.Область(Строка.Верх, Строка.Лево);
		Если ТекОбласть.СодержитЗначение Тогда
			ТекПоказатель = ОпределитьПоказательПоКоду(ТекОБласть.Имя);
			Если ТекПоказатель = Неопределено Тогда
				Возврат Ложь
			Иначе
				Строка.Показатель = ТекПоказатель;
				ТекстФормулы = СтрЗаменить(ТекстФормулы, "{" + Строка.НаименованиеЯчейки + "}", "{" + СокрЛП(ТекОбласть.Имя) + "}");
			КонецЕсли;
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьТекстФормул() Экспорт
	
	ТекстОшибки = "";
	
	Если ПустаяСтрока(ФайлЭксель) Тогда
		ТекстОшибки = ТекстОшибки + "
		| Не выбран файл Excel";
	КонецЕсли;
	
	Если ТипЗнч(МакетОтчета) <> Тип("ТабличныйДокумент") Тогда
		ТекстОшибки = ТекстОшибки + "
		| Не задан макет бланка отчета";
	КонецЕсли;
	
	Если ВидОтчета = Справочники.ВидыОтчетов.ПустаяСсылка() Тогда
		ТекстОшибки = ТекстОшибки + "
		| Не задан вид отчета";
	КонецЕсли;
	
	Если ПравилоОбработки = Справочники.ПравилаОбработки.ПустаяСсылка() Тогда
		ТекстОшибки = ТекстОшибки + "
		| Не задано правило обработки";
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ОбщегоНазначенияУХ.СообщитьОбОшибке(ТекстОшибки);
		Возврат Ложь;
	КонецЕсли;
	
	Если Эксель = Неопределено Тогда
		Если НЕ ИнициализацияДокумента() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Лист = Workbook.Sheets(ИмяЛиста);
	
	Попытка
		ЯчейкиСФормулами = Лист.Cells.SpecialCells(-4123);
	Исключение
		ОбщегоНазначенияУХ.СообщитьОбОшибке("Документ не содержит ячеек с формулами");
		ЗакрытьДокументЭксель();
		Возврат Ложь;
	КонецПопытки;
	
	ТаблицаФормул = Новый ТаблицаЗначений;
	ТаблицаФормул.Колонки.Добавить("Лево");
	ТаблицаФормул.Колонки.Добавить("Верх");
	ТаблицаФормул.Колонки.Добавить("ТекстФормулы");
	ТаблицаФормул.Колонки.Добавить("ТаблицаОперандов", Новый ОписаниеТипов("ТаблицаЗначений"));
	
	ОбщегоНазначенияУХ.СообщитьОбОшибке("Обнаружено " + Формат(ЯчейкиСФормулами.Count, "ЧДЦ=0; ЧН=0; ЧГ=3,0") + " ячеек с формулами", , , СтатусСообщения.Информация);
	
	Для Каждого Ячейка Из ЯчейкиСФормулами Цикл
		ФормулаЯчейки = Ячейка.Formula;
		АдресЯчейки   = Ячейка.Address;
		
		Если СтрНайти(ВРЕГ(ФормулаЯчейки),"ЛИСТ")>0 ИЛИ СтрНайти(ВРЕГ(ФормулаЯчейки),"SHEET")>0 Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ТаблицаПеременных = АнализФормулы(ФормулаЯчейки);
		Если ЗначениеЗаполнено(ТаблицаПеременных) И ТаблицаПеременных.Количество() > 0 Тогда
			НоваяСтрока = ТаблицаФормул.Добавить();
			НоваяСтрока.Лево = Ячейка.Column;
			НоваяСтрока.Верх = Ячейка.Row;
			НоваяСтрока.ТекстФормулы = СтрЗаменить(ФормулаЯчейки, "$", "");
			НоваяСтрока.ТаблицаОперандов = ТаблицаПеременных.Скопировать();
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияУХ.СообщитьОбОшибке("Удалось распознать формулы для " + Формат(ТаблицаФормул.Количество(), "ЧДЦ=0; ЧН=0; ЧГ=3,0") + " ячеек", , , СтатусСообщения.Информация);
	// Связь документа Excel и документа MXL
	ОбщееЧислоПоказателей          = 0;
	ЧислоОбработанныхПоказателей   = 0;
	
	БылиИзменения = Ложь;
	Для Каждого Строка Из ТаблицаФормул Цикл
		
		ТекОбласть = МакетОтчета.Область(Строка.Верх, Строка.Лево);
		Если ТекОбласть.СодержитЗначение Тогда
			ТекПоказатель = ОпределитьПоказательПоКоду(ТекОБласть.Имя, Истина);
			Если ТекПоказатель <> Неопределено Тогда
				
				ОбщееЧислоПоказателей = ОбщееЧислоПоказателей + 1;
				
				Если ОпределитьОперанды(Строка.ТаблицаОперандов, Строка.ТекстФормулы, МакетОтчета) Тогда
					
					СтруктураДанных = Новый Структура;
					СтруктураДанных.Вставить("ТекстПроцедуры",		Сред(Строка.ТекстФормулы, 2));
					СтруктураДанных.Вставить("ТипЯчейки",			"Показатель");
					СтруктураДанных.Вставить("Владелец",			ВидОтчета);
					СтруктураДанных.Вставить("НазначениеРасчетов",	ПравилоОбработки);
					СтруктураДанных.Вставить("ПотребительРасчета",	ТекПоказатель);
					СтруктураДанных.Вставить("ПроизвольныйКод",		Ложь);
					СтруктураДанных.Вставить("СпособИспользования",	Перечисления.СпособыИспользованияОперандов.ДляФормулРасчета);
		
					Если УправлениеОтчетамиУХ.ОбработатьТекстУпрощеннойФормулы(СтруктураДанных) Тогда		
						
						УправлениеОтчетамиУХ.ЗаписатьПроцедуруРасчета(СтруктураДанных);
						
					КонецЕсли;					
					
				Иначе
					
					ОбщегоНазначенияУХ.СообщитьОбОшибке("Не удалось сопоставить ячейки с операндами для показателя: " + ТекПоказатель.Наименование);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияУХ.СообщитьОбОшибке("Обработано " + ОбщееЧислоПоказателей + " показателей", , , СтатусСообщения.Информация);
	ОбщегоНазначенияУХ.СообщитьОбОшибке("Создана формула для " + ОбщееЧислоПоказателей + " показателей", , , СтатусСообщения.Информация);

	Если БылиИзменения Тогда
		УправлениеОтчетамиУХ.ОчиститьЗаписиРегистраПараметрическихНастроек(ПравилоОбработки)
	КонецЕсли;
	
	ЗакрытьДокументЭксель();
	Возврат Истина;
	
КонецФункции

Процедура ЗакрытьДокументЭксель()
	
	Workbook.Close(Ложь);
	Эксель.Quit();
	Эксель = Неопределено;

КонецПроцедуры
