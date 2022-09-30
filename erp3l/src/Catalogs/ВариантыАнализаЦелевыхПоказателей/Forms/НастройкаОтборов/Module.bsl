
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ИнициализироватьКомпоновщикНастроек(Параметры.АдресаСхемыКомпоновкиДанных, Параметры.АдресПользовательскихНастроек);
	
	АдресаСхемыКомпоновкиДанных = Параметры.АдресаСхемыКомпоновкиДанных;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	АдресПользовательскихНастроек = ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	Закрыть(АдресПользовательскихНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтандартныеНастройки(Команда)
	
	КомпоновщикНастроек = Неопределено;
	
	ИнициализироватьКомпоновщикНастроек(АдресаСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере 
Процедура ИнициализироватьКомпоновщикНастроек(АдресаСхемыКомпоновкиДанных, АдресПользовательскихНастроек = Неопределено)
	
	СКДВариантаАнализа = ПолучитьИзВременногоХранилища(АдресаСхемыКомпоновкиДанных.СхемаКомпоновкиДанных);
	
	АдресСКД = ПоместитьВоВременноеХранилище(СКДВариантаАнализа, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
		
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	Если НЕ АдресаСхемыКомпоновкиДанных.НастройкиКомпоновкиДанных = Неопределено Тогда
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресаСхемыКомпоновкиДанных.НастройкиКомпоновкиДанных);
		
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
		
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СКДВариантаАнализа.НастройкиПоУмолчанию);
		
	КонецЕсли;
	
	Если Не АдресПользовательскихНастроек = Неопределено Тогда
		ПользовательскиеНастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресПользовательскихНастроек);
	
		Если НЕ ПользовательскиеНастройкиКомпоновкиДанных = Неопределено Тогда
			КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройкиКомпоновкиДанных);
		КонецЕсли;
		
	Иначе 
		КомпоновщикНастроек.Восстановить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
