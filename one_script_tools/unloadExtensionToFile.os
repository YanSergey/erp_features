#Использовать v8runner
#Использовать cmdline

Перем СЕРВЕР;
Перем СЕРВЕР_ПОРТ;
Перем БАЗА;
Перем ЭТО_ФАЙЛОВАЯ_БАЗА;
Перем ПОЛЬЗОВАТЕЛЬ;
Перем ПАРОЛЬ;
Перем ПЛАТФОРМА_ВЕРСИЯ;
Перем ИМЯ_РАСШИРЕНИЯ;
Перем ФАЙЛ_РАСШИРЕНИЯ;

Перем Конфигуратор;
Перем Лог;

Функция Инициализация()

    Парсер = Новый ПарсерАргументовКоманднойСтроки();
    Парсер.ДобавитьИменованныйПараметр("-platform");
    Парсер.ДобавитьИменованныйПараметр("-server");
    Парсер.ДобавитьИменованныйПараметр("-base");
    Парсер.ДобавитьИменованныйПараметр("-user");
    Парсер.ДобавитьИменованныйПараметр("-passw");
    Парсер.ДобавитьИменованныйПараметр("-extensionfile");
    Парсер.ДобавитьИменованныйПараметр("-extension");

    Параметры = Парсер.Разобрать(АргументыКоманднойСтроки);
    
    ПЛАТФОРМА_ВЕРСИЯ  = Параметры["-platform"];//"8.3.10.2639"; // если пустая строка, то будет взята последняя версия
    СЕРВЕР            =  Параметры["-server"];
    СЕРВЕР_ПОРТ       = 1541; // 1541 - по умолчанию
    БАЗА              = Параметры["-base"];
    ЭТО_ФАЙЛОВАЯ_БАЗА = Не ЗначениеЗаполнено(СЕРВЕР);
    ПОЛЬЗОВАТЕЛЬ      = Параметры["-user"];
    ПАРОЛЬ            = Параметры["-passw"];
    ИМЯ_РАСШИРЕНИЯ    = Параметры["-extension"];
    ФАЙЛ_РАСШИРЕНИЯ = Параметры["-extensionfile"];
    
    //ПЛАТФОРМА_ВЕРСИЯ  = "8.3.12.1685";
    //СЕРВЕР            = "devadapter";
    //СЕРВЕР_ПОРТ       = 1541; // 1541 - по умолчанию
    //БАЗА              = "custom_rkudakov_adapter_adapter";
    //ЭТО_ФАЙЛОВАЯ_БАЗА = Не ЗначениеЗаполнено(СЕРВЕР);
    //ПОЛЬЗОВАТЕЛЬ      = "Administrator";
    //ПАРОЛЬ            = "111";
    //ИМЯ_РАСШИРЕНИЯ    = "biterpExtension";
    //ФАЙЛ_РАСШИРЕНИЯ = "C:\temp\mytest\myext.cfe";

    Конфигуратор = Новый УправлениеКонфигуратором();
    Конфигуратор.УстановитьКонтекст(СтрокаСоединенияИБ(), ПОЛЬЗОВАТЕЛЬ, ПАРОЛЬ);
    Конфигуратор.ИспользоватьВерсиюПлатформы(ПЛАТФОРМА_ВЕРСИЯ);

    Лог = Логирование.ПолучитьЛог("unloadExtension");
    ЛОГ.Отладка("СЕРВЕР = " + СЕРВЕР);
    ЛОГ.Отладка("ПЛАТФОРМА_ВЕРСИЯ = " + ПЛАТФОРМА_ВЕРСИЯ);

КонецФункции

Функция ВыгрузитьРасширениеВФайл()

    Конфигуратор.ВыгрузитьРасширениеВФайл(ФАЙЛ_РАСШИРЕНИЯ, ИМЯ_РАСШИРЕНИЯ);

КонецФункции

Функция СтрокаСоединенияИБ() 
    Если ЭТО_ФАЙЛОВАЯ_БАЗА Тогда
        Возврат "/F" + БАЗА; 
    Иначе   
        Возврат "/IBConnectionString""Srvr=" + СЕРВЕР + ?(ЗначениеЗаполнено(СЕРВЕР_ПОРТ),":" + СЕРВЕР_ПОРТ,"") + ";Ref='"+ БАЗА + "'""";
    КонецЕсли;
КонецФункции

Инициализация();
Лог.Информация("Unloading extension %1 for infobase %2", ИМЯ_РАСШИРЕНИЯ, БАЗА);
ВыгрузитьРасширениеВФайл();
Лог.Информация("Sucessfuly unloaded extension %1 to file %2", ИМЯ_РАСШИРЕНИЯ, ФАЙЛ_РАСШИРЕНИЯ);