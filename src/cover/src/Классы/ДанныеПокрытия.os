Перем Результат Экспорт;


Процедура ПриСозданииОбъекта() Экспорт

	Результат = Новый Соответствие();

КонецПроцедуры	


Процедура РазобратьЛог(Лог, ДанныеКонфигурации) Экспорт

	Если НЕ ЕстьСвойство(Лог, "request") 
		ИЛИ НЕ ЕстьСвойство(Лог.request, "commandToDbgServer")
		ИЛИ НЕ ЕстьСвойство(Лог.request.commandToDbgServer, "measure") 
		ИЛИ НЕ ЕстьСвойство(Лог.request.commandToDbgServer.measure, "moduleData") Тогда
		Возврат;
	КонецЕсли;	
	
	Данные = Лог.request.commandToDbgServer.measure.moduleData;

	Для каждого Ключ Из Данные Цикл
	
		Если НЕ ЕстьСвойство(Ключ, "moduleId") Тогда
			Возврат;
		КонецЕсли;	

		ЭтоНовый = Ложь;
		Модуль = ДанныеКонфигурации.ОпределитьМодульПоId(Ключ.moduleId.objectID, Ключ.moduleId.propertyID);
		ДаннныеМодуля = Результат.Получить(Модуль);
		Если ДаннныеМодуля = Неопределено Тогда
			ЭтоНовый = Истина;
			ДаннныеМодуля = Новый Структура("Путь, Строки", "", Новый Массив);
			ДаннныеМодуля.Путь = ПутиФайловКонфигурации.ПутьКонфигуратора(Модуль);
		КонецЕсли;	
	
		СтрокиМодуля = ДаннныеМодуля.Строки;
		Если ТипЗнч(Ключ.lineInfo) = Тип("Массив") Тогда 
			
			Для Каждого ПокрытаяСтрока Из Ключ.lineInfo Цикл

				ДанныеСтроки = Новый Структура();
				ДанныеСтроки.Вставить("НомерСтроки", ПокрытаяСтрока.lineNo);
				
				СтрокиМодуля.Добавить(ДанныеСтроки);

			КонецЦикла;	
		Иначе

			ДанныеСтроки = Новый Структура();
			ДанныеСтроки.Вставить("НомерСтроки", Ключ.lineInfo.lineNo);
			СтрокиМодуля.Добавить(ДанныеСтроки);

		КонецЕсли;
		
		Если ЭтоНовый Тогда
			Результат.Вставить(Модуль, ДаннныеМодуля);
		КонецЕсли;	

	КонецЦикла;	

КонецПроцедуры	

Функция ЕстьСвойство(Структура, ИмяСвойства)

	ЕстьСвойство = Ложь;

	Если ТипЗнч(Структура) = Тип("Структура") 
		И Структура.Свойство(ИмяСвойства) Тогда

		ЕстьСвойство = Истина;
	КонецЕсли;	

	Возврат ЕстьСвойство;

КонецФункции	