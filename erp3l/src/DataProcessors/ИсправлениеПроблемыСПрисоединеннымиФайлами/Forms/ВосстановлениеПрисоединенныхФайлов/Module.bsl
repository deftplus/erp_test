
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокФайлов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыФайлы

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьФайл();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Присоединить(Команда)
	
	ФизическоеЛицо = Элементы.ФизическиеЛица.ТекущаяСтрока;
	
	Если ФизическоеЛицо = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Выбранные файлы будут присоединены к работнику %1.';
																				|en = 'Selected files will be attached to the %1 employee.'"), ФизическоеЛицо);
	Оповещение = Новый ОписаниеОповещения("ПрисоединитьЗавершение", ЭтотОбъект);				
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена, , КодВозвратаДиалога.Отмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисоединитьЗавершение(Ответ, ДополнительныеПараметры) Экспорт 
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьДанныеФайлов();
	
	Если Файлы.Количество() = 0 Тогда 
		Оповестить("ВосстановленыПрисоединенныеФайлыФизическихЛиц", , ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Просмотреть(Команда)
	
	ОткрытьФайл();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокФайлов()
	
	Файлы.Очистить();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	Файлы.Ссылка,
	               |	Файлы.ИндексКартинки,
	               |	Файлы.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.Файлы КАК Файлы
	               |ГДЕ
	               |	Файлы.ВладелецФайла = НЕОПРЕДЕЛЕНО
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Наименование";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		ЗаполнитьЗначенияСвойств(Файлы.Добавить(), Выборка);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл()
	
	ТекущиеДанные = Элементы.Файлы.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла);
	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьДанныеФайлов()
	
	ФизическоеЛицо = Элементы.ФизическиеЛица.ТекущаяСтрока;
	
	Если ФизическоеЛицо = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Элементы.Файлы.ВыделенныеСтроки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ИдентификаторСтроки Из Элементы.Файлы.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Файлы.НайтиПоИдентификатору(ИдентификаторСтроки);
		
		НачатьТранзакцию();
		
		Попытка
		
			ФайлОбъект = ДанныеСтроки.Ссылка.ПолучитьОбъект();
			ФайлОбъект.ВладелецФайла = ФизическоеЛицо;
			ФайлОбъект.ОбменДанными.Загрузка = Истина;
			ФайлОбъект.Записать();
			
			ДанныеФайлаИДвоичныеДанные = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаИДвоичныеДанные(ДанныеСтроки.Ссылка);
			
			ДанныеФайла = ДанныеФайлаИДвоичныеДанные.ДанныеФайла;
			ДвоичныеДанные = ДанныеФайлаИДвоичныеДанные.ДвоичныеДанные;
			
			ИдентификаторАдресаФайла = Новый УникальныйИдентификатор;
			АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторАдресаФайла);
			
			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("Автор", ДанныеФайла.АвторТекущейВерсии);
			ПараметрыФайла.Вставить("ВладелецФайлов", ФизическоеЛицо);
			ПараметрыФайла.Вставить("ИмяБезРасширения", ДанныеФайла.ПолноеНаименованиеВерсии);
			ПараметрыФайла.Вставить("РасширениеБезТочки", ДанныеФайла.Расширение);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ДанныеФайла.ДатаМодификацииУниверсальная);
			
			ПрисоединенныйФайлСсылка = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайлаВоВременномХранилище);
			
			УдалитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = НСтр("ru = 'Ошибка при восстановлении файла %1';
								|en = 'An error occurred while restoring the %1 file'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДанныеСтроки.Наименование) + Символы.ПС + ИнформацияОбОшибке.Описание;
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки);	
			ОтменитьТранзакцию();
			Продолжить;
			
		КонецПопытки;
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
		
	ЗаполнитьСписокФайлов();
	
КонецПроцедуры

#КонецОбласти
