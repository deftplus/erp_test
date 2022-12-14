#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если НЕ Параметры.Отбор.Свойство("Ссылка") 
		ИЛИ ТипЗнч(Параметры.Отбор.Ссылка) = Тип("ФиксированныйМассив") Тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НеДоступныеЭлементы", Справочники.ВидыДоходовПоСтраховымВзносам.НеДоступныеЭлементыПоЗначениямФункциональныхОпций());
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	ВидыДоходовПоСтраховымВзносам.Ссылка
			|ИЗ
			|	Справочник.ВидыДоходовПоСтраховымВзносам КАК ВидыДоходовПоСтраховымВзносам
			|ГДЕ
			|	НЕ ВидыДоходовПоСтраховымВзносам.Ссылка В (&НеДоступныеЭлементы)
			|	И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)";
			
		Если Параметры.Отбор.Свойство("Ссылка") Тогда
			Запрос.УстановитьПараметр("СсылкиОтбора", Параметры.Отбор.Ссылка);
		Иначе
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ВидыДоходовПоСтраховымВзносам.Ссылка В(&СсылкиОтбора)", "");
		КонецЕсли;
		
		МассивДоступныхЭлементов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Параметры.Отбор.Вставить("Ссылка", Новый ФиксированныйМассив(МассивДоступныхЭлементов));
		
	КонецЕсли; 
	
	ДанныеВыбораБЗК.ЗаполнитьДляКлассификатораСПорядкомПоДопРеквизиту(
		Справочники.ВидыДоходовПоСтраховымВзносам,
		ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
	
#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьВидыДоходовПоСтраховымВзносам();
	
КонецПроцедуры


Процедура ЗаполнитьВидыДоходовПоСтраховымВзносам()

	ОписатьВидДоходаПоСтраховымВзносам("НеЯвляетсяОбъектом",												
		НСтр("ru = 'Доходы, не являющиеся объектом обложения страховыми взносами';
			|en = 'Income not subject to insurance contributions'"),																		Ложь, 	Ложь,	Ложь,	Ложь,	8); 
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликом",												
		НСтр("ru = 'Доходы, целиком не облагаемые страховыми взносами, кроме пособий за счет ФСС и денежного довольствия военнослужащих';
			|en = 'Income that is fully not subject to insurance contributions, except for benefits from the SSF and allowance for military personnel'"),				Ложь, 	Ложь, 	Ложь, 	Ложь,	2); 
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС",													
		НСтр("ru = 'Государственные пособия обязательного социального страхования, выплачиваемые за счет ФСС';
			|en = 'State benefits of mandatory social insurance, paid at the expense of the SSF'"),											Ложь, 	Ложь, 	Ложь, 	Ложь,	4);
	ОписатьВидДоходаПоСтраховымВзносам("ПособияЗаСчетФСС_НС",												
		НСтр("ru = 'Государственные пособия по обязательному страхованию от несчастных случаев и профзаболеваний';
			|en = 'State benefits for mandatory insurance against accidents and occupational diseases'"),										Ложь, 	Ложь, 	Ложь, 	Ложь,	5);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеДовольствиеВоеннослужащих",									
		НСтр("ru = 'Денежное довольствие военнослужащих и приравненных к ним лиц рядового и начальствующего состава МВД и других ведомств';
			|en = 'Allowance of military personnel and privates and senior officers of the Ministry of Internal Affairs and other departments equated to them'"),			Ложь, 	Ложь, 	Ложь, 	Ложь,	19);
	ОписатьВидДоходаПоСтраховымВзносам("НеОблагаетсяЦеликомПрокуроров",										
		НСтр("ru = 'Доходы прокуроров, следователей и судей, целиком не облагаемые страховыми взносами';
			|en = 'Income of prosecutors, investigators and judges that is fully not subject to insurance contributions'"),												Ложь,	Ложь, 	Ложь, 	Ложь,	21); 
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликом",													
		НСтр("ru = 'Доходы, целиком облагаемые страховыми взносами';
			|en = 'Income fully subject to insurance contributions'"),																					Истина, Истина, Истина, Истина,	1);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроров",										
		НСтр("ru = 'Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР';
			|en = 'Monetary pay to prosecutors, investigators and judges not subject to insurance contributions in PF'"),									Ложь, 	Истина, Истина, Истина,	20); 
	
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносами",										
		НСтр("ru = 'Возмещаемые ФСС компенсации, облагаемые страховыми взносами';
			|en = 'Compensations reimbursed by SSF and subject to insurance contributions'"),																		Истина, Истина, Истина, Истина,	9);
	ОписатьВидДоходаПоСтраховымВзносам("КомпенсацииОблагаемыеВзносамиПрокуроров",							
		НСтр("ru = 'Возмещаемые ФСС компенсации, облагаемые страховыми взносами, выплачиваемые прокурорам, следователям и судьям';
			|en = 'Compensations paid to prosecutors, investigators and judges, reimbursed by SSF, and subject to insurance contributions'"),						Ложь, 	Истина, Истина, Истина, 24); 
	ОписатьВидДоходаПоСтраховымВзносам("Матпомощь",															
		НСтр("ru = 'Материальная помощь, облагаемая страховыми взносами частично';
			|en = 'Support payments partially subject to insurance contributions'"),																		Истина, Истина, Истина, Истина,	6,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПрокуроров",												
		НСтр("ru = 'Материальная помощь прокуроров, следователей и судей, облагаемая страховыми взносами частично';
			|en = 'Support payments to prosecutors, investigators and judges partially subject to insurance contributions'"),									Ложь, 	Истина, Истина, Истина,	22,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенка",										
		НСтр("ru = 'Материальная помощь при рождении ребенка, облагаемая страховыми взносами частично';
			|en = 'Support payment on childbirth partially subject to insurance contributions'"),												Истина, Истина, Истина, Истина,	7,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("МатпомощьПриРожденииРебенкаПрокуроров",								
		НСтр("ru = 'Материальная помощь при рождении ребенка прокурорам, следователям и судьям, облагаемая страховыми взносами частично';
			|en = 'Support payments on childbirth to prosecutors, investigators and judges partially subject to insurance contributions'"),				Ложь, 	Истина, Истина, Истина,	23,	Истина); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору",				
		НСтр("ru = 'Доходы студентов за работу в студотряде по трудовому договору';
			|en = 'Income of students for work in a students'' team under an employment contract'"),																	Ложь,	Истина, Истина, Истина,	25); 

	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору",	
		НСтр("ru = 'Доходы студентов за работу в студотряде по гражданско-правовому договору';
			|en = 'Income of students for work in a students'' team under a civil law contract'"),															Ложь, 	Истина, Ложь, 	Ложь,	26);
	
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХ",														
		НСтр("ru = 'Договоры гражданско-правового характера';
			|en = 'Civil law contracts'"),																							Истина,	Истина, Ложь, 	Ложь,	3); 
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведения",								
		НСтр("ru = 'Создание аудиовизуальных произведений (видео-, теле- и кинофильмов)';
			|en = 'Creation of audiovisual works (video, television and films)'"),																Истина,	Истина, Ложь, 	Ложь,	12,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведения",									
		НСтр("ru = 'Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна';
			|en = 'Creation of artistic and graphic works, photographic works for printing, works of architecture and design'"),						Истина, Истина, Ложь, 	Ложь,	14,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведения",							
		НСтр("ru = 'Создание других музыкальных произведений, в том числе подготовленных к опубликованию';
			|en = 'Creation of other musical works, including those prepared for publication'"),												Истина, Истина, Ложь, 	Ложь,	13,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведений",									
		НСтр("ru = 'Исполнение произведений литературы и искусства';
			|en = 'Performing works of literature and art'"),																					Истина,	Истина, Ложь, 	Ложь,	10,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведения",									
		НСтр("ru = 'Создание литературных произведений, в том числе для театра, кино, эстрады и цирка';
			|en = 'Creation of literary works, including for theater, cinema, stage and circus'"),												Истина, Истина, Ложь, 	Ложь,	15,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведение",						
		НСтр("ru = 'Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых, камерных, оригинальной музыки для кино и др.';
			|en = 'Creation of musical and stage works (operas, ballets, etc.), symphonic, choral, chamber, original music for films, etc.'"),					Истина,	Истина, Ложь, 	Ложь,	16,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТруды",												
		НСтр("ru = 'Создание научных трудов и разработок';
			|en = 'Creation of scientific papers and developments'"),																								Истина,	Истина, Ложь, 	Ложь,	17,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытия",													
		НСтр("ru = 'Открытия, изобретения и создание промышленных образцов (процент суммы дохода, полученного за первые два года использования)';
			|en = 'Discoveries, inventions and creation of industrial designs (percentage of the income amount received in the first two years of use)'"),		Истина, Истина, Ложь,Ложь,	11,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптуры",												
		НСтр("ru = 'Создание произведений скульптуры, монументально- декоративной живописи, декоративно-прикладного и оформительского искусства, станковой живописи и др.';
			|en = 'Creation of works of sculpture, monumental and decorative painting, arts and crafts and decoration art, easel painting, etc.'"),	Истина,	Истина, Ложь, 	Ложь,	18,	Истина,	Истина);
	
	ОписатьВидДоходаПоСтраховымВзносам("ОблагаетсяЦеликомНеОблагаемыеФСС_НС",								
		НСтр("ru = 'Доходы, целиком облагаемые страховыми взносами на ОПС, ОМС и соц.страхование, не облагаемые взносами на страхование от несчастных случаев';
			|en = 'Income fully subject to insurance contributions for MPI, CMI and social insurance, not subject to contributions for accident insurance'"),				Истина, Истина, Истина, Ложь,	27);
	ОписатьВидДоходаПоСтраховымВзносам("ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС",					
		НСтр("ru = 'Денежное содержание прокуроров, следователей и судей, не облагаемое страховыми взносами в ПФР и взносами на страхование от несчастных случаев';
			|en = 'Monetary pay to prosecutors, investigators and judges not subject to PF insurance contributions and accident insurance contributions'"),			Ложь, 	Истина, Истина, Ложь,	28); 
	ОписатьВидДоходаПоСтраховымВзносам("ДоговорыГПХОблагаемыеФСС_НС",										
		НСтр("ru = 'Договоры гражданско-правового характера, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Civil contracts subject to accident insurance contributions'"),								Истина,	Истина, Ложь, 	Истина,	29); 
	
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеАудиовизуальныеПроизведенияОблагаемыеФСС_НС",				
		НСтр("ru = 'Создание аудиовизуальных произведений (видео-, теле- и кинофильмов), облагаемые взносами на страхование от несчастных случаев';
			|en = 'Creation of audiovisual works (video, television and films) subject to accident insurance contributions'"),	Истина,	Истина, Ложь, 	Истина,	32,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеГрафическиеПроизведенияОблагаемыеФСС_НС",					
		НСтр("ru = 'Создание художественно-графических произведений, фоторабот для печати, произведений архитектуры и дизайна, обл.взносами на страхование от несч.случаев';
			|en = 'Creation of artistic and graphic works, photographic works for printing, works of architecture and design subject to accident insurance contributions'"),	Истина, Истина, Ложь, 	Истина,	34,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеДругиеМузыкальныеПроизведенияОблагаемыеФСС_НС",			
		НСтр("ru = 'Создание других музыкальных произведений, в том числе подготовленных к опубликованию, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Creation of other musical works including those prepared for publishing subject to accident insurance contributions'"),			Истина, Истина, Ложь, 	Истина,	33,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеИсполнениеПроизведенийОблагаемыеФСС_НС",					
		НСтр("ru = 'Исполнение произведений литературы и искусства, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Performance of works of literature and art subject to accident insurance contributions'"),							Истина,	Истина, Ложь, 	Истина,	30,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеЛитературныеПроизведенияОблагаемыеФСС_НС",					
		НСтр("ru = 'Создание литературных произведений, в том числе для театра, кино, эстрады и цирка, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Creation of literary works, including for theater, cinema, stage and circus, subject to accident insurance contributions'"),				Истина, Истина, Ложь, 	Истина,	35,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеМузыкальноСценическиеПроизведениеОблагаемыеФСС_НС",		
		НСтр("ru = 'Создание музыкально-сценических произведений (опер, балетов и др.), симфонических, хоровых и др., обл.взносами на страхование от несч.случаев';
			|en = 'Creation of musical and stage works (operas, ballets, etc.), symphonic, choral, etc., subject to accident insurance contributions'"),			Истина,	Истина, Ложь, 	Истина,	36,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеНаучныеТрудыОблагаемыеФСС_НС",								
		НСтр("ru = 'Создание научных трудов и разработок, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Creation of scientific works and developments subject to accident insurance contributions'"),									Истина,	Истина, Ложь, 	Истина,	37,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеОткрытияОблагаемыеФСС_НС",									
		НСтр("ru = 'Открытия, изобретения и создание промышленных образцов, облагаемые взносами на страхование от несчастных случаев';
			|en = 'Discoveries, inventions and creation of industrial designs subject to accident insurance contributions'"),		 			Истина,	Истина, Ложь, 	Истина,	31,	Истина,	Истина);
	ОписатьВидДоходаПоСтраховымВзносам("АвторскиеСкульптурыОблагаемыеФСС_НС",								
		НСтр("ru = 'Создание произведений скульптуры, монументально-декоративной живописи и др., облагаемые взносами на страхование от несчастных случаев';
			|en = 'Creation of works of sculpture, monumental and decorative painting, etc., subject to accident insurance contributions'"),					Истина,	Истина, Ложь, 	Истина,	38,	Истина,	Истина);
	
	ДобавитьВыплатыПоДоговорамОпеки();
	ДобавитьВыплатыПоДоговорамСтудентам();
	ДобавитьКоронавирусныеСубсидии();
	
КонецПроцедуры

Процедура ДобавитьВыплатыПоДоговорамОпеки() Экспорт 
	
	ОписатьВидДоходаПоСтраховымВзносам("ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсии",                  
		НСтр("ru = 'Выплаты по договорам опеки и попечительства лицам, получающим страховые пенсии';
			|en = 'Payments under guardianship and trusteeship contracts to persons receiving insurance pensions'"), Ложь, Истина, Ложь, Ложь, 42); 
	
КонецПроцедуры

Процедура ДобавитьВыплатыПоДоговорамСтудентам() Экспорт

	ОписатьВидДоходаПоСтраховымВзносам("ДоходыСтудентовЗаРаботуВСтудотрядеПоДоговоруГПХОблагаемыеФСС_НС",	
		НСтр("ru = 'Доходы студентов за работу в студотряде по гражданско-правовому договору, облагаемые взносами в ФСС на НС и ПЗ';
			|en = 'Income of students for work in a students'' team under a civil law contract subject to contributions to the SSF for industrial accidents and occupational diseases'"), Ложь, Истина, Ложь, Истина, 43);
	
КонецПроцедуры

Процедура ДобавитьКоронавирусныеСубсидии() Экспорт

	ОписатьВидДоходаПоСтраховымВзносам("КоронавирусныеСубсидии",	
		НСтр("ru = 'Субсидии из федерального бюджета из-за эпидемии коронавирусной инфекции';
			|en = 'Subsidies from the federal budget due to the coronavirus pandemic'"), Ложь, Ложь, Ложь, Истина, 44);
	
КонецПроцедуры


Процедура ОписатьВидДоходаПоСтраховымВзносам(ИмяПредопределенныхДанных, Наименование, ВходитВБазуПФР, ВходитВБазуФОМС, ВходитВБазуФСС, ВходитВБазуФСС_НС, ДопУпорядочивание = 0, ОблагаетсяВзносамиЧастично = Ложь, АвторскиеВознаграждения = Ложь)

	СсылкаПредопределенного = ОбщегоНазначения.ПредопределенныйЭлемент("Справочник.ВидыДоходовПоСтраховымВзносам." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Объект = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Объект = Справочники.ВидыДоходовПоСтраховымВзносам.СоздатьЭлемент();
		Объект.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;

	Объект.Наименование = Наименование;
	
	Если Объект.ВходитВБазуПФР <> ВходитВБазуПФР Тогда
		Объект.ВходитВБазуПФР = ВходитВБазуПФР
	КонецЕсли;
	Если Объект.ВходитВБазуФОМС <> ВходитВБазуФОМС Тогда
		Объект.ВходитВБазуФОМС = ВходитВБазуФОМС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС <> ВходитВБазуФСС Тогда
		Объект.ВходитВБазуФСС = ВходитВБазуФСС
	КонецЕсли;
	Если Объект.ВходитВБазуФСС_НС <> ВходитВБазуФСС_НС Тогда
		Объект.ВходитВБазуФСС_НС = ВходитВБазуФСС_НС
	КонецЕсли;
	Если Объект.ОблагаетсяВзносамиЧастично <> ОблагаетсяВзносамиЧастично Тогда
		Объект.ОблагаетсяВзносамиЧастично = ОблагаетсяВзносамиЧастично
	КонецЕсли;
	Если Объект.АвторскиеВознаграждения <> АвторскиеВознаграждения Тогда
		Объект.АвторскиеВознаграждения = АвторскиеВознаграждения
	КонецЕсли;
	Если ЗначениеЗаполнено(ДопУпорядочивание) И Не ЗначениеЗаполнено(Объект.РеквизитДопУпорядочивания) Тогда
		Объект.РеквизитДопУпорядочивания = ДопУпорядочивание
	КонецЕсли;

	Если Объект.Модифицированность() Тогда
		
		Объект.ДополнительныеСвойства.Вставить("ЗаписьОбщихДанных");
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
	КонецЕсли;

КонецПроцедуры

Функция НеДоступныеЭлементыПоЗначениямФункциональныхОпций() Экспорт
	
	НеДоступныеЗначения = Новый Массив;
	
	ИмяОпции = "ИспользоватьРасчетДенежногоСодержанияПрокуроров";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.КомпенсацииОблагаемыеВзносамиПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеСодержаниеПрокуроровНеОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.НеОблагаетсяЦеликомПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПрокуроров);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.МатпомощьПриРожденииРебенкаПрокуроров);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользуетсяТрудСтудентов";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоГражданскоПравовомуДоговору);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоДоговоруГПХОблагаемыеФСС_НС);
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДоходыСтудентовЗаРаботуВСтудотрядеПоТрудовомуДоговору);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВоеннуюСлужбу";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ДенежноеДовольствиеВоеннослужащих);
		
	КонецЕсли; 
	
	ИмяОпции = "ИспользоватьВыплатыПоДоговорамОпеки";
	ФункциональнаяОпцияИспользуется =
		(Метаданные.ФункциональныеОпции.Найти(ИмяОпции) <> Неопределено);
		
	Если НЕ ФункциональнаяОпцияИспользуется
		ИЛИ НЕ ПолучитьФункциональнуюОпцию(ИмяОпции) Тогда
		
		НеДоступныеЗначения.Добавить(Справочники.ВидыДоходовПоСтраховымВзносам.ВыплатыПоДоговорамОпекиПолучающимСтраховыеПенсии);
		
	КонецЕсли; 
	
	Возврат НеДоступныеЗначения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
