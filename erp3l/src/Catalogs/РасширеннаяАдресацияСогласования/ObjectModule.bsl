#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	ТекстПроцедуры = 
	"//Запрос = Новый Запрос;
	|//Запрос.Текст = ""ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|//|	ЗаявкаНаРасходованиеДенежныхСредствДвиженияОперации.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|//|	ОтветственныеОрганизаций.Пользователь КАК Пользователь
	|//|ИЗ
	|//|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.ДвиженияОперации КАК ЗаявкаНаРасходованиеДенежныхСредствДвиженияОперации
	|//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОтветственныеОрганизаций КАК ОтветственныеОрганизаций
	|//|		ПО ЗаявкаНаРасходованиеДенежныхСредствДвиженияОперации.СтатьяДвиженияДенежныхСредств = ОтветственныеОрганизаций.Организация
	|//|ГДЕ
	|//|	ЗаявкаНаРасходованиеДенежныхСредствДвиженияОперации.Ссылка = &Ссылка
	|//|	И ОтветственныеОрганизаций.Роль = &Роль
	|//|
	|//|УПОРЯДОЧИТЬ ПО
	|//|	Пользователь"";
	|//Роль = Справочники.РолиКонтактныхЛиц.НайтиПоНаименованию(""Ответственный за статью бюджета"");
	|//Запрос.УстановитьПараметр(""Ссылка"", ДокументПроцессаВход.КлючевойОбъектПроцесса);
	|//Запрос.УстановитьПараметр(""Роль"", Роль);
	|//РезультатЗапроса = Запрос.Выполнить();
	|//Выгрузка = РезультатЗапроса.Выгрузить();
	|//ЗначениеПараметра = Новый Массив;
	|//Если Выгрузка.Количество() > 0 Тогда
	|//	ПерваяСтрока = Выгрузка[0];
	|//	ЗначениеПараметра.Добавить(ПерваяСтрока.Пользователь);
	|//Иначе
	|//	ЗначениеПараметра = Новый Массив;
	|//КонецЕсли;";
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	// Сгенерируем наименование автоматически, если оно не задано.
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ВидРасширеннойАдресацииСогласования",	 ВидРасширеннойАдресацииСогласования);
		СтруктураПараметров.Вставить("РеквизитПользователя",				 РеквизитПользователя);
		СтруктураПараметров.Вставить("АдресацияРуководителю",				 АдресацияРуководителю);
		СтруктураПараметров.Вставить("УровеньРуководителя",					 УровеньРуководителя);
		СтруктураПараметров.Вставить("РольАдресации",						 РольАдресации);
		СтруктураПараметров.Вставить("РеквизитОбъектаРолевойАдресации",		 РеквизитОбъектаРолевойАдресации);
		СтруктураПараметров.Вставить("ФиксированныйОбъектАдресации",		 ФиксированныйОбъектАдресации);
		СтруктураПараметров.Вставить("Владелец",							 Владелец);
		Наименование = Справочники.РасширеннаяАдресацияСогласования.СгенерироватьНовоеНаименование(СтруктураПараметров);
	Иначе
		// Наименование уже задано.
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
