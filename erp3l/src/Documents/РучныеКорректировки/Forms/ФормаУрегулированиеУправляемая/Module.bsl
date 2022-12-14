
///////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛНЯЕМЫЕ НА СЕРВЕРЕ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РабочийОбъектАдрес=Параметры.РабочийОбъектАдрес;
	СтрокаЭлиминации=Параметры.СтрокаЭлиминации;
	ИдентификаторРодителя=Параметры.ИдентификаторРодителя;
	
	Если ТипЗнч(Параметры.ТабличноеПолеСравнение)=Тип("Массив") Тогда
		
		ЗначениеВРеквизитФормы(ПроцедурыПреобразованияДанныхУХ.ПолучитьТаблицуИзМассиваСтруктур(Параметры.ТабличноеПолеСравнение),"ТабличноеПолеСравнение");
		
	КонецЕсли;
	
	Если Параметры.Элиминация Тогда
		
		ЗаполнитьТаблицыЭлиминации(Отказ);
		Элементы.НадписьРасхождение.Заголовок="Баланс элиминации: "+Формат((ТабличноеПолеБазис.Итог("Элиминация")-ТабличноеПолеСравнение.Итог("Элиминация")),"ЧЦ=18; ЧДЦ=5; ЧН=Ноль");
        Заголовок="Формирование таблиц элиминации";
		
	Иначе
		
		ЗаполнитьТаблицыАналитикУрегулирования();
		Элементы.НадписьРасхождение.Заголовок="Текущее расхождение: "+Формат(ТабличноеПолеСравнение.Итог("РасхождениеПослеУрегулирования"),"ЧЦ=18; ЧДЦ=5; ЧН=Отсутствует");
		Заголовок="Урегулирование по группам раскрытия";
		
	КонецЕсли;
	
	Элементы.НадписьБазис.Заголовок="Базисные данные. Организация: "+СокрЛП(СтрокаЭлиминации.ОрганизацияБазис)+", вид отчета: "+СтрокаЭлиминации.ПоказательБазис.Владелец+", показатель: "+СокрЛП(СтрокаЭлиминации.ПоказательБазис.Наименование);
	Элементы.НадписьСравнение.Заголовок="Данные для сравнения. Организация: "+СокрЛП(СтрокаЭлиминации.ОрганизацияСравнение)+", вид отчета: "+СтрокаЭлиминации.ПоказательСравнение.Владелец+", показатель: "+СокрЛП(СтрокаЭлиминации.ПоказательСравнение.Наименование);
		
	УстановитьВидимостьКолонок();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРабочийОбъект()
	
	РабочийОбъект=ОбщегоНазначенияУХ.ПолучитьРабочийОбъект(РабочийОбъектАдрес);
		
	Возврат РабочийОбъект;
		
КонецФункции // ПолучитьСправочникОбъект()

&НаСервере
Процедура ПоместитьРабочийОбъект(РабочийОбъект)
	
	РабочийОбъектАдрес=ПоместитьВоВременноеХранилище(РабочийОбъект.ПодготовитьСтруктуруПеременныхДляРасчета(),ИдентификаторРодителя);
					
КонецПроцедуры // ПолучитьСправочникОбъект()

&НаСервере
Процедура ОбновитьОбъектВХранилище()
	
	РабочийОбъект=ПолучитьРабочийОбъект();
	РабочийОбъектАдрес=ПоместитьВоВременноеХранилище(РабочийОбъект.ПодготовитьСтруктуруПеременныхДляРасчета(),ИдентификаторРодителя);
	
КонецПроцедуры // ОбновитьОбъектВХранилище()


&НаСервере
Процедура ЗаполнитьТаблицыЭлиминации(Отказ,ОбновитьДанные=Ложь)
	
	Если СтрокаЭлиминации.ТабЭлиминации.Количество()=2 И (НЕ ОбновитьДанные)Тогда
		
		СписокТаблиц=ПроцедурыПреобразованияДанныхУХ.ПреобразоватьСписокМассивовДляСервера(СтрокаЭлиминации.ТабЭлиминации);
		
	Иначе
		
		РабочийОбъект=ПолучитьРабочийОбъект();
		
		СписокТаблиц=РабочийОбъект.ПолучитьТаблицыЭлиминации(СтрокаЭлиминации,Параметры.ВалютаОтчета,Параметры.ПериодОтчета,Параметры.Сценарий);
		
		Если НЕ СписокТаблиц.Количество()=2 Тогда
			
			Сообщить("Не сформированы элиминационные таблицы.");
			Отказ=Истина;
			Возврат;
			
		КонецЕсли;
		
		ПоместитьРабочийОбъект(РабочийОбъект);
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(СписокТаблиц[0].Значение,"ТабличноеПолеБазис");
	ЗначениеВРеквизитФормы(СписокТаблиц[1].Значение,"ТабличноеПолеСравнение");
					
КонецПроцедуры // ЗаполнитьТаблицыЭлиминации()

&НаСервере
Процедура ЗаполнитьТаблицыАналитикУрегулирования(ОбновитьСравнение=Ложь)
	
	ТекстАналитикБазис="";
	ТекстГруппировкиБазис="";
	ТекстГруппировкиСравнение="";
	ТекстАналитикСравнение="";
	
	ТабличноеПолеБазис.Очистить();
	
	РабочийОбъект=ПолучитьРабочийОбъект();
	
	Если СтрокаЭлиминации.ТабСоответствияАналитик.Количество()>0 И ТипЗнч(СтрокаЭлиминации.ТабСоответствияАналитик[0].Значение)=Тип("Массив") Тогда
		
		ТабАналитики=ПроцедурыПреобразованияДанныхУХ.ПолучитьТаблицуИзМассиваСтруктур(СтрокаЭлиминации.ТабСоответствияАналитик[0].Значение);
		
		Для Каждого СтрСоответствие ИЗ ТабАналитики Цикл
			
			Если СтрСоответствие.КодАналитикиБазис="Аналитика"+СтрокаЭлиминации.АналитикаВГОБазис
				ИЛИ СтрСоответствие.КодАналитикиСравнение="Аналитика"+СтрокаЭлиминации.АналитикаВГОСравнение Тогда
				
				// по внутригрупповой аналитике не разделяем
				
				Продолжить;
				
			КонецЕсли;
			
			ТекстАналитикБазис=ТекстАналитикБазис+",
			|##."+СтрСоответствие.КодАналитикиБазис;
			
			ТекстАналитикСравнение=ТекстАналитикСравнение+",
			|##."+СтрСоответствие.КодАналитикиСравнение+" КАК "+СтрСоответствие.КодАналитикиСравнение;
				
			ТекстГруппировкиБазис=ТекстГруппировкиБазис+",
			|##."+СтрСоответствие.КодАналитикиБазис;
			
			ТекстГруппировкиСравнение=ТекстГруппировкиСравнение+",
			|##."+СтрСоответствие.КодАналитикиСравнение;
			
		КонецЦикла;
		
		ТекстАналитикБазис=Сред(ТекстАналитикБазис,2);
		ТекстАналитикСравнение=Сред(ТекстАналитикСравнение,2);
		ТекстГруппировкиСравнение=Сред(ТекстГруппировкиСравнение,2);
		ТекстГруппировкиБазис=Сред(ТекстГруппировкиБазис,2);
		
	КонецЕсли;
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ";
	Если СтрДлина(ТекстАналитикБазис)>0 Тогда
		Запрос.Текст=Запрос.Текст+"
		|"+СтрЗаменить(ТекстАналитикБазис,"##","ЗначенияПоказателейОтчетов")+",";
	КонецЕсли;
	Запрос.Текст=Запрос.Текст+"
	|	СУММА(ЗначенияПоказателейОтчетов.Значение) КАК Значение
	|ИЗ
	|	РегистрСведений.ЗначенияПоказателейОтчетов"+СтрокаЭлиминации.ГруппаРаскрытияБазис.ЧислоАналитик+" КАК ЗначенияПоказателейОтчетов
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВерсииЗначенийПоказателей КАК ВерсииЗначенийПоказателей 
	|	ПО ЗначенияПоказателейОтчетов.Версия=ВерсииЗначенийПоказателей.Ссылка
	|ГДЕ
	|	ЗначенияПоказателейОтчетов.Показатель = &Показатель
	|	И ВерсииЗначенийПоказателей.Регистратор <> &ТекущийДокумент
	|	И ВерсииЗначенийПоказателей.Валюта = &Валюта
	|	И ВерсииЗначенийПоказателей.Организация = &Организация
	|	И ВерсииЗначенийПоказателей.ПериодОтчета = &ПериодОтчета
	|	И ВерсииЗначенийПоказателей.Сценарий = &Сценарий
	|	И ЗначенияПоказателейОтчетов.Аналитика"+СтрокаЭлиминации.АналитикаВГОБазис+" = &ОрганизацияСравнение";
	
	Если СтрДлина(ТекстГруппировкиБазис)>0 Тогда
		Запрос.Текст=Запрос.Текст+"
		
		|  СГРУППИРОВАТЬ ПО
		|"+СтрЗаменить(ТекстГруппировкиБазис,"##","ЗначенияПоказателейОтчетов");
		
	КонецЕсли;	
	
	Запрос.УстановитьПараметр("Показатель",СтрокаЭлиминации.ПоказательБазис);
	Запрос.УстановитьПараметр("Валюта",Параметры.ВалютаОтчета);
	Запрос.УстановитьПараметр("ПериодОтчета",Параметры.ПериодОтчета);
	Запрос.УстановитьПараметр("Сценарий",Параметры.Сценарий);
	Запрос.УстановитьПараметр("Организация",СтрокаЭлиминации.ОрганизацияБазис);
	Запрос.УстановитьПараметр("ОрганизацияСравнение",СтрокаЭлиминации.ОрганизацияСравнение);
	Запрос.УстановитьПараметр("ТекущийДокумент",РабочийОбъект.Ссылка);
	
	Результат=Запрос.Выполнить().Выбрать();
	
	Пока Результат.Следующий() Цикл
		
		СтрБазис=ТабличноеПолеБазис.Добавить();
		ЗаполнитьЗначенияСвойств(СтрБазис,Результат);
		
	КонецЦикла;
	
	Если ТабличноеПолеСравнение.Количество()>0 И (НЕ ОбновитьСравнение) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(РабочийОбъект.ПолучитьТаблицуУрегулированияПоАналитике(СтрокаЭлиминации,Параметры.ВалютаОтчета,Параметры.ПериодОтчета,Параметры.Сценарий),"ТабличноеПолеСравнение");
	
	ПоместитьРабочийОбъект(РабочийОбъект);
	
КонецПроцедуры // ЗаполнитьТаблицыАналитик()

&НаСервере
Процедура УстановитьВидимостьКолонок()
	
	Если СтрокаЭлиминации.ТабСоответствияАналитик.Количество()>0 И ТипЗнч(СтрокаЭлиминации.ТабСоответствияАналитик[0].Значение)=Тип("Массив") Тогда
				
		ТабАналитики=ПроцедурыПреобразованияДанныхУХ.ПолучитьТаблицуИзМассиваСтруктур(СтрокаЭлиминации.ТабСоответствияАналитик[0].Значение);
		
		Для Инд=1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
						
			Элементы.ТабличноеПолеБазис.ПодчиненныеЭлементы["ТабличноеПолеБазисАналитика"+Инд].Видимость=НЕ (ТабАналитики.Найти("Аналитика"+Инд,"КодАналитикиБазис")=Неопределено ИЛИ Инд=СтрокаЭлиминации.АналитикаВГОБазис);
			Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы["ТабличноеПолеСравнениеАналитика"+Инд].Видимость=НЕ (ТабАналитики.Найти("Аналитика"+Инд,"КодАналитикиСравнение")=Неопределено ИЛИ Инд=СтрокаЭлиминации.АналитикаВГОСравнение);
		
		КонецЦикла;

	Иначе
		
		Для Инд=1 По ПараметрыСеанса.ЧислоДопАналитик Цикл
						
			Элементы.ТабличноеПолеБазис.ПодчиненныеЭлементы["ТабличноеПолеБазисАналитика"+Инд].Видимость=Ложь;
			Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы["ТабличноеПолеСравнениеАналитика"+Инд].Видимость=Ложь;
		
		КонецЦикла;	
	
	КонецЕсли;
	
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеЗначениеБазис.Видимость=НЕ Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеРасхождение.Видимость=НЕ Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеРасхождениеПослеУрегулирования.Видимость=НЕ Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеЗначениеСравнение.Видимость=НЕ Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеУрегулирование.Видимость=НЕ Параметры.Элиминация;
	
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеПараметры.Элиминация.Видимость=Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеЗначениеПослеЭлиминации.Видимость=Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнение.ПодчиненныеЭлементы.ТабличноеПолеСравнениеЗначение.Видимость=Параметры.Элиминация;

	Элементы.ТабличноеПолеБазис.ПодчиненныеЭлементы.ТабличноеПолеБазисПараметры.Элиминация.Видимость=Параметры.Элиминация;
	Элементы.ТабличноеПолеБазис.ПодчиненныеЭлементы.ТабличноеПолеБазисЗначениеПослеЭлиминации.Видимость=Параметры.Элиминация;

		
	Элементы.ФормаКоманднаяПанель.ПодчиненныеЭлементы.ФормаОбновитьФорму.Доступность=Параметры.Элиминация;
	Элементы.ТабличноеПолеСравнениеКоманднаяПанель.ПодчиненныеЭлементы.ТабличноеПолеСравнениеОбновитьДанныеДляСравнения.Доступность=НЕ Параметры.Элиминация;
				
КонецПроцедуры // УстановитьВидимостьКолонок()

