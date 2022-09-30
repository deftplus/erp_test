
#Область ПрограммныйИнтерфейсСлужебный

Процедура НачатьВыгрузкуДанныхНаККМ(ИдентификаторУстройства,
	УникальныйИдентификатор, ОповещениеПриЗавершении, ОтображатьСообщения = Истина) Экспорт
	
	НаборВыгружаемыхДанных = Новый Структура;
	НаборВыгружаемыхДанных.Вставить("Настройки", Истина);
	НаборВыгружаемыхДанных.Вставить("ПрайсЛист", Истина);
	НаборВыгружаемыхДанных.Вставить("Заказы",	 Истина);
	НаборВыгружаемыхДанных.Вставить("ПолныйПрайсЛист", Ложь);
	
	Контекст = Новый Структура;
	Контекст.Вставить("СледующееОповещение"     , ОповещениеПриЗавершении);
	Контекст.Вставить("УникальныйИдентификатор" , УникальныйИдентификатор);
	Контекст.Вставить("ОтображатьСообщения"     , ОтображатьСообщения);
	Контекст.Вставить("НаборВыгружаемыхДанных"  , НаборВыгружаемыхДанных);
	Контекст.Вставить("Команда", "ВыгрузитьДанные");
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, "ККМОфлайн",
			НСтр("ru = 'Выберите ККМ Офлайн';
				|en = 'Select offline cash register'"), НСтр("ru = 'ККМ Офлайн не подключены';
													|en = 'Offline cash registers are not connected'"));
	
	Иначе
		НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства(ИдентификаторУстройства, Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(ИдентификаторУстройства,
	УникальныйИдентификатор, ОповещениеПриЗавершении, ОтображатьСообщения = Истина) Экспорт
	
	НаборВыгружаемыхДанных = Новый Структура;
	НаборВыгружаемыхДанных.Вставить("Настройки", Ложь);
	НаборВыгружаемыхДанных.Вставить("ПрайсЛист", Ложь);
	НаборВыгружаемыхДанных.Вставить("Заказы",	 Ложь);
	НаборВыгружаемыхДанных.Вставить("ПолныйПрайсЛист", Истина);
	
	Контекст = Новый Структура;
	Контекст.Вставить("СледующееОповещение"     , ОповещениеПриЗавершении);
	Контекст.Вставить("УникальныйИдентификатор" , УникальныйИдентификатор);
	Контекст.Вставить("ОтображатьСообщения"     , ОтображатьСообщения);
	Контекст.Вставить("НаборВыгружаемыхДанных"  , НаборВыгружаемыхДанных);
	Контекст.Вставить("Команда", "ВыгрузитьДанные");
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, "ККМОфлайн",
			НСтр("ru = 'Выберите ККМ Офлайн';
				|en = 'Select offline cash register'"), НСтр("ru = 'ККМ Офлайн не подключены';
													|en = 'Offline cash registers are not connected'"));
	Иначе
		НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства(ИдентификаторУстройства, Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыгрузкуНастроекНаККМ(ИдентификаторУстройства,
	УникальныйИдентификатор, ОповещениеПриЗавершении, ОтображатьСообщения = Истина) Экспорт
	
	НаборВыгружаемыхДанных = Новый Структура;
	НаборВыгружаемыхДанных.Вставить("Настройки", Истина);
	НаборВыгружаемыхДанных.Вставить("ПрайсЛист", Ложь);
	НаборВыгружаемыхДанных.Вставить("Заказы",	 Ложь);
	НаборВыгружаемыхДанных.Вставить("ПолныйПрайсЛист", Ложь);
	
	Контекст = Новый Структура;
	Контекст.Вставить("СледующееОповещение"     , ОповещениеПриЗавершении);
	Контекст.Вставить("УникальныйИдентификатор" , УникальныйИдентификатор);
	Контекст.Вставить("ОтображатьСообщения"     , ОтображатьСообщения);
	Контекст.Вставить("НаборВыгружаемыхДанных"  , НаборВыгружаемыхДанных);
	Контекст.Вставить("Команда", "ВыгрузитьНастройки");
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, "ККМОфлайн",
			НСтр("ru = 'Выберите ККМ Офлайн';
				|en = 'Select offline cash register'"), НСтр("ru = 'ККМ Офлайн не подключены';
													|en = 'Offline cash registers are not connected'"));
	Иначе
		НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства(ИдентификаторУстройства, Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьОчисткуПрайсЛистаНаККМ(ИдентификаторУстройства,
	УникальныйИдентификатор, ОповещениеПриЗавершении, ОтображатьСообщения = Истина) Экспорт
	
	НачатьОчисткуТоваровВККМOffline(ОповещениеПриЗавершении, УникальныйИдентификатор, ИдентификаторУстройства);
	
КонецПроцедуры

Процедура НачатьЗагрузкуДанныхИзККМ(ИдентификаторУстройства,
	УникальныйИдентификатор, ОповещениеПриЗавершении, ОтображатьСообщения = Истина) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("СледующееОповещение"     , ОповещениеПриЗавершении);
	Контекст.Вставить("УникальныйИдентификатор" , УникальныйИдентификатор);
	Контекст.Вставить("ОтображатьСообщения"     , ОтображатьСообщения);
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхИзККМПослеВыбораУстройства", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, "ККМОфлайн",
			НСтр("ru = 'Выберите ККМ Offline';
				|en = 'Select an offline cash register'"), 
			НСтр("ru = 'ККМ Offline не подключены.';
				|en = 'Offline cash registers are not connected.'"),
			НСтр("ru = 'ККМ Offline не выбрано.';
				|en = 'Offline cash register is not selected.'"), 
			НЕ ОтображатьСообщения);
	Иначе
		
		ЭтоПерваяЗагрузкаКассыЭвотор = МенеджерОфлайнОборудованияВызовСервера.ПроверитьИсториюЗагрузкиУстройства(ИдентификаторУстройства);
		
		Если ЭтоПерваяЗагрузкаКассыЭвотор Тогда
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
			
			ОткрытьФорму("ОбщаяФорма.ФормаНастройки1СЭвоторККМOfflineПроизвольногоПериодаЗагрузки", ПараметрыФормы, ЭтотОбъект,,,, ОповещениеПриЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
			
		Иначе
			НачатьЗагрузкуДанныхИзККМПослеВыбораУстройства(ИдентификаторУстройства, Контекст);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНастройки(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	ПараметрыФормы = Новый Структура();
	
	ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииРаботыСОборудованиемККМOffline

#Область КомандаВыгрузкаДанных

Процедура НачатьВыгрузкуДанныхНаККМПослеВыбораУстройства(ИдентификаторУстройства, Параметры) Экспорт // оповещение
	
	Параметры.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
	
	#Если ВебКлиент Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхНаККМПродолжение", ЭтотОбъект, Параметры);
		ПроверитьДоступностьРасширенияРаботыСФайлами(ОписаниеОповещения, Ложь);
	#Иначе
		// В тонком и толстом клиентах расширение подключено всегда.
		НачатьВыгрузкуДанныхНаККМПродолжение(Истина, Параметры);
	#КонецЕсли
	
КонецПроцедуры

Процедура НачатьВыгрузкуДанныхНаККМПродолжение(Подключено, Контекст) Экспорт // оповещение
	
	Если Не Подключено Тогда
		ТекстСообщения = НСтр("ru = 'Данная операция не доступна без установленного расширения для веб-клиента ""1С:Предприятие"".';
								|en = 'The operation is not available without extension for 1C:Enterprise web client installed.'");
		Если Контекст.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		Если Контекст.СледующееОповещение <> Неопределено Тогда
			
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства",
													Ложь, ТекстСообщения, Контекст.ИдентификаторУстройства
			);
			
			ВыполнитьОбработкуОповещения(Контекст.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	
	Результат = МенеджерОборудованияКлиент.ПодключитьОборудованиеПоИдентификатору(
		Контекст.УникальныйИдентификатор,
		Контекст.ИдентификаторУстройства,
		ОписаниеОшибки
	);
	
	Если Результат Тогда
		
		МенеджерОборудованияКлиент.СостояниеПроцесса(НСтр("ru = 'Выполняется выгрузка данных в ККМ Офлайн...';
															|en = 'Exporting data to CRE Offline...'")); 
		
		Параметры = Новый Структура;
		Параметры.Вставить("ИдентификаторУстройства", Контекст.ИдентификаторУстройства);
		Параметры.Вставить("НаборВыгружаемыхДанных", Контекст.НаборВыгружаемыхДанных);
		
		ДанныеДляВыгрузки = МенеджерОфлайнОборудованияВызовСервера.ПолучитьДанныеДляВыгрузки(Параметры);
		
		ВходныеПараметры  = Новый Структура("ДанныеДляВыгрузки", ДанныеДляВыгрузки);
		
		ИмяКоманды = Контекст.Команда;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьВыгрузкуДанныхНаККМЗавершение", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, Контекст.ИдентификаторУстройства, ИмяКоманды, ВходныеПараметры);
		
	Иначе
		
		ТекстСообщения = НСтр("ru = 'При подключении устройства произошла ошибка.
									|%ОписаниеОшибки%';
									|en = 'An error occurred when connecting the device.
									|%ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
		
		Если Контекст.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		Если Контекст.СледующееОповещение <> Неопределено Тогда
			
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства",
													Ложь, ТекстСообщения, Контекст.ИдентификаторУстройства
			);
			
			ВыполнитьОбработкуОповещения(Контекст.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьВыгрузкуДанныхНаККМЗавершение(РезультатКоманды, Параметры) Экспорт // оповещение
	
	Если НЕ РезультатКоманды.Результат Тогда
		ТекстСообщения = НСтр("ru = 'При выгрузке данных в оборудование произошла ошибка.
								|%ОписаниеОшибки%';
								|en = 'An error occurred when exporting data to equipment.
								|%ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", РезультатКоманды.ВыходныеПараметры[1]);
	Иначе
		
		МенеджерОфлайнОборудованияВызовСервера.ОповеститьОбУдачнойВыгрузке(Параметры.ИдентификаторУстройства, Параметры.НаборВыгружаемыхДанных);
		
		ТекстСообщения = НСтр("ru = 'Данные успешно выгружены';
								|en = 'Data is exported successfully'");
	КонецЕсли;
	
	Если Параметры.СледующееОповещение <> Неопределено Тогда
		РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", РезультатКоманды.Результат, ТекстСообщения, Параметры.ИдентификаторУстройства);
		ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(Параметры.УникальныйИдентификатор, Параметры.ИдентификаторУстройства);

КонецПроцедуры

#КонецОбласти

#Область КомандаЗагрузкаДанных

Процедура НачатьЗагрузкуДанныхИзККМПослеВыбораУстройства(ИдентификаторУстройства, Параметры) Экспорт
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Оборудование не выбрано.';
								|en = 'Equipment is not selected.'");
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ТекстСообщения, Неопределено);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
#Если ВебКлиент Тогда
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхИзККМПродолжение", ЭтотОбъект, Параметры);
	ПроверитьДоступностьРасширенияРаботыСФайлами(ОписаниеОповещения, Ложь);
#Иначе
	// В тонком и толстом клиентах расширение подключено всегда.
	НачатьЗагрузкуДанныхИзККМПродолжение(Истина, Параметры);
#КонецЕсли
	
КонецПроцедуры

Процедура НачатьЗагрузкуДанныхИзККМПродолжение(Подключено, Параметры) Экспорт
	
	Если Не Подключено Тогда
		ТекстСообщения = НСтр("ru = 'Данная операция не доступна без установленного расширения для веб-клиента ""1С:Предприятие"".';
								|en = 'The operation is not available without extension for 1C:Enterprise web client installed.'");
		Если Параметры.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства",
													Ложь, ТекстСообщения, Параметры.ИдентификаторУстройства
			);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	
	Результат = МенеджерОборудованияКлиент.ПодключитьОборудованиеПоИдентификатору(
		Параметры.УникальныйИдентификатор,
		Параметры.ИдентификаторУстройства,
		ОписаниеОшибки
	);
	
	Если Результат Тогда
		МенеджерОборудованияКлиент.СостояниеПроцесса(НСтр("ru = 'Выполняется загрузка данных из ККМ Офлайн';
															|en = 'Importing data from offline cash register'"));
		
		ВходныеПараметры  = Новый Массив;
		
		ИмяКоманды = "ЗагрузитьДанные";
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхИзККМЗавершение", ЭтотОбъект, Параметры);
		МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, Параметры.ИдентификаторУстройства, ИмяКоманды, ВходныеПараметры);
		
	Иначе
		ТекстСообщения = НСтр("ru = 'При подключении устройства произошла ошибка.
									|%ОписаниеОшибки%';
									|en = 'An error occurred when connecting the device.
									|%ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
		
		Если Параметры.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ТекстСообщения, Параметры.ИдентификаторУстройства);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьЗагрузкуДанныхИзККМЗавершение(РезультатКоманды, Параметры) Экспорт
	
	ЕстьОшибки = Ложь;
	
	ВыходныеПараметры = РезультатКоманды.ВыходныеПараметры;
	
	Если РезультатКоманды.Результат Тогда
		
		Контекст = Новый Структура;
		Контекст.Вставить("ИдентификаторУстройства", Параметры.ИдентификаторУстройства);
		Контекст.Вставить("ДанныеИзККМ", РезультатКоманды.ВыходныеПараметры[0]);
		
		РезультатПередачиДанных = МенеджерОфлайнОборудованияВызовСервера.ПередатьДанныеЗагрузки(Контекст);
		
		Если РезультатПередачиДанных.Успешно Тогда
			
			ВходныеПараметры = Неопределено;
			
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхИзККМПослеУстановкиФлагаОбработанности", ЭтотОбъект, Параметры);
			МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, Параметры.ИдентификаторУстройства, "УстановитьФлагДанныеЗагружены", ВходныеПараметры);
			
		Иначе
			
			ВыходныеПараметры = Новый Массив;
			ЕстьОшибки = Истина;
			СоздатьСообщениеОбОшибке(ВыходныеПараметры, РезультатПередачиДанных.СообщениеОбОшибке);
		КонецЕсли;
		
	Иначе
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	
	Если ЕстьОшибки Тогда
		
		РезультатВыполнения = Новый Структура("Результат, ВыходныеПараметры", Ложь, ВыходныеПараметры);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьЗагрузкуДанныхИзККМПослеУстановкиФлагаОбработанности", ЭтотОбъект, Параметры);
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, РезультатВыполнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьЗагрузкуДанныхИзККМПослеУстановкиФлагаОбработанности(РезультатКоманды, Параметры) Экспорт
	
	Если РезультатКоманды.Результат Тогда
		ТекстСообщения = НСтр("ru = 'Данные загружены успешно';
								|en = 'Data is imported successfully'");
	Иначе
		ТекстСообщения = РезультатКоманды.ВыходныеПараметры[1];
	КонецЕсли;
	
	Если Параметры.СледующееОповещение <> Неопределено Тогда
		
		РезультатВыполнения = МенеджерОборудованияКлиент.ПараметрыВыполненияОперацииНаОборудовании(
			РезультатКоманды.Результат,
			ТекстСообщения,
			Параметры.ИдентификаторУстройства
		);
		
		ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(Параметры.УникальныйИдентификатор, Параметры.ИдентификаторУстройства);
	
КонецПроцедуры

#КонецОбласти

// Процедура добавляет в массив выходных параметров сообщение об ошибке.
//		Параметры:
//			- ВыходныеПараметры - массив, в который будет помещено сообщение об ошибке.
//			- ТекстСообщения - текст сообщения, содержащий информация об ошибке.
Процедура СоздатьСообщениеОбОшибке(ВыходныеПараметры, ТекстСообщения)
	
	ВыходныеПараметры.Добавить(999);
	ВыходныеПараметры.Добавить(ТекстСообщения);
	
КонецПроцедуры

// Очищает товары в ККМ Offline.
//
Процедура НачатьОчисткуТоваровВККМOffline(ОповещениеПриОчисткеДанные, УникальныйИдентификатор, ИдентификаторУстройства = Неопределено, ОтображатьСообщения = Истина)
	
	Контекст = Новый Структура;
	Контекст.Вставить("СледующееОповещение"     , ОповещениеПриОчисткеДанные);
	Контекст.Вставить("УникальныйИдентификатор" , УникальныйИдентификатор);
	Контекст.Вставить("ОтображатьСообщения"     , ОтображатьСообщения);
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровВККМOfflineЗавершение", ЭтотОбъект, Контекст);
		МенеджерОборудованияКлиент.ПредложитьВыбратьУстройство(ОписаниеОповещения, "ККМОфлайн",
			НСтр("ru = 'Выберите ККМ Offline';
				|en = 'Select an offline cash register'"), 
			НСтр("ru = 'ККМ Offline не подключены.';
				|en = 'Offline cash registers are not connected.'"),
			НСтр("ru = 'ККМ Offline не выбрано.';
				|en = 'Offline cash register is not selected.'"), 
			НЕ ОтображатьСообщения);
	Иначе
		НачатьОчисткуТоваровВККМOfflineЗавершение(ИдентификаторУстройства, Контекст);
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьОчисткуТоваровВККМOfflineЗавершение(ИдентификаторУстройства, Параметры) Экспорт
	
	Если ИдентификаторУстройства = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Оборудование не выбрано.';
								|en = 'Equipment is not selected.'");
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ТекстСообщения, Неопределено);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("ИдентификаторУстройства", ИдентификаторУстройства);
#Если ВебКлиент Тогда
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровВККМOfflineФайловоеРасширениеЗавершение", ЭтотОбъект, Параметры);
	ПроверитьДоступностьРасширенияРаботыСФайлами(ОписаниеОповещения, Ложь);
#Иначе
	// В тонком и толстом клиентах расширение подключено всегда.
	НачатьОчисткуТоваровВККМOfflineФайловоеРасширениеЗавершение(Истина, Параметры);
#КонецЕсли
	
КонецПроцедуры

Процедура НачатьОчисткуТоваровВККМOfflineФайловоеРасширениеЗавершение(Подключено, Параметры) Экспорт
	
	Если Не Подключено Тогда
		ТекстСообщения = НСтр("ru = 'Данная операция не доступна без установленного расширения для веб-клиента ""1С:Предприятие"".';
								|en = 'The operation is not available without extension for 1C:Enterprise web client installed.'");
		Если Параметры.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ТекстСообщения, Параметры.ИдентификаторУстройства);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ОписаниеОшибки = "";
	ПоддержкаАсинхронногоРежима = Ложь;
	
	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;
	МенеджерОборудованияКлиент.ВыполнитьКомандуОбработчикаДрайвера("РасширеннаяВыгрузка", ВходныеПараметры, ВыходныеПараметры, Параметры.ИдентификаторУстройства, Неопределено, ПоддержкаАсинхронногоРежима);
	
	Результат = МенеджерОборудованияКлиент.ПодключитьОборудованиеПоИдентификатору(Параметры.УникальныйИдентификатор, Параметры.ИдентификаторУстройства, ОписаниеОшибки);
	
	Если Результат Тогда
		
		МенеджерОборудованияКлиент.СостояниеПроцесса(НСтр("ru = 'Выполняется очистка товаров в ККМ Offline...';
															|en = 'Clearing items in the offline cash register...'"));
		
		ВходныеПараметры  = Неопределено;
		ВыходныеПараметры = Неопределено;
		
		Если ПоддержкаАсинхронногоРежима Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("НачатьОчисткуТоваровВККМOfflineВыполнитьКомандуЗавершение", ЭтотОбъект, Параметры);
			МенеджерОборудованияКлиент.НачатьВыполнениеКоманды(ОписаниеОповещения, Параметры.ИдентификаторУстройства, "ОчиститьБазу", ВходныеПараметры);
		Иначе
			Результат = МенеджерОборудованияКлиент.ВыполнитьКоманду(Параметры.ИдентификаторУстройства, "ОчиститьБазу", ВходныеПараметры, ВыходныеПараметры);
			Если НЕ Результат Тогда
				ТекстСообщения = НСтр("ru = 'При очистке данных в оборудование произошла ошибка.
										  |%ОписаниеОшибки%';
										  |en = 'An error occurred while clearing data in equipment.
										  |%ОписаниеОшибки%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ВыходныеПараметры[1]);
			Иначе
				ТекстСообщения = НСтр("ru = 'Очистка данных успешно завершена.';
										|en = 'Data is successfully cleared.'");
			КонецЕсли;
			
			Если Параметры.СледующееОповещение <> Неопределено Тогда
				РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Результат, ТекстСообщения, Параметры.ИдентификаторУстройства);
				ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
			КонецЕсли;
			
			МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(Параметры.УникальныйИдентификатор, Параметры.ИдентификаторУстройства);
		КонецЕсли;
	Иначе
		ТекстСообщения = НСтр("ru = 'При подключении устройства произошла ошибка.
									|%ОписаниеОшибки%';
									|en = 'An error occurred when connecting the device.
									|%ОписаниеОшибки%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
		
		Если Параметры.ОтображатьСообщения Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
		Если Параметры.СледующееОповещение <> Неопределено Тогда
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", Ложь, ТекстСообщения, Параметры.ИдентификаторУстройства);
			ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура НачатьОчисткуТоваровВККМOfflineВыполнитьКомандуЗавершение(РезультатКоманды, Параметры) Экспорт
	
	Если НЕ РезультатКоманды.Результат Тогда
		ТекстСообщения = НСтр("ru = 'При очистке данных в оборудование произошла ошибка.
								|%ОписаниеОшибки%';
								|en = 'An error occurred while clearing data in equipment.
								|%ОписаниеОшибки%'");
		ОписаниеОшибки = ?(РезультатКоманды.ВыходныеПараметры.Количество() > 1, РезультатКоманды.ВыходныеПараметры[1], "");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%", ОписаниеОшибки);
	Иначе
		ТекстСообщения = НСтр("ru = 'Очистка данных успешно завершена.';
								|en = 'Data is successfully cleared.'");
	КонецЕсли;
	
	Если Параметры.СледующееОповещение <> Неопределено Тогда
		РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ИдентификаторУстройства", РезультатКоманды.Результат, ТекстСообщения, Параметры.ИдентификаторУстройства);
		ВыполнитьОбработкуОповещения(Параметры.СледующееОповещение, РезультатВыполнения);
	Иначе
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	МенеджерОборудованияКлиент.ОтключитьОборудованиеПоИдентификатору(Параметры.УникальныйИдентификатор, Параметры.ИдентификаторУстройства);

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыРаботыСФайлами

// Процедура получения содержания текстовых файлов.
// Параметры:
//  ИменаФайлов  - Строка, Массив - имя файла или массив с именами файлов.
//  ОписаниеОповещенияПриЗавершении  - ОписаниеОповещения - вызывается после завершения чтения файлов.
//  Кодировка - Строка - кодировка при чтении текстового файла, по умолчанию КодировкаТекста.UTF8, возможные значения параметра ANSI, OEM, UTF8, UTF16.
//
Процедура ПолучитьСодержаниеТекстовыхФайлов(ИменаФайлов, ОписаниеОповещенияПриЗавершении, Кодировка = Неопределено) Экспорт
	
	Кодировка = МенеджерОборудованияВызовСервера.ПолучитьКодировкуФайла(Кодировка); //Массив из ОписаниеПередаваемогоФайла
	
	ПомещаемыеФайлы = Новый Массив; //Массив из ОписаниеПередаваемогоФайла
	
	Если ТипЗнч(ИменаФайлов) = Тип("Строка") Тогда
		ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИменаФайлов);
		ПомещаемыеФайлы.Добавить(ОписаниеФайла);
	ИначеЕсли ТипЗнч(ИменаФайлов) = Тип("Массив") Тогда
		Если ИменаФайлов.Количество() = 0 Тогда
			РезультатЧтенияФайлов = Новый Структура;
			РезультатЧтенияФайлов.Вставить("СодержаниеФайлов", Новый Массив);
			РезультатЧтенияФайлов.Вставить("Успешно", Истина);
			РезультатЧтенияФайлов.Вставить("ТекстОшибки","");
		Иначе
			Для Каждого ИмяФайла Из ИменаФайлов Цикл
				ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла));
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ОписаниеОповещенияПриЗавершении", ОписаниеОповещенияПриЗавершении);
		ДополнительныеПараметры.Вставить("Кодировка", Кодировка);
		
		ОповещениеНачатьПомещениеФайла = Новый ОписаниеОповещения("ПолучитьСодержаниеТекстовыхФайловЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПомещениеФайлов(ОповещениеНачатьПомещениеФайла, ПомещаемыеФайлы,, Ложь);
		
	#Иначе
		
		СодержаниеФайлов = Новый Массив;
		РезультатЧтенияФайлов = Новый Структура;
		РезультатЧтенияФайлов.Вставить("СодержаниеФайлов", Неопределено);
		РезультатЧтенияФайлов.Вставить("Успешно", Ложь);
		РезультатЧтенияФайлов.Вставить("ТекстОшибки", "");
		
		Для Каждого Файл Из ПомещаемыеФайлы Цикл
			
			СтруктураСодержанияФайла = Новый Структура;
			
			Попытка
				ЧтениеТекста = Новый ЧтениеТекста(Файл.Имя, Кодировка);
				ТекстСодержания = ЧтениеТекста.Прочитать();
			Исключение
				
				ТекстСообщения =  НСтр("ru = 'При чтении файла %ИмяФайла% произошла ошибка';
										|en = 'An error occurred when reading the %ИмяФайла% file'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяФайла%", Файл.Имя);
				
				РезультатЧтенияФайлов.ТекстОшибки = ТекстСообщения + Символы.ПС + ОписаниеОшибки();
				
			КонецПопытки;
			
			СтруктураСодержанияФайла.Вставить("ОписаниеПереданногоФайла", Файл);
			СтруктураСодержанияФайла.Вставить("ТекстСодержания",          ТекстСодержания);
			
			СодержаниеФайлов.Добавить(СтруктураСодержанияФайла);
			ЧтениеТекста.Закрыть();
			
		КонецЦикла;
		
		РезультатЧтенияФайлов.Успешно = Истина;
		РезультатЧтенияФайлов.СодержаниеФайлов = СодержаниеФайлов;
		ВыполнитьОбработкуОповещения(ОписаниеОповещенияПриЗавершении, РезультатЧтенияФайлов);
		
	#КонецЕсли
	
КонецПроцедуры

// Процедура оповещения получения содержания текстовых файлов.
// Вызывается из процедуры ПолучитьСодержаниеТекстовыхФайлов.
//
Процедура ПолучитьСодержаниеТекстовыхФайловЗавершение(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	РезультатЧтенияФайлов = Новый Структура;
	РезультатЧтенияФайлов.Вставить("СодержаниеФайлов", Неопределено);
	РезультатЧтенияФайлов.Вставить("Успешно", Ложь);
	РезультатЧтенияФайлов.Вставить("ТекстОшибки", "");
	
	Если ПомещенныеФайлы = Неопределено Тогда
		РезультатЧтенияФайлов.ТекстОшибки = НСтр("ru = 'Неизвестная ошибка при передаче файлов на сервер.';
												|en = 'Unknown error when passing files to the server.'");
	Иначе
		Если Не ПомещенныеФайлы.Количество() = 0 Тогда
			РезультатИзвлеченияТекста = МенеджерОборудованияВызовСервера.ПолучитьСодержаниеТекстовыхФайловИзХранилища(
				ПомещенныеФайлы, ДополнительныеПараметры.Кодировка);
			ЗаполнитьЗначенияСвойств(РезультатЧтенияФайлов, РезультатИзвлеченияТекста);
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещенияПриЗавершении, РезультатЧтенияФайлов);
	
КонецПроцедуры

// Проверить доступность расширения работы с Файлами.
// 
Процедура ПроверитьДоступностьРасширенияРаботыСФайлами(ОповещениеПриЗавершении, ПредлагатьУстановку = Истина) Экспорт
	
#Если Не ВебКлиент Тогда
	// В тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, Истина);
	Возврат;
#Иначе
	ДополнительныеПараметры = Новый Структура("ОповещениеПриЗавершении, ПредлагатьУстановку", ОповещениеПриЗавершении, ПредлагатьУстановку);
	Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
#КонецЕсли
	
КонецПроцедуры

Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено И ДополнительныеПараметры.ПредлагатьУстановку Тогда
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?';
								|en = 'To continue, you need to install an extension for 1C:Enterprise web client. Install?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет); 
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, Подключено);
	КонецЕсли
	
КонецПроцедуры

Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

// Записывает текстовый файл.
// 
// Параметры:
// 	ТекстовыйДокумент - ТекстовыйДокумент - .
// 	ИмяФайла - Строка - .
// Возвращаемое значение:
// 	Булево - Описание
Функция ЗаписатьТекстовыйФайл(ТекстовыйДокумент, ИмяФайла) Экспорт
	
	Результат = Ложь;
	
	Попытка
		ТекстовыйДокумент.Записать(ИмяФайла);
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти