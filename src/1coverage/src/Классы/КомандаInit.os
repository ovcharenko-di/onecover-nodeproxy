#Использовать fs
#Использовать ParserFileV8i

Перем Лог;

Перем ПараметрыКоманды;

Перем СтрокаСоединенияСИБ;
Перем ХостПрокси;
Перем ПортПрокси;

Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("proxy-host", "", "хост прокси")
				.ТСтрока()
				.ВОкружении("1COVERAGE_PROXY_HOST")
				.ПоУмолчанию("localhost");
				
	Команда.Опция("proxy-port", "", "порт прокси")
				.ТСтрока()
				.ВОкружении("1COVERAGE_PROXY_PORT")
				.ПоУмолчанию("3000");

	Команда.Опция("ib-connection", "", "строка соединения с информационной базой")
				.ТСтрока()
				.ВОкружении("1COVERAGE_IB_CONNECTION 1COVERAGE_IBCONNECTION");
				
КонецПроцедуры

Процедура ПередВыполнениемКоманды(Знач Команда) Экспорт
	
	Лог = ПараметрыПриложения.Лог();

	ПараметрыКоманды = Новый Соответствие();
	ПараметрыПриложения.ДобавитьПараметрыПриложения(ПараметрыКоманды);
	ПараметрыКоманды.Вставить("ib-connection", Команда.ЗначениеОпции("ib-connection"));
	ПараметрыКоманды.Вставить("proxy-host", Команда.ЗначениеОпции("proxy-host"));
	ПараметрыКоманды.Вставить("proxy-port", Команда.ЗначениеОпции("proxy-port"));

	ПараметрыПриложения.ДополнитьПараметрамиИзФайлаНастроек("init", ПараметрыКоманды);
	ПараметрыПриложения.ДополнитьПараметрамиИзПеременныхОкружения(ПараметрыКоманды);
	
КонецПроцедуры

Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ИдИнформационнойБазы = ОпределитьИдИнформационнойБазы(СтрокаСоединенияСИБ);

	AppData = ПолучитьПеременнуюСреды("APPDATA");
	КаталогФайлаНастроек = ОбъединитьПути(AppData, "1C", "1cv8", ИдИнформационнойБазы);
	
	ЗаменитьФайлСНастройкамиОтладки(КаталогФайлаНастроек);

	Лог.Информация("Установлена http-отладка для базы, Ид " + ИдИнформационнойБазы);
	
КонецПроцедуры // ВыполнитьКоманду

Функция ОпределитьИдИнформационнойБазы(СтрокаСоединенияСИБ)

	ИдИнформационнойБазы = ОпределитьИдИнформационнойБазы_v8i(СтрокаСоединенияСИБ);

	Если Не ЗначениеЗаполнено(ИдИнформационнойБазы) Тогда
		ИдИнформационнойБазы = ОпределитьИдИнформационнойБазы_pfl(СтрокаСоединенияСИБ);
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ИдИнформационнойБазы) Тогда
		ВызватьИсключение("Не удалось определить Ид информационной базы " + СтрокаСоединенияСИБ);
	КонецЕсли;

	Возврат ИдИнформационнойБазы;

КонецФункции

Функция ОпределитьИдИнформационнойБазы_v8i(Знач СтрокаСоединенияСИБ)

	ТипИБ = Лев(СтрокаСоединенияСИБ, 2);

	Если ТипИБ = "/F" Тогда
		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
	ИначеЕсли ТипИБ = "/S" Тогда

		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
		СтрокаСоединенияСИБ = СтрЗаменить(СтрокаСоединенияСИБ, "\", ":");

	Иначе

		ВызватьИсключение("Некорректно указан тип базы в строке соединения, ожидалось /F или /S");

	КонецЕсли;

	Лог.Отладка("Поиск ИБ "+ СтрокаСоединенияСИБ + " в файле ibases.v8i");
	
	ИдИнформационнойБазы = "";
	
	Парсер = Новый ПарсерСпискаБаз;
	СписокИБ = Парсер.НайтиПоПути(СтрокаСоединенияСИБ);

	Если ТипЗнч(СписокИБ) = Тип("Структура") Тогда
		ИдИнформационнойБазы = СписокИБ.ID;
		Лог.Отладка("ИБ "+ СтрокаСоединенияСИБ + " найдена в файле ibases.v8i с Ид=" + ИдИнформационнойБазы);
	Иначе
		Лог.Отладка("ИБ "+ СтрокаСоединенияСИБ + " не найдена в файле ibases.v8i");
	КонецЕсли;

	Возврат ИдИнформационнойБазы;

КонецФункции

Функция ОпределитьИдИнформационнойБазы_pfl(Знач СтрокаСоединенияСИБ)

	ИдБазы = "";

	ТипИБ = Лев(СтрокаСоединенияСИБ, 2);

	Если ТипИБ = "/F" Тогда
		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
	ИначеЕсли ТипИБ = "/S" Тогда

		СтрокаСоединенияСИБ = Сред(СтрокаСоединенияСИБ, 3);
		ЧастиСтрокиСоединения = СтрРазделить(СтрокаСоединенияСИБ, "\");

		КоличествоЧастейСтрокиСоединенияСервер = 2;
		Если ЧастиСтрокиСоединения.Количество() = КоличествоЧастейСтрокиСоединенияСервер Тогда

			СтрокаСоединенияСИБ = ЧастиСтрокиСоединения[0] + """" + """;Ref=" + """" + """" + ЧастиСтрокиСоединения[1];

		Иначе

			ВызватьИсключение("Некорректно указана строка соединения с ИБ");

		КонецЕсли;

	Иначе

		ВызватьИсключение("Некорректно указан тип базы в строке соединения, ожидалось /F или /S");

	КонецЕсли;
	
	AppData = ПолучитьПеременнуюСреды("APPDATA");
	ИмяФайлаPFL = ОбъединитьПути(AppData, "1C", "1Cv8", "1cv8u.pfl");

	Лог.Отладка("Поиск ИБ "+ СтрокаСоединенияСИБ + " в файле " + ИмяФайлаPFL);

	Если Не ФС.ФайлСуществует(ИмяФайлаPFL) Тогда
		Лог.Отладка("Не найден файл" + ИмяФайлаPFL);
		Возврат Неопределено;
	КонецЕсли;
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяФайлаPFL);

	ТекущаяСтрока = "";
	Пока ТекущаяСтрока <> Неопределено Цикл

		ТекущаяСтрока = ЧтениеТекста.ПрочитатьСтроку();

		Если СтрНайти(ТекущаяСтрока, СтрокаСоединенияСИБ) Тогда
			
			ИдБазы = ЧтениеТекста.ПрочитатьСтроку();
			ИдБазы = СтрЗаменить(ИдБазы, "{""S"",""", "");
			ИдБазы = СтрЗаменить(ИдБазы, """},0}", "");
			ИдБазы = СтрЗаменить(ИдБазы, ",", "");
			Лог.Отладка("В файле pfl найден Ид базы = " + ИдБазы);
			Прервать; // TODO: сделать так, чтобы отладка устанавливалась для всех подходящих баз

		КонецЕсли;

	КонецЦикла;
	ЧтениеТекста.Закрыть();

	Возврат ИдБазы;

КонецФункции

Процедура ЗаменитьФайлСНастройкамиОтладки(КаталогФайлаНастроек)

	ФС.ОбеспечитьКаталог(КаталогФайлаНастроек);

	ИмяФайлаНастроек = ОбъединитьПути(КаталогФайлаНастроек, "1cv8.pfl");

	ЧтениеТекста = Новый ЧтениеТекста("./fixtures/1cv8.pfl");
	СодержимоеФайла = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();

	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_HOST%", ХостПрокси);
	СодержимоеФайла = СтрЗаменить(СодержимоеФайла, "%1COVERAGE_PROXY_PORT%", ПортПрокси);

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаНастроек);
	ЗаписьТекста.Записать(СодержимоеФайла);
	ЗаписьТекста.Закрыть();
	
КонецПроцедуры