&НаСервере
Функция ПодготовитьСтруктуруОтвета()
	
	СтруктураДанныхФормы=Новый Структура;
	СтруктураДанныхФормы.Вставить("РабочийОбъектАдрес",РабочийОбъектАдрес);
	
	Если Параметры.Элиминация Тогда
					
		ТабЭлиминации=Новый СписокЗначений;
		ТабЭлиминации.Вставить(0,ПроцедурыПреобразованияДанныхУХ.ПолучитьМассивСтруктурИЗТаблицы(РеквизитФормыВЗначение(ТабличноеПолеБазис)));
		ТабЭлиминации.Вставить(1,ПроцедурыПреобразованияДанныхУХ.ПолучитьМассивСтруктурИЗТаблицы(РеквизитФормыВЗначение(ТабличноеПолеСравнение)));
		
		СтруктураДанныхФормы.Вставить("ТабЭлиминации",ТабЭлиминации);
		СтруктураДанныхФормы.Вставить("ЭлиминационнаяПоправка",ТабличноеПолеБазис.Итог("Элиминация"));
		
	Иначе	
		
		СтруктураДанныхФормы.Вставить("ТабУрегулированиеАналитики",ПроцедурыПреобразованияДанныхУХ.ПолучитьМассивСтруктурИЗТаблицы(РеквизитФормыВЗначение(ТабличноеПолеСравнение)));
				
	КонецЕсли;
	
	Возврат СтруктураДанныхФормы;
		
КонецФункции // ПодготовитьСтруктуруОтвета()


///////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ, ИСПОЛНЯЕМЫЕ НА КЛИЕНТЕ

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	
	ЗаполнитьТаблицыЭлиминации(Ложь,Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеДляСравнения(Команда)
	
	ЗаполнитьТаблицыАналитикУрегулирования(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеСравнениеУрегулированиеПриИзменении(Элемент)
	
	Элементы.ТабличноеПолеСравнение.ТекущиеДанные.РасхождениеПослеУрегулирования=Элементы.ТабличноеПолеСравнение.ТекущиеДанные.ЗначениеБазис-(Элементы.ТабличноеПолеСравнение.ТекущиеДанные.ЗначениеСравнение+Элементы.ТабличноеПолеСравнение.ТекущиеДанные.Урегулирование);
	Элементы.НадписьРасхождение.Заголовок="Текущее расхождение: "+Формат(ТабличноеПолеСравнение.Итог("РасхождениеПослеУрегулирования"),"ЧЦ=18; ЧДЦ=5; ЧН=Отсутствует");
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеФормы(Команда)
	
	Если Параметры.Элиминация Тогда
		
		Если НЕ Окр((ТабличноеПолеБазис.Итог("Элиминация")-ТабличноеПолеСравнение.Итог("Элиминация")),0)=0 Тогда
			
			Сообщить("Не соблюден баланс элиминационных поправок.",СтатусСообщения.Важное);
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
				
	Закрыть(ПодготовитьСтруктуруОтвета());
					
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСтрокуЭлиминации(СтрокаЭлиминации)
	
	СтрокаЭлиминации.ЗначениеПослеЭлиминации=СтрокаЭлиминации.Значение-СтрокаЭлиминации.Элиминация;
	
КонецПроцедуры // РассчитатьСтрокуЭлиминации()

&НаКлиенте
Процедура ТабличноеПолеБазисЭлиминацияПриИзменении(Элемент)
	
	РассчитатьСтрокуЭлиминации(Элементы.ТабличноеПолеБазис.ТекущиеДанные);
	
	Если ТабличноеПолеБазис.Количество()=1 И ТабличноеПолеСравнение.Количество()=1 Тогда
		
		ТабличноеПолеСравнение[0].Элиминация=ТабличноеПолеБазис[0].Элиминация;
		РассчитатьСтрокуЭлиминации(ТабличноеПолеСравнение[0]);
		
	КонецЕсли;
	
	Элементы.НадписьРасхождение.Заголовок="Баланс элиминации: "+Формат((ТабличноеПолеБазис.Итог("Элиминация")-ТабличноеПолеСравнение.Итог("Элиминация")),"ЧЦ=18; ЧДЦ=5; ЧН=Ноль");
	
КонецПроцедуры

&НаКлиенте
Процедура ТабличноеПолеСравнениеЭлиминацияПриИзменении(Элемент)
	
	РассчитатьСтрокуЭлиминации(Элементы.ТабличноеПолеСравнение.ТекущиеДанные);
	
	Если ТабличноеПолеБазис.Количество()=1 И ТабличноеПолеСравнение.Количество()=1 Тогда
		
		ТабличноеПолеБазис[0].Элиминация=ТабличноеПолеСравнение[0].Элиминация;
		РассчитатьСтрокуЭлиминации(ТабличноеПолеБазис[0]);
		
	КонецЕсли;

	Элементы.НадписьРасхождение.Заголовок="Баланс элиминации: "+Формат((ТабличноеПолеБазис.Итог("Элиминация")-ТабличноеПолеСравнение.Итог("Элиминация")),"ЧЦ=18; ЧДЦ=5; ЧН=Ноль");
	
КонецПроцедуры
