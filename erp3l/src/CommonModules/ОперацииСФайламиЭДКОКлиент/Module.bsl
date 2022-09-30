////////////////////////////////////////////////////////////////////////////////
// Подсистема "Операции с файлами".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает объект для работы с файлами. При необходимо компонента будет установлена.
//
// Параметры:
//  ОповещениеОЗавершении  - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Булево - описание ошибки выполнения.
//
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура СоздатьДвоичныеДанные(ОповещениеОЗавершении, ВыводитьСообщения = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.СоздатьДвоичныеДанные(ОповещениеОЗавершении, ВыводитьСообщения);
			
КонецПроцедуры

// Преобразует файл в строку Base64.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * СтрокаBase64   - Строка - файл преобразованный в Base64.
//
//  ИмяФайла          - Строка - файл, который необходимо преобразовать в  строку Base64.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные    - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
//  ПроверятьСуществование - Булево - если необходимо, то будет установлено расширение работы с файлами для проверки существования
//
Процедура ФайлВBase64(ОповещениеОЗавершении, ИмяФайла, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено, ПроверятьСуществование = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ФайлВBase64(ОповещениеОЗавершении, ИмяФайла, ВыводитьСообщения, ДвоичныеДанные, ПроверятьСуществование);
	
КонецПроцедуры

// Читает файл как текст.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * Текст          - Строка - текст из файла.
//
//  ИмяФайла          - Строка - файл, который необходимо преобразовать в  строку Base64.
//
//  КодировкаТекста   - Строка - указывается кодировка текста в открываемом файле.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные    - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура ФайлВТекст(ОповещениеОЗавершении, ИмяФайла, КодировкаТекста = "utf-8", ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ФайлВТекст(
		ОповещениеОЗавершении, ИмяФайла, КодировкаТекста, ВыводитьСообщения, ДвоичныеДанные);
	
КонецПроцедуры

// Преобразует строку Base64 в файл.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяФайла       - Строка - имя файла, в который был сохранен результат.
//
//  СтрокаBase64          - Строка - строка Base64, которую необходимо преобразовать в файл.
//
//  ИмяФайлаИлиРасширение - Строка - имя файла, в который необходимо сохранить результат.
//                                   Также можно указать только расширение создаваемого файла - ".расширение".
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные        - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура Base64ВФайл(ОповещениеОЗавершении, СтрокаBase64, ИмяФайлаИлиРасширение = Неопределено, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.Base64ВФайл(ОповещениеОЗавершении, СтрокаBase64, ИмяФайлаИлиРасширение, ВыводитьСообщения, ДвоичныеДанные);

КонецПроцедуры

// Сохраняет текст в файл.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяФайла       - Строка - имя файла, в который был сохранен результат.
//
//  Текст                 - Строка - текст, которую необходимо записать в файл.
//
//  ИмяФайлаИлиРасширение - Строка - имя файла, в который необходимо сохранить результат.
//                                   Также можно указать только расширение создаваемого файла - ".расширение".
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные        - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура ТекстВФайл(ОповещениеОЗавершении, Текст, ИмяФайлаИлиРасширение = Неопределено, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ТекстВФайл(ОповещениеОЗавершении, Текст, ИмяФайлаИлиРасширение, ВыводитьСообщения, ДвоичныеДанные);
	
КонецПроцедуры

// Получает имя каталога, который используется программой для размещения временных файлов.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяКаталога    - Строка - имя каталога временных файлов пользователя, от имени которого запущено приложение.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные    - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура КаталогВременныхФайловНаКлиенте(ОповещениеОЗавершении, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.КаталогВременныхФайловНаКлиенте(ОповещениеОЗавершении, ВыводитьСообщения, ДвоичныеДанные);
		
КонецПроцедуры

// Создает новый каталог в каталоге временных файлов.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяКаталога    - Строка - полное имя созданного каталога.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные    - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура СоздатьКаталогНаКлиенте(ОповещениеОЗавершении, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.СоздатьКаталогНаКлиенте(ОповещениеОЗавершении, ВыводитьСообщения, ДвоичныеДанные);
	
КонецПроцедуры

// Удаляет указанные файлы.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//
//  Путь              - Строка - путь к удаляемым файлам.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура УдалитьФайлыНаКлиенте(ОповещениеОЗавершении = Неопределено, Путь, ВыводитьСообщения = Ложь) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.УдалитьФайлыНаКлиенте(ОповещениеОЗавершении, Путь, ВыводитьСообщения);
	
КонецПроцедуры

// Получает уникальное имя временного файла. 
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяФайла       - Строка - полное имя временного файла.
//
//  Расширение        - Строка - указывает желаемое расширение имени временного файла.
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные    - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура ПолучитьИмяВременногоФайлаНаКлиенте(ОповещениеОЗавершении, Расширение = Неопределено, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ПолучитьИмяВременногоФайлаНаКлиенте(
		ОповещениеОЗавершении, Расширение, ВыводитьСообщения, ДвоичныеДанные);	
	
КонецПроцедуры

// Получает список свойств файла или каталога. 
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * СвойстваФайла  - Структура - свойства файла.
//        ** Имя              - Строка - имя файла.
//        ** ИмяБезРасширения - Строка - имя файла (без расширения).
//        ** ПолноеИмя        - Строка - полное имя файла (включающее путь к файлу).
//        ** Путь             - Строка - путь к файлу.
//        ** Расширение       - Строка - расширение имени файла.
//        ** Размер           - Число  - размер файла (в байтах).
//        ** Существует       - Булево - определяет, существует ли файл.
//        ** ЭтоКаталог       - Булево - если Истина, то каталог, иначе - файл.
//
//  ИмяФайла - Строка - полное имя файла или каталога.
//
Процедура ПолучитьСвойстваФайла(ОповещениеОЗавершении, ИмяФайла, ВыводитьСообщения = Ложь) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ПолучитьСвойстваФайла(ОповещениеОЗавершении, ИмяФайла, ВыводитьСообщения);
	
КонецПроцедуры

// Получает данные с сервера из временного хранилища и сохраняет на клиенте.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * ИмяФайла       - Строка - имя файла, в который был сохранен результат.
//
//  Адрес                 - Строка - адрес файла во временном хранилище.
//
//  ИмяФайлаИлиРасширение - Строка - имя файла, в который необходимо сохранить результат.
//                                   Также можно указать только расширение создаваемого файла - ".расширение".
//
//  ВыводитьСообщения     - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
//  ДвоичныеДанные        - AddIn  - объект используемый для работы с файлами. Если не задан, то будет создан новый.
//
Процедура ДанныеССервераВФайл(ОповещениеОЗавершении, Адрес, ИмяФайлаИлиРасширение = Неопределено, ВыводитьСообщения = Истина, ДвоичныеДанные = Неопределено) Экспорт

	ОперацииСФайламиЭДКОСлужебныйКлиент.ДанныеССервераВФайл(
		ОповещениеОЗавершении, Адрес, ИмяФайлаИлиРасширение, ВыводитьСообщения, ДвоичныеДанные);
	
КонецПроцедуры

// Получает данные с сервера в виде Base64. 
//
// Параметры:
//  Адрес - Строка - адрес файла во временном хранилище.
//
//  Возвращаемое значение:
//    Строка - файл преобразованный в Base64.    
//
Функция ДанныеССервераВBase64(Адрес) Экспорт

	Возврат ОперацииСФайламиЭДКОСлужебныйВызовСервера.ПолучитьФайлССервераКакСтроку(Адрес);
	
КонецФункции

// Открывает файл с использованием ассоциированного с ним приложения.
//
// Параметры:
//  ПолноеИмяФайлаИлиАдрес - Строка - полное имя файла, который необходимо открыть.
//                                  - адрес файла на сервере во временном хранилище.
//
//  ИмяФайла               - Строка - указывается имя, с которым необходимо сохранить файл, полученный с сервера.
//
//  ВыводитьСообщения      - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ОткрытьФайл(ПолноеИмяФайлаИлиАдрес, ИмяФайла = "", ВыводитьСообщения = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ОткрытьФайл(ПолноеИмяФайлаИлиАдрес, ИмяФайла, ВыводитьСообщения);		
	
КонецПроцедуры

// Сохраняет файлы в файловую систему.
//
// Параметры:
//  СохраняемыеФайлы - Массив - описания сохраняемых файлов. Массив структур.
//    * Имя   - Строка - имя сохраняемого файла
//    * Адрес - Строка - адрес с данными в памяти, подлежащие сохранению в файл
//                   - Сруктура - описания сохраняемого файла.
//    * Имя   - Строка - имя сохраняемого файла
//    * Адрес - Строка - адрес с данными в памяти, подлежащие сохранению в файл
//                   - Массив - описания сохраняемых файлов. Массив описаний передаваемых файлов.
//                   - ОписаниеПередаваемогоФайла - описания сохраняемого файла.
//
//  КаталогСохранения - Строка - каталог сохранения файлов. 
//    Если не указан, то будет отображен диалог выбора каталога.
//    Если в СохраняемыеФайлы передан массив описаний, то данный параметр игнорируется. 
//
//  ВыводитьСообщения - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура СохранитьФайлы(СохраняемыеФайлы, КаталогСохранения = Неопределено, ВыводитьСообщения = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.СохранитьФайлы(СохраняемыеФайлы, КаталогСохранения, ВыводитьСообщения);

КонецПроцедуры

// Выполняет запуск внешнего приложения либо открытие файла с использованием ассоциированного с ним приложения.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения, Неопределено - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ДвоичныеДанные - AddIn  - объект используемый для работы с файлами. Работать напрямую с объектом запрещено.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//      * КодВозврата    - Число        - код возврата. 
//                       - Неопределено - ДождатьсяЗавершения не указан.
//
//  СтрокаКоманды       - Строка - командная строка для запуска приложения либо имя файла, ассоциированного с некоторым приложением.
//
//  ДождатьсяЗавершения - Булево - определяет нужно ли дожидаться завершения запущенного приложения перед продолжением работы.
//
//  ВыводитьСообщения   - Булево - устанавливает признак необходимости выводить сообщения об ошибках.
//
Процедура ЗапуститьПриложениеНаКлиенте(ОповещениеОЗавершении, СтрокаКоманды, ДождатьсяЗавершения = Ложь, ВыводитьСообщения = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ЗапуститьПриложениеНаКлиенте(
		ОповещениеОЗавершении, СтрокаКоманды, "", ДождатьсяЗавершения, ВыводитьСообщения);

КонецПроцедуры

// Получает файл из Интернета по протоколу http(s) и сохраняет его во временном хранилище на сервере.
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * АдресФайла     - Строка - адрес файла во временном хранилище.
//      * ИмяФайла       - Строка - имя файла, полученное из URL.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//
//  URL                   - Строка - url файла в формате [Протокол://]<Сервер>/<Путь к файлу на сервере>.
//  Параметры             - Структуруа - дополнительные параметры для "тонкой" настройки.
//    * ПоясняющийТекст - Строка - текст, который будет показываться в форме индикатора загрузки.
//    * ВладелецФормы   - ФормаКлиентскогоПриложения - форма, которая будет указана в качестве владельца в форме индикатора.
//
Процедура СкачатьФайлНаСервереВФоне(ОповещениеОЗавершении, Знач URL, Знач Параметры = Неопределено) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.СкачатьФайлНаСервереВФоне(ОповещениеОЗавершении, URL, Параметры);
	
КонецПроцедуры

// Помещает выбранные пользователем файлы во временное хранилище.
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена и получен результат, иначе см. ОписаниеОшибки.
//      * ОписанияФайлов - Массив - описания файлов во временном хранилище.
//          ** Имя   - Строка - имя файла.
//          ** Адрес - Строка - адрес файла во временном хранилище.
//          ** Размер - Число - размер файла в байтах. Возвращается если задан параметр Параметры.ВозвращатьРазмер.
//      * ОписаниеОшибки - Строка - описание ошибки выполнения.
//
//  ИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор формы.
//                       Файлы помещаются во временное хранилище и автоматически удаляется после удаления объекта формы.
//  Заголовок          - Строка - текст заголовка окна диалога выбора файлов.
//  Параметры - Структура - дополнительные настройки.
//    * Фильтр - Строка - набор файловых фильтров. См. ДиалогВыбораФайла.Фильтр.
//    * МаксимальныйРазмерФайла - Число - максимальный размер файла в байтах, который можно добавить. 0 - значение неограничено.
//    * ВозвращатьРазмер - Булево - если Истина, то дополниетельно будет получен размер по каждому файлу.
//    * ДопустимыеТипыФайлов - Строка - допустимые типы файлов. Пример: "jpeg;jpg".
//    * МножественныйВыбор - Булево - Если Истина, то при наличии расширения работы с файлами можно выбрать несколько файлов. По умолчанию Истина.
//    * Требования - Структура - см ТребованияКСканам(). Если указаны, то будет выполнено преобразование файлов к этим требованиям.
//
//  ВозможноПродолжениеБезУстановкиРасширения - Булево - возможно ли продолжить без установки расширения работы с файлами.
//
Процедура ДобавитьФайлы(ОповещениеОЗавершении, ИдентификаторФормы = Неопределено, Заголовок = "", Параметры = Неопределено, ВозможноПродолжениеБезУстановкиРасширения = Истина) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ДобавитьФайлы(ОповещениеОЗавершении, ИдентификаторФормы, Заголовок, Параметры, ВозможноПродолжениеБезУстановкиРасширения);
	
КонецПроцедуры

// Добавляет сканы через форму предпросмотра
//
// Параметры:
//  ОповещениеОЗавершении - ОписаниеОповещения - описание процедуры, принимающей результат.
//    Результат - Структура:
//      * Выполнено      - Булево - если Истина, то процедура успешно выполнена.
//      * Файлы - Массив - описания файлов во временном хранилище.
//          ** ИсходноеИмя   - Строка - имя файла.
//          ** Адрес         - Строка - адрес файла во временном хранилище.
//          ** Размер        - Число - размер файла в байтах.
//
//  ИдентификаторФормы - УникальныйИдентификатор - уникальный идентификатор формы.
//                       Файлы помещаются во временное хранилище и автоматически удаляется после удаления объекта формы.
//  Заголовок          - Строка - текст заголовка окна диалога выбора файлов.
//  Параметры          - Структура - см метод ПараметрыМетодаДобавитьФайлыСПредпросмотром
//
Процедура ДобавитьФайлыСПредпросмотром(ОповещениеОЗавершении, ИдентификаторФормы, Заголовок, Параметры) Экспорт
	
	ОперацииСФайламиЭДКОСлужебныйКлиент.ДобавитьФайлыСПредпросмотром(ОповещениеОЗавершении, ИдентификаторФормы, Заголовок, Параметры);
	
КонецПроцедуры

Функция ПараметрыМетодаДобавитьФайлыСПредпросмотром() Экспорт
	
	ПараметрыФункции = Новый Структура;
	
	// МаксимальныйРазмерФайла - Число - максимальный размер файла в байтах, который можно добавить. 0 - значение неограничено.
	ПараметрыФункции.Вставить("МаксимальныйРазмерФайла", 	0);
	
	// РежимТолькоПросмотр - Булево - Запрещает добавлять и изменять картинки в форму просмотра.
	// В этом случае форма предназанчена только для просмотра
	ПараметрыФункции.Вставить("РежимТолькоПросмотр", 		Ложь);
	
	// ИспользоватьСтраницы - Булево - требовать ли указания номера страницы в форме ПросмотрДокументов
	// Номера страниц нужны, например, в макете пенсионных дел.
	ПараметрыФункции.Вставить("ИспользоватьСтраницы", 		Ложь);
	
	// * Требования - Структура - Описание требований, которые нужно показать в форме требований к изображению
	//   ТребованияКИзображениямУниверсальная и к которым нужно преобразовать файлы. См ТребованияКСканам()
	ПараметрыФункции.Вставить("Требования", Неопределено);
	
	// * Файлы - Массив - описания ранее добавленных файлов во временном хранилище, которые нужно открыть в форме предпросмотра
	//   ** ИсходноеИмя   - Строка - имя файла.
	//   ** Адрес         - Строка - адрес файла во временном хранилище.
	ПараметрыФункции.Вставить("Файлы", Неопределено);
	
	// Документ - Строка - Заголовок формы ПросмотрДокументов
	ПараметрыФункции.Вставить("Документ", "");
	
	Возврат ПараметрыФункции;
	
КонецФункции

Функция ТекстСообщенияДляНеобязательнойУстановкиРасширенияРаботыСФайлами() Экспорт
	
	ТекстСообщения = НСтр("ru = 'Для удобной загрузки файлов рекомендуется установить расширение работы с файлами.
                           |';
                           |en = 'Для удобной загрузки файлов рекомендуется установить расширение работы с файлами.
                           |'");
	
	Возврат ТекстСообщения;
	
КонецФункции

// Преобразовывает изображения в соотвествии с указанными параметрами.
// Файлы, которые не являются изображениями будут возвращены без преобразования.
// Файлы, на преобразовании которых возникла ошибка, не добавляются в Результат.ОписанияФайлов
//
// Параметры:
//  ОповещениеОЗавершении	 - ОписаниеОповещения - описание процедуры, принимающей результат. - 
//    Результат - Массив структур - Если массив пустой, значит не удалось обработать ни один файл.
//      * Выполнено      - Булево - если Истина, означает, что возвращено хотя бы один элемент в ОписанияФайлов.
//      * Отменено       - Булево - если Истина, означает загрузка файлов была полностью отменена.
//      * ОписанияФайлов - Массив - описания файлов во временном хранилище.
//          ** Имя   - Строка - имя файла (после обработки может измениться расширение).
//          ** Адрес - Строка - адрес файла во временном хранилище.
//          ** Идентификатор - Произвольный - Произвольное сериализуемое значение для дополнительной идентификации/принадлежности файла при необходимости.
//  * ОписанияФайлов - Массив - описания файлов во временном хранилище.
//     ** Имя   - Строка - имя файла.
//     ** Адрес - Строка - адрес файла во временном хранилище.
//     ** Размер - Число - размер в байтах.
//     ** Идентификатор - Произвольный - Значение сохраняется из входящего параметра.
//     ** Размер - Число - Размер в байта.
//  Требования - Структура - дополнительные настройки, см ТребованияКСканам(). Все эти требования можно посмотреть в свойствах картинки Windows.
//    Обязательные:
//    * ДопустимыеТипыФайлов - Строка - допустимые типы файлов. Пример: "jpeg;jpg".
//                           - Массив - Массив форматов (ФорматКартинки) или строк (расширений) или смешанный (форматов и расширений)
//    * РасширениеПоУмолчанию - Строка - расширение без точки, которое будет указано для картинки неподходящего формата.
//    Необязательные:
//    * ГлубинаЦвета - ГлубинаЦвета, Неопределено - Строка из перечисления Системные перечисления/Интерфейсные/ГлубинаЦвета.
//        Нужна именно срока, так как перечисление ГлубинаЦвета не сериализируется.
//        Если указано, что "Количество бит на компонент = 8" и "Компоненты цвета = 3", то это означает глубинау цвета БитНаПиксел24 (8*3)
//    * ПреобразоватьВОттенкиСерого - Булево - Истина, если надо преобразовать в оттенки серого.
//        ПреобразоватьВОттенкиСерого будет работать только для PNG и TIFF (См СП для ПреобразоватьВОттенкиСерого)
//        Если указано "Цветность: 256 оттенков серого", то нужно ГлубинаЦвета - БитНаПиксел8 и ПреобразоватьВОттенкиСерого = Истина,
//        так как при 8-би́тном цвете максимальное количество цветов, которые могут быть отображены одновременно - 256 (2^8)
//    * МинимальнаяПлотность - Число (число точек на дюйм (DPI)) - минимально допустимая плотность (разрешение) изображения. 0 - значение неограничено.
//    * МаксимальнаяПлотность - Число (число точек на дюйм (DPI)) - максимально допустимая плотность (разрешение) изображения. 0 - значение неограничено.
//    * МаксимальныйРазмерФайла - Число - максимальный размер файла в байтах, который можно добавить. 0 - значение неограничено.        
//    * Пояснение - Строка - Любой текст, который нужно вывести в форме требования к сканам
//
Процедура ОбработатьКартинки(ОповещениеОЗавершении, ОписанияФайлов, Требования) Экспорт
	ОперацииСФайламиЭДКОСлужебныйКлиент.ОбработатьКартинки(ОповещениеОЗавершении, ОписанияФайлов, Требования);
КонецПроцедуры

// Параметры метода ОбработатьКартинки
Функция ТребованияКСканам() Экспорт

	// Описание свойств см ОбработатьКартинки()
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ДопустимыеТипыФайлов", 		"");
	ДополнительныеПараметры.Вставить("РасширениеПоУмолчанию", 		РасширениеПоУмолчанию());
	// Необязательные:
	ДополнительныеПараметры.Вставить("ГлубинаЦвета", 				Неопределено); // по-русски
	ДополнительныеПараметры.Вставить("ПреобразоватьВОттенкиСерого", Ложь);
	ДополнительныеПараметры.Вставить("МинимальнаяПлотность", 		0);
	ДополнительныеПараметры.Вставить("МаксимальнаяПлотность", 		0);
	ДополнительныеПараметры.Вставить("МаксимальныйРазмерФайла", 	0);
	
	// Дополнительная информация, которая будет выведена в поле Пояснение формы ТребованияКИзображениямУниверсальная 
	ДополнительныеПараметры.Вставить("Пояснение",                   "");
	// Если можно добавлять не только картинки, например в письмах можное еще отправлять doc
	ДополнительныеПараметры.Вставить("РазрешатьДругиеТипы",         Ложь);
	ДополнительныеПараметры.Вставить("ИгнорироватьОшибки",          Ложь);
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

Функция РасширениеПоУмолчанию() Экспорт
	
	Возврат "png";
	
КонецФункции

#КонецОбласти


