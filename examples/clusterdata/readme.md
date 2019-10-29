# Примеры разбора файлов кластера 1С

## Примеры разбора файла списка баз сервера 1С

- **ib-list2jsonfile.json** - поиск настроек кластера в указанном каталоге, чтение списка баз из файла настройки кластера, преобразование в структуру и вывод результатов файл JSON и в консоль
  
## Примеры разбора журнала регистрации (текстовый формат)

- **jornal-dic2jsonfile.json** - чтение словаря журнала регистрации, преобразование в структуру и вывод результатов в файл JSON
- **jornal2filter2jsonfile.json** - чтение журнала регистрации, преобразование в структуру, фильтр записей по значениям полей и вывод результатов в файл JSON
- **jornal2elastic.json** - чтение словаря журнала регистрации, преобразование в структуру и вывод результатов в Elasticsearch с использованием REST API
- **ib-jornal2elastic.json** - комплексный пример:
  - поиск настроек кластера в указанном каталоге
  - чтение списка баз и фильтрация по именам баз
  - чтение журналов регистрации баз из соответствующих каталогов
  - фильтрация событий журналов по значениям полей
  - вывод результатов в Elasticsearch с использованием REST API

### Данные для тестирования

- **srvinfo\reg_1541\1CV8Clst.lst** - файл настроек кластера серверов 1С
- **srvinfo\reg_1541\{UID}\1Cv8Log\1Cv8.lgf** - словари журнала регистрации
- **srvinfo\reg_1541\{UID}\1Cv8Log\*.lgp** - файлы журналов регистрации