
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НомерТекущейСтраницы = 1;
		
	Если Параметры.РучноеРедактированиеДокументовНеДоступно Тогда
		Элементы.Вариант8Группа.Видимость = Ложь;
		ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаСтажа;
		ОписаниеКорректирующихДокументов = Новый ФиксированныйМассив(Новый Массив);
	Иначе
		ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.РучнойВводДокументов;
		ОписаниеКорректирующихДокументов = Новый ФиксированныйМассив(Параметры.ОписаниеКорректирующихДокументов);
	КонецЕсли;	
		
	Организация = Параметры.Организация;
	ОтчетныйПериод = Параметры.ОтчетныйПериод;
	КорректируемыйПериод = Параметры.КорректируемыйПериод;
	
	КорректируемыйПериодСтрокой = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(КорректируемыйПериод);
		
	УстановитьСвойстваКнопокКоманднойПанели();

	УстановитьСвойстваЭлементовВыбораСотрудников();
	
	КорректируемыйПериодПриИзменении();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетныйПериодСтрокойРегулирование(Элемент, Направление, СтандартнаяОбработка)
	Если КорректируемыйПериод = ПерсонифицированныйУчетКлиентСервер.ПредшествующийОтчетныйПериодПерсУчета(ОтчетныйПериод) 
		И Направление = 1 Тогда 
		
		ПоказатьПредупреждение(, НСтр("ru = 'Корректируемый период должен быть меньше отчетного';
										|en = 'Adjusted period should be earlier than the reporting period '"));
	Иначе	
		ПерсонифицированныйУчетКлиент.ОтчетныйПериодРегулирование(КорректируемыйПериод, КорректируемыйПериодСтрокой, Направление);
	КонецЕсли;	
	
	КорректируемыйПериодПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодСтрокойНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("ТекущийКорректируемыйПериод", КорректируемыйПериод);
	
	Оповещение = Новый ОписаниеОповещения("ОтчетныйПериодСтрокойНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ПерсонифицированныйУчетКлиент.ОтчетныйПериодНачалоВыбора(ЭтаФорма, ЭтаФорма, "КорректируемыйПериод", "КорректируемыйПериодСтрокой", '20100101', ,Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйПериодСтрокойНачалоВыбораЗавершение(Отказ, ДополнительныеПараметры) Экспорт
	
	Если КорректируемыйПериод >= ОтчетныйПериод Тогда		
		ПоказатьПредупреждение(, НСтр("ru = 'Корректируемый период должен быть меньше отчетного';
										|en = 'Adjusted period should be earlier than the reporting period '"));
		
		КорректируемыйПериод = ДополнительныеПараметры.ТекущийКорректируемыйПериод;
		КорректируемыйПериодСтрокой = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(КорректируемыйПериод);
	КонецЕсли;	
	
	КорректируемыйПериодПриИзменении();

КонецПроцедуры

&НаКлиенте
Процедура Вариант1ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант2ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант3ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант4ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант5ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант6ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант7ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура Вариант8ПриИзменении(Элемент)
	УстановитьСвойстваКнопокКоманднойПанели()
КонецПроцедуры

&НаКлиенте
Процедура ОбновлятьДанныеДляВсехСотрудниковПриИзменении(Элемент)
	УстановитьДоступностьСпискаСотрудников(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОбновлятьДанныеДляВыбранныхСотрудниковПриИзменении(Элемент)
	УстановитьДоступностьСпискаСотрудников(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСотрудник

&НаКлиенте
Процедура СписокСотрудниковОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Для Каждого Сотрудник Из ВыбранноеЗначение Цикл
		СтрокаТаблицы = СписокСотрудников.Добавить();
		СтрокаТаблицы.Сотрудник = Сотрудник;
	КонецЦикла;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКорректирующиеДокументы

&НаКлиенте
Процедура КорректирующиеДокументыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодборСотрудников(Команда)
	КадровыйУчетКлиент.ПодобратьФизическихЛицОрганизации(Элементы.СписокСотрудников, Организация, АдресСпискаПодобранныхСотрудников(), Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОК_Далее(Команда)
	Если НомерТекущейСтраницы = 1
		И ВариантФормирования <> ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаНачисленныхУплаченныхВзносов")
		И ВариантФормирования <> ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоОрганизации") Тогда
		
		ПерейтиКСледующейСтранице(1);	
	ИначеЕсли ВариантФормирования = ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.РучнойВводДокументов") Тогда
		ОповеститьОРучномРедактированииСведений();		
	Иначе	
		ОповеститьОФормированииСведений();	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ПерейтиКСледующейСтранице(-1);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСЗВ_6_1(Команда)
	ДобавитьОписаниеКорректируемогоДокумента(Тип("ДокументСсылка.ПачкаДокументовСЗВ_6_1"));
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСЗВ_6_2(Команда)
	ДобавитьОписаниеКорректируемогоДокумента(Тип("ДокументСсылка.РеестрСЗВ_6_2"));
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСЗВ_6_4(Команда)
	ДобавитьОписаниеКорректируемогоДокумента(Тип("ДокументСсылка.ПачкаДокументовСЗВ_6_4"));
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПачкуРазделов6(Команда)
	ДобавитьОписаниеКорректируемогоДокумента(Тип("ДокументСсылка.ПачкаРазделов6РасчетаРСВ_1"));
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРегистрационныйНомерПФРвКорректируемыйПериод(Команда)
	РегНомера = РегНомераПФР(Организация, ОтчетныйПериод, КорректируемыйПериод);
	
	Если Не ЗначениеЗаполнено(РегНомера.РегНомерПФРВКоррПериод) Тогда
		КраткоеПредставлениеКоррПериода = ПерсонифицированныйУчетКлиентСервер.ПредставлениеОтчетногоПериода(КорректируемыйПериод, Истина);
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'На конец %1 для организации не задан регистрационный номер в ПФР.';
																							|en = 'Registration number in PF for the company at the end of %1 is not specified.'"), КраткоеПредставлениеКоррПериода);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		
		Возврат;
	КонецЕсли;
	
	Если РегНомера.РегНомерПФРВКоррПериод = РегНомера.РегНомерПФРТекущий Тогда
		ТекстПредупреждения = НСтр("ru = 'Регистрационные номера в ПФР за корректируемый и отчетный периоды совпадают. В этом случае данное поле не заполняется.';
									|en = 'PF registration numbers for the adjusting and accounting periods match. In such case this field is not filled in.'");
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;	
	КонецЕсли;	
	
	Для Каждого ОписаниеДокумента Из КорректирующиеДокументы Цикл
		ОписаниеДокумента.РегистрационныйНомерПФРвКорректируемыйПериод = РегНомера.РегНомерПФРВКоррПериод;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура КорректируемыйПериодПриИзменении()
	Если КорректируемыйПериод >= '20140101' Тогда
		ДоступностьЭлементов = Ложь;
	Иначе
		ДоступностьЭлементов = Истина;
	КонецЕсли;
	
	Элементы.Вариант3Группа.Видимость = ДоступностьЭлементов;
	Элементы.Вариант5Группа.Видимость = ДоступностьЭлементов;
	Элементы.Вариант6Группа.Видимость = ДоступностьЭлементов;
	Элементы.Вариант7Группа.Видимость = ДоступностьЭлементов;
КонецПроцедуры	

&НаКлиенте
Процедура ОповеститьОФормированииСведений()
	Если ВариантФормирования = ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоЗастрахованномуЛицу")
		Или ВариантФормирования = ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоОрганизации") Тогда 
		
		Если ЕстьКомплектыНеопределенногоСтатуса(Организация, КорректируемыйПериод) Тогда
			ТекстПредупреждения = НСтр("ru = 'В корректируемом периоде ни одному из комплектов не установлено состояние ""Сведения отправлены"". 
                                        |Установите принятому в ПФР комплекту состояние ""Сведения отправлены"", либо загрузите комплект принятый в ПФР.';
                                        |en = 'No set in the adjusted period has the ""Information is sent"" state.
                                        |Set the ""Information is sent"" state to the set received in PF, or import the set received in PF.'");
											
			ПоказатьПредупреждение(, ТекстПредупреждения);	
			
			Возврат;
		КонецЕсли;		

	Иначе 
		Если ЕстьКомплектыНеопределенногоСтатуса(Организация, КорректируемыйПериод) Тогда
			ТекстПредупреждения = НСтр("ru = 'В корректируемом периоде ни одному из комплектов не установлено состояние ""Сведения отправлены"". 
		                                    |Установите принятому в ПФР комплекту состояние ""Сведения отправлены"". 
		                                    |Либо укажите для всех комплектов  состояние ""Сведения не будут передаваться"".';
		                                    |en = 'No set in the adjusted period has the ""Information is sent"" state.
		                                    |Set the ""Information is sent"" state to the set received in PF
		                                    |or specify the ""Information will not be transferred"" state to all sets.'");
											
			ПоказатьПредупреждение(, ТекстПредупреждения);	
			
			Возврат;
		КонецЕсли;		
	КонецЕсли;
	
	ПараметрыФормированияСведений = Новый Структура;
	ПараметрыФормированияСведений.Вставить("ВариантФормирования", ВариантФормирования);
	ПараметрыФормированияСведений.Вставить("КорректируемыйПериод", КорректируемыйПериод);
		
	Если ОбновлятьДанныеДляВсехСотрудников Тогда
		ПараметрыФормированияСведений.Вставить("СписокФизическихЛиц", Неопределено);	
	Иначе
		Если СписокСотрудников.Количество() = 0 
			И ВариантФормирования <> ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаНачисленныхУплаченныхВзносов")
			И ВариантФормирования <> ПредопределенноеЗначение("Перечисление.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоОрганизации") Тогда									
			
			ПоказатьПредупреждение(, НСтр("ru = 'Не заполнен список сотрудников.';
											|en = 'Employee list is not filled in.'"));	
			
			Возврат;
		КонецЕсли;	
		
		ПараметрыФормированияСведений.Вставить("СписокФизическихЛиц", Новый Массив);
		
		Для Каждого СтрокаТаблицы Из СписокСотрудников Цикл 
			ПараметрыФормированияСведений.СписокФизическихЛиц.Добавить(СтрокаТаблицы.Сотрудник);
		КонецЦикла;
	КонецЕсли;	
	
	Оповестить("ФормированиеКорректирующихСведенийПФР", ПараметрыФормированияСведений, ЭтаФорма);
	
	Закрыть();	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция ЕстьКомплектыНеопределенногоСтатуса(Организация, ОтчетныйПериод)
	Возврат Справочники.КомплектыОтчетностиПерсУчета.ЕстьКомплектыНеопределенногоСтатуса(Организация, ОтчетныйПериод);	
КонецФункции

&НаКлиенте
Процедура ОповеститьОРучномРедактированииСведений()
	ОписаниеДокументов = Новый Массив;
	
	Для Каждого ОписаниеДокумента Из КорректирующиеДокументы Цикл
		СтруктураОписанияДокумента = Новый Структура("Ссылка, ПредставлениеДокумента, КатегорияЗастрахованныхЛиц, ТипДоговора, ТипСведенийСЗВ, НомерПачки, РегистрационныйНомерПФРвКорректируемыйПериод");
			
		ЗаполнитьЗначенияСвойств(СтруктураОписанияДокумента, ОписаниеДокумента);
			
		ОписаниеДокументов.Добавить(СтруктураОписанияДокумента);
	КонецЦикла;	
	
	ПараметрыОповещения = Новый Структура("КорректирующиеДокументы, КорректируемыйПериод", ОписаниеДокументов, КорректируемыйПериод);
	
	Оповестить("РучноеРедактированииКорректирующихСведенийПФР", ПараметрыОповещения, ЭтаФорма);
	
	Закрыть();		
КонецПроцедуры	

&НаКлиенте
Функция РежимВыбораПериода(ВыбираемыйПериод) Экспорт
	Год = Год(ВыбираемыйПериод);
	Если Год < 2011 Тогда
		Возврат "Полугодие";
	Иначе
		Возврат "Квартал";
	КонецЕсли; 
КонецФункции

&НаСервере
Процедура УстановитьСвойстваКнопокКоманднойПанели()
	Если НомерТекущейСтраницы = 2 Тогда
		Элементы.ОК_Далее.Заголовок = НСтр("ru = 'ОК';
											|en = 'OK'");
		Элементы.Назад.Видимость = Истина;
	Иначе
		Элементы.Назад.Видимость = Ложь;
		Если ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаНачисленныхУплаченныхВзносов
			Или ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоОрганизации Тогда
			
			Элементы.ОК_Далее.Заголовок = НСтр("ru = 'ОК';
												|en = 'OK'");
		Иначе
			Элементы.ОК_Далее.Заголовок = НСтр("ru = 'Далее';
												|en = 'Next'");
		КонецЕсли;				
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура УстановитьСвойстваЭлементовТекущейСтраницы()
	УстановитьСвойстваКнопокКоманднойПанели();
	
	Если НомерТекущейСтраницы = 2 Тогда
		Элементы.ОтчетныйПериодСтрокой.ТолькоПросмотр = Истина;
		
		Если ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.РучнойВводДокументов Тогда
			Элементы.ЗавершениеДействияСтраницы.ТекущаяСтраница = Элементы.СписокДокументовСтраница;
			
			ЗаполнитьСписокКорректируемыхДокументов();
			УстановитьВидимостьКомандДобавленияДокументов();
			РегистрационныйНомерПФРвКорректируемыйПериод = ПерсонифицированныйУчет.РегНомерПФРВКорректируемыйПериод(Организация, ОтчетныйПериод, КорректируемыйПериод);
		Иначе	
			Элементы.ЗавершениеДействияСтраницы.ТекущаяСтраница = Элементы.ВыборСпискаСотрудниковСтраница;
			УстановитьСвойстваЭлементовВыбораСотрудников();
		КонецЕсли;	
	Иначе
		Элементы.ОтчетныйПериодСтрокой.ТолькоПросмотр = Ложь;
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ПерейтиКСледующейСтранице(Направление)
	НомерТекущейСтраницы = НомерТекущейСтраницы + Направление;	
	
	Если НомерТекущейСтраницы = 1 Тогда
		Элементы.РабочаяОбластьСтраницы.ТекущаяСтраница = Элементы.ВыборВариантаФормированияСведений;
	Иначе
		Элементы.РабочаяОбластьСтраницы.ТекущаяСтраница = Элементы.ЗавершениеДействия;
	КонецЕсли;	
	
	УстановитьСвойстваЭлементовТекущейСтраницы();
КонецПроцедуры	

&НаСервере
Процедура УстановитьСвойстваЭлементовВыбораСотрудников()
	Элементы.ПереключательВыбораСпискаСотрудников.Доступность = Истина;
	ОбновлятьДанныеДляВсехСотрудников = Ложь;

	Если ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаСтажа Тогда
		ВариантыФормированияИнфонадпись = НСтр("ru = 'Стаж будет перезаполнен по текущим кадровым данным. Сведения о взносах и заработке не изменятся, они будут получены из корректируемых документов. Вы можете выбрать сотрудников, по которым необходимо формировать корректирующие сведения или указать что сведения будут сформированы по всем сотрудникам из корректируемых документов.';
												|en = 'Length of service will be refilled by the current HR data. Information about contributions and earnings will not change, they will be received from adjusted documents. You can select employees to generate adjusting information or specify that information will be generated for all employees from the adjusted documents.'");
												
		ТекстВариантаВыбиратьСотрудников = НСтр("ru = 'Корректировать стаж только по выбранным сотрудникам';
												|en = 'Adjust length of service by the selected employees only'");
		ТекстВариантаПоВсемСотрудникам = НСтр("ru = 'Корректировать стаж по всем сотрудникам из корректируемых документов';
												|en = 'Adjust length of service by all employees from adjusted documents'");
	ИначеЕсли ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаНачисленныхВзносов Тогда
		ВариантыФормированияИнфонадпись = НСтр("ru = 'Начисленные взносы и заработок будут перезаполнены. Сведения об уплаченных взносах и стаже не изменятся, они будут получены из корректируемых документов. Вы можете выбрать сотрудников, по которым необходимо формировать корректирующие сведения или указать что сведения будут сформированы по всем сотрудникам из корректируемых документов.';
												|en = 'Accrued contributions and earnings will be refilled. Information about paid contributions and length of service will not change, it will be received from the adjusted documents. You can select employees for whom corrective information should be generated and specify that the information will be generated for all employees from the adjusted documents.'");
												
		ТекстВариантаВыбиратьСотрудников = НСтр("ru = 'Корректировать начисленные взносы только по выбранным сотрудникам';
												|en = 'Adjust accrued contributions by the selected employees only'");
		ТекстВариантаПоВсемСотрудникам = НСтр("ru = 'Корректировать начисленные взносы по всем сотрудникам из корректируемых документов';
												|en = 'Adjust accrued contributions by all employees from adjusted documents'");
		
	ИначеЕсли ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаСтажаИНачисленныхВзносов Тогда
		ВариантыФормированияИнфонадпись = НСтр("ru = 'Начисленные взносы, заработок и стаж будут перезаполнены. Сведения об уплаченных взносах не изменятся, они будут получены из корректируемых документов. Вы можете выбрать сотрудников, по которым необходимо формировать корректирующие сведения или указать что сведения будут сформированы по всем сотрудникам из корректируемых документов.';
												|en = 'Accrued contributions, earnings and length of service will be refilled. Information about paid contributions will not change, it will be received from the adjusted documents. You can select employees for whom corrective information should be generated and specify that the information will be generated for all employees from the adjusted documents.'" );
												
		ТекстВариантаВыбиратьСотрудников = НСтр("ru = 'Корректировать сведения только по выбранным сотрудникам';
												|en = 'Edit information on the selected employees only'");
		ТекстВариантаПоВсемСотрудникам = НСтр("ru = 'Корректировать сведения по всем сотрудникам из корректируемых документов';
												|en = 'Edit information on all employees from adjusted documents'");
	ИначеЕсли ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаСтажаИНачисленныхУплаченныхВзносов Тогда
		ВариантыФормированияИнфонадпись = НСтр("ru = 'Начисленные, уплаченные  взносы и заработок будут перезаполнены для всех сотрудников из корректируемых документов. Вы можете выбрать сотрудников, для которых будут обновлены данные о стаже (для остальных сотрудников в этом случае стаж будет взят из корректируемых документов) или указать, что стаж будет обновлен для всех сотрудников из корректируемых документов.';
												|en = 'Accrued, paid contributions and earnings will be refilled for all employees from the adjusted documents. You can select employees for whom data about length of service will be updated (in this case length of service for other employees will be taken from the adjusted documents) or specify that the length of service will be updated for all employees from the adjusted documents.'");
												
		ТекстВариантаВыбиратьСотрудников = НСтр("ru = 'Обновлять стаж только для выбранных сотрудников';
												|en = 'Update length of service only for the selected employees'");
		ТекстВариантаПоВсемСотрудникам = НСтр("ru = 'Обновлять стаж для всех сотрудников из корректируемых документов';
												|en = 'Update length of service for all employees from the adjusted documents'");
	ИначеЕсли ВариантФормирования = Перечисления.ВариантыФормированияКорректирующихСведенийВПФР.КорректировкаКатегорииПоЗастрахованномуЛицу Тогда
		ВариантыФормированияИнфонадпись = НСтр("ru = 'Выберите данный вариант, если категория застрахованных лиц, по которой были переданы данные по сотруднику, была указана ошибочно. В этом случае будут сформированы исходные сведения по новым категориям, эти сведения необходимо передать в ПФР отдельно. Так же будут сформированы отменяющие сведения по ошибочным категориям и корректирующие сведения по всем сотрудникам комплекта, при этом будут полностью обновлены уплаченные взносы по всем сотрудникам, а по сотрудникам, по которым была ошибочно указана категория, так же будут обновлены начисленные взносы и стаж.';
												|en = 'Select this option if the insured persons'' category according to which data on employee was transferred was specified incorrectly. In this case, the initial data on new categories will be generated, this data should be transferred to PF separately. Canceling information on incorrect categories and adjusting information of all employees of the set will be created. Paid contributions will be updated for all employees, and for employees with incorrectly specified category accrued contributions and length of service will be updated.'");
												
		ТекстВариантаВыбиратьСотрудников = НСтр("ru = 'Обновлять стаж только для выбранных сотрудников';
												|en = 'Update length of service only for the selected employees'");
		ТекстВариантаПоВсемСотрудникам = НСтр("ru = 'Обновлять стаж для всех сотрудников из корректируемых документов';
												|en = 'Update length of service for all employees from the adjusted documents'");
		
		ОбновлятьДанныеДляВсехСотрудников = Ложь;
	КонецЕсли;	
	
	Элементы.ОбновлятьДанныеДляВсехСотрудников.СписокВыбора[0].Представление = ТекстВариантаПоВсемСотрудникам;
	Элементы.ОбновлятьДанныеДляВыбранныхСотрудников.СписокВыбора[0].Представление = ТекстВариантаВыбиратьСотрудников;
	
	УстановитьДоступностьСпискаСотрудников(ЭтаФорма);
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьСпискаСотрудников(Форма)
	Если Форма.ОбновлятьДанныеДляВсехСотрудников Тогда
		Форма.Элементы.СписокСотрудников.Доступность = Ложь;
	Иначе
		Форма.Элементы.СписокСотрудников.Доступность = Истина;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСписокКорректируемыхДокументов()
	КорректирующиеДокументы.Очистить();
	Для Каждого ОписаниеДокумента Из ОписаниеКорректирующихДокументов Цикл
		Если ОписаниеДокумента.КорректируемыйПериод = КорректируемыйПериод Тогда
		
			СтрокаТаблицыДокументов = КорректирующиеДокументы.Добавить();
			
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыДокументов, ОписаниеДокумента);	
		КонецЕсли;	
	КонецЦикла;	
	
	КорректирующиеДокументы.Сортировать("ТипСведенийСЗВ, КатегорияЗастрахованныхЛиц, ТипДоговора");
КонецПроцедуры	

&НаСервере
Процедура УстановитьВидимостьКомандДобавленияДокументов()
	Если КорректируемыйПериод >= '20140101' Тогда	
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_1.Видимость = Ложь;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_2.Видимость = Ложь;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_4.Видимость = Ложь;	
		Элементы.КорректирующиеДокументыДобавитьПачкуРазделов6.Видимость = Истина;	
	ИначеЕсли КорректируемыйПериод >= '20130101' Тогда
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_1.Видимость = Ложь;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_2.Видимость = Ложь;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_4.Видимость = Истина;
		Элементы.КорректирующиеДокументыДобавитьПачкуРазделов6.Видимость = Ложь;
	Иначе
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_1.Видимость = Истина;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_2.Видимость = Истина;
		Элементы.КорректирующиеДокументыДобавитьСЗВ_6_4.Видимость = Ложь;	
		Элементы.КорректирующиеДокументыДобавитьПачкуРазделов6.Видимость = Ложь;
	КонецЕсли;	
КонецПроцедуры	

&НаСервере
Процедура ДобавитьОписаниеКорректируемогоДокумента(ТипДокумента)
	СтрокаТаблицыДокументов = КорректирующиеДокументы.Добавить();
	
	Если ТипДокумента = Тип("ДокументСсылка.ПачкаДокументовСЗВ_6_1") Тогда
		СтрокаТаблицыДокументов.ПредставлениеДокумента = "СВЗ-6-1";
		СтрокаТаблицыДокументов.Ссылка = Документы.ПачкаДокументовСЗВ_6_1.ПустаяСсылка();
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.РеестрСЗВ_6_2") Тогда
		СтрокаТаблицыДокументов.ПредставлениеДокумента = "СВЗ-6-2";
		СтрокаТаблицыДокументов.Ссылка = Документы.РеестрСЗВ_6_2.ПустаяСсылка();
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПачкаДокументовСЗВ_6_4") Тогда
		СтрокаТаблицыДокументов.ПредставлениеДокумента = "СВЗ-6-4";
		СтрокаТаблицыДокументов.Ссылка = Документы.ПачкаДокументовСЗВ_6_4.ПустаяСсылка();
		СтрокаТаблицыДокументов.РегистрационныйНомерПФРвКорректируемыйПериод = РегистрационныйНомерПФРвКорректируемыйПериод;
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.ПачкаРазделов6РасчетаРСВ_1") Тогда
		СтрокаТаблицыДокументов.ПредставлениеДокумента = "Пачка разделов 6";
		СтрокаТаблицыДокументов.Ссылка = Документы.ПачкаРазделов6РасчетаРСВ_1.ПустаяСсылка();
		СтрокаТаблицыДокументов.РегистрационныйНомерПФРвКорректируемыйПериод = РегистрационныйНомерПФРвКорректируемыйПериод;	
	КонецЕсли;	
	
	СтрокаТаблицыДокументов.КатегорияЗастрахованныхЛиц = Перечисления.КатегорииЗастрахованныхЛицДляПФР.НР;
	
	Если КорректируемыйПериод >= '20130101' Тогда 
		СтрокаТаблицыДокументов.ТипДоговора = Перечисления.ТипыДоговоровСЗВ63.Трудовой;
	КонецЕсли;
	
	Если КорректируемыйПериод <= '20140101' Тогда
		СтрокаТаблицыДокументов.ТипСведенийСЗВ = Перечисления.ТипыСведенийСЗВ.КОРРЕКТИРУЮЩАЯ;	
	КонецЕсли;	
КонецПроцедуры	

&НаСервереБезКонтекста
Функция РегНомераПФР(Организация, ОтчетныйПериод, КорректируемыйПериод)
	РегНомерПФРВКоррПериод = ПерсонифицированныйУчет.РегистрационныйНомерПФР(Организация, ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(КорректируемыйПериод));
		
	РегНомерПФРТекущий = ПерсонифицированныйУчет.РегистрационныйНомерПФР(Организация, ПерсонифицированныйУчетКлиентСервер.ОкончаниеОтчетногоПериодаПерсУчета(ОтчетныйПериод));
	
	Возврат Новый Структура("РегНомерПФРВКоррПериод, РегНомерПФРТекущий", РегНомерПФРВКоррПериод, РегНомерПФРТекущий);	
КонецФункции

&НаСервере
Функция АдресСпискаПодобранныхСотрудников()
	
	Возврат ПоместитьВоВременноеХранилище(СписокСотрудников.Выгрузить(,"Сотрудник").ВыгрузитьКолонку("Сотрудник"), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти
