
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.Заголовок="Тип данных ("+Параметры.ИмяОбъекта+","+Параметры.ТекстПоля+")";
	
	МассивТипов=ОбщегоНазначенияУХ.РазложитьСтрокуВМассивПодстрок(Параметры.ТипДанных,";");
	
	Для Каждого Строка ИЗ МассивТипов Цикл 
		
		НоваяСтрока=ТаблицаТипов.Добавить();
		НоваяСтрока.СтрокаТип=Строка;
		
	КонецЦикла;
	
	ТаблицаТипов.Сортировать("СтрокаТип Возр");
	
КонецПроцедуры
