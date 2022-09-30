///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "СПАРК".
// ОбщийМодуль.СПАРКРискиКлиентПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбработчикиСобытийЭлементовФормы

// Обработчик события "ОбработкаНавигационнойСсылки" любой формы.
//
// Параметры:
//  Форма                           - ФормаКлиентскогоПриложения - форма, в которой инициировано событие;
//  ЭлементФормы                    - ПолеФормы - элемент формы, в котором инициировано событие;
//  НавигационнаяСсылка             - Строка - навигационная ссылка;
//  СтандартнаяОбработкаФормой      - Булево - в этот параметр возвратить Ложь, если надо запретить стандартную обработку события формой;
//  СтандартнаяОбработкаБиблиотекой - Булево - в этот параметр возвратить Ложь, если надо запретить стандартную обработку события библиотекой.
//
Процедура ОбработкаНавигационнойСсылки(Форма, ЭлементФормы, НавигационнаяСсылка, СтандартнаяОбработкаФормой, СтандартнаяОбработкаБиблиотекой) Экспорт

КонецПроцедуры

// Обработчик события "ОбработкаОповещения" любой формы.
//
// Параметры:
//  Форма                           - ФормаКлиентскогоПриложения - форма, в которой инициировано событие;
//  КонтрагентОбъект                - Объект, Неопределено - заполняется в том случае, если форма - это форма элемента справочника, а не форма документа.
//  ИмяСобытия                      - Произвольный - имя события;
//  Параметр                        - Произвольный - параметр оповещения;
//  Источник                        - Произвольный - источник оповещения;
//  СтандартнаяОбработкаБиблиотекой - Булево - в этот параметр возвратить Ложь, если надо запретить стандартную обработку события библиотекой.
//
Процедура ОбработкаОповещения(Форма, КонтрагентОбъект, ИмяСобытия, Параметр, Источник, СтандартнаяОбработкаБиблиотекой) Экспорт

КонецПроцедуры

#КонецОбласти

// Процедура переопределяет интервал проверки фоновых заданий и количество повторов проверки.
//
// Параметры:
//  КоличествоПроверок - Число - количество проверок фоновых заданий. Должно быть от 1 до 40. По-умолчанию 20;
//  ИнтервалПроверки   - Число - интервал проверки фоновых заданий (в секундах, должно быть от 1 до 30). По-умолчанию 1 секунда.
//
Процедура ПереопределитьПараметрыПроверкиФоновыхЗаданий(КоличествоПроверок, ИнтервалПроверки) Экспорт

КонецПроцедуры

#КонецОбласти
