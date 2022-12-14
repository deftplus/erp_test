
#Область СлужебныеПроцедурыИФункции

Процедура СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц) Экспорт
	ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияПоДокументу(Движения, Отказ, Организация, ПериодРегистрации, ДанныеДляПроведения, СтрокаСписокТаблиц);
КонецПроцедуры

Процедура СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, ПроцентЕНВД, МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТБухучетНачислений(Организация, ПериодРегистрации, ПроцентЕНВД, МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура СоздатьВТСведенияОБухучетеЗарплатыСотрудников(МенеджерВременныхТаблиц, ИмяВременнойТаблицы, ИменаПолейВременнойТаблицы = "Сотрудник,Период", Организация = Неопределено, Подразделение = Неопределено, ТерриторияВыполненияРаботВОрганизации = Неопределено) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТСведенияОБухучетеЗарплатыСотрудников(МенеджерВременныхТаблиц, ИмяВременнойТаблицы, ИменаПолейВременнойТаблицы, Организация, Подразделение, ТерриторияВыполненияРаботВОрганизации);

КонецПроцедуры

Процедура СоздатьВТСведенияОБухучетеНачислений(МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТСведенияОБухучетеНачислений(МенеджерВременныхТаблиц);

КонецПроцедуры

Процедура УстановитьСписокВыбораОтношениеКЕНВД(ЭлементФормы, ИмяЭлемента) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.УстановитьСписокВыбораОтношениеКЕНВД(ЭлементФормы, ИмяЭлемента);
	
КонецПроцедуры

Функция ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации) Экспорт

	Возврат ОтражениеЗарплатыВБухучетеРасширенный.ДанныеДляОтраженияЗарплатыВБухучете(Организация, ПериодРегистрации);

КонецФункции

Процедура ДополнитьСведенияОВзносахДаннымиБухучета(Движения, Организация, ПериодРегистрации, Ссылка, МенеджерВременныхТаблиц, ИмяВременнойТаблицы) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ДополнитьСведенияОВзносахДаннымиБухучета(Движения, Организация, ПериодРегистрации, Ссылка, МенеджерВременныхТаблиц, ИмяВременнойТаблицы);

КонецПроцедуры

Процедура ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьПараметрыДляРасчетаОценочныхОбязательствОтпусков(Организация, ПериодРегистрации, ПараметрыДляРасчета, Сотрудники);

КонецПроцедуры

Процедура ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, Период, КоллекцияНачисленныйНДФЛ) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьРегистрациюВНалоговомОрганеВКоллекцииСтрок(Организация, Период, КоллекцияНачисленныйНДФЛ);

КонецПроцедуры

Процедура УдалитьРольОтражениеЗарплатыВБухгалтерскомУчете() Экспорт
	
	ОтражениеЗарплатыВБухучетеРасширенный.УдалитьРольОтражениеЗарплатыВБухгалтерскомУчете();
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыПолученияФОТОрганизацийДляОценочныхОбязательствОтпусков(Организации, Период, ТаблицаПараметров) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьПараметрыПолученияФОТОрганизацийДляОценочныхОбязательствОтпусков(Организации, Период, ТаблицаПараметров);

КонецПроцедуры

Процедура ЗаполнитьПараметрыПолученияФОТСотрудниковДляОценочныхОбязательствОтпусков(СотрудникиДляОбработки, Период, ПараметрыПолученияФОТ) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьПараметрыПолученияФОТСотрудниковДляОценочныхОбязательствОтпусков(СотрудникиДляОбработки, Период, ПараметрыПолученияФОТ);

КонецПроцедуры

Процедура ЗаполнитьСведенияОбОтпускахСотрудниковДляОценочныхОбязательств(СведенияОбОтпусках, СотрудникиДляОбработки, Организация, Период) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.ЗаполнитьСведенияОбОтпускахСотрудниковДляОценочныхОбязательств(СведенияОбОтпусках, СотрудникиДляОбработки, Организация, Период);
	
КонецПроцедуры

Функция ИспользуетсяЕНВД() Экспорт

	Возврат ОтражениеЗарплатыВБухучетеРасширенный.ИспользуетсяЕНВД();
	
КонецФункции

Процедура СоздатьВТИсключаемыеСтроки(МенеджерВременныхТаблиц) Экспорт

	ОтражениеЗарплатыВБухучетеРасширенный.СоздатьВТИсключаемыеСтроки(МенеджерВременныхТаблиц);

КонецПроцедуры

#КонецОбласти
