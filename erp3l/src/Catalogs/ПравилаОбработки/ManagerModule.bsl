#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПроверитьМодуль(Знач ТекстМодуля, ОписаниеОшибки, ВычисляемыйПоказатель=Ложь, 
	ВидОтчета = Неопределено, Знач ИспользоватьРасширенныйРасчет = Неопределено) Экспорт
	
	Если ИспользоватьРасширенныйРасчет = Неопределено Тогда
		ИспользоватьРасширенныйРасчет = РасширениеБизнесЛогикиУХ.ИспользоватьРасширенныйРасчет();
	КонецЕсли;
	
	Если ИспользоватьРасширенныйРасчет Тогда
		ОбработкаРасчет = РасширениеБизнесЛогикиУХ.ПолучитьОбработкуЗаполненияДанных();
		Возврат ОбработкаРасчет.ПроверитьМодуль(ТекстМодуля, ОписаниеОшибки, ВычисляемыйПоказатель, ВидОтчета);
	Иначе		
		ДокНО = Документы.НастраиваемыйОтчет.СоздатьДокумент();
		Возврат ДокНО.ПроверитьМодуль(ТекстМодуля, ОписаниеОшибки);
	КонецЕсли;
	
КонецФункции

// Возвращает строку обращения к показателю или параметру из строку номер
// НомСтр текста, содержащегося в поле текстового документа на форме.
//
Функция ПолучитьСтрокуОбращенияКПоказателюИЛИПараметру(ТекСтр, нрегСтр)
	
	ПозицияВхождения = СтрНайти(нрег(ТекСтр), нрегСтр);
	Если ПозицияВхождения = 0 Тогда
		Возврат нрегСтр;
	Иначе
		Возврат Сред(ТекСтр, ПозицияВхождения, СтрДлина(нрегСтр));
	КонецЕсли;
	
КонецФункции

