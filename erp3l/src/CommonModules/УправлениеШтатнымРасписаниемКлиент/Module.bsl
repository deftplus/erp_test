////////////////////////////////////////////////////////////////////////////////
// УправлениеШтатнымРасписаниемКлиент:
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ОткрытьФормуДокументаИзменившегоПозицию(СсылкаНаДокумент, ПозицияШтатногоРасписания, Владелец, Оповещение = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(СсылкаНаДокумент) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Ключ", СсылкаНаДокумент);
		ПараметрыОткрытия.Вставить("ТекущаяПозиция", ПозицияШтатногоРасписания);
		
		ПолноеИмяМетаданных = УправлениеШтатнымРасписаниемВызовСервера.ПолноеИмяМетаданныхДокумента(СсылкаНаДокумент);
		ОткрытьФорму(ПолноеИмяМетаданных + ".ФормаОбъекта", ПараметрыОткрытия, Владелец, , , , Оповещение);
		
	КонецЕсли; 
	
КонецПроцедуры


#Область ПроцедурыИФункцииДляОтображенияНачисленийВФормеСправочникаШтатноеРасписание

Процедура РедактированиеСостоянияШРПриИзмененииНачислений(Форма, НачисленияПутьКДанным, ИмяТаблицыПозиции, ИмяТаблицыНачисления, УдалениеНачисления = Ложь) Экспорт
	
	ДанныеТекущейСтрокиПозиция    = Форма.Элементы[ИмяТаблицыПозиции].ТекущиеДанные;
	МаксимальноеКоличествоПоказателей = ЗарплатаКадрыРасширенныйКлиентСервер.МаксимальноеКоличествоПоказателей(Форма, ИмяТаблицыНачисления);
	
	НачисленияДанныеФормы = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, НачисленияПутьКДанным);
	
	Если ДанныеТекущейСтрокиПозиция <> Неопределено Тогда
		
		ДанныеТекущейСтрокиНачисления = Форма.Элементы[ИмяТаблицыНачисления].ТекущиеДанные;
		Если ДанныеТекущейСтрокиНачисления <> Неопределено Тогда
			
			Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьВилкуСтавокВШтатномРасписании") Тогда
				Для СчПоказателей = 1 По МаксимальноеКоличествоПоказателей Цикл
					ДанныеТекущейСтрокиНачисления["МинимальноеЗначение" + СчПоказателей] = ДанныеТекущейСтрокиНачисления["МаксимальноеЗначение" + СчПоказателей];
				КонецЦикла;
			КонецЕсли;
			
		КонецЕсли;
		
		НачисленияПозиции = НачисленияДанныеФормы.НайтиСтроки(Новый Структура("ИдентификаторСтрокиПозиции", ДанныеТекущейСтрокиПозиция.ИдентификаторСтрокиПозиции));
		
		Если Не УдалениеНачисления Тогда
			ДействующиеНачисления = Новый Массив;
			Для каждого НачислениеПозиции Из НачисленияПозиции Цикл
				Если НачислениеПозиции.Действие = ПредопределенноеЗначение("Перечисление.ДействияСНачислениямиИУдержаниями.Отменить") Тогда
					Продолжить;
				КонецЕсли;
				ДействующиеНачисления.Добавить(НачислениеПозиции);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры	

#КонецОбласти

#Область ПроцедурыИФункцииНастройкиФормКадровыхДокументовДляПроверкиШтатногоРасписания

