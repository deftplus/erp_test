
Функция ПолучитьИменаСубконто() Экспорт 

	Результат = Новый Структура;
	
	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетСписанияПриВыбытииСубконто1");
	Субконто.Вставить(2, "СчетСписанияПриВыбытииСубконто2");
	Субконто.Вставить(3, "СчетСписанияПриВыбытииСубконто3");
	
	Результат.Вставить("СчетСписанияПриВыбытии", Субконто);
	
	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетВыбытияВНАСубконто1");
	Субконто.Вставить(2, "СчетВыбытияВНАСубконто2");
	Субконто.Вставить(3, "СчетВыбытияВНАСубконто3");
	
	Результат.Вставить("СчетВыбытияВНА", Субконто);
	
	Возврат Результат;
	
КонецФункции