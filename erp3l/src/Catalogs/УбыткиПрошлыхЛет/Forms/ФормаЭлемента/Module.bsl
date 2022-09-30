#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ГодУбытка = Год(Объект.ДатаНачалаСписания) - 1;
	
	Элементы.ГодУбытка.Видимость = (Объект.ВидРБП = Перечисления.ВидыРБП.УбыткиПрошлыхЛет);	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГодУбыткаПриИзменении(Элемент)
	
	Объект.ДатаНачалаСписания = Дата(ГодУбытка+1,1,1);
	Объект.ДатаОкончанияСписания = ДобавитьМесяц(Объект.ДатаНачалаСписания,120)-1;
	
КонецПроцедуры

#КонецОбласти
