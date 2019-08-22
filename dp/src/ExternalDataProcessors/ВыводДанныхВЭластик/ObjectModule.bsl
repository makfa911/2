//----------------------------------------------------------
//This Source Code Form is subject to the terms of the
//Mozilla Public License, v.2.0. If a copy of the MPL
//was not distributed with this file, You can obtain one
//at http://mozilla.org/MPL/2.0/.
//----------------------------------------------------------
//Codebase: https://github.com/ArKuznetsov/yabr.1c/
//----------------------------------------------------------

Перем МенеджерОбработкиДанных; // ВнешняяОбработкаОбъект - обработка-менеджер, вызвавшая данный обработчик
Перем Идентификатор;           // Строка                 - идентификатор обработчика, заданный обработкой-менеджером
Перем ПараметрыОбработки;      // Структура              - параметры обработки
Перем РазмерПорцииОбработки;   // Число                  - количество записей, которое будет добавлено в пакет
                               //                          для отправки в индекс Elastic
Перем СохранятьОбработанныеДанные;   // Булево           - Истина - в результатах обработки будут сохранены обработанные данные
Перем СохранятьОтправленныеСтроки;   // Булево           - Истина - в результатах обработки будут сохранены отправленные строки

Перем Данные;                  // Структура              - данные для отправки в эластик 1С

Перем Эластик_Сервер;          // Строка			     - адрес сервера http-сервиса Elastic
Перем Эластик_Порт;            // Число 			     - порт сервера http-сервиса Elastic
Перем Эластик_Пользователь;    // Строка			     - имя пользователя сервиса Elastic
Перем Эластик_Пароль;          // Строка			     - пароль пользователя сервиса Elastic
Перем Эластик_Соединение;      // HTTP-соединение        - объект соединения с http-сервисом для повторного использования

Перем ШаблонЗаголовкаИндекса;  // Строка                 - шаблон для установки значения заголовка индекса при выгрузке
Перем ШаблонТипаИндекса;       // Строка                 - шаблон для установки значения типа индекса при выгрузке
Перем ШаблонИдИндекса;         // Строка                 - шаблон для установки идентификатора индекса при выгрузке

Перем БылиОшибкиОтправки;
Перем ДанныеДляОтправки;	   // Массив(Структура)      - накопленные данные для отправки в Elastic
Перем РезультатыОбработки;	   // Массив(Структура)      - результаты обработки данных


#Область ПрограммныйИнтерфейс

// Функция - признак возможности обработки, принимать входящие данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может принимать входящие данные для обработки;
//	         Ложь - обработка не принимает входящие данные;
//
Функция ПринимаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ПринимаетДанные()

// Функция - признак возможности обработки, возвращать обработанные данные
// 
// Возвращаемое значение:
//	Булево - Истина - обработка может возвращать обработанные данные;
//	         Ложь - обработка не возвращает данные;
//
Функция ВозвращаетДанные() Экспорт
	
	Возврат Истина;
	
КонецФункции // ВозвращаетДанные()

// Функция - возвращает список параметров обработки
// 
// Возвращаемое значение:
//	Структура                                - структура входящих параметров обработки
//      *Тип                    - Строка         - тип параметра
//      *Обязательный           - Булево         - Истина - параметр обязателен
//      *ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//      *Описание               - Строка         - описание параметра
//
Функция ОписаниеПараметров() Экспорт
	
	Параметры = Новый Структура();
	
	ДобавитьОписаниеПараметра(Параметры,
	                          "Эластик_Сервер",
	                          "Строка",
	                          Истина,
	                          "localhost",
	                          "Адрес сервера http-сервиса Elastic.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Эластик_Порт",
	                          "Число",
	                          Ложь,
	                          9200,
	                          "Порт сервера http-сервиса Elastic.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Эластик_Пользователь",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Имя пользователя сервиса Elastic.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "Эластик_Пароль",
	                          "Строка",
	                          ,
	                          "",
	                          "Пароль пользователя сервиса Elastic.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ШаблонЗаголовкаИндекса",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Шаблон для установки значения заголовка индекса при выгрузке.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ШаблонТипаИндекса",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Шаблон для установки значения типа индекса при выгрузке.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ШаблонИдИндекса",
	                          "Строка",
	                          Истина,
	                          "",
	                          "Шаблон для установки идентификатора индекса при выгрузке.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "РазмерПорцииОбработки",
	                          "Число",
	                          ,
	                          1,
	                          "Количество записей, которое будет добавлено в пакет
                              |для отправки в Elastic.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "СохранятьОбработанныеДанные",
	                          "Булево",
	                          ,
	                          Ложь,
	                          "Истина - в результатах обработки будут сохранены обработанные данные.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "СохранятьОтправленныеСтроки",
	                          "Булево",
	                          ,
	                          Ложь,
	                          "Истина - в результатах обработки будут сохранены отправленные строки.");
	ДобавитьОписаниеПараметра(Параметры,
	                          "ИмяФайлаЖурнала",
	                          "Строка",
	                          ,
	                          "",
	                          "Имя обрабатываемого файла журнала регистрации.");
	    
	Возврат Параметры;
	
