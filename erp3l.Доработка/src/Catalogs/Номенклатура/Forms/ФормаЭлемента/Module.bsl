
&НаСервере
Процедура ллл_ПриСозданииНаСервереПеред(Отказ, СтандартнаяОбработка)
	
	// +++ 3L; Лопатин; 03.08.2022; https://jira.corp.3l.ru/browse/ERP1C-228
	//Вывод реквизита на форму
	ПолеВвода = Элементы.Добавить("ллл_Бренд", Тип("ПолеФормы"), Элементы.ГруппаОписания);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ллл_Бренд";
	// --- 3L; Лопатин; 03.08.2022; https://jira.corp.3l.ru/browse/ERP1C-228
	
КонецПроцедуры
