
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ПереключательСменаПодписи = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"НастройкиПользователя",
		"НастройкиСменыПодписи",
		ПодписиДокументовКлиентСервер.НастройкиСменыПодписи().ВызыватьДиалог);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)

	СохранитьНастройкиСменыПодписи();
	Закрыть();

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНастройкиПодписей(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОчиститьНастройкиПодписейПродолжение", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Сохраненные настройки подписей будут очищены. Продолжить?';
									|en = 'The saved signature settings will be cleared. Continue?'"), РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОчиститьНастройкиПодписейПродолжение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекУдалить("НастройкиПользователя", "ПодписиДокументов", ИмяПользователя());
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекУдалить("НастройкиПользователя", "ПодписиПоВидамДокументов", ИмяПользователя());
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСменыПодписи()

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НастройкиПользователя", "НастройкиСменыПодписи", ПереключательСменаПодписи);

КонецПроцедуры

#КонецОбласти