КонецФункции // ОписаниеПараметров()

// Функция - Возвращает обработку - менеджер
// 
// Возвращаемое значение:
//	ВнешняяОбработкаОбъект - обработка-менеджер
//
Функция МенеджерОбработкиДанных() Экспорт
	
	Возврат МенеджерОбработкиДанных;
	
КонецФункции // МенеджерОбработкиДанных()

// Процедура - Устанавливает обработку - менеджер
//
// Параметры:
//	НовыйМенеджерОбработкиДанных      - ВнешняяОбработкаОбъект - обработка-менеджер
//
Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных) Экспорт
	
	МенеджерОбработкиДанных = НовыйМенеджерОбработкиДанных;
	
КонецПроцедуры // УстановитьМенеджерОбработкиДанных()

// Функция - Возвращает идентификатор обработчика
// 
// Возвращаемое значение:
//	Строка - идентификатор обработчика
//
Функция Идентификатор() Экспорт
	
	Возврат Идентификатор;
	
КонецФункции // Идентификатор()

// Процедура - Устанавливает идентификатор обработчика
//
// Параметры:
//	НовыйИдентификатор      - Строка - новый идентификатор обработчика
//
Процедура УстановитьИдентификатор(Знач НовыйИдентификатор) Экспорт
	
	Идентификатор = НовыйИдентификатор;
	
КонецПроцедуры // УстановитьИдентификатор()

// Функция - Возвращает значения параметров обработки данных
// 
// Возвращаемое значение:
//	Структура - параметры обработки данных
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	Если ПараметрыОбработки.Свойство("Эластик_Сервер") Тогда

		ОписаниеСервера = РазложитьАдресСервера(ПараметрыОбработки.Эластик_Сервер);

		Эластик_Сервер = ОписаниеСервера.Сервер;

		Если ОписаниеСервера.Свойство("Порт") Тогда
			Эластик_Порт = ОписаниеСервера.Порт;
		КонецЕсли;

	Иначе
		Эластик_Сервер = "localhost";
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Эластик_Порт) Тогда
		Эластик_Порт = 9200;
	КонецЕсли;

	Если ПараметрыОбработки.Свойство("Эластик_Пользователь") Тогда
		Эластик_Пользователь = ПараметрыОбработки.Эластик_Пользователь;
	Иначе
		Эластик_Пользователь = "";
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("Эластик_Пароль") Тогда
		Эластик_Пароль = ПараметрыОбработки.Эластик_Пароль;
	Иначе
		Эластик_Пароль = "";
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("ШаблонЗаголовкаИндекса") Тогда
		ШаблонЗаголовкаИндекса = ПараметрыОбработки.ШаблонЗаголовкаИндекса;
	Иначе
		ШаблонЗаголовкаИндекса = "";
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("ШаблонТипаИндекса") Тогда
		ШаблонТипаИндекса = ПараметрыОбработки.ШаблонТипаИндекса;
	Иначе
		ШаблонТипаИндекса = "";
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("ШаблонИдИндекса") Тогда
		ШаблонИдИндекса = ПараметрыОбработки.ШаблонИдИндекса;
	Иначе
		ШаблонИдИндекса = "";
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("РазмерПорцииОбработки") Тогда
		РазмерПорцииОбработки = ПараметрыОбработки.РазмерПорцииОбработки;
	Иначе
		РазмерПорцииОбработки = 0;
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("СохранятьОбработанныеДанные") Тогда
		СохранятьОбработанныеДанные = ПараметрыОбработки.СохранятьОбработанныеДанные;
	Иначе
		СохранятьОбработанныеДанные = Ложь;
	КонецЕсли;
	
	Если ПараметрыОбработки.Свойство("СохранятьОтправленныеСтроки") Тогда
		СохранятьОтправленныеСтроки = ПараметрыОбработки.СохранятьОтправленныеСтроки;
	Иначе
		СохранятьОтправленныеСтроки = Ложь;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрыОбработкиДанных()

// Функция - Возвращает значение параметра обработки данных
// 
// Параметры:
//	ИмяПараметра      - Строка           - имя получаемого параметра
//
// Возвращаемое значение:
//	Произвольный      - значение параметра
//
Функция ПараметрОбработкиДанных(Знач ИмяПараметра) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НЕ ПараметрыОбработки.Свойство(ИмяПараметра) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ПараметрыОбработки[ИмяПараметра];
	
КонецФункции // ПараметрОбработкиДанных()

// Процедура - Устанавливает значение параметра обработки
//
// Параметры:
//	ИмяПараметра      - Строка           - имя устанавливаемого параметра
//	Значение          - Произвольный     - новое значение параметра
//
Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение) Экспорт
	
	Если НЕ ТипЗнч(ПараметрыОбработки) = Тип("Структура") Тогда
		ПараметрыОбработки = Новый Структура();
	КонецЕсли;
	
	ПараметрыОбработки.Вставить(ИмяПараметра, Значение);

	Если ВРег(ИмяПараметра) = ВРег("Эластик_Сервер") Тогда
		Эластик_Сервер = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Эластик_Порт") Тогда
		Эластик_Порт = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Эластик_Пользователь") Тогда
		Эластик_Пользователь = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("Эластик_Пароль") Тогда
		Эластик_Пароль = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ШаблонЗаголовкаИндекса") Тогда
		ШаблонЗаголовкаИндекса = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ШаблонТипаИндекса") Тогда
		ШаблонТипаИндекса = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("ШаблонИдИндекса") Тогда
		ШаблонИдИндекса = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("РазмерПорцииОбработки") Тогда
		РазмерПорцииОбработки = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("СохранятьОбработанныеДанные") Тогда
		СохранятьОбработанныеДанные = Значение;
	ИначеЕсли ВРег(ИмяПараметра) = ВРег("СохранятьОтправленныеСтроки") Тогда
		СохранятьОтправленныеСтроки = Значение;
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // УстановитьПараметрОбработкиДанных()

// Процедура - устанавливает данные для обработки
//
// Параметры:
//	Данные      - Структура     - значения параметров обработки
//
Процедура УстановитьДанные(Знач ВходящиеДанные) Экспорт
	
	Данные = ВходящиеДанные;
	
КонецПроцедуры // УстановитьДанные()

// Процедура - выполняет обработку данных
//
Процедура ОбработатьДанные() Экспорт
	
	ДобавитьЗаписи(Данные);
	
	Если ДанныеДляОтправки.Количество() < РазмерПорцииОбработки Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоНакопленныхДанных = 0;
	 
	Если ТипЗнч(РезультатыОбработки) = Тип("Массив") Тогда
		КоличествоНакопленныхДанных = РезультатыОбработки.Количество();
	КонецЕсли;

	ОтправитьДанные();

	Для й = КоличествоНакопленныхДанных По РезультатыОбработки.ВГраница() Цикл
		ПродолжениеОбработкиДанныхВызовМенеджера(РезультатыОбработки[й]);
	КонецЦикла;
	
КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат РезультатыОбработки;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	Если ТипЗнч(РезультатыОбработки) = Тип("Массив") И РезультатыОбработки.Количество() > 0 Тогда
		
		КоличествоНакопленныхДанных = РезультатыОбработки.Количество();
	
		ОтправитьДанные();
	
		Для й = КоличествоНакопленныхДанных По РезультатыОбработки.ВГраница() Цикл
			ПродолжениеОбработкиДанныхВызовМенеджера(РезультатыОбработки[й]);
		КонецЦикла;
		
	КонецЕсли;
	
	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииОтправкиДанныхВЭластик

// Процедура - добавляет записи в массив данных для отправки в Elastic
//
// Параметры:
//	Элемент         - Массив, Структура        - добавляемый элемент(-ы)
//
Процедура ДобавитьЗаписи(Элемент)
	
	Если НЕ ТипЗнч(ДанныеДляОтправки) = Тип("Массив") Тогда
		ДанныеДляОтправки = Новый Массив();
	КонецЕсли;
	
	Если ТипЗнч(Элемент) = Тип("Массив") Тогда
		Для Каждого ТекЭлемент Из Элемент Цикл
			ДанныеДляОтправки.Добавить(ТекЭлемент);
		КонецЦикла;
	Иначе
		ДанныеДляОтправки.Добавить(Элемент);
	КонецЕсли;

КонецПроцедуры // ДобавитьЗаписи()

// Процедура - выполняет отправку данных на сервер elastic
//
// Возвращаемое значение:
//   Структура - словари данных журнала регистрации
//
Процедура ОтправитьДанные()
	
	Если НЕ ТипЗнч(ДанныеДляОтправки) = Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеДляОтправки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОтвета = "";
	ТекстОшибки = "";
	СтрокаЗапроса = "/_bulk?pretty";
	СтрокиДляОтправки = ПолучитьСтрокиДляОтправки(ДанныеДляОтправки);
	
	Соединение = ПолучитьСоединение();
	
	РезультатОбработки = ПолучитьРезультатОбработкиХТТПСервиса(Соединение,
	                                                           СтрокаЗапроса,
															   СтрокиДляОтправки,
															   ДанныеОтвета,
															   ТекстОшибки);
	
	Если НЕ ТипЗнч(РезультатыОбработки) = Тип("Массив") Тогда
		РезультатыОбработки = Новый Массив();
	КонецЕсли;
	
	ОписаниеРезультата = Новый Структура();
	Если СохранятьОбработанныеДанные Тогда
		ОписаниеРезультата.Вставить("Данные"     , ДанныеДляОтправки);
	КонецЕсли;
	Если СохранятьОтправленныеСтроки Тогда
		ОписаниеРезультата.Вставить("Строки"     , СтрокиДляОтправки);
	КонецЕсли;
	ОписаниеРезультата.Вставить("Обработано" , РезультатОбработки);
	ОписаниеРезультата.Вставить("Ответ"      , ДанныеОтвета);
	ОписаниеРезультата.Вставить("ТекстОшибки", ТекстОшибки);

	РезультатыОбработки.Добавить(ОписаниеРезультата);
	
	Если НЕ РезультатОбработки Тогда
		БылиОшибкиОтправки = Истина;
	КонецЕсли;
	
	ДанныеДляОтправки = Новый Массив();
	
КонецПроцедуры // ОтправитьДанные()

// Функция - возвращает вычисленные значения параметров шаблона в виде:
//     [<выражение параметра шаблона 1>] : <вычисленное значение параметра>
//     [<выражение параметра шаблона 2>] : <вычисленное значение параметра>
//     ...
//     [<выражение параметра шаблона N>] : <вычисленное значение параметра>
// 
// Параметры:
//     Шаблон     - Строка      - строка-шаблон для обработки вида: "... [выражение1] ... [выражениеN]..."
//     Запись     - Структура   - обрабатываемая запись
//
// Возвращаемое значение:
//   Соответствие - соответствие выражений параметров шаблона и их значений
//
Функция ВычислитьПараметрыШаблонаЗаписи(Знач Шаблон, Знач Запись)

	ПараметрыШаблона = Новый Соответствие();
	
	ПозНачала = СтрНайти(Шаблон, "["); 
	Пока ПозНачала > 0 Цикл
		Шаблон = Сред(Шаблон, ПозНачала + 1);
		ПозОкончания = СтрНайти(Шаблон, "]");
		Если ПозОкончания > 0 Тогда
			Выражение = Сред(Шаблон, 1, ПозОкончания - 1);
			Если ПараметрыШаблона.Получить(СтрШаблон("[%1]", Выражение)) = Неопределено Тогда
				ПараметрыШаблона.Вставить(СтрШаблон("[%1]", Выражение),
				                          Вычислить(СокрЛП(Сред(Шаблон, 1, ПозОкончания - 1))));
			КонецЕсли;
		КонецЕсли;
		ПозНачала = СтрНайти(Шаблон, "[");
	КонецЦикла;
	
	Возврат ПараметрыШаблона;
	 
КонецФункции // ВычислитьПараметрыШаблонаЗаписи()

// Функция - возвращает результат подстановки вычисленных значений параметров шаблона в исходный шаблон
// 
// Параметры:
//     Шаблон     - Строка      - строка-шаблон для обработки вида: "... [выражение1] ... [выражениеN]..."
//     Запись     - Структура   - обрабатываемая запись
//
// Возвращаемое значение:
//   Строка - результат подстановки вычисленных значений параметров шаблона в исходный шаблон
//
Функция СформироватьСтрокуПоШаблонуЗаписи(Знач Шаблон, Знач Запись)
	
	ПараметрыШаблона = ВычислитьПараметрыШаблонаЗаписи(Шаблон, Запись);
	
	Для Каждого ТекПараметр Из ПараметрыШаблона Цикл
		Шаблон = СтрЗаменить(Шаблон, ТекПараметр.Ключ, ТекПараметр.Значение);
	КонецЦикла;

	Возврат Шаблон;
		 
КонецФункции // СформироватьСтрокуПоШаблонуЗаписи()

// Функция - преобразует переданные записи в строку JSON для отправки в индекс Elastic
// 
// Параметры:
//     Записи     - Массив(Структура)      - записи для отправки в индекс Elastic
//
// Возвращаемое значение:
//   Строка - строка JSON для отправки в индекс Elastic
//
Функция ПолучитьСтрокиДляОтправки(Записи)
	
	МассивСтрокДляОтправки = Новый Массив();
	
	Для Каждого ТекЗапись Из Записи Цикл
		
		СтруктураЗаголовка = Новый Структура("index", Новый Структура());
		
		СтруктураЗаголовка.index.Вставить("_index",
		                                  НРег(СформироватьСтрокуПоШаблонуЗаписи(ШаблонЗаголовкаИндекса, ТекЗапись)));
		СтруктураЗаголовка.index.Вставить("_type",
		                                  СформироватьСтрокуПоШаблонуЗаписи(ШаблонТипаИндекса, ТекЗапись));
		СтруктураЗаголовка.index.Вставить("_id",
		                                  СформироватьСтрокуПоШаблонуЗаписи(ШаблонИдИндекса, ТекЗапись));
		
		СтрокаДляОтправки = ПреобразоватьЗаписьВJSON(СтруктураЗаголовка);
		СтрокаДляОтправки = СтрЗаменить(СтрокаДляОтправки, Символы.ПС, "");
		СтрокаДляОтправки = СтрЗаменить(СтрокаДляОтправки, Символы.ВК, "");
		МассивСтрокДляОтправки.Добавить(СтрокаДляОтправки);
		
		СтрокаДляОтправки = ПреобразоватьЗаписьВJSON(ТекЗапись);
		СтрокаДляОтправки = СтрЗаменить(СтрокаДляОтправки, Символы.ПС, "");
		СтрокаДляОтправки = СтрЗаменить(СтрокаДляОтправки, Символы.ВК, "");
		МассивСтрокДляОтправки.Добавить(СтрокаДляОтправки);
		
	КонецЦикла;
	
	СтрокаДляОтправки = СтрСоединить(МассивСтрокДляОтправки, Символы.ПС);
	СтрокаДляОтправки = СтрЗаменить(СтрокаДляОтправки, Символы.ВК, "") + Символы.ПС;
	
	Возврат СтрокаДляОтправки;
	
КонецФункции // ПолучитьСтрокиДляОтправки()

// Функция - преобразует переданные данные в строку JSON
// 
// Параметры:
//     СтруктураЗаписи     - Массив, Структура      - данные для преобразования
//
// Возвращаемое значение:
//   Строка - строка JSON (результат преобразования или сообщение об ошибке)
//
Функция ПреобразоватьЗаписьВJSON(СтруктураЗаписи)
	
	Запись = Новый ЗаписьJSON();
	Запись.УстановитьСтроку();
	
	НастройкиСериализации = Новый НастройкиСериализацииJSON();
	НастройкиСериализации.ВариантЗаписиДаты      = ВариантЗаписиДатыJSON.УниверсальнаяДата;
	НастройкиСериализации.ФорматСериализацииДаты = ФорматДатыJSON.ISO;
	
	Попытка
		ЗаписатьJSON(Запись, СтруктураЗаписи, НастройкиСериализации);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат СтрШаблон("{""ТекстОшибки"":""%1""}", ТекстОшибки);
	КонецПопытки;
	
	Возврат Запись.Закрыть();
	
КонецФункции // ПреобразоватьЗаписьВJSON()
	
// Функция - Получить соединение
//
// Возвращаемое значение:
//		HTTPСоединение		- Установленное соединение с http-сервисом
//
Функция ПолучитьСоединение()
	
	Если ТипЗнч(Эластик_Соединение) = Тип("HTTPСоединение") Тогда
		Возврат Эластик_Соединение;
	КонецЕсли;
	
	//Подключаем http-сервис указанный в настройках подключения к базе
	Попытка
		Эластик_Соединение = Новый HTTPСоединение(Эластик_Сервер, , Эластик_Пользователь, Эластик_Пароль);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение СтрШаблон("%1: %2", Эластик_Сервер, ТекстОшибки);
	КонецПопытки;
	
	Возврат Эластик_Соединение;
	
КонецФункции // ПолучитьСоединение()

// Функция - отправляет запрос на обработку в Elastic
// 
// Параметры:
//     Соединение                    - HTTPСоединение      - соединение с сервером Elastic
//     СтрокаЗапроса                 - Строка              - адрес API на сервере Elastic
//     ПараметрыЗапросаДляОтправки   - Строка              - строка JSON для отправки в Elastic
//     ДанныеОтвета                  - Массив, Структура   - ответ от сервера Elastic
//     ТекстОшибки                   - Строка              - текст ошибки отправки запроса
//
// Возвращаемое значение:
//   Булево                         - Истина - данные успешно обработаны;
//                                    Ложь - в противном случае 
//
Функция ПолучитьРезультатОбработкиХТТПСервиса(Соединение
	                                        , СтрокаЗапроса
	                                        , ПараметрыЗапросаДляОтправки = "{}"
	                                        , ДанныеОтвета = Неопределено
	                                        , ТекстОшибки = "") Экспорт
	
	ЗапросКСервису = Новый HTTPЗапрос(СтрокаЗапроса);
	ЗапросКСервису.Заголовки.Вставить("Content-Type", "application/x-ndjson");
	ЗапросКСервису.УстановитьТелоИзСтроки(ПараметрыЗапросаДляОтправки);
		
	ТекстОтвета = "";
		
	Попытка
		ОтветСервиса = Соединение.ОтправитьДляОбработки(ЗапросКСервису);
		ТекстОтвета = ОтветСервиса.ПолучитьТелоКакСтроку();
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
		
	Если НЕ Лев(ОтветСервиса.КодСостояния, 1) = "2" Тогда
		ТекстОшибки = СокрЛП(ОтветСервиса.КодСостояния) + ": <" + ТекстОтвета + ">";
		Возврат Ложь;
	КонецЕсли;
	
	Если ПустаяСтрока(ТекстОтвета) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ЧтениеДанныхОтвета = Новый ЧтениеJSON();
	ЧтениеДанныхОтвета.УстановитьСтроку(ТекстОтвета);
		
	СвойстваСоЗначениемДата = Новый Массив();
		
	Попытка
		ДанныеОтвета = ПрочитатьJSON(ЧтениеДанныхОтвета, Ложь, СвойстваСоЗначениемДата, ФорматДатыJSON.ISO);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции // ПолучитьРезультатОбработкиХТТПСервиса()

#КонецОбласти // ПроцедурыИФункцииОтправкиДанныхВЭластик

#Область СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

// Процедура - выполняет действия обработки элемента данных
// и оповещает обработку-менеджер о продолжении обработки элемента
//
//	Параметры:
//		Элемент    - Произвольный     - Элемент данных для продолжения обработки
//
Процедура ПродолжениеОбработкиДанныхВызовМенеджера(Элемент)
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ПродолжениеОбработкиДанных(Элемент, Идентификатор);
	
КонецПроцедуры // ПродолжениеОбработкиДанныхВызовМенеджера()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанныхВызовМенеджера()
	
	Если МенеджерОбработкиДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбработкиДанных.ЗавершениеОбработкиДанных(Идентификатор);
	
КонецПроцедуры // ЗавершениеОбработкиДанныхВызовМенеджера()

#КонецОбласти // СлужебныеПроцедурыВызоваМенеджераОбработкиДанных

#Область СлужебныеПроцедурыИФункции

// Функция - возвращает описание параметра обработки
// 
// Параметры:
//     ОписаниеПараметров     - Структура      - структура описаний параметров
//     Параметр               - Строка         - имя параметра
//     Тип                    - Строка         - список возможных типов параметра
//     Обязательный           - Булево         - Истина - параметр обязателен
//     ЗначениеПоУмолчанию    - Произвольный   - значение параметра по умолчанию
//     Описание               - Строка         - описание параметра
//
Процедура ДобавитьОписаниеПараметра(ОписаниеПараметров
	                              , Параметр
	                              , Тип
	                              , Обязательный = Ложь
	                              , ЗначениеПоУмолчанию = Неопределено
	                              , Описание = "")
	
	Если НЕ ТипЗнч(ОписаниеПараметров) = Тип("Структура") Тогда
		ОписаниеПараметров = Новый Структура();
	КонецЕсли;
	
	ОписаниеПараметра = Новый Структура();
	ОписаниеПараметра.Вставить("Тип"                , Тип);
	ОписаниеПараметра.Вставить("Обязательный"       , Обязательный);
	ОписаниеПараметра.Вставить("ЗначениеПоУмолчанию", ЗначениеПоУмолчанию);
	ОписаниеПараметра.Вставить("Описание"           , Описание);
	
	ОписаниеПараметров.Вставить(Параметр, ОписаниеПараметра);
	
КонецПроцедуры // ДобавитьОписаниеПараметра()

// Функция - возвращает версию обработчика
// 
// Возвращаемое значение:
// 	Строка - версия обработчика
//
Функция Версия() Экспорт
	
	//@skip-warning
	Возврат ЭтотОбъект.ПолучитьМакет("ВерсияОбработки").ПолучитьТекст();
	
КонецФункции // Версия()

// Функция - раскладывает строку адреса сервера на протокол, сервер, порт
// 
// Параметры:
//     СтрокаАдреса        - Строка       - адрес сервера
//
// Возвращаемое значение:
//   Структура             - результат разбора
//       * Протокол        - Строка       - наименование протокола (http, https)
//       * Сервер          - Строка       - адрес/имя сервера
//       * Порт            - Число        - номер порта (если указан)
//
Функция РазложитьАдресСервера(Знач СтрокаАдреса)

	ЧастиАдреса = СтрРазделить(СтрокаАдреса, ":");

	Результат = Новый Структура();

	КоличествоЭлементов1 = 1;
	КоличествоЭлементов2 = 2;
	КоличествоЭлементов3 = 3;

	Если ЧастиАдреса.Количество() = КоличествоЭлементов1 Тогда
		Результат.Вставить("Сервер", ЧастиАдреса[0]);
	ИначеЕсли ЧастиАдреса.Количество() = КоличествоЭлементов2 Тогда
		Если Лев(ЧастиАдреса[1], 2) = "//" Тогда
			Результат.Вставить("Протокол", ЧастиАдреса[0]);
			Результат.Вставить("Сервер", Сред(ЧастиАдреса[1], 3));
		Иначе
			Результат.Вставить("Сервер", ЧастиАдреса[0]);
			Результат.Вставить("Порт", Число(ЧастиАдреса[1]));
		КонецЕсли;
	ИначеЕсли ЧастиАдреса.Количество() = КоличествоЭлементов3 Тогда
		Результат.Вставить("Протокол", ЧастиАдреса[0]);
		Результат.Вставить("Сервер", Сред(ЧастиАдреса[1], 3));
		Результат.Вставить("Порт", Число(ЧастиАдреса[2]));
	Иначе
		ВызватьИсключение СтрШаблон("Некорректно указан адрес сервера %1", СтрокаАдреса);
	КонецЕсли;

	Возврат Результат;

КонецФункции // РазложитьАдресСервера()

#КонецОбласти // СлужебныеПроцедурыИФункции()
