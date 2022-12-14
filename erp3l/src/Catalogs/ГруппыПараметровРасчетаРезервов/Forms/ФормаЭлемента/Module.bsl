
&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	УправлениеФормой(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.Владелец.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПараметрыРасчетаРезервовПоДЗ");//нельзя выбирать неиспользуемый тип		
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.ГруппаДиапазон.Видимость = ДоступенДиапазон(Форма.Объект.Владелец);	

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДоступенДиапазон(Владелец)
    
    ТипПараметраРасчетный = ПредопределенноеЗначение("Перечисление.ТипыПараметровРасчетаРезерва.Вычисляемый");    
    Возврат ТипЗнч(Владелец) = Тип("СправочникСсылка.ПараметрыРасчетаРезервовПоДЗ") 
				И Не Владелец.Пустая() И (Владелец.ТипПараметраРасчетаРезервов = ТипПараметраРасчетный);
    
КонецФункции
 