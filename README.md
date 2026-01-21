# DevOps Test — Контрольная работа

## Задание 1: Веб-сервер
- Установлен и настроен веб-сервер **Nginx**
- Nginx слушает порт **8080**
- Настроен endpoint `/status`, который возвращает:
  - hostname виртуальной машины
  - IP-адрес сервера
  - текущую дату и время запроса
- Логи сохраняются в кастомный каталог: `/var/log/custom_web/access.log`
- Формат лога: `IP [дата] "HTTP-запрос" код_ответа`
- Проверка работы:
  ```bash
  curl http://localhost:8080/status
  ```

## Задание 2: Анализ логов
- Создана структура проекта:
  ```
  devops-test/
  ├── scripts/
  ├── logs/
  └── README.md
  ```
- Реальные логи скопированы из `/var/log/custom_web/access.log` в `logs/access.log`
- Написан Bash-скрипт `scripts/log_analyzer.sh`, который:
  - выводит общее количество HTTP-запросов
  - выводит количество ответов с кодом **200**
  - выводит **ТОП-3 IP-адресов** по количеству запросов
- Скрипт выводит результат в **stdout**
- Пример запуска:
  ```bash
  ./scripts/log_analyzer.sh
  ```

## Задание 3: PostgreSQL и cron
- Установлена СУБД **PostgreSQL**
- Создана база данных `devops_test`
- Создана таблица:
  ```sql
  CREATE TABLE log_stats (
      id SERIAL PRIMARY KEY,
      ip INET NOT NULL,
      requests_count INT NOT NULL,
      created_at TIMESTAMP DEFAULT NOW()
  );
  ```
- Скрипт `scripts/log_analyzer.sh` модифицирован:
  - анализирует файл `logs/access.log`
  - определяет количество запросов для каждого IP-адреса
  - записывает результаты в таблицу `log_stats`
- Настроена **cron-задача**: запуск каждый час
  ```cron
  0 * * * * /home/roman/devops-test/scripts/log_analyzer.sh >/dev/null 2>&1
  ```
- Скрипт работает корректно при запуске из cron (использует абсолютные пути)
- Скрипт возвращает код выхода:
  - `0` — при успешном выполнении
  - `1` — при ошибке
```
