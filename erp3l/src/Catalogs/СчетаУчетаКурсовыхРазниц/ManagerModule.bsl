
#Область ИменаСубконто

Функция ПолучитьИменаСубконто() Экспорт 

	Результат = Новый Структура;
	
	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетУчетаПрибылиСубконто1");
	Субконто.Вставить(2, "СчетУчетаПрибылиСубконто2");
	Субконто.Вставить(3, "СчетУчетаПрибылиСубконто3");
	
	Результат.Вставить("СчетУчетаПрибыли", Субконто);
	
	Субконто = Новый Соответствие;
	Субконто.Вставить(1, "СчетУчетаУбыткаСубконто1");
	Субконто.Вставить(2, "СчетУчетаУбыткаСубконто2");
	Субконто.Вставить(3, "СчетУчетаУбыткаСубконто3");
	
	Результат.Вставить("СчетУчетаУбытка", Субконто);
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти