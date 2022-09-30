////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ СО СТРОКАМИ

#Область ПрограммныйИнтерфейс

// Добавляет или удаляет префикс в начале строки текста.
// При добавлении учитывается, что такой префикс уже может быть, и он не добавляется.
// Параметры:
//	Текст - Строка - текст для изменения.
//	Префикс - Строка - текст для добавления или удаления.
//	Добавить - Булево
//		- Истина - добавить текст в начало заголовка (если его нет).
//		- Ложь - удалить (если есть) текст из начала заголовка формы.
//
Функция ДобавитьУдалитьПрефиксТекста(Текст, Префикс, Добавить) Экспорт
	ДлинаПрефикса = СтрДлина(Префикс);
	флУжеСодержитПрефикс = (Лев(Текст, ДлинаПрефикса) = Префикс);
	Если Добавить И НЕ флУжеСодержитПрефикс Тогда
		Возврат Префикс + Текст;
	КонецЕсли;
	
	Если НЕ Добавить И флУжеСодержитПрефикс Тогда
		Возврат Сред(Текст, ДлинаПрефикса+1);
	КонецЕсли;
	
	Возврат Текст;
КонецФункции

// Функция проверяет, является ли переданная строка корректным именем переменной 1С.
// Параметры:
// СтрокаПроверки (Строка) - Проверяемая строка
// Возвращаемое значение:
// Булево. Истина - переданная строка является идентификатором.
Функция ЭтоКорректноеИмяПеременной(СтрокаПроверки) Экспорт
	
	ПервыйСимвол = Лев(СтрокаПроверки, 1);
	
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ПервыйСимвол) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Индекс = 1 По СтрДлина(СтрокаПроверки) Цикл
		
		Символ = Сред(СтрокаПроверки, Индекс, 1);
		
		Если ПустаяСтрока(Символ) ИЛИ (НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Символ)
			И НЕ ТолькоБуквыВСтроке(Символ,,"_")) Тогда
			
			Возврат Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ТолькоБуквыВСтроке(Знач СтрокаПроверки, Знач УчитыватьРазделителиСлов = Истина, ДопустимыеСимволы = "") Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(СтрокаПроверки,УчитыватьРазделителиСлов, ДопустимыеСимволы) 
		ИЛИ СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(СтрокаПроверки,УчитыватьРазделителиСлов, ДопустимыеСимволы);
	
КонецФункции

#КонецОбласти

#Область УстаревшийПрограммныйИнтерфейс
// Функция "расщепляет" строку на подстроки, используя заданный
//      разделитель. Разделитель может иметь любую длину.
//      Если в качестве разделителя задан пробел, рядом стоящие пробелы
//      считаются одним разделителем, а ведущие и хвостовые пробелы параметра Стр
//      игнорируются.
//      Например,
//      РазложитьСтрокуВМассивПодстрок(",один,,,два", ",") возвратит массив значений из пяти элементов,
//      три из которых - пустые строки, а
//      РазложитьСтрокуВМассивПодстрок(" один   два", " ") возвратит массив значений из двух элементов
//
//  Параметры:
//      Стр -           строка, которую необходимо разложить на подстроки.
//                      Параметр передается по значению.
//      Разделитель -   строка-разделитель, по умолчанию - запятая.
//
//  Возвращаемое значение:
//      массив значений, элементы которого - подстроки
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = ",") Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Стр, Разделитель);
	
КонецФункции 

// Устарела. Следует использовать СтрСоединить.
// Возвращает строку, полученную из массива элементов, разделенных символом разделителя
//
// Параметры:
//  Массив - Массив - массив элементов из которых необходимо получить строку
//  Разделитель - Строка - любой набор символов, который будет использован как разделитель между элементами в строке
//
// Возвращаемое значение:
//  Результат - Строка - строка, полученная из массива элементов, разделенных символом разделителя
// 
Функция ПолучитьСтрокуИзМассиваПодстрок(Массив, Разделитель = ",") Экспорт
	Возврат СтрСоединить(Массив, Разделитель);
КонецФункции

// Сравнить две строки версий.
//
// Параметры
//  СтрокаВерсии1  – Строка – номер версии в формате РР.{П|ПП}.ЗЗ.СС
//  СтрокаВерсии2  – Строка – второй сравниваемый номер версии
//
// Возвращаемое значение:
//   Число   – больше 0, если СтрокаВерсии1 > СтрокаВерсии2; 0, если версии равны.
//
Функция СравнитьВерсии(Знач СтрокаВерсии1, Знач СтрокаВерсии2) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(СтрокаВерсии1, СтрокаВерсии2);
	
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%ИмяПараметра").
// Параметр<n>         - Строка - параметр
// Возвращаемое значение:
//   Строка   – текстовая строка с подставленными параметрами
//
// Пример:
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк");
//
Функция ПодставитьПараметрыВСтроку( Знач СтрокаПодстановки,
									Знач Параметр1,
									Знач Параметр2 = Неопределено,
									Знач Параметр3 = Неопределено,
									Знач Параметр4 = Неопределено,
									Знач Параметр5 = Неопределено,
									Знач Параметр6 = Неопределено,
									Знач Параметр7 = Неопределено,
									Знач Параметр8 = Неопределено,
									Знач Параметр9 = Неопределено) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, 
		Параметр1, Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	
КонецФункции

// Подставляет параметры в строку. Неограниченное число параметров в строке.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров
// начинается с единицы.
//
// Параметры
//  СтрокаПодстановки  – Строка – шаблон строки с параметрами (вхождениями вида "%1").
//  МассивПараметров   - Массив - массив строк, которые соответствуют параметрам в строке подстановки
//
// Возвращаемое значение:
//   Строка   – текстовая строка с подставленными параметрами
//
// Пример:
// МассивПараметров = Новый Массив;
// МассивПараметров = МассивПараметров.Добавить("Вася");
// МассивПараметров = МассивПараметров.Добавить("Зоопарк");
//
// Строка = ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), МассивПараметров);
//
Функция ПодставитьПараметрыВСтрокуИзМассива(Знач СтрокаПодстановки, знач МассивПараметров) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(СтрокаПодстановки, МассивПараметров);
	
КонецФункции

// Проверяет содержит ли строка только цифры.
//
// Параметры:
//  СтрокаПроверки - строка для проверки.
//  УчитыватьЛидирующиеНули - Булево - нужно ли учитывать лидирующие нули.
//  УчитыватьПробелы - Булево - нужно ли учитывать пробелы.
//
// Возвращаемое значение:
//  Истина       - строка содержит только цифры;
//  Ложь         - строка содержит не только цифры.
//
Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПроверки, УчитыватьЛидирующиеНули, УчитыватьПробелы);
	
КонецФункции // ТолькоЦифрыВСтроке()

// Удаляет двойные кавычки с начала и конца строки, если они есть.
//
// Параметры:
//  Строка       - входная строка;
//
// Возвращаемое значение:
//  Строка - строка без двойных кавычек.
// 
Функция СократитьДвойныеКавычки(Знач Строка) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.СократитьДвойныеКавычки(Строка);
	
КонецФункции 

// Процедура удаляет из строки указанное количество символов справа
//
Процедура УдалитьПоследнийСимволВСтроке(Текст, ЧислоСимволов) Экспорт
	
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(Текст, ЧислоСимволов);
	
КонецПроцедуры 

// Устарела. Следует использовать СтрНайти.
// Находит символ в строке с конца
//
Функция НайтиСимволСКонца(Знач СтрокаВся, Знач ОдинСимвол) Экспорт
	Возврат СтрНайти(СтрокаВся, ОдинСимвол, НаправлениеПоиска.СКонца);
КонецФункции

