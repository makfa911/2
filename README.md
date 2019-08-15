# Yet another brace reader (1C): Чтение "скобкофайлов" 1С (yabr.1c)
Набор обработок для чтения скобочных файлов 1С.

## Общие сведения
- Чтение и обработка данных выполняется последовательно (построчно)
- Это эксперимент по реализации конвейерной обработки данных (pipeline), т.е. каждая порция данных, полученная в текущей обработке передается в указанный(-ные) в настройках обработчик(-и) для последующе обработки
- Настройки описываются в формате JSON (см. [Файл настроек](./readme.md))
- разработка ведется в формате EDT

## Обрабатываемые форматы
- Журнал регистрации 1С (LGP) и словарь журнала регистрации (LGF)
- Настройки информационных баз из файла настроек кластера 1С (1CV8Clst.lst)
- Список версий хранилища из отчета по версиям хранилища (MXL)
- Результаты замера производительности (PFF)

## Управляющие обработки

### МенеджерОбработкиДанных.epf
Управляющая обработка-менеджер, читает настройки, запускает и управляет обработкой данных.

### yabr.epf
Обработка для интерактивного указания файла настроек и запуска обработки данных.

## Стандартный программный интерфейс обработки

**Функция ПринимаетДанные()** - признак возможности обработки, принимать входящие данные

**Функция ВозвращаетДанные()** - признак возможности обработки, возвращать обработанные данные

**Функция ОписаниеПараметров()** - возвращает структуру с описанием параметров обработки

**Функция МенеджерОбработкиДанных()** - возвращает ссылку на вызывающую/управляющую обработку - менеджер обработки данных

**Процедура УстановитьМенеджерОбработкиДанных(Знач НовыйМенеджерОбработкиДанных)** - устанавливает ссылку на вызывающую/управляющую обработку - менеджер обработки данных
	
**Функция Идентификатор()** - возвращает идентификатор обработки, установленный при инициализации в менеджере обработки данных

**Процедура УстановитьИдентификатор(Знач НовыйИдентификатор)** - устанавливает идентификатор обработки, вызывается при инициализации в менеджере обработки данных
	
**Функция ПараметрыОбработкиДанных()** - возвращает значения параметров обработки данных

**Процедура УстановитьПараметрыОбработкиДанных(Знач НовыеПараметры)** - устанавливает значения параметров обработки данных

**Функция ПараметрОбработкиДанных(Знач ИмяПараметра)** - возвращает значение указанного параметра обработки данных

**Процедура УстановитьПараметрОбработкиДанных(Знач ИмяПараметра, Знач Значение)** - устанавливает значение указанного параметра обработки

**Процедура УстановитьДанные(Знач ВходящиеДанные)** - устанавливает данные для обработки

**Процедура ОбработатьДанные()** - выполняет обработку данных

**Функция РезультатОбработки()** - возвращает результаты обработки данных

**Процедура ЗавершениеОбработкиДанных()** - выполняет действия при окончании обработки данных и оповещает обработку-менеджер о завершении обработки данных

## Обработчики данных

### ЧтениеКаталога.epf
Читает список файлов из указанного каталога по указанной маске и передает для дальнейшей обработки по одному.

### ЧтениеСкобкоФайла.epf
Читает скобочный файл в иерархию структур и массивов:
- чтение выполняется последовательно по строкам
- ошибки формата файла не проверяются и игнорируются, что сможет прочитать. то и получится
- элементы простых типов (число/строка) записываются в массив текущего уровня как есть
- элементы - массивы (ограниченные "{...}") "оборачиваются" в структуру вида:
```
    |-> Элемент
    |      |- Родитель    - родительский элемент (Неопределено - для корневого элемента)
    |______|________|
    |      |- Уровень     - уровень элемента в иерархии (0 - корневой элемент)
    |      |- Индекс      - индекс элемента в родительском элементе
    |      |- НомераСтрок - соответствие с номерами строк исходного файла, на основании которых создан текущий и подчиненные элементы
    |      |- Значения    - массив дочерних элементов
    |_______________|
```
- Для закрывающихся скобок ("}") выполняется обратный вызов МенеджерОбработкиДанных.ПродолжениеОбработкиДанных (МенеджерОбработкиДанных.epf) для передачи прочитанных данных на дальнейшую обработку
 
### ЧтениеЖР.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает каждый элемент данных как запись текстового журнала регистрации.

### ЧтениеСловаряЖР.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает каждый элемент данных как запись словаря текстового журнала регистрации.

### ЧтениеСпискаИБ.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает элементы данных как запись настройки информационной базы в файле настроек кластера 1С.

### ЧтениеЖР.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает каждый элемент данных как запись текстового журнала регистрации.

### ЧтениеОтчетаПоВерсиямХранилища.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает как элементы данных табличного документа (MXL) с отчетом по версиям хранилища 1С.

### ЧтениеЗамераПроизводительности.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает каждый элемент данных как запись замера производительности 1С (PFF).

### ЧтениеЖР.epf
Принимает на вход данные в том виде как их возвращает обработка чтения "скобкофайлов" и обрабатывает каждый элемент данных как запись текстового журнала регистрации.

### ВыводДанныхВКонсоль.epf
Пример обработки вывода данных, любые входящие данные преобразует в формат JSON и выводит в панель сообщений.

### ВыводДанныхВФайлJSON.epf
Пример обработки вывода данных, любые входящие данные преобразует в формат JSON и выводит в указанный файл.

### ВыводДанныхВЭластик.epf
Пример обработки вывода данных, любые входящие данные преобразует в формат JSON и отправляет в индекс Elastic.
