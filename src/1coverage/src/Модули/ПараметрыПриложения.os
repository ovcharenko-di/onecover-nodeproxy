#Использовать logos
#Использовать fs

Перем Лог;

Перем ОбщиеПараметры;

Процедура Инициализация()
	
	ОбщиеПараметры = Новый Структура();
	ОбщиеПараметры.Вставить("v8version", "");
	ОбщиеПараметры.Вставить("v8path", "");
	ОбщиеПараметры.Вставить("tempdir", "");
	ОбщиеПараметры.Вставить("settings", "");
	
КонецПроцедуры

Функция ИмяПриложения() Экспорт
	
	Возврат "1coverage";
	
КонецФункции

Функция Версия() Экспорт
	
	Возврат "0.1.0";
	
КонецФункции

Функция Лог() Экспорт
	
	Если Лог = Неопределено Тогда
		Лог = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
	КонецЕсли;
	
	Возврат Лог;
	
КонецФункции

Функция ИмяЛогаПриложения() Экспорт
	Возврат "oscript.app." + ИмяПриложения();
КонецФункции

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		Лог().УстановитьУровень(УровниЛога.Отладка);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВерсиюПлатформы(Знач ВерсияПлатформы) Экспорт
	ОбщиеПараметры.Вставить("v8version", ВерсияПлатформы);
КонецПроцедуры

Процедура УстановитьПутьКПлатформе(Знач ПутьКПлатформе) Экспорт
	ОбщиеПараметры.Вставить("v8path", ПутьКПлатформе);
КонецПроцедуры

Процедура УстановитьКаталогВременныхФайлов(Знач КаталогВременныхФайлов) Экспорт
	ОбщиеПараметры.Вставить("tempdir", КаталогВременныхФайлов);
КонецПроцедуры

Процедура УстановитьФайлНастроек(Знач ФайлНастроек) Экспорт
	ОбщиеПараметры.Вставить("settings", ФайлНастроек);
КонецПроцедуры

Функция Параметры() Экспорт
	
	Возврат ОбщиеПараметры;
	
КонецФункции

Процедура ДобавитьПараметрыПриложения(ПараметрыКоманды) Экспорт
	
	Для Каждого ОбщийПараметр Из ОбщиеПараметры Цикл
		
		ПараметрыКоманды.Вставить(ОбщийПараметр.Ключ, ОбщийПараметр.Значение);
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ДополнитьПараметрамиИзФайлаНастроек(ИмяКоманды, ПараметрыКоманды) Экспорт
	
	ПараметрыФайлаНастроек = ПрочитатьНастройкиФайлJSON(ТекущийКаталог(), ОбщиеПараметры.settings);
	
	НастройкиКомандыИзФайла = ПараметрыФайлаНастроек.Получить(ИмяКоманды);
	Если НастройкиКомандыИзФайла <> Неопределено Тогда
		
		Для Каждого Настройка Из НастройкиКомандыИзФайла Цикл
			
			Если Не ЗначениеЗаполнено(ПараметрыКоманды[Настройка.Ключ])
				И ЗначениеЗаполнено(Настройка.Значение) Тогда
				
				Лог.Отладка("Установлен параметр из файла настроек для команды: " + Настройка.Ключ + "=" + Настройка.Значение);
				ПараметрыКоманды.Вставить(Настройка.Ключ, Настройка.Значение);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;

	НастройкиПоУмолчаниюИзФайла = ПараметрыФайлаНастроек.Получить("default");

	Если НастройкиПоУмолчаниюИзФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Настройка Из НастройкиПоУмолчаниюИзФайла Цикл
		
		Если Не ЗначениеЗаполнено(ПараметрыКоманды[Настройка.Ключ])
			И ЗначениеЗаполнено(Настройка.Значение) Тогда
			
			Лог.Отладка("Установлен параметр из файла настроек по умолчанию: " + Настройка.Ключ + "=" + Настройка.Значение);
			ПараметрыКоманды.Вставить(Настройка.Ключ, Настройка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПараметрамиИзПеременныхОкружения(ПараметрыКоманды) Экспорт

	// TODO
	
КонецПроцедуры

Функция ПрочитатьНастройкиФайлJSON(Знач ТекущийКаталогПроекта, Знач ИмяФайлаНастроек = Неопределено)

	ПутьКФайлуНастроек = ФС.ПолныйПуть(ИмяФайлаНастроек);
	
	Лог.Отладка("Чтение файла настроек: " + ПутьКФайлуНастроек);
	Если Не ФС.ФайлСуществует(ПутьКФайлуНастроек) Тогда
		Лог.Отладка("Файл настроек не найден: " + ПутьКФайлуНастроек);
		Возврат Новый Соответствие;
	КонецЕсли;
	Чтение = Новый ЧтениеТекста(ПутьКФайлуНастроек);
	JsonСтрока = Чтение.Прочитать();
	Чтение.Закрыть();
	ПарсерJSON = Новый ПарсерJSON();
	Результат = ПарсерJSON.ПрочитатьJSON(JsonСтрока);
	Возврат Результат;

КонецФункции

Инициализация();