Процедура ОбработатьРезультатыПроверки(Форма, АдресРезультатаПроверки) Экспорт
	
	Перем МассивРезультатовПроверки;
	
	Если АдресРезультатаПроверки <> Неопределено Тогда
		СтруктураРезультатовПроверки = ПолучитьИзВременногоХранилища(АдресРезультатаПроверки);
		СтруктураРезультатовПроверки.Свойство("ПроблемыТекущегоДокумента", МассивРезультатовПроверки);
	КонецЕсли; 
	
	ПроверяемыеРеквизиты = Форма.РеквизитыПроверяемыеНаСоответствиеНаКлиенте();
	
	ОчиститьРеквизитыПроверки(Форма, ПроверяемыеРеквизиты);
	
	Если МассивРезультатовПроверки <> Неопределено Тогда
		
		Для Каждого РезультатыПроверки Из МассивРезультатовПроверки Цикл
			
			РеквизитыШапки = ПроверяемыеРеквизиты.РеквизитыШапки;
			Для Каждого РеквизитШапки Из РеквизитыШапки Цикл
				ИмяРеквизита = РеквизитШапки.Ключ;
				ИмяЭлементаФормы = РеквизитШапки.Значение;
				НеПрошелПроверку = Неопределено;
				Если РезультатыПроверки <> Неопределено И РезультатыПроверки.Свойство(ИмяРеквизита + "НеСоответствуетПозиции", НеПрошелПроверку) Тогда
					Если НеПрошелПроверку Тогда
						Форма.Элементы[ИмяЭлементаФормы].ЦветТекста = Форма.ЦветаСтиляПоясняющийОшибкуТекст;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			ТабличныеЧасти = ПроверяемыеРеквизиты.ТабличныеЧасти;
			Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
				
				ОписаниеТабличнойЧасти = ТабличнаяЧасть.Значение;
				
				РасшифровкаНачислений = Неопределено;
				Если РезультатыПроверки <> Неопределено
					И РезультатыПроверки.Свойство("РасшифровкаНачислений", РасшифровкаНачислений)
					И РасшифровкаНачислений <> Неопределено Тогда
					
					Для Каждого РасшифровкаНачисления Из РасшифровкаНачислений Цикл
						
						Если ОписаниеТабличнойЧасти.СтруктураПоиска.Свойство("Сотрудник") Тогда
							ОписаниеТабличнойЧасти.СтруктураПоиска.Сотрудник = РезультатыПроверки.Сотрудник;
						КонецЕсли; 
						Если ОписаниеТабличнойЧасти.СтруктураПоиска.Свойство("ДолжностьПоШтатномуРасписанию") Тогда
							ОписаниеТабличнойЧасти.СтруктураПоиска.ДолжностьПоШтатномуРасписанию = РезультатыПроверки.ПозицияШтатногоРасписания;
						КонецЕсли; 
						
						ЗаполнитьЗначенияСвойств(ОписаниеТабличнойЧасти.СтруктураПоиска, РасшифровкаНачисления);
						
						Если ТабличнаяЧасть.Значение.Свойство("ПутьКДанным") Тогда
							ПутьКДанным = ТабличнаяЧасть.Значение.ПутьКДанным;
						Иначе
							ПутьКДанным = "Объект." + ТабличнаяЧасть.Ключ;
						КонецЕсли;
						ДанныеФормы = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДанным);
						
						НайденныеСтроки = ДанныеФормы.НайтиСтроки(ОписаниеТабличнойЧасти.СтруктураПоиска);
						
						Если НайденныеСтроки.Количество() > 0 Тогда
							
							СтрокаДокумента = НайденныеСтроки[0];
							Если РасшифровкаНачисления.Свойство(ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия) Тогда
								СтрокаДокумента[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия] = РасшифровкаНачисления[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия];
							Иначе
								СтрокаДокумента[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия] = РезультатыПроверки[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия];
							КонецЕсли;
							
							Если ОписаниеТабличнойЧасти.РасшифровкаНачислений Тогда
								
								Показатель = РасшифровкаНачисления.Показатель;
								Если ЗначениеЗаполнено(Показатель) Тогда
									
									Для НомерПоказателя = 1 По ОписаниеТабличнойЧасти.МаксимальноеКоличествоПоказателей Цикл
										Если Показатель = СтрокаДокумента["Показатель" + НомерПоказателя] Тогда
											Прервать;
										КонецЕсли; 
									КонецЦикла;
									Если НомерПоказателя <= ОписаниеТабличнойЧасти.МаксимальноеКоличествоПоказателей Тогда
										СтрокаДокумента[ОписаниеТабличнойЧасти.ОписаниеСоответствияПоказателей["Показатель" + НомерПоказателя]] = РасшифровкаНачисления.ПоказательНеСоответствуетПозиции;
										СтрокаДокумента[ОписаниеТабличнойЧасти.ОписаниеСоответствияПоказателей["Значение" + НомерПоказателя]] = РасшифровкаНачисления.ЗначениеНеСоответствуетПозиции;
									Иначе
										СтрокаДокумента[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия] = Истина;
									КонецЕсли;
								Иначе
									СтрокаДокумента[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия] = Истина;
								КонецЕсли;
								
							КонецЕсли; 
							
						КонецЕсли;
							
					КонецЦикла;
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОчиститьРеквизитыПроверки(Форма, ПроверяемыеРеквизиты)
	
	РеквизитыШапки = ПроверяемыеРеквизиты.РеквизитыШапки;
	Для Каждого РеквизитШапки Из РеквизитыШапки Цикл
		ИмяЭлементаФормы = РеквизитШапки.Значение;
		Форма.Элементы[ИмяЭлементаФормы].ЦветТекста = Форма.ЦветаСтиляЦветТекстаПоля;
	КонецЦикла;
	
	ТабличныеЧасти = ПроверяемыеРеквизиты.ТабличныеЧасти;
	Для Каждого ТабличнаяЧасть Из ТабличныеЧасти Цикл
		
		ОписаниеТабличнойЧасти = ТабличнаяЧасть.Значение;
		
		Если ОписаниеТабличнойЧасти.Свойство("ПутьКДанным") Тогда
			ПутьКДанным = ОписаниеТабличнойЧасти.ПутьКДанным;
		Иначе
			ПутьКДанным = "Объект." + ТабличнаяЧасть.Ключ;
		КонецЕсли;
		ДанныеФормы = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ПутьКДанным);
		
		// Сбросим флаги несоответствия позиции для всех строк.
		Для каждого СтрокаТЧ Из ДанныеФормы Цикл
			СтрокаТЧ[ОписаниеТабличнойЧасти.РеквизитНесоответствияСтроки.ИмяРеквизитаНесоответствия] = Ложь;
			Если ОписаниеТабличнойЧасти.ОписаниеСоответствияПоказателей <> Неопределено Тогда
				Для каждого ЭлементОписанияТабличнойЧасти Из ОписаниеТабличнойЧасти.ОписаниеСоответствияПоказателей Цикл
					СтрокаТЧ[ЭлементОписанияТабличнойЧасти.Значение] = Ложь;
				КонецЦикла;
			КонецЕсли; 
		КонецЦикла;
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииФормыДокументов

Процедура УдалитьВыделенныеСтрокиПозицийИзДокумента(Форма)
	
	Форма.УдалитьНачисленияИЕжегодныеОтпуска();
	
	УдаляемыеСтроки = Новый Массив;
	Для каждого ИдентификаторСтроки Из Форма.Элементы.Позиции.ВыделенныеСтроки Цикл
		УдаляемыеСтроки.Добавить(Форма.Объект.Позиции.НайтиПоИдентификатору(ИдентификаторСтроки));
	КонецЦикла;
	
	Для каждого УдаляемаяСтрока Из УдаляемыеСтроки Цикл
		Форма.Объект.Позиции.Удалить(УдаляемаяСтрока);
	КонецЦикла;
	
	Форма.Модифицированность = Истина;
	
КонецПроцедуры

Процедура ЗакрытьПозицию(Форма, РазрешеноУдаление = Ложь, ОповещениеЗавершения = Неопределено) Экспорт
	
	ЕстьНовыеПозиции = Ложь;
	ВсеПозицииНовые = Истина;
	
	Элементы = Форма.Элементы;
	
	Для Каждого ИдентификаторСтроки Из Элементы.Позиции.ВыделенныеСтроки Цикл 
		СтрокаПозиции = Форма.Объект.Позиции.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если СтрокаПозиции.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию") Тогда
			ЕстьНовыеПозиции = Истина;
		Иначе
			ВсеПозицииНовые = Ложь; 
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьНовыеПозиции Тогда
		
		Если ВсеПозицииНовые Тогда
			УдалитьВыделенныеСтрокиПозицийИзДокумента(Форма);
		Иначе
			
			ПоказатьПредупреждение(, НСтр("ru = 'Среди выделенных строк, есть еще не созданные позиции штатного расписания, 
				|если вы не хотите создавать эти позиции, удалите соответствующие строки.';
				|en = 'There are lines among the selected ones where staff list positions were not created. Delete the corresponding lines
				|if you do not want to create these positions.'"));
			
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	КоличествоПозиций = Элементы.Позиции.ВыделенныеСтроки.Количество();
	
	Если КоличествоПозиций = 1 Тогда
		Действие = Форма.Объект.Позиции.НайтиПоИдентификатору(Элементы.Позиции.ВыделенныеСтроки[0]).Действие;
		Если Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка") Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Хотите закрыть действующую позицию ""%1""?';
																						|en = 'Do you want to close the ""%1"" current position?'"), Элементы.Позиции.ТекущиеДанные.Позиция);
		Иначе
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Хотите отменить закрытие позиции ""%1""?';
																						|en = 'Do you want to cancel closing of position ""%1""?'"), Элементы.Позиции.ТекущиеДанные.Позиция);
		КонецЕсли;
	ИначеЕсли КоличествоПозиций > 1 Тогда  
		Действие = Форма.Объект.Позиции.НайтиПоИдентификатору(Элементы.Позиции.ВыделенныеСтроки[0]).Действие;
		Если Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка") Тогда
			Если КоличествоПозиций <= 4 Тогда
				СтрокаПодстановки = НСтр("ru = 'действующие позиции';
										|en = 'valid positions'");
			Иначе
				ПоследниеДвеЦифры = ?(Цел(КоличествоПозиций * 0.01) < 1, КоличествоПозиций, КоличествоПозиций - Цел(КоличествоПозиций * 0.01) * 100);
				Если ПоследниеДвеЦифры >= 5 И ПоследниеДвеЦифры <= 20 Тогда
					СтрокаПодстановки = НСтр("ru = 'действующих позиций';
											|en = 'current positions'");
				Иначе
					ПоследняяЦифра = ?(Цел(ПоследниеДвеЦифры * 0.1) < 1, ПоследниеДвеЦифры, ПоследниеДвеЦифры - Цел(ПоследниеДвеЦифры * 0.1) * 10);
					Если ПоследняяЦифра = 1 Тогда 
						СтрокаПодстановки = НСтр("ru = 'действующую позицию';
												|en = 'the current position'");
					ИначеЕсли ПоследняяЦифра >= 2 И ПоследняяЦифра <= 4 Тогда	
						СтрокаПодстановки = НСтр("ru = 'действующие позиции';
												|en = 'valid positions'");
					ИначеЕсли ПоследняяЦифра  = 0 ИЛИ (ПоследняяЦифра >= 5 И ПоследняяЦифра <= 9)Тогда
						СтрокаПодстановки = НСтр("ru = 'действующих позиций';
												|en = 'current positions'");	
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;	
			ТекстВопроса =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Хотите закрыть %1 %2 штатного расписания?';
																						|en = 'Do you want to close %1 %2 of staff list?'"), Формат(КоличествоПозиций, "ЧГ=0"), СтрокаПодстановки);
		Иначе
			ТекстВопроса =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Хотите отменить закрытие %1 позиций штатного расписания?';
																						|en = 'Do you want to cancel closing of %1 positions of the staff list?'"), Формат(КоличествоПозиций, "ЧГ=0"));
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбраны закрываемые позиции.';
										|en = 'Closed positions are not selected.'"));
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Действие", Действие);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если РазрешеноУдаление Тогда
		
		КнопкиДиалога = Новый СписокЗначений;
		
		Если Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка") Тогда
			
			Если КоличествоПозиций > 1 Тогда
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Закрыть позиции';
																	|en = 'Close positions'"));
			Иначе
				КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Закрыть позицию';
																	|en = 'Close position'"));
			КонецЕсли;
			
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Отменить закрытие';
																|en = 'Cancel closing'"));
		КонецЕсли;
		
		Если КоличествоПозиций > 1 Тогда
			КнопкиДиалога.Добавить("УдалитьСтроки", НСтр("ru = 'Удалить строки';
														|en = 'Remove lines'"));
		Иначе
			КнопкиДиалога.Добавить("УдалитьСтроки", НСтр("ru = 'Удалить строку';
														|en = 'Remove the line'"));
		КонецЕсли;
		
		КнопкиДиалога.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Отмена';
															|en = 'Cancel'"));
		
		Оповещение = Новый ОписаниеОповещения("ЗакрытьПозициюЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиДиалога, , "УдалитьСтроки", НСтр("ru = 'Закрытие позиций';
																						|en = 'Close positions'"));
		
	Иначе
		// Если не разрешено удаление - закрываем позиции
		ЗакрытьПозициюЗавершение(КодВозвратаДиалога.Да, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗакрытьПозициюЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	Элементы = Форма.Элементы;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Действие = ДополнительныеПараметры.Действие;
		Для Каждого ИдентификаторСтроки Из Элементы.Позиции.ВыделенныеСтроки Цикл 
			СтрокаПозиции = Форма.Объект.Позиции.НайтиПоИдентификатору(ИдентификаторСтроки);
			Если Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка") Тогда
				СтрокаПозиции.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ЗакрытьПозицию");
			Иначе
				СтрокаПозиции.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка");
			КонецЕсли;
			СтрокаПозиции.Комментарий = УправлениеШтатнымРасписаниемКлиентСервер.ПолучитьКомментарийКДействиюСПозициейШР(
				СтрокаПозиции, Форма);
		КонецЦикла;
		
		Форма.Модифицированность = Истина;
		
	ИначеЕсли Ответ = "УдалитьСтроки" Тогда
		УдалитьВыделенныеСтрокиПозицийИзДокумента(Форма);
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПереместитьНачисление(Форма, НаправлениеВверх) Экспорт
	
	Если Форма.Элементы.Начисления.ТекущиеДанные <> Неопределено Тогда
		
		Если Форма.Элементы.Начисления.ОтборСтрок <> Неопределено Тогда
			
			СтруктураОтбора = Новый Структура;
			Для каждого ЭлементОтбора Из Форма.Элементы.Начисления.ОтборСтрок Цикл
				СтруктураОтбора.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
			КонецЦикла;
			
			НайденныеСтроки = Форма.Объект.Начисления.НайтиСтроки(СтруктураОтбора);
			Если НайденныеСтроки.Количество() > 1 Тогда
				
				НомерТекущейСтроки = Форма.Элементы.Начисления.ТекущиеДанные.НомерСтроки;
				СтрокаЗамены = Неопределено;
				Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
					
					Если НаправлениеВверх Тогда
						Если НайденнаяСтрока.НомерСтроки >= НомерТекущейСтроки Тогда
							Продолжить;
						КонецЕсли; 
						Если СтрокаЗамены = Неопределено 
							ИЛИ СтрокаЗамены.НомерСтроки < НайденнаяСтрока.НомерСтроки Тогда
							СтрокаЗамены = НайденнаяСтрока;
						КонецЕсли; 
					Иначе
						Если НайденнаяСтрока.НомерСтроки <= НомерТекущейСтроки Тогда
							Продолжить;
						КонецЕсли; 
						Если СтрокаЗамены = Неопределено 
							ИЛИ СтрокаЗамены.НомерСтроки > НайденнаяСтрока.НомерСтроки Тогда
							СтрокаЗамены = НайденнаяСтрока;
						КонецЕсли; 
					КонецЕсли;
					
				КонецЦикла;
				
				Если СтрокаЗамены <> Неопределено И СтрокаЗамены.НомерСтроки - НомерТекущейСтроки <> 0 Тогда
					Форма.Объект.Начисления.Сдвинуть(Форма.Объект.Начисления.Индекс(Форма.Элементы.Начисления.ТекущиеДанные), СтрокаЗамены.НомерСтроки - НомерТекущейСтроки);
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОповеститьОЗаписиПозицийШтатногоРасписания(Форма) Экспорт
	
	Если Форма.ИзмененныеПозиции <> Неопределено Тогда
		
		Оповестить("СохраненыПозицииШтатногоРасписания", Новый Соответствие(Форма.ИзмененныеПозиции), Форма.ВладелецФормы);
		Форма.ИзмененныеПозиции = Неопределено;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыПозиции

Процедура ПозицииПриАктивизацииСтроки(Форма, Позиции, РазрешеноУдаление = Ложь) Экспорт
	
	Элементы = Форма.Элементы;
	ТекущиеДанные = Элементы.Позиции.ТекущиеДанные;
	
	Если РазрешеноУдаление
		ИЛИ ТекущиеДанные = Неопределено
		ИЛИ ТекущиеДанные.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию")
		ИЛИ НЕ ЗначениеЗаполнено(ТекущиеДанные.Должность)
		ИЛИ НЕ ЗначениеЗаполнено(ТекущиеДанные.Подразделение) Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПозицииУдалить",
			"Доступность",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПозицииКонтекстноеМенюУдалить",
			"Доступность",
			Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПозицииУдалить",
			"Доступность",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ПозицииКонтекстноеМенюУдалить",
			"Доступность",
			Ложь);
		
	КонецЕсли;
	
	Если Форма.ТолькоПросмотр ИЛИ Элементы.Позиции.ВыделенныеСтроки.Количество() = 0 Тогда
		ДоступностьКнопкиЗакрытьПозицию = Ложь;
	Иначе
		ДоступностьКнопкиЗакрытьПозицию = Истина;
		ЕстьЗакрытые = Ложь;
		ЕстьОткрытые = Ложь;
		Для каждого ИдентификаторВыделеннойСтроки Из Элементы.Позиции.ВыделенныеСтроки Цикл
			ВыделеннаяСтрока = Позиции.НайтиПоИдентификатору(ИдентификаторВыделеннойСтроки);
			Если ВыделеннаяСтрока = Неопределено 
				ИЛИ ВыделеннаяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию")
				ИЛИ НЕ ЗначениеЗаполнено(ВыделеннаяСтрока.Позиция) Тогда
				ДоступностьКнопкиЗакрытьПозицию = Ложь;
				Прервать;
			КонецЕсли;
			ЕстьЗакрытые = ЕстьЗакрытые ИЛИ ВыделеннаяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ЗакрытьПозицию");
			ЕстьОткрытые = ЕстьОткрытые ИЛИ ВыделеннаяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.ПустаяСсылка");
			Если ЕстьЗакрытые И ЕстьОткрытые Тогда
				ДоступностьКнопкиЗакрытьПозицию = Ложь;
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ЗакрытьПозиции",
		"Доступность",
		ДоступностьКнопкиЗакрытьПозицию);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"ПозицииКонтекстноеМенюЗакрытьПозицию",
		"Доступность",
		ДоступностьКнопкиЗакрытьПозицию);
	
КонецПроцедуры

Процедура ПозицииПриНачалеРедактирования(Форма, Позиции, ИдентификаторСтроки, НоваяСтрока, Копирование) Экспорт
	
	Элементы = Форма.Элементы;
	ТекущиеДанные = Позиции.НайтиПоИдентификатору(ИдентификаторСтроки);
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию");
		
		Форма.ИдентификаторСтрокиПозицииМакс = Форма.ИдентификаторСтрокиПозицииМакс + 1;
		ТекущиеДанные.ИдентификаторСтрокиПозиции = Форма.ИдентификаторСтрокиПозицииМакс;
		ТекущиеДанные.Комментарий = УправлениеШтатнымРасписаниемКлиентСервер.ПолучитьКомментарийКДействиюСПозициейШР(
			ТекущиеДанные, Форма);
		
		Элементы.ПозицииУдалить.Доступность = Истина;
		
	КонецЕсли;
	
	Если Копирование Тогда
		
		ТекущиеДанные.Позиция = ПредопределенноеЗначение("Справочник.ШтатноеРасписание.ПустаяСсылка"); 
		ТекущиеДанные.ТекущееКоличествоСтавок = 0;
		Если Не ЗначениеЗаполнено(ТекущиеДанные.КоличествоСтавок) Тогда
			ТекущиеДанные.КоличествоСтавок = 1;
		КонецЕсли;
		
	ИначеЕсли НоваяСтрока Тогда
		ТекущиеДанные.КоличествоСтавок = 1;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПозицииПередУдалением(Форма, Отказ, РазрешеноУдаление = Ложь) Экспорт
	
	ОбрабатываютсяНовыеПозиции = Ложь;
	ОбрабатываютсяСуществующиеПозиции = Ложь;
	
	Для каждого ИдентификаторВыделеннойСтроки Из Форма.Элементы.Позиции.ВыделенныеСтроки Цикл
		
		ВыделеннаяСтрока = Форма.Объект.Позиции.НайтиПоИдентификатору(ИдентификаторВыделеннойСтроки);
		Если ВыделеннаяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСПозициямиШтатногоРасписания.СоздатьНовуюПозицию")
			Или Не ЗначениеЗаполнено(ВыделеннаяСтрока.Позиция) Тогда
			
			ОбрабатываютсяНовыеПозиции = Истина;
			
		Иначе
			ОбрабатываютсяСуществующиеПозиции = Истина;
		КонецЕсли;
		
		Если ОбрабатываютсяНовыеПозиции И ОбрабатываютсяСуществующиеПозиции Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОбрабатываютсяСуществующиеПозиции Тогда
		Отказ = Истина;
		ЗакрытьПозицию(Форма, РазрешеноУдаление);
	КонецЕсли;
	
	Если ОбрабатываютсяНовыеПозиции ИЛИ РазрешеноУдаление Тогда
		Форма.УдалитьНачисленияИЕжегодныеОтпуска();
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыНачисления

Процедура НачисленияПриАктивизацииСтроки(Форма, ОписаниеКоманднойПанелиНачислений) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриАктивизацииСтроки(Форма, "Начисления", "НачисленияНачисление", 0, ОписаниеКоманднойПанелиНачислений);
	
КонецПроцедуры

Процедура НачисленияПриНачалеРедактирования(Форма, НоваяСтрока, Копирование, ВнешниеДанные) Экспорт
	
	Если НоваяСтрока Тогда
		
		Если Форма.Элементы.Начисления.ТекущиеДанные.Свойство("ИдентификаторСтрокиПозиции") Тогда
			Форма.Элементы.Начисления.ТекущиеДанные.ИдентификаторСтрокиПозиции = Форма.Элементы.Позиции.ТекущиеДанные.ИдентификаторСтрокиПозиции;
		КонецЕсли;
		
		Если Форма.Элементы.Начисления.ТекущиеДанные.Свойство("ИдентификаторСтрокиВидаРасчета") Тогда
			ИдентификаторСтрокиВидаРасчета = 0;
			Для Каждого СтрокаНачислений Из Форма.Объект.Начисления Цикл
				Если ИдентификаторСтрокиВидаРасчета < СтрокаНачислений.ИдентификаторСтрокиВидаРасчета Тогда
					ИдентификаторСтрокиВидаРасчета = СтрокаНачислений.ИдентификаторСтрокиВидаРасчета;
				КонецЕсли;
			КонецЦикла;
			Форма.Элементы.Начисления.ТекущиеДанные.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		КонецЕсли;
		
		СтрокаНачислений = Форма.Элементы.Начисления.ТекущиеДанные;
		Если СтрокаНачислений <> Неопределено Тогда
			УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачислений, "ДействующийВидРасчета", Ложь);
			Если Копирование Тогда
				УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачислений, "РазмерДоРедактирования", 0);
				Если СтрокаНачислений.Свойство("ФОТНеРедактируется") И СтрокаНачислений.ФОТНеРедактируется Тогда
					УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачислений, "Размер", 0);
					УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачислений, "РазмерМин", 0);
					УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачислений, "РазмерМакс", 0);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриНачалеРедактирования(Форма, "Начисления", 0, , НоваяСтрока И ВнешниеДанные);
	
КонецПроцедуры

Процедура УстановитьЗначениеРеквизитвСтрокиНачисления(СтрокаНачисления, ИмяРеквизита, Значение)
	Если СтрокаНачисления.Свойство(ИмяРеквизита) Тогда
		СтрокаНачисления[ИмяРеквизита] = Значение;
	КонецЕсли;
КонецПроцедуры

Процедура НачисленияНачислениеПриИзменении(Форма, Знач ДатаСобытия, Знач РазрядКатегория, Знач ТарифнаяСетка, Знач РазрядКатегорияНадбавки, Знач ТарифнаяСеткаНадбавки, СчитатьПоказателиПоДолжности = Ложь ) Экспорт
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьТарифныеСеткиПриРасчетеЗарплаты") Тогда 
		
		ДатаСобытия = Неопределено;
		РазрядКатегория = Неопределено;
		ТарифнаяСетка = Неопределено;
				
	КонецЕсли;
	
	Если НЕ Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьКвалификационнуюНадбавку") Тогда 
		
		РазрядКатегорияНадбавки = Неопределено;
		ТарифнаяСеткаНадбавки = Неопределено;
				
	КонецЕсли;
	
	ОписаниеТаблицыВидовРасчета = Форма.ОписаниеТаблицыНачисленийНаКлиенте();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийНачислениеПриИзменении(
		Форма, ОписаниеТаблицыВидовРасчета, 0, , ТарифнаяСетка, РазрядКатегория, ДатаСобытия, ТарифнаяСеткаНадбавки,
		РазрядКатегорияНадбавки, СчитатьПоказателиПоДолжности);
	
КонецПроцедуры

Процедура НачисленияПередНачаломДобавления(Форма, Отказ) Экспорт
	
	Если Форма.Элементы.Позиции.ТекущиеДанные = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура НачисленияПослеУдаления(Форма) Экспорт
	
	РедактированиеСостоянияШРПриИзмененииНачислений(Форма, "Объект.Начисления", "Позиции", "Начисления", Истина);
	
КонецПроцедуры

Процедура НачисленияПередУдалением(Форма, Отказ, ОписаниеКоманднойПанелиНачислений, ИмяТаблицы = "Начисления") Экспорт
	
	Отказ = Истина;
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийОтменитьНачисление(Форма, ИмяТаблицы, 0, ОписаниеКоманднойПанелиНачислений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыПоказатели

Процедура ПоказателиПриНачалеРедактирования(Форма, НоваяСтрока, Копирование) Экспорт
	
	Если НоваяСтрока И Форма.Элементы.Показатели.ТекущиеДанные.Свойство("ИдентификаторСтрокиПозиции") Тогда
		Форма.Элементы.Показатели.ТекущиеДанные.ИдентификаторСтрокиПозиции = Форма.Элементы.Позиции.ТекущиеДанные.ИдентификаторСтрокиПозиции;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Отчеты

Функция ОткрытьОтчетШтатноеРасписаниеНачисления(ПараметрыПечати) Экспорт
	
	ОткрытьФорму("Отчет.ШтатноеРасписаниеНачисления.Форма", ПараметрыОткрытияОтчета(ПараметрыПечати));
	
КонецФункции

Функция ОткрытьОтчетШтатноеРасписание(ПараметрыПечати) Экспорт
	
	ОткрытьФорму("Отчет.ШтатноеРасписание.Форма", ПараметрыОткрытияОтчета(ПараметрыПечати));
	
КонецФункции

Функция ОткрытьОтчетСостояниеШтатногоРасписания(ПараметрыПечати) Экспорт
	
	ОткрытьФорму("Отчет.СостояниеШтатногоРасписания.Форма", ПараметрыОткрытияОтчета(ПараметрыПечати));
	
КонецФункции

Функция ПараметрыОткрытияОтчета(ПараметрыПечати)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("КлючВарианта", ПараметрыПечати.Идентификатор);
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ДатаАктуальности", ОбщегоНазначенияКлиент.ДатаСеанса());
	
	ОтборОрганизация = ПараметрыПечати.Форма.ОтборОрганизация;
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		СтруктураОтбора.Вставить("Организация", ОтборОрганизация);
	КонецЕсли; 
	ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#КонецОбласти

#КонецОбласти
