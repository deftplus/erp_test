
#Область ПрограммныйИнтерфейс

Функция СформироватьСообщениеPain001(СсылкаНаДокумент, ИмяФайла) Экспорт
	
	Если СсылкаНаДокумент.ВалютаДокумента = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета() Тогда
		ТекстСообщения = НСтр("ru = 'По данным документа %1 невозможно создание сообшения Pain001. Поддерживается только создание сообщений для валютных операций.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ТекстСообщения, СсылкаНаДокумент));
		Возврат Ложь;
	КонецЕсли;
	ПространствоИмен = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
	
	ТекстОшибки = "";
	СекцияЗаголовокГруппы = СформироватьЗаголовокПлатежногоПоручения(СсылкаНаДокумент, ТекстОшибки);
	СообщениеЗаголовок = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "CustomerCreditTransferInitiationV03", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СообщениеЗаголовок, "GrpHdr", СекцияЗаголовокГруппы, Истина, ТекстОшибки);

	СекцияЗаголовокПлатежа = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PaymentInstructionInformation3", ПространствоИмен);
	ИдентификаторСообщения = СтрЗаменить(Строка(СсылкаНаДокумент.УникальныйИдентификатор()),"-","");
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "PmtInfId", ИдентификаторСообщения, Истина, ТекстОшибки);

	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "PmtMtd", "TRF", Истина, ТекстОшибки);

	БанкПлательщикИД = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "FinancialInstitutionIdentification7", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПлательщикИД, "BIC", СсылкаНаДокумент.СчетОрганизации.Банк.СВИФТБИК, Истина, ТекстОшибки);
	БанкПлательщик = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "BranchAndFinancialInstitutionIdentification4", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПлательщик, "FinInstnId", БанкПлательщикИД, Истина, ТекстОшибки);

	// Строки 2.6 - 2.13
	СекцияЗаголовокТипПлатежа = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PaymentTypeInformation19", ПространствоИмен);
	СекцияЗаголовокЛокальныйИнструмент = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "LocalInstrument2Choice", ПространствоИмен);
	Если СсылкаНаДокумент.ВидСообщенияISO20022 = Перечисления.ВидыСообщенийISO20022.ПокупкаПродажаВалюты Тогда
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокЛокальныйИнструмент, "Prtry", "RU-FX", Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокТипПлатежа, "LclInstrm", СекцияЗаголовокЛокальныйИнструмент, Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "PmtTpInf", СекцияЗаголовокТипПлатежа, Истина, ТекстОшибки);
	ИначеЕсли СсылкаНаДокумент.ВидСообщенияISO20022 = Перечисления.ВидыСообщенийISO20022.РаспоряжениеПоТранзитномуСчету Тогда
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокЛокальныйИнструмент, "Prtry", "RU-FCYRLS", Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокТипПлатежа, "LclInstrm", СекцияЗаголовокЛокальныйИнструмент, Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "PmtTpInf", СекцияЗаголовокТипПлатежа, Истина, ТекстОшибки);
	//Иначе
	//	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокЛокальныйИнструмент, "Prtry", "", Истина, ТекстОшибки);
	КонецЕсли;
	
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "ReqdExctnDt", СсылкаНаДокумент.Дата, Истина, ТекстОшибки);// Заменить на дату исполнения

	// Строки 2.19 - 9.1.18
	СекцияЗаголовокДебитор = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PartyIdentification32", ПространствоИмен);
	СекцияЗаголовокИд = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "Party6Choice", ПространствоИмен);
	СекцияЗаголовокОрг = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "OrganisationIdentification4", ПространствоИмен);
	СекцияЗаголовокОргИд = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "GenericOrganisationIdentification1", ПространствоИмен);
	СекцияЗаголовокИмяКода = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "OrganisationIdentificationSchemeName1Choice", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокИмяКода, "Cd", "TXID", Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокОргИд, "SchmeNm", СекцияЗаголовокИмяКода, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокОргИд, "Id", СсылкаНаДокумент.ИННПлательщика, Истина, ТекстОшибки); // точно 2 раза?
	СекцияЗаголовокОрг.Othr.Добавить(СекцияЗаголовокОргИд);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокИд, "OrgId", СекцияЗаголовокОрг, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокДебитор, "Id", СекцияЗаголовокИд, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "Dbtr", СекцияЗаголовокДебитор, Истина, ТекстОшибки);

	// DbtrAcct
	СекцияЗаголовокСчет = СформироватьСтруктуруСчета(СсылкаНаДокумент.СчетОрганизации.НомерСчета, СсылкаНаДокумент.ВалютаДокумента.Наименование, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "DbtrAcct", СекцияЗаголовокСчет, Истина, ТекстОшибки);


	// 2.25 - 1.1.3           
	СекцияЗаголовокСчет = СформироватьСтруктуруСчета("00000000000000000000000000", , ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "ChrgsAcct", СекцияЗаголовокСчет, Истина, ТекстОшибки);

	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокПлатежа, "DbtrAgt", БанкПлательщик, Истина, ТекстОшибки);

	// Тело

	
	Если СсылкаНаДокумент.ВидСообщенияISO20022 = Перечисления.ВидыСообщенийISO20022.ВалютныйПлатеж Тогда
		СекцияТранзакция = ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СсылкаНаДокумент.СуммаДокумента, "", ИдентификаторСообщения, ПространствоИмен, ТекстОшибки);
		СекцияЗаголовокПлатежа.CdtTrfTxInf.Добавить(СекцияТранзакция);
	ИначеЕсли СсылкаНаДокумент.ВидСообщенияISO20022 = Перечисления.ВидыСообщенийISO20022.ПокупкаПродажаВалюты Тогда
		СекцияТранзакция = ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СсылкаНаДокумент.СуммаДокумента, "FX", ИдентификаторСообщения, ПространствоИмен, ТекстОшибки);
		СекцияЗаголовокПлатежа.CdtTrfTxInf.Добавить(СекцияТранзакция);
	ИначеЕсли СсылкаНаДокумент.ВидСообщенияISO20022 = Перечисления.ВидыСообщенийISO20022.РаспоряжениеПоТранзитномуСчету Тогда
		СекцияТранзакция = ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СсылкаНаДокумент.СуммаДокумента, "NTF", ИдентификаторСообщения, ПространствоИмен, ТекстОшибки);
		СекцияЗаголовокПлатежа.CdtTrfTxInf.Добавить(СекцияТранзакция);
		Если СсылкаНаДокумент.СуммаОбязательнойПродажи <> 0 Тогда 
			СекцияТранзакция = ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СсылкаНаДокумент.СуммаДокумента - СсылкаНаДокумент.СуммаОбязательнойПродажи, "TRF", ИдентификаторСообщения, ПространствоИмен, ТекстОшибки);
			СекцияЗаголовокПлатежа.CdtTrfTxInf.Добавить(СекцияТранзакция);
			СекцияТранзакция = ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СсылкаНаДокумент.СуммаОбязательнойПродажи, "FX", ИдентификаторСообщения, ПространствоИмен, ТекстОшибки);
			СекцияЗаголовокПлатежа.CdtTrfTxInf.Добавить(СекцияТранзакция);
		КонецЕсли;
	КонецЕсли;

	СообщениеЗаголовок.PmtInf.Добавить(СекцияЗаголовокПлатежа);

	СообщениеPain001 = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "Document", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СообщениеPain001, "CstmrCdtTrfInitn", СообщениеЗаголовок, Истина, ТекстОшибки);

	СообщениеPain001.Проверить();
	
	ДвоичныеДанныеФайла = ОбменСБанкамиСлужебный.ДвоичныеДанныеИзXDTO(ФабрикаXDTO, СообщениеPain001);
	ДвоичныеДанныеФайла.Записать(ИмяФайла);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьЗаголовокПлатежногоПоручения(СсылкаНаДокумент, ТекстОшибки = "")
	// сформируем заголовок группы
	ПространствоИмен = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
	СекцияЗаголовокГруппы = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "GroupHeader32", ПространствоИмен);
	ИдентификаторСообщения = СтрЗаменить(Строка(СсылкаНаДокумент.УникальныйИдентификатор()),"-","");
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокГруппы, "MsgId", ИдентификаторСообщения, Истина, ТекстОшибки);
	ДатаВремяСоздания = СсылкаНаДокумент.Дата;
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокГруппы, "CreDtTm", ДатаВремяСоздания, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокГруппы, "NbOfTxs", "1", Истина, ТекстОшибки); // фиксированное
	ИдентификацияИнициатора = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PartyIdentification32", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокГруппы, "InitgPty", ИдентификацияИнициатора, Истина, ТекстОшибки); // фиксированное

	//СообщениеЗаголовок = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "CustomerCreditTransferInitiationV03", ПространствоИмен);
	//ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СообщениеЗаголовок, "GrpHdr", СекцияЗаголовокГруппы, Истина, ТекстОшибки);

	Возврат СекцияЗаголовокГруппы;

КонецФункции

Функция СпособОплатыКомиссииЗаПлатеж(СсылкаНаДокумент)
	КодПлательщикаБанковскойКомиссии = СсылкаНаДокумент.КодПлательщикаБанковскойКомиссии;
	Если КодПлательщикаБанковскойКомиссии = Перечисления.КодыПлательщикаБанковскойКомиссии.BEN Тогда
		Возврат "CRED";
	ИначеЕсли КодПлательщикаБанковскойКомиссии = Перечисления.КодыПлательщикаБанковскойКомиссии.OUR Тогда
		Возврат "DEBT";
	ИначеЕсли КодПлательщикаБанковскойКомиссии = Перечисления.КодыПлательщикаБанковскойКомиссии.SHA Тогда
		Возврат "SHAR";
	Иначе
		
	КонецЕсли;
КонецФункции

Функция СформироватьСтруктуруСчета(НомерСчета, Валюта, ТекстОшибки)
	ПространствоИмен = "urn:iso:std:iso:20022:tech:xsd:pain.001.001.03";
	СекцияЗаголовокСчет = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "CashAccount16", ПространствоИмен);
	СекцияЗаголовокСчетИд = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "AccountIdentification4Choice", ПространствоИмен);
	СекцияЗаголовокСчетТип = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "GenericAccountIdentification1", ПространствоИмен);
	СекцияЗаголовокСчетТипИмя = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "AccountSchemeName1Choice", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчетТипИмя, "Cd", "BBAN", Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчетТип, "SchmeNm", СекцияЗаголовокСчетТипИмя, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчетТип, "Id", НомерСчета, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчетИд, "Othr", СекцияЗаголовокСчетТип, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчет, "Id", СекцияЗаголовокСчетИд, Истина, ТекстОшибки);
	Если Не ПустаяСтрока(Валюта) Тогда
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокСчет, "Ccy", Валюта, Истина, ТекстОшибки);
	КонецЕсли;
	Возврат СекцияЗаголовокСчет;
КонецФункции

Функция ЗаполнитьСекциюТранзакции(СсылкаНаДокумент, СуммаДокумента, ЛокальныйИнструмент, ИдентификаторСообщения, ПространствоИмен, ТекстОшибки)
	СекцияТранзакция = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "CreditTransferTransactionInformation10", ПространствоИмен); 
	
	СекцияИДПлатежа = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PaymentIdentification1", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияИДПлатежа, "InstrId", ИдентификаторСообщения, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияИДПлатежа, "EndToEndId", СсылкаНаДокумент.Номер, Истина, ТекстОшибки);

	СекцияЗаголовокТипПлатежа = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PaymentTypeInformation19", ПространствоИмен);
	СекцияЗаголовокЛокальныйИнструмент = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "LocalInstrument2Choice", ПространствоИмен);
	Если Не ПустаяСтрока(ЛокальныйИнструмент) Тогда
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокЛокальныйИнструмент, "Prtry", ЛокальныйИнструмент, Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияЗаголовокТипПлатежа, "LclInstrm", СекцияЗаголовокЛокальныйИнструмент, Истина, ТекстОшибки);
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "PmtTpInf", СекцияЗаголовокТипПлатежа, Истина, ТекстОшибки);
	КонецЕсли;
	
	СекцияСумма = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "AmountType3Choice", ПространствоИмен); 
	СекцияСуммаЗначение = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "ActiveOrHistoricCurrencyAndAmount", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияСуммаЗначение, "__content", СуммаДокумента, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияСуммаЗначение, "Ccy", СсылкаНаДокумент.ВалютаДокумента.Наименование, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияСумма, "InstdAmt", СекцияСуммаЗначение, Истина, ТекстОшибки);

	// КУРС
	СекцияКурс = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "ExchangeRateInformation1", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияКурс, "XchgRate", СсылкаНаДокумент.КурсКонвертации, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияКурс, "RateTp", "SPOT", Истина, ТекстОшибки);

	БанкПосредникИД = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "FinancialInstitutionIdentification7", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПосредникИД, "BIC", "ABCDRUMMXXX", Истина, ТекстОшибки);
	БанкПосредник = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "BranchAndFinancialInstitutionIdentification4", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПосредник, "FinInstnId", БанкПосредникИД, Истина, ТекстОшибки);

	БанкПолучательИД = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "FinancialInstitutionIdentification7", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПолучательИД, "BIC", СсылкаНаДокумент.СчетКонтрагента.Банк.СВИФТБИК, Истина, ТекстОшибки);
	БанкПолучатель = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "BranchAndFinancialInstitutionIdentification4", ПространствоИмен); 
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(БанкПолучатель, "FinInstnId", БанкПолучательИД, Истина, ТекстОшибки);

	Получатель = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "PartyIdentification32", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(Получатель, "Nm", ?(ПустаяСтрока(СсылкаНаДокумент.Контрагент.Наименование1), СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(СсылкаНаДокумент.Контрагент.НаименованиеПолное), СсылкаНаДокумент.Контрагент.Наименование1), Истина, ТекстОшибки);

	// 2.80
	СчетПолучатель = СформироватьСтруктуруСчета(СсылкаНаДокумент.СчетКонтрагента.НомерСчета,, ТекстОшибки);

	ИнформацияОПлатеже = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "RemittanceInformation5", ПространствоИмен);
	ИнформацияОПлатеже.Ustrd.Добавить(СтроковыеФункцииКлиентСервер.СтрокаЛатиницей(СсылкаНаДокумент.НазначениеПлатежа));
	ИнформацияОПлатежеСтруктурная = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "StructuredRemittanceInformation7", ПространствоИмен);
	СвязныеДокументы = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "ReferredDocumentInformation3", ПространствоИмен);
	ТипДокумента = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "ReferredDocumentType2", ПространствоИмен);
	ТипДокументаВыбор = ОбменСБанкамиСлужебный.ОбъектТипаCML(ФабрикаXDTO, "ReferredDocumentType1Choice", ПространствоИмен);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(ТипДокументаВыбор, "Prtry", "POD", Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(ТипДокумента, "CdOrPrtry", ТипДокументаВыбор, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СвязныеДокументы, "Tp", ТипДокумента, Истина, ТекстОшибки);
	ИнформацияОПлатежеСтруктурная.RfrdDocInf.Добавить(СвязныеДокументы);
	ИнформацияОПлатеже.Strd.Добавить(ИнформацияОПлатежеСтруктурная);
	
	
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "PmtId", СекцияИДПлатежа, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "Amt", СекцияСумма, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "XchgRateInf", СекцияКурс, Истина, ТекстОшибки);
	СпособОплатыКомиссии = СпособОплатыКомиссииЗаПлатеж(СсылкаНаДокумент);
	Если ЗначениеЗаполнено(СпособОплатыКомиссии) Тогда
		ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "ChrgBr", СпособОплатыКомиссии, Истина, ТекстОшибки);
	КонецЕсли;
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "IntrmyAgt1", БанкПосредник, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "CdtrAgt", БанкПолучатель, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "Cdtr", Получатель, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "CdtrAcct", СчетПолучатель, Истина, ТекстОшибки);
	ОбменСБанкамиСлужебный.ЗаполнитьСвойствоXDTO(СекцияТранзакция, "RmtInf", ИнформацияОПлатеже, Истина, ТекстОшибки);
	Возврат СекцияТранзакция;
КонецФункции

#КонецОбласти