// Функция проверяет, является ли переданная в неё строка уникальным идентификатором
//
Функция ЭтоУникальныйИдентификатор(ИдентификаторСтрока) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ЭтоУникальныйИдентификатор(ИдентификаторСтрока);

КонецФункции

// Формирует строку повторяющихся символов заданной длины
//
Функция СформироватьСтрокуСимволов(Символ, КоличествоСимволов) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.СформироватьСтрокуСимволов(Символ, КоличествоСимволов);
	
КонецФункции

// Дополняет переданную в качестве первого параметра строку символами слева\справа до заданной длины и возвращает ее
// Незначащие символы слева и справа удаляются
// По умолчанию функция добавляет строку нулями слева
//
// Параметры:
//  Строка      - Строка - исходная строка, которую необходимо дополнить символами до заданной длины
//  ДлинаСтроки - Число - требуемая конечная длина строки
//  Символ      - Строка - (необязательный) значение символа, которым необходимо дополнить строку
//  Режим       - Строка - (необязательный) [Слева|Справа] режим добавления символов к исходной строке: слева или справа
// 
// Пример 1:
// Строка = "1234"; ДлинаСтроки = 10; Символ = "0"; Режим = "Слева"
// Возврат: "0000001234"
//
// Пример 2:
// Строка = " 1234  "; ДлинаСтроки = 10; Символ = "#"; Режим = "Справа"
// Возврат: "1234######"
//
// Возвращаемое значение:
//  Строка - строка, дополненная символами слева или справа
//
Функция ДополнитьСтроку(Знач Строка, Знач ДлинаСтроки, Знач Символ = "0", Знач Режим = "Слева") Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Строка, ДлинаСтроки, Символ, Режим)
	
КонецФункции

// Удаляет повторяющиеся символы слева/справа в переданной строке
//
// Параметры:
//  Строка      - Строка - исходная строка, из которой необходимо удалить повторяющиеся символы
//  Символ      - Строка - значение символа, который необходимо удалить
//  Режим       - Строка - (необязательный) [Слева|Справа] режим добавления символов к исходной строке: слева или справа
//
Функция УдалитьПовторяющиесяСимволы(Знач Строка, Знач Символ, Знач Режим = "Слева") Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.УдалитьПовторяющиесяСимволы(Строка,Символ,Режим);
	
КонецФункции

// Получает номер версии конфигурации без номера сборки
//
// Параметры:
//  Версия - Строка - версия конфигурации в формате РР.ПП.ЗЗ.СС,
//                    где СС – номер сборки, который будет удален
// 
//  Возвращаемое значение:
//  Строка - номер версии конфигурации без номера сборки в формате РР.ПП.ЗЗ
//
Функция ВерсияКонфигурацииБезНомераСборки(Знач Версия) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(Версия);
	
КонецФункции

// Преобразует исходную строку в число.
//   Превращает строку в число без вызова исключений. Стандартная функция преобразования.
//   Число() строго контролирует отсутствие каких-либо символов кроме числовых.
//
// Параметры:
//   ИсходнаяСтрока - Строка - Строка, которую необходимо привести к числу.
//
// Возвращаемое значение:
//   Число - Полученное число.
//   Неопределено - Если строка не является числом.
//
Функция СтрокаВЧисло(Знач ИсходнаяСтрока) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВЧисло(ИсходнаяСтрока);
	
КонецФункции

// Форматирует строку в соответствии с заданным шаблоном.
// Возможные значения тегов выделения:
//	<b> Строка </b> - выделяет строку жирным шрифтом.
//	<a href = "Ссылка"> Строка </a>
//
// Пример:
//	Минимальная версия программы <b>1.1</b>. <a href = "Обновление">Обновите</a> программу.
//
// Возвращаемое значение:
//	ФорматированнаяСтрока
Функция ФорматированнаяСтрока(Знач Строка) Экспорт
		
		Возврат СтроковыеФункцииКлиентСервер.ФорматированнаяСтрока(Строка);
		
	КонецФункции
	
#КонецОбласти

