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
Перем УровеньЭлементов;        // Число                  - номер уровня элементов в структуре данных,
                               //                          которые будут прочитаны и обработаны
Перем Данные;                  // Структура              - результаты чтения скобочного формата 1С
Перем НакопленныеДанные;	   // Массив(Структура)      - результаты обработки данных
Перем КоличествоСтрок;         // Число                  - количество строк в обрабатываемой таблице
Перем БуферЗаписи;             // Структура              - буфер записи отчета по версиям

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
	                          "УровеньЭлементов",
	                          "Число",
	                          ,
	                          4,
	                          "Номер уровня элементов в структуре данных, которые будут прочитаны и обработаны.");
	    
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

// Функция - Возвращает значения параметров обработки
// 
// Возвращаемое значение:
//	Структура - параметры обработки
//
Функция ПараметрыОбработкиДанных() Экспорт
	
	Возврат ПараметрыОбработки;
	
КонецФункции // ПараметрыОбработкиДанных()

// Процедура - Устанавливает значения параметров обработки данных
//
// Параметры:
//	НовыеПараметры      - Структура     - значения параметров обработки
//
Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры) Экспорт
	
	ПараметрыОбработки = НовыеПараметры;
	
	Если ПараметрыОбработки.Свойство("УровеньЭлементов") Тогда
		УровеньЭлементов = ПараметрыОбработки.УровеньЭлементов;
	Иначе
		УровеньЭлементов = 4;
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

	Если ВРег(ИмяПараметра) = ВРег("УровеньЭлементов") Тогда
		УровеньЭлементов = Значение;
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
	
	Если НЕ ДобавитьЗапись(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	ПродолжениеОбработкиДанныхВызовМенеджера(НакопленныеДанные[НакопленныеДанные.ВГраница()]);
	
КонецПроцедуры // ОбработатьДанные()

// Функция - возвращает текущие результаты обработки
//
// Возвращаемое значение:
//	Произвольный     - результаты обработки данных
//
Функция РезультатОбработки() Экспорт
	
	Возврат НакопленныеДанные;
	
КонецФункции // РезультатОбработки()

// Процедура - выполняет действия при окончании обработки данных
// и оповещает обработку-менеджер о завершении обработки данных
//
Процедура ЗавершениеОбработкиДанных() Экспорт
	
	// Код при завершении обработки данных
	ЗавершениеОбработкиДанныхВызовМенеджера();
	
КонецПроцедуры // ЗавершениеОбработкиДанных()

#КонецОбласти // ПрограммныйИнтерфейс

#Область ОбработкаДанных

// Процедура - проверяет, что элемент является записью ИБ файла настроек кластера
// и добавляет его в список информационных баз
//
// Параметры:
//	Элемент         - Структура       проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
Функция ДобавитьЗапись(Элемент)
	
	Если НЕ ТипЗнч(НакопленныеДанные) = Тип("Массив") Тогда
		НакопленныеДанные = Новый Массив();
	КонецЕсли;
	
	Если НЕ ЭтоЯчейкаТаблицы(Элемент) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если КоличествоСтрок = Неопределено Тогда
		КоличествоСтрок = КоличествоСтрокВТаблице(Элемент);
	КонецЕсли;
	
	ОписаниеЯчейки = ПолучитьОписаниеЯчейки(Элемент);
	
	ЗначениеЯчейки = ОписаниеЯчейки.Значение;
	
	ЗаписьДляДобавления = Неопределено;
	
	Если СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Версия:") Тогда
		Если ТипЗнч(БуферЗаписи) = Тип("Структура") И БуферЗаписи.Количество() > 1 Тогда
			БуферЗаписи.Удалить("ТекущееПоле");
			ЗаписьДляДобавления = БуферЗаписи;
		КонецЕсли;
		БуферЗаписи = Новый Структура();
		БуферЗаписи.Вставить("ТекущееПоле", "Номер");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Пользователь:") Тогда
		БуферЗаписи.Вставить("ТекущееПоле", "Автор");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Дата создания:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Дата");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Время создания:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Время");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Комментарий:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Комментарий");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Изменены:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Изменены");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Добавлены:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Добавлены");
	ИначеЕсли СтрокаНачиснаетсяСВнутр(ЗначениеЯчейки, "Удалены:") Тогда
 		БуферЗаписи.Вставить("ТекущееПоле", "Удалены");
	Иначе
		Если НЕ (ТипЗнч(БуферЗаписи) = Тип("Структура")
		       И БуферЗаписи.Свойство("ТекущееПоле")
		       И ЗначениеЗаполнено(БуферЗаписи.ТекущееПоле)) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если БуферЗаписи.ТекущееПоле = "Изменены" 
		 ИЛИ БуферЗаписи.ТекущееПоле = "Добавлены"
		 ИЛИ БуферЗаписи.ТекущееПоле = "Удалены" Тогда
			
			Если НЕ БуферЗаписи.Свойство(БуферЗаписи.ТекущееПоле) Тогда
				БуферЗаписи.Вставить(БуферЗаписи.ТекущееПоле, Новый Массив());
			КонецЕсли;
			БуферЗаписи[БуферЗаписи.ТекущееПоле].Добавить(ЗначениеЯчейки);
			
		Иначе
			БуферЗаписи.Вставить(БуферЗаписи.ТекущееПоле, ЗначениеЯчейки);
		КонецЕсли;
		
	КонецЕсли;
	
	НомерКолонкиЗначения = 2;
	
	Если ТипЗнч(ЗаписьДляДобавления) = Тип("Структура") Тогда
		НакопленныеДанные.Добавить(ЗаписьДляДобавления);
		Возврат Истина;
	ИначеЕсли ОписаниеЯчейки.Строка = КоличествоСтрок И ОписаниеЯчейки.Колонка = НомерКолонкиЗначения Тогда
		БуферЗаписи.Удалить("ТекущееПоле");
		НакопленныеДанные.Добавить(БуферЗаписи);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
		
