#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	Результат = Новый Массив;
	Результат.Добавить("ТипПолитики");
	
	Результат.Добавить("УчетСерийВНеотфактурованныхПоставкахТоваров");
	Результат.Добавить("УчетТоваровВПутиОтПоставщикаПоСериям");
	
	Результат.Добавить("УказыватьПриОтгрузке");
	Результат.Добавить("УказыватьПриОтгрузкеВРозницу");
	Результат.Добавить("УказыватьПриОтгрузкеКлиенту");
	Результат.Добавить("УказыватьПриОтгрузкеКомплектовДляРазборки");
	Результат.Добавить("УказыватьПриОтгрузкеКомплектующихДляСборки");
	Результат.Добавить("УказыватьПриОтгрузкеНаВнутренниеНужды");
	Результат.Добавить("УказыватьПриОтгрузкеПоВозвратуПоставщику");
	Результат.Добавить("УказыватьПриОтгрузкеПоПеремещению");
	
	Результат.Добавить("УказыватьПриПриемке");
	Результат.Добавить("УказыватьПриПриемкеКомплектующихПослеРазборки");
	Результат.Добавить("УказыватьПриПриемкеОтПоставщика");
	Результат.Добавить("УказыватьПриПриемкеПоВозвратуОтКлиента");
	Результат.Добавить("УказыватьПриВозвратеНепринятыхПолучателемТоваров");
	Результат.Добавить("УказыватьПриПриемкеПоПеремещению");
	Результат.Добавить("УказыватьПриПриемкеПоПрочемуОприходованию");
	Результат.Добавить("УказыватьПриПриемкеСобранныхКомплектов");
	//++ НЕ УТ
	Результат.Добавить("УказыватьПриПриемкеПродукцииИзПроизводства");
	//-- НЕ УТ
	
	Результат.Добавить("УказыватьПриОтраженииИзлишков");
	Результат.Добавить("УказыватьПриОтраженииНедостач");
	Результат.Добавить("УказыватьПриПеремещенииМеждуПомещениями");
	
	//++ НЕ УТ
	Результат.Добавить("УказыватьПриДвиженииМатериалов");
	Результат.Добавить("УказыватьПриПолученииМатериалов");
	Результат.Добавить("УказыватьПриВозвратеНаСклад");
	Результат.Добавить("УказыватьПриРасходеМатериалов");
	Результат.Добавить("УказыватьПриОтраженииЗатратНаПроизводство");
	
	Результат.Добавить("УказыватьПриДвиженииПродукции");
	Результат.Добавить("УказыватьПриПроизводствеПродукции");
	Результат.Добавить("УказыватьПриВыпускеВПодразделение");
	Результат.Добавить("УчетСерийВПереданныхНаХранениеТоварах");
	Результат.Добавить("УчитыватьСерииТМЦВЭксплуатации");
	//-- НЕ УТ
	
	Закрыть(Результат);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
