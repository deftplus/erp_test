
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОрганизацияБазис     = Параметры.ОрганизацияБазис;
	ОрганизацияСравнение = Параметры.ОрганизацияСравнение;
	ПоказательБазис      = Параметры.ПоказательБазис;
	ПоказательСравнение  = Параметры.ПоказательСравнение;
	
	ЗначениеВРеквизитФормы(ПолучитьИзВременногоХранилища(Параметры.АдресТаблицы), "ТабличноеПолеАналитики");
	УдалитьИзВременногоХранилища(Параметры.АдресТаблицы);
	
КонецПроцедуры
