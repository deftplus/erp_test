
////////////////////////////////////////////////////////////////////////////////
// Подсистема "Облачные классификаторы".
// ОбщийМодуль.ОблачныеКлассификаторыПереопределяемый.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область КлассификаторТНВЭД

// Определение загруженных элементов ТНВЭД
// Процедура используется в форме онлайн-подбора элементов классификатора ТН ВЭД
// для установки отметок у имеющихся в базе элементов (в режиме загрузки элементов),
// а также при обновлении классификатора и в других служебных методах.
//
// Параметры:
//  Элементы - Массив - коды имеющихся в базе элементов классификатора. Элементы массива должны иметь тип Строка.
//                      Допустимо передавать коды в формате с пробелами так, как они указываются в классификаторе
//                      ("ХХХХ ХХ ХХХ Х" - 13 символов) или без ("ХХХХХХХХХХ" - 10 символов).
//
Процедура ОпределитьЗагруженныеЭлементыТНВЭД(Элементы) Экспорт
	
КонецПроцедуры

// Создание или обновление элементов ТНВЭД
//
// Параметры:
//  ДанныеСервиса - ТаблицаЗначений - данные, полученные из сервиса. Колонки:
//                    * Идентификатор           - Число  - идентификатор элемента на стороне сервиса (служебное);
//                    * Код                     - Строка - код элемента классификатора в формате "ХХХХ ХХ ХХХ Х";
//                    * КодРодителя             - Строка - код элемента, являющегося родителем, в формате с пробелами;
//                    * Порядок                 - Число  - поле для упорядочивания элементов (служебное);
//                    * ДатаНачалаДействия      - Дата   - дата начала действия элемента классификатора;
//                    * ДатаОкончанияДействия   - Дата   - дата окончания действия элемента классификатора;
//                    * Наименование            - Строка - наименование элемента;
//                    * НаименованиеПолное      - Строка - наименование элемента, включающее наименования родителей;
//                    * Описание                - Строка - описание элемента;
//                    * КодОКЕИ                 - Строка - код элемента справочника ОКЕИ;
//                    * Сырьевой                - Булево - признак, указывающий на принадлежность товаров к сырьевым;
//                    * ТаможеннаяПошлина       - Строка - ставка таможенной пошлины и дополнительная информация;
//                    * СтавкаНДС               - Строка - ставка НДС;
//                    * ПодлежитУтилизации      - Булево - признак, указывающий на необходимость утилизации товаров;
//                    * ИзменениеСоставаТоваров - Булево - признак, указывающий на изменение состава товаров,
//                                                         относящихся к элементу;
//  Отказ - Булево - если Истина, обновление будет считаться неуспешным.
//
Процедура СоздатьОбновитьЭлементыТНВЭД(ДанныеСервиса, Отказ) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область КлассификаторОКПД2

// Определение загруженных элементов ОКПД 2
// Процедура заполняет переданный параметр массивом кодов классификатора, имеющихся в базе.
// Используется в форме онлайн-подбора элементов классификатора 
// для установки отметок у имеющихся в базе элементов (в режиме загрузки элементов),
// а также при обновлении классификатора и в других служебных методах.
//
// Параметры:
//  ЭлементыКлассификатора - Массив - коды имеющихся в базе элементов классификатора. 
//        Элементы массива должны иметь тип Строка(12).
//          Форматы кодов:
//          А - Раздел;
//          ХХ - Класс;
//          ХХ.Х - Подкласс;
//          ХХ.ХХ - Группа;
//          ХХ.ХХ.Х - Подгруппа;
//          ХХ.ХХ.ХХ - Вид;
//          ХХ.ХХ.ХХ.ХХ0 - Категория;
//          ХХ.ХХ.ХХ.ХХХ - Подкатегория;
//          где Х - цифры от 0 до 9; А - буква от А до Я
//
Процедура ОпределитьЗагруженныеЭлементыОКПД2(ЭлементыКлассификатора) Экспорт
	
КонецПроцедуры	

// Создание или обновление элементов классификатора ОКПД 2
//
// Параметры:
//  ДанныеСервиса - ТаблицаЗначений - данные, полученные из сервиса. Колонки:
//    * Идентификатор           - Число - идентификатор элемента на стороне сервиса (служебное);
//    * Код                     - Строка - код элемента классификатора;
//    * КодРодителя             - Строка - код родителя элементов;
//    * Порядок                 - Число - поле для упорядочивания элементов (служебное);
//    * ДатаНачалаДействия      - Дата - дата начала действия элемента классификатора;
//    * ДатаОкончанияДействия   - Дата - дата окончания действия элемента классификатора;
//    * Наименование            - Строка - наименование элемента;
//    * Описание                - Строка - описание элемента;
//    * КодОКЕИ                 - Строка - код элемента справочника ОКЕИ;
//  Отказ - Булево - если Истина, обновление будет считаться не успешным.
//
Процедура СоздатьОбновитьЭлементыОКПД2(ДанныеСервиса, Отказ) Экспорт

КонецПроцедуры	

#КонецОбласти

#КонецОбласти