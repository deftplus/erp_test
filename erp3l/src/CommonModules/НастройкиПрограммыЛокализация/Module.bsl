
#Область ПрограммныйИнтерфейс

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// см. НастройкиПроНастройкиПрограммыПереопределяемый.НастройкиПользователейИПравПриСозданииНаСервере.
//
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
	//++ Локализация
	БазоваяВерсия = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	СоставНабораКонстантФормы = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(Форма.НаборКонстант);
	
	Форма.Элементы.ГруппаИспользоватьГруппыДоступаФизЛиц.Видимость =
		НЕ БазоваяВерсия И СоставНабораКонстантФормы.Свойство("ОграничиватьДоступНаУровнеЗаписейФизическиеЛица");
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти