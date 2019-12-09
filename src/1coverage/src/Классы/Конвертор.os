Перем ДанныеПокрытия;
Перем ТекКаталогИсходников;
Перем ИсходникиВФорматеXML;
Перем ТипыМодулей;
Перем ПутьКФайлуКонфигурации;

Перем Лог;

Процедура ПриСозданииОбъекта(КаталогИсходников)

	Лог = ПараметрыПриложения.Лог();
	
	ТекКаталогИсходников = КаталогИсходников;
	
	ДанныеПокрытия = Новый ТаблицаЗначений();
	ДанныеПокрытия.Колонки.Добавить("ИдМодуля");
	ДанныеПокрытия.Колонки.Добавить("ИдТипаМодуля");
	ДанныеПокрытия.Колонки.Добавить("ИмяФайла");
	ДанныеПокрытия.Колонки.Добавить("ПутьКОбъекту");
	ДанныеПокрытия.Колонки.Добавить("ИмяКоманды");
	ДанныеПокрытия.Колонки.Добавить("ПутьКМодулю");
	ДанныеПокрытия.Колонки.Добавить("НомераСтрок");
	
	ТипыМодулей = Новый Соответствие();
	ТипыМодулей.Вставить("МодульОбъекта", "a637f77f-3840-441d-a1c3-699c8c5cb7e0");
	ТипыМодулей.Вставить("МодульМенеджера", "d1b64a2c-8078-4982-8190-8f81aefda192");
	ТипыМодулей.Вставить("ОбщийМодуль", "d5963243-262e-4398-b4d7-fb16d06484f6");
	ТипыМодулей.Вставить("МодульФормы", "32e087ab-1491-49b6-aba7-43571b41ac2b");
	ТипыМодулей.Вставить("МодульСеанса", "9b7bbbae-9771-46f2-9e4d-2489e0ffc702");
	ТипыМодулей.Вставить("МодульУправляемогоПриложения", "d22e852a-cf8a-4f77-8ccb-3548e7792bea");
	ТипыМодулей.Вставить("МодульКоманды", "078a6af8-d22c-4248-9c33-7e90075a3d2c");
	ТипыМодулей.Вставить("МодульНабораЗаписей", "9f36fd70-4bf4-47f6-b235-935f73aab43f");
	ТипыМодулей.Вставить("Неизвестно", "0c8cad23-bf8c-468e-b49e-12f1927c048b");
	
КонецПроцедуры

Процедура ОбработатьЛог(КопияЛога) Экспорт
	
	ЗаписиЛогаJSON = ПреобразоватьЗаписиЛогаВJSON(КопияЛога);
	ЗаполнитьДанныеПокрытия(ЗаписиЛогаJSON);
	ОпределитьОбъектыКонфигурации();
	ПостроитьПутиКМодулямКонфигурации();
	
КонецПроцедуры

Процедура СохранитьРезультат(КаталогРезультата, ФорматФайлаРезультата) Экспорт
	
	Если ФорматФайлаРезультата = "GenericCoverage" Тогда
		
		СохранитьВGenericCoverage(КаталогРезультата);
		
		
		
	ИначеЕсли ФорматФайлаРезультата = "lcov" Тогда
		
		СохранитьВlcov(КаталогРезультата);
		
	Иначе
		
		ВызватьИсключение("Некорректный формат результирующего файла");
		
	КонецЕсли;
	
	Лог.Отладка("Файл успешно сохранен в каталог " + КаталогРезультата);
	
КонецПроцедуры