Функция ПроверкаПроцедуры(ПолеТекстовогоДокумента, ВидОтчета, ВычисляемыйПоказатель=Ложь, ИспользоватьРасширенныйРасчет = Неопределено) Экспорт
	
	Текст = НРег(ПолеТекстовогоДокумента.ПолучитьТекст());
	
	ВозможныеСимволыКода = нрег("АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789");
	ОписаниеОшибки = "";
	Если НЕ ПроверитьМодуль(Текст, ОписаниеОшибки, ВычисляемыйПоказатель, ВидОтчета, ИспользоватьРасширенныйРасчет) Тогда
		Сообщить(Нстр("ru = 'В модуле заполнения присутствуют синтаксические ошибки!'"));
		Сообщить(ОписаниеОшибки);
		Возврат 1;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ПоказателиОтчетов.Код КАК Код
	                      |ИЗ
	                      |	Справочник.ПоказателиОтчетов КАК ПоказателиОтчетов
	                      |ГДЕ
	                      |	ПоказателиОтчетов.Владелец = &ВидОтчета
	                      |	И (НЕ ПоказателиОтчетов.ПометкаУдаления)
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	Код УБЫВ");
	Запрос.УстановитьПараметр("ВидОтчета", ВидОтчета);
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.Прямой);
	Пока Выборка.Следующий() Цикл
		Текст = СтрЗаменить(Текст, "показатели." + нрег(СокрЛП(Выборка.Код)), "");
	КонецЦикла;
	
	Для Каждого Параметр Из ВидОтчета.ПараметрыОтчета Цикл
		Текст = СтрЗаменить(Текст, "параметры." + нрег(СокрЛП(Параметр.Код)), "");
	КонецЦикла;
	
	Для Каждого Параметр Из Метаданные.Документы.НастраиваемыйОтчет.Реквизиты Цикл
		Текст = СтрЗаменить(Текст, "параметры." + нрег(СокрЛП(Параметр.Имя)), "");
	КонецЦикла;
	
	КоличествоОшибок = 0;
	Если СтрЧислоВхождений(Текст, "показатели.") + СтрЧислоВхождений(Текст, "параметры.") <> 0 Тогда
		Для Инд = 1 По СтрЧислоСтрок(Текст) Цикл
			ТекСтр = СтрПолучитьСтроку(Текст, Инд);
			Если Лев(СокрЛ(ТекСтр), 2) = "//" Тогда
				Продолжить;
			КонецЕсли;
			ПозицияВхождения = СтрНайти(ТекСтр, "показатели.");
			Если ПозицияВхождения <> 0 Тогда
				Если СтрДлина(ТекСтр) < ПозицияВхождения + 10 Тогда
					
					СтрокаШаблона = Нстр("ru = 'Строка %1. Не указан код показателя (Показатели.(?))!'");
					
					Если Не ПустаяСтрока(СтрокаШаблона) тогда						
						Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0")), СтатусСообщения.Важное);
					КонецЕсли;
					
					КоличествоОшибок = КоличествоОшибок + 1;
				Иначе
					НачалоКода = ПозицияВхождения + 11;
					ТекПозиция = НачалоКода;
					Пока ТекПозиция <= СтрДлина(ТекСтр) Цикл
						ТекСимв = Сред(ТекСтр, ТекПозиция, 1);
						Если СтрНайти(ВозможныеСимволыКода, ТекСимв) = 0 Тогда
							
							СтрокаШаблона = Нстр("ru = 'Строка %1. Обращение к несуществующему показателю: ""%2""!'");
							
							Если Не ПустаяСтрока(СтрокаШаблона) тогда						
								Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0"), 
									СокрЛП(ПолучитьСтрокуОбращенияКПоказателюИЛИПараметру(ПолеТекстовогоДокумента.ПолучитьСтроку(Инд), Сред(ТекСтр, ПозицияВхождения, ТекПозиция - ПозицияВхождения)))), СтатусСообщения.Важное);
							КонецЕсли;
							
							КоличествоОшибок = КоличествоОшибок + 1;
							Прервать;
						КонецЕсли;
						ТекПозиция = ТекПозиция + 1;
					КонецЦикла;
					Если ТекПозиция > СтрДлина(ТеКстр) Тогда
						
						СтрокаШаблона = Нстр("ru = 'Строка %1. Обращение к несуществующему показателю: ""%2""!'");
						
						Если Не ПустаяСтрока(СтрокаШаблона) тогда						
							Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0"), 
								СокрЛП(ПолучитьСтрокуОбращенияКПоказателюИЛИПараметру(ПолеТекстовогоДокумента.ПолучитьСтроку(Инд), Сред(ТекСтр, ПозицияВхождения, ТекПозиция - ПозицияВхождения)))), СтатусСообщения.Важное);
						КонецЕсли;
						
						КоличествоОшибок = КоличествоОшибок + 1;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			ПозицияВхождения = СтрНайти(ТекСтр, "параметры.");
			Если ПозицияВхождения <> 0 Тогда
				Если СтрДлина(ТекСтр) < ПозицияВхождения + 9 Тогда
					
					СтрокаШаблона = Нстр("ru = 'Строка %1. Не указан код параметра (Параметры.(?))!'");
					
					Если Не ПустаяСтрока(СтрокаШаблона) тогда						
						Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0")), СтатусСообщения.Важное);
					КонецЕсли;
					
					КоличествоОшибок = КоличествоОшибок + 1;
				Иначе
					НачалоКода = ПозицияВхождения + 10;
					ТекПозиция = НачалоКода;
					Пока ТекПозиция <= СтрДлина(ТекСтр) Цикл
						ТекСимв = Сред(ТекСтр, ТекПозиция, 1);
						Если СтрНайти(ВозможныеСимволыКода, ТекСимв) = 0 Тогда
							
							
							СтрокаШаблона = Нстр("ru = 'Строка %1. Обращение к несуществующему параметру: ""%2""!'");
							
							Если Не ПустаяСтрока(СтрокаШаблона) тогда						
								Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0"), 
									СокрЛП(ПолучитьСтрокуОбращенияКПоказателюИЛИПараметру(ПолеТекстовогоДокумента.ПолучитьСтроку(Инд), Сред(ТекСтр, ПозицияВхождения, ТекПозиция - ПозицияВхождения)))), СтатусСообщения.Важное);
							КонецЕсли;
							
							КоличествоОшибок = КоличествоОшибок + 1;
							Прервать;
						КонецЕсли;
						ТекПозиция = ТекПозиция + 1;
					КонецЦикла;
					Если ТекПозиция > СтрДлина(ТеКстр) Тогда
						
						СтрокаШаблона = Нстр("ru = 'Строка %1. Обращение к несуществующему параметру: ""%2""!'");
						
						Если Не ПустаяСтрока(СтрокаШаблона) тогда						
							Сообщить(СтрШаблон(СтрокаШаблона, Формат(Инд, "ЧГ=0"), 
								СокрЛП(ПолучитьСтрокуОбращенияКПоказателюИЛИПараметру(ПолеТекстовогоДокумента.ПолучитьСтроку(Инд), Сред(ТекСтр, ПозицияВхождения, ТекПозиция - ПозицияВхождения)))), СтатусСообщения.Важное);
						КонецЕсли;
						
						КоличествоОшибок = КоличествоОшибок + 1;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат КоличествоОшибок;
	
КонецФункции

#КонецЕсли