КонецФункции // ДобавитьЗапись()

// Функция - проверяет, что элемент является ячейкой таблицы MXL
//
// Параметры:
//	Элемент         - Структура       проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
// Возвращаемое значение:
//	Булево          - Истина - переданный элемент является ячейкой таблицы MXL;
//	                  Ложь - в противном случае
//
Функция ЭтоЯчейкаТаблицы(Элемент)
	
	Если НЕ ТипЗнч(Элемент) = Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;

	Если НЕ Элемент.Уровень = УровеньЭлементов Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Элемент.Значения.ВГраница() = 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции // ЭтоЯчейкаТаблицы()

// Функция - получает описание ячейки таблицы MXL
//
// Параметры:
//	Элемент            - Структура                  - проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
// Возвращаемое значение:
//	Структура                                       - проверяемый элемент
//		*Строка              - Число                     - номер строки ячейки
//		*Колонка             - Число                     - номер колонки ячейки
//		*Значение            - Строка, Число             - значение ячейки
//
Функция ПолучитьОписаниеЯчейки(Элемент)
	
	Если НЕ ЭтоЯчейкаТаблицы(Элемент) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначенияКонтейнераУровня1 = Элемент.Родитель.Родитель.Родитель.Значения;
	КонтейнерЯчеекУровня2 = Элемент.Родитель.Родитель;
	 
	ИндексКолонки = ЗначенияКонтейнераУровня1[КонтейнерЯчеекУровня2.Индекс - 1];
	
	Если НЕ ТипЗнч(ИндексКолонки) = Тип("Строка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексКолонки = ОбработатьКавычкиВСтроке(ИндексКолонки);
	
	Если ПустаяСтрока(ИндексКолонки) Тогда
		НомерКолонки = 0;
	Иначе
		НомерКолонки = Число(ИндексКолонки) + 1;
	КонецЕсли;

	ИндексСтроки = Неопределено;
	
	СдвигИндексаНач = 4;
	СдвигИндекса1 = 1;
	СдвигИндекса2 = 2;
	СдвигИндекса3 = 3;
	
	ВремИндекс = КонтейнерЯчеекУровня2.Индекс - СдвигИндексаНач;
	
	Пока ВремИндекс > 0 Цикл
		Если ТипЗнч(ЗначенияКонтейнераУровня1[ВремИндекс]) = Тип("Строка")
		   И ТипЗнч(ЗначенияКонтейнераУровня1[ВремИндекс + СдвигИндекса1]) = Тип("Строка") 
		   И ТипЗнч(ЗначенияКонтейнераУровня1[ВремИндекс + СдвигИндекса2]) = Тип("Строка") 
		   И ТипЗнч(ЗначенияКонтейнераУровня1[ВремИндекс + СдвигИндекса3]) = Тип("Строка") Тогда
			ИндексСтроки = ЗначенияКонтейнераУровня1[ВремИндекс];
			Прервать;
		КонецЕсли;
		
		ВремИндекс = ВремИндекс - 1;
		
	КонецЦикла;
	
	Если НЕ ТипЗнч(ИндексСтроки) = Тип("Строка") Тогда
		Возврат Неопределено;
	КонецЕсли;

	ИндексСтроки = ОбработатьКавычкиВСтроке(ИндексСтроки);
	
	Если ПустаяСтрока(ИндексСтроки) Тогда
		НомерСтроки = 0;
	Иначе
		НомерСтроки = Число(ИндексСтроки) + 1;
	КонецЕсли;

	Если ИндексСтроки = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ЗначениеЯчейки = ОбработатьКавычкиВСтроке(Элемент.Значения[1]);
	
	Возврат Новый Структура("Строка, Колонка, Значение", НомерСтроки, НомерКолонки, ЗначениеЯчейки);
	
КонецФункции // ПолучитьОписаниеЯчейки()

// Функция - получает количество строк в таблице MXL
//
// Параметры:
//	Элемент            - Структура                  - проверяемый элемент
//		*Родитель            - Структура                 - ссылка на элемент-родитель
//		*Уровень             - Число                     - уровень иерархии элемента
//		*Индекс              - Число                     - индекс элемента в массиве значений родителя
//		*НомераСтрок         - Соответсвие(Число)        - массив номеров строк из которых был прочитан элемент и его дочерние элементы
//		*НачСтрока           - Число                     - номер первой строки из которой был прочитан элемент и его дочерние элементы
//		*КонСтрока           - Число                     - номер последней строки из которой был прочитан элемент и его дочерние элементы
//		*Значения            - Массив(Структура)         - массив дочерних элементов
//
// Возвращаемое значение:
//	Число              - количество строк в таблице MXL
//
Функция КоличествоСтрокВТаблице(Элемент)
	
	Если НЕ ТипЗнч(Элемент) = Тип("Структура") Тогда
		Возврат Ложь;
	КонецЕсли;

	ИндексКоличестваСтрок = 15;
	
	КорневойЭлемент = Элемент;
	Пока КорневойЭлемент.Уровень > 1 Цикл
		КорневойЭлемент = КорневойЭлемент.Родитель;
	КонецЦикла;
	
	КоличествоСтрок = КорневойЭлемент.Значения[ИндексКоличестваСтрок];
	
	Возврат Число(КоличествоСтрок);
	 
КонецФункции // КоличествоСтрокВТаблице()

#КонецОбласти // ОбработкаДанных

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

// Функция - удаляет начальные, конечные и экранированные кавычки из строки
//
// Параметры:
//  ПарамСтрока	 - Строка - строка для обработки
// 
// Возвращаемое значение:
//   Строка - результирующая строка
//
Функция ОбработатьКавычкиВСтроке(Знач ПарамСтрока)
	
	ПарамСтрока = СтрЗаменить(ПарамСтрока, """""", """");
	
	Если Лев(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 2);
	КонецЕсли;
	
	Если Прав(ПарамСтрока, 1) = """" Тогда
		ПарамСтрока = Сред(ПарамСтрока, 1, СтрДлина(ПарамСтрока) - 1);
	КонецЕсли;
	
	Возврат СокрЛП(ПарамСтрока);
	
КонецФункции // ОбработатьКавычкиВСтроке()

// Функция проверяет что переданная строка начинается с указанной подстроки
//
//	Параметры: 
//		Строка            - Строка   - строка для проверки 
//		Подстрока         - Строка   - проверяемое начало строки
//		УчитыватьРегистр  - Булево   - Истина - проверка выполняется с учетом регистра;
//                                     Ложь - без учета регистра
//
//	Возвращаемое значение:
//		Булево   - Истина - строка начинается с указанной подстроки;
//                 Ложь - в противном случае
//
Функция СтрокаНачиснаетсяСВнутр(Строка, Подстрока = "", УчитыватьРегистр = Ложь)

	Если НЕ ЗначениеЗаполнено(Подстрока) Тогда
		Возврат Истина;
	КонецЕсли;

	Если УчитыватьРегистр Тогда
		Возврат Лев(Строка, СтрДлина(Подстрока)) = Подстрока;
	Иначе
		Возврат ВРег(Лев(Строка, СтрДлина(Подстрока))) = ВРег(Подстрока);
	КонецЕсли;

КонецФункции // СтрокаНачиснаетсяСВнутр()

// Функция - возвращает версию обработчика
// 
// Возвращаемое значение:
// 	Строка - версия обработчика
//
Функция Версия() Экспорт
	
	//@skip-warning
	Возврат ЭтотОбъект.ПолучитьМакет("ВерсияОбработки").ПолучитьТекст();
	
КонецФункции // Версия()

#КонецОбласти // СлужебныеПроцедурыИФункции