Функция ПреобразоватьЗаписиЛогаВJSON(КопияЛога)
	
	ЧтениеТекста = Новый ЧтениеТекста(КопияЛога);
	ЗаписиЛогаJSON = Новый Массив();
	
	ТекущаяЗаписьЛога = "";
	
	Пока ТекущаяЗаписьЛога <> Неопределено Цикл
		
		ТекущаяЗаписьЛога = ЧтениеТекста.ПрочитатьСтроку();
		
		Если Не ЗначениеЗаполнено(ТекущаяЗаписьЛога) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекЗаписьЛогаJSON = ПреобразоватьЗаписьЛогаВJSON(ТекущаяЗаписьЛога);
		ЗаписиЛогаJSON.Добавить(ТекЗаписьЛогаJSON);
		
	КонецЦикла;

	ЧтениеТекста.Закрыть();
	
	Возврат ЗаписиЛогаJSON;
	
КонецФункции

Функция ПреобразоватьЗаписьЛогаВJSON(Знач ЗаписьЛога)
	
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "xmlns:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "debugMeasure:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "dbgtgtRemoteRequestResponse:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "xsi:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "debugRDBGRequestResponse:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "debugRTEFilter:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "debugAutoAttach:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "dbgtgtData:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "d2p1:", "");
	ЗаписьЛога = СтрЗаменить(ЗаписьЛога, "$", "Start");
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ЗаписьЛога);
	ТекЗаписьЛогаJSON = ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	
	Возврат ТекЗаписьЛогаJSON;
	
КонецФункции

Процедура ЗаполнитьДанныеПокрытия(ЗаписиЛогаJSON)
	
	Для Каждого ТекЗаписьЛогаJSON Из ЗаписиЛогаJSON Цикл
		
		Если Не ЭтоВалиднаяЗапись(ТекЗаписьЛогаJSON) Тогда
			Лог.Отладка("Запись лога не валидна, отсутствуют необходимые поля");
			Продолжить;
		КонецЕсли;
		
		ДанныеМодуля = ТекЗаписьЛогаJSON.request.commandToDbgServer.measure.moduleData;
		
		Для Каждого Запись Из ДанныеМодуля Цикл
			
			ИдМодуля = Запись.moduleId.objectId;
			ИдТипаМодуля = Запись.moduleId.propertyId;
			
			НайденнаяСтрокаМодуль = ДанныеПокрытия.Найти(ИдМодуля, "ИдМодуля");
			Если НайденнаяСтрокаМодуль <> Неопределено Тогда
				ТекСтрокаМодуль = НайденнаяСтрокаМодуль;
			Иначе
				ТекСтрокаМодуль = ДанныеПокрытия.Добавить();
				ТекСтрокаМодуль.НомераСтрок = Новый Соответствие();
			КонецЕсли;
			ТекСтрокаМодуль.ИдМодуля = ИдМодуля;
			ТекСтрокаМодуль.ИдТипаМодуля = ИдТипаМодуля;
			
			Для Каждого СтрокаПокрытия Из Запись.lineInfo Цикл
				
				Если ТекСтрокаМодуль.НомераСтрок[СтрокаПокрытия.lineNo] <> Неопределено Тогда
					ТекущееКоличествоХитов = ТекСтрокаМодуль.НомераСтрок[СтрокаПокрытия.lineNo] + 1;
				Иначе
					ТекущееКоличествоХитов = 1;
				КонецЕсли;
				
				ТекСтрокаМодуль.НомераСтрок.Вставить(СтрокаПокрытия.lineNo, ТекущееКоличествоХитов);
				
			КонецЦикла;
			
			Лог.Отладка("В замерах обнаружен модуль с id " + ИдМодуля);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОпределитьОбъектыКонфигурации()
	
	ПутьКФайлуКонфигурации = ОбъединитьПути(ТекКаталогИсходников, "ConfigDumpInfo.xml");
	ПутьКФайлуКонфигурацииEDT = ОбъединитьПути(ТекКаталогИсходников, "src", "Configuration", "Configuration.mdo");
	
	Если ФС.ФайлСуществует(ПутьКФайлуКонфигурации) Тогда
		
		Лог.Отладка("Конфигурация в формате XML");
		ИсходникиВФорматеXML = Истина;
		ОпределитьОбъектыКонфигурацииXML();
		
	ИначеЕсли ФС.ФайлСуществует(ПутьКФайлуКонфигурацииEDT) Тогда
		
		Лог.Отладка("Конфигурация в формате EDT");
		ИсходникиВФорматеXML = Ложь;
		ОпределитьОбъектыКонфигурацииEDT();
		
	Иначе
		
		ВызватьИсключение("Не найден исходный код конфигурации или он выгружен в неизвестном формате");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьОбъектыКонфигурацииXML()
	
	МассивФайлов = НайтиФайлы(ТекКаталогИсходников, "*.xml", Истина);
	ПроцессорXML = Новый СериализацияДанныхXML;
	Для Каждого ТекФайл Из МассивФайлов Цикл
		
		ТекПолныйПуть = СтрЗаменить(ТекФайл.ПолноеИмя, "\", "/");
		
		КаталогИсходниковДляПоиска = ТекКаталогИсходников;
		Если СтрНачинаетсяС(КаталогИсходниковДляПоиска, "./") Тогда
			КаталогИсходниковДляПоиска = Сред(ТекКаталогИсходников, 3);
		КонецЕсли;
		
		ПозицияНачало = СтрНайти(ТекПолныйПуть, КаталогИсходниковДляПоиска);
		ОтносительныйПуть = Сред(ТекПолныйПуть, ПозицияНачало);
		
		РезультатЧтенияXML = ПроцессорXML.ПрочитатьИзФайла(ТекПолныйПуть);
		УзелОбъявлениеОбъектаМетаданных = РезультатЧтенияXML["MetaDataObject"];
		Если УзелОбъявлениеОбъектаМетаданных = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого Элемент Из УзелОбъявлениеОбъектаМетаданных._Элементы Цикл
			УзелТипОбъекта = Элемент;
		КонецЦикла;
		
		Если УзелТипОбъекта.Ключ = "Language"
			Или УзелТипОбъекта.Ключ = "Template" Тогда
			Продолжить;
		КонецЕсли;
		
		УзелОбъектМетаданных = УзелТипОбъекта.Значение;
		
		ТекUUID = УзелОбъектМетаданных._Атрибуты["uuid"];
		
		Если ТекUUID = Неопределено Тогда
			Лог.Отладка("ОТЛАДКА: возможно, ошибка");
			Продолжить;
		КонецЕсли;
		
		ЗаписатьМодульВДанныеПокрытия(ТекUUID, ОтносительныйПуть, ТекФайл.Имя);
		ОбработатьДочерниеОбъектыXML(УзелОбъектМетаданных, ОтносительныйПуть, ТекФайл);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДочерниеОбъектыXML(УзелОбъектМетаданных, ОтносительныйПуть, ТекФайл)
	
	ЭлементыУзлаОбъектМетаданных = УзелОбъектМетаданных._Элементы;
	ТипЗнчЭлементыУзла = ТипЗнч(ЭлементыУзлаОбъектМетаданных);
	
	ДочерниеОбъекты = Неопределено;
	Если ТипЗнчЭлементыУзла = Тип("Соответствие") Тогда
		
		ДочерниеОбъекты = ЭлементыУзлаОбъектМетаданных["ChildObjects"];
		
	ИначеЕсли ТипЗнчЭлементыУзла = Тип("Массив") Тогда
		
		Для Каждого Элемент ИЗ ЭлементыУзлаОбъектМетаданных Цикл
			ДочерниеОбъекты = Элемент["ChildObjects"];
			
			Если ДочерниеОбъекты <> Неопределено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Лог.Отладка("Поведение не опредлено");
	КонецЕсли;
	
	Если ДочерниеОбъекты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДочернийОбъект Из ДочерниеОбъекты Цикл
		
		Если ТипЗнч(ДочернийОбъект) <> Тип("Соответствие") Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ЭлементСоответствия Из ДочернийОбъект Цикл
			
			Если ЭлементСоответствия.Ключ = "Command" Тогда
				ТекUUIDКоманды = ЭлементСоответствия.Значение._Атрибуты["uuid"];
				ИмяКоманды = ЭлементСоответствия.Значение._Элементы["Properties"]["Name"];
				ЗаписатьМодульВДанныеПокрытия(ТекUUIDКоманды, ОтносительныйПуть, ТекФайл.Имя, ИмяКоманды);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДочерниеОбъектыEDT(УзелОбъектМетаданных, ОтносительныйПуть, ТекФайл)
	
	ЭлементыУзлаОбъектМетаданных = УзелОбъектМетаданных._Элементы;
	ТипЗнчЭлементыУзла = ТипЗнч(ЭлементыУзлаОбъектМетаданных);
	
	ДочерниеОбъекты = Неопределено;
	Если ТипЗнчЭлементыУзла = Тип("Соответствие") Тогда
		
		Формы = ЭлементыУзлаОбъектМетаданных["forms"];
		Если Формы <> Неопределено Тогда
			
			ТекUUIDФормы = Формы._Атрибуты["uuid"];
			ЭлементыФормы = Формы._Элементы;
			
			Если ТипЗнч(ЭлементыФормы) = Тип("Массив") Тогда
				
				Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
					
					ИмяФормы = ЭлементФормы["name"];
					
					Если ИмяФормы <> Неопределено Тогда
						ЗаписатьМодульВДанныеПокрытия(ТекUUIDФормы, ОтносительныйПуть, ТекФайл.Имя, ИмяФормы);
					КонецЕсли;
					
				КонецЦикла;
				
			Иначе
				Лог.Отладка("TODO");
			КонецЕсли;
			
		КонецЕсли;
		
		Команда = ЭлементыУзлаОбъектМетаданных["commands"];
		Если Команда <> Неопределено Тогда
			ТекUUIDКоманды = Команда._Атрибуты["uuid"];
			ИмяКоманды = Команда._Элементы["name"];
			
			ЗаписатьМодульВДанныеПокрытия(ТекUUIDКоманды, ОтносительныйПуть, ТекФайл.Имя, ИмяКоманды);
		КонецЕсли;
		
	ИначеЕсли ТипЗнчЭлементыУзла = Тип("Массив") Тогда
		
		Для Каждого Элемент Из ЭлементыУзлаОбъектМетаданных Цикл
			Формы = Элемент["forms"];
			Если Формы <> Неопределено Тогда
				
				ТекUUIDФормы = Формы._Атрибуты["uuid"];
				ЭлементыФормы = Формы._Элементы;
				
				Если ТипЗнч(ЭлементыФормы) = Тип("Массив") Тогда
					
					Для Каждого ЭлементФормы Из ЭлементыФормы Цикл
						ИмяФормы = ЭлементФормы["name"];
						
						Если ИмяФормы <> Неопределено Тогда
							ЗаписатьМодульВДанныеПокрытия(ТекUUIDФормы, ОтносительныйПуть, ТекФайл.Имя, ИмяФормы);
						КонецЕсли;
					КонецЦикла;
					
				Иначе
					Лог.Отладка("TODO");
				КонецЕсли;
				
			КонецЕсли;
			
			Команда = Элемент["commands"];
			Если Команда <> Неопределено Тогда
				ТекUUIDКоманды = Команда._Атрибуты["uuid"];
				ИмяКоманды = Команда._Элементы["name"];
				
				ЗаписатьМодульВДанныеПокрытия(ТекUUIDКоманды, ОтносительныйПуть, ТекФайл.Имя, ИмяКоманды);
			КонецЕсли;
		КонецЦикла;
		
	Иначе
		Лог.Отладка("Поведение не опредлено");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаписатьМодульВДанныеПокрытия(UUID, ОтносительныйПуть, ТекИмяФайла, ИмяКоманды = Неопределено)
	
	ДанныеПокрытияМодуляКонфигурации = ДанныеПокрытия.Найти(UUID, "ИдМодуля");
	
	Если ДанныеПокрытияМодуляКонфигурации = Неопределено Тогда
		Лог.Отладка("В объекте " + UUID + " замеров не обнаружено");
	Иначе
		
		Лог.Отладка("Обнаружен замер в объекте " + UUID + " (" + ОтносительныйПуть + ")");
		
		ДанныеПокрытияМодуляКонфигурации.ПутьКОбъекту = ОтносительныйПуть;
		ДанныеПокрытияМодуляКонфигурации.ИмяФайла = ТекИмяФайла;
		ДанныеПокрытияМодуляКонфигурации.ИмяКоманды = ИмяКоманды;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОпределитьОбъектыКонфигурацииEDT()
	
	МассивФайлов = НайтиФайлы(ТекКаталогИсходников, "*.mdo", Истина);
	ПроцессорXML = Новый СериализацияДанныхXML;
	
	Для Каждого ТекФайл Из МассивФайлов Цикл
		
		ТекПолныйПуть = СтрЗаменить(ТекФайл.ПолноеИмя, "\", "/");
		
		КаталогИсходниковДляПоиска = ТекКаталогИсходников;
		Если СтрНачинаетсяС(КаталогИсходниковДляПоиска, "./") Тогда
			КаталогИсходниковДляПоиска = Сред(ТекКаталогИсходников, 3);
		КонецЕсли;
		
		ПозицияНачало = СтрНайти(ТекПолныйПуть, КаталогИсходниковДляПоиска);
		ОтносительныйПуть = Сред(ТекПолныйПуть, ПозицияНачало);
		
		РезультатЧтенияXML = ПроцессорXML.ПрочитатьИзФайла(ТекПолныйПуть);
		Для Каждого Элемент Из РезультатЧтенияXML Цикл
			УзелОбъявлениеОбъектаМетаданных = Элемент;
		КонецЦикла;
		
		ТекUUID = УзелОбъявлениеОбъектаМетаданных.Значение._Атрибуты["uuid"];
		
		Если ТекUUID = Неопределено Тогда
			Лог.Отладка("Возможно, ошибка");
			Продолжить;
		КонецЕсли;
		
		ЗаписатьМодульВДанныеПокрытия(ТекUUID, ОтносительныйПуть, ТекФайл.Имя);
		ОбработатьДочерниеОбъектыEDT(УзелОбъявлениеОбъектаМетаданных.Значение, ОтносительныйПуть, ТекФайл);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПостроитьПутиКМодулямКонфигурации()
	
	Если ИсходникиВФорматеXML Тогда
		ПостроитьПутиКМодулямКонфигурацииXML();
	Иначе
		ПостроитьПутиКМодулямКонфигурацииEDT();
	КонецЕсли;
	
	// ВывестиРезультат();
	
	ПроверитьСуществованиеФайлов();
	
КонецПроцедуры

Процедура ПостроитьПутиКМодулямКонфигурацииXML()
	
	Для Каждого Стр Из ДанныеПокрытия Цикл
		
		Если Не ЗначениеЗаполнено(Стр.ПутьКОбъекту) Тогда
			Лог.Отладка("Не удалось определить объект с Id модуля " + Стр.ИдМодуля);
			Продолжить;
		КонецЕсли;
		
		Если Стр.ИдТипаМодуля = ТипыМодулей["МодульОбъекта"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/ObjectModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульМенеджера"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/ManagerModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["ОбщийМодуль"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/Module.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульФормы"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/Form/Module.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульСеанса"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Ext/SessionModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульУправляемогоПриложения"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Ext/ManagedApplicationModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульКоманды"] Тогда
			ЭтоОбщаяКоманда = СтрНайти(Стр.ПутьКОбъекту, "/CommonCommands/");
			Если ЭтоОбщаяКоманда Тогда
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/CommandModule.bsl");
			Иначе
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Commands/" + Стр.ИмяКоманды + "/Ext/CommandModule.bsl");
			КонецЕсли;
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульНабораЗаписей"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, ".xml", "/Ext/RecordSetModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["Неизвестно"] Тогда
			Лог.Отладка("TODO");
		Иначе
			Лог.Отладка("Неизвестный идентификатор типа модуля");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПостроитьПутиКМодулямКонфигурацииEDT()
	
	Для Каждого Стр Из ДанныеПокрытия Цикл
		
		Если Не ЗначениеЗаполнено(Стр.ПутьКОбъекту) Тогда
			Лог.Отладка("Не удалось определить путь к объекту с Id " + Стр.ИдМодуля);
			Продолжить;
		КонецЕсли;
		
		Если Стр.ИдТипаМодуля = ТипыМодулей["МодульОбъекта"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "ObjectModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульМенеджера"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "ManagerModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["ОбщийМодуль"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Module.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульФормы"] Тогда
			ЭтоОбщаяФорма = СтрНайти(Стр.ПутьКОбъекту, "/CommonForms/");
			Если ЭтоОбщаяФорма Тогда
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Module.bsl");
			Иначе
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Forms/" + Стр.ИмяКоманды + "/Module.bsl");
			КонецЕсли;
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульСеанса"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "SessionModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульУправляемогоПриложения"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "ManagedApplicationModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульКоманды"] Тогда
			ЭтоОбщаяКоманда = СтрНайти(Стр.ПутьКОбъекту, "/CommonCommands/");
			Если ЭтоОбщаяКоманда Тогда
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "CommandModule.bsl");
			Иначе
				Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "Commands/" + Стр.ИмяКоманды + "/CommandModule.bsl");
			КонецЕсли;
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["МодульНабораЗаписей"] Тогда
			Стр.ПутьКМодулю = СтрЗаменить(Стр.ПутьКОбъекту, Стр.ИмяФайла, "RecordSetModule.bsl");
		ИначеЕсли Стр.ИдТипаМодуля = ТипыМодулей["Неизвестно"] Тогда
			Лог.Отладка("TODO");
		Иначе
			Лог.Отладка("Неизвестный идентификатор типа модуля");
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьВGenericCoverage(КаталогРезультатов)
	
	ФайлРезультата = "/genericCoverage.xml";
	ПутиКИсходникам = ПутьКФайлуКонфигурации;
	Если СтрНачинаетсяС(ПутьКФайлуКонфигурации, "./") Тогда
		ПутиКИсходникам = ТекущийКаталог() + Сред(ПутьКФайлуКонфигурации, 2);
	КонецЕсли;
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.ОткрытьФайл(КаталогРезультатов + ФайлРезультата);
	ЗаписьXML.ЗаписатьНачалоЭлемента("coverage");
	ЗаписьXML.ЗаписатьАтрибут("version", "1");
	
	КоличествоСтрок = 0;
	
	Для Каждого Модуль Из ДанныеПокрытия Цикл
		
		Если ПустаяСтрока(Модуль.ПутьКМодулю) Тогда
			Лог.Отладка("Не удалось определить путь к модулю " + Модуль.ИдМодуля + " с типом " + Модуль.ИдТипаМодуля);
			Продолжить;
		КонецЕсли;
		
		ЗаписьXML.ЗаписатьНачалоЭлемента("file");
		ПутьКМодулю = Модуль.ПутьКМодулю;
		ПутьКМодулю = СтрЗаменить(ПутьКМодулю, "/", "\");
		ЗаписьXML.ЗаписатьАтрибут("path", ПутьКМодулю);
		
		Для Каждого СтрокаМодуля Из Модуль.НомераСтрок Цикл
			
			ЗаписьXML.ЗаписатьНачалоЭлемента("lineToCover");
			ЗаписьXML.ЗаписатьАтрибут("lineNumber", СтрокаМодуля.Ключ);
			ЗаписьXML.ЗаписатьАтрибут("covered", "true");
			ЗаписьXML.ЗаписатьКонецЭлемента();
			
			КоличествоСтрок = КоличествоСтрок + 1;
			
		КонецЦикла;
		
		ЗаписьXML.ЗаписатьКонецЭлемента();
		
	КонецЦикла;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();
	
	Лог.Отладка("Количество строк в замерах = " + КоличествоСтрок);
	
КонецПроцедуры

Процедура СохранитьВlcov(КаталогРезультатов)
	
	ФайлРезультата = "/lcov.info";
	
	ПутиКИсходникам = ПутьКФайлуКонфигурации;
	Если СтрНачинаетсяС(ПутьКФайлуКонфигурации, "./") Тогда
		ПутиКИсходникам = ТекущийКаталог() + Сред(ПутьКФайлуКонфигурации, 2);
	КонецЕсли;
	
	ЗаписьТекста = Новый ЗаписьТекста(КаталогРезультатов + ФайлРезультата);
	
	Для Каждого Модуль Из ДанныеПокрытия Цикл
		
		Если ПустаяСтрока(Модуль.ПутьКМодулю) Тогда
			Лог.Отладка("Не удалось определить путь к модулю " + Модуль.ИдМодуля + " с типом " + Модуль.ИдТипаМодуля);
			Продолжить;
		КонецЕсли;
		
		СтрокаЗаписи = "";
		СтрокиДляЗаписи = Новый Массив();
		СтрокиДляЗаписи.Добавить("TN:");
		
		ПутьКМодулю = Модуль.ПутьКМодулю;
		СтрокиДляЗаписи.Добавить("SF:" + ПутьКМодулю);
		
		Для Каждого СтрокаМодуля Из Модуль.НомераСтрок Цикл
			
			Хиты = СтрокаМодуля.Значение;
			Если Не ЗначениеЗаполнено(Хиты) Тогда
				Хиты = "0";
			КонецЕсли;
			СтрокиДляЗаписи.Добавить("DA:" + Строка(СтрокаМодуля.Ключ) + "," + Хиты);
			
		КонецЦикла;
		
		СтрокиДляЗаписи.Добавить("end_of_record");
		СтрокаЗаписи = СтрСоединить(СтрокиДляЗаписи, Символы.ПС);
		ЗаписьТекста.ЗаписатьСтроку(СтрокаЗаписи);
		
	КонецЦикла;
	
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры

Процедура ПроверитьСуществованиеФайлов()
	
	Для Каждого Стр Из ДанныеПокрытия Цикл
		
		Если Не ФС.ФайлСуществует(Стр.ПутьКМодулю) Тогда
			Лог.Отладка("Файл не существует:" + Стр.ПутьКМодулю);
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

Функция ЭтоВалиднаяЗапись(ТекЗаписьЛогаJSON)
	
	Если ЕстьСвойство(ТекЗаписьЛогаJSON, "request")
		И ЕстьСвойство(ТекЗаписьЛогаJSON.request, "commandToDbgServer")
		И ЕстьСвойство(ТекЗаписьЛогаJSON.request.commandToDbgServer, "measure")
		И ЕстьСвойство(ТекЗаписьЛогаJSON.request.commandToDbgServer.measure, "moduleData") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

Функция ЕстьСвойство(Структура, ИмяСвойства)
	
	ЕстьСвойство = Ложь;
	
	Если ТипЗнч(Структура) = Тип("Структура")
		И Структура.Свойство(ИмяСвойства) Тогда
		
		ЕстьСвойство = Истина;
	КонецЕсли;
	
	Возврат ЕстьСвойство;
	
КонецФункции

