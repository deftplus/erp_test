
&НаКлиенте
Процедура ЗаписатьКомментарий(Команда)
	
	СтрокаШаблона = Нстр("ru = 'Значение показателя: %1. '");
	
	ТекстКомментария = "";
	Если Не ПустаяСтрока(СтрокаШаблона) тогда
		ТекстКомментария = СтрШаблон(СтрокаШаблона, Строка(ЗначениеПоказателя));	
	КонецЕсли;
	
	ТекстКомментария = ?(ЗначениеЗаполнено(ЗначениеПоказателя), ТекстКомментария, "") + НовыйКомментарий;
	
	Если ЗначениеЗаполнено(ТекстКомментария) Тогда
		
		НовыйКомментарий=""; // Сбросим текстовое поле.
		НовСтр=Комментарии.Добавить();
		НовСтр.ДатаКомментария=ТекущаяДата();
		НовСтр.Автор=Автор;
		НовСтр.Комментарий=ТекстКомментария;
		Элементы.Комментарии.ТекущаяСтрока = Комментарии[Комментарии.Количество() - 1];
	КонецЕсли;
	
	Оповестить("ЗаписанКомментарий", Показатель, ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Показатель = Параметры.Показатель;
	ПоказательКод = Параметры.Показатель.Код;
	Автор=ОбщегоНазначенияУХ.ПолучитьЗначениеПеременной("глТекущийПользователь");
	ТЗКомментариев=ЗначениеИзСтрокиВнутр(Параметры.ТЗКоментариев);
	Для Каждого Стр Из ТЗКомментариев Цикл
		НовСтр=Комментарии.Добавить();
		НовСтр.ДатаКомментария=Стр.Период;
		НовСтр.Автор=Стр.Автор;
		НовСтр.Комментарий=Стр.Комментарий;
	КонецЦикла;
	
	
КонецПроцедуры
