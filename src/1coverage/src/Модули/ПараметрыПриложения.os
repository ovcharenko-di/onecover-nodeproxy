#Использовать logos

Перем Лог;

Перем ОбщиеПараметры;

Процедура Инициализация()
	
	ОбщиеПараметры = Новый Структура();
	ОбщиеПараметры.Вставить("v8version", "");
	ОбщиеПараметры.Вставить("v8path", "");
	ОбщиеПараметры.Вставить("tempdir", "");
	
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

Функция Параметры() Экспорт
	
	Возврат ОбщиеПараметры;
	
КонецФункции

Процедура ДобавитьПараметрыПриложения(ПараметрыКоманды) Экспорт
	
	Для Каждого ОбщийПараметр Из ОбщиеПараметры Цикл
		
		ПараметрыКоманды.Вставить(ОбщийПараметр.Ключ, ОбщийПараметр.Значение);
		
	КонецЦикла;
	
КонецПроцедуры


Процедура ДополнитьПараметрамиИзФайлаНастроек(ИмяКоманды, ПараметрыКоманды) Экспорт
	
	ПараметрыФайлаНастроек = ПрочитатьНастройкиФайлJSON(".", "1coverage.json");
	
	НастройкиКомандыИзФайла = ПараметрыФайлаНастроек.Получить(ИмяКоманды);
	Если НастройкиКомандыИзФайла <> Неопределено Тогда
		
		Для Каждого Настройка Из НастройкиКомандыИзФайла Цикл
			
			Если Не ЗначениеЗаполнено(ПараметрыКоманды[Настройка.Ключ]) Тогда
				
				ПараметрыКоманды.Вставить(Настройка.Ключ, Настройка.Значение);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	НастройкиКомандыИзФайла = ПараметрыФайлаНастроек.Получить("default");
	
	Для Каждого Настройка Из НастройкиКомандыИзФайла Цикл
		
		Если Не ЗначениеЗаполнено(ПараметрыКоманды[Настройка.Ключ]) Тогда
			
			ПараметрыКоманды.Вставить(Настройка.Ключ, Настройка.Значение);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПараметрамиИзПеременныхОкружения(ПараметрыКоманды) Экспорт
	
КонецПроцедуры

Функция ПрочитатьНастройкиФайлJSON(Знач ТекущийКаталогПроекта, Знач ПутьКФайлу = Неопределено)
	
	Если ПутьКФайлу = Неопределено
		Или Не ЗначениеЗаполнено(ПутьКФайлу) Тогда
		ПутьКФайлу = ОбъединитьПути(ТекущийКаталогПроекта, "1coverage.json");
	КонецЕсли;
	Лог.Отладка(ПутьКФайлу);
	
	Возврат ПрочитатьФайлJSON(ПутьКФайлу);
КонецФункции

Функция ПрочитатьФайлJSON(ИмяФайла)
	
	Лог.Отладка("Чтение файла настроек " + ИмяФайла);
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если Не ФайлСуществующий.Существует() Тогда
		Лог.Отладка("Файл настроек не найден: " + ИмяФайла);
		Возврат Новый Соответствие;
	КонецЕсли;
	Чтение = Новый ЧтениеТекста(ИмяФайла);
	JsonСтрока = Чтение.Прочитать();
	Чтение.Закрыть();
	ПарсерJSON = Новый ПарсерJSON();
	Результат = ПарсерJSON.ПрочитатьJSON(JsonСтрока);
	Возврат Результат;
	
КонецФункции

Инициализация();