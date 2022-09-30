#Область ПрограммныйИнтерфейс

// Переопределяет настройки команд ввода на основании.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы:
//   * ИспользоватьКомандыВводаНаОсновании - Булево - разрешает использование программных команд ввода на основании
//                                                    вместо штатных. Значение по умолчанию: Истина.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
КонецПроцедуры

// Определяет список объектов конфигурации, в модулях менеджеров которых предусмотрена процедура 
// ДобавитьКомандыСозданияНаОсновании, формирующая команды создания на основании объектов.
// Синтаксис процедуры ДобавитьКомандыСозданияНаОсновании см. в документации.
//
// Параметры:
//   Объекты - Массив - объекты метаданных (ОбъектМетаданных) с командами создания на основании.
//
// Пример:
//  Объекты.Добавить(Метаданные.Справочники.Организации);
//
Процедура ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Объекты) Экспорт
	
	Объекты.Добавить(Метаданные.Документы.ЗакрытиеПлатежнойПозиции);
	
	// Заявка на оплату
	Документ = Новый(КэшируемыеПроцедурыОПК.ТипЗаявкаНаОплату());
	МетаданныеДокумента = Документ.Метаданные();
	Если Объекты.Найти(МетаданныеДокумента) = неопределено Тогда
		Объекты.Добавить(МетаданныеДокумента);
	КонецЕсли;
	
	// Планируемое поступление ДС
	Документ = Новый(КэшируемыеПроцедурыОПК.ТипПланируемоеПоступление());
	МетаданныеДокумента = Документ.Метаданные();
	Если Объекты.Найти(МетаданныеДокумента) = неопределено Тогда
		Объекты.Добавить(МетаданныеДокумента);
	КонецЕсли;
	
	Объекты.Добавить(Метаданные.Документы.ЗаявкаНаРасход);
	Объекты.Добавить(Метаданные.Документы.ПланируемыйДоход);
	Объекты.Добавить(Метаданные.Документы.ОперативныйПлан);
	Объекты.Добавить(Метаданные.Документы.ОтражениеФактическихДанныхБюджетирования);
	
	Объекты.Добавить(Метаданные.Документы.ЗаявкаНаКорректировкуЛимитов);
	Объекты.Добавить(Метаданные.Документы.КорректировкаЛимитов);
	
КонецПроцедуры

// Вызывается для формирования списка команд создания на основании КомандыСозданияНаОсновании, однократно для при первой
// необходимости, а затем результат кэшируется с помощью модуля с повторным использованием возвращаемых значений.
// Здесь можно определить команды создания на основании, общие для большинства объектов конфигурации.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - сформированные команды для вывода в подменю:
//     
//     Общие настройки:
//       * Идентификатор - Строка - Идентификатор команды.
//     
//     Настройки внешнего вида:
//       * Представление - Строка   - Представление команды в форме.
//       * Важность      - Строка   - Группа в подменю, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - Порядок размещения команды в подменю. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - Картинка команды.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - Типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - Имена форм через запятую, в которых должна отображаться команда.
//                                        Используется когда состав команд отличается для различных форм.
//       * ФункциональныеОпции - Строка - Имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - Определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - Определяет доступность команды в ситуации,
//                                        когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево, Неопределено - Если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию: Ложь.
//       * РежимЗаписи - Строка - Действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//             "НеЗаписывать"          - Объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                       вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                       которая передается в структуре 2 параметра обработчика команды.
//             "ЗаписыватьТолькоНовые" - Записывать новые объекты.
//             "Записывать"            - Записывать новые и модифицированные объекты.
//             "Проводить"             - Проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию: "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - Если Истина, то в веб-клиенте предлагается
//             установить расширение работы с файлами.
//             Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - Объект, отвечающий за выполнение команды.
//       * ИмяФормы - Строка - Имя формы, которую требуется получить для выполнения команды.
//             Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * ПараметрыФормы - Неопределено, ФиксированнаяСтруктура - Необязательный. Параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - Описание процедуры, обрабатывающей основное действие команды.
//             Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется когда процедура размещена в общем модуле.
//             Формат "<ИмяПроцедуры>" используется в следующих случаях:
//               - Если ИмяФормы заполнено то в модуле указанной формы ожидается клиентская процедура.
//               - Если ИмяФормы не заполнено то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - ФиксированнаяСтруктура - Необязательный. Параметры обработчика, указанного в Обработчик.
//   
//   Параметры - Структура - Сведения о контексте исполнения.
//       * ИмяФормы - Строка - Полное имя формы.
//
//   СтандартнаяОбработка - Булево - Если установить в Ложь, то событие "ДобавитьКомандыСозданияНаОсновании" менеджера
//                                   объекта не будет вызвано.
//
Процедура ПередДобавлениемКомандСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Определяет список команд создания на основании. Вызывается перед вызовом "ДобавитьКомандыСозданияНаОсновании" модуля
// менеджера объекта.
//
// Параметры:
//  Объект - ОбъектМетаданных - объект, для которого добавляются команды.
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//  СтандартнаяОбработка - Булево - Если установить в Ложь, то событие "ДобавитьКомандыСозданияНаОсновании" менеджера
//                                  объекта не будет вызвано.
//
Процедура ПриДобавленииКомандСозданияНаОсновании(Объект, КомандыСозданияНаОсновании, Параметры, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура добавляет команду создания ЗНО на основании документа
Функция ДобавитьКоманду_ЗаявкуНаОплату(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипЗаявкаНаОплату());
КонецФункции

// Процедура добавляет команду создания ожидаемой оплаты на основании документа
Функция ДобавитьКоманду_ОжидаемуюОплату(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипПланируемоеПоступление());
КонецФункции

// Процедура добавляет команду создания ЗНР на основании документа
Функция ДобавитьКоманду_ЗаявкуНаРасход(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипЗаявкаНаРасход());
КонецФункции

// Процедура добавляет команду создания планируемого дохода на основании документа
Функция ДобавитьКоманду_ПланируемыйДоход(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипПланируемыйДоход());
КонецФункции

// Процедура добавляет команду создания РКО на основании документа
Функция ДобавитьКоманду_РКО(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипРКО());
КонецФункции

// Процедура добавляет команду создания ПКО на основании документа
Функция ДобавитьКоманду_ПКО(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипПКО());
КонецФункции

// Процедура добавляет команду создания ПКО на основании документа
Функция ДобавитьКоманду_ПП(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипПлатежноеПоручение());
КонецФункции

// Процедура добавляет команду создания СписаниеБезналичныхДенежныхСредств на основании документа
Функция ДобавитьКоманду_СписаниеБезналичныхДенежныхСредств(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипСписаниеБезналичныхДенежныхСредств());
КонецФункции

// Процедура добавляет команду создания ПоступлениеБезналичныхДенежныхСредств на основании документа
Функция ДобавитьКоманду_ПоступлениеБезналичныхДенежныхСредств(КомандыСозданияНаОсновании) Экспорт
	Возврат ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, КэшируемыеПроцедурыОПК.ТипПоступлениеБезналичныхДенежныхСредств());
КонецФункции

// Процедура добавляет команду создания ожидаемой оплаты на основании документа
Функция ДобавитьКоманду_НачисленияОперацийМСФО(КомандыСозданияНаОсновании) Экспорт
	Если Метаданные.Документы.Найти("НачислениеОперацийМСФО") <> неопределено Тогда
		Возврат Документы["НачислениеОперацийМСФО"].ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	КонецЕсли;
	Возврат неопределено;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандуСоздатьНаОснованииПоТипу(КомандыСозданияНаОсновании, Тип)
	
	ОбъектСсылка = Новый (Тип);
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(ОбъектСсылка);
	Попытка
		Команда = МенеджерОбъекта.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	Исключение
		Команда = ДобавитьКомандуСоздатьНаОснованииПоМетаданным(КомандыСозданияНаОсновании, ОбъектСсылка.Метаданные());
	КонецПопытки; 
	
	Возврат Команда;
	
КонецФункции

Функция ДобавитьКомандуСоздатьНаОснованииПоМетаданным(КомандыСозданияНаОсновании, МетаданныеОбъекта)
	
	Если ПравоДоступа("Добавление", МетаданныеОбъекта) Тогда
		
		КомандаСоздатьНаОсновании						= КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер				= МетаданныеОбъекта.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление			= ОбщегоНазначения.ПредставлениеОбъекта(МетаданныеОбъекта);
		КомандаСоздатьНаОсновании.РежимЗаписи			= "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти
 
