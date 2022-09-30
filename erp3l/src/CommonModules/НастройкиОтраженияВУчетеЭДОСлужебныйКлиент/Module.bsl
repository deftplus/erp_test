
#Область СлужебныеПроцедурыИФункции

Процедура УдалитьНастройкуОтраженияВУчете(Получатель, Отправитель, ИдентификаторПолучателя,
	ИдентификаторОтправителя, Форма, Оповещение) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Получатель", Получатель);
	Контекст.Вставить("Отправитель", Отправитель);
	Контекст.Вставить("ИдентификаторПолучателя", ИдентификаторПолучателя);
	Контекст.Вставить("ИдентификаторОтправителя", ИдентификаторОтправителя);
	Контекст.Вставить("Форма", Форма);
	Контекст.Вставить("Оповещение", Оповещение);
	Описание = Новый ОписаниеОповещения("ПослеВопросаОбУдаленииНастройки", ЭтотОбъект, Контекст);
	
	ТекстВопроса = НСтр("ru = 'Сейчас будет удалена настройка отражения в учете.
                         |Продолжить?';
                         |en = 'The recognition setting will now be removed.
                         |Continue?'");
	
	ПоказатьВопрос(Описание, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

Процедура ПослеВопросаОбУдаленииНастройки(РезультатВопроса, Контекст) Экспорт 
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		ОповеститьОЗавершенииУдаленияНастройкиОтраженияВУчете(Неопределено, Контекст);
		Возврат;
	КонецЕсли;
	
	ДлительнаяОперация = НастройкиОтраженияВУчетеЭДОСлужебныйВызовСервера.НачатьУдалениеНастроекОтраженияВУчете(
		Контекст.Форма.УникальныйИдентификатор, Контекст.Получатель, Контекст.Отправитель,
		Контекст.ИдентификаторПолучателя, Контекст.ИдентификаторОтправителя);
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Контекст.Форма);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьУдалениеНастройкиОтраженияВУчете", ЭтотОбъект, Контекст);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
		
КонецПроцедуры

Процедура ЗавершитьУдалениеНастройкиОтраженияВУчете(Результат, Контекст) Экспорт
	
	Если Результат.Статус = "Ошибка" Тогда
		
		ТекстСообщения = НСтр("ru = 'Во время удаления настройки отражения в учете произошла ошибка.';
								|en = 'The error occurred when the accounting registration setting was removed.'");
		
		ОбработкаНеисправностейБЭДВызовСервера.ОбработатьОшибку(НСтр("ru = 'Удаление настройки отражения в учете ЭДО';
																	|en = 'Delete setting of recording in EDI accounting'"), 
			ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().ОбменСКонтрагентами, Результат.ПодробноеПредставлениеОшибки, ТекстСообщения);
		
		ОповеститьОЗавершенииУдаленияНастройкиОтраженияВУчете(Ложь, Контекст);
		Возврат;
	КонецЕсли;
	
	РезультатУдаления = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если Не РезультатУдаления Тогда
		ТекстСообщения = НСтр("ru = 'Во время удаления настройки отражения в учете произошла ошибка.
                               |Подробнее см. в журнале регистрации.';
                               |en = 'An error occurred when deleting the recognition in accounting setting.
                               |See the event log.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	ОповеститьОЗавершенииУдаленияНастройкиОтраженияВУчете(РезультатУдаления, Контекст);
	
КонецПроцедуры

Процедура ОповеститьОЗавершенииУдаленияНастройкиОтраженияВУчете(Результат, Контекст)
	
	ВыполнитьОбработкуОповещения(Контекст.Оповещение, Результат);
	
КонецПроцедуры

#КонецОбласти