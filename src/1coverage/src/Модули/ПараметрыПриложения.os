#Использовать logos

Перем ЛогПриложения;
Перем ОбщиеПараметры;

Процедура Инициализация()
	
	ОбщиеПараметры = Новый Структура();
	ОбщиеПараметры.Вставить("ВерсияПлатформы", "8.3");
	ОбщиеПараметры.Вставить("ПутьКПлатформе", "");
	ОбщиеПараметры.Вставить("ПутьКИсходникам", "");

	ИмяФайлаНастройкиПриложения = "config.json";

КонецПроцедуры

Функция ИмяПриложения() Экспорт

	Возврат "1coverage";
		
КонецФункции

Функция Версия() Экспорт

	Возврат "0.1.0";
		
КонецФункции

Функция Лог() Экспорт
	
	Если ЛогПриложения = Неопределено Тогда
		ЛогПриложения = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
	КонецЕсли;

	Возврат ЛогПриложения;

КонецФункции

Функция ИмяЛогаПриложения() Экспорт
	Возврат "oscript.app." + ИмяПриложения();
КонецФункции

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		Лог().УстановитьУровень(УровниЛога.Отладка);

	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПутьКПлатформе(ПараметрПутьКПлатформе) Экспорт

	ОбщиеПараметры.Вставить("ПутьКПлатформе", ПараметрПутьКПлатформе);
	
КонецПроцедуры

Функция Параметры() Экспорт

	Возврат ОбщиеПараметры;
	
КонецФункции

Инициализация